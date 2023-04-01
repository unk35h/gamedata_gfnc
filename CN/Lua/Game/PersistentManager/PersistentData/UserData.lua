-- params : ...
-- function num : 0 , upvalues : _ENV
local PersistentDataBase = require("Game.PersistentManager.PersistentData.PersistentDataBase")
local UserData = class("UserData", PersistentDataBase)
local FormationUtil = require("Game.Formation.FormationUtil")
local WCEnum = require("Game.WeeklyChallenge.WCEnum")
UserData.GetSaveDataFilePath = function(self)
  -- function num : 0_0 , upvalues : _ENV
  return PathConsts:GetPersistentUserDataPath(PlayerDataCenter.strPlayerId)
end

UserData.InitBySaveData = function(self, table)
  -- function num : 0_1
  self.lastSectorEntered = table.lastSectorEntered
  if not table.userSetting then
    self.userSetting = {}
    self.guideData = table.guideData
    self.fomationData = table.fomationData
    if self.fomationData == nil then
      self:__InitFormationData()
    end
    self.dungeonExtrData = table.dungeonExtrData
    if self.dungeonExtrData == nil then
      self:__InitDungeonExtrData()
    end
    self.specialReddotData = table.specialReddotData
    if self.specialReddotData == nil then
      self:__InitSpecialReddotData()
    end
    self.activityData = table.activityData
    if self.activityData == nil then
      self:__InitActivitySaveData()
    end
    self.gameNoticeData = table.gameNoticeData
    if not table.unlockNewSector then
      self.unlockNewSector = {}
      self.avgnoundic = table.avgnoundic
      self.avgplayspeed = table.avgplayspeed
      if not table.challengeStageDic then
        self.challengeStageDic = {}
        self.chipGiftPop = table.chipGiftPop
        if self.chipGiftPop == nil then
          self:__InitChipGiftPop()
        end
        self.guidePicIdDic = table.guidePicIdDic
        if self.guidePicIdDic == nil then
          self.guidePicIdDic = {}
        end
        if not table.lotteryData then
          self.lotteryData = self:__InitLotterydata()
        end
      end
    end
  end
end

UserData.InitByDefaultData = function(self)
  -- function num : 0_2
  self.lastSectorEntered = 0
  self.unlockNewSector = {maxLastPlayVideSectorId = 0, maxLastUnlockAnimaSectorId = 0}
  self.userSetting = {}
  self:GetNoticeSwitchOff()
  self:__InitFormationData()
  self:__InitDungeonExtrData()
  self:__InitSpecialReddotData()
  self:__InitActivitySaveData()
  self.challengeStageDic = {}
  self.avgnoundic = {}
  self:__InitChipGiftPop()
  self.guidePicIdDic = {}
  self:__InitLotterydata()
end

UserData.__InitFormationData = function(self)
  -- function num : 0_3
  self.fomationData = {
lastFmtId = {}
, 
weeklyChallengeFmt = {}
, weeklyChallengeTreeId = 0, 
fixedTeamId2FmtIdDic = {}
, 
fixedTeamIdListSaved = {}
, 
lastBattleDeployFmtId = {}
, 
weeklySpFmt = {}
, weeklySpTreeId = 0, 
lastFromModuleFmtId = {}
}
end

UserData.__InitDungeonExtrData = function(self)
  -- function num : 0_4
  self.dungeonExtrData = {
lastSelectStageDic = {}
, unitBlood = 0, bossUnitBlood = 0, lastAthDungeonId = 0, 
dropBuffOpenDic = {}
, lastDropBuffOpenResetTm = 0}
end

UserData.__InitSpecialReddotData = function(self)
  -- function num : 0_5
  self.specialReddotData = {
specialReddotDic = {}
, 
newGiftItemDic = {}
, 
firstOpenTask = {}
, 
newPayGiftItemDic = {}
, 
newDormHouseDic = {}
, 
unlockableDormHouseDic = {}
, tower_racing_reward = false, 
actLimitNewTaskDic = {}
, actLimitNewTaskActFrameId = 0, 
twinTowerReaded = {}
, normalTowerLevel = 0, 
newItemDic = {}
, lastMonthCardRenew = 0, 
specWeaponLookedDic = {}
}
end

UserData.__InitActivitySaveData = function(self)
  -- function num : 0_6
  self.activityData = {
entranceLastShow = {}
, 
activityHeros = {}
, 
sectorIIDataDic = {}
, 
sectorIIRecommendShopDic = {}
, 
activityCarnivalDic = {}
, 
adcDic = {}
}
end

UserData.__CreateDefaultActivityHero = function(self)
  -- function num : 0_7
  return {
shopReads = {}
, 
avgReviewDic = {}
, challengeStageLooked = 0, dailyTaskLooked = 0, 
dungeonBattle = {}
}
end

UserData.__InitChipGiftPop = function(self)
  -- function num : 0_8
  self.chipGiftPop = {
ignoreTime = {}
}
end

UserData.__InitActivityCarnival = function(self)
  -- function num : 0_9
  return {diffEnv = 0, 
avgReviewDic = {}
}
end

UserData.__InitLotterydata = function(self)
  -- function num : 0_10
  self.lotteryData = {
groupSelectedLtrPool = {}
, newConvertSwitchRed = false, newConvertRuleRed = false, 
newRuleReddotRead = {}
}
  return self.lotteryData
end

UserData._DealLtrOldData = function(self)
  -- function num : 0_11
  if (self.lotteryData).newConvertRuleRed then
    self:SetReadLtrNewRuleReddot(1)
  end
end

UserData.__InitSum22ActData = function(self)
  -- function num : 0_12
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).sum22Activity == nil then
    (self.activityData).sum22Activity = {}
  end
end

UserData.__InitHallowmasData = function(self)
  -- function num : 0_13
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).hallowmasActivity == nil then
    (self.activityData).hallowmasActivity = {}
  end
end

UserData.__InitSpring23Data = function(self)
  -- function num : 0_14
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).spring23Activity == nil then
    (self.activityData).spring23Activity = {}
  end
end

UserData.__InitWinter23Data = function(self)
  -- function num : 0_15
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).winter23Activity == nil then
    (self.activityData).winter23Activity = {}
  end
end

UserData.__InitComebackData = function(self)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).comebackActivity == nil then
    (self.activityData).comebackActivity = {}
  end
end

UserData.__InitInvitationData = function(self)
  -- function num : 0_17
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).invitationActivity == nil then
    (self.activityData).invitationActivity = {}
  end
end

UserData.__InitWeeklyQAData = function(self)
  -- function num : 0_18
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).answerActivity == nil then
    (self.activityData).answerActivity = {}
  end
end

UserData.__InitAngelaGiftData = function(self)
  -- function num : 0_19
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.activityData).angelaGiftActivity == nil then
    (self.activityData).angelaGiftActivity = {}
  end
end

