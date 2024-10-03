-- Civilian Traffic for NTTR RAT

local A320DAirlineZone1 = SPAWN:New("AA727 AirlineZone1")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local AA727AirlineZone1FG1 = FLIGHTGROUP:New(spawngrp)
            AA727AirlineZone1FG1:SetFlightControl(atcMcCarran)
        end
    )
    :SpawnScheduled(900, .5)

local DA727AirlineZone2 = SPAWN:New("DA727 AirlineZone2")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local DA727AirlineZone2FG1 = FLIGHTGROUP:New(spawngrp)
            DA727AirlineZone2FG1:SetFlightControl(atcMcCarran)
        end
    )
    :SpawnScheduled(900, .5)

local U727AirlineZone3 = SPAWN:New("U727 AirlineZone3")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local U727AirlineZone3FG1 = FLIGHTGROUP:New(spawngrp)
            U727AirlineZone3FG1:SetFlightControl(atcMcCarran)
        end
    )
    :SpawnScheduled(900, .5)

local AA737AirlineZone4 = SPAWN:New("AA737 AirlineZone4")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local AA737AirlineZone4FG1 = FLIGHTGROUP:New(spawngrp)
            AA737AirlineZone4FG1:SetFlightControl(atcMcCarran)
        end
    )
    :SpawnScheduled(900, .5)

-- Military Traffic for NTTR RAT
local B1BTonCreech = SPAWN:New("B1B Ton-Creech")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :InitRepeatOnLanding()
    :OnSpawnGroup(
        function(spawngrp)
            local B1BTonCreechFG1 = FLIGHTGROUP:New(spawngrp)
            B1BTonCreechFG1:SetFlightControl(atcTonopahTest)
            B1BTonCreechFG1:SetFuelLowRTB(false)
            B1BTonCreechFG1:SetFuelCriticalRTB(true)
            B1BTonCreechFG1:SetFuelLowRefuel(true)

            function B1BTonCreechFG1:OnAfterTakeoff(From, Event, To)
                B1BTonCreechFG1:SetFlightControl(atcCreech)
            end
        end
    )
    :SpawnScheduled(1800, .5)



local F16TonCreech = SPAWN:New("F-16 Ton-Creech")
    :InitLimit(3, 0)
    :InitCleanUp(300)
    :InitRepeatOnLanding()
    :OnSpawnGroup(
        function(spawngrp)
            local F16TonCreechFG1 = FLIGHTGROUP:New(spawngrp)
            F16TonCreechFG1:SetFlightControl(atcTonopahTest)
            F16TonCreechFG1:SetFuelLowRTB(false)
            F16TonCreechFG1:SetFuelCriticalRTB(true)
            F16TonCreechFG1:SetFuelLowRefuel(true)

            function F16TonCreechFG1:OnAfterTakeoff(From, Event, To)
                F16TonCreechFG1:SetFlightControl(atcCreech)
            end
        end
    )
    :SpawnScheduled(1800, 0.5)

TIMER:New(function()
    local F16NellisTon = SPAWN:New("F-16 Nellis-Ton")
        :InitLimit(3, 0)
        :InitCleanUp(300)
        :OnSpawnGroup(
            function(spawngrp)
                local F16NellisTonFG1 = FLIGHTGROUP:New(spawngrp)
                F16NellisTonFG1:SetFlightControl(atcNellis)
                F16NellisTonFG1:SetFuelLowRTB(false)
                F16NellisTonFG1:SetFuelCriticalRTB(true)
                F16NellisTonFG1:SetFuelLowRefuel(true)

                function F16NellisTonFG1:OnAfterTakeoff(From, Event, To)
                    F16NellisTonFG1:SetFlightControl(atcTonopahTest)
                end
            end
        )
        :SpawnScheduled(1200, 0.5)
end):Start(600)

TIMER:New(function()
    local F4ENellisTon = SPAWN:New("F-4E Nellis-Ton")
        :InitLimit(3, 0)
        :InitCleanUp(300)
        :OnSpawnGroup(
            function(spawngrp)
                local F4ENellisTonFG1 = FLIGHTGROUP:New(spawngrp)
                F4ENellisTonFG1:SetFlightControl(atcNellis)
                F4ENellisTonFG1:SetFuelLowRTB(false)
                F4ENellisTonFG1:SetFuelCriticalRTB(true)
                F4ENellisTonFG1:SetFuelLowRefuel(true)

                function F4ENellisTonFG1:OnAfterTakeoff(From, Event, To)
                    F4ENellisTonFG1:SetFlightControl(atcTonopahTest)
                end
            end
        )
        :SpawnScheduled(1200, 0.5)
end):Start(300)


TIMER:New(function()
    local F15ENellisNellis = SPAWN:New("F-15E Nellis-Nellis")
        :InitLimit(3, 0)
        :InitCleanUp(300)
        :OnSpawnGroup(
            function(spawngrp)
                local F15ENellisNellisFG1 = FLIGHTGROUP:New(spawngrp)
                F15ENellisNellisFG1:SetFlightControl(atcNellis)
                F15ENellisNellisFG1:SetFuelLowRTB(false)
                F15ENellisNellisFG1:SetFuelCriticalRTB(true)
                F15ENellisNellisFG1:SetFuelLowRefuel(true)
            end
        )
        :SpawnScheduled(1800, 0.5)
end):Start(800)


local NEExitZone = ZONE:New("NE Exit")

TIMER:New(function()
    local C5NellisNEExit = SPAWN:New("C5 Nellis-NEExit")
        :InitLimit(3, 0)
        :InitCleanUp(300)
        :OnSpawnGroup(
            function(spawngrp)
                local C5NellisNEExitFG1 = FLIGHTGROUP:New(spawngrp)
                C5NellisNEExitFG1:SetFlightControl(atcNellis)
                C5NellisNEExitFG1:AddCheckZone(NEExitZone)
                function C5NellisNEExitFG1:OnAfterEnterZonOnAfterEnterZone(From, Event, To, zone)
                    if zone == NEExitZone then
                        spawngrp:Destroy()
                    end
                end
            end
        )
        :SpawnScheduled(3600, 0.5)
end):Start(1000)
