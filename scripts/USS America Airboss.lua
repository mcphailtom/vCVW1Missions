----------------------------------------------------------------------------------------
---
-- Name: CV-66 USS America
-- Author: Nords
----------------------------------------------------------------------------------------

-- No MOOSE settings menu. Comment out this line if required.
_SETTINGS:SetPlayerMenuOff()

-- S-3B Recovery Tanker spawning on CV-66 USS America.
local tanker = RECOVERYTANKER:New("CV-66 USS America", "VS-32 Tanker | 252.500MHz")
tanker:SetUseUncontrolledAircraft()
tanker:SetTakeoffCold()
tanker:SetRadio(252.5)
tanker:SetAltitude(12059)
tanker:SetCallsign(CALLSIGN.AWACS.Mauler, 5)
tanker:SetModex(702)
tanker:SetRespawnOn()
tanker:SetTACAN(91, "TEX")
tanker:__Start(800)

-- E-2D AWACS spawning on CV-66 USS America.
local awacs = RECOVERYTANKER:New("CV-66 USS America", "VAW-123 AWACS | 255.500MHz")
awacs:SetAWACS()
awacs:SetUseUncontrolledAircraft()
awacs:SetTakeoffCold()
awacs:SetRadio(255.5)
awacs:SetAltitude(27897)
awacs:SetCallsign(CALLSIGN.AWACS.Focus)
awacs:SetRacetrackDistances(30, 15)
awacs:SetModex(600)
awacs:SetRespawnOn()
awacs:SetTACAN(2, "FOC")
awacs:__Start(800)

-- Rescue Helo with home base CV-66 USS America. Has to be a global object!
rescuehelo = RESCUEHELO:New("CV-66 USS America", "HS-11 Plane Guard")
rescuehelo:SetUseUncontrolledAircraft()
rescuehelo:SetTakeoffCold()
rescuehelo:SetModex(615)
rescuehelo:SetRespawnOn()
rescuehelo:__Start(800)

-- Create AIRBOSS object.
local AirbossUSSAmerica = AIRBOSS:New("CV-66 USS America")

-- Set as Nimitz carrier class.
AirbossUSSAmerica:_InitStennis()

-- Add recovery windows:
local window1 = AirbossUSSAmerica:AddRecoveryWindow("7:30", "8:15", 1, nil, false, 25)
local window2 = AirbossUSSAmerica:AddRecoveryWindow("9:15", "10:00", 1, nil, false, 25)
local window3 = AirbossUSSAmerica:AddRecoveryWindow("11:00", "11:45", 1, nil, false, 25)
local window4 = AirbossUSSAmerica:AddRecoveryWindow("12:45", "13:30", 1, nil, false, 25)
local window5 = AirbossUSSAmerica:AddRecoveryWindow("14:30", "15:15", 1, nil, false, 25)

-- Set folder of airboss sound files within miz file.
AirbossUSSAmerica:SetSoundfilesFolder("Airboss Soundfiles/")

-- Switch off welcome message.
AirbossUSSAmerica:SetWelcomePlayers(false)

-- Set TACAN.
AirbossUSSAmerica:SetTACAN(66, "X", "ARA")

-- Set ICLS.
AirbossUSSAmerica:SetICLS(16, "ARA")

-- Radios.
AirbossUSSAmerica:SetAirbossRadio(300)
AirbossUSSAmerica:SetMarshalRadio(275)
AirbossUSSAmerica:SetLSORadio(260)

-- Set carrier controlled zone.
AirbossUSSAmerica:SetCarrierControlledArea(50)

-- Set max number of Marshal Stacks.
AirbossUSSAmerica:SetMaxMarshalStacks(8)

-- Set max section size.
AirbossUSSAmerica:SetMaxSectionSize(4)

-- Set max stack size.
AirbossUSSAmerica:SetMaxFlightsPerStack(1)

-- Single carrier menu optimization.
AirbossUSSAmerica:SetMenuSingleCarrier()

-- Skipper menu (45 mins at 25kn)
AirbossUSSAmerica:SetMenuRecovery(45, 25, false)

-- Remove landed AI planes from flight deck.
AirbossUSSAmerica:SetDespawnOnEngineShutdown(true)

-- Load all saved player grades from your "Saved Games\DCS" folder (if lfs was desanitized).
AirbossUSSAmerica:Load()

-- Automatically save player results to your "Saved Games\DCS" folder each time a player get a final grade from the LSO.
AirbossUSSAmerica:SetAutoSave()

-- Enable trap sheet.
AirbossUSSAmerica:SetTrapSheet()

-- Enable FunkMan Discord Bot.
AirbossUSSAmerica:SetFunkManOn(10042, "127.0.0.1")

-- Start airboss class.
AirbossUSSAmerica:Start()


--- Function called when recovery tanker is started.
function tanker:OnAfterStart(From, Event, To)
  -- Set recovery tanker.
  AirbossUSSAmerica:SetRecoveryTanker(tanker)


  -- Use tanker as radio relay unit for LSO transmissions.
  AirbossUSSAmerica:SetRadioRelayLSO(self:GetUnitName())
end

--- Function called when AWACS is started.
function awacs:OnAfterStart(From, Event, To)
  -- Set AWACS.
  AirbossUSSAmerica:SetRecoveryTanker(tanker)
end

--- Function called when recovery has started.
function rescuehelo:OnAfterRecoveryStart(From, Event, To, Case, Offset)
  -- Use rescue helo as radio relay for Marshal.
  AirbossUSSAmerica:SetRadioRelayMarshal(self:GetUnitName())
end

--- Function called when recovery has ended.
function rescuehelo:OnAfterRecoveryStop(From, Event, To)
  -- Send helo RTB.
  rescuehelo:TaskRTB()
end

--- Function called when rescue helo has landed.
function rescuehelo:OnAfterReturned(From, Event, To, airbase)
  -- Send helo RTB.
  self:__Stop(300)
end

--- Function called when a player gets graded by the LSO.
function AirbossUSSAmerica:OnAfterLSOGrade(From, Event, To, playerData, grade)
  player_name = playerData.name:gsub('[%p]', '')
  trapsheet = "AIRBOSS-trapsheet-" .. player_name
  AirbossUSSAmerica:SetTrapSheet(nil, trapsheet)
  self:_SaveTrapSheet(playerData, grade)

  -- Send the player's grade to the DCS-BIOS Discord bot.
  msg = {}
  msg.command = "onMissionEvent"
  msg.eventName = "S_EVENT_AIRBOSS"
  msg.initiator = {}
  msg.initiator.name = playerData.name
  msg.place = {}
  msg.place.name = myGrade.carriername
  msg.points = myGrade.points
  msg.grade = myGrade.grade
  msg.details = myGrade.details
  msg.case = myGrade.case
  msg.wire = playerData.wire
  msg.trapsheet = trapsheet
  msg.time = timer.getTime()
  dcsbot.sendBotTable(msg)

  -- Log the player's score to the DCS.log file.
  local score = tonumber(grade.points)
  local name = tostring(playerData.name)
  env.info(string.format("Player %s scored %.1f", name, score))
end
