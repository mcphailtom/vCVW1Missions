-- Create protected FOX missile range for NTTR

-- Add new Fox
local foxAir = FOX:New()

local joshuaZone = ZONE_POLYGON:NewFromDrawing("Blackjack")

-- Add training zones.
foxAir:AddSafeZone(joshuaZone)

-- Add monitored Launch Zones
foxAir:AddLaunchZone(joshuaZone)

-- Configure Fox defaults, can be switched via the F10 menu for each player
foxAir:SetDefaultLaunchMarks(false)
foxAir:SetDefaultLaunchAlerts(false)

-- Adjust explosion distance for missiles to help with head on aspect engagments
foxAir:SetExplosionDistance(200)
foxAir:SetExplosionDistanceBigMissiles(500, 50)

-- Protect AI Traffic
local protected = SET_GROUP:New()
protected:FilterPrefixes({ "C5 Nellis", "DA727", "AA727", "AA737", "U727", "B1B Ton-Creech", "F-16 Ton-Creech", "F-16 Nellis-Ton", "F-4E Nellis-Ton", "F-14B Nellis-Nellis" })
protected:FilterStart()
foxAir:SetProtectedGroupSet(protected)

-- Start missile trainer.
foxAir:Start()

function foxAir:OnAfterEnterSafeZone(From, Event, To, Player)
    local player = Player

    MESSAGE:New( player.name .. " you have entered the Blackjack missile safe zone" ):ToClient( player.client )

    dcsbot.sendBotMessage(player.name .. ' has entered the Blackjack missile safe zone')
end

function foxAir:OnAfterExitSafeZone(From, Event, To, Player)
    local player = Player

    MESSAGE:New( player.name .. " you have left the Blackjack missile safe zone" ):ToClient( player.client )

    dcsbot.sendBotMessage(player.name .. ' has left the Blackjack missile safe zone')
end
