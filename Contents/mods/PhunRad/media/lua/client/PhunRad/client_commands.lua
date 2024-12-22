if isServer() then
    return
end
local PR = PhunRad
local Commands = {}

Commands[PR.commands.setPlayerRadLevel] = function(args)
    local name = args[1] or "NONE"
    local amount = tonumber(args[2]) or 0
    local relative = args[3] == "true"

    for i = 1, getOnlinePlayers():size() do
        local playerObj = getOnlinePlayers():get(i - 1)
        if playerObj and playerObj:isLocalPlayer() then
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
end

return Commands
