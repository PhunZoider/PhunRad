if isServer() then
    return
end
local PR = PhunRad
local Commands = {}

Commands[PR.commands.setPlayerRadLevel] = function(args)
    local name = args[1] or "NONE"
    local amount = tonumber(args[2]) or 0
    local relative = args[3] == "true"
    local players = PR:onlinePlayers()

    for i = 1, players:size() do
        local playerObj = players:get(i - 1)

        if playerObj:getUsername() == name then
            local data = PR:getPlayerData(playerObj)
            if relative then
                data.rads = data.rads + amount
            else
                data.rads = amount
            end
        end

    end
end

-- Commands[PR.commands.updateVehiclePosition] = function(args)
--     local data = getPlayer():getModData()
--     PR:debug("updateVehiclePosition", args)
--     local vehicle = getVehicleById(args[1] or args.vehicleId)
--     print(tostring(vehicle))
-- end

-- Commands[PR.commands.clientFinishEnterInterior] = function(args)
--     local data = getPlayer():getModData()
--     PR:debug("clientFinishEnterInterior", args)
-- end

-- Commands[PR.commands.clientFinishExitInterior] = function(args)
--     local data = getPlayer():getModData()
--     local car = args and args.vehicleId and getVehicleById(args.vehicleId)
--     PR:debug("clientFinishExitInterior", args)
-- end

return Commands
