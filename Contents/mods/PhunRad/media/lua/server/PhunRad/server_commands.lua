if isClient() then
    return
end

local PR = PhunRad
local Commands = {}

Commands[PR.commands.setPlayerRadLevel] = function(_, args)
    local name = args[1] or "NONE"
    local amount = tonumber(args[2]) or 0
    local relative = args[3] == true
    for i = 1, getOnlinePlayers():size() do
        local playerObj = getOnlinePlayers():get(i - 1)
        if playerObj then
            if playerObj:getUsername() == name then
                sendServerCommand(playerObj, PR.name, PR.commands.setPlayerRadLevel, args)
            end
        end
    end
end

return Commands
