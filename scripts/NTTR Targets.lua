local OutpostStatics = SET_STATIC:New():FilterCoalitions("red"):FilterPrefixes("IADS Fortified Target Outpost"):FilterStart()


MobileGroup = SPAWN:New("Mobile Targets")
:InitKeepUnitNames()
:OnSpawnGroup(
    function(spawngrp)
        local MBGroupAG = ARMYGROUP:New(spawngrp)
    end
)
:Spawn()