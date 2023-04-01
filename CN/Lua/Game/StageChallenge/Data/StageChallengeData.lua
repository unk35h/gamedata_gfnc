-- params : ...
-- function num : 0 , upvalues : _ENV
local StageChallengeData = class("StageChallengeData")
StageChallengeData.Create = function(stageId)
  -- function num : 0_0 , upvalues : _ENV, StageChallengeData
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil then
    error("cant get stageCfg, id = " .. tostring(stageId))
    return 
  end
  local saveUserData = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData))
  -- DECOMPILER ERROR at PC19: Overwrote pending register: R3 in 'AssignReg'

  local isOpen = .end
  if (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskOpen(stageId) then
    isOpen = saveUserData:GetChallengeStageSwitch(stageId)
  else
    isOpen = false
  end
  local lastOpenTaskDic = saveUserData:GetChallengeStageTaskOptDic(stageId)
  local challengeTaskIdOptDic = {}
  for k,taskId in ipairs(stageCfg.hard_task) do
    if (stageCfg.is_optional)[k] and lastOpenTaskDic[taskId] then
      challengeTaskIdOptDic[taskId] = true
    end
  end
  local data = (StageChallengeData.New)(stageCfg, isOpen, challengeTaskIdOptDic)
  return data
end

StageChallengeData.ctor = function(self, stageCfg, isOpen, optionalTaskOpenDic)
  -- function num : 0_1
  self._stageCfg = stageCfg
  self:SetStageChallengeOpen(isOpen)
  self:SetStgClgOptionalTaskOpenDic(optionalTaskOpenDic)
end

StageChallengeData.SetStageChallengeOpen = function(self, isOpen)
  -- function num : 0_2
  self._isOpen = isOpen
end

StageChallengeData.IsStageChallengeOpen = function(self)
  -- function num : 0_3
  return self._isOpen
end

StageChallengeData.SetStgClgOptionalTaskOpenDic = function(self, optionalTaskOpenDic)
  -- function num : 0_4
  self._optionalTaskOpenDic = optionalTaskOpenDic
end

StageChallengeData.GetStgClgOptionalTaskOpenDic = function(self, isCopy)
  -- function num : 0_5 , upvalues : _ENV
  do
    if isCopy then
      local dic = {}
      for k,v in pairs(self._optionalTaskOpenDic) do
        dic[k] = v
      end
      return dic
    end
    return self._optionalTaskOpenDic
  end
end

StageChallengeData.GetStgClgOptionalTaskOpenList = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._optionalTaskOpenDic == nil then
    return table.emptytable
  end
  local list = {}
  for taskId,v in pairs(self._optionalTaskOpenDic) do
    (table.insert)(list, taskId)
  end
  return list
end

StageChallengeData.GetStgChallengeTaskList = function(self)
  -- function num : 0_7
  return (self._stageCfg).hard_task
end

StageChallengeData.IsStgChallengeTaskComplete = function(self, taskId)
  -- function num : 0_8 , upvalues : _ENV
  return (PlayerDataCenter.sectorAchievementDatas):IsChallengeTaskComplete((self._stageCfg).id, taskId)
end

StageChallengeData.GetStgChallengePowerLimitCfg = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local sctPowerLimitCfg = (ConfigData.sector_power_limit)[(self._stageCfg).power_limit]
  if sctPowerLimitCfg == nil then
    error("Cant get sector_power_limit, id = " .. tostring((self._stageCfg).power_limit))
    return 
  end
  return sctPowerLimitCfg
end

StageChallengeData.GetStgChallengeTaskRewardNum = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not self._isOpen then
    return 0
  end
  local taskNum = 0
  for k,taskId in ipairs(self:GetStgChallengeTaskList()) do
    local isOptional = ((self._stageCfg).is_optional)[k]
    local isOpen = true
    if isOptional then
      isOpen = (self._optionalTaskOpenDic)[taskId]
    end
    if isOpen and not (PlayerDataCenter.sectorAchievementDatas):IsChallengeTaskComplete((self._stageCfg).id, taskId) then
      taskNum = taskNum + 1
    end
  end
  local rewardNum = (ConfigData.game_config).stageChallengeTaskRewardPerNum * (taskNum)
  return rewardNum
end

StageChallengeData.TrySaveStgChallengeTask = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local stageId = (self._stageCfg).id
  if not (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskCompleteAll(stageId) then
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetChallengeStageSwitch(stageId, self._isOpen)
    if self._isOpen then
      local challengeTaskIdOptDic = self:GetStgClgOptionalTaskOpenDic()
      saveUserData:SetChallengeStageTaskOptDic(stageId, challengeTaskIdOptDic)
    end
  end
end

return StageChallengeData

