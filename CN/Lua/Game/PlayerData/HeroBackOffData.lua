-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroBackOffData = class("HeroBackOffData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
HeroBackOffData.ctor = function(self, datas)
  -- function num : 0_0 , upvalues : _ENV, ActivityFrameEnum
  self.backActivitys = {}
  for _,actdata in pairs(datas) do
    local backActivity = {}
    backActivity.backHeros = {}
    backActivity.actId = actdata.actId
    for _,data in pairs(actdata.elems) do
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R13 in 'UnsetPending'

      (backActivity.backHeros)[data.heroId] = data
    end
    local activityFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
    local activityId = activityFrameCtr:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).HeroBackOff, backActivity.actId)
    backActivity.__activityData = activityFrameCtr:GetActivityFrameData(activityId or 0)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.backActivitys)[backActivity.actId] = backActivity
  end
end

HeroBackOffData.IsHeroBackOffEnable = function(self, heroId)
  -- function num : 0_1 , upvalues : _ENV
  for actId,backActivity in pairs(self.backActivitys) do
    if backActivity.__activityData ~= nil and (backActivity.__activityData):IsActivityOpen() then
      local returnCfg = (ConfigData.activity_return)[actId]
      if returnCfg ~= nil and (returnCfg.role_dic)[heroId] and (backActivity.backHeros)[heroId] == nil then
        return true, actId
      end
    end
  end
  return false, 0
end

return HeroBackOffData

