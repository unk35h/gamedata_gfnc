-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityRoundController = class("ActivityRoundController", ControllerBase)
local base = ControllerBase
local ActivityRoundData = require("Game.ActivityRound.ActivityRoundData")
ActivityRoundController.OnInit = function(self)
  -- function num : 0_0
  self._data = {}
end

ActivityRoundController.AddRoundList = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  for _,singleMsg in ipairs(msg) do
    self:AddActivityRound(singleMsg)
  end
end

ActivityRoundController.AddActivityRound = function(self, msg)
  -- function num : 0_2 , upvalues : ActivityRoundData
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  if (self._data)[msg.actId] == nil then
    (self._data)[msg.actId] = (ActivityRoundData.New)()
  end
  ;
  ((self._data)[msg.actId]):InitRoundData(msg)
end

ActivityRoundController.UpdateActivityRound = function(self, msg)
  -- function num : 0_3
  local data = (self._data)[msg.actId]
  if data == nil then
    return 
  end
  data:UpdateRoundData(msg)
end

ActivityRoundController.RemoveActivityRound = function(self, id)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._data)[id] = nil
end

ActivityRoundController.GetActivityRound = function(self, id)
  -- function num : 0_5
  return (self._data)[id]
end

ActivityRoundController.HasActivityRound = function(self)
  -- function num : 0_6 , upvalues : _ENV
  do return (table.count)(self._data) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return ActivityRoundController

