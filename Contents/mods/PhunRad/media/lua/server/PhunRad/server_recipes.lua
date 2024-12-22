if not isServer() then
    return
end
local PR = PhunRad

if not PR.OnTest then
    PR.OnTest = {}
end
if not PR.OnCreate then
    PR.OnCreate = {}
end

function PR.OnTest.BrokenGeiger(sourceItem, result)
    if sourceItem and sourceItem.getFullType then
        print(sourceItem:getFullType())
    end
    -- if sourceItem:getType() == "BrokenGeigerCounter" then
    --     return sourceItem:getUsedDelta() == 0; -- Only allow the batteries inserting if the geigerteller has no batteries left in it.
    -- end

    return true
end

function PR.OnCreate.BrokenGeiger(items, result, player)
    local totalDelta = 0
end

function PR.OnTest.GeigerBatteriesInsert(sourceItem, result)
    if sourceItem and sourceItem.getFullType then
        print(sourceItem:getFullType())
    end
    if sourceItem:getType() == "GeigerCounter" then
        return sourceItem:getUsedDelta() == 0;
    end

    return true
end

function PR.OnCreate.GeigerBatteriesInsert(items, result, player)

    local totalDelta = 0

    for i = 0, items:size() - 1 do
        if items:get(i):getType() == "Battery" then
            totalDelta = totalDelta + items:get(i):getUsedDelta() / 4
            result:setUsedDelta(totalDelta);
        end
    end
end

function PR.OnTest.GeigerBatteriesRemove(sourceItem, result)
    return sourceItem:getUsedDelta() > 0;
end

function PR.OnCreate.GeigerBatteriesRemove(items, result, player)

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getType() == "GeigerTeller" then

            -- Unfortunately if the result of the recipe is 4 batteries the code sees it as one battery instead of 4.
            -- So I have to give the 3 batteries manually in an ugly way
            local battery1 = player:getInventory():AddItem("Battery")
            local battery2 = player:getInventory():AddItem("Battery")
            local battery3 = player:getInventory():AddItem("Battery")
            battery1:setUsedDelta(item:getUsedDelta())
            battery2:setUsedDelta(item:getUsedDelta())
            battery3:setUsedDelta(item:getUsedDelta())
            result:setUsedDelta(item:getUsedDelta())

            -- then we empty the geiger teller used delta (his energy/battery)
            item:setUsedDelta(0);
        end
    end
end
