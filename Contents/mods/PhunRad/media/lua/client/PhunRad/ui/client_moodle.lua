require "MF_ISMoodle"
local mf = MF
local PR = PhunRad
mf.createMoodle(PR.name)

PR.moodles = {}
local inied = {}

local function formatNumber(number)
    number = number or 0
    -- Round the number to remove the decimal part
    local roundedNumber = math.floor(number + 0.005)
    -- Convert to string and format with commas
    local formattedNumber = tostring(roundedNumber):reverse():gsub("(%d%d%d)", "%1,")
    formattedNumber = formattedNumber:reverse():gsub("^,", "")
    return formattedNumber
end

local function getDescription(player, goodBadNeutral, moodleLevel)
    local tbl = {}
    local pd = player:getModData().PhunRad
    if goodBadNeutral == 2 then
        -- bad?
        table.insert(tbl, getText("Moodles_PhunRad_Bad_desc_lvl" .. tostring(moodleLevel)))
    elseif goodBadNeutral == 1 then
        -- good?
        table.insert(tbl, getText("Moodles_PhunRad_Good_desc_lvl" .. tostring(moodleLevel)))
    else
        -- neutral?
        table.insert(tbl, getText("Moodles_PhunRad_Good_desc_lvl1"))
    end
    local hasIodine = pd.iodineExp and pd.iodineExp > getGameTime():getWorldAgeHours()
    local hasRad = pd.rads > 0
    if hasIodine then
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
    local hasGeiger = false
    local items = player:getInventory():getItemsFromType("GeigerCounter", true)
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local isActivated = item:isActivated()
        if isActivated then
            item:Use()
            if not PR.settings.GeigerMustBeEquippedToHear or (item:isEquipped() or item:getAttachedSlot() > 0) then
                hasGeiger = true
                break
            end
        end
    end
    pd.activeGeiger = hasGeiger
    if pd.activeGeiger then
        table.insert(tbl, getText("IGUI_PhunRad_YourRadiation", formatNumber(pd.rads)))
        if pd.itemRads then
            table.insert(tbl, getText("IGUI_PhunRad_ItemRadiation", formatNumber(pd.itemRads)))
        end
        if (#(pd.clothingProtectionItems or {})) > 0 then
            table.insert(tbl, getText("IGUI_PhunRad_ClothingProtection", formatNumber(pd.clothingProtection)))
        end
        for _, v in ipairs(pd.clothingProtectionItems or {}) do
            table.insert(tbl, " - " .. tostring(v.name) .. ": " .. tostring(v.protection))
        end
    end

    return table.concat(tbl, "\n")

end

function PR.moodles:getRadsMoodle(player)

    local moodle = mf.getMoodle(PR.name, player and player:getPlayerNum())

    if not inied[tostring(player)] then

        moodle:setThresholds(0.1, 0.4, 0.6, 0.95, 0.95000002, 0.97, 0.99, 1)
        local oldMoodleMouseover = moodle.mouseOverMoodle
        moodle.mouseOverMoodle = function(self, goodBadNeutral, moodleLevel)
            if self:isMouseOver() or self:isMouseOverMoodle() then
                self:setDescription(goodBadNeutral, moodleLevel, getDescription(player, goodBadNeutral, moodleLevel))
            end
            oldMoodleMouseover(self, goodBadNeutral, moodleLevel)
        end
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

    local hasIodine = pd.iodineExp and pd.iodineExp > getGameTime():getWorldAgeHours()
    local hasRad = pd.rads > 0

    if not hasIodine then
        if not pd.activeGeiger and pd.rads < 50 then
            -- no geiger activated so dont tell user right away
            moodle:setValue(0.95000001)
            return
        end
        -- effectively hide the moodle
        if (pd.radLevel or 0) < 1 then
            moodle:setValue(0.95000001)
            return
        end
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

    -- moodle:setDescription(moodle:getGoodBadNeutral(), moodle:getLevel(), #tbl > 0 and table.concat(tbl, "\n") or "")
    -- moodle.disable = pd.iodineExp == nil

end

