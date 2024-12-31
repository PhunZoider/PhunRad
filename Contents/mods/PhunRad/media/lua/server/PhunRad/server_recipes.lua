local PR = PhunRad
local Recipe = Recipe

function Recipe.OnTest.BrokenGeiger(sourceItem, result)
    if sourceItem and sourceItem.getFullType then
        print(sourceItem:getFullType())
    end
    return true
end

function Recipe.OnCreate.BrokenGeiger(items, result, player)
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getType() == "GeigerCounter" then
            item:setUsedDelta(0);
        end
    end
end

function Recipe.OnTest.GeigerBatteriesInsert(sourceItem, result)
    if sourceItem:getType() == "GeigerCounter" then
        return sourceItem:getUsedDelta() == 0;
    end
    return true
end

function Recipe.OnCreate.GeigerBatteriesInsert(items, result, player)
    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "Battery" then
            result:setUsedDelta(items:get(i):getUsedDelta());
        end
    end
end

function Recipe.OnTest.GeigerBatteriesRemove(sourceItem, result)
    return sourceItem:getUsedDelta() > 0;
end

function Recipe.OnCreate.GeigerBatteriesRemove(items, result, player)

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getType() == "GeigerCounter" then
            local battery = player:getInventory():AddItem("Battery")
            battery:setUsedDelta(item:getUsedDelta())
            result:setUsedDelta(item:getUsedDelta())
            item:setUsedDelta(0);
        end
    end
end

function Recipe.OnCreate.DismantleLantern(items, result, player, selectedItem)
    local success = 50 + (player:getPerkLevel(Perks.Electricity) * 5);
    player:getInventory():AddItem("Base.Aluminum");
    player:getInventory():AddItem("Base.LightBulb");

    if ZombRand(0, 100) < success then
        player:getInventory():AddItem("Base.ElectronicsScrap");
    end

    if ZombRand(0, 100) < success then
        player:getInventory():AddItem("Radio.ElecticWire");
    end
end
