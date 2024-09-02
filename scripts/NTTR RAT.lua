-- Create a new FLIGHTCONTROL object at Nellis AFB. The tower frequency is 251 MHz AM. Path to SRS has to be adjusted. 
local atcMcCarran=FLIGHTCONTROL:New(AIRBASE.Nevada.McCarran_International, 251,nil)
atcMcCarran:SetSpeedLimitTaxi(25)
atcMcCarran:SetLimitTaxi(3, false, 1)
atcMcCarran:SetLimitLanding(2, 99)
atcMcCarran:Start()


local A320DAirlineZone1 = SPAWN:New( "A320D AirlineZone1" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local A320DAirlineZone1FG1 = FLIGHTGROUP:New(spawngrp)
        A320DAirlineZone1FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local A320DAirlineZone2 = SPAWN:New( "A320D AirlineZone2" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local A320DAirlineZone2FG1 = FLIGHTGROUP:New(spawngrp)
        A320DAirlineZone2FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local A320DAirlineZone3 = SPAWN:New( "A320D AirlineZone3" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local A320DAirlineZone3FG1 = FLIGHTGROUP:New(spawngrp)
        A320DAirlineZone3FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local A320DAirlineZone4 = SPAWN:New( "A320D AirlineZone4" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local A320DAirlineZone4FG1 = FLIGHTGROUP:New(spawngrp)
        A320DAirlineZone4FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )


local atcCreech=FLIGHTCONTROL:New(AIRBASE.Nevada.Creech, 251,nil)
atcCreech:SetSpeedLimitTaxi(25)
atcCreech:SetLimitTaxi(3, false, 1)
atcCreech:SetLimitLanding(2, 99)
atcCreech:Start()

local atcTonopahTest=FLIGHTCONTROL:New(AIRBASE.Nevada.Tonopah_Test_Range, 251,nil)
atcTonopahTest:SetSpeedLimitTaxi(25)
atcTonopahTest:SetLimitTaxi(3, false, 1)
atcTonopahTest:SetLimitLanding(2, 99)
atcTonopahTest:Start()


local F16TonCreech = SPAWN:New( "F-16 Ton-Creech" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local F16TonCreechFG1 = FLIGHTGROUP:New(spawngrp)
        F16TonCreechFG1:SetFlightControl(atcTonopahTest)

        function F16TonCreechFG1:OnAfterTakeoff(From, Event, To)
            F16TonCreechFG1:SetFlightControl(atcTonopahTest)
        end
    end
)
:SpawnScheduled( 1800 , .5 )

local B2TonCreech = SPAWN:New( "B2 Ton-Creech" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local B2TonCreechFG1 = FLIGHTGROUP:New(spawngrp)
        B2TonCreechFG1:SetFlightControl(atcTonopahTest)

        function B2TonCreechFG1:OnAfterTakeoff(From, Event, To)
            B2TonCreechFG1:SetFlightControl(atcTonopahTest)
        end
    end
)
:SpawnScheduled( 1800 , .5 )