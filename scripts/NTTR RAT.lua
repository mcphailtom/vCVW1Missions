-- Civilian Traffic for NTTR RAT

local A320DAirlineZone1 = SPAWN:New( "AA727 AirlineZone1" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local AA727AirlineZone1FG1 = FLIGHTGROUP:New(spawngrp)
        AA727AirlineZone1FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 900 , .5 )

local DA727AirlineZone2 = SPAWN:New( "DA727 AirlineZone2" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local DA727AirlineZone2FG1 = FLIGHTGROUP:New(spawngrp)
        DA727AirlineZone2FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 900, .5 )

local U727AirlineZone3 = SPAWN:New( "U727 AirlineZone3" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local U727AirlineZone3FG1 = FLIGHTGROUP:New(spawngrp)
        U727AirlineZone3FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 900 , .5 )

local AA737AirlineZone4 = SPAWN:New( "AA737 AirlineZone4" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local AA737AirlineZone4FG1 = FLIGHTGROUP:New(spawngrp)
        AA737AirlineZone4FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 900, .5 )

-- Military Traffic for NTTR RAT
SCHEDULER:New(nil, function()
    local B1BTonCreech = SPAWN:New( "B1B Ton-Creech" )
    :InitLimit( 3 , 0 )
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local B1BTonCreechFG1 = FLIGHTGROUP:New(spawngrp)
            B1BTonCreechFG1:SetFlightControl(atcTonopahTest)

            function B1BTonCreechFG1:OnAfterTakeoff(From, Event, To)
                B1BTonCreechFG1:SetFlightControl(atcCreech)
            end
        end
    )
    :SpawnAtAirbase(abTonopahTest, SPAWN.Takeoff.Cold)
end, {}, 60, 1800)

SCHEDULER:New(nil, function()
    local F16TonCreech = SPAWN:New( "F-16 Ton-Creech" )
    :InitLimit( 3 , 0 )
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local F16TonCreechFG1 = FLIGHTGROUP:New(spawngrp)
            F16TonCreechFG1:SetFlightControl(atcTonopahTest)
    
            function F16TonCreechFG1:OnAfterTakeoff(From, Event, To)
                F16TonCreechFG1:SetFlightControl(atcCreech)
            end
        end
    )
    :SpawnAtAirbase(abTonopahTest, SPAWN.Takeoff.Cold)
end, {}, 60, 1800)

SCHEDULER:New(nil, function()
    local F16NellisTon = SPAWN:New( "F-16 Nellis-Ton" )
    :InitLimit( 3 , 0 )
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local F16NellisTonFG1 = FLIGHTGROUP:New(spawngrp)
            F16NellisTonFG1:SetFlightControl(atcNellis)

            function F16NellisTonFG1:OnAfterTakeoff(From, Event, To)
                F16NellisTonFG1:SetFlightControl(atcTonopahTest)
            end
        end
    )
    :SpawnAtAirbase(abNellis, SPAWN.Takeoff.Cold)
end, {}, 600, 1200)

SCHEDULER:New(nil, function()
    local F4ENellisTon = SPAWN:New( "F-4E Nellis-Ton" )
    :InitLimit( 3 , 0 )
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local F4ENellisTonFG1 = FLIGHTGROUP:New(spawngrp)
            F4ENellisTonFG1:SetFlightControl(atcNellis)

            function F4ENellisTonFG1:OnAfterTakeoff(From, Event, To)
                F4ENellisTonFG1:SetFlightControl(atcTonopahTest)
            end
        end
    )
    :SpawnAtAirbase(abNellis, SPAWN.Takeoff.Cold)
end, {}, 800, 1200)

SCHEDULER:New(nil, function()
    local F15ENellisNellis = SPAWN:New( "F-15E Nellis-Nellis" )
    :InitLimit( 3 , 0 )
    :InitCleanUp(300)
    :OnSpawnGroup(
        function(spawngrp)
            local F15ENellisNellisFG1 = FLIGHTGROUP:New(spawngrp)
            F15ENellisNellisFG1:SetFlightControl(atcNellis)
        end
    )
    :SpawnAtAirbase(abNellis, SPAWN.Takeoff.Cold)
end, {}, 800, 1800)

SCHEDULER:New(nil, function()
    local NEExitZone   = ZONE:New("NE Exit")

    local C5NellisNEExit = SPAWN:New( "C5 Nellis-NEExit" )
    :InitLimit( 3 , 0 )
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
    :SpawnAtAirbase(abNellis, SPAWN.Takeoff.Cold)
end, {}, 1000, 3600)