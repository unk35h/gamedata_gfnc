-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorAchievementData = class("SectorAchievementData")
SectorAchievementData.CreateAchivSectorData = function(sectorData)
  -- function num : 0_0 , upvalues : SectorAchievementData
  local data = (SectorAchievementData.New)()
  data:__InitData(sectorData)
  data:InitSectorAchivRedDot()
  return data
end

SectorAchievementData.ctor = function(self)
  -- function num : 0_1
  self.sectorDataDic = nil
end

SectorAchievementData.__InitData = function(self, sectorData)
  -- function num : 0_2 , upvalues : _ENV
  self.sectorDataDic = sectorData
  self.stageChallengeQuestDic = {}
  for sectorId,sector in pairs(sectorData) do
    for k,v in pairs(sector.challengeQuest) do
      -- DECOMPILER ERROR at PC12: Confused about usage of register: R12 in 'UnsetPending'

      (self.stageChallengeQuestDic)[k] = v
    end
  end
end

SectorAchievementData.GetIsPicked = function(self, sectorId, achivId)
  -- function num : 0_3
  if self.sectorDataDic == nil or (self.sectorDataDic)[sectorId] == nil or ((self.sectorDataDic)[sectorId]).boxPicked == nil then
    return false
  end
  return (((self.sectorDataDic)[sectorId]).boxPicked)[achivId]
end

SectorAchievementData.GetIsComplete = function(self, sectorId, taskId)
  -- function num : 0_4
  if self.sectorDataDic == nil or (self.sectorDataDic)[sectorId] == nil or ((self.sectorDataDic)[sectorId]).completed == nil then
    return false
  end
  return (((self.sectorDataDic)[sectorId]).completed)[taskId]
end

SectorAchievementData.GetCompletedTask = function(self, sectorId)
  -- function num : 0_5
  if self.sectorDataDic == nil or (self.sectorDataDic)[sectorId] == nil then
    return 
  end
  return ((self.sectorDataDic)[sectorId]).completed
end

SectorAchievementData.UpdateCompleteTaskData = function(self, sectorId, taskId)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if (self.sectorDataDic)[sectorId] == nil then
    (self.sectorDataDic)[sectorId] = {}
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  if ((self.sectorDataDic)[sectorId]).completed == nil then
    ((self.sectorDataDic)[sectorId]).completed = {}
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.sectorDataDic)[sectorId]).completed)[taskId] = true
end

SectorAchievementData.UpdateAchivData = function(self, msg)
  -- function num : 0_7
  local sectorId = msg.sectorId
  local achivId = msg.id
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  if (self.sectorDataDic)[sectorId] == nil then
    (self.sectorDataDic)[sectorId] = {}
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  if ((self.sectorDataDic)[sectorId]).boxPicked == nil then
    ((self.sectorDataDic)[sectorId]).boxPicked = {}
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.sectorDataDic)[sectorId]).boxPicked)[achivId] = true
  self:UpdateSectorAchivRedDot(sectorId)
end

SectorAchievementData.InitSectorAchivRedDot = function(self)
  -- function num : 0_8 , upvalues : _ENV
  for _,id in ipairs((ConfigData.sector).id_sort_list) do
    local sectorCfg = (ConfigData.sector)[id]
    local achivCfgs = (ConfigData.sectorAchievement)[sectorCfg.id]
    local sectorId = sectorCfg.id
    local node = RedDotController:AddRedDotNodeWithPath(RedDotDynPath.SectorItemTaskAchivPath, RedDotStaticTypeId.Main, RedDotStaticTypeId.Sector, sectorId, RedDotStaticTypeId.SectorTaskBtn, RedDotStaticTypeId.SectorTaskAchiv)
    local count = 0
    if achivCfgs ~= nil then
      for i = 1, #achivCfgs do
        local achivCfg = achivCfgs[i]
        if not self:GetIsPicked(sectorId, achivCfg.id) and self:CheckAchivCondition(achivCfg) then
          count = count + 1
        end
      end
    end
    do
      do
        node:SetRedDotCount(count)
        -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

