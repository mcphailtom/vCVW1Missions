-- BASE:TraceClass("COMMANDER")
-- BASE:TraceClass("AIRWING")
-- BASE:TraceClass("SQUADRON")
-- AIRBASE:FindByName("Nellis"):MarkParkingSpots(104, true)
local debug = false
local flightmessages = false
local flightlog = true

---
-- Helper Functions
---

-- _WaypointDebugMessage to print out the current waypoint of a flightgroup. Debugging function only
function _WaypointDebugMessage(Flightgroup)
    local flightgroup = Flightgroup

    SCHEDULER:New(flightgroup, function()
        local waypoints = flightgroup:GetWaypoints()
        local airwing = flightgroup:GetAirwing()
        local squadron = flightgroup:GetSquadron()

        local wptext = string.format("%s - %s - %s waypoints: \n", airwing:GetName(), squadron:GetName(),
            flightgroup:GetCallsignName(true, true))
        for i, waypoint in ipairs(waypoints) do
            wptext = wptext ..
                string.format("   wp %d: uid: %d co-ord: %s\n", i, waypoint.uid, waypoint.coordinate:ToStringLLDDM())
        end

        local cwp = flightgroup:GetWaypointCurrent()
        wptext = wptext .. string.format("   current wp uid: %d co-ord: %s\n", cwp.uid, cwp.coordinate:ToStringLLDDM())

        local nwp = flightgroup:GetWaypointNext()
        wptext = wptext .. string.format("   next wp uid: %d co-ord: %s\n", nwp.uid, nwp.coordinate:ToStringLLDDM())

        local fuelstate = flightgroup:GetFuelMin()
        wptext = wptext .. string.format("   fuelstate: %.2f\n", fuelstate)

        MESSAGE:New(wptext, 20):ToBlue():ToLog()
    end, {}, 5, 45)
end

-- _NewSupportMission creates AWACS or TANKER support missions from a specification in the missionmanager.
function _NewSupportMission(Commander, MissionManager, MissionType, MissionID)
    local commander = Commander
    local missionmanager = MissionManager
    local mtype = MissionType
    local mid = MissionID
    local misparams -- params for the mission to be executed

    -- Look for a mission ID in the mission manager to use for the AWACS mission
    for misid, misspec in pairs(missionmanager.missions[mtype]) do
        if misid == mid then
            misparams = misspec
            break
        end
    end

    if misparams == nil then
        if debug then
            MESSAGE:New(
                string.format(
                    "Failed to find a matching mission spec to assign a new mission - missiontype: %s mid: %s.\n", mtype,
                    mid),
                30)
                :ToBlue():ToLog()
        end
        return
    end

    local supportMission
    if mtype == AUFTRAG.Type.AWACS then
        supportMission = AUFTRAG:NewAWACS(misparams.zone:GetCoordinate(), misparams.orbitAltitude, misparams.orbitSpeed,
            misparams.orbitTrack, misparams.legLength)
    elseif mtype == AUFTRAG.Type.TANKER then
        supportMission = AUFTRAG:NewTANKER(misparams.zone:GetCoordinate(), misparams.orbitAltitude, misparams.orbitSpeed,
            misparams.orbitTrack, misparams.legLength, misparams.refuelType)
    end


    supportMission:SetMissionSpeed(misparams.missionSpeed)
    supportMission:SetName(misparams.name)
    supportMission.mid = mid

    if misparams.firstAssetLaunch then
        supportMission:SetTeleport(true)
        missionmanager.missions[mtype][mid].firstAssetLaunch = false
    end

    commander:AddMission(supportMission)
end

