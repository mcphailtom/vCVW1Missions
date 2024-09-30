
local joshuaZone = ZONE_POLYGON:NewFromDrawing("Joshua")
local RedIADSSet = SET_GROUP:New():FilterCoalitions("red"):FilterPrefixes({"RSAM","REWR"}):FilterActive((false)):FilterStart()

RedIADSSet:ForEachGroup(function(group)
    local IADSGroup = SPAWN:New( group.GroupName )
    :InitKeepUnitNames()
    :OnSpawnGroup(
        function(spawngrp)
            -- Add the ARMYGROUP to the IADS List
            local IADSGroupAG = ARMYGROUP:New(spawngrp)
        end
    )
    :Spawn()
end
)

local redIADS = MANTIS:New("RedIADSNetwork","RSAM","REWR",nil,"red",true)
redIADS:SetDetectInterval(15)
redIADS:AddZones({joshuaZone},{},{})
redIADS:Debug(false)
redIADS:Start()
