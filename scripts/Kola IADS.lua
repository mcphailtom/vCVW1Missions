local debug = false

local redIADS = SkynetIADS:create('redIADS')
redIADS:addSAMSitesByPrefix('RSAM')
redIADS:addEarlyWarningRadarsByPrefix('REWR')


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

    return true
end

redIADS:getSAMSites():addGoLiveConstraint('ignore_civilian_planes', civilianGoLiveConstraint)


redIADS:removeRadioMenu()
redIADS:activate()
