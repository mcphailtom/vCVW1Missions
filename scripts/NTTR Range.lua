-- SRS
-- local rgSRSPath = "D:\\DCS-SimpleRadio-Standalone"
-- local rgSRSPort = 5002
-- local rgSRSGoogle = "D:\\DCS-SimpleRadio-Standalone\\creds\\tomdcsatc-f2ffe3cfee37.json"

-- Table of bombing target names.
local DBRbombtargets = { "NTTR DBL Circle" }

-- DBL Strafe Pits
local strafepit_north = { "DBL Strafe Pit-1" }
local strafepit_south = { "DBL Strafe Pit-2" }

local DogboneRange = RANGE:New("NTTR Range 62A")

DogboneRange:AddBombingTargets(DBRbombtargets, 50)

local fld = DogboneRange:GetFoullineDistance("DBL Strafe Pit-1", "DBL Foul Line-1")
DogboneRange:AddStrafePit(strafepit_north, nil, nil, nil, false, nil, fld)
DogboneRange:AddStrafePit(strafepit_south, nil, nil, nil, false, nil, fld)

-- Set Range Frequencys and initialise
-- DogboneRange:SetSRS(rgSRSPath, rgSRSPort, coalition.side.BLUE, 250.5, radio.modulation.AM, 1.0, rgSRSGoogle)
-- DogboneRange:SetSRSRangeInstructor(250.5, radio.modulation.AM, nil, "en-US", "male", "Range Relay")
-- DogboneRange:SetSRSRangeControl(395, radio.modulation.AM, nil, "en-US", "male", "Range Relay")

DogboneRange:TrackRocketsOFF()
DogboneRange:SetRangeZone(ZONE:FindByName("DBL Range Zone"))

DogboneRange:SetAutosaveOn(".\\range\\")

DogboneRange:SetFunkManOn(10042, "127.0.0.1")

DogboneRange:Start()

-- DCSBot Range announcments via Discord for range entry, exit, bomb results and strafe results
function DogboneRange:OnAfterEnterRange(From, Event, To, player)
	local player = player

	local name = tostring(player.playername)
	local aircraft = tostring(player.airframe)
	dcsbot.sendBotMessage(name .. ' has entered the Dog Bone Lake Range in an ' .. aircraft .. ' the range is Hot!')
end

function DogboneRange:OnAfterExitRange(From, Event, To, player)
	local player = player

	local name = tostring(player.playername)
	dcsbot.sendBotMessage(name .. ' is cleared off the Dog Bone Lake Range, the range is Cold!')
end

function DogboneRange:OnAfterImpact(From, Event, To, result, player)
	local player = player
	local result = result

	local name = tostring(player.playername)
	local score = tostring(result.quality)
	local weapon = tostring(result.weapon)
	local distance = tonumber(string.format("%.2f", result.distance))
	dcsbot.sendBotMessage(name ..
		' has completed their ' ..
		weapon ..
		' run on the Dog Bone Lake Range their grading was ' .. score .. ' at ' .. distance .. ' meters from the bull ') -- results
	local client = player.playername
	if result.quality == "EXCELLENT" then                                                                          --if excellent give player 5 points
		dcsbot.addUserPoints(client, 5)
	elseif result.quality == "GOOD" then                                                                           --if good give player 2 points
		dcsbot.addUserPoints(client, 2)
	else
	end
end

function DogboneRange:OnAfterStrafeResult(From, Event, To, player, result)
	local player = player
	local result = result

	local name = tostring(player.playername)
	local score = tostring(result.roundsQuality)
	local hits = tonumber(result.roundsHit)
	dcsbot.sendBotMessage(name ..
		' has completed a strafe pass on the Dog Bone Lake Range, Accuracy was graded as ' ..
		score .. ' with ' .. hits .. ' rounds on target ') -- results
end

-- Table of bombing target names.
local R62Bbombtargets = { "NTTR 62B Circle" }

local R62B = RANGE:New("NTTR Range 62B")

R62B:AddBombingTargets(R62Bbombtargets, 10)

-- Set Range Frequencys and initialise
-- R62B:SetSRS(rgSRSPath, rgSRSPort, coalition.side.BLUE, 249.5, radio.modulation.AM, 1.0, rgSRSGoogle)
-- R62B:SetSRSRangeInstructor(249.5, radio.modulation.AM, nil, "en-US", "male", "Range Relay")
-- R62B:SetSRSRangeControl(394, radio.modulation.AM, nil, "en-US", "male", "Range Relay")

R62B:TrackRocketsOFF()
R62B:SetRangeZone(ZONE:FindByName("62B Range Zone"))

R62B:SetAutosaveOn(".\\range\\")

R62B:SetFunkManOn(10042, "127.0.0.1")

R62B:Start()

-- DCSBot Range announcments via Discord for range entry, exit, bomb results and strafe results
function R62B:OnAfterEnterRange(From, Event, To, player)
	local player = player

	local name = tostring(player.playername)
	local aircraft = tostring(player.airframe)
	dcsbot.sendBotMessage(name .. ' has entered Range 62A in an ' .. aircraft .. ' the range is Hot!')
end

function R62B:OnAfterExitRange(From, Event, To, player)
	local player = player
	player.playername = player.playername
	local name = tostring(player.playername)
	dcsbot.sendBotMessage(name .. ' is cleared off Range 62A, the range is Cold!')
end

function R62B:OnAfterImpact(From, Event, To, result, player)
	local player = player
	local result = result

	local name = tostring(player.playername)
	local score = tostring(result.quality)
	local weapon = tostring(result.weapon)
	local distance = tonumber(string.format("%.2f", result.distance))
	dcsbot.sendBotMessage(name ..
		' has completed their ' ..
		weapon ..
		' run on Range 62B their grading was ' .. score .. ' at ' .. distance .. ' meters from the bull ') -- results
	local client = player.playername
	if result.quality == "EXCELLENT" then
	elseif result.quality == "GOOD" then
		dcsbot.addUserPoints(client, 2)
	else
	end
end

function R62B:OnAfterStrafeResult(From, Event, To, player, result)
	local player = player
	local result = result

	local name = tostring(player.playername)
	local score = tostring(result.roundsQuality)
	local hits = tonumber(result.roundsHit)
	dcsbot.sendBotMessage(name ..
		' has completed a strafe pass on Range 62B, Accuracy was graded as ' ..
		score .. ' with ' .. hits .. ' rounds on target ') -- results
end
