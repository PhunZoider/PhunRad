if isClient() then
    return
end
local Commands = require "PhunRad/server_commands"
local PR = PhunRad

Events.OnInitGlobalModData.Add(function()
    local m = ModData.getOrCreate("NUCModDataServerVariablesLocal")
    m.WriteFalloutzoneFileDone = true
end)

Events.OnClientCommand.Add(function(module, command, playerObj, arguments)
    if module == PR.name and Commands[command] then
        print("Executing command: " .. command)
        Commands[command](playerObj, arguments)
    end
end)
