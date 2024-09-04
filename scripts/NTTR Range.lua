-- Table of bombing target names.
local bombtargets = { "NTTR DBL Circle" }

DogboneRange = RANGE:New("NTTR Range 62A")

DogboneRange:AddBombingTargets(bombtargets, 10)

-- Set Range Frequencys and initialise
DogboneRange:SetSRS('')
DogboneRange:SetSRSRangeInstructor(250.5, radio.modulation.AM, nil, "en-US", "male", "Range Relay")
DogboneRange:SetSRSRangeControl(395, radio.modulation.AM, nil, "en-US", "male", "Range Relay")

DogboneRange:TrackRocketsOFF()
DogboneRange:SetRangeRadius(5)

DogboneRange:SetAutosaveOn(".\\range\\")

DogboneRange:SetFunkManOn(10042, "127.0.0.1")

DogboneRange:Start()

-- DCSBot Range announcments via Discord for range entry, exit, bomb results and strafe results
function DogboneRange:OnAfterEnterRange(From, Event, To, player)
	local player = player
	player.playername = player.playername
	player.airframe = player.airframe
	local name = tostring(player.playername)
	local aircraft = tostring(player.airframe)
	dcsbot.sendBotMessage(name .. ' has entered the Dog Bone Lake Range in an ' .. aircraft .. ' the range is Hot!')
end

function DogboneRange:OnAfterExitRange(From, Event, To, player)
	local player = player
	player.playername = player.playername
	local name = tostring(player.playername)
	dcsbot.sendBotMessage(name .. ' is cleared off the Dog Bone Lake Range, the range is Cold!')
end

function DogboneRange:OnAfterImpact(From, Event, To, result, player)
	local player = player
	local result = result
	player.playername = player.playername
	result.quality = result.quality
	result.distance = result.distance
	result.weapon = result.weapon
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
	player.playername = player.playername
	result.roundsQuality = result.roundsQuality
	result.roundsHit = result.roundsHit
	local name = tostring(player.playername)
	local score = tostring(result.roundsQuality)
	local hits = tonumber(result.roundsHit)
	dcsbot.sendBotMessage(name ..
		' has completed a strafe pass on the Dog Bone Lake Range, Accuracy was graded as ' ..
		score .. ' with ' .. hits .. ' rounds on target ') -- results
end