UserData.GetSum22ActEnter = function(self, actId)
  -- function num : 0_20
  self:__InitSum22ActData()
  local sum22Activity = ((self.activityData).sum22Activity)[actId]
  do return (sum22Activity ~= nil and sum22Activity.enterActive) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UserData.SetSum22ActEnter = function(self, actId)
  -- function num : 0_21
  self:__InitSum22ActData()
  local sum22Activity = ((self.activityData).sum22Activity)[actId]
  if sum22Activity == nil then
    sum22Activity = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.activityData).sum22Activity)[actId] = sum22Activity
  end
  if sum22Activity.enterActive then
    return 
  end
  sum22Activity.enterActive = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetSum22SelectTechLastEnterRefreshTs = function(self, actId)
  -- function num : 0_22
  self:__InitSum22ActData()
  local sum22Activity = ((self.activityData).sum22Activity)[actId]
  return sum22Activity ~= nil and sum22Activity.lastEnterTechSelectRefreshTs or 0
end

UserData.SetSum22SelectTechLastEnterRefreshTs = function(self, actId, ts)
  -- function num : 0_23
  self:__InitSum22ActData()
  local sum22Activity = ((self.activityData).sum22Activity)[actId]
  if sum22Activity == nil then
    sum22Activity = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).sum22Activity)[actId] = sum22Activity
  end
  if sum22Activity.lastEnterTechSelectRefreshTs == ts then
    return 
  end
  sum22Activity.lastEnterTechSelectRefreshTs = ts
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.TryDeleteSum22Activity = function(self, ingoreActTable)
  -- function num : 0_24 , upvalues : _ENV
  if self.activityData == nil or (self.activityData).sum22Activity == nil then
    return 
  end
  for actId,sum22Activity in pairs((self.activityData).sum22Activity) do
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R7 in 'UnsetPending'

    if ingoreActTable[actId] == nil then
      ((self.activityData).sum22Activity)[actId] = nil
    end
  end
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetLtrGroupSelectedLtrId = function(self, groupId)
  -- function num : 0_25
  return ((self.lotteryData).groupSelectedLtrPool)[groupId]
end

UserData.SetLtrGroupSelectedLtrId = function(self, groupId, ltrId)
  -- function num : 0_26
  if ((self.lotteryData).groupSelectedLtrPool)[groupId] == ltrId then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.lotteryData).groupSelectedLtrPool)[groupId] = ltrId
  self:SetPstDataDirty()
end

UserData.GetLtrNewConvertSwitchRed = function(self)
  -- function num : 0_27
  return not (self.lotteryData).newConvertSwitchRed
end

UserData.SetLtrNewConvertSwitchRed = function(self)
  -- function num : 0_28
  if (self.lotteryData).newConvertSwitchRed == true then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.lotteryData).newConvertSwitchRed = true
  self:SetPstDataDirty()
end

UserData.IsReadLtrNewRuleReddot = function(self, ltrRuleId)
  -- function num : 0_29
  if (self.lotteryData).newRuleReddotRead == nil then
    return false
  end
  return ((self.lotteryData).newRuleReddotRead)[ltrRuleId] or false
end

UserData.SetReadLtrNewRuleReddot = function(self, ltrRuleId)
  -- function num : 0_30
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if (self.lotteryData).newRuleReddotRead == nil then
    (self.lotteryData).newRuleReddotRead = {}
  end
  if ((self.lotteryData).newRuleReddotRead)[ltrRuleId] == true then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.lotteryData).newRuleReddotRead)[ltrRuleId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.RecordLastSectorSelected = function(self, sectorMentionId)
  -- function num : 0_31
  if self.lastSectorEntered ~= sectorMentionId then
    self.lastSectorEntered = sectorMentionId
    self:SetPstDataDirty()
  end
end

UserData.GetLastLocalSectorMentionId = function(self)
  -- function num : 0_32
  return self.lastSectorEntered
end

UserData.RecordLastMaxUnlockSectorId = function(self, maxUnlockSectorId, isAnima)
  -- function num : 0_33 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  -- DECOMPILER ERROR at PC7: Unhandled construct in 'MakeBoolean' P1

  if isAnima and (self.unlockNewSector).maxLastUnlockAnimaSectorId ~= maxUnlockSectorId then
    (self.unlockNewSector).maxLastUnlockAnimaSectorId = maxUnlockSectorId
    self:SetPstDataDirty()
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  if (self.unlockNewSector).maxLastPlayVideSectorId ~= maxUnlockSectorId then
    (self.unlockNewSector).maxLastPlayVideSectorId = maxUnlockSectorId
    self:SetPstDataDirty()
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
end

UserData.GetLastLocalMaxUnlockSectorId = function(self, isAnima)
  -- function num : 0_34
  if not (self.unlockNewSector).maxLastUnlockAnimaSectorId then
    do return not isAnima or 0 end
    do return (self.unlockNewSector).maxLastPlayVideSectorId or 0 end
  end
end

UserData.SetNoticeSwitchOff = function(self, homeside_info_id, bool)
  -- function num : 0_35
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if ((self.userSetting).homeNoticeOff)[homeside_info_id] ~= bool then
    ((self.userSetting).homeNoticeOff)[homeside_info_id] = bool
    self:SetPstDataDirty()
  end
end

UserData.GetNoticeSwitchOff = function(self)
  -- function num : 0_36 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.userSetting).homeNoticeOff == nil then
    (self.userSetting).homeNoticeOff = {}
    for id,_ in pairs(ConfigData.homeside_info) do
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R6 in 'UnsetPending'

      ((self.userSetting).homeNoticeOff)[id] = false
    end
  end
  do
    return (self.userSetting).homeNoticeOff
  end
end

UserData.__InitGuideData = function(self)
  -- function num : 0_37
  self.guideData = {
skipGuideTask = {}
}
end

UserData.SaveSkipGuideTask = function(self, taskId)
  -- function num : 0_38
  if self.guideData == nil then
    self:__InitGuideData()
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.guideData).skipGuideTask)[taskId] ~= true then
    ((self.guideData).skipGuideTask)[taskId] = true
    self:SetPstDataDirty()
  end
end

UserData.ContainSkipGuideTask = function(self, taskId)
  -- function num : 0_39
  if self.guideData == nil then
    return false
  end
  return ((self.guideData).skipGuideTask)[taskId]
end

UserData.GetLastFormationId = function(self, moduleId, stageId)
  -- function num : 0_40 , upvalues : FormationUtil
  local defaultFmtId = 1
  if self.fomationData == nil then
    return defaultFmtId
  end
  if stageId then
    local offset = (FormationUtil.GetFmtIdOffsetBySpecialStage)(stageId)
    if offset ~= 0 then
      if (self.fomationData).guardPlayFmtId == 0 or not (self.fomationData).guardPlayFmtId then
        do
          do return defaultFmtId + offset end
          local fmtId = ((self.fomationData).lastFmtId)[moduleId]
          return fmtId or defaultFmtId
        end
      end
    end
  end
end

UserData.SetLastFormationId = function(self, moduleId, fmtId, stageId)
  -- function num : 0_41 , upvalues : FormationUtil
  local lastId = nil
  if stageId and (FormationUtil.GetFmtIdOffsetBySpecialStage)(stageId) ~= 0 then
    lastId = (self.fomationData).guardPlayFmtId
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.fomationData).guardPlayFmtId = fmtId
  else
    lastId = ((self.fomationData).lastFmtId)[moduleId]
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.fomationData).lastFmtId)[moduleId] = fmtId
  end
  if fmtId ~= lastId then
    self:SetPstDataDirty()
  end
end

UserData.GetLastBattleDeployFmtId = function(self, moduleId)
  -- function num : 0_42 , upvalues : FormationUtil
  local fmtId = ((self.fomationData).lastBattleDeployFmtId)[moduleId]
  if fmtId == nil then
    fmtId = (FormationUtil.GetFmtIdByDungeonType)(moduleId, 1)
  end
  return fmtId
end

UserData.SetLastBattleDeployFmtId = function(self, moduleId, fmtId)
  -- function num : 0_43
  local lastId = ((self.fomationData).lastBattleDeployFmtId)[moduleId]
  if fmtId == lastId then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.fomationData).lastBattleDeployFmtId)[moduleId] = fmtId
  self:SetPstDataDirty()
end

UserData.GetLastFromModuleFmtId = function(self, moduleId, stageId)
  -- function num : 0_44 , upvalues : FormationUtil
  if stageId then
    local offset = (FormationUtil.GetFmtIdOffsetBySpecialStage)(stageId)
    if offset ~= 0 then
      if (self.fomationData).guardPlayFmtId == 0 or not (self.fomationData).guardPlayFmtId then
        do
          do return 1 + offset end
          local fmtId = ((self.fomationData).lastFromModuleFmtId)[moduleId]
          if fmtId == nil then
            fmtId = (FormationUtil.GetFmtIdOffsetByFmtFromModule)(moduleId) + 1
          end
          return fmtId
        end
      end
    end
  end
end

UserData.SetLastFromModuleFmtId = function(self, moduleId, fmtId, stageId)
  -- function num : 0_45 , upvalues : FormationUtil
  local lastId = nil
  if stageId and (FormationUtil.GetFmtIdOffsetBySpecialStage)(stageId) ~= 0 then
    lastId = (self.fomationData).guardPlayFmtId
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.fomationData).guardPlayFmtId = fmtId
  else
    lastId = ((self.fomationData).lastFromModuleFmtId)[moduleId]
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.fomationData).lastFromModuleFmtId)[moduleId] = fmtId
  end
  if fmtId == lastId then
    return 
  end
  self:SetPstDataDirty()
end

UserData.GetFmtFixedSaved = function(self)
  -- function num : 0_46
  return (self.fomationData).fixedTeamId2FmtIdDic, (self.fomationData).fixedTeamIdListSaved
end

UserData.SetFmtFixedSaved = function(self, fixedTeamId2FmtIdDic, fixedTeamIdListSaved)
  -- function num : 0_47 , upvalues : _ENV
  local changed = false
  if #(self.fomationData).fixedTeamIdListSaved ~= #fixedTeamIdListSaved then
    changed = true
  else
    for k,v in ipairs((self.fomationData).fixedTeamIdListSaved) do
      if fixedTeamIdListSaved[k] ~= v then
        changed = true
      else
        do
          -- DECOMPILER ERROR at PC19: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC19: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    if (table.count)(fixedTeamId2FmtIdDic) ~= (table.count)((self.fomationData).fixedTeamId2FmtIdDic) then
      changed = true
    else
      for k,v in pairs((self.fomationData).fixedTeamId2FmtIdDic) do
        if fixedTeamId2FmtIdDic[k] ~= v then
          changed = true
          break
        end
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

    if changed then
      (self.fomationData).fixedTeamId2FmtIdDic = fixedTeamId2FmtIdDic
      -- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.fomationData).fixedTeamIdListSaved = fixedTeamIdListSaved
      self:SetPstDataDirty()
    end
  end
end

UserData.GetLastDungeonStageId = function(self, dungeonId)
  -- function num : 0_48
  if self.dungeonExtrData == nil then
    return nil
  end
  local stageId = ((self.dungeonExtrData).lastSelectStageDic)[dungeonId]
  return stageId
end

UserData.SetLastDungeonStageId = function(self, dungeonId, stageId)
  -- function num : 0_49
  local lastId = ((self.dungeonExtrData).lastSelectStageDic)[dungeonId]
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  if stageId ~= lastId then
    ((self.dungeonExtrData).lastSelectStageDic)[dungeonId] = stageId
    self:SetPstDataDirty()
  end
end

UserData.SetLastAthDungeonId = function(self, dungeonId)
  -- function num : 0_50
  if (self.dungeonExtrData).lastAthDungeonId == dungeonId then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.dungeonExtrData).lastAthDungeonId = dungeonId
  self:SetPstDataDirty()
end

UserData.GetLastAthDungeonId = function(self)
  -- function num : 0_51
  local lastAthDungeonId = (self.dungeonExtrData).lastAthDungeonId
  if lastAthDungeonId == 0 then
    return nil
  end
  return lastAthDungeonId
end

UserData.SetDungeonDropBuffActive = function(self, dungeonType, active)
  -- function num : 0_52
  if ((self.dungeonExtrData).dropBuffOpenDic)[dungeonType] == active then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.dungeonExtrData).dropBuffOpenDic)[dungeonType] = active
  self:SetPstDataDirty()
end

UserData.GetDungeonDropBuffActive = function(self, dungeonType)
  -- function num : 0_53
  return ((self.dungeonExtrData).dropBuffOpenDic)[dungeonType] or false
end

UserData.SetDungeonDropBuffLastResetTm = function(self, timestamp)
  -- function num : 0_54
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.dungeonExtrData).lastDropBuffOpenResetTm = timestamp
end

UserData.GetDungeonDropBuffLastResetTm = function(self)
  -- function num : 0_55
  return (self.dungeonExtrData).lastDropBuffOpenResetTm
end

UserData.GetLastWeeklyChallengeFmt = function(self, wcType)
  -- function num : 0_56 , upvalues : WCEnum
  if self.fomationData ~= nil then
    if wcType == (WCEnum.eWeeklyChallengeType).special then
      return (self.fomationData).weeklySpFmt
    end
    return (self.fomationData).weeklyChallengeFmt
  end
  return nil
end

UserData.SetLastWeeklyChallengeFmt = function(self, wcType, fmtDic)
  -- function num : 0_57 , upvalues : WCEnum, _ENV
  if self.fomationData == nil then
    self:__InitFormationData()
  end
  local isChanged = false
  local modifyTable = nil
  if wcType == (WCEnum.eWeeklyChallengeType).special then
    modifyTable = (self.fomationData).weeklySpFmt
  else
    modifyTable = (self.fomationData).weeklyChallengeFmt
  end
  if fmtDic ~= nil and modifyTable ~= nil then
    if (table.count)(fmtDic) ~= (table.count)(modifyTable) then
      isChanged = true
    else
      for k,v in pairs(modifyTable) do
        if fmtDic[k] == nil or fmtDic[k] ~= v then
          isChanged = true
          break
        end
      end
    end
  else
    do
      if fmtDic ~= modifyTable then
        isChanged = true
      end
      -- DECOMPILER ERROR at PC57: Confused about usage of register: R5 in 'UnsetPending'

      if isChanged then
        if wcType == (WCEnum.eWeeklyChallengeType).special then
          (self.fomationData).weeklySpFmt = fmtDic
        else
          -- DECOMPILER ERROR at PC60: Confused about usage of register: R5 in 'UnsetPending'

          ;
          (self.fomationData).weeklyChallengeFmt = fmtDic
        end
        self:SetPstDataDirty()
      end
    end
  end
end

UserData.GetLastWeeklySkillList = function(self, wcType)
  -- function num : 0_58 , upvalues : WCEnum
  if self.fomationData ~= nil then
    if wcType == (WCEnum.eWeeklyChallengeType).special then
      return (self.fomationData).weeklySpTreeId
    end
    return (self.fomationData).weeklyChallengeTreeId
  end
  return nil, nil
end

UserData.SetLastWeeklySkillList = function(self, wcType, treeId)
  -- function num : 0_59 , upvalues : WCEnum
  if self.fomationData == nil then
    self:__InitFormationData()
  end
  local isChanged = false
  local lastTreeId = 0
  if wcType == (WCEnum.eWeeklyChallengeType).special then
    lastTreeId = (self.fomationData).weeklySpTreeId
  else
    lastTreeId = (self.fomationData).weeklyChallengeTreeId
  end
  if lastTreeId ~= treeId then
    isChanged = true
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  if isChanged then
    if wcType == (WCEnum.eWeeklyChallengeType).special then
      (self.fomationData).weeklySpTreeId = treeId
    else
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.fomationData).weeklyChallengeTreeId = treeId
    end
    self:SetPstDataDirty()
  end
end

UserData.GetIsSReddotClose = function(self, redDotLoactionString)
  -- function num : 0_60
  return ((self.specialReddotData).specialReddotDic)[redDotLoactionString]
end

UserData.SetSReddotClose = function(self, redDotLoactionString, bool)
  -- function num : 0_61 , upvalues : _ENV
  local last = ((self.specialReddotData).specialReddotDic)[redDotLoactionString]
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  if last ~= bool then
    ((self.specialReddotData).specialReddotDic)[redDotLoactionString] = bool
    self:SetPstDataDirty()
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
  end
end

UserData.GetNewGiftItemReddotDic = function(self)
  -- function num : 0_62
  return (self.specialReddotData).newGiftItemDic
end

UserData.SetNewGiftItemReddot = function(self, itemId, value)
  -- function num : 0_63
  local last = ((self.specialReddotData).newGiftItemDic)[itemId]
  if last == value then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).newGiftItemDic)[itemId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetNewPayGiftItemIsNotNew = function(self, payGiftId)
  -- function num : 0_64
  return ((self.specialReddotData).newPayGiftItemDic)[payGiftId]
end

UserData.SetNewGiftItemIsNotNew = function(self, payGiftId, value)
  -- function num : 0_65
  local last = ((self.specialReddotData).newPayGiftItemDic)[payGiftId]
  if last == value then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).newPayGiftItemDic)[payGiftId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetNewItemReddotDic = function(self)
  -- function num : 0_66
  return (self.specialReddotData).newItemDic
end

UserData.SetNewItemReddot = function(self, itemId, value)
  -- function num : 0_67
  local last = ((self.specialReddotData).newItemDic)[itemId]
  if last == value then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).newItemDic)[itemId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetLastMonthCardRenew = function(self)
  -- function num : 0_68
  return (self.specialReddotData).lastMonthCardRenew
end

UserData.SetLastMonthCardRenew = function(self, time)
  -- function num : 0_69
  local last = (self.specialReddotData).lastMonthCardRenew
  if last == time then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.specialReddotData).lastMonthCardRenew = time
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetNewDormHouseReaded = function(self, houseId)
  -- function num : 0_70
  return ((self.specialReddotData).newDormHouseDic)[houseId] or false
end

UserData.SetNewDormHouseReaded = function(self, houseId, value)
  -- function num : 0_71
  local last = ((self.specialReddotData).newDormHouseDic)[houseId]
  if last == value then
    return false
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).newDormHouseDic)[houseId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
  return true
end

UserData.GetUnlockableDormHouseReaded = function(self, houseId)
  -- function num : 0_72
  return (self.specialReddotData).unlockableDormHouseDic and ((self.specialReddotData).unlockableDormHouseDic)[houseId] or false
end

UserData.SetUnlockableDormHouseReaded = function(self, houseId, value)
  -- function num : 0_73
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if (self.specialReddotData).unlockableDormHouseDic == nil then
    (self.specialReddotData).unlockableDormHouseDic = {}
  end
  local last = ((self.specialReddotData).unlockableDormHouseDic)[houseId]
  if last == value then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).unlockableDormHouseDic)[houseId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetDunTwinTowerRacingReaded = function(self)
  -- function num : 0_74
  return (self.specialReddotData).tower_racing_reward or false
end

UserData.SetDunTwinTowerRacingReaded = function(self, value)
  -- function num : 0_75
  local last = (self.specialReddotData).tower_racing_reward
  if last == value then
    return false
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.specialReddotData).tower_racing_reward = value
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
  return true
end

UserData.GetFirstOpenTaskReddotDic = function(self)
  -- function num : 0_76
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if (self.specialReddotData).firstOpenTask == nil then
    (self.specialReddotData).firstOpenTask = {}
  end
  return (self.specialReddotData).firstOpenTask
end

UserData.SetNewFirstOpenTaskReddot = function(self, open_condition, value)
  -- function num : 0_77 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if (self.specialReddotData).firstOpenTask == nil then
    (self.specialReddotData).firstOpenTask = {}
  end
  local last = ((self.specialReddotData).firstOpenTask)[open_condition]
  if last == value then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).firstOpenTask)[open_condition] = value
  self:SetPstDataDirty()
  PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
end

UserData.GetActLimitNewTaskReddot = function(self, actFrameId, taskId)
  -- function num : 0_78
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if actFrameId ~= (self.specialReddotData).actLimitNewTaskActFrameId then
    (self.specialReddotData).actLimitNewTaskDic = {}
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.specialReddotData).actLimitNewTaskActFrameId = actFrameId
    self:SetPstDataDirty()
  end
  return not ((self.specialReddotData).actLimitNewTaskDic)[taskId]
end

UserData.SetActLimitNewTaskReddot = function(self, taskId)
  -- function num : 0_79
  if ((self.specialReddotData).actLimitNewTaskDic)[taskId] == true then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.specialReddotData).actLimitNewTaskDic)[taskId] = true
  self:SetPstDataDirty()
end

UserData.GetIsAutoBattle = function(self)
  -- function num : 0_80
  return (self.userSetting).isAutoBattle or false
end

UserData.SetIsAutoBattle = function(self, isAutoBattle)
  -- function num : 0_81
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  if (self.userSetting).isAutoBattle ~= isAutoBattle then
    (self.userSetting).isAutoBattle = isAutoBattle
    self:SetPstDataDirty()
  end
end

UserData.GetBattleSpeed = function(self)
  -- function num : 0_82
  return ((self.userSetting).battleSpeed or 0) + 1
end

UserData.SetBattleSpeed = function(self, battleSpeed)
  -- function num : 0_83
  battleSpeed = battleSpeed - 1
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if (self.userSetting).battleSpeed ~= battleSpeed then
    (self.userSetting).battleSpeed = battleSpeed
    self:SetPstDataDirty()
  end
end

UserData.SetUnitBlood = function(self, unitBlood, bossUnitBlood)
  -- function num : 0_84
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if unitBlood ~= (self.dungeonExtrData).unitBlood or bossUnitBlood ~= (self.dungeonExtrData).bossUnitBlood then
    (self.dungeonExtrData).unitBlood = unitBlood
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.dungeonExtrData).bossUnitBlood = bossUnitBlood
    self:SetPstDataDirty()
  end
end

UserData.GetUnitBlood = function(self)
  -- function num : 0_85
  if self.dungeonExtrData == nil then
    return 
  end
  return (self.dungeonExtrData).unitBlood, (self.dungeonExtrData).bossUnitBlood
end

UserData.__InitGameNoticeData = function(self)
  -- function num : 0_86
  if self.gameNoticeData ~= nil then
    return 
  end
  self.gameNoticeData = {timestamp = 0, 
readNotice = {}
}
end

UserData.SaveIsReadGameNotice = function(self, noticeID)
  -- function num : 0_87
  self:__InitGameNoticeData()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.gameNoticeData).readNotice)[noticeID] ~= true then
    ((self.gameNoticeData).readNotice)[noticeID] = true
    self:SetPstDataDirty()
  end
end

UserData.SaveGameNoticeTimestamp = function(self, timestamp)
  -- function num : 0_88
  self:__InitGameNoticeData()
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.gameNoticeData).timestamp = timestamp
  self:SetPstDataDirty()
end

UserData.GetGameNoticeTimestamp = function(self, timestamp)
  -- function num : 0_89
  if self.gameNoticeData == nil then
    return 0
  end
  return (self.gameNoticeData).timestamp
end

UserData.ContainGameNoticeIsRead = function(self, noticeID)
  -- function num : 0_90
  if self.gameNoticeData == nil then
    return false
  end
  return ((self.gameNoticeData).readNotice)[noticeID]
end

UserData.DiffLocalGNReadData = function(self, noticeIds)
  -- function num : 0_91 , upvalues : _ENV
  if self.gameNoticeData == nil or noticeIds == nil then
    return 
  end
  for id,bool in pairs((self.gameNoticeData).readNotice) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

    if noticeIds[id] == nil then
      ((self.gameNoticeData).readNotice)[id] = nil
    end
  end
  self:SetPstDataDirty()
end

UserData.ReadIsReceiveFriendApplication = function(self)
  -- function num : 0_92
  return not (self:GetNoticeSwitchOff())[100]
end

UserData.SaveAvgNoun = function(self, nounid)
  -- function num : 0_93
  if (self.avgnoundic)[nounid] then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.avgnoundic)[nounid] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(3)
end

UserData.GetAvgNounIsRead = function(self, nounid)
  -- function num : 0_94
  if self.avgnoundic == nil then
    return false
  end
  if (self.avgnoundic)[nounid] == nil then
    return false
  end
  return (self.avgnoundic)[nounid]
end

UserData.GetAvgplayspeed = function(self)
  -- function num : 0_95
  return self.avgplayspeed
end

UserData.Saveavgspeed = function(self, speed)
  -- function num : 0_96
  self.avgplayspeed = speed
  self:SetPstDataDirty()
end

UserData.GetActEntranceLastShow = function(self, id)
  -- function num : 0_97
  return ((self.activityData).entranceLastShow)[id] or 0
end

UserData.SaveActEntranceLastShow = function(self, id, time)
  -- function num : 0_98 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.activityData).entranceLastShow)[id] = time
  for tid,ttime in pairs((self.activityData).entranceLastShow) do
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R8 in 'UnsetPending'

    if tid ~= id and CommonUtil.DaySeconds < (math.abs)(ttime - time) then
      ((self.activityData).entranceLastShow)[tid] = 0
    end
  end
  self:SetPstDataDirty()
end

UserData._NewChallengeStageTab = function(self)
  -- function num : 0_99
  self:SetPstDataDirty()
  return {isOpen = false, 
optionalTask = {}
}
end

UserData.GetChallengeStageSwitch = function(self, stageId)
  -- function num : 0_100 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  if (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskCompleteAll(stageId) then
    if (self.challengeStageDic)[stageId] ~= nil then
      (self.challengeStageDic)[stageId] = nil
      self:SetPstDataDirty()
    end
    return false
  end
  local challengeStageTab = (self.challengeStageDic)[stageId]
  if challengeStageTab == nil then
    return false
  else
    return challengeStageTab.isOpen
  end
end

UserData.SetChallengeStageSwitch = function(self, stageId, isOpen)
  -- function num : 0_101
  if not (self.challengeStageDic)[stageId] then
    local challengeStageTab = self:_NewChallengeStageTab()
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.challengeStageDic)[stageId] = challengeStageTab
  if challengeStageTab.isOpen == isOpen then
    return 
  end
  challengeStageTab.isOpen = isOpen
  self:SetPstDataDirty()
end

UserData.GetChallengeStageTaskOptDic = function(self, stageId)
  -- function num : 0_102 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  if (PlayerDataCenter.sectorAchievementDatas):IsStageChallengeTaskCompleteAll(stageId) then
    if (self.challengeStageDic)[stageId] ~= nil then
      (self.challengeStageDic)[stageId] = nil
      self:SetPstDataDirty()
    end
    return table.emptytable
  end
  local challengeStageTab = (self.challengeStageDic)[stageId]
  if challengeStageTab == nil then
    return table.emptytable
  else
    return challengeStageTab.optionalTask
  end
end

UserData.SetChallengeStageTaskOptDic = function(self, stageId, taskIdDic)
  -- function num : 0_103 , upvalues : _ENV
  if not (self.challengeStageDic)[stageId] then
    local challengeStageTab = self:_NewChallengeStageTab()
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.challengeStageDic)[stageId] = challengeStageTab
  if (table.IsDicValueSame)(taskIdDic, challengeStageTab.optionalTask) then
    return 
  end
  challengeStageTab.optionalTask = taskIdDic
  self:SetPstDataDirty()
end

UserData.TryClearActivityHeroData = function(self, ingoreActTable)
  -- function num : 0_104 , upvalues : _ENV
  if self.activityData == nil or (self.activityData).activityHeros == nil then
    return 
  end
  local apply = false
  for actId,v in pairs((self.activityData).activityHeros) do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[actId] == nil then
      ((self.activityData).activityHeros)[actId] = nil
      apply = true
    end
  end
  if apply then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.IsActivityHeroShopRead = function(self, actId, shopId)
  -- function num : 0_105
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    return false
  end
  return (activityHero.shopReads)[shopId] or false
end

UserData.SetActivityHeroShopReaded = function(self, actId, shopId)
  -- function num : 0_106
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  else
    if (activityHero.shopReads)[shopId] then
      return 
    end
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (activityHero.shopReads)[shopId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetHeroGrowAvgReview = function(self, actId, stageId)
  -- function num : 0_107
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    return false
  end
  if activityHero.avgReviewDic == nil then
    return 
  end
  return (activityHero.avgReviewDic)[stageId] or false
end

UserData.SetHeroGrowAvgReview = function(self, actId, stageId)
  -- function num : 0_108
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  else
    if (activityHero.avgReviewDic)[stageId] then
      return 
    end
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (activityHero.avgReviewDic)[stageId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetHeroGrowChallengeStageId = function(self, actId)
  -- function num : 0_109
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    return 0
  end
  return activityHero.challengeStageLooked
end

UserData.SetHeroGrowChallengeStageId = function(self, actId, stageId)
  -- function num : 0_110
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  end
  activityHero.challengeStageLooked = stageId
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetHeroGrowDailyTask = function(self, actId)
  -- function num : 0_111
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    return nil
  end
  local dayDic = {}
  local dailyTaskLooked = activityHero.dailyTaskLooked or 0
  local day = 0
  while dailyTaskLooked > 0 do
    day = day + 1
    dailyTaskLooked = dailyTaskLooked >> 1
    if dailyTaskLooked & 1 == 1 then
      dayDic[day] = true
    end
  end
  return dayDic
end

UserData.SetHeroGrowDailyTask = function(self, actId, day)
  -- function num : 0_112
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  end
  local addtion = 1 << day
  if activityHero.dailyTaskLooked & addtion > 0 then
    return 
  end
  activityHero.dailyTaskLooked = activityHero.dailyTaskLooked + addtion
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetHeroGrowBattleDungeon = function(self, actId, dungeonId)
  -- function num : 0_113
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  end
  return (activityHero.dungeonBattle)[dungeonId]
end

UserData.SetHeroGrowBattleDungeon = function(self, actId, dungeonId)
  -- function num : 0_114
  local activityHero = ((self.activityData).activityHeros)[actId]
  if activityHero == nil then
    activityHero = self:__CreateDefaultActivityHero()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityHeros)[actId] = activityHero
  end
  if (activityHero.dungeonBattle)[dungeonId] then
    return 
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (activityHero.dungeonBattle)[dungeonId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.SetSectorIIIsTurnOnMultEfficient = function(self, actId, bool)
  -- function num : 0_115
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  if ((self.activityData).sectorIIDataDic)[actId] == nil then
    ((self.activityData).sectorIIDataDic)[actId] = {}
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.activityData).sectorIIDataDic)[actId]).isTurnOnMultEfficient = bool
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetSectorIIIsTurnOnMultEfficient = function(self, actId)
  -- function num : 0_116
  local activity_sectorII = ((self.activityData).sectorIIDataDic)[actId]
  if activity_sectorII == nil then
    return false
  end
  return activity_sectorII.isTurnOnMultEfficient
end

UserData.SetSectorIIRecommendShopIsLooked = function(self, shopId, bool)
  -- function num : 0_117
  if ((self.activityData).sectorIIRecommendShopDic)[shopId] == bool then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.activityData).sectorIIRecommendShopDic)[shopId] = bool
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetSectorIIRecommendShopIsLooked = function(self, shopId)
  -- function num : 0_118
  return ((self.activityData).sectorIIRecommendShopDic)[shopId]
end

UserData.SetChipGiftPopIgnore = function(self, giftId, time, endTime)
  -- function num : 0_119 , upvalues : _ENV
  if time ~= nil then
    time = (math.floor)(time)
  end
  if endTime ~= nil then
    endTime = (math.floor)(endTime)
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  if (self.chipGiftPop).ignoreEndTime == nil then
    (self.chipGiftPop).ignoreEndTime = {}
  end
  if ((self.chipGiftPop).ignoreTime)[giftId] == time and ((self.chipGiftPop).ignoreEndTime)[giftId] == endTime then
    return 
  end
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.chipGiftPop).ignoreTime)[giftId] = time
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.chipGiftPop).ignoreEndTime)[giftId] = endTime
  self:SetPstDataDirty()
end

UserData.GetChipGiftPopIgnore = function(self, giftId)
  -- function num : 0_120
  local endTime = nil
  if (self.chipGiftPop).ignoreEndTime ~= nil then
    endTime = ((self.chipGiftPop).ignoreEndTime)[giftId]
  end
  return ((self.chipGiftPop).ignoreTime)[giftId], endTime
end

UserData.TryClearChipGiftPopIgnore = function(self)
  -- function num : 0_121 , upvalues : _ENV
  local giftCfg = ConfigData.pay_gift_type
  local dataDirty = false
  for id,v in pairs((self.chipGiftPop).ignoreTime) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R8 in 'UnsetPending'

    if giftCfg[id] == nil then
      ((self.chipGiftPop).ignoreTime)[id] = nil
      dataDirty = true
    end
  end
  if (self.chipGiftPop).ignoreEndTime ~= nil then
    for id,v in pairs((self.chipGiftPop).ignoreEndTime) do
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

      if giftCfg[id] == nil then
        ((self.chipGiftPop).ignoreTime)[id] = nil
        dataDirty = true
      end
    end
  end
  do
    if dataDirty then
      self:SetPstDataDirty()
      self:DelaySavePstData(2)
    end
  end
end

UserData.IsGuidPicLooked = function(self, tipsId)
  -- function num : 0_122
  if self.guidePicIdDic == nil then
    return false
  end
  return (self.guidePicIdDic)[tipsId]
end

UserData.RecordGuidPicLooked = function(self, tipsId)
  -- function num : 0_123
  if self.guidePicIdDic == nil then
    self.guidePicIdDic = {}
  end
  if (self.guidePicIdDic)[tipsId] then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.guidePicIdDic)[tipsId] = true
  self:SetPstDataDirty()
end

UserData.RecordCarnivalDiffEnv = function(self, actId, envId, diffculty)
  -- function num : 0_124
  local singleData = ((self.activityData).activityCarnivalDic)[actId]
  if singleData == nil then
    singleData = self:__InitActivityCarnival()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.activityData).activityCarnivalDic)[actId] = singleData
  end
  local recordValue = envId << 16 | diffculty
  if singleData.diffEnv == recordValue then
    return 
  end
  singleData.diffEnv = recordValue
  self:SetPstDataDirty()
  self:DelaySavePstData(2)
end

UserData.GetCarnivalDiffEnv = function(self, actId)
  -- function num : 0_125
  local singleData = ((self.activityData).activityCarnivalDic)[actId]
  if singleData == nil then
    return nil, nil
  end
  if singleData.diffEnv == 0 then
    return nil, nil
  end
  return singleData.diffEnv >> 16, singleData.diffEnv & 65535
end

UserData.SetCarnivalAvg = function(self, actId, avgId)
  -- function num : 0_126
  local singleData = ((self.activityData).activityCarnivalDic)[actId]
  if singleData == nil then
    singleData = self:__InitActivityCarnival()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).activityCarnivalDic)[actId] = singleData
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (singleData.avgReviewDic)[avgId] = true
end

UserData.GetCarnivalAvg = function(self, actId, avgId)
  -- function num : 0_127
  local singleData = ((self.activityData).activityCarnivalDic)[actId]
  if singleData == nil then
    return false
  end
  return (singleData.avgReviewDic)[avgId]
end

UserData.TryDeleteCarnival = function(self, ingoreActTable)
  -- function num : 0_128 , upvalues : _ENV
  if self.activityData == nil or (self.activityData).activityCarnivalDic == nil then
    return 
  end
  local apply = false
  for actId,v in pairs((self.activityData).activityCarnivalDic) do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[actId] == nil then
      ((self.activityData).activityCarnivalDic)[actId] = nil
      apply = true
    end
  end
  if apply then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.RecordADCEnterTime = function(self, actId, time)
  -- function num : 0_129 , upvalues : _ENV
  time = (math.floor)(time)
  local apply = false
  local recordTable = ((self.activityData).adcDic)[actId]
  if recordTable == nil then
    recordTable = {}
    recordTable.enterTime = time
    recordTable.buffSelect = {}
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.activityData).adcDic)[actId] = recordTable
    apply = true
  else
    if recordTable.enterTime ~= time then
      recordTable.enterTime = time
      apply = true
    end
  end
  if apply then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetADCEnterTime = function(self, actId)
  -- function num : 0_130
  local recordTable = ((self.activityData).adcDic)[actId]
  if recordTable == nil then
    return 0
  end
  return recordTable.enterTime or 0
end

UserData.RecordADCBuffSelect = function(self, actId, dungeonOrder, buffSelectDic)
  -- function num : 0_131 , upvalues : _ENV
  local apply = false
  local recordTable = ((self.activityData).adcDic)[actId]
  if recordTable == nil then
    recordTable = {}
    recordTable.enterTime = 0
    recordTable.buffSelect = {}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.activityData).adcDic)[actId] = recordTable
  end
  local ingoreDic = {}
  local targetValue = 1 << dungeonOrder
  for k,v in pairs(recordTable.buffSelect) do
    if v & targetValue > 0 then
      if buffSelectDic[k] ~= nil then
        ingoreDic[k] = true
      else
        -- DECOMPILER ERROR at PC30: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (recordTable.buffSelect)[k] = v ~ targetValue
        apply = true
      end
    end
  end
  for k,_ in pairs(buffSelectDic) do
    if not (recordTable.buffSelect)[k] then
      local recordValue = ingoreDic[k] or 0
    end
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R14 in 'UnsetPending'

    if recordValue & targetValue == 0 then
      (recordTable.buffSelect)[k] = recordValue | targetValue
      apply = true
    end
  end
  if apply then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetADCBuffSelect = function(self, actId, dungeonOrder)
  -- function num : 0_132 , upvalues : _ENV
  local buffDic = {}
  local recordTable = ((self.activityData).adcDic)[actId]
  if recordTable == nil then
    return buffDic
  end
  local targetValue = 1 << dungeonOrder
  for k,v in pairs(recordTable.buffSelect) do
    if v & targetValue > 0 then
      buffDic[k] = true
    end
  end
  return buffDic
end

UserData.TryDeleteADCEnterTime = function(self, ingoreActTable)
  -- function num : 0_133 , upvalues : _ENV
  if self.activityData == nil or (self.activityData).adcDic == nil then
    return 
  end
  local apply = false
  for actId,v in pairs((self.activityData).adcDic) do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[actId] == nil then
      ((self.activityData).adcDic)[actId] = nil
      apply = true
    end
  end
  if apply then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetTwinTowerNewReaded = function(self, towerId)
  -- function num : 0_134
  return ((self.specialReddotData).twinTowerReaded)[towerId] or false
end

UserData.SetTwinTowerNewReaded = function(self, towerId, value)
  -- function num : 0_135
  local oldValue = ((self.specialReddotData).twinTowerReaded)[towerId]
  if oldValue == value then
    return false
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.specialReddotData).twinTowerReaded)[towerId] = value
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
  return true
end

UserData.GetNormalTowerLevel = function(self)
  -- function num : 0_136
  return (self.specialReddotData).normalTowerLevel
end

UserData.SetNormalTowerLevel = function(self, value)
  -- function num : 0_137
  local oldValue = (self.specialReddotData).normalTowerLevel
  if oldValue == value then
    return false
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.specialReddotData).normalTowerLevel = value
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
  return true
end

UserData.SetHallowmasEnvTaskLooked = function(self, actId, envId)
  -- function num : 0_138
  self:__InitHallowmasData()
  local dataTable = ((self.activityData).hallowmasActivity)[actId]
  if dataTable == nil then
    dataTable = {
envTaskLookedDic = {}
}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).hallowmasActivity)[actId] = dataTable
  end
  if (dataTable.envTaskLookedDic)[envId] then
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (dataTable.envTaskLookedDic)[envId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetHallowmasEnvTaskLooked = function(self, actId, envId)
  -- function num : 0_139
  if (self.activityData).hallowmasActivity == nil then
    return false
  end
  local dataTable = ((self.activityData).hallowmasActivity)[actId]
  if dataTable == nil then
    return false
  end
  return (dataTable.envTaskLookedDic)[envId]
end

UserData.TryClearHallowmas = function(self, ingoreActTable)
  -- function num : 0_140 , upvalues : _ENV
  if (self.activityData).hallowmasActivity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).hallowmasActivity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).hallowmasActivity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.SetSpring23HardLevelLooked = function(self, actId)
  -- function num : 0_141
  self:__InitSpring23Data()
  local dataTable = ((self.activityData).spring23Activity)[actId]
  if dataTable == nil then
    dataTable = {enterHardLevel = false, 
notEnteredNewEnv = {}
}
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.activityData).spring23Activity)[actId] = dataTable
  end
  if dataTable.enterHardLevel then
    return 
  end
  dataTable.enterHardLevel = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetSpring23HardLevelLooked = function(self, actId)
  -- function num : 0_142
  if (self.activityData).spring23Activity == nil then
    return false
  end
  local dataTable = ((self.activityData).spring23Activity)[actId]
  if dataTable == nil then
    return false
  end
  return dataTable.enterHardLevel
end

UserData.SetSpring23IsNotEnteredNewEnv = function(self, actId, envId, bool)
  -- function num : 0_143
  self:__InitSpring23Data()
  local dataTable = ((self.activityData).spring23Activity)[actId]
  if dataTable == nil then
    dataTable = {enterHardLevel = false, 
notEnteredNewEnv = {}
}
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.activityData).spring23Activity)[actId] = dataTable
  end
  if dataTable.notEnteredNewEnv == nil then
    dataTable.notEnteredNewEnv = {}
  end
  local isNeedUpdate = false
  if (dataTable.notEnteredNewEnv)[envId] == true then
    isNeedUpdate = not bool
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (dataTable.notEnteredNewEnv)[envId] = true
    isNeedUpdate = (dataTable.notEnteredNewEnv)[envId] ~= nil
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (dataTable.notEnteredNewEnv)[envId] = nil
    if isNeedUpdate then
      self:SetPstDataDirty()
      self:DelaySavePstData(1)
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UserData.GetSpring23IsNotEnteredNewEnv = function(self, actId, envId)
  -- function num : 0_144
  if (self.activityData).spring23Activity == nil then
    return false
  end
  local dataTable = ((self.activityData).spring23Activity)[actId]
  if dataTable == nil then
    return false
  end
  if dataTable.notEnteredNewEnv == nil then
    return false
  end
  do return (dataTable.notEnteredNewEnv)[envId] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UserData.TryClearSpring = function(self, ingoreActTable)
  -- function num : 0_145 , upvalues : _ENV
  if (self.activityData).spring23Activity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).spring23Activity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).spring23Activity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.SetComebackPopLooked = function(self, actId)
  -- function num : 0_146
  self:__InitComebackData()
  local dataTable = ((self.activityData).comebackActivity)[actId]
  if dataTable == nil then
    dataTable = {popLooked = true}
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.activityData).comebackActivity)[actId] = dataTable
  end
  dataTable.popLooked = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetComebackPopLooked = function(self, actId)
  -- function num : 0_147
  if (self.activityData).comebackActivity == nil then
    return false
  end
  local dataTable = ((self.activityData).comebackActivity)[actId]
  if dataTable == nil then
    return false
  end
  return dataTable.popLooked
