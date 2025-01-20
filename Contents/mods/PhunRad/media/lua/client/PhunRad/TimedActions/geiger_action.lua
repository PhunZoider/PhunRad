local PR = PhunRad;
require "TimedActions/ISBaseTimedAction"

ISGeigerAction = ISBaseTimedAction:derive("ISGeigerAction")

ISGeigerAction.instances = {}

function ISGeigerAction.get(player, device)

    for _, v in ipairs(ISGeigerAction.instances) do
        if v.character == player and v.device == device then
            return v;
        end
    end

    local instance = ISTimedActionQueue.add(
        ISGeigerAction:new(isActivated and "ToggleOff" or "ToggleOn", player, device))

    table.insert(ISGeigerAction.instances, instance)

end

function ISGeigerAction:toggle(player, device)

    if device and device:getDelta() > 0 then
        local instance = ISGeigerAction:new("ToggleOn", self.character, device)
        instance:perform()
        table.insert(ISGeigerAction.instances, instance)
    end

end

function ISGeigerAction:isValid()
    if self.character and self.device and self.mode then
        if self["isValid" .. self.mode] then
            return self["isValid" .. self.mode](self);
        end
    end
end

function ISGeigerAction:update()
    if self.character then
        self.character:getModData().PhunRad.activeGeiger = self.device:isActivated()
    end
end

function ISGeigerAction:perform()
    if self.character and self.device and self.mode then
        if self["perform" .. self.mode] then
            self["perform" .. self.mode](self);
        end
    end

    ISBaseTimedAction.perform(self)
end

-- ToggleOn
function ISGeigerAction:isValidToggleOn()
    return self.device:getDelta() > 0
end

function ISGeigerAction:performToggleOn()
    if self:isValidToggleOn() then
        local isActivated = self.device:isActivated() and self.device:getDelta() > 0
        if self.character then
            self.character:playSound("TelevisionOn")
        end
        self.device:setActivated(true);
        local data = PR:getPlayerData(self.character)
        data.activeGeiger = true
        PR:updateGeigerCounterSound(self.character)

        local function autoStop()
            local s = self;
            local d = s.device;
            if d:getDelta() <= 0 or not d:isActivated() then
                Events.EveryOneMinute.Remove(autoStop)
                local data = PR:getPlayerData(s.character)
                data.activeGeiger = false
                PR:updateGeigerCounterSound(s.character)
                d:setActivated(false)
                return
            end
            print(tostring(s) .. tostring(d))
        end
        Events.EveryOneMinute.Add(autoStop)
    end
end

-- ToggleOnOff
function ISGeigerAction:isValidToggleOff()

    return self.device:getDelta() > 0
end

function ISGeigerAction:performToggleOff()
    if self:isValidToggleOff() then
        local isActivated = self.device:isActivated() and self.device:getDelta() > 0
        if self.character then
            self.character:playSound("TelevisionOff")
        end
        self.device:setActivated(false)
    end
end

-- RemoveBattery
function ISGeigerAction:isValidRemoveBattery()
    return self.deviceData:getIsBatteryPowered() and self.deviceData:getHasBattery();
end

function ISGeigerAction:performRemoveBattery()
    if self:isValidRemoveBattery() and self.character:getInventory() then
        self.deviceData:getBattery(self.character:getInventory());
    end
end

-- AddBattery
function ISGeigerAction:isValidAddBattery()
    return self.deviceData:getIsBatteryPowered() and self.deviceData:getHasBattery() == false;
end

function ISGeigerAction:performAddBattery()
    if self:isValidAddBattery() and self.secondaryItem then
        self.deviceData:addBattery(self.secondaryItem);
    end
end

-- TogglePlayMedia
function ISGeigerAction:isValidTogglePlayMedia()
    return self.deviceData:getIsTurnedOn() and self.deviceData:hasMedia();
end

function ISGeigerAction:performTogglePlayMedia()
    if self:isValidTogglePlayMedia() then
        if self.deviceData:isPlayingMedia() then
            self.deviceData:StopPlayMedia();
        else
            self.deviceData:StartPlayMedia();
        end
    end
end

function ISGeigerAction:new(mode, character, device)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.mode = mode;
    o.character = character;
    o.device = device;
    o.stopOnWalk = false;
    o.stopOnRun = true;
    o.maxTime = 30;

    return o;
end
