-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityComebackController = class("ActivityComebackController", ControllerBase)
local base = ControllerBase
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityComebackData = require("Game.ActivityComeback.ActivityComebackData")
ActivityComebackController.OnInit = function(self)
  -- function num : 0_0
  self._dataDic = {}
end

ActivityComebackController.AddComebackList = function(self, comebackMsgs)
  -- function num : 0_1 , upvalues : _ENV
  for i,comebackMsg in ipairs(comebackMsgs) do
    self:AddComebackActivity(comebackMsg)
  end
end

ActivityComebackController.AddComebackActivity = function(self, comebackMsg)
  -- function num : 0_2 , upvalues : ActivityComebackData, ActivityFrameEnum
  if (self._dataDic)[comebackMsg.actId] ~= nil then
    ((self._dataDic)[comebackMsg.actId]):InitActivityComeback(comebackMsg)
  else
    local data = (ActivityComebackData.New)()
    data:SetActFrameDataByType((ActivityFrameEnum.eActivityType).Comeback, comebackMsg.actId)
    data:InitActivityComeback(comebackMsg)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._dataDic)[comebackMsg.actId] = data
  end
end

ActivityComebackController.RemoveComebackActivity = function(self, comebackId)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[comebackId] = nil
end

ActivityComebackController.HasActivityComeback = function(self)
  -- function num : 0_4 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityComebackController.GetComebackData = function(self, id)
  -- function num : 0_5
  return (self._dataDic)[id]
end

ActivityComebackController.GetTheLatestComebackData = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local res = nil
  for k,v in pairs(self._dataDic) do
    if res == nil then
      res = v
    else
      if res:GetActivityBornTime() < v:GetActivityBornTime() then
        res = v
      end
    end
  end
  return res
end

return ActivityComebackController

