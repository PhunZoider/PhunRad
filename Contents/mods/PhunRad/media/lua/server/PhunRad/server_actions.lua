if not isClient() then
    return
end
local PR = PhunRad

local gt = nil
function OnEat_Iodine(food, player, percentage)
    print("OnEat_Iodine")
    if gt == nil then
        gt = GameTime:getInstance()
    end

    local pd = player:getModData().PhunRad
    pd.iodineExp = gt:getWorldAgeHours() + (PR.settings.IodineHours or 5)

end
