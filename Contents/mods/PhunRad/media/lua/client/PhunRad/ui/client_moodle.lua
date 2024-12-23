require "MF_ISMoodle"
local mf = MF
local PR = PhunRad
mf.createMoodle(PR.name)

local radMapping = {{
    level = 99,
    value = .1,
    chevrons = 3
}, {
    level = 90,
    value = .2,
    chevrons = 2
}, {
    level = 80,
    value = .3,
    chevrons = 1
}, {
    level = 70,
    value = .4,
    chevrons = 0
}, {
    level = 60,
    value = .5,
    chevrons = 0
}, {
    level = 50,
    value = .6,
    chevrons = 0
}, {
    level = 40,
    value = .7,
    chevrons = 1
}, {
    level = 30,
    value = .8,
    chevrons = 2
}, {
    level = 20,
    value = .9,
    chevrons = 3
}}

PR.moodles = {}
local inied = {}
function PR.moodles:getRadsMoodle(player)

    local moodle = mf.getMoodle(PR.name, player and player:getPlayerNum())

    if not inied[tostring(player)] then

        moodle:setThresholds(0.1, 0.4, 0.6, 0.99, 1.1, 1.1, 1.1, 1.1) -- dont show till 99% and its bad?
        inied[tostring(player)] = true
    end

    return moodle
end

function PR.moodles:updateRadMoodle(player, data)

    local pd = data or player:getModData().PhunRad or {}
    local moodle = self:getRadsMoodle(player)
    if not moodle then
        return
    end

    local value = 1 - data.percent

    moodle:setValue(value)

    if data.rate then
        if data.rate > 0 then
            moodle:setChevronCount(data.rate)
            moodle:setChevronIsUp(data.rate > 0)
        elseif data.rate < 0 then
            moodle:setChevronCount(math.abs(data.rate))
            moodle:setChevronIsUp(false)
        else
            moodle:setChevronCount(0)
        end
    else
        moodle:setChevronCount(0)
    end
    local txt = "Radiation level: " .. PhunTools:formatWholeNumber(pd.rads)
    if pd.iodineExp then
        local expin = pd.iodineExp - getGameTime():getWorldAgeHours()
        if expin < 0 then
            txt = txt .. "\nIodine soon"
        elseif expin < 2 then
            txt = txt .. "\nIodine expires in an hour"
        else
            txt = txt .. "\nIodine expires in " .. PhunTools:formatWholeNumber(expin) .. " hours"
        end
    end
    local gb = moodle:getGoodBadNeutral()
    local lvl = moodle:getLevel()
    moodle:setDescription(gb, lvl, txt)
    local disable = value > .999 or (not ((pd.rads or 0) > 0 or (pd.rate or 0) > 0))
    -- print("Disable: " .. tostring(disable) .. " at " .. tostring(1 - data.percent) .. " value=" .. tostring(value))
    -- moodle.disable = disable
end

