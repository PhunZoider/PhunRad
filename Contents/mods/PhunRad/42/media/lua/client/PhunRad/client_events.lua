if isServer() then
    return
end
local PR = PhunRad
local PZ = PhunZones
Events[PZ.events.OnPhunZonesPlayerLocationChanged].Add(function(player, zone)

    PR:updatePlayerZone(player, zone)

end)

Events.OnCreatePlayer.Add(function(playerIndex)
    PR:ini()
    -- PZ:updateModData(player)
    -- print("====> OnCreatePlayer")
    -- print(tostring(playerIndex))
    -- PR:updatePlayer(getSpecificPlayer(playerIndex))
end)

Events.EveryOneMinute.Add(function()
    for i = 0, getOnlinePlayers():size() - 1 do
        local p = getOnlinePlayers():get(i)
        if p:isLocalPlayer() then
            PR:updatePlayer(p)
        end
    end
end)