-- SupportFlightOnMission is the handler used by both the TANKER and AWACS Airwings to manage the mission progress.
function _SupportFlightOnMission(From, Event, To, Flightgroup, Mission, MissionManager, Commander)
    local flightgroup = Flightgroup
    local group = flightgroup:GetGroup()
    local airwing = flightgroup:GetAirwing()
    local squadron = flightgroup:GetSquadron()

    local mission = Mission
    local mtype = mission:GetType()
    local mid = mission.mid

    local missionmanager = MissionManager
    local commander = Commander

    local fuellowthreshold = missionmanager.missions[mtype][mid].fuellowthreshold
    local fuelcritthreshold = missionmanager.missions[mtype][mid].fuelcritthreshold

    -- Set the right callsign for the flightgroups
    flightgroup:SetDefaultCallsign(missionmanager.missions[mtype][mid].callsignName,
        missionmanager.missions[mtype][mid].callsignNumber)

    -- Set the fuel thresholds for the flightgroup
    flightgroup:SetFuelLowThreshold(fuellowthreshold)
    flightgroup:SetFuelLowRTB(false)
    flightgroup:SetFuelCriticalThreshold(fuelcritthreshold)
    flightgroup:SetFuelCriticalRTB(true)

    -- Debug Flight Progress
    if debug then
        _WaypointDebugMessage(flightgroup)
    end

    -- Manage the active mission
    missionmanager.missions[mtype][mid].mission:enqueue(mission)
    if debug then
        MESSAGE:New(
            string.format("%s - %s - %s adding mission to the squadron queue %s.\n",
                airwing:GetName(), squadron:GetName(), flightgroup:GetCallsignName(true, true), mission:GetName()),
            30)
            :ToBlue():ToLog()
    end

    -- Add a new mission on fuel low
    function flightgroup:OnAfterFuelLow(From, Event, To)
        _NewSupportMission(commander, missionmanager, mtype, mid)

        if debug or flightmessages or flightlog then
            local msg = MESSAGE:New(
                string.format("%s - %s - %s fuel low, calling for replacement.\n",
                    airwing:GetName(), squadron:GetName(), flightgroup:GetCallsignName(true, true)), 30)
            if flightmessages or debug then
                msg:ToBlue()
            end
            if flightlog or debug then
                msg:ToLog()
            end
        end
    end

    -- Add a new mission on dead
    function flightgroup:OnAfterDead(From, Event, To)
        _NewSupportMission(commander, missionmanager, mtype, mid)

        if debug or flightmessages or flightlog then
            local msg = MESSAGE:New(
                string.format("%s - %s - %s dead, calling for replacement.\n",
                    airwing:GetName(), squadron:GetName(), flightgroup:GetCallsignName(true, true)), 30)
            if flightmessages or debug then
                msg:ToBlue()
            end
            if flightlog or debug then
                msg:ToLog()
            end
        end
    end

    -- Start Radios and TACAN when mission is executed.
    function flightgroup:OnAfterMissionExecute(From, Event, To, Mission)
        local mission = Mission
        local mtype = mission:GetType()
        local mid = mission.mid

        local tacanChannel
        local tacanMorse
        local tacanBand
        local radioFrequency
        local radioModulation

        -- Assign the TACAN and radio frequencies for the mission based on mission type
        if mtype == AUFTRAG.Type.AWACS then
            radioFrequency = missionmanager.missions[AUFTRAG.Type.AWACS][mid].radioFrequency
            radioModulation = missionmanager.missions[AUFTRAG.Type.AWACS][mid].radioModulation
        elseif mtype == AUFTRAG.Type.TANKER then
            tacanChannel = missionmanager.missions[AUFTRAG.Type.TANKER][mid].tacanChannel
            tacanMorse = missionmanager.missions[AUFTRAG.Type.TANKER][mid].tacanMorse
            tacanBand = missionmanager.missions[AUFTRAG.Type.TANKER][mid].tacanBand
            radioFrequency = missionmanager.missions[AUFTRAG.Type.TANKER][mid].radioFrequency
            radioModulation = missionmanager.missions[AUFTRAG.Type.TANKER][mid].radioModulation
        end


        -- Cancel the active mission if it is not this one.
        local cm = missionmanager.missions[mtype][mid].mission:peek()
        while cm ~= mission do
            if cm ~= mission and cm:IsNotOver() then
                cm:Cancel()
                missionmanager.missions[mtype][mid].mission:dequeue()

                if debug then
                    MESSAGE:New(
                        string.format("%s - %s - %s cancelling and dequeuing the previously active mission: %s.\n",
                            airwing:GetName(),
                            squadron:GetName(), flightgroup:GetCallsignName(true, true), cm:GetName()), 30):ToBlue()
                        :ToLog()
                end
            elseif cm ~= mission and cm:IsOver() then
                missionmanager.missions[mtype][mid].mission:dequeue()
                if debug then
                    MESSAGE:New(
                        string.format("%s - %s - %s dequeuing the previously active mission: %s.\n", airwing:GetName(),
                            squadron:GetName(), flightgroup:GetCallsignName(true, true), cm:GetName()), 30):ToBlue()
                        :ToLog()
                end
            elseif cm == mission then
                if debug then
                    MESSAGE:New(
                        string.format("%s - %s - %s is the currently active mission: %s.\n", airwing:GetName(),
                            squadron:GetName(), flightgroup:GetCallsignName(true, true), cm:GetName()), 30):ToBlue()
                        :ToLog()
                end
            elseif cm == nil then
                missionmanager.missions[mtype][mid].mission:enqueue(mission)
                if debug then
                    MESSAGE:New(
                        string.format("%s - %s - %s queue is unexpectededly empty, requeuing mission: %s.\n",
                            airwing:GetName(),
                            squadron:GetName(), flightgroup:GetCallsignName(true, true), mission:GetName()), 30):ToBlue()
                        :ToLog()
                end
            end
            cm = missionmanager.missions[mtype][mid].mission:peek()
        end

        -- Startup TACAN/Radio for mission.
        if mtype == AUFTRAG.Type.TANKER then
            flightgroup:SwitchTACAN(tacanChannel, tacanMorse, 1, tacanBand)
        end
        flightgroup:SwitchRadio(radioFrequency, radioModulation)

        if debug or flightmessages or flightlog then
            local msg
            if mtype == AUFTRAG.Type.TANKER then
                msg = MESSAGE:New(string.format(
                    "%s - %s - %s executing %s mission. TACAN: (%s%s) RADIO (%s%s)", airwing:GetName(),
                    squadron:GetName(), flightgroup:GetCallsignName(true, false), mission:GetType(),
                    tostring(tacanChannel),
                    tostring(tacanBand), tostring(radioFrequency), tostring(radioModulation)), 30)
            else
                msg = MESSAGE:New(string.format(
                    "%s - %s - %s executing %s mission. RADIO (%s%s)", airwing:GetName(),
                    squadron:GetName(), flightgroup:GetCallsignName(true, false), mission:GetType(),
                    tostring(radioFrequency),
                    tostring(radioModulation)), 30)
            end
            if flightmessages or debug then
                msg:ToBlue()
            end
            if flightlog or debug then
                msg:ToLog()
            end
        end
    end

    -- Decommission TACAN and radio after mission is done.
    function flightgroup:OnAfterMissionDone(From, Event, To, Mission)
        local mission = Mission

        -- Disable TACAN and radio after mission.
        if mtype == AUFTRAG.Type.TANKER then
            self:TurnOffTACAN()
        end
        self:TurnOffRadio()

        if debug or flightmessages or flightlog then
            local msg = MESSAGE:New(string.format(
                "%s - %s - %s has completed mission: %s. Returning to Base", airwing:GetName(),
                squadron:GetName(), flightgroup:GetCallsignName(true, false),
                mission:GetType()), 30)
            if flightmessages or debug then
                msg:ToBlue()
            end
            if flightlog or debug then
                msg:ToLog()
            end
        end
    end

    function flightgroup:OnAfterMissionCancel(From, Event, To, Mission)
        local mission = Mission

        -- Disable TACAN and radio after mission.
        self:TurnOffRadio()

        if debug then
            MESSAGE:New(string.format(
                "%s - %s - %s mission canceled by replacement. RTB", airwing:GetName(),
                squadron:GetName(), flightgroup:GetCallsignName(true, false),
                mission:GetType()), 30):ToBlue():ToLog()
        end
    end

    function flightgroup:OnAfterPassingWaypoint(From, Event, To, Waypoint)
        local waypoint = Waypoint
        if debug then
            MESSAGE:New(
                string.format("%s - %s - %s passing waypoint %s", airwing:GetName(),
                    squadron:GetName(), self:GetCallsignName(true, false), waypoint.name), 30)
                :ToBlue():ToLog()
        end
    end
