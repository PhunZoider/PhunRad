if isServer() then
    return
end
local PR = PhunRad
local gt = nil

function PR:getPlayerData(player)
    local data = player:getModData()
    if not data.PhunRad then
        data.PhunRad = {}
    end
    return data.PhunRad
end

function PR:updatePlayerRadLevel(player, radLevel)

    local pd = self:getPlayerData(player)
    pd.radLevel = radLevel or 0
    self:updatePlayer(player)

end

function PR:updateGeigerCounterSound(player)

    local data = self:getPlayerData(player)

    if data.playing and (data.radLevel == 0 or data.activeGeiger ~= true) then
        -- geiger sound was playing so stop it
        self:stopSound(player, data.playing)
        data.playing = nil
    elseif (data.radLevel or 0) > 0 and data.activeGeiger == true then
        -- wasn't playing, but rad level says it should be
        local sound = ""
        if data.radLevel < 30 then
            sound = "PhunRad_GeigerLow"
        elseif data.radLevel < 60 then
            sound = "PhunRad_GeigerMed"
        else
            sound = "PhunRad_Geiger"
        end
        if data.playing ~= sound then
            if data.playing then
                self:stopSound(player, data.playing)
            end
            data.playing = self:playSound(player, sound)
        end
    end
end

function PR:updatePlayer(player)

    if gt == nil then
        gt = GameTime:getInstance()
    end

    local data = self:getPlayerData(player)
    local lastLevel = data.lastLevel or 0 -- last strength of radiation affecting player
    local currentLevel = data.radLevel or 0 -- strength of radiation affecting player
    local rads = data.rads or 0 -- total accumulated rads

    if currentLevel > 0 then
        -- in radiated area. check for geiger counter
        local items = player:getInventory():getItemsFromType("GeigerCounter", true)
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            local isActivated = item:isActivated()
            if isActivated then
                -- item:Use()
                if not self.settings.GeigerMustBeEquippedToHear or (item:isEquipped() or item:getAttachedSlot() > 0) then
                    data.activeGeiger = true
                    break
                end

            end
        end
    end

    self:updateGeigerCounterSound(player)

    local adjustedLevel = currentLevel

    local radItems, itemRadAdj = self:getRadioactiveItems(player)
    adjustedLevel = adjustedLevel + itemRadAdj

    if data.iodineExp then
        adjustedLevel = currentLevel - self.settings.IodineStrength
    end
    adjustedLevel = adjustedLevel - (data.clothingProtection or 0)
    local items = player:getWornItems()

    local change = adjustedLevel * (self.settings.RadsPerMin * .01)
    rads = rads + change
    if change <= 0 then
        rads = rads - self.settings.RadsRecoveryPerMin
    end

    if rads < 0 then
        rads = 0
    elseif rads > self.settings.MaxRads then
        rads = self.settings.MaxRads
        player:getBodyDamage():setFoodSicknessLevel(100)
    end

    if rads > 0 then
        data.percent = rads / self.settings.MaxRads
    else
        data.percent = 0
    end
    player:getBodyDamage():setFoodSicknessLevel((data.percent * 100))

    if currentLevel > 49 then
        data.rate = 3
    elseif currentLevel > 24 then
        data.rate = 2
    elseif currentLevel > 9 then
        data.rate = 1
    elseif currentLevel < -50 then
        data.rate = -3
    elseif currentLevel < -35 then
        data.rate = -2
    elseif currentLevel < -15 then
        data.rate = -1
    else
        data.rate = 0
    end

    data.rads = rads
    data.lastLevel = currentLevel

    if data.iodineExp and data.iodineExp < gt:getWorldAgeHours() then
        data.iodineExp = nil
    end

    self.moodles:updateRadMoodle(player, data)

end

-- local cache
local playerSounds = {}

function PR:playSound(player, sound)
    sound = sound or "PhunRad_Geiger"
    local name = player:getUsername()

    if playerSounds[name] == nil then
        player:playSoundLocal(sound)
        playerSounds[name] = sound
    elseif playerSounds[name] ~= nil and not player:getEmitter():isPlaying(sound) then
        self:stopSound(player, playerSounds[name])
        player:playSoundLocal(sound)
        playerSounds[name] = sound
    end
    return sound
end

function PR:stopSound(player, sound)
    sound = sound or "PhunRad_Geiger"
    local name = player:getUsername()
    if playerSounds[name] then
        local s = playerSounds[name]
        if s and player:getEmitter():isPlaying(sound) then
            player:getEmitter():stopSoundByName(s)
        end
    end
    playerSounds[name] = nil

end
