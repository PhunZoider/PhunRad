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

function ISInventoryTransferAction:waitToStart()
    return false
end

local oldISInventoryTransferActionStop = ISInventoryTransferAction.stop
function ISInventoryTransferAction:stop()
    oldISInventoryTransferActionStop(self)
end

local oldISInventoryPaneGetActualItems = ISInventoryPane.getActualItems
function ISInventoryPane.getActualItems(items)
    local itemsTmp = oldISInventoryPaneGetActualItems(items)
    for _, item in ipairs(itemsTmp) do
        if not item:getAttachedSlotType() then
        end
    end
    return itemsTmp
end

local oldISInventoryPaneDraggedItemsReset = ISInventoryPaneDraggedItems.reset
function ISInventoryPaneDraggedItems:reset()
    if self.items then
        for _, item in ipairs(self.items) do

        end
    end
    oldISInventoryPaneDraggedItemsReset(self)
end