end

UserData.TryClearComebackPopLooked = function(self, ingoreActTable)
  -- function num : 0_148 , upvalues : _ENV
  if (self.activityData).comebackActivity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).comebackActivity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).comebackActivity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetWinter23ShopLooked = function(self, actId, shopId)
  -- function num : 0_149
  if (self.activityData).winter23Activity == nil then
    return false
  end
  local dataTable = ((self.activityData).winter23Activity)[actId]
  if dataTable == nil or dataTable.shopReads == nil then
    return false
  end
  return (dataTable.shopReads)[shopId]
end

UserData.SetWinter23ShopLooked = function(self, actId, shopId)
  -- function num : 0_150
  self:__InitWinter23Data()
  local dataTable = ((self.activityData).winter23Activity)[actId]
  if dataTable == nil then
    dataTable = {
shopReads = {}
}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).winter23Activity)[actId] = dataTable
  end
  if (dataTable.shopReads)[shopId] then
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (dataTable.shopReads)[shopId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetWinter23FirstEnterSectorId = function(self, actId)
  -- function num : 0_151
  if (self.activityData).winter23Activity == nil then
    return false
  end
  local dataTable = ((self.activityData).winter23Activity)[actId]
  if dataTable == nil or dataTable.firstEnterSectorId == nil then
    return false
  end
  return dataTable.firstEnterSectorId
end

UserData.SetWinter23FirstEnterSectorId = function(self, actId, sectorId)
  -- function num : 0_152
  self:__InitWinter23Data()
  local dataTable = ((self.activityData).winter23Activity)[actId]
  if dataTable == nil then
    dataTable = {
shopReads = {}
}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).winter23Activity)[actId] = dataTable
  end
  dataTable.firstEnterSectorId = sectorId
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.TryClearWinter23 = function(self, ingoreActTable)
  -- function num : 0_153 , upvalues : _ENV
  if (self.activityData).winter23Activity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).winter23Activity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).winter23Activity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetInvitationLooked = function(self, actId)
  -- function num : 0_154
  if (self.activityData).invitationActivity == nil then
    return false
  end
  local dataTable = ((self.activityData).invitationActivity)[actId]
  do return (dataTable ~= nil and dataTable.isFirstEnter) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UserData.SetInvitationLooked = function(self, actId)
  -- function num : 0_155
  self:__InitInvitationData()
  local dataTable = ((self.activityData).invitationActivity)[actId]
  if dataTable == nil then
    dataTable = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.activityData).invitationActivity)[actId] = dataTable
  end
  if dataTable.isFirstEnter then
    return 
  end
  if not dataTable then
    dataTable = {}
  end
  dataTable.isFirstEnter = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.TryClearInvitationLooked = function(self, ingoreActTable)
  -- function num : 0_156 , upvalues : _ENV
  if (self.activityData).invitationActivity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).invitationActivity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).invitationActivity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetWeeklyQALooked = function(self, actId, order)
  -- function num : 0_157
  if (self.activityData).answerActivity == nil then
    return false
  end
  local dataTable = ((self.activityData).answerActivity)[actId]
  do return dataTable ~= nil and dataTable.lastEnteredOrder == order end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UserData.SetWeeklyQALooked = function(self, actId, order)
  -- function num : 0_158
  self:__InitWeeklyQAData()
  local dataTable = ((self.activityData).answerActivity)[actId]
  if dataTable == nil then
    dataTable = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).answerActivity)[actId] = dataTable
  end
  if dataTable.lastEnteredOrder == order then
    return 
  end
  if not dataTable then
    dataTable = {}
  end
  dataTable.lastEnteredOrder = order
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.TryClearWeeklyQALooked = function(self, ingoreActTable)
  -- function num : 0_159 , upvalues : _ENV
  if (self.activityData).answerActivity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).answerActivity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).answerActivity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.GetAngelaGiftLooked = function(self, actId)
  -- function num : 0_160
  if (self.activityData).angelaGiftActivity == nil then
    return false
  end
  local dataTable = ((self.activityData).angelaGiftActivity)[actId]
  do return (dataTable ~= nil and dataTable.isLooked) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UserData.SetAngelaGiftLooked = function(self, actId)
  -- function num : 0_161
  self:__InitAngelaGiftData()
  local dataTable = ((self.activityData).angelaGiftActivity)[actId]
  if dataTable == nil then
    dataTable = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.activityData).angelaGiftActivity)[actId] = dataTable
  end
  if dataTable.isLooked then
    return 
  end
  if not dataTable then
    dataTable = {}
  end
  dataTable.isLooked = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetAngelaGiftCanPop = function(self, actId)
  -- function num : 0_162 , upvalues : _ENV
  if (self.activityData).angelaGiftActivity == nil then
    return true
  end
  local dataTable = ((self.activityData).angelaGiftActivity)[actId]
  do return dataTable == nil or dataTable.cantShowTime == nil or dataTable.cantShowTime <= PlayerDataCenter.timestamp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UserData.SetAngelaGiftCantShowTime = function(self, actId, nextTm)
  -- function num : 0_163
  self:__InitAngelaGiftData()
  local dataTable = ((self.activityData).angelaGiftActivity)[actId]
  if dataTable == nil then
    dataTable = {}
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.activityData).angelaGiftActivity)[actId] = dataTable
  end
  if not dataTable then
    dataTable = {}
  end
  dataTable.cantShowTime = nextTm
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.TryClearAngelaGiftLooked = function(self, ingoreActTable)
  -- function num : 0_164 , upvalues : _ENV
  if (self.activityData).angelaGiftActivity == nil then
    return 
  end
  local isClear = false
  for k,v in pairs((self.activityData).angelaGiftActivity) do
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ingoreActTable[k] == nil then
      ((self.activityData).angelaGiftActivity)[k] = nil
      isClear = true
    end
  end
  if isClear then
    self:SetPstDataDirty()
    self:DelaySavePstData(1)
  end
end

UserData.SetSpeacWeaponLooked = function(self, weaponId)
  -- function num : 0_165
  if ((self.specialReddotData).specWeaponLookedDic)[weaponId] then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.specialReddotData).specWeaponLookedDic)[weaponId] = true
  self:SetPstDataDirty()
  self:DelaySavePstData(1)
end

UserData.GetSpeacWeaponLooked = function(self, weaponId)
  -- function num : 0_166
  return ((self.specialReddotData).specWeaponLookedDic)[weaponId]
end

return UserData

