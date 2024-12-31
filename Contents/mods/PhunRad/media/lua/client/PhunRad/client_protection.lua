if isServer() then
    return
end
local PR = PhunRad

local protectiveClothing = {
    ["HazmatGloves"] = 20,

    ["HazmatSuit"] = 100,
    ["HazmatSuit2"] = 100,
    ["MysteriousHazmat"] = 100,

    ["CEDAHazmatSuit"] = 100,
    ["CEDAHazmatSuitRed"] = 100,
    ["CEDAHazmatSuitBlue"] = 100,
    ["CEDAHazmatSuitBlack"] = 100,

    ["HazmatSuit2NoMask"] = 75,
    ["HazmatSuitCEDANoMask"] = 75,
    ["CEDAHazmatSuitBlackNoMask"] = 75,
    ["CEDAHazmatSuitRedNoMask"] = 75,
    ["CEDAHazmatSuitBlueNoMask"] = 75,

    ["HazmatSuit2NoShoes"] = 75,
    ["HazmatSuitCEDANoShoes"] = 75,
    ["CEDAHazmatSuitBlackNoShoes"] = 75,
    ["CEDAHazmatSuitRedNoShoes"] = 75,
    ["CEDAHazmatSuitBlueNoShoes"] = 75,

    ["HazmatSuit2NoMaskNoShoes"] = 50,
    ["HazmatSuitCEDANoMaskNoShoes"] = 50,
    ["CEDAHazmatSuitBlackNoMaskNoShoes"] = 50,
    ["CEDAHazmatSuitRedNoMaskNoShoes"] = 50,
    ["CEDAHazmatSuitBlueNoMaskNoShoes"] = 50

}

local radioactiveItems = {
    ["Nails"] = 1,
    ["Base.NUC_Items.NUC_NuclearRod"] = 20,
    ["Base.NUC_Items.NUC_Waste"] = 30
}

local function getItemProtection(item)
    local base = protectiveClothing[item:getType()]
    if not base then
        return nil
    end
    local itemProtection = ((PR.settings.HazmatStrength or 100) * .01) * (protectiveClothing[item:getType()] or 50)
    return itemProtection -
               (itemProtection * ((item:getHolesNumber() or 0) * ((PR.settings.HazmatStrengthLossPerHole or 20) * .01)))
end

function PR:getRadioactiveItems(player)

    local data = self:getPlayerData(player)
    if not data or (data.invUpdated or 0) < (data.lastItemCalc or 0) then
        -- inventory not updated since last calculation so just use that
        return data.items or {}, data.itemRads or 0
    end
    print("=> Calculating Radioactive Items")
    -- get all items in surrounding containers
    local loot = getPlayerLoot(player:getPlayerNum())
    local radiatedItems = {}
    local radiatedLevels = 0
    local containers = loot.inventoryPane.inventoryPage.backpacks
    local itemList = ArrayList.new();
    for k, v in pairs(containers) do
        local container = v.inventory
        if container then
            for k, v in pairs(radioactiveItems) do
                local items = container:getItemsFromType(k)
                if items:size() > 0 then
                    if not radiatedItems[k] then
                        radiatedItems[k] = {
                            count = 0,
                            level = 0
                        }
                    end
                    radiatedItems[k].count = radiatedItems[k].count + items:size()
                    radiatedItems[k].level = radiatedItems[k].level + (items:size() * v)
                    radiatedLevels = radiatedLevels + (items:size() * v)
                end
            end
        end
    end

    -- get all items in players inventory
    for k, v in pairs(radioactiveItems) do
        local items = player:getInventory():getAllTypeRecurse(k)

        if items:size() > 0 then
            if not radiatedItems[k] then
                radiatedItems[k] = {
                    count = 0,
                    level = 0
                }
            end
            radiatedItems[k].count = radiatedItems[k].count + items:size()
            radiatedItems[k].level = radiatedItems[k].level + (items:size() * v)
            radiatedLevels = radiatedLevels + (items:size() * v)
        end

    end
    data.lastItemCalc = getTimestamp()
    data.items = radiatedItems
    data.itemRads = radiatedLevels

    return radiatedItems, radiatedLevels

end

