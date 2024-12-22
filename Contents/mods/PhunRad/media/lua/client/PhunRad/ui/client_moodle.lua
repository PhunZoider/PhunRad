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
function PR.moodles:getRadsMoodle(player)
    return mf.getMoodle(PR.name, player and player:getPlayerNum())
end

function PR.moodles:updateRadMoodle(player, data)

    local pd = data or player:getModData().PhunRad or {}
    local moodle = mf.getMoodle(PR.name, player and player:getPlayerNum())

    if pd.rads < 0 then
        pd.rads = 0
    end

    if pd.rads > 100 then
        moodle:setValue(.2)
    elseif pd.rads > 50 then
        moodle:setValue(.30)
    elseif pd.rads > 10 then
        moodle:setValue(.5)
    else
        moodle:setValue(0)
    end

    if pd.rate then
        if pd.rate > 0 then
            moodle:setChevronCount(pd.rate)
            moodle:setChevronIsUp(true)
        elseif pd.rate < 0 then
            moodle:setChevronCount(math.abs(pd.rate))
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
    moodle:setDescription(moodle:getGoodBadNeutral(), moodle:getLevel(), txt)
    moodle.disable = not ((pd.rads or 0) > 0 or (pd.rate or 0) > 0)
end

