abMcCarran = AIRBASE:FindByName(AIRBASE.Nevada.McCarran_International)
abCreech = AIRBASE:FindByName(AIRBASE.Nevada.Creech)
abTonopahTest = AIRBASE:FindByName(AIRBASE.Nevada.Tonopah_Test_Range)
abNellis = AIRBASE:FindByName(AIRBASE.Nevada.Nellis)

atcMcCarran=FLIGHTCONTROL:New(AIRBASE.Nevada.McCarran_International, 257.8,nil)
atcMcCarran:SetSpeedLimitTaxi(25)
atcMcCarran:SetLimitTaxi(6, false, 0)
atcMcCarran:SetLimitLanding(4,99)
atcMcCarran:SetMarkHoldingPattern(false)
atcMcCarran:Start()

atcCreech=FLIGHTCONTROL:New(AIRBASE.Nevada.Creech, 360.6,nil)
atcCreech:SetSpeedLimitTaxi(25)
atcCreech:SetLimitTaxi(2, false, 0)
atcCreech:SetLimitLanding(2,99)
atcCreech:SetMarkHoldingPattern(false)
atcCreech:Start()

atcTonopahTest=FLIGHTCONTROL:New(AIRBASE.Nevada.Tonopah_Test_Range, 257.950,nil)
atcTonopahTest:SetSpeedLimitTaxi(25)
atcTonopahTest:SetLimitTaxi(2, false, 0)
atcTonopahTest:SetLimitLanding(2, 99)
atcTonopahTest:SetMarkHoldingPattern(false)
atcTonopahTest:Start()

atcNellis=FLIGHTCONTROL:New(AIRBASE.Nevada.Nellis, 327,nil)
atcNellis:SetSpeedLimitTaxi(25)
atcNellis:SetLimitTaxi(6, false, 0)
atcNellis:SetLimitLanding(4, 99)
atcNellis:SetMarkHoldingPattern(false)
atcNellis:Start()