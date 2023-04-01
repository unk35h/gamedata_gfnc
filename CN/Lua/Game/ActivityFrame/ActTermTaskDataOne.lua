-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActTermTaskData")
local ActTermTaskDataOne = class("ActTermTaskDataOne", base)
ActTermTaskDataOne.InitTermTask = function(self, frameId)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitTermTask)(self, frameId)
  self._taskIds = ((ConfigData.activity_general)[frameId]).once_quest
end

ActTermTaskDataOne.GetTermTaskStageCount = function(self)
  -- function num : 0_1
  return 1
end

ActTermTaskDataOne.GetTermTaskIds = function(self, term)
  -- function num : 0_2
  return self._taskIds
end

ActTermTaskDataOne.GetTermOpenTime = function(self, term)
  -- function num : 0_3
  return 0
end

ActTermTaskDataOne.IsExitInTermTask = function(self, taskId)
  -- function num : 0_4 , upvalues : _ENV
  return (table.contain)(self._taskIds, taskId)
end

return ActTermTaskDataOne

