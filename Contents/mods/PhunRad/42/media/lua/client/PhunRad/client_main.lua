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

function PR:updatePlayerZone(player, zone)

    local pd = self:getPlayerData(player)

    local radLevel = zone.rads or 0

    if pd.playing and radLevel == 0 then
        -- geiger sound was playing so stop it
        self:stopSound(player, pd.playing)
        pd.playing = nil

    elseif radLevel > 0 then
        -- wasn't playing, but rad level says it should be
        local sound = ""
        if radLevel < 30 then
            sound = "PhunRad_GeigerLow"
        elseif radLevel < 60 then
            sound = "PhunRad_GeigerMed"
        else
            sound = "PhunRad_Geiger"
        end
        if pd.playing ~= sound then
            if pd.playing then
                self:stopSound(player, pd.playing)
            end
            pd.playing = self:playSound(player, sound)
        end
    end

    pd.radLevel = radLevel
    self:updatePlayer(player)
end

function PR:updatePlayer(player)

    if gt == nil then
        gt = GameTime:getInstance()
    end

    local pd = self:getPlayerData(player)
    local lastLevel = pd.lastLevel or 0
    local currentLevel = pd.radLevel or 0
    local rads = pd.rads or 0

    local adjustedLevel = currentLevel
    if pd.iodineExp then
        adjustedLevel = currentLevel - self.settings.IodineStrength
    end

    local change = adjustedLevel * (self.settings.RadsPerMin * .01)
    rads = rads + change
    if change <= 0 then
        rads = rads - self.settings.RadsRecoveryPerMin
    end
    if currentLevel > 80 then
        pd.rate = 3
    elseif currentLevel > 50 then
        pd.rate = 2
    elseif currentLevel > 10 then
        pd.rate = 1
    end

    pd.rads = rads
    pd.lastLevel = currentLevel

    if pd.iodineExp and pd.iodineExp < gt:getWorldAgeHours() then
        print("Iodine Expired")
        pd.iodineExp = nil
    end

    self.moodles:updateRadMoodle(player, pd)

end

local playerSounds = {}

function PR:playSound(player, sound)
    sound = sound or "PhunRad_Geiger"
    local name = player:getUsername()

    if playerSounds[name] == nil then
        print("Playing sound: " .. sound)
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
