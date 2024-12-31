if isClient() then
    return
end
local Commands = require "PhunRad/server_commands"
local PR = PhunRad

Events.OnClientCommand.Add(function(module, command, playerObj, arguments)
    if module == PR.name and Commands[command] then
        Commands[command](playerObj, arguments)
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
