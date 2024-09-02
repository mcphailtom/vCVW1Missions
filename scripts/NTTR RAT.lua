-- Create a new FLIGHTCONTROL object at Nellis AFB. The tower frequency is 251 MHz AM. Path to SRS has to be adjusted. 
local atcMcCarran=FLIGHTCONTROL:New(AIRBASE.Nevada.McCarran_International, 251,nil)
atcMcCarran:SetSpeedLimitTaxi(25)
atcMcCarran:SetLimitTaxi(3, false, 1)
atcMcCarran:SetLimitLanding(2, 99)
atcMcCarran:Start()


local A320DAirlineZone1 = SPAWN:New( "AA727 AirlineZone1" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local AA727AirlineZone1FG1 = FLIGHTGROUP:New(spawngrp)
        AA727AirlineZone1FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local DA727AirlineZone2 = SPAWN:New( "DA727 AirlineZone2" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local DA727AirlineZone2FG1 = FLIGHTGROUP:New(spawngrp)
        DA727AirlineZone2FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local U727AirlineZone3 = SPAWN:New( "U727 AirlineZone3" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local U727AirlineZone3FG1 = FLIGHTGROUP:New(spawngrp)
        U727AirlineZone3FG1:SetFlightControl(atcMcCarran)

    end
)
:SpawnScheduled( 600 , .5 )

local AA737AirlineZone4 = SPAWN:New( "AA737 AirlineZone4" )
:InitLimit( 3 , 0 )
:InitCleanUp(300)
:OnSpawnGroup(
    function(spawngrp)
        local AA737AirlineZone4FG1 = FLIGHTGROUP:New(spawngrp)
        AA737AirlineZone4FG1:SetFlightControl(atcMcCarran)

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

local B2TonCreech = SPAWN:New( "B1B Ton-Creech" )
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