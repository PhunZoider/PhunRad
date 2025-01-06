if isServer() then
    return
end
local Commands = require "PhunRad/client_commands"
local PR = PhunRad
local PZ = PhunZones
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

Events.EveryOneMinute.Add(function()
    for i = 0, getOnlinePlayers():size() - 1 do
        local p = getOnlinePlayers():get(i)
        if p:isLocalPlayer() then
            PR:updatePlayer(p)
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
    for i = 0, getOnlinePlayers():size() - 1 do
        local p = getOnlinePlayers():get(i)
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
        PR:updatePlayersClothingProtection(player)
        PR:updatePlayer(player)
    end
end)

local nextCheck = getTimestamp() + 5
Events.OnRefreshInventoryWindowContainers.Add(function(invSelf, state)
    if state == "end" and (PR.settings.RadiatedItemFrequency or getTimestamp()) > 0 and nextCheck < getTimestamp() then
        nextCheck = getTimestamp() + PR.settings.RadiatedItemFrequency
        local playerObj = getSpecificPlayer(invSelf.player)
        PR:getRadioactiveItems(playerObj)
    end

end)

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
