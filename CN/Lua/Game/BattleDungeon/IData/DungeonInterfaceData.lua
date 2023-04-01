-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonInterfaceData = class("DungeonInterfaceData")
local FmtEnum = require("Game.Formation.FmtEnum")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
DungeonInterfaceData.ctor = function(self)
  -- function num : 0_0 , upvalues : DungeonLevelEnum, _ENV
  self.__interfaceType = (DungeonLevelEnum.InterfaceType).Default
  self.__ableSelectChipSuit = false
  self.__chipSuitPool = nil
  self.__chipSuitSelectMax = 0
  self.__chipSuitQuality = 0
  self.__chipSuitQualityDic = {}
  self.__limitUseSuitCount = false
  self.__chipSuitNum = nil
  self.__lastSelectSuit = {}
  self.__ableNextLevelBattle = false
  self.__nextStaminaCost = 0
  self.__staminaReplaceItemId = nil
  self.__ableReplaytLevelBattle = false
  self.__ableFailRestart = false
  self.__replayStaminaCost = 0
  self.__replayStaminaReplaceItemId = nil
  self.__notShowCouldUseTime = nil
  self.__enableRacingTime = false
  self.__lastRacingTime = -1
  self.__isHideRacingTimeCompare = false
  self.__isNeedShowBuff = false
  self.__addedBuffDic = {}
  self.__deletedBuffDic = {}
  self.__restartBattleEvent = nil
  self.__nextBattleEvent = nil
  self.__dungeonStageData = nil
  self.__dungeonLevelData = nil
  self.__wait2UnlockChipPoolList = nil
  self.__wait4UnlockChipSuitUnlockInfoList = nil
  self._dungeonDyncData = nil
  self._fmtFromModule = nil
  self.__luckDropDic = nil
  self.__notShowExtrAward = false
  self.__defeatAdviseList = nil
  self.__isNeedRecordFormation = true
  self.__formationRuleCfg = (ConfigData.formation_rule)[0]
  self.__afterClickBattleFunc = nil
  self.__listen2OverKill = false
end

DungeonInterfaceData.CreateDefaultBattleInterface = function()
  -- function num : 0_1 , upvalues : DungeonInterfaceData
  return (DungeonInterfaceData.New)()
end

DungeonInterfaceData.CreateDailyDungeonInterface = function(dailyDgDyncData)
  -- function num : 0_2 , upvalues : DungeonInterfaceData, DungeonLevelEnum, _ENV, FmtEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).DailyDungeon
  interfaceData.__ableSelectChipSuit = true
  local stageId = dailyDgDyncData:GetDailyDgNextLvDungeonId()
  local dungeonCfg = (ConfigData.battle_dungeon)[stageId]
  local material_dungeonCfg = (ConfigData.material_dungeon)[dungeonCfg.module_id]
  interfaceData.__chipSuitSelectMax = material_dungeonCfg.chip_select_max
  interfaceData.__chipSuitQuality = material_dungeonCfg.chip_quality
  interfaceData.__chipSuitPool = material_dungeonCfg.chip_pool
  interfaceData.__limitUseSuitCount = true
  interfaceData.__chipSuitNum = material_dungeonCfg.chipSuitNumMaxDic
  interfaceData._fmtFromModule = (FmtEnum.eFmtFromModule).DailyDungeon
  interfaceData._dungeonDyncData = dailyDgDyncData
  return interfaceData
end

DungeonInterfaceData.CreateSctWinChallengeInterface = function(dungeonLevelData)
  -- function num : 0_3 , upvalues : DungeonInterfaceData, DungeonLevelEnum, FmtEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__ableSelectChipSuit = true
  interfaceData.__isNeedRecordFormation = false
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).WinterChallenge
  local selectMax = dungeonLevelData:GetSectorIIDun_ChipSuitLimitNum()
  local sectorIIData = dungeonLevelData:GetSectorIIActivityData()
  local chipPoolList, chipPoolQualityDic = sectorIIData:GetSectorII_ChipSuitPool()
  local wait2UnlockChipPoolList, wait4UnlockChipSuitUnlockInfoList = sectorIIData:GetSectorII_Wait4UnlockChipSuit()
  local chipSuitNumDic = dungeonLevelData:GetSctIIChallengeDgSuitNumDic()
  interfaceData.__chipSuitNum = chipSuitNumDic
  interfaceData.__limitUseSuitCount = true
  interfaceData.__chipSuitSelectMax = selectMax
  interfaceData.__chipSuitQuality = 1
  interfaceData.__chipSuitQualityDic = chipPoolQualityDic
  interfaceData.__chipSuitPool = chipPoolList
  interfaceData._fmtFromModule = (FmtEnum.eFmtFromModule).SctIIDunChallenge
  interfaceData.__wait2UnlockChipPoolList = wait2UnlockChipPoolList
  interfaceData.__wait4UnlockChipSuitUnlockInfoList = wait4UnlockChipSuitUnlockInfoList
  interfaceData.__dungeonLevelData = dungeonLevelData
  return interfaceData
end

DungeonInterfaceData.CreateDungeonTowerInterface = function(dungeonLevelData, fmtRuleCfg)
  -- function num : 0_4 , upvalues : DungeonInterfaceData, DungeonLevelEnum, _ENV
  local towerStageId = dungeonLevelData:GetDungeonLevelStageId()
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__isNeedRecordFormation = false
  local chipPool = dungeonLevelData:GetTowerChipSuitPool()
  if #chipPool > 0 then
    interfaceData.__ableSelectChipSuit = true
    interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).DungeonTower
    interfaceData.__chipSuitSelectMax = dungeonLevelData:GetTowerChipSelectMax()
    interfaceData.__chipSuitQuality = dungeonLevelData:GetTowerChipQuality()
    interfaceData.__chipSuitPool = chipPool
  end
  interfaceData.__ableFailRestart = true
  if fmtRuleCfg ~= nil then
    interfaceData.__formationRuleCfg = fmtRuleCfg
  end
  if dungeonLevelData:IsTwinTowerLevel() then
    interfaceData.__enableRacingTime = true
    local time = (PlayerDataCenter.dungeonTowerSData):GetTowerLevelRacingFrame(dungeonLevelData:GetDungeonTowerType(), dungeonLevelData:GetDunTowerLevelNum())
    interfaceData.__lastRacingTime = time
  end
  do
    return interfaceData
  end
end

DungeonInterfaceData.CreateActSectorIIDungeonInterface = function(dungeonLevelData)
  -- function num : 0_5 , upvalues : DungeonInterfaceData, DungeonLevelEnum, _ENV
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__dungeonLevelData = dungeonLevelData
  local selectMax = dungeonLevelData:GetSectorIIDun_ChipSuitLimitNum()
  if selectMax > 0 then
    interfaceData.__ableSelectChipSuit = true
    interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).SectorIIDungeon
    local sectorIIData = dungeonLevelData:GetSectorIIActivityData()
    local chipPoolList, chipPoolQualityDic = sectorIIData:GetSectorII_ChipSuitPool()
    local wait2UnlockChipPoolList, wait4UnlockChipSuitUnlockInfoList = sectorIIData:GetSectorII_Wait4UnlockChipSuit()
    interfaceData.__chipSuitSelectMax = selectMax
    interfaceData.__chipSuitQuality = 1
    interfaceData.__chipSuitQualityDic = chipPoolQualityDic
    interfaceData.__chipSuitPool = chipPoolList
    interfaceData.__wait2UnlockChipPoolList = wait2UnlockChipPoolList
    interfaceData.__wait4UnlockChipSuitUnlockInfoList = wait4UnlockChipSuitUnlockInfoList
    interfaceData.__isNeedShowBuff = true
    interfaceData.__addedBuffDic = sectorIIData:GetSectorII_UnlockedBuffList()
    interfaceData.__deletedBuffDic = sectorIIData:GetSectorII_DelectedBuffList()
    interfaceData.__notShowCouldUseTime = true
    interfaceData.__luckDropDic = {}
    local pointMultRateDic = sectorIIData:GetSectorII_PointMultRat()
    local rewardRate = dungeonLevelData:GetWADunRewardRate()
    for itemId,itemTable in pairs(dungeonLevelData:GetWADunGropShowDic()) do
      local itemNum = nil
      itemNum = itemTable.minValue * 2
      local pointRate = pointMultRateDic[itemId]
      if pointRate ~= nil then
        pointRate = pointRate / 1000
        itemNum = (math.floor)(itemNum * (pointRate + 1))
      end
      -- DECOMPILER ERROR at PC57: Confused about usage of register: R17 in 'UnsetPending'

      ;
      (interfaceData.__luckDropDic)[itemId] = itemNum * rewardRate
    end
    interfaceData.__notShowExtrAward = true
    interfaceData.__defeatAdviseList = sectorIIData:GetBeDefeatJumpList()
  end
  do
    return interfaceData
  end
end

DungeonInterfaceData.CreateARDDungeonInterface = function(dungeonLevelData)
  -- function num : 0_6 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).RefreshDun
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__listen2OverKill = true
  return interfaceData
end

DungeonInterfaceData.CreateCarnivalDungeonInterface = function(dungeonLevelData)
  -- function num : 0_7 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).Carnival
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__listen2OverKill = true
  return interfaceData
end

DungeonInterfaceData.CreateADCDungeonInterface = function(dungeonLevelData, scoreAddRate)
  -- function num : 0_8 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).ADC
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__listen2OverKill = true
  interfaceData.__enableRacingTime = true
  interfaceData.__isHideRacingTimeCompare = true
  interfaceData.__enableScoreAddRate = true
  interfaceData.__scoreAdd = scoreAddRate
  return interfaceData
end

DungeonInterfaceData.CreateActIIIDunInterface = function(dungeonLevelData)
  -- function num : 0_9 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).SectorIIIDungeon
  return interfaceData
end

DungeonInterfaceData.CreateHeroGrowInterface = function(dungeonLevelData)
  -- function num : 0_10 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).HeroGrow
  return interfaceData
end

DungeonInterfaceData.CreateActSeasonDunInterface = function(dungeonLevelData)
  -- function num : 0_11 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).Season
  return interfaceData
end

DungeonInterfaceData.CreateSpringDungeonInterface = function(dungeonLevelData)
  -- function num : 0_12 , upvalues : DungeonInterfaceData, DungeonLevelEnum
  local interfaceData = (DungeonInterfaceData.New)()
  interfaceData.__interfaceType = (DungeonLevelEnum.InterfaceType).Spring
  interfaceData.__dungeonLevelData = dungeonLevelData
  interfaceData.__listen2OverKill = true
  return interfaceData
end

DungeonInterfaceData.GetInterfaceType = function(self)
  -- function num : 0_13
  return self.__interfaceType
end

DungeonInterfaceData.BindDungeonStageData = function(self, dungeonStageData, restartBattleEvent)
  -- function num : 0_14 , upvalues : _ENV
  self.__dungeonStageData = dungeonStageData
  self.__restartBattleEvent = restartBattleEvent
  self.__replayStaminaReplaceItemId = ConstGlobalItem.SKey
  if dungeonStageData ~= nil then
    self:SaveBattleWinRewardInfo(dungeonStageData.dungeonData)
  end
end

DungeonInterfaceData.GetIDungeonStageData = function(self)
  -- function num : 0_15
  return self.__dungeonStageData
end

DungeonInterfaceData.GetIDungeonLevelData = function(self)
  -- function num : 0_16
  return self.__dungeonLevelData
end

DungeonInterfaceData.GetIDungeonRestartEvent = function(self)
  -- function num : 0_17
  return self.__restartBattleEvent
end

DungeonInterfaceData.GetIDungeonNextLevelEvent = function(self)
  -- function num : 0_18
  return self.__nextBattleEvent
end

DungeonInterfaceData.SetDungeonNextInfo = function(self, nextBattleEvent, nextStaminaCost, keyItemId)
  -- function num : 0_19
  self.__ableNextLevelBattle = true
  self.__nextBattleEvent = nextBattleEvent
  self.__nextStaminaCost = nextStaminaCost
  self.__staminaReplaceItemId = keyItemId
end

DungeonInterfaceData.SetDungeonReplayInfo = function(self, restartBattleEvent, replayStaminaCost, keyItemId)
  -- function num : 0_20
  self.__ableReplaytLevelBattle = true
  self.__restartBattleEvent = restartBattleEvent
  self.__replayStaminaCost = replayStaminaCost
  self.__replayStaminaReplaceItemId = keyItemId
end

DungeonInterfaceData.SaveBattleWinRewardInfo = function(self, dungeonData)
  -- function num : 0_21
  self.__multRewardInfo = {}
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.__multRewardInfo).isMultReward = dungeonData:GetIsHaveMultReward()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  if (self.__multRewardInfo).isMultReward then
    (self.__multRewardInfo).multRewardRate = dungeonData:GetActivityMultRewardRate()
    local leftTime, totalTime = dungeonData:GetLeftActivityMultRewardNum()
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.__multRewardInfo).multRewardTotalNum = totalTime
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.__multRewardInfo).multRewardLeftNum = leftTime - 1
  end
end

DungeonInterfaceData.GetBattleWinRewardInfo = function(self)
  -- function num : 0_22
  return self.__multRewardInfo
end

DungeonInterfaceData.RestartAthMaybeFull = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if self.__dungeonStageData == nil then
    return false
  end
  local maybeFull = not (self.__dungeonStageData):IsHaveATHReward() or (ConfigData.game_config).athMaxNum - (ConfigData.game_config).athSpaceNotEnoughNum <= #(PlayerDataCenter.allAthData):GetAllAthList()
  do return maybeFull end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

