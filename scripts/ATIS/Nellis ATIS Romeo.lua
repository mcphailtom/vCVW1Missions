local nellisAB = AIRBASE:FindByName(AIRBASE.Nevada.Nellis)

local FileName = "NellisATIS.ogg"
local FolderPath = [[D:\DCSData\ATIS\Romeo]]
local Duration = 21 -- Will use 3 seconds as default
local UseSrs = true
local InstallPathSrs = [[D:\DCS-SimpleRadio-Standalone]]
local Coordinate = nellisAB:GetCoordinate()

local nellisATIS = SOUNDFILE:New(FileName, FolderPath, Duration, UseSrs)
local msrs = MSRS:New(InstallPathSrs, 270.10, radio.modulation.AM)
msrs:SetCoordinate(Coordinate)

SCHEDULER:New(nil, function()
    msrs:PlaySoundFile(nellisATIS)
end, {}, 5, 30)