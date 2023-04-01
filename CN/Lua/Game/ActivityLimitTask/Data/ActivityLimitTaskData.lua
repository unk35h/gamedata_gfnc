-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityLimitTaskData = class("ActivityLimitTaskData")
ActivityLimitTaskData.InitActLimitTaskData = function(self, activityFrameData)
  -- function num : 0_0 , upvalues : _ENV
  self._actFrameData = activityFrameData
  local actTaskLimitCfg = (ConfigData.activity_task_limit)[activityFrameData.id]
  if actTaskLimitCfg == nil then
    error("Cant get activity_task_limit cfg, id = " .. tostring(activityFrameData.id))
    return 
  end
  self.actTaskLimitCfg = actTaskLimitCfg
end

ActivityLimitTaskData.GetActLimitTaskFrameData = function(self)
  -- function num : 0_1
  return self._actFrameData
end

ActivityLimitTaskData.IsActLimitTask = function(self, taskType)
  -- function num : 0_2
  do return ((self.actTaskLimitCfg).taskTypeDic)[taskType] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityLimitTaskData.IsActLimitTaskShowNew = function(self, taskData)
  -- function num : 0_3 , upvalues : _ENV
  local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local show = userData:GetActLimitNewTaskReddot((self._actFrameData).id, taskData.id)
  local nopick = not taskData:IsPickedTaskReward()
  return not show or nopick
end

ActivityLimitTaskData.GetActLimitTaskDataList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local list = {}
  for taskType,_ in pairs((self.actTaskLimitCfg).taskTypeDic) do
    local taskDic = (PlayerDataCenter.allTaskData):GetTaskDataDicByType(taskType)
    for taskId,taskData in pairs(taskDic) do
      if (taskData.stcData).isShow then
        (table.insert)(list, taskData)
      end
    end
  end
  return list
end

ActivityLimitTaskData.GetActLimitNotPickedTaskDataDic = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local dic = {}
  for taskType,_ in pairs((self.actTaskLimitCfg).taskTypeDic) do
    local taskDic = (PlayerDataCenter.allTaskData):GetTaskDataDicByType(taskType)
    for taskId,taskData in pairs(taskDic) do
      if (taskData.stcData).isShow and not taskData:IsPickedTaskReward() then
        dic[taskId] = taskData
      end
    end
  end
  return dic
end

return ActivityLimitTaskData

