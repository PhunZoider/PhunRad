if not isClient() then
    return
end
local Commands = require "PhunRad/client_commands"
local PR = PhunRad
local PZ = PhunZones
Events[PZ.events.OnPhunZonesPlayerLocationChanged].Add(function(player, zone)
    PR:updatePlayerZone(player, zone)
end)

-- Events.OnCreatePlayer.Add(function(playerIndex)

--     print("[[[[ OnCreatePlayer ]]]]")
--     -- trigger the initial setup (eg they login to area with rads)
--     local player = getSpecificPlayer(playerIndex)
--     local data = PR:getPlayerData(player)
--     if data then
--         if data.playing then
--             data.playing = false
--         end

--         PR:updatePlayerZone(player, {
--             rads = data.radLevel
--         })
--     end

-- end)

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
        local adminOption = context:addOption("PhunRad:" .. tostring(data.radLevel or 0) .. "/" ..
                                                  tostring(data.rads or 0), worldobjects, nil)
        local adminSubMenu = ISContextMenu:getNew(context)
        local targetPlayer = player
        for _, wObj in ipairs(worldobjects) do -- find object to interact with; code support for controllers
            local square = wObj:getSquare()
            for i = square:getMovingObjects():size(), 1, -1 do
                if instanceof(square:getMovingObjects():get(i - 1), "IsoPlayer") then
                    targetPlayer = square:getMovingObjects():get(i - 1)
                    break
                end
            end
        end

        adminSubMenu:addOption("Remove rads from " .. targetPlayer:getUsername(), player, function()
            sendClientCommand(PR.name, PR.commands.setPlayerRadLevel, {targetPlayer:getUsername(), 0, false})
        end)
        context:addSubMenu(adminOption, adminSubMenu)
        -- local item = items:get(0)
        -- if item:getType() == "GeigerCounter" then
        --     local option = context:addOption("Set Geiger Counter to 0", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 100", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 200", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 300", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 400", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 500", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 600", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 700", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 800", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 900", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        --     local option = context:addOption("Set Geiger Counter to 1000", item, PR.OnCreate.GeigerBatteriesInsert, playerObj)
        -- end
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

                PR:updatePlayerZone(p, {
                    rads = data.radLevel
                })
            end
        end
    end
end

Events.OnTick.Add(setup)
