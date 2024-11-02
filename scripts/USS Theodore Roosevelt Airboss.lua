-- No MOOSE settings menu.
_SETTINGS:SetPlayerMenuOff()

-- S-3B Recovery Tanker
local tanker = RECOVERYTANKER:New("CVN-71 USS Theodore Roosevelt", "VS-32 Recovery Tanker")
--tanker:SetUseUncontrolledAircraft()
tanker:SetTakeoffCold()
tanker:SetRadio(252.5)
tanker:SetAltitude(12059)
tanker:SetCallsign(CALLSIGN.AWACS.Mauler, 5)
tanker:SetModex(704)
tanker:SetRespawnOn()
tanker:SetTACAN(91, "TEX")
tanker:__Start(600)

local USSTheodoreRooseveltAirboss = AIRBOSS:New("CVN-71 USS Theodore Roosevelt")
USSTheodoreRooseveltAirboss:_InitStennis()

-- Recovery windows
local window1 = USSTheodoreRooseveltAirboss:AddRecoveryWindow("21:05", "23:59", 3, 30, true, 25)


USSTheodoreRooseveltAirboss:SetSoundfilesFolder("Airboss Soundfiles/")
USSTheodoreRooseveltAirboss:SetWelcomePlayers(false)

-- TACAN/ICLS
USSTheodoreRooseveltAirboss:SetTACAN(71, "X", "TRT")
USSTheodoreRooseveltAirboss:SetICLS(17, "TRT")

-- Radios.
USSTheodoreRooseveltAirboss:SetAirbossRadio(300)
USSTheodoreRooseveltAirboss:SetMarshalRadio(275)
USSTheodoreRooseveltAirboss:SetLSORadio(260)

-- Carrier settings
USSTheodoreRooseveltAirboss:SetCarrierControlledArea(50)
USSTheodoreRooseveltAirboss:SetMaxMarshalStacks(8)
USSTheodoreRooseveltAirboss:SetMaxSectionSize(4)
USSTheodoreRooseveltAirboss:SetMaxFlightsPerStack(1)

USSTheodoreRooseveltAirboss:SetMenuSingleCarrier()
USSTheodoreRooseveltAirboss:SetMenuRecovery(45, 25, false)
USSTheodoreRooseveltAirboss:SetDespawnOnEngineShutdown(true)
USSTheodoreRooseveltAirboss:Start()


--- Function called when recovery tanker is started.
function tanker:OnAfterStart(From, Event, To)
  -- Set recovery tanker.
  USSTheodoreRooseveltAirboss:SetRecoveryTanker(tanker)

  -- Use tanker as radio relay unit for LSO transmissions.
  USSTheodoreRooseveltAirboss:SetRadioRelayLSO(self:GetUnitName())
end