end

-- Setup a basic FIFO queue for coordinating tanker and AWACS missions to minimize the time without an asset in the air and on station.
local missionQueue = {}
missionQueue.__index = missionQueue

function missionQueue:new()
    return setmetatable({ first = 0, last = -1, [0] = nil }, missionQueue)
end

function missionQueue:enqueue(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

function missionQueue:dequeue()
    local first = self.first
    if first > self.last then return nil end
    local value = self[first]
    self[first] = nil -- to allow garbage collection
    self.first = first + 1
    return value
end

function missionQueue:isEmpty()
    return self.first > self.last
end

function missionQueue:count()
    return self.last - self.first + 1
end

function missionQueue:peek()
    return self[self.first]
end

---
-- Setup Main Control structures
---

-- Anderson AFB Commander
local AndersonCommander = COMMANDER:New(coalition.side.BLUE, "Anderson Commander")
local USSAmericaCommander = COMMANDER:New(coalition.side.BLUE, "CV-66 USS America")

---
-- Mission Manangement
---

-- manages shared data between for mission coordination
-- @param squadrons table maintains squadron data
-- @param missions table maintains mission data
local missionmanager = {}
missionmanager.squadrons = {}
missionmanager.missions = {}

-- Mission Parameters
missionmanager.missions = {
    [AUFTRAG.Type.TANKER] = {
        ["shell2"] = {
            name = "Shell 2",
            callsignName = CALLSIGN.Tanker.Shell,
            callsignNumber = 2,
            zone = ZONE:FindByName("AAR.N"),
            orbitSpeed = 280,
            missionSpeed = 380,
            orbitAltitude = 21000,
            orbitTrack = 270,
            legLength = 40,
            tacanChannel = 21,
            tacanMorse = "SHL",
            tacanBand = "Y",
            radioFrequency = 242.500,
            radioModulation = radio.modulation.AM,
            refuelType = Unit.RefuelingSystem.PROBE_AND_DROGUE,
            firstAssetLaunch = false,
            mission = missionQueue:new(),
            fuellowthreshold = 25, -- The fuel low state threshold
            fuelcritthreshold = 15 -- The fuel critical state threshold
        }
    },
    [AUFTRAG.Type.AWACS] = {
        ["darkstar1"] = {
            name = "Darkstar 1",
            callsignName = CALLSIGN.AWACS.Darkstar,
            callsignNumber = 1,
            zone = ZONE:FindByName("DARKSTAR.N"),
            orbitSpeed = 300,
            missionSpeed = 380,
            orbitAltitude = 30000,
            orbitTrack = 288,
            legLength = 100,
            radioFrequency = 251,
            radioModulation = radio.modulation.AM,
            firstAssetLaunch = false,
            mission = missionQueue:new(),
            fuellowthreshold = 25, -- The fuel low state threshold
            fuelcritthreshold = 15 -- The fuel critical state threshold
        },
        ["screwtop4"] = {
            name = "Screwtop 4",
            callsignName = CALLSIGN.AWACS.Magic,
            callsignNumber = 4,
            zone = ZONE:FindByName("SCREWTOP.N"),
            orbitSpeed = 300,
            missionSpeed = 380,
            orbitAltitude = 30000,
            orbitTrack = 243,
            legLength = 100,
            radioFrequency = 255.5,
            radioModulation = radio.modulation.AM,
            firstAssetLaunch = false,
            mission = missionQueue:new(),
            fuellowthreshold = 25, -- The fuel low state threshold
            fuelcritthreshold = 15 -- The fuel critical state threshold
        },

    }
}

---
-- Squadrons
---

-- KC-135MPRS squadron.
local ARS06 = SQUADRON:New("Anderson KC-135MPRS", 4, "6th Air Refueling Squadron")
ARS06:SetModex(100)
ARS06:SetSkill(AI.Skill.EXCELLENT)
ARS06:AddMissionCapability({ AUFTRAG.Type.TANKER }, 100)
ARS06:SetTakeoffCold()
ARS06:SetMissionRange(300)

-- E-3A squadron.
local AAC963 = SQUADRON:New("Anderson AWACS", 2, "963rd Airborne Air Control Squadron")
AAC963:SetModex(400)
AAC963:SetSkill(AI.Skill.EXCELLENT)
AAC963:AddMissionCapability({ AUFTRAG.Type.AWACS }, 100)
AAC963:SetTakeoffCold()
AAC963:SetMissionRange(300)

-- E-3A squadron.
local SCREWTOP4 = SQUADRON:New("Screwtop", 2, "Screwtop Airborne Air Control Squadron")
SCREWTOP4:SetModex(500)
SCREWTOP4:SetSkill(AI.Skill.EXCELLENT)
SCREWTOP4:AddMissionCapability({ AUFTRAG.Type.AWACS }, 100)
SCREWTOP4:SetTakeoffCold()
SCREWTOP4:SetMissionRange(300)

---
-- Airwings
---

-- 60th Air Mobility Wing.
local AMW60 = AIRWING:New("Warehouse Anderson", "60th Air Mobility Wing")
AMW60:AddSquadron(ARS06)

-- Handlers for AMW60 Tanker setup and mission assignment.
function AMW60:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
    _SupportFlightOnMission(From, Event, To, Flightgroup, Mission, missionmanager, AndersonCommander)
end

-- 552nd Air Control Wing.
local ACW552 = AIRWING:New("Warehouse Anderson", "552nd Air Control Wing")
ACW552:AddSquadron(AAC963)

-- Handlers for ACW552 AWACS setup and mission assignment.
function ACW552:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
    _SupportFlightOnMission(From, Event, To, Flightgroup, Mission, missionmanager, AndersonCommander)
end

-- VAW-123 Air Control Wing.
local VAW123 = AIRWING:New("CV-66 USS America", "VAW-123 Air Control Wing")
VAW123:AddSquadron(SCREWTOP4)

-- Handlers for VAW-123 AWACS setup and mission assignment.
function VAW123:OnAfterFlightOnMission(From, Event, To, Flightgroup, Mission)
    _SupportFlightOnMission(From, Event, To, Flightgroup, Mission, missionmanager, USSAmericaCommander)
end

---
-- Initialisation
---

AndersonCommander:AddAirwing(AMW60)
AndersonCommander:AddAirwing(ACW552)

USSAmericaCommander:AddAirwing(VAW123)

-- Support Missions
_NewSupportMission(AndersonCommander, missionmanager, AUFTRAG.Type.TANKER, "shell2")
_NewSupportMission(AndersonCommander, missionmanager, AUFTRAG.Type.AWACS, "darkstar1")

_NewSupportMission(USSAmericaCommander, missionmanager, AUFTRAG.Type.AWACS, "screwtop4")


-- Start the commanders
AndersonCommander:SetVerbosity(5)
AndersonCommander:__Start(1)

USSAmericaCommander:SetVerbosity(5)
USSAmericaCommander:__Start(1)
