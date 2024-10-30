local debug = false

local redIADS = SkynetIADS:create('redIADS')
redIADS:addSAMSitesByPrefix('RSAM')
redIADS:addEarlyWarningRadarsByPrefix('REWR')

local sa10_1 = redIADS:getSAMSiteByGroupName('RSAM SA-10 Complex-1')
sa10_1:setGoLiveRangeInPercent(90)
sa10_1:setActAsEW(true)

local sa10_2 = redIADS:getSAMSiteByGroupName('RSAM SA-10 Complex-2')
sa10_2:setGoLiveRangeInPercent(90)


if debug then
    local iadsDebug = redIADS:getDebugSettings()
    iadsDebug.IADSStatus = true
    iadsDebug.radarWentDark = true
    iadsDebug.contacts = true
    iadsDebug.radarWentLive = true
    iadsDebug.noWorkingCommmandCenter = true
    iadsDebug.samNoConnection = true
    iadsDebug.jammerProbability = true
    iadsDebug.addedEWRadar = true
    iadsDebug.harmDefence = true
end

--SAM site will only go live if the contact not a civilian aircraft.
local function civilianGoLiveConstraint(contact)
    name = contact:getName()

    if string.find(name, "Recon") then
        return false
    end

    if string.find(name, "DA727") then
        return false
    end

    if string.find(name, "AA727") then
        return false
    end

    if string.find(name, "AA737") then
        return false
    end

    if string.find(name, "U727") then
        return false
    end

    if string.find(name, "B1B Ton-Creech") then
        return false
    end

    if string.find(name, "F-16 Ton-Creech") then
        return false
    end

    if string.find(name, "F-16 Nellis-Ton") then
        return false
    end

    if string.find(name, "F-4E Nellis-Ton") then
        return false
    end

    if string.find(name, "F-15E Nellis-Creech") then
        return false
    end

    return true
end

redIADS:getSAMSites():addGoLiveConstraint('ignore_civilian_planes', civilianGoLiveConstraint)


redIADS:removeRadioMenu()
redIADS:activate()
