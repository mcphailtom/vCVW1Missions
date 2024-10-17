local joshuaZone = ZONE_POLYGON:NewFromGroupName("Joshua")

local redIADS = MANTIS:New("RedIADSNetwork", "RSAM", "REWR", nil, "red", true)
redIADS:SetDetectInterval(15)
redIADS:AddZones({ joshuaZone }, {}, {})
redIADS:Debug(false)
redIADS:Start()
