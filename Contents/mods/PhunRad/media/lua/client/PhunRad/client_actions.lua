local PR = PhunRad

local gt = nil
function OnEat_Iodine(food, player, percentage)
    print("OnEat_Iodine")
    if gt == nil then
        gt = GameTime:getInstance()
    end

    local pd = player:getModData().PhunRad
    if (pd.iodineExp or 0) then
        pd.iodineExp = gt:getWorldAgeHours()
    end
    pd.iodineExp = pd.iodineExp + (PR.settings.IodineHours or 5)

end

function IodineTake(items, result, player)

    if gt == nil then
        gt = GameTime:getInstance()
    end

    local pd = player:getModData().PhunRad
    if (pd.iodineExp or 0) then
        pd.iodineExp = gt:getWorldAgeHours()
    end
    pd.iodineExp = pd.iodineExp + (PR.settings.IodineHours or 5)
end