DungeonInterfaceData.RestartAthAlreadyFull = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.__dungeonStageData == nil then
    return false
  end
  local alreadyFull = not (self.__dungeonStageData):IsHaveATHReward() or (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList()
  do return alreadyFull end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

DungeonInterfaceData.GetIStaminaCost = function(self)
  -- function num : 0_25
  if self.__dungeonStageData == nil then
    return 0
  end
  return (self.__dungeonStageData):GetStaminaCost()
end

DungeonInterfaceData.GetINextStaminaCost = function(self)
  -- function num : 0_26
  return self.__nextStaminaCost
end

DungeonInterfaceData.GetINextStaminaReplaceItemId = function(self)
  -- function num : 0_27
  return self.__staminaReplaceItemId
end

DungeonInterfaceData.AbleContinueNextLevel = function(self)
  -- function num : 0_28
  return self.__ableNextLevelBattle
end

DungeonInterfaceData.GetReplayStaminaCost = function(self)
  -- function num : 0_29
  return self.__replayStaminaCost
end

DungeonInterfaceData.GetReplayStaminaReplaceItemId = function(self)
  -- function num : 0_30
  return self.__replayStaminaReplaceItemId
end

DungeonInterfaceData.AbleContinueReplayLevel = function(self)
  -- function num : 0_31
  return self.__ableReplaytLevelBattle
end

DungeonInterfaceData.AbleFailRestart = function(self)
  -- function num : 0_32
  return self.__ableFailRestart
end

DungeonInterfaceData.SetDIDExtraDrop = function(self, active)
  -- function num : 0_33
  self._extraDropActive = active
end

DungeonInterfaceData.GetDIDExtraDrop = function(self)
  -- function num : 0_34
  return self._extraDropActive
end

DungeonInterfaceData.GetDunFormationRuleCfg = function(self)
  -- function num : 0_35
  return self.__formationRuleCfg
end

DungeonInterfaceData.SetAutoDecompose = function(self, active)
  -- function num : 0_36
  self._autoDecomposeActive = active
end

DungeonInterfaceData.GetAutoDecompose = function(self)
  -- function num : 0_37
  return self._autoDecomposeActive
end

DungeonInterfaceData.GetAbleSelectChipSuit = function(self)
  -- function num : 0_38
  return self.__ableSelectChipSuit
end

DungeonInterfaceData.GetChipSuitSelectMax = function(self)
  -- function num : 0_39
  return self.__chipSuitSelectMax
end

DungeonInterfaceData.GetChipSuitSelectQuality = function(self, chipTagId)
  -- function num : 0_40
  if self.__chipSuitQualityDic ~= nil and (self.__chipSuitQualityDic)[chipTagId] ~= nil then
    return (self.__chipSuitQualityDic)[chipTagId]
  end
  return self.__chipSuitQuality
end

DungeonInterfaceData.GetChipSuitPool = function(self)
  -- function num : 0_41
  return self.__chipSuitPool
end

DungeonInterfaceData.GetLockedChipSuitPool = function(self)
  -- function num : 0_42
  return self.__wait2UnlockChipPoolList
end

DungeonInterfaceData.GetLockedChipSuitPoolUnlockInfoList = function(self)
  -- function num : 0_43
  return self.__wait4UnlockChipSuitUnlockInfoList
end

DungeonInterfaceData.LimitUseSuitCount = function(self)
  -- function num : 0_44
  return self.__limitUseSuitCount
end

DungeonInterfaceData.GetIsNotShowCouldUseTime = function(self)
  -- function num : 0_45
  return self.__notShowCouldUseTime
end

DungeonInterfaceData.GetChipSuitNum = function(self)
  -- function num : 0_46
  return self.__chipSuitNum
end

DungeonInterfaceData.GetAfterBattleLuckDropDic = function(self)
  -- function num : 0_47
  return self.__luckDropDic
end

DungeonInterfaceData.IsNotShowExtrAward = function(self)
  -- function num : 0_48
  return self.__notShowExtrAward
end

DungeonInterfaceData.IsNeedRecordFormation = function(self)
  -- function num : 0_49
  return self.__isNeedRecordFormation
end

DungeonInterfaceData.GetLastSelectSuit = function(self, lastChipGroup)
  -- function num : 0_50 , upvalues : DungeonLevelEnum, _ENV
  if self.__interfaceType == (DungeonLevelEnum.InterfaceType).DailyDungeon then
    local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
    return dungeonDyncElem.lastChipGroup
  else
    do
      if self.__interfaceType == (DungeonLevelEnum.InterfaceType).WinterChallenge then
        local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
        return dungeonDyncElem.lastChipGroup
      else
        do
          do return self.__lastSelectSuit end
        end
      end
    end
  end
end

DungeonInterfaceData.SaveLastSelectSuit = function(self, lastChipGroup)
  -- function num : 0_51 , upvalues : DungeonLevelEnum, _ENV
  if self.__interfaceType == (DungeonLevelEnum.InterfaceType).DailyDungeon then
    local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
    dungeonDyncElem:SetDgDyncElemLastChipGroup(lastChipGroup)
  else
    do
      if self.__interfaceType == (DungeonLevelEnum.InterfaceType).WinterChallenge then
        local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
        dungeonDyncElem:SetDgDyncElemLastChipGroup(lastChipGroup)
      else
        do
          self.__lastSelectSuit = lastChipGroup
        end
      end
    end
  end
end

DungeonInterfaceData.GetChipSuitNumById = function(self, chipSuitId)
  -- function num : 0_52
  if self.__limitUseSuitCount then
    return (self.__chipSuitNum)[chipSuitId]
  else
    return 1
  end
end

DungeonInterfaceData.GetChipSuitSelectedCount = function(self, chipTagId)
  -- function num : 0_53 , upvalues : DungeonLevelEnum, _ENV
  if self.__interfaceType == (DungeonLevelEnum.InterfaceType).DailyDungeon then
    local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
    return (dungeonDyncElem.selectedChipGroup)[chipTagId] or 0
  else
    do
      if self.__interfaceType == (DungeonLevelEnum.InterfaceType).WinterChallenge then
        local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
        return (dungeonDyncElem.selectedChipGroup)[chipTagId] or 0
      else
        do
          do return 0 end
        end
      end
    end
  end
end

DungeonInterfaceData.GetIsHaveBuff = function(self)
  -- function num : 0_54
  return self.__isNeedShowBuff
end

DungeonInterfaceData.GetAddBuffList = function(self)
  -- function num : 0_55 , upvalues : _ENV
  local addedBuffList = {}
  for buffId,_ in pairs(self.__addedBuffDic) do
    (table.insert)(addedBuffList, buffId)
  end
  return addedBuffList
end

DungeonInterfaceData.GetRemoveBuffList = function(self)
  -- function num : 0_56 , upvalues : _ENV
  local deletedBuffList = {}
  for buffId,_ in pairs(self.__deletedBuffDic) do
    (table.insert)(deletedBuffList, buffId)
  end
  return deletedBuffList
end

DungeonInterfaceData.GetDgItfFmtFromModule = function(self)
  -- function num : 0_57
  return self._fmtFromModule
end

DungeonInterfaceData.GetDgWinChallengeCurScore = function(self)
  -- function num : 0_58 , upvalues : DungeonLevelEnum
  if self.__dungeonLevelData == nil or (self.__dungeonLevelData):GetDungeonLevelType() ~= (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    return 0
  end
  return (self.__dungeonLevelData):GetSctIIChallengeDgScore()
end

DungeonInterfaceData.GetDgWinChallengeMaxScore = function(self)
  -- function num : 0_59 , upvalues : DungeonLevelEnum
  if self.__dungeonLevelData == nil or (self.__dungeonLevelData):GetDungeonLevelType() ~= (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    return 0
  end
  return (self.__dungeonLevelData):GetSctIIChallengeDgMaxScore()
end

DungeonInterfaceData.GetDefeatJumpList = function(self)
  -- function num : 0_60 , upvalues : _ENV
  if not self.__defeatAdviseList then
    return table.emptytable
  end
end

DungeonInterfaceData.TryGetDungeonTowerLvInfo = function(self)
  -- function num : 0_61 , upvalues : DungeonLevelEnum
  if self.__dungeonLevelData == nil or (self.__dungeonLevelData):GetDungeonLevelType() ~= (DungeonLevelEnum.DunLevelType).Tower then
    return nil, 0
  end
  return (self.__dungeonLevelData):GetTowerLvName(), (self.__dungeonLevelData):GetDunTowerLevelNum()
end

DungeonInterfaceData.GetDgInterfaceDungeonDyncData = function(self)
  -- function num : 0_62
  return self._dungeonDyncData
end

DungeonInterfaceData.SetAfterClickBattleFunc = function(self, func)
  -- function num : 0_63
  self.__afterClickBattleFunc = func
end

DungeonInterfaceData.GetAfterClickBattleFunc = function(self)
  -- function num : 0_64
  return self.__afterClickBattleFunc
end

DungeonInterfaceData.GetIsListen2OverKill = function(self)
  -- function num : 0_65
  return self.__listen2OverKill
end

DungeonInterfaceData.GetDunRacingData = function(self)
  -- function num : 0_66
  return self.__enableRacingTime, self.__lastRacingTime, self.__isHideRacingTimeCompare
end

DungeonInterfaceData.GetDunScoreAddRate = function(self)
  -- function num : 0_67
  return self.__enableScoreAddRate or false, self.__scoreAdd or 0
end

DungeonInterfaceData.DealDungeonResult = function(self, msg)
  -- function num : 0_68
  if msg ~= nil and self.__dungeonLevelData ~= nil then
    (self.__dungeonLevelData):DealDungeonResult(msg)
  end
end

DungeonInterfaceData.GetDunRacingServerTime = function(self)
  -- function num : 0_69
  if self.__dungeonLevelData == nil then
    return -1
  end
  return (self.__dungeonLevelData):GetDunServerRacingFrame()
end

return DungeonInterfaceData

