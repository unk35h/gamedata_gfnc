-- params : ...
-- function num : 0 , upvalues : _ENV
local TaskCheckUtil = {}
local checkFuncDic = {[1602] = function(stepCfg, value)
  -- function num : 0_0
  do return value < stepCfg.finish_value end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [1605] = function(stepCfg, value)
  -- function num : 0_1
  do return value < stepCfg.finish_value end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
TaskCheckUtil.CheckTaskCondition = function(self, taskId, value)
  -- function num : 0_2 , upvalues : _ENV, checkFuncDic
  if (ConfigData.taskStep)[taskId] == nil or ((ConfigData.taskStep)[taskId])[1] == nil then
    error("Cant get taskStep cfg, taskId:" .. tostring(taskId))
    return 
  end
  local stepCfg = ((ConfigData.taskStep)[taskId])[1]
  local conditionId = (stepCfg.finish_condition)[1]
  local checkFunc = checkFuncDic[conditionId]
  if checkFunc == nil then
    error("CheckTaskCondition:Unsupported finish_condition, conditionId:" .. tostring(conditionId))
    return 
  end
  return checkFunc(stepCfg, value)
end

local getCheckFmtNumFuncDic = {[1602] = function(stepCfg, formationData)
  -- function num : 0_3 , upvalues : _ENV
  local careerId = (stepCfg.finish_condition)[2]
  if careerId == nil then
    error("taskStep.finish_condition , careerId == nil, taskId:" .. tostring(stepCfg.task_id))
    return 0
  end
  local heroIdDic = formationData:GetFormationHeroDic()
  local num = 0
  for idx,heroId in pairs(heroIdDic) do
    local heroData = formationData:GetFormationHeroData(idx)
    if heroData.career == careerId then
      num = num + 1
    end
  end
  return num
end
, [1605] = function(stepCfg, formationData)
  -- function num : 0_4 , upvalues : _ENV
  local heroIdDic = formationData:GetFormationHeroDic()
  local num = (table.count)(heroIdDic)
  return num
end
}
TaskCheckUtil.CheckFormationCondition = function(self, taskId, formationData)
  -- function num : 0_5 , upvalues : _ENV, getCheckFmtNumFuncDic, TaskCheckUtil
  if (ConfigData.task)[taskId] == nil or (ConfigData.taskStep)[taskId] == nil or ((ConfigData.taskStep)[taskId])[1] == nil then
    error("Cant get taskStep cfg, taskId:" .. tostring(taskId))
    return false
  end
  local stepCfg = ((ConfigData.taskStep)[taskId])[1]
  local taskCfg = (ConfigData.task)[taskId]
  local conditionId = (stepCfg.finish_condition)[1]
  local getNumFunc = getCheckFmtNumFuncDic[conditionId]
  if getNumFunc == nil then
    return true
  end
  local num = getNumFunc(stepCfg, formationData)
  local ok = TaskCheckUtil:CheckTaskCondition(taskId, num)
  local taskDes = (LanguageUtil.GetLocaleText)(taskCfg.task_intro)
  return ok, taskDes
end

return TaskCheckUtil

