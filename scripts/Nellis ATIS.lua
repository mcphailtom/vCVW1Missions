local NellisAtis = UNIT:FindByName("Nellis ATIS")
local NellisAtisRadio = NellisAtis:GetRadio()

-- Set up the transmission
NellisAtisRadio:SetFrequency(270.10)
NellisAtisRadio:SetModulation(radio.modulation.AM)
NellisAtisRadio:SetPower(100)
NellisAtisRadio:SetFileName("NellisATIS.ogg")
NellisAtisRadio:SetLoop(false)

SCHEDULER:New(flightgroup, function()
    NellisAtisRadio:Broadcast()
end, {}, 5, 30)