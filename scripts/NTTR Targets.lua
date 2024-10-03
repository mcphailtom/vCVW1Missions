-- BASE:TraceClass("PLAYERTASKCONTROLLER")
-- BASE:TraceClass("INTEL")

local reconZoneSet = SET_ZONE:New():FilterPrefixes("Recon Zone"):FilterStart()
local joshuaZone = ZONE_POLYGON:NewFromDrawing("Joshua")

MobileGroup = SPAWN:New("Mobile Targets")
    :InitKeepUnitNames()
    :OnSpawnGroup(
        function(spawngrp)
            local MBGroupAG = ARMYGROUP:New(spawngrp)
        end
    )
    :Spawn()


local Recon = SPAWN:New("Recon")
Recon:InitLimit(2, 0)
    :InitCleanUp(300)
    :InitRepeatOnLanding()
    :OnSpawnGroup(function(spawngrp)
        local ReconFG = FLIGHTGROUP:New(spawngrp)

        ReconFG:SetFlightControl(atcNellis)
        ReconFG:SetFuelLowThreshold(15)
        ReconFG:SetFuelLowRTB(false)
        ReconFG:SetFuelCriticalThreshold(10)
        ReconFG:SetFuelCriticalRTB(false)
        ReconFG:SwitchAlarmstate(0)

        local supportMission = nil

        function ReconFG:OnAfterTakeoff(From, Event, To)
            ReconFG:SetFlightControl(atcNellis)
        end

        function ReconFG:OnAfterDead(From, Event, To)
            Recon:Spawn()
        end

        function ReconFG:OnAfterPassingWaypoint(From, Event, To, Waypoint)
            local cwp = ReconFG:GetWaypointCurrent()
            if cwp.uid == 6 then
                supportMission = AUFTRAG:NewRECON(reconZoneSet, 413, 64000, true, true,
                    ENUMS.Formation.FixedWing.LineAbreast.Close)
                ReconFG:AddMission(supportMission)

                ReconFG:SwitchAlarmstate(2)
                ReconFG:SetDetection(true)
            end

            if cwp.uid == 7 then
                ReconFG:SwitchAlarmstate(0)
                ReconFG:SetDetection(false)
            end
        end

        function ReconFG:OnAfterFuelLow(From, Event, To)
            if supportMission then
                supportMission:Cancel()
            end
        end
    end
    )
    :SpawnScheduled(600, 0.5)

-- Settings
_SETTINGS:SetPlayerMenuOn()
_SETTINGS:SetImperial()
_SETTINGS:SetA2G_BR()

local taskmanager = PLAYERTASKCONTROLLER:New("Joshua Zone Controller", coalition.side.BLUE, PLAYERTASKCONTROLLER.Type
    .A2G)
taskmanager:SetLocale("en")
taskmanager:SetupIntel("Recon")
taskmanager:SetMenuName("Groundhog")
taskmanager:SwitchMagenticAngles(true)
taskmanager:SuppressScreenOutput(true)

taskmanager:AddAcceptZone(joshuaZone)

-- SRS
local ghSRSPath = "D:\\DCS-SimpleRadio-Standalone"
local ghSRSPort = 5002
local ghSRSGoogle = "D:\\DCS-SimpleRadio-Standalone\\creds\\tomdcsatc-f2ffe3cfee37.json"
local ghCoordinate = STATIC:FindByName("Groundhog Tower"):GetCoordinate()
taskmanager:SetSRS(227, radio.modulation.AM, ghSRSPath, "male", "en-US", ghSRSPort, nil, 1.0,
    ghSRSGoogle, nil, ghCoordinate)

-- Targetting options
taskmanager:AddTarget(ZONE:FindByName("Outpost Zone-1"))
taskmanager:AddTarget(ZONE:FindByName("Outpost Zone-2"))
taskmanager:AddTarget(ZONE:FindByName("IADS Zone-1"))
taskmanager:AddTarget(ZONE:FindByName("IADS Zone-2"))
taskmanager:AddTarget(ZONE:FindByName("IADS Zone-3"))
taskmanager:AddTarget(ZONE:FindByName("IADS Zone-4"))
taskmanager:AddTarget(ZONE:FindByName("IADS Zone-5"))
taskmanager:AddTarget(ZONE:FindByName("Recon Zone-1"))
taskmanager:AddTarget(ZONE:FindByName("Recon Zone-2"))

taskmanager:SetTaskWhiteList({ AUFTRAG.Type.CAS, AUFTRAG.Type.BAI, AUFTRAG.Type.BOMBING, AUFTRAG.Type.SEAD })
taskmanager:SetTargetRadius(1000)
