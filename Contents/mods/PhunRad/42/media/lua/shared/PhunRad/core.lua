PhunRad = {
    inied = false,
    name = "PhunRad",
    commands = {
        setPlayerRadLevel = "PhunRad.setPlayerRadLevel"
    },
    events = {},
    data = {},
    settings = {}
}

local Core = PhunRad
Core.settings = SandboxVars[Core.name] or {}

for _, event in pairs(Core.events or {}) do
    if not Events[event] then
        LuaEventManager.AddEvent(event)
    end
end

function Core:ini()
    if not self.inied then
        self.inied = true
        self.data = ModData.getOrCreate(self.name)
    end
end
