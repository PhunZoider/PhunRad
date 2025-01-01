require "MF_ISMoodle"
local mf = MF
local PR = PhunRad
mf.createMoodle(PR.name)

PR.moodles = {}
local inied = {}
function PR.moodles:getRadsMoodle(player)

    local moodle = mf.getMoodle(PR.name, player and player:getPlayerNum())

    if not inied[tostring(player)] then

        moodle:setThresholds(0.1, 0.4, 0.6, 0.9, 0.9, 0.95, 0.97, 1)
        inied[tostring(player)] = true
    end

    return moodle
end

local function formatNumber(number)
    number = number or 0
    -- Round the number to remove the decimal part
    local roundedNumber = math.floor(number + 0.005)
    -- Convert to string and format with commas
    local formattedNumber = tostring(roundedNumber):reverse():gsub("(%d%d%d)", "%1,")
    formattedNumber = formattedNumber:reverse():gsub("^,", "")
    return formattedNumber
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
            moodle:setChevronIsUp(data.rate < 0)
        elseif data.rate < 0 then
            moodle:setChevronCount(math.abs(data.rate))
            moodle:setChevronIsUp(true)
        else
            moodle:setChevronCount(0)
        end
    else
        moodle:setChevronCount(0)
    end
    local tbl = {}
    if pd.iodineExp then
        table.insert(tbl, getText("IGUI_PhunRad_IodineStrength", PR.settings.IodineStrength))
        local expin = pd.iodineExp - math.floor(getGameTime():getWorldAgeHours() + 0.005)
        if expin < 0 then
            table.insert(tbl, getText("IGUI_PhunRad_IodineExpiresSoon"))
        elseif expin < 2 then
            table.insert(tbl, getText("IGUI_PhunRad_IodineExpiresInAnHour"))
        else
            table.insert(tbl, getText("IGUI_PhunRad_IodineExpiresInXHours", formatNumber(expin, true)))
        end
    end
    if data.activeGeiger then
        table.insert(tbl, getText("IGUI_PhunRad_YourRadiation", formatNumber(pd.rads)))
    end
    if data.itemRads then
        table.insert(tbl, getText("IGUI_PhunRad_ItemRadiation", formatNumber(data.itemRads)))
    end
    if (#(data.clothingProtectionItems or {})) > 0 then
        table.insert(tbl, getText("IGUI_PhunRad_ClothingProtection", formatNumber(data.clothingProtection)))
    end
    for _, v in ipairs(data.clothingProtectionItems or {}) do
        table.insert(tbl, " - " .. tostring(v.name) .. ": " .. tostring(v.protection))
    end
    moodle:setDescription(moodle:getGoodBadNeutral(), moodle:getLevel(), #tbl > 0 and table.concat(tbl, "\n") or "")
    moodle.disable = pd.iodineExp == nil

end

