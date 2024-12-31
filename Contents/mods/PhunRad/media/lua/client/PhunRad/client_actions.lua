local PR = PhunRad
local gt = nil
function OnEat_Iodine(food, player, percentage)
    if gt == nil then
        gt = GameTime:getInstance()
    end
    local pd = PR:getPlayerData(player)
    if (pd.iodineExp or 0) then
        pd.iodineExp = gt:getWorldAgeHours()
    end
    pd.iodineExp = pd.iodineExp + (PR.settings.IodineHours or 5)
end
-- function IodineTake(items, result, player)
--     if gt == nil then
--         gt = GameTime:getInstance()
--     end
--     local pd = PR:getPlayerData(player)
--     if (pd.iodineExp or 0) then
--         pd.iodineExp = gt:getWorldAgeHours()
--     end
--     pd.iodineExp = pd.iodineExp + (PR.settings.IodineHours or 5)
-- end

function ISInventoryTransferAction:waitToStart()
    print("ISInventoryTransferAction:waitToStart() - self.item:getName()=" .. self.item:getName())
    return false
end

local oldISInventoryTransferActionStop = ISInventoryTransferAction.stop
function ISInventoryTransferAction:stop()
    oldISInventoryTransferActionStop(self)
    print("ISInventoryTransferAction:stop() - self.item:getName()=" .. self.item:getName())
end

local oldISInventoryPaneGetActualItems = ISInventoryPane.getActualItems
function ISInventoryPane.getActualItems(items)
    local itemsTmp = oldISInventoryPaneGetActualItems(items)
    for _, item in ipairs(itemsTmp) do
        if not item:getAttachedSlotType() then
            print("ISInventoryPane.getActualItems() - item:getName()=" .. item:getName() ..
                      ", item:getAttachedSlotType()=nil")
        end
    end
    return itemsTmp
end

local oldISInventoryPaneDraggedItemsReset = ISInventoryPaneDraggedItems.reset
function ISInventoryPaneDraggedItems:reset()
    if self.items then
        for _, item in ipairs(self.items) do
            if item:getAttachedSlotType() then
                local chr = getSpecificPlayer(self.playerNum)
                print("ISInventoryPaneDraggedItems:reset() - item:getName()=" .. item:getName() ..
                          ", item:getAttachedSlotType()=" .. item:getAttachedSlotType())
            else
                print("ISInventoryPaneDraggedItems:reset()2 - item:getName()=" .. item:getName() ..
                          ", item:getAttachedSlotType()=nil")
            end
        end
    end
    oldISInventoryPaneDraggedItemsReset(self)
end

