ZoneTableSA10 = { ZONE:New("SA-10-1"), ZONE:New("SA-10-2"), ZONE:New("SA-10-3"), ZONE:New("SA-10-4"), ZONE:New("SA-10-5"), ZONE:New("SA-10-6"), 
    ZONE:New("SA-10-7"), ZONE:New("SA-10-8"), ZONE:New("SA-10-9"), ZONE:New("SA-10-10")}
Spawn_SAM10 = SPAWN:New("RSAM SA-10 Complex Triggered"):InitLimit(18, 1)
Spawn_SAM10:InitRandomizeZones(ZoneTableSA10)
Spawn_SAM10:Spawn()
