if isServer() then
    return
end
require "TimedActions/ISInventoryTransferAction"
local Commands = require "PhunRad/client_commands"
local PR = PhunRad
local PZ = PhunZones

local deferredContainerToRecalc = {}
local deferredClothingToRecalc = {}
local deferredItemsToRecalc = {}

local radioactiveItems = {
    ["NUC_Items.NUC_NuclearRod"] = 20,
    ["NUC_Items.NUC_Waste"] = 30,
    ["Base.Nails"] = 1
}
local doRecalcItems = false
-- Hook the original New Inventory Transfer Method
local originalNewInventoryTransaferAction = ISInventoryTransferAction.new
function ISInventoryTransferAction:new(player, item, srcContainer, destContainer, time)

    if radioactiveItems[item:getFullType()] then
        deferredItemsToRecalc[player] = true
    end

    -- deferredContainerToRecalc[srcContainer] = true
    -- deferredContainerToRecalc[destContainer] = true
    -- otherwise, just do the transfer by passing parms back to original method
    return originalNewInventoryTransaferAction(self, player, item, srcContainer, destContainer, time)
end

Events[PZ.events.OnPhunZonesPlayerLocationChanged].Add(function(player, zone)
    local radLevel = zone and zone.rads or 0
    local previousRadLevel = PR:getPlayerData(player).radLevel or 0
    if zone and zone.isVoid then
        -- lets not let them espcape by running into RV!
        PR:updatePlayerRadLevel(player, previousRadLevel)
    else
        PR:updatePlayerRadLevel(player, radLevel)
    end

end)

local currentMinuteAction = 0
Events.EveryOneMinute.Add(function()

    local action = (currentMinuteAction - 1) % 3
    if action == 0 then
        local players = PR:onlinePlayers()
        for i = 0, players:size() - 1 do
            local p = players:get(i)
            PR:updatePlayer(p)
        end
    elseif action == 1 and doRecalcItems then
        for player, _ in pairs(deferredItemsToRecalc) do
            PR:getRadioactiveItems(player)
            deferredItemsToRecalc[player] = nil
        end
        -- local players = PR:onlinePlayers()
        -- for i = 0, players:size() - 1 do
        --     local p = players:get(i)
        --     PR:getRadioactiveItems(p)
        -- end
        -- PR:recalcDeferredContainers(deferredContainerToRecalc)
    else
        PR:recalcDeferredClothingUpdates(deferredClothingToRecalc)
        currentMinuteAction = 0
    end
    currentMinuteAction = currentMinuteAction + 1
end)

Events.OnFillInventoryObjectContextMenu.Add(function(playerNum, context, items)

    local item = nil
    local playerObj = getSpecificPlayer(playerNum)
    for i = 1, #items do
        if not instanceof(items[i], "InventoryItem") then
            item = items[i].items[1]
        else
            item = items[i]
        end

        if item then
            local itemType = item:getType()
            if itemType == "GeigerCounter" then

                local isActivated = item:isActivated() and item:getDelta() > 0
                local isEquipped = (item:isEquipped() or item:getAttachedSlot() > 0)
                local hasJuice = item:getDelta() > 0
                if not hasJuice and isActivated then
                    -- item:setActivated(false)
                    -- playerObj:getModData().PhunRad.activeGeiger = false
                    isActivated = false
                end
                local txt = "Turn On!"
                if isActivated then
                    txt = "Turn Off!"
                end

                local option = context:addOptionOnTop(txt, playerObj, function()
                    local instance = ISTimedActionQueue.add(ISGeigerAction:new(
                        isActivated and "ToggleOff" or "ToggleOn", playerObj, item))

                    local fn = function()
                        if instance then
                            instance:stop()
                        end
                    end
                    Events.EveryOneMinute.Add(fn)
                    -- item:setActivated(not isActivated)
                    -- playerObj:playSound(isActivated and "TelevisionOff" or "TelevisionOn")
                    -- playerObj:getModData().PhunRad.activeGeiger = not isActivated
                end)

                local toolTip = ISToolTip:new();
                toolTip:setVisible(false);
                toolTip:setName("Geiger Counter");
                option.notAvailable = not isEquipped or not hasJuice
                if not isEquipped then
                    toolTip.description = getTextOrNull("Tooltip_Item_Geiger") or "Equip and turn on to detect rads"
                elseif not hasJuice then
                    toolTip.description = getTextOrNull("Tooltip_Item_GeigerNoBattery") or "No battery power"
                end
                option.toolTip = toolTip;
            end
        end
    end
end)

Events.OnPreFillWorldObjectContextMenu.Add(function(playerNum, context, worldobjects, test)

    if isAdmin() or isDebugEnabled() then
        local player = playerNum and getSpecificPlayer(playerNum) or getPlayer()
        local data = PR:getPlayerData(player)
        local adminOption = context:addOption("PhunRad", worldobjects, nil)
        local adminSubMenu = ISContextMenu:getNew(context)
        local targetPlayer = player
        for _, wObj in ipairs(worldobjects) do
            local square = wObj:getSquare()
            for i = square:getMovingObjects():size(), 1, -1 do
                if instanceof(square:getMovingObjects():get(i - 1), "IsoPlayer") then
                    targetPlayer = square:getMovingObjects():get(i - 1)
                    break
                end
            end
        end

        adminSubMenu:addOption(getText("IGUI_PhunRad_RemovePlayerRads", targetPlayer:getUsername(),
            tostring(data.radLevel or 0), tostring(data.rads or 0)), player, function()
            sendClientCommand(PR.name, PR.commands.setPlayerRadLevel, {targetPlayer:getUsername(), 0, false})
        end)
        context:addSubMenu(adminOption, adminSubMenu)
    end
end)

Events.OnRefreshInventoryWindowContainers.Add(function(invSelf, state)
    if state == "end" then
        -- update last inventory update time because inventory around player has changed
        local playerObj = getSpecificPlayer(invSelf.player)
        local data = PR:getPlayerData(playerObj)
        data.invUpdated = getTimestamp()
    end
end)

Events.OnServerCommand.Add(function(module, command, arguments)
    if module == PR.name and Commands[command] then
        Commands[command](arguments)
    end
end)

local function setup()
    Events.OnTick.Remove(setup)
    PR:ini()
    local players = PR:onlinePlayers()
    for i = 0, players:size() - 1 do
        local p = players:get(i)
        if p:isLocalPlayer() then
            local data = PR:getPlayerData(p)
            if data then
                if data.playing then
                    data.playing = false
                end
                PR:updatePlayersClothingProtection(p)
                PR:updatePlayerRadLevel(p, data.radLevel)
            end
        end
    end
end

Events.OnTick.Add(setup)

Events.OnClothingUpdated.Add(function(player)
    print("=> OnClothingUpdated ", tostring(player))
    if player:isLocalPlayer() then
        deferredClothingToRecalc[player] = true
    end
end)

-- local nextCheck = getTimestamp() + 5
-- Events.OnRefreshInventoryWindowContainers.Add(function(invSelf, state)
--     if state == "end" and (PR.settings.RadiatedItemFrequency or getTimestamp()) > 0 and nextCheck < getTimestamp() then
--         nextCheck = getTimestamp() + PR.settings.RadiatedItemFrequency
--         local playerObj = getSpecificPlayer(invSelf.player)
--         PR:getRadioactiveItems(playerObj)
--     end

-- end)

Events.OnRainStart.Add(function(a, b, c)
    print("=> OnRainStart ", tostring(a), tostring(b), tostring(c))
end)

Events.OnRainStop.Add(function(a, b, c)
    print("=> OnRainStop ", tostring(a), tostring(b), tostring(c))
end)

Events.OnWeatherPeriodStart.Add(function(a, b, c)
    print("=> OnWeatherPeriodStart ", tostring(a), tostring(b), tostring(c))
end)

Events.OnWeatherPeriodStop.Add(function(a, b, c)
    print("=> OnWeatherPeriodStop ", tostring(a), tostring(b), tostring(c))
end)

Events.OnChangeWeather.Add(function(a, b, c)
    print("=> OnChangeWeather ", tostring(a), tostring(b), tostring(c))
end)

Events.OnRadioInteraction.Add(function(a, b, c)
    print("=> OnRadioInteraction ", tostring(a), tostring(b), tostring(c))
end)
