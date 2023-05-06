-- params : ...
-- function num : 0 , upvalues : _ENV
local EnterFmtData = class("EnterFmtData")
local FmtEnum = require("Game.Formation.FmtEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local FormationUtil = require("Game.Formation.FormationUtil")
local VirtualFormationData = require("Game.Formation.Data.VirtualFormationData")
local SpecialRuleGenerator = require("Game.PlayerData.SpecialRuleGenerator")
local StageChallengeData = require("Game.StageChallenge.Data.StageChallengeData")
local DungeonTowerUtil = require("Game.DungeonCenter.Util.DungeonTowerUtil")
local WCEnum = require("Game.WeeklyChallenge.WCEnum")
local OfficialSupportHeroData = require("Game.Formation.Data.OfficialSupportHeroData")
EnterFmtData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.fromModule = nil
  self.gameType = nil
  self.stageId = nil
  self.defaultFmtId = nil
  self.isFmtCtrlFixed = nil
  self.__assistTeamCfg = nil
  self.__isFixedCouldChangeTeam = nil
  self.specificHeroDataRuler = nil
  self.__specialRuleGenerator = nil
  self.__virtualFmtData = nil
  self._fmtBuffSelectData = nil
  self.enterFunc = nil
  self.exitFunc = nil
  self.startBattleFunc = nil
  self.isFriendSupport = false
  self.isFriendSupportTimeLimitted = false
  self.isFriendSupportHaveTimeLimit = false
  self.forbidSupport = false
  self.__forceShowSupportNotAvaliable = nil
  self.isHaveChallengeMode = false
  self.stgChallengeData = nil
  self.setChallengeModeFunc = false
  self.isInBattleFmt = false
  self.fmtDungeonDyncData = nil
  self.__couldShowRecommendBtn = false
  self.isOpenedCampInfluence = false
  self.isOpenBuffSelect = false
  self.isOpenBuffWhenEnter = false
  self.isOpenTotalPower = true
  self.isOpenChangeFmt = true
  self.couldShowQuickLevelUp = true
  self.isExpShow = true
  self.isStaminaShow = true
  self.staminaCost = 0
  self.__notStaminaTicketItemId = nil
  self.isAutoBattleState = false
  self.autoCount = 0
  self.isCloseCommandSkill = false
  self.__isHaveMult = nil
  self.isOpenFmtEvaluation = true
  self.__fmtchipDataList = nil
  self.__isEditShowPow = true
  self.__isEditShowEvaluate = true
  self.__formationRuleCfg = (ConfigData.formation_rule)[0]
  self.__heroPassStats = nil
  self.__heroRecommendDic = nil
  self.__fixedChangeTeamFmtIdDic = nil
  self.__fixedTeamNameDic = nil
  self.__isWarChessDeploy = nil
  self.__deployOverCallback = nil
  self.__wcLevelCfg = nil
  self.__wcCurTeamIndex = nil
  self.__wcDTeamDataDic = nil
  self.__isHaveOfficialSupport = nil
  self.__officialSupportCfgId = nil
  self.__allOfficialSupportHeroDataDic = nil
end

EnterFmtData.SetFmtCtrlBaseInfo = function(self, fromModule, stageId, lastFmtId)
  -- function num : 0_1 , upvalues : FmtEnum
  self.fromModule = fromModule
  self.gameType = (FmtEnum.GetFmtGameTypeByModuleId)(fromModule)
  self.stageId = stageId
  self.defaultFmtId = lastFmtId
  return self
end

EnterFmtData.SetFmtId = function(self, fmtId)
  -- function num : 0_2
  self.defaultFmtId = fmtId
  return self
end

EnterFmtData.SetFmtCtrlCallback = function(self, enterFunc, exitFunc, startBattleFunc)
  -- function num : 0_3
  self.enterFunc = enterFunc
  self.exitFunc = exitFunc
  self.startBattleFunc = startBattleFunc
  return self
end

EnterFmtData.SetEnterBattleCostTicketNum = function(self, costNum)
  -- function num : 0_4
  self.staminaCost = costNum
  return self
end

EnterFmtData.SetEnterBattleTicketItemId = function(self, itemId)
  -- function num : 0_5
  self.__notStaminaTicketItemId = itemId
  return self
end

EnterFmtData.SetSpecificHeroDataRuler = function(self, specificHeroDataRuler)
  -- function num : 0_6 , upvalues : SpecialRuleGenerator
  self.specificHeroDataRuler = specificHeroDataRuler
  if self.specificHeroDataRuler ~= nil then
    self.couldShowQuickLevelUp = false
    self.__specialRuleGenerator = (SpecialRuleGenerator.New)()
    ;
    (self.__specialRuleGenerator):SetSpeicalRuler(self.specificHeroDataRuler)
  end
  return self
end

EnterFmtData.SetPeridicFmtBuffSelect = function(self, peridicFmtBuffSelectData)
  -- function num : 0_7
  self._fmtBuffSelectData = peridicFmtBuffSelectData
  return self
end

EnterFmtData.TryGenFmtCtrlDungeonDyncData = function(self)
  -- function num : 0_8 , upvalues : FormationUtil
  self.fmtDungeonDyncData = (FormationUtil.GetDyncDgDataByFmtFromModule)(self.fromModule)
  return self
end

EnterFmtData.SetIsOpenBuffSelect = function(self, bool)
  -- function num : 0_9
  self.isOpenBuffSelect = bool
  return self
end

EnterFmtData.SetIsOpenBuffWhenEnter = function(self, bool)
  -- function num : 0_10
  self.isOpenBuffWhenEnter = bool
  return self
end

EnterFmtData.SetFmtCtrlIsHaveMultEffi = function(self, bool)
  -- function num : 0_11
  self.__isHaveMult = bool
  return self
end

EnterFmtData.SetFmtCtrlChipDataList = function(self, fmtchipDataList)
  -- function num : 0_12
  self.__fmtchipDataList = fmtchipDataList
  return self
end

EnterFmtData.SetFmtCtrlChallengeData = function(self, isHaveChallengeMode, setChallengeModeFunc, stgChallengeData)
  -- function num : 0_13 , upvalues : _ENV, StageChallengeData
  if self.stageId == nil then
    error("pls check EnterFmtData data set order,can\'t get stageId for stgChallengeData")
    return 
  end
  self.isHaveChallengeMode = isHaveChallengeMode
  self._SetChallengeModeFunc = setChallengeModeFunc
  if stgChallengeData == nil then
    self.stgChallengeData = (StageChallengeData.Create)(self.stageId)
  else
    self.stgChallengeData = stgChallengeData
  end
  if isHaveChallengeMode then
    self.__isEditShowPow = false
    self.__isEditShowEvaluate = false
  end
  return self
end

EnterFmtData.SetFmtCtrlIsInBattleFmt = function(self, isInBattleFmt)
  -- function num : 0_14
  self.isInBattleFmt = isInBattleFmt
  if isInBattleFmt then
    self.isOpenTotalPower = false
    self.__isEditShowPow = false
  end
  return self
end

EnterFmtData.SetFmtForbidSupport = function(self, bool)
  -- function num : 0_15
  self.forbidSupport = bool
  return self
end

EnterFmtData.SetIsShowSupportHolder = function(self, bool)
  -- function num : 0_16
  self.__forceShowSupportNotAvaliable = bool
  return self
end

EnterFmtData.SetIsOpenChangeFmt = function(self, bool)
  -- function num : 0_17
  self.isOpenChangeFmt = bool
  return self
end

EnterFmtData.SetFormationRuleCfg = function(self, formationRuleCfg)
  -- function num : 0_18
  if formationRuleCfg ~= nil then
    self.__formationRuleCfg = formationRuleCfg
  end
  return self
end

EnterFmtData.SetIsShowTotalPow = function(self, bool)
  -- function num : 0_19
  self.isOpenTotalPower = bool
  return self
end

EnterFmtData.SetFmtHeroPassInfo = function(self, heroPassStats)
  -- function num : 0_20 , upvalues : _ENV
  if heroPassStats == nil or #heroPassStats <= 0 then
    return self
  end
  self.__heroPassStats = heroPassStats
  self.__heroRecommendDic = {}
  local showRecommendNum = (ConfigData.game_config).towerRecommendNum
  for i = 1, (math.min)(showRecommendNum, #heroPassStats) do
    local passStat = heroPassStats[i]
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__heroRecommendDic)[passStat.heroId] = true
  end
  return self
end

EnterFmtData.SetFmtIsWarChessDeploy = function(self, bool, deployOverCallback, wcLevelCfg, index)
  -- function num : 0_21
  self.__isWarChessDeploy = bool
  self.__deployOverCallback = deployOverCallback
  self.__wcLevelCfg = wcLevelCfg
  self.__wcCurTeamIndex = index
  return self
end

EnterFmtData.SetFmtWarChessSeasonRecommendCfg = function(self, warchessRecommendHeroDic, warchessRecommendTeamList, warchessRecommendSkillDataList)
  -- function num : 0_22
  self.__heroRecommendDic = warchessRecommendHeroDic
  self.__warchessRecommendTeamList = warchessRecommendTeamList
  self.__warchessRecommendSkillDataList = warchessRecommendSkillDataList
  return self
end

EnterFmtData.SetFmtWarChessDTeamDataDic = function(self, dTeamDataDic)
  -- function num : 0_23
  self.__wcDTeamDataDic = dTeamDataDic
  return self
end

EnterFmtData.SetOfficialSupportCfgId = function(self, officialSupportCfgId)
  -- function num : 0_24
  self.__officialSupportCfgId = officialSupportCfgId
end

EnterFmtData.GetFmtCtrlFromModule = function(self)
  -- function num : 0_25
  return self.fromModule
end

EnterFmtData.GetFmtCtrlGameType = function(self)
  -- function num : 0_26
  return self.gameType
end

EnterFmtData.GetFmtCtrlEnterFunc = function(self)
  -- function num : 0_27
  return self.enterFunc
end

EnterFmtData.GetFmtCtrlExitFunc = function(self)
  -- function num : 0_28
  return self.exitFunc
end

EnterFmtData.GetFmtCtrlStartBattleFunc = function(self)
  -- function num : 0_29
  return self.startBattleFunc
end

EnterFmtData.GetFmtCtrlFmtId = function(self)
  -- function num : 0_30
  return self.defaultFmtId
end

EnterFmtData.GetFmtCtrlFmtIdStageId = function(self)
  -- function num : 0_31
  return self.stageId
end

EnterFmtData.GetFormationRuleCfg = function(self)
  -- function num : 0_32
  return self.__formationRuleCfg
end

EnterFmtData.GetFormationMaxStageNum = function(self)
  -- function num : 0_33
  return (self.__formationRuleCfg).stage_num
end

EnterFmtData.GetFormationMaxBenchNum = function(self)
  -- function num : 0_34
  return (self.__formationRuleCfg).bench_num
end

EnterFmtData.GetFormationRoleMax = function(self)
  -- function num : 0_35
  return (self.__formationRuleCfg).stage_num + (self.__formationRuleCfg).bench_num
end

EnterFmtData.IsFormationIndexEnable = function(self, fmtIndex)
  -- function num : 0_36
  do return fmtIndex <= (self.__formationRuleCfg).stage_num or (self.__formationRuleCfg).bench_start_idx <= fmtIndex end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.GetFmtHeroPassInfo = function(self)
  -- function num : 0_37
  return self.__heroPassStats
end

EnterFmtData.IsFmtHeroRecommend = function(self, heroId)
  -- function num : 0_38
  if self.__heroRecommendDic == nil then
    return false
  end
  return (self.__heroRecommendDic)[heroId]
end

EnterFmtData.GetWarChessRecommendTeam = function(self)
  -- function num : 0_39
  return self.__warchessRecommendTeamList
end

EnterFmtData.GetWarChessRecommendSkillData = function(self)
  -- function num : 0_40
  return self.__warchessRecommendSkillDataList
end

EnterFmtData.GetPeridicFmtBuffSelect = function(self)
  -- function num : 0_41
  return self._fmtBuffSelectData
end

EnterFmtData.IsFmtCtrlVirtualFmtData = function(self)
  -- function num : 0_42
  do return self.specificHeroDataRuler ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.GetFmtCtrlSpecificHeroDataRuler = function(self)
  -- function num : 0_43
  return self.specificHeroDataRuler
end

EnterFmtData.GetFmtCtrlSpecialRuleGenerator = function(self)
  -- function num : 0_44
  return self.__specialRuleGenerator
end

EnterFmtData.GetFmtCtrlVirtualFmtData = function(self)
  -- function num : 0_45
  return self.__virtualFmtData
end

EnterFmtData.IsFmtCtrlFiexd = function(self)
  -- function num : 0_46
  return self.isFmtCtrlFixed
end

EnterFmtData.HasFmtFixedHeroIndex = function(self, fmtIndex)
  -- function num : 0_47
  if not self:IsFmtCtrlFiexd() then
    return false
  end
  local openNum = #(self.__assistTeamCfg).param1 + (self.__assistTeamCfg).extra_add
  do return fmtIndex <= openNum end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.HasFmtFixedExtra = function(self)
  -- function num : 0_48
  if self.__assistTeamCfg == nil then
    return false
  end
  do return (self.__assistTeamCfg).extra_add > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.HasFmtFixedShowPow = function(self)
  -- function num : 0_49
  if self.__assistTeamCfg then
    return (self.__assistTeamCfg).show_battlepow
  end
end

EnterFmtData.IsFmtFixedHeroId = function(self, heroId)
  -- function num : 0_50 , upvalues : _ENV
  if self.__assistTeamCfg == nil then
    return false
  end
  for k,fixedHeroId in ipairs((self.__assistTeamCfg).param1) do
    if fixedHeroId == heroId then
      return true
    end
  end
  return false
end

EnterFmtData.GetFmtFixedHeroNum = function(self)
  -- function num : 0_51
  if not self:IsFmtCtrlFiexd() then
    return 0
  end
  local openNum = #(self.__assistTeamCfg).param1 + (self.__assistTeamCfg).extra_add
  return openNum
end

EnterFmtData.IsFmtFixedHeroFull = function(self, fmtData)
  -- function num : 0_52 , upvalues : _ENV
  if not self:IsFmtCtrlFiexd() then
    return 
  end
  local allNum = self:GetFmtFixedHeroNum()
  local curNum = (table.count)(fmtData:GetFormationHeroDic())
  do return allNum <= curNum end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.IsFmtFixedCouldChangeTeam = function(self)
  -- function num : 0_53
  return self.__isFixedCouldChangeTeam
end

EnterFmtData.GetFmtFixedChangeTeamFmtId = function(self, fmtIndex)
  -- function num : 0_54
  return (self.__fixedChangeTeamFmtIdDic)[fmtIndex]
end

EnterFmtData.GetIsFmtExpShow = function(self)
  -- function num : 0_55
  return self.isExpShow
end

EnterFmtData.GetIsFmtStaminaShow = function(self)
  -- function num : 0_56
  return self.isStaminaShow
end

EnterFmtData.GetIsFmtTicketId = function(self)
  -- function num : 0_57 , upvalues : _ENV
  if not self.__notStaminaTicketItemId then
    return ConstGlobalItem.SKey
  end
end

EnterFmtData.IsInTdFormation = function(self)
  -- function num : 0_58 , upvalues : ExplorationEnum
  do return self.__mapLogic == (ExplorationEnum.eMapLogic).TowerDefence end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.IsWCFormation = function(self)
  -- function num : 0_59 , upvalues : FmtEnum, _ENV, WCEnum
  local isWc = self.fromModule == (FmtEnum.eFmtFromModule).WeeklyChallenge
  if isWc then
    local wcCfg = (ConfigData.weekly_challenge)[self.stageId]
    local wcType = (WCEnum.eWeeklyChallengeId).normal
    if wcCfg ~= nil then
      wcType = wcCfg.weekly_challenge_type
    end
    return isWc, wcType
  end
  do return false end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

EnterFmtData.IsFmtTdSpecHero = function(self, heroId)
  -- function num : 0_60 , upvalues : _ENV
  if not self:IsInTdFormation() then
    return false
  end
  do return ((ConfigData.skill_adapter).td_adapter)[heroId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.GetFmtChipDataList = function(self)
  -- function num : 0_61
  return self.__fmtchipDataList
end

EnterFmtData.GetIsAutoBattleState = function(self)
  -- function num : 0_62
  return self.isAutoBattleState
end

EnterFmtData.IsFmtActivityForbidSupport = function(self)
  -- function num : 0_63 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[self.stageId]
  if not stageCfg then
    return false
  end
  local sectorId = stageCfg.sector
  local win21Ctrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if win21Ctrl and win21Ctrl:GetSectorIIDataBySectorId(sectorId) then
    return true
  end
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local winter23Data = win23Ctrl:GetWinter23Data()
    local winter23MainCfg = winter23Data:GetWinter23Cfg()
    if sectorId == winter23MainCfg.hard_stage then
      return true
    end
  end
  do
    return false
  end
end

EnterFmtData.IsFmtHaveChallengeMode = function(self)
  -- function num : 0_64
  return self.isHaveChallengeMode
end

EnterFmtData.IsFmtChallengeMode = function(self)
  -- function num : 0_65
  if self.stgChallengeData then
    return (self.stgChallengeData):IsStageChallengeOpen()
  end
end

EnterFmtData.GetFmtChallengeModeData = function(self)
  -- function num : 0_66
  return self.stgChallengeData
end

EnterFmtData.GetFmtChallengeModeChangeFunc = function(self)
  -- function num : 0_67
  return self._SetChallengeModeFunc
end

EnterFmtData.GetFmtDungeonDyncData = function(self)
  -- function num : 0_68
  return self.fmtDungeonDyncData
end

EnterFmtData.IsFmtInWarChessDeploy = function(self)
  -- function num : 0_69
  return self.__isWarChessDeploy
end

EnterFmtData.GetFmtTeamSize = function(self)
  -- function num : 0_70 , upvalues : _ENV
  if self:IsFmtInWarChessDeploy() then
    return ((WarChessManager:GetWarChessCtrl()).teamCtrl):GetWCFmtShowNum()
  end
  return (ConfigData.game_config).formationCount
end

EnterFmtData.GetDeployOverCallback = function(self)
  -- function num : 0_71
  return self.__deployOverCallback
end

EnterFmtData.IsFmtInBattleDeploy = function(self, mustInBattle)
  -- function num : 0_72 , upvalues : FmtEnum
  if self.fmtDungeonDyncData == nil then
    return false
  end
  if self.fromModule == (FmtEnum.eFmtFromModule).DailyDungeonLevel then
    do return not mustInBattle end
    do return true end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

EnterFmtData.GetStaminaCost = function(self)
  -- function num : 0_73
  if self:GetIsAutoBattleState() then
    return self.staminaCost * self.autoCount
  end
  return self.staminaCost
end

EnterFmtData.GetIsShowTotalPow = function(self)
  -- function num : 0_74
  return self.isOpenTotalPower
end

EnterFmtData.GetFmtCtrlRecommendPower = function(self)
  -- function num : 0_75 , upvalues : FmtEnum, _ENV
  local stageCfg = nil
  if self.fromModule ~= (FmtEnum.eFmtFromModule).PeriodicChallenge then
    if self.fromModule ~= (FmtEnum.eFmtFromModule).WeeklyChallenge or self.fromModule == (FmtEnum.eFmtFromModule).Infinity then
      local endlessLevel = ((ConfigData.endless).levelDic)[self.stageId]
      if endlessLevel == nil then
        return 
      end
      stageCfg = ((ConfigData.endless)[endlessLevel.sectorId])[endlessLevel.index]
    else
      do
        if self.fromModule == (FmtEnum.eFmtFromModule).WarChess then
          return WarChessManager:GetWCRecommenPower(), 0
        else
          local playType = (FmtEnum.GetFmtGameTypeByModuleId)(self.fromModule)
          if playType == (FmtEnum.eFmtGamePlayType).Exploration then
            stageCfg = (ConfigData.sector_stage)[self.stageId]
          else
            if playType == (FmtEnum.eFmtGamePlayType).Dungeon then
              stageCfg = (ConfigData.battle_dungeon)[self.stageId]
            end
          end
        end
        do
          if stageCfg == nil then
            return 0, 0
          end
          return stageCfg.combat, stageCfg.bench_combat
        end
      end
    end
  end
end

EnterFmtData.GetIsCloseCommandSkill = function(self)
  -- function num : 0_76
  return self.isCloseCommandSkill
end

EnterFmtData.GetFixedCstSkills = function(self)
  -- function num : 0_77 , upvalues : FmtEnum, _ENV
  if self.fromModule ~= (FmtEnum.eFmtFromModule).SectorLevel then
    return false
  end
  return ConfigData:GetFixedCstSkillsExp(self.stageId)
end

EnterFmtData.GetIsOpenFmtEvaluate = function(self)
  -- function num : 0_78
  return self.isOpenFmtEvaluation
end

EnterFmtData.GetIsOpenSelectDebuff = function(self)
  -- function num : 0_79
  return self.isOpenBuffSelect
end

EnterFmtData.GetIsOpenBuffWhenEnter = function(self)
  -- function num : 0_80
  return self.isOpenBuffWhenEnter
end

EnterFmtData.GetFmtIsFriendSupport = function(self)
  -- function num : 0_81
  if self:IsFmtChallengeMode() then
    return false
  end
  return self.isFriendSupport
end

EnterFmtData.GetFmtForceShowSupportNotAvaliable = function(self)
  -- function num : 0_82
  if self:IsFmtChallengeMode() then
    return true
  end
  return self.__forceShowSupportNotAvaliable
end

EnterFmtData.GetFmtIsFriendSupportTimeLimitted = function(self)
  -- function num : 0_83
  return self.isFriendSupportTimeLimitted
end

EnterFmtData.GetFmtIsFriendSupportHaveTimeLimit = function(self)
  -- function num : 0_84
  return self.isFriendSupportHaveTimeLimit
end

EnterFmtData.GetSupportTimeLimit = function(self)
  -- function num : 0_85 , upvalues : _ENV
  return (ConfigData.game_config).supportTimeLimit + (PlayerDataCenter.playerBonus):GetSupportCountAddtion()
end

EnterFmtData.GetFmtEditIsShowPow = function(self)
  -- function num : 0_86
  return self.__isEditShowPow
end

EnterFmtData.GetFmtEditIsShowEvaluate = function(self)
  -- function num : 0_87
  return self.__isEditShowEvaluate
end

EnterFmtData.GetIsOpenChangeFmt = function(self)
  -- function num : 0_88
  return self.isOpenChangeFmt
end

EnterFmtData.GetCouldShowQuickLevelUp = function(self)
  -- function num : 0_89
  return self.couldShowQuickLevelUp
end

EnterFmtData.GetIsOpenedCampInfluence = function(self)
  -- function num : 0_90
  return self.isOpenedCampInfluence
end

EnterFmtData.GetCouldShowFmtRecommendBtn = function(self)
  -- function num : 0_91
  return self.__couldShowRecommendBtn
end

EnterFmtData.GetCouldShowWarChessRecommendBtn = function(self)
  -- function num : 0_92 , upvalues : _ENV
  local recommendTeamCheck = (self:GetWarChessRecommendTeam() ~= nil and not (table.IsEmptyTable)(self:GetWarChessRecommendTeam()))
  local recommendSkillCheck = (self:GetWarChessRecommendSkillData() ~= nil and not (table.IsEmptyTable)(self:GetWarChessRecommendSkillData()))
  do return not recommendTeamCheck or recommendSkillCheck end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

EnterFmtData.GetIsHaveOfficialSupport = function(self)
  -- function num : 0_93
  return self.__isHaveOfficialSupport
end

EnterFmtData.GetOfficialSupportCfgId = function(self)
  -- function num : 0_94
  return self.__officialSupportCfgId
end

EnterFmtData.GetIsHaveOfficialSupportHeroDic = function(self)
  -- function num : 0_95
  return self.__allOfficialSupportHeroDataDic
end

EnterFmtData.GenFmtCtrlData = function(self)
  -- function num : 0_96
  self:__GenIsDunAutoBattle()
  self:__GenIsFmtFixed()
  self:__GenIsFmtVirtual()
  self:__GenMapLogic()
  self:__TryGenDungeonDyncData4InBattleFmt()
  self:__TryGenSupportData()
  self:__TryGenOfficialSupportData()
  self:__TryGenFmtRecommendData()
  self:__TryGenCommandSkillData()
end

EnterFmtData.__GenIsDunAutoBattle = function(self)
  -- function num : 0_97 , upvalues : FmtEnum, _ENV
  if self.gameType == (FmtEnum.eFmtGamePlayType).Dungeon then
    self.isAutoBattleState = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
    self.autoCount = (BattleDungeonManager.autoCtrl):GetTotalDungeonAutoCount()
  end
end

EnterFmtData.__GenIsFmtFixed = function(self)
  -- function num : 0_98 , upvalues : FmtEnum, _ENV, FormationUtil
  self.isFmtCtrlFixed = false
  self.__isFixedCouldChangeTeam = false
  if self.fromModule == (FmtEnum.eFmtFromModule).SectorLevel then
    local sectorCfg = (ConfigData.sector_stage)[self.stageId]
    if sectorCfg == nil then
      error("cant get sectorCfg, id = " .. tostring(self.stageId))
      return 
    end
    local fixedHeroTeamId = sectorCfg.fixed_hero_team
    if fixedHeroTeamId == 0 then
      return 
    end
    self.defaultFmtId = (FormationUtil.GetFmtIdByFixedTeamId)(fixedHeroTeamId)
    self.__assistTeamCfg = (FormationUtil.SetFiexdFmt)(self.defaultFmtId, fixedHeroTeamId)
    if not (self.__assistTeamCfg).friend_support then
      self.forbidSupport = true
    end
    self.isOpenTotalPower = self:HasFmtFixedShowPow()
    self.isFmtCtrlFixed = true
    return 
  end
  do
    if self.fromModule == (FmtEnum.eFmtFromModule).WarChess then
      if self.__wcLevelCfg == nil then
        error("cant read wcLevelCfg, id = " .. tostring(self.stageId))
        return 
      end
      self.__isFixedCouldChangeTeam = true
      self.__fixedChangeTeamFmtIdDic = {}
      for index,fixedHeroTeamId in pairs((self.__wcLevelCfg).assist) do
        local isFixed = false
        local dTeamData = (self.__wcDTeamDataDic)[index]
        if dTeamData ~= nil then
          isFixed = dTeamData:GetDTeamIsFixedTeam()
        end
        if isFixed then
          local fixedFmtId = (FormationUtil.GetFmtIdByFixedTeamId)(fixedHeroTeamId)
          -- DECOMPILER ERROR at PC82: Confused about usage of register: R9 in 'UnsetPending'

          ;
          (self.__fixedChangeTeamFmtIdDic)[index] = fixedFmtId
          if self.__wcCurTeamIndex == index then
            self.defaultFmtId = fixedFmtId
            self.__assistTeamCfg = (FormationUtil.SetFiexdFmt)(self.defaultFmtId, fixedHeroTeamId)
            if not (self.__assistTeamCfg).friend_support then
              self.forbidSupport = true
            end
            self.isOpenTotalPower = self:HasFmtFixedShowPow()
            self.isFmtCtrlFixed = true
          end
        end
      end
      return 
    end
  end
end

EnterFmtData.__GenIsFmtVirtual = function(self)
  -- function num : 0_99 , upvalues : _ENV, VirtualFormationData
  if self:IsFmtCtrlVirtualFmtData() then
    local _, wcType = self:IsWCFormation()
    local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local treeId = userData:GetLastWeeklySkillList(wcType)
    self.__virtualFmtData = (VirtualFormationData.New)(treeId, self.__specialRuleGenerator)
    local fmt = userData:GetLastWeeklyChallengeFmt(wcType)
    ;
    (self.__virtualFmtData):TryRestoreFormation(fmt)
  end
end

EnterFmtData.__GenMapLogic = function(self)
  -- function num : 0_100 , upvalues : FmtEnum, _ENV, ExplorationEnum
  if self.fromModule == (FmtEnum.eFmtFromModule).SectorLevel then
    local sectorStageCfg = (ConfigData.sector_stage)[self.stageId]
    if sectorStageCfg == nil then
      error("sectorStageCfg is nil ,id:" .. tostring())
      self.__mapLogic = nil
    end
    local expFloorList = sectorStageCfg.exploration_list
    local expCfg = (ConfigData.exploration)[expFloorList[1]]
    self.__mapLogic = expCfg.map_logic
  else
    do
      if self.fromModule == (FmtEnum.eFmtFromModule).Infinity then
        local sectorId = self.stageId // 1000
        local index = self.stageId % 100
        local endless = ((ConfigData.endless)[sectorId])[index]
        if endless == nil then
          error("endless is nil , id:" .. tostring(self.stageId))
          self.__mapLogic = nil
        end
        local layerCfg = (ConfigData.endless_layer)[(endless.layer)[1]]
        local expCfg = (ConfigData.exploration)[(layerCfg.map_para)[1]]
        self.__mapLogic = expCfg.map_logic
      else
        do
          if self.fromModule == (FmtEnum.eFmtFromModule).WeeklyChallenge then
            local weeklyData = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeDataByDungeonId(self.stageId)
            if weeklyData == nil then
              error(" weeklyChallenge is nil ,id:" .. tostring(self.stageId))
              self.__mapLogic = nil
            end
            self.__mapLogic = weeklyData:GetMapLogic()
          else
            do
              if self.fromModule == (FmtEnum.eFmtFromModule).DailyDungeonLevel then
                self.__mapLogic = (ExplorationEnum.eMapLogic).Default
              end
            end
          end
        end
      end
    end
  end
end

EnterFmtData.__TryGenDungeonDyncData4InBattleFmt = function(self)
  -- function num : 0_101 , upvalues : FormationUtil
  if self.isInBattleFmt then
    self.fmtDungeonDyncData = (FormationUtil.GetDyncDgDataByFmtFromModule)(self.fromModule)
  end
end

EnterFmtData.__TryGenSupportData = function(self)
  -- function num : 0_102 , upvalues : FmtEnum, _ENV
  if self:IsFmtChallengeMode() then
    self.isFriendSupport = false
    self.__forceShowSupportNotAvaliable = true
    return 
  end
  if self:IsFmtInWarChessDeploy() then
    self.isFriendSupport = false
    self.__forceShowSupportNotAvaliable = true
    return 
  end
  if self:IsFmtActivityForbidSupport() then
    self.isFriendSupport = false
    self.__forceShowSupportNotAvaliable = true
    return 
  end
  local fromModule = self.fromModule
  if fromModule == (FmtEnum.eFmtFromModule).DailyDungeonLevel then
    fromModule = (FmtEnum.eFmtFromModule).DailyDungeon
  end
  local supportLimitCfg = (ConfigData.support_limit)[fromModule]
  if supportLimitCfg ~= nil then
    self.isFriendSupportHaveTimeLimit = supportLimitCfg.is_limited
    if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Support) then
      local isSupportUnlock = (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited()
    end
    if supportLimitCfg.is_open and isSupportUnlock then
      self.isFriendSupport = not self.forbidSupport
      if self.isFriendSupportHaveTimeLimit then
        local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterMoudleSupportLimit, 0)
        if PlayerDataCenter.timestamp >= counterElem.nextExpiredTm or self:GetSupportTimeLimit() > counterElem.times then
          do
            self.isFriendSupportTimeLimitted = counterElem == nil
            if self:IsFmtInBattleDeploy() and supportLimitCfg.is_open == nil then
              if isSupportUnlock then
                do
                  self.isFriendSupport = not self.forbidSupport
                  -- DECOMPILER ERROR: 4 unprocessed JMP targets
                end
              end
            end
          end
        end
      end
    end
  end
end

EnterFmtData.__TryGenOfficialSupportData = function(self)
  -- function num : 0_103 , upvalues : _ENV, OfficialSupportHeroData
  if self.__officialSupportCfgId == nil or self.__officialSupportCfgId == 0 then
    return 
  end
  local officialAssistCfg = (ConfigData.official_assist)[self.__officialSupportCfgId]
  if officialAssistCfg == nil then
    error("officialAssistCfg not exist, wcAssist id:" .. tostring(self.__officialSupportCfgId))
    return 
  end
  self.__isHaveOfficialSupport = true
  self.__allOfficialSupportHeroDataDic = {}
  for index,heroId in ipairs(officialAssistCfg.param1) do
    local assistCfgId = (officialAssistCfg.assist_lvs)[index]
    local power = (officialAssistCfg.effective)[index]
    local assisLvCfg = (ConfigData.assist_level)[assistCfgId]
    local osHeroData = (OfficialSupportHeroData.GenOfficialSupportHeroData)(heroId, assisLvCfg, power)
    osHeroData:SetOfficialSupportCfgId(self.__officialSupportCfgId)
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.__allOfficialSupportHeroDataDic)[heroId] = osHeroData
  end