SectorAchievementData.UpdateSectorAchivRedDot = function(self, sectorId)
  -- function num : 0_9 , upvalues : _ENV
  local OK, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Sector, sectorId, RedDotStaticTypeId.SectorTaskBtn, RedDotStaticTypeId.SectorTaskAchiv)
  if OK then
    local sectorCfg = (ConfigData.sector)[sectorId]
    local achivCfgs = (ConfigData.sectorAchievement)[sectorCfg.id]
    local count = 0
    if achivCfgs ~= nil then
      for i = 1, #achivCfgs do
        local achivCfg = achivCfgs[i]
        if not self:GetIsPicked(sectorId, achivCfg.id) and self:CheckAchivCondition(achivCfg) then
          count = count + 1
        end
      end
    end
    do
      node:SetRedDotCount(count)
    end
  end
end

SectorAchievementData.CheckAchivCondition = function(self, achivCfg)
  -- function num : 0_10 , upvalues : _ENV
  for i = 1, #achivCfg.conditionIds do
    local conditionId = (achivCfg.conditionIds)[i]
    local conditionNum = (achivCfg.conditionNums)[i]
    local itemCount = PlayerDataCenter:GetItemCount(conditionId)
    if itemCount < conditionNum then
      return false
    end
  end
  return true
end

SectorAchievementData.IsChallengeTaskComplete = function(self, stageId, questId)
  -- function num : 0_11
  local key = stageId << 32 | questId
  do return (self.stageChallengeQuestDic)[key] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorAchievementData.SetChallengeTaskComplete = function(self, stageId, questId)
  -- function num : 0_12 , upvalues : _ENV
  local key = stageId << 32 | questId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.stageChallengeQuestDic)[key] = true
  MsgCenter:Broadcast(eMsgEventId.OnChallengeTaskComplete, stageId, questId)
end

SectorAchievementData.IsStageChallengeTaskCompleteAll = function(self, stageId)
  -- function num : 0_13 , upvalues : _ENV
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return false
  end
  local completeAll = true
  for k,taskId in ipairs(sectorStageCfg.hard_task) do
    if not self:IsChallengeTaskComplete(stageId, taskId) then
      completeAll = false
      break
    end
  end
  do
    return completeAll
  end
end

SectorAchievementData.HasStageChallengeTask = function(self, stageId)
  -- function num : 0_14 , upvalues : _ENV
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return false
  end
  local sectorCfg = (ConfigData.sector)[sectorStageCfg.sector]
  if sectorCfg.task_is_open and #sectorStageCfg.hard_task > 0 then
    return true
  end
  return false
end

SectorAchievementData.IsStageChallengeTaskOpen = function(self, stageId)
  -- function num : 0_15 , upvalues : _ENV
  if not self:HasStageChallengeTask(stageId) then
    return false
  end
  if (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
    return true
  end
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return false
  end
  if sectorStageCfg.hard_task_unlock ~= 0 then
    return (PlayerDataCenter.sectorStage):IsStageComplete(sectorStageCfg.hard_task_unlock)
  end
  return false
end

SectorAchievementData.GetStageChallengeTaskOpenDes = function(self, stageId)
  -- function num : 0_16 , upvalues : _ENV
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return 
  end
  if sectorStageCfg.hard_task_unlock == 0 then
    return ConfigData:GetTipContent(963)
  else
    local stageName = ConfigData:GetSectorStageName(sectorStageCfg.hard_task_unlock)
    local msg = ConfigData:GetTipContent(965)
    return (string.format)(msg, stageName)
  end
end

SectorAchievementData.GetStageChallengeTaskCompleteNum = function(self, stageId)
  -- function num : 0_17 , upvalues : _ENV
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return 0
  end
  local num = 0
  for k,taskId in ipairs(sectorStageCfg.hard_task) do
    if self:IsChallengeTaskComplete(stageId, taskId) then
      num = num + 1
    end
  end
  return num
end

SectorAchievementData.GetStageChallengeTaskNum = function(self, stageId)
  -- function num : 0_18 , upvalues : _ENV
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil then
    error("Cant get sector_stage cfg, id = " .. tostring(stageId))
    return 0
  end
  return #sectorStageCfg.hard_task
end

return SectorAchievementData