-- Table of bombing target names.
local bombtargets = { "NTTR 62B Range Static *Silhouette (MiG-29)-1","NTTR 62B Range Static *Silhouette (MiG-29)-2", "NTTR 62B Range Static *NTTR Target 62-13 DMPI 313-1", "NTTR 62B Range Static *NTTR Target 62-71 DMPI 119-2","NTTR 62B Range Static *NTTR Target 62-13 DMPI 310-1",
"NTTR 62B Range Static *NTTR Target 62-71 DMPI 119-1", "NTTR 62B Range Static *NTTR Target 62-32 DMPI 205-1", "NTTR 62B Range Static *NTTR Target 62-22 DMPI 217-2", "NTTR 62B Range Static *SeaLand 1x1 (Tan)-7","NTTR 62B Range Static *SeaLand 1x1 (Tan)-6",
"NTTR 62B Range Static *SeaLand 1x1 (Tan)-4","NTTR 62B Range Static *SeaLand 1x1 (Tan)-1","NTTR 62B Range Static *SeaLand 1x1 (Tan)-3","NTTR 62B Range Static *SeaLand 1x1 (Tan)-2","NTTR 62B Range Static *SeaLand 1x1 (Tan)-5","NTTR 62B Range Static *SeaLand 1x1 (Tan)-10",
"NTTR 62B Range Static *SeaLand 1x1 (Tan)-9","NTTR 62B Range Static *SeaLand 1x1 (Tan)-8","NTTR 62B Range Static *NTTR Target 62-22 DMPI 206-1","NTTR 62B Range Static *NTTR Target 62-22 DMPI 208-1","NTTR 62B Range Static *NTTR Target 62-22 DMPI 210-1","NTTR 62B Range Static *NTTR Target 62-22 DMPI 208-2",
"NTTR 62B Range Static *NTTR Target 62-22 DMPI 214-1","NTTR 62B Range Static *NTTR Target 62-22 DMPI 217-1","NTTR 62B Range Static *NTTR Target 62-22 DMPI 214-2","NTTR 62B Range Static *NTTR Target 62-21 DMPI 130-4","NTTR 62B Range Static *NTTR Target 62-21 DMPI 147-2",
"NTTR 62B Range Static *NTTR Target 62-21 DMPI 135-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 111-3","NTTR 62B Range Static *NTTR Target 76-01 DMPI 13-2","NTTR 62B Range Static *NTTR Target 76-01 DMPI 13-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 130-3",
"NTTR 62B Range Static *NTTR Target 62-21 DMPI 126-1","NTTR 62B Range Static *NTTR Target 62-62 DMPI 201-1","NTTR 62B Range Static *NTTR Target 62-13 DMPI 321-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 113-2","NTTR 62B Range Static *NTTR Target 62-21 DMPI 130-2",
"NTTR 62B Range Static *NTTR Target 62-21 DMPI 113-3","NTTR 62B Range Static *NTTR Target 62-21 DMPI 111-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 130-5","NTTR 62B Range Static *NTTR Target 62-21 DMPI 116-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 102-4",
"NTTR 62B Range Static *NTTR Target 62-21 DMPI 111-2","NTTR 62B Range Static *NTTR Target 62-21 DMPI 102-3","NTTR 62B Range Static *NTTR Target 62-21 DMPI 131-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 113-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 126-2",
"NTTR 62B Range Static *NTTR Target 62-21 DMPI 128-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 124-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 102-1","NTTR 62B Range Static *NTTR Target 62-21 DMPI 130-1","NTTR 62B Range Static *NTTR Target 62-11 DMPI 01-1",
"NTTR 62B Range Static *NTTR Target 62-13 DMPI 344-1","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-1","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-2","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-3","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-4",
"NTTR 62B Range Static *Bunker, Concrete (Sand 1)-5","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-6","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-7","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-8","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-9",
"NTTR 62B Range Static *Bunker, Concrete (Sand 1)-10","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-11","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-13","NTTR 62B Range Static *Bunker, Concrete (Sand 1)-12","NTTR 62B Range Static *NTTR Target 62-13 DMPI 334-1",
"NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-1","NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-2","NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-3","NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-4","NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-5",
"NTTR 62B Range Static *NTTR Target 62-41 DMPI 121-6","NTTR 62B Range Static *NTTR Target 66-07 DMPI 05-1" }

R62B = RANGE:New("NTTR Range 62A")

R62B:AddBombingTargets(bombtargets, 3)

-- Set Range Frequencys and initialise
R62B:SetSRS('')
R62B:SetSRSRangeInstructor(249.5, radio.modulation.AM, nil, "en-US", "male", "Range Relay")
R62B:SetSRSRangeControl(394, radio.modulation.AM, nil, "en-US", "male", "Range Relay")

R62B:TrackRocketsOFF()
R62B:SetRangeRadius(5)

R62B:SetAutosaveOn(".\\range\\")

R62B:SetFunkManOn(10042, "127.0.0.1")

R62B:Start()

-- DCSBot Range announcments via Discord for range entry, exit, bomb results and strafe results
function R62B:OnAfterEnterRange(From, Event, To, player)
	local player = player
	player.playername = player.playername
	player.airframe = player.airframe
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
	player.playername = player.playername
	result.quality = result.quality
	result.distance = result.distance
	result.weapon = result.weapon
	local name = tostring(player.playername)
	local score = tostring(result.quality)
	local weapon = tostring(result.weapon)
	local distance = tonumber(string.format("%.2f", result.distance))
	dcsbot.sendBotMessage(name ..
		' has completed their ' ..
		weapon ..
		' run on Range 62A their grading was ' .. score .. ' at ' .. distance .. ' meters from the bull ') -- results
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
	player.playername = player.playername
	result.roundsQuality = result.roundsQuality
	result.roundsHit = result.roundsHit
	local name = tostring(player.playername)
	local score = tostring(result.roundsQuality)
	local hits = tonumber(result.roundsHit)
	dcsbot.sendBotMessage(name ..
		' has completed a strafe pass on Range 62A, Accuracy was graded as ' ..
		score .. ' with ' .. hits .. ' rounds on target ') -- results
end