-- BASE:TraceClass("FOX")
-- Create protected FOX missile range for NTTR

-- Add new Fox
local foxMissiles = FOX:New()

local blackjackZone = ZONE_POLYGON:NewFromGroupName("Blackjack")
local joshuaZone = ZONE_POLYGON:NewFromGroupName("Joshua")

-- Add training zones.
foxMissiles:AddSafeZone(blackjackZone)
foxMissiles:AddSafeZone(joshuaZone)

-- Add monitored Launch Zones
foxMissiles:AddLaunchZone(blackjackZone)
foxMissiles:AddLaunchZone(joshuaZone)

-- Configure Fox defaults, can be switched via the F10 menu for each player
foxMissiles:SetDefaultLaunchMarks(false)
foxMissiles:SetDefaultLaunchAlerts(false)

-- Adjust explosion distance for missiles to help with head on aspect engagments
foxMissiles:SetExplosionDistance(200)
foxMissiles:SetExplosionDistanceBigMissiles(500, 50)

-- Protect AI Traffic
local protected = SET_GROUP:New()
protected:FilterPrefixes({ "C5 Nellis", "DA727", "AA727", "AA737", "U727", "B1B Ton-Creech", "F-16 Ton-Creech",
    "F-16 Nellis-Ton", "F-4E Nellis-Ton", "F-14B Nellis-Nellis", "Recon" })
protected:FilterStart()
foxMissiles:SetProtectedGroupSet(protected)

-- Start missile trainer.
foxMissiles:Start()

function foxMissiles:OnAfterEnterSafeZone(From, Event, To, Player)
    local player = Player

    MESSAGE:New(player.name .. " you have entered a missile safe zone"):ToClient(player.client)

    dcsbot.sendBotMessage(player.name .. ' has entered a missile safe zone')
end

function foxMissiles:OnAfterExitSafeZone(From, Event, To, Player)
    local player = Player

    MESSAGE:New(player.name .. " you have left a missile safe zone"):ToClient(player.client)

    dcsbot.sendBotMessage(player.name .. ' has left a missile safe zone')
end

function foxMissiles:OnAfterMissileLaunch(From, Event, To, missile)
    if missile.targetPlayer ~= nil then
        dcsbot.sendBotMessage(missile.missileType ..
            ' launched at ' .. missile.targetPlayer .. ' by ' .. missile.shooterName)
    else
        dcsbot.sendBotMessage(missile.missileType ..
            ' launched at ' .. missile.targetName .. ' by ' .. missile.shooterName)
    end
end

function foxMissiles:OnAfterMissileDestoyed(From, Event, To, missile)
    if missile.targetPlayer ~= nil then
        dcsbot.sendBotMessage(missile.missileType ..
            ' launched at ' .. missile.targetPlayer .. ' by ' .. missile.shooterName .. ' has been destroyed')
    else
        dcsbot.sendBotMessage(missile.missileType ..
            ' launched at ' .. missile.targetName .. ' by ' .. missile.shooterName .. ' has been destroyed')
    end
end
