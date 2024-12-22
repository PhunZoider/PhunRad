if not isServer() then
    return
end
local PR = PhunRad

Events.OnInitGlobalModData.Add(function()
    local m = ModData.getOrCreate("NUCModDataServerVariablesLocal")
    m.WriteFalloutzoneFileDone = true
end)

