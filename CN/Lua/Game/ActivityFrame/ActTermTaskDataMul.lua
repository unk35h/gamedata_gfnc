-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActTermTaskData")
local ActTermTaskDataMul = class("ActTermTaskDataMul", base)
ActTermTaskDataMul.InitTermTask = function(self, frameId)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitTermTask)(self, frameId)
  local taskIds = ((ConfigData.activity_general)[frameId]).once_quest
  self._cfgs = (ConfigData.activity_general_term_task)[frameId]
  if taskIds[1] ~= nil then
    self._firstTaskIds = {}
    ;
    (table.insertto)(self._firstTaskIds, taskIds)
    ;
    (table.insertto)(self._firstTaskIds, ((self._cfgs)[1]).task)
  end
end

ActTermTaskDataMul.GetTermTaskStageCount = function(self)
  -- function num : 0_1
  if self._stageCount == nil then
    self._stageCount = #self._cfgs
  end
  return self._stageCount
end

ActTermTaskDataMul.GetTermTaskIds = function(self, term)
  -- function num : 0_2
  if term == 1 and self._firstTaskIds ~= nil then
    return self._firstTaskIds
  end
  local cfg = (self._cfgs)[term]
  if cfg == nil then
    return nil
  end
  return cfg.task
end

ActTermTaskDataMul.GetTermOpenTime = function(self, term)
  -- function num : 0_3
  local cfg = (self._cfgs)[term]
  if cfg == nil then
    return 0
  end
  return cfg.start_time
end

ActTermTaskDataMul.IsExitInTermTask = function(self, taskId)
  -- function num : 0_4 , upvalues : _ENV
  for i = 1, self:GetTermTaskStageCount() do
    if PlayerDataCenter.timestamp >= self:GetTermOpenTime(i) then
      do
        local tasks = self:GetTermTaskIds(i)
        if (table.contain)(tasks, taskId) then
          return true
        end
        -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return false
end

return ActTermTaskDataMul