-- local old_ISCraftingUI_getContainers = ISCraftingUI.getContainers
-- function ISCraftingUI:getContainers()
--     local result = old_ISCraftingUI_getContainers(self)
--     print("=> ISCraftingUI:getContainers()")
--     -- If ProxInv is enabled:
--     -- local localContainer = ISInventoryPage.GetLocalContainer(self.playerNum)
--     -- self.containerList:remove(localContainer);
--     return result
-- end

local old_ISInventoryPaneContextMenu_getContainers = ISInventoryPaneContextMenu.getContainers
ISInventoryPaneContextMenu.getContainers = function(character)
    print("=> ISInventoryPaneContextMenu.getContainers()")
    local containerList = old_ISInventoryPaneContextMenu_getContainers(character)
    -- local localContainer = ISInventoryPage.GetLocalContainer(character:getPlayerNum())
    -- -- If ProxInv is enabled:
    -- containerList:remove(localContainer);

    return containerList;
end

function PR:updatePlayersClothingProtection(player)

    local data = self:getPlayerData(player)
    local items = player:getWornItems()

    data.clothingProtection = 0
    data.clothingProtectionItems = {}

    for count = 0, items:size() - 1 do
        local clothingItem = items:getItemByIndex(count)
        local clothingItemType = clothingItem:getType()
        if protectiveClothing[clothingItemType] then
            print("=> Clothing Protection: " .. tostring(count) .. "=" .. clothingItemType)
            local protection = getItemProtection(clothingItem) or 0
            table.insert(data.clothingProtectionItems, {
                slot = count,
                type = clothingItemType,
                name = clothingItem:getDisplayName(),
                protection = protection
            })

            data.clothingProtection = data.clothingProtection + getItemProtection(clothingItem) or 0
        end
    end
    if data.clothingProtection < 0 then
        data.clothingProtection = 0
    end
    data.activeGeiger = false -- reset active geiger flag
    local items = player:getInventory():getItemsFromType("GeigerCounter", true)
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local isActivated = item:isActivated()
        if isActivated then
            item:Use()
            if not self.settings.GeigerMustBeEquippedToHear or (item:isEquipped() or item:getAttachedSlot() > 0) then
                data.activeGeiger = true
                break
            end

        end
    end
    return data.clothingProtection
end

local original_render = ISToolTipInv.render;
ISToolTipInv.render = function(self)

    local type = self.item:getType()
    local txt = nil
    local total = nil
    local isGeiger = type == "GeigerCounter"

    if not protectiveClothing[type] and not radioactiveItems[type] and not isGeiger then
        original_render(self)
        return
    elseif isGeiger then

        if self.item:isActivated() then
            -- print("player ", tostring(self.owner.player or self.owner.playerNum))
            local p = getSpecificPlayer(self.owner.player or self.owner.playerNum)
            if p and instanceof(p, "IsoPlayer") then
                local data = PR:getPlayerData(p)
                txt = data and "Radiation level " .. tostring(data.rads or "None")
            end
        else
            txt = "Activate for radiation detection"
        end
    elseif radioactiveItems[type] then
        txt = getText("IGUI_PhunRad_Radiation")
        total = radioactiveItems[type]
    else
        txt = getText("IGUI_PhunRad_Protection")
        total = getItemProtection(self.item)
    end

    local fontConfig = {
        Small = {
            y = 15,
            iconY = 2
        },
        Medium = {
            y = 20,
            iconY = 4
        },
        Large = {
            y = 20,
            iconY = 6
        }
    }
    local fontSize = getCore():getOptionTooltipFont();
    local th = self.tooltip:getHeight();
    local txtWidth = getTextManager():MeasureStringX(UIFont[getCore():getOptionTooltipFont()], txt)
    local height = fontConfig[fontSize].y * 1
    self:setY(self.tooltip:getY() + th);
    self:setHeight(height);
    self:drawRect(0, 0, self.width, self.height + 10, self.backgroundColor.a, self.backgroundColor.r,
        self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height + 10, self.borderColor.a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);
    local x = 15
    local y = th + 5
    self.tooltip:DrawText(self.tooltip:getFont(), txt, 5, y, 1, 1, 0.8, self.borderColor.a);
    if total ~= nil then
        self.tooltip:DrawText(self.tooltip:getFont(), tostring(total), x + txtWidth + 2, y, 1, 1, 1, self.borderColor.a)
    end
    original_render(self)

end
