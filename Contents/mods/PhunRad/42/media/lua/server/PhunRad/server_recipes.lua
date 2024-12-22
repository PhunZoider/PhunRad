if isClient() then
    return
end
local PR = PhunRad

function PR.OnTest.BrokenGeiger(sourceItem, result)
    print(sourceItem:getFullType())
    -- if sourceItem:getType() == "BrokenGeigerCounter" then
    --     return sourceItem:getUsedDelta() == 0; -- Only allow the batteries inserting if the geigerteller has no batteries left in it.
    -- end

    return true
end

function PR.OnTest.GeigerBatteriesInsert(sourceItem, result)
    print(sourceItem:getFullType())
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

function PR.OnCreate.BrokenGeiger(items, result, player)

    local totalDelta = 0

end

function PR.OnTest.GeigerBatteriesRemove(sourceItem, result)
    return sourceItem:getUsedDelta() > 0;
end