end

EnterFmtData.__TryGenFmtRecommendData = function(self)
  -- function num : 0_104 , upvalues : FmtEnum, _ENV, DungeonTowerUtil
  self.__couldShowRecommendBtn = false
  if self.fromModule == (FmtEnum.eFmtFromModule).SectorLevel or self.fromModule == (FmtEnum.eFmtFromModule).Infinity then
    local recommeCtrl = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
    if recommeCtrl:IsCanReqRecomme(self.stageId, false) then
      self.__couldShowRecommendBtn = true
    end
  else
    do
      if (self.fromModule == (FmtEnum.eFmtFromModule).DungeonTower or self.fromModule == (FmtEnum.eFmtFromModule).DungeonTwinTower) and (DungeonTowerUtil.TowerHasRecommendFormation)(self.stageId) then
        self.__couldShowRecommendBtn = true
      end
    end
  end
end

EnterFmtData.__TryGenCommandSkillData = function(self)
  -- function num : 0_105 , upvalues : FmtEnum, _ENV
  if (FmtEnum.GetFmtGameTypeByModuleId)(self.fromModule) == (FmtEnum.eFmtGamePlayType).Dungeon then
    local stageCfg = (ConfigData.battle_dungeon)[self.stageId]
    if stageCfg ~= nil then
      self.isCloseCommandSkill = stageCfg.close_cmdskill
    end
  end
end

EnterFmtData.GetFmtLimitHeroNum = function(self)
  -- function num : 0_106 , upvalues : FmtEnum, _ENV
  do
    if self.fromModule == (FmtEnum.eFmtFromModule).SectorLevel or self.fromModule == (FmtEnum.eFmtFromModule).CarnivalEp or self.fromModule == (FmtEnum.eFmtFromModule).SpringEp then
      local sectorStageCfg = (ConfigData.sector_stage)[self.stageId]
      if sectorStageCfg == nil then
        error("sectorStageCfg is nil ,id:" .. tostring(self.stageId))
        return 0
      end
      return sectorStageCfg.formation_num_limit
    end
    return 0
  end
end

EnterFmtData.IsFmtPlatformBan = function(self, platformIdx)
  -- function num : 0_107
  local limitHeroNum = self:GetFmtLimitHeroNum()
  do return limitHeroNum > 0 and limitHeroNum < platformIdx end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EnterFmtData.TryReGenFixedFmtData = function(self, fmtIndex)
  -- function num : 0_108
  if self:IsFmtFixedCouldChangeTeam() then
    self.__wcCurTeamIndex = fmtIndex
    self:__GenIsFmtFixed()
    return true
  end
  return false
end

return EnterFmtData

