-- params : ...
-- function num : 0 , upvalues : _ENV
WarChessManager = {}
local util = require("XLua.Common.xlua_util")
local WarChessCtrl = require("Game.WarChess.WarChessCtrl")
local WCGuideUtil = require("Game.WarChess.Util.WCGuideUtil")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
-- DECOMPILER ERROR at PC22: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__isInWarChess = false
  self.__isHaveUncompleteWarChess = false
  self.__uncompleteData = nil
  self.__wcCtrl = nil
  self.wcLevelId = nil
  self.wcLevelCfg = nil
  self.restartFunc = nil
  self.restartCostId = nil
  self.restartCostNum = nil
  self.__levelNameStr = nil
  self.__levelIndexStr = nil
  self.__recommendPower = nil
  self.__wcNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.WarChess)
end

-- DECOMPILER ERROR at PC25: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.InitWarchessCtrl = function(self)
  -- function num : 0_1 , upvalues : WarChessCtrl
  self.__isInWarChess = true
  self.__wcCtrl = (WarChessCtrl.New)()
end

-- DECOMPILER ERROR at PC28: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ExitWarChessClean = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.finishCo ~= nil then
    (GR.StopCoroutine)(self.finishCo)
    self.finishCo = nil
  end
  if self.__isInWarChess then
    if self.__wcCtrl ~= nil then
      (self.__wcCtrl):Delete()
    end
    self:CleamWCManager()
  end
end

-- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.CleamWCManager = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.__isInWarChess = false
  self.__wcCtrl = nil
  self.wcLevelId = nil
  self.wcLevelCfg = nil
  self.restartFunc = nil
  self.restartCostId = nil
  self.restartCostNum = nil
  self._stageId = nil
  self.isWCFinish = nil
  WarChessManager:ClearWcAudio()
end

-- DECOMPILER ERROR at PC34: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetIsInWarChess = function(self)
  -- function num : 0_4
  return self.__isInWarChess
end

-- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.SetLevelNameAndIndex = function(self, nameStr, indexStr)
  -- function num : 0_5
  self.__levelNameStr = nameStr
  self.__levelIndexStr = indexStr
end

-- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.SetWCRecommendPower = function(self, power)
  -- function num : 0_6
  self.__recommendPower = power
end

-- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetLevelNameAndIndex = function(self)
  -- function num : 0_7
  return self.__levelNameStr, self.__levelIndexStr
end

-- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.SyncIsHaveUncompletedWarChess = function(self)
  -- function num : 0_8 , upvalues : _ENV, eWarChessEnum, SectorStageDetailHelper, SectorLevelDetailEnum
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess) then
    return 
  end
  ;
  (self.__wcNetworkCtrl):CS_WarChess_Brief_Detail(function(args)
    -- function num : 0_8_0 , upvalues : _ENV, self, eWarChessEnum, SectorStageDetailHelper, SectorLevelDetailEnum
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    self.__isHaveUncompleteWarChess = false
    self.__uncompleteData = nil
    WarChessSeasonManager:SetUncompleteWCSData(false)
    local msg = args[0]
    for _,briefMsg in pairs(msg.detail) do
      if briefMsg.sectorId or briefMsg.detailType ~= (eWarChessEnum.eBriefDetailType).normal or 0 > 0 then
        self.__isHaveUncompleteWarChess = true
        self.__uncompleteData = {sectorStageId = briefMsg.sectorId, warchessId = briefMsg.warchessId, strengthWinReward = briefMsg.strengthWinReward}
        local stageCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)((SectorStageDetailHelper.PlayMoudleType).Warchess)
        self.__recommendPower = stageCfg.combat
        if stageCfg.sector ~= nil and stageCfg.difficulty <= (SectorLevelDetailEnum.eDifficulty).infinity then
          (PlayerDataCenter.sectorStage):InitSelectStage(stageCfg.sector, stageCfg.difficulty)
        end
      end
      do
        do
          if briefMsg.detailType == (eWarChessEnum.eBriefDetailType).season then
            WarChessSeasonManager:SetUncompleteWCSData(true, briefMsg)
          end
          -- DECOMPILER ERROR at PC69: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
    MsgCenter:Broadcast(eMsgEventId.OnHasUncompletedEp)
  end
)
end

-- DECOMPILER ERROR at PC49: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ContinueLastWarchess = function(self)
  -- function num : 0_9 , upvalues : eWarChessEnum, _ENV
  local warChessType = (eWarChessEnum.eBriefDetailType).normal
  ;
  (self.__wcNetworkCtrl):CS_WarChess_Detail(warChessType, function(argList)
    -- function num : 0_9_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local warChessMsg = argList[0]
    self:InitWarchessCtrl()
    local sectorStageCfg = (ConfigData.sector_stage)[(self.__uncompleteData).sectorStageId]
    self._stageId = (self.__uncompleteData).sectorStageId
    ;
    (PlayerDataCenter.sectorStage):SetSelectSectorId(sectorStageCfg.sector)
    self.__levelNameStr = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
    self.__levelIndexStr = ConfigData:GetSectorInfoMsg(sectorStageCfg.sector, sectorStageCfg.num, sectorStageCfg.difficulty)
    self.wcLevelId = (sectorStageCfg.exploration_list)[1]
    self.wcLevelCfg = (ConfigData.warchess_level)[self.wcLevelId]
    if self.wcLevelCfg == nil then
      error((string.format)("can\'t read wcLevelCfg by stageId:%s, levelId:%s", tostring(self._stageId), tostring(self.wcLevelId)))
      return 
    end
    self:CleanOrtherWhenEnter()
    ;
    (self.__wcCtrl):EnterWarChessByMsg(warChessMsg.data, true)
  end
)
end

-- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCSectorStageCfg = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._stageId == nil then
    return nil
  end
  local sectorStageCfg = (ConfigData.sector_stage)[self._stageId]
  return sectorStageCfg
end

-- DECOMPILER ERROR at PC55: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GiveUpWarchess = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local rewardList = (wcCtrl.backPackCtrl):GetIsWCRewardBagItemList()
  UIManager:HideWindow(UIWindowTypeID.BattlePause)
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessGameFail, function(window)
    -- function num : 0_11_0 , upvalues : _ENV, rewardList, wcCtrl
    window:SetPlayOverCallback(function()
      -- function num : 0_11_0_0 , upvalues : _ENV, rewardList, wcCtrl
      WarChessManager:OpenWCRewardBagSelect(rewardList, function(pickInfo)
        -- function num : 0_11_0_0_0 , upvalues : wcCtrl, _ENV
        (wcCtrl.wcNetworkCtrl):CS_WarChess_Quit(pickInfo, function(msg)
          -- function num : 0_11_0_0_0_0 , upvalues : _ENV
          WarChessManager:WarChessFinishSubFunc(msg, false, nil)
        end
)
      end
)
    end
)
  end
)
end

-- DECOMPILER ERROR at PC58: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GiveUpLastWarchess = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local rewardList = nil
  if self.__uncompleteData ~= nil then
    rewardList = (self.__uncompleteData).strengthWinReward
  else
    rewardList = false
  end
  self._stageId = (self.__uncompleteData ~= nil and (self.__uncompleteData).sectorStageId)
  WarChessManager:OpenWCRewardBagSelect(rewardList, function(pickInfo)
    -- function num : 0_12_0 , upvalues : self, _ENV
    (self.__wcNetworkCtrl):CS_WarChess_Quit(pickInfo, function(args)
      -- function num : 0_12_0_0 , upvalues : self, _ENV
      self.__uncompleteData = nil
      self.__isHaveUncompleteWarChess = false
      local warChessSettleData = (args[0]).data
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_12_0_0_0 , upvalues : _ENV, warChessSettleData
        if window ~= nil then
          local CommonRewardData = require("Game.CommonUI.CommonRewardData")
          local CRData = ((CommonRewardData.CreateCRDataUseDic)((warChessSettleData.rewards).stmStorePickRewards)):SetCRNotHandledGreat(true)
          window:AddAndTryShowReward(CRData)
        end
      end
)
      WarChessSeasonManager:SetUncompleteWCSData(false)
      MsgCenter:Broadcast(eMsgEventId.GiveUncompleteExploration)
      MsgCenter:Broadcast(eMsgEventId.OnHasUncompletedEp)
      self._stageId = nil
    end
)
  end
)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC61: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetIsHaveUncompletedWarChess = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self.__uncompleteData == nil then
    return false
  end
  return self.__isHaveUncompleteWarChess, (self.__uncompleteData).sectorStageId, proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess, false
end

-- DECOMPILER ERROR at PC64: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWarChessCtrl = function(self)
  -- function num : 0_14
  return self.__wcCtrl
end

-- DECOMPILER ERROR at PC67: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelShopId = function(self)
  -- function num : 0_15
  return (self:GetWCLevelCfg()).shop
end

-- DECOMPILER ERROR at PC70: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelId = function(self)
  -- function num : 0_16
  return self.wcLevelId
end

-- DECOMPILER ERROR at PC73: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelCfg = function(self)
  -- function num : 0_17
  return self.wcLevelCfg
end

-- DECOMPILER ERROR at PC76: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelStressId = function(self)
  -- function num : 0_18
  return (self.wcLevelCfg).stress
end

-- DECOMPILER ERROR at PC79: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCOfficialSupportCfgId = function(self)
  -- function num : 0_19
  if (self.wcLevelCfg).assist_id <= 0 then
    return nil
  end
  return (self.wcLevelCfg).assist_id
end

-- DECOMPILER ERROR at PC82: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelStressCfg = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local stressId = (self.wcLevelCfg).stress
  local stressCfg = (ConfigData.warchess_stress)[stressId]
  return stressCfg
end

-- DECOMPILER ERROR at PC85: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCLevelGlobalTriggerCfg = function(self)
  -- function num : 0_21
  local isHaveGTrigger = (self.wcLevelCfg).trigger_id ~= nil
  do return isHaveGTrigger, (self.wcLevelCfg).trigger_icon, (self.wcLevelCfg).trigger_id end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC88: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCGlobalData = function(self)
  -- function num : 0_22
  return (self.__wcCtrl).wcGlobalData
end

-- DECOMPILER ERROR at PC91: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCGuideActionList = function(self, moment, logicCoord, tipArg)
  -- function num : 0_23 , upvalues : WCGuideUtil
  local wcLevelId = self:GetWCLevelId()
  return (WCGuideUtil.GetWCGuideActionsById)(wcLevelId, moment, logicCoord, tipArg)
end

-- DECOMPILER ERROR at PC94: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.QuickExeWCGuideActions = function(self, moment, logicCoord, battleCount, tipArg)
  -- function num : 0_24 , upvalues : WCGuideUtil
  local actionList = self:GetWCGuideActionList(moment, logicCoord, tipArg)
  if actionList ~= nil and #actionList > 0 then
    (WCGuideUtil.ExecuteWCGuideActions)(actionList, battleCount)
    return true
  else
    return false
  end
end

-- DECOMPILER ERROR at PC97: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.EnterWarChessBySectorStageId = function(self, stageId, challengeData)
  -- function num : 0_25 , upvalues : _ENV, eWarChessEnum
  self:InitWarchessCtrl()
  local stageCfg = (ConfigData.sector_stage)[stageId]
  self._stageId = stageId
  ;
  (PlayerDataCenter.sectorStage):SetSelectSectorId(stageCfg.sector)
  self.__levelNameStr = (LanguageUtil.GetLocaleText)(stageCfg.name)
  self.__levelIndexStr = ConfigData:GetSectorInfoMsg(stageCfg.sector, stageCfg.num, stageCfg.difficulty)
  self.wcLevelId = (stageCfg.exploration_list)[1]
  self.wcLevelCfg = (ConfigData.warchess_level)[self.wcLevelId]
  self.__recommendPower = stageCfg.combat
  if self.wcLevelCfg == nil then
    error("war chess LevelCfg not exist:" .. tostring(self.wcLevelId))
    return 
  end
  local isChallengeMode, challengeQuestsList = nil, nil
  if challengeData ~= nil then
    isChallengeMode = challengeData:IsStageChallengeOpen()
    challengeQuestsList = challengeData:GetStgClgOptionalTaskOpenList()
  end
  local warChessType = (eWarChessEnum.eBriefDetailType).normal
  ;
  ((self.__wcCtrl).wcNetworkCtrl):CS_WarChess_SingleStart(stageId, isChallengeMode, challengeQuestsList, warChessType, function(argList)
    -- function num : 0_25_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local warChessMsg = argList[0]
    self:CleanOrtherWhenEnter()
    ;
    (self.__wcCtrl):EnterWarChessByMsg(warChessMsg)
  end
)
end

-- DECOMPILER ERROR at PC100: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.EnterWarChessByOutMsg = function(self, warChessOutMsg, isReconnect)
  -- function num : 0_26 , upvalues : _ENV
  self:InitWarchessCtrl()
  self.__levelNameStr = self.__levelNameStr or "???"
  self.__levelIndexStr = self.__levelIndexStr or "???"
  self.wcLevelId = warChessOutMsg.configId
  self.wcLevelCfg = (ConfigData.warchess_level)[self.wcLevelId]
  self.__recommendPower = self.__recommendPower or 0
  if self.wcLevelCfg == nil then
    error("war chess LevelCfg not exist:" .. tostring(self.wcLevelId))
    return 
  end
  self:CleanOrtherWhenEnter()
  ;
  (self.__wcCtrl):EnterWarChessByMsg(warChessOutMsg, isReconnect)
end

-- DECOMPILER ERROR at PC103: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.CleanOrtherWhenEnter = function(self)
  -- function num : 0_27 , upvalues : _ENV
  UIManager:DeleteAllWindow()
  ControllerManager:DeleteController(ControllerTypeId.SectorController)
end

-- DECOMPILER ERROR at PC106: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.SetWCRestart = function(self, restartFunc, restartCostId, restartCostNum)
  -- function num : 0_28
  self.restartFunc = restartFunc
  self.restartCostId = restartCostId
  self.restartCostNum = restartCostNum
end

-- DECOMPILER ERROR at PC109: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCRestart = function(self)
  -- function num : 0_29
  return self.restartFunc, self.restartCostId, self.restartCostNum
end

-- DECOMPILER ERROR at PC112: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.IsWCCouldRestart = function(self)
  -- function num : 0_30
  do return self.restartFunc ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC115: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.IsWCInBattle = function(self)
  -- function num : 0_31 , upvalues : eWarChessEnum
  do return (self.__wcCtrl):GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC118: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.IsWCInGuardBattle = function(self)
  -- function num : 0_32 , upvalues : eWarChessEnum
  if self.__wcCtrl ~= nil and (self.__wcCtrl):GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle then
    return ((self.__wcCtrl).battleCtrl):IsInGuardBattle()
  end
  return false
end

-- DECOMPILER ERROR at PC121: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCCoinNum = function(self)
  -- function num : 0_33
  if self.__wcCtrl ~= nil and (self.__wcCtrl).backPackCtrl ~= nil then
    return ((self.__wcCtrl).backPackCtrl):GetWCCoinNum()
  end
  return 0
end

-- DECOMPILER ERROR at PC124: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.SetWCCacheCoinNum = function(self, goldCount)
  -- function num : 0_34
  if self.__wcCtrl ~= nil and (self.__wcCtrl).backPackCtrl ~= nil then
    return ((self.__wcCtrl).backPackCtrl):SetCacheMoneyCount(goldCount)
  end
  return 0
end

-- DECOMPILER ERROR at PC127: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCCacheCoinNum = function(self)
  -- function num : 0_35
  if self.__wcCtrl ~= nil and (self.__wcCtrl).backPackCtrl ~= nil then
    return ((self.__wcCtrl).backPackCtrl):GetCacheMoneyCount()
  end
  return 0
end

-- DECOMPILER ERROR at PC130: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.TryExitWCBattle = function(self)
  -- function num : 0_36 , upvalues : eWarChessEnum
  if (self.__wcCtrl):GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle then
    ((self.__wcCtrl).battleCtrl):WCEscapeFromBattle()
  end
end

-- DECOMPILER ERROR at PC133: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.WarChessFinishSubFunc = function(self, args, isWin, heroIdSnapShoot)
  -- function num : 0_37 , upvalues : _ENV
  if args.Count == 0 then
    error("args.Count == 0")
    return 
  end
  local warChessSettleData = (args[0]).data
  local warChessSeasonSettleData = (args[0]).seasonData
  local wcSettelRewardData = {}
  if warChessSettleData.rewards ~= nil then
    wcSettelRewardData.firstPassRewardDic = (warChessSettleData.rewards).firstClear
    wcSettelRewardData.innerWCReardDic = (warChessSettleData.rewards).normalRewards
    wcSettelRewardData.stmStorePickRewardDic = (warChessSettleData.rewards).stmStorePickRewards
  end
  if warChessSeasonSettleData ~= nil then
    if wcSettelRewardData.innerWCReardDic == nil then
      wcSettelRewardData.innerWCReardDic = warChessSeasonSettleData.rewardItems
    else
      for itemId,itemNum in pairs(warChessSeasonSettleData.rewardItems) do
        -- DECOMPILER ERROR at PC43: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (wcSettelRewardData.innerWCReardDic)[itemId] = ((wcSettelRewardData.innerWCReardDic)[itemId] or 0) + itemNum
      end
    end
  end
  do
    local WCResultFunc = function(isFakeWin)
    -- function num : 0_37_0 , upvalues : wcSettelRewardData, _ENV, heroIdSnapShoot, isWin, self
    local settelRewardData = wcSettelRewardData
    if settelRewardData.innerWCReardDic ~= nil then
      local new_normalReward = {}
      local aftertTeatmentRewardDic = {}
      local aftertTeatmentCareerDic = {}
      local StOCareerItemIdDic = (ConfigData.game_config).STOCareerCostDic
      local extrAwardDic = (ConfigData.activity_time_limit).exchangeMapping
      for itemId,num in pairs(settelRewardData.innerWCReardDic) do
        if StOCareerItemIdDic[itemId] ~= nil then
          aftertTeatmentCareerDic[itemId] = num
        else
          if extrAwardDic[itemId] ~= nil then
            aftertTeatmentRewardDic[itemId] = num
          else
            new_normalReward[itemId] = num
          end
        end
      end
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
      aftertTeatmentCtrl:AddShowStOCareerReward(aftertTeatmentCareerDic)
      aftertTeatmentCtrl:AddShowReward(aftertTeatmentRewardDic)
      settelRewardData.innerWCReardDic = new_normalReward
    end
    do
      local newHeroDic = {}
      local AddItem_func = function(itemDic)
      -- function num : 0_37_0_0 , upvalues : _ENV, heroIdSnapShoot, newHeroDic
      for k,v in pairs(itemDic) do
        local itemCfg = (ConfigData.item)[k]
        if itemCfg ~= nil and itemCfg.action_type == eItemActionType.HeroCard then
          local heroId = (itemCfg.arg)[1]
          if not heroIdSnapShoot[heroId] then
            newHeroDic[heroId] = true
          end
        end
      end
    end

      if settelRewardData.firstPassRewardDic ~= nil then
        AddItem_func(settelRewardData.firstPassRewardDic)
      end
      if settelRewardData.stmStorePickRewardDic ~= nil then
        AddItem_func(settelRewardData.stmStorePickRewardDic)
      end
      do
        if (table.count)(newHeroDic) > 0 then
          local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
          aftertTeatmentCtrl:AddNewHeroReward(newHeroDic)
        end
        UIManager:ShowWindowAsync(UIWindowTypeID.WarChessResult, function(window)
      -- function num : 0_37_0_1 , upvalues : isFakeWin, isWin, settelRewardData, self
      if not isFakeWin then
        window:InitWarChessResult(window == nil or isWin)
        window:RefreshWCResultReward(settelRewardData)
        window:RefreshWCLevelInfo(self.__levelNameStr, self.__levelIndexStr)
      end
    end
)
      end
    end
  end

    if WarChessSeasonManager:GetIsInWCSeason() then
      WarChessSeasonManager:WCSSettle(isWin, args[0], WCResultFunc)
      return 
    end
    WCResultFunc()
    if self._stageId ~= nil and warChessSettleData.rewards ~= nil then
      local challengeQuestRewards = (warChessSettleData.rewards).challengeRewards
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
      local challengeQuestList = warChessSettleData.challengeQuests
      if challengeQuestRewards ~= nil and #challengeQuestList > 0 then
        local fromNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskCompleteNum(self._stageId)
        local toNum = fromNum + #challengeQuestList
        local totalNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskNum(self._stageId)
        aftertTeatmentCtrl:SetShowChallengeModeReward(challengeQuestRewards, fromNum, toNum, totalNum)
      end
      do
        for k,questId in ipairs(challengeQuestList) do
          (PlayerDataCenter.sectorAchievementDatas):SetChallengeTaskComplete(self._stageId, questId)
        end
      end
    end
  end
end

-- DECOMPILER ERROR at PC136: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.WarchesFinish = function(self, isWin, castOverData)
  -- function num : 0_38 , upvalues : _ENV, util, eWarChessEnum
  local Finish = function(selectedRewardInfo)
    -- function num : 0_38_0 , upvalues : _ENV, self, isWin
    UIManager:HideWindow(UIWindowTypeID.WarChessNotice)
    local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    ;
    ((self.__wcCtrl).wcNetworkCtrl):CS_WarChess_Settle(selectedRewardInfo, function(args)
      -- function num : 0_38_0_0 , upvalues : _ENV, isWin, heroIdSnapShoot
      WarChessManager:WarChessFinishSubFunc(args, isWin, heroIdSnapShoot)
    end
)
  end

  self.finishCo = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_38_1 , upvalues : self, _ENV, eWarChessEnum, castOverData, isWin, Finish
    while not (self.__wcCtrl):GetIsInWarChessScene() do
      (coroutine.yield)(nil)
    end
    local IsPlaying = function()
      -- function num : 0_38_1_0 , upvalues : self, eWarChessEnum
      if (self.__wcCtrl).state == (eWarChessEnum.eWarChessState).play and (((self.__wcCtrl).curState):IsMovingMonster() or ((self.__wcCtrl).curState):IsMovingTeam() or ((self.__wcCtrl).curState):GetIsWaitingEntityAnimation()) then
        return true
      end
      if (self.__wcCtrl):IsWCInSubSystem() then
        return true
      end
      return false
    end

    while IsPlaying() do
      (coroutine.yield)(nil)
    end
    self.isWCFinish = true
    local wcsFloorReward = true
    if castOverData ~= nil then
      local overReward = castOverData.overReward
      if overReward == nil then
        wcsFloorReward = false
      else
        local celanFloorRewardDynCtrl = (self.__wcCtrl):LazyLoadDynCtrl((eWarChessEnum.eDynCtrl).cleanFloorReward)
        celanFloorRewardDynCtrl:OpenCleanFloorRewardSelect(overReward, function()
      -- function num : 0_38_1_1 , upvalues : wcsFloorReward
      wcsFloorReward = false
    end
)
      end
    else
      do
        wcsFloorReward = false
        ;
        (self.__wcCtrl):SetIsWCInAfterSettleProcess(true)
        while wcsFloorReward do
          (coroutine.yield)(nil)
        end
        ;
        (self.__wcCtrl):SetIsWCInAfterSettleProcess(false)
        local waitWinOrFailPlayOver = true
        if isWin then
          UIManager:ShowWindowAsync(UIWindowTypeID.WarChessGameWin, function(window)
      -- function num : 0_38_1_2 , upvalues : waitWinOrFailPlayOver
      window:SetPlayOverCallback(function()
        -- function num : 0_38_1_2_0 , upvalues : waitWinOrFailPlayOver
        waitWinOrFailPlayOver = false
      end
)
    end
)
        else
          UIManager:ShowWindowAsync(UIWindowTypeID.WarChessGameFail, function(window)
      -- function num : 0_38_1_3 , upvalues : waitWinOrFailPlayOver
      window:SetPlayOverCallback(function()
        -- function num : 0_38_1_3_0 , upvalues : waitWinOrFailPlayOver
        waitWinOrFailPlayOver = false
      end
)
    end
)
        end
        while waitWinOrFailPlayOver do
          (coroutine.yield)(nil)
        end
        UIManager:HideWindow(UIWindowTypeID.WarChessGameWin)
        UIManager:HideWindow(UIWindowTypeID.WarChessGameFail)
        local isSelecting, selectedRewardInfo = nil, nil
        if ((self.__wcCtrl).backPackCtrl):GetIsWCHaveRewardBag() then
          local isInWCS = (WarChessSeasonManager:GetIsInWCSeason())
          local isLastFloor = nil
          do
            if isInWCS then
              local wcsCtrl = WarChessSeasonManager:GetWCSCtrl()
              isLastFloor = wcsCtrl:WCSGetIsAtLastFloor()
            end
            if not isInWCS or isInWCS and (isLastFloor or not isWin) then
              isSelecting = true
              local rewardList = ((self.__wcCtrl).backPackCtrl):GetIsWCRewardBagItemList()
              WarChessManager:OpenWCRewardBagSelect(rewardList, function(pickInfo)
      -- function num : 0_38_1_4 , upvalues : selectedRewardInfo, isSelecting
      selectedRewardInfo = pickInfo
      isSelecting = false
    end
, isWin)
            end
            do
              while isSelecting do
                (coroutine.yield)(nil)
              end
              if Finish ~= nil then
                Finish(selectedRewardInfo)
              end
              self.finishCo = nil
            end
          end
        end
      end
    end
  end
))
end

-- DECOMPILER ERROR at PC139: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.OpenWCRewardBagSelect = function(self, rewardList, selectOverCallback, isWin)
  -- function num : 0_39 , upvalues : _ENV
  if rewardList ~= nil and #rewardList > 0 then
    UIManager:HideWindow(UIWindowTypeID.WarChessMain)
    UIManager:HideWindow(UIWindowTypeID.WarChessInfo)
    UIManager:ShowWindowAsync(UIWindowTypeID.EpRewardBag, function(window)
    -- function num : 0_39_0 , upvalues : _ENV, isWin, rewardList, selectOverCallback
    if window == nil then
      return 
    end
    local epModuleId, stageId, firstClearDic = nil, nil, nil
    local isInWCS = WarChessSeasonManager:IsInWCS()
    if isInWCS then
      local towerId = WarChessSeasonManager:GetWCSSeasonTowerID()
      local wcsTowerShopDropCfg = (ConfigData.warchess_tower_shop_drop)[towerId]
      epModuleId = proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason
      if wcsTowerShopDropCfg == nil then
        error("wcs not have reward bag config, but server send it, pls check")
      end
      local fakeStageId = wcsTowerShopDropCfg.stage_id
      stageId = fakeStageId
    else
      do
        do
          local sectorStageCfg = WarChessManager:GetWCSectorStageCfg()
          epModuleId = proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess
          stageId = sectorStageCfg.id
          if stageId and isWin then
            firstClearDic = ExplorationManager:GetEpFirstClearDic(stageId, epModuleId)
          end
          if window == nil then
            return 
          end
          window:InitEpRewardBag(rewardList, nil, true, firstClearDic, true, epModuleId, stageId)
          window:SetEpRewardBagCloseFunc(function(rewardDic, pickInfo)
      -- function num : 0_39_0_0 , upvalues : selectOverCallback, window
      if selectOverCallback ~= nil then
        selectOverCallback(pickInfo)
      end
      window:Delete()
    end
)
        end
      end
    end
  end
)
  else
    if isGameDev then
      print("reward bag try to show, but not have any thing")
    end
    if selectOverCallback ~= nil then
      selectOverCallback(nil)
    end
  end
end

-- DECOMPILER ERROR at PC142: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ForceExitWarchess = function(self)
  -- function num : 0_40
  if (self.__wcCtrl):GetIsInWarChessScene() then
    self:ExitWarChess()
  else
    ;
    (self.__wcCtrl):SetExitWhenLoadSuccess()
  end
end

-- DECOMPILER ERROR at PC145: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ExitWarChess = function(self, exit2SceneName, isWin, loadMainCallback, scenechangeCallback)
  -- function num : 0_41 , upvalues : _ENV, util
  local lastSatgeData = {stageCfg = (ConfigData.sector_stage)[self._stageId], isWin = isWin == true}
  ;
  ((CS.BattleManager).Instance):ForceExitBattle()
  MsgCenter:Broadcast(eMsgEventId.WC_ExitWC)
  AudioManager:RemoveAllVoice()
  UIManager:DeleteAllWindow()
  self:ExitWarChessClean()
  self:SyncIsHaveUncompletedWarChess()
  local isInWCS = (WarChessSeasonManager:GetIsInWCSeason())
  local seasonId, towerId, seasonLevelIndex, lastWCS = nil, nil, nil, nil
  if isInWCS then
    seasonId = WarChessSeasonManager:GetWCSSeasonId()
    towerId = WarChessSeasonManager:GetWCSSeasonTowerID()
    seasonLevelIndex = (WarChessSeasonManager:GetWCSCtrl()):WCSGetFloor()
    lastWCS = {seasonId = seasonId, towerId = towerId, seasonLevelIndex = seasonLevelIndex}
    WarChessSeasonManager:ExitWarChessClean()
  end
  if exit2SceneName ~= (Consts.SceneName).Main then
    if not isInWCS and ((PlayerDataCenter.sectorEntranceHandler).TrySpecialExitEp)(lastSatgeData, scenechangeCallback) then
      return 
    end
    if isInWCS and ((PlayerDataCenter.sectorEntranceHandler).TrySpecialExitSeason)(lastWCS, scenechangeCallback) then
      return 
    end
  end
  if exit2SceneName == nil or exit2SceneName == (Consts.SceneName).Sector then
    local loadingFunc = function()
    -- function num : 0_41_0 , upvalues : _ENV, scenechangeCallback
    UIManager:ShowWindowAsync(UIWindowTypeID.Sector, nil)
    while UIManager:GetWindow(UIWindowTypeID.Sector) == nil do
      (coroutine.yield)(nil)
    end
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, true)
    if sectorController:IsHave2PlayUnlockSectorShow() then
      sectorController:SetAfterUnlockSectorShowCallback(scenechangeCallback)
    else
      if scenechangeCallback ~= nil then
        scenechangeCallback()
      end
    end
  end

    ;
    (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(1)
    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_41_1 , upvalues : isInWCS, _ENV, lastWCS, lastSatgeData
    if isInWCS then
      (ControllerManager:GetController(ControllerTypeId.SectorController, true)):SetFrom(AreaConst.WarChessSeason, nil, nil, lastWCS)
      return 
    end
    ;
    (ControllerManager:GetController(ControllerTypeId.SectorController, true)):SetFrom(AreaConst.WarChess, nil, nil, lastSatgeData)
  end
, (util.cs_generator)(loadingFunc))
  elseif exit2SceneName == (Consts.SceneName).Main then
    (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(1)
    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
    -- function num : 0_41_2 , upvalues : _ENV, loadMainCallback, scenechangeCallback
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:CreateWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_41_2_0 , upvalues : _ENV, loadMainCallback, scenechangeCallback
      if window == nil then
        return 
      end
      window:SetFrom2Home(AreaConst.Home, true)
      if loadMainCallback ~= nil then
        loadMainCallback()
      end
      if scenechangeCallback ~= nil then
        scenechangeCallback()
      end
    end
)
  end
)
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC148: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetEpSceneBattleFieldSize = function(self)
  -- function num : 0_42
  local sceneCfg = self:GetWcSceneCfg()
  return sceneCfg.size_row, sceneCfg.size_col, sceneCfg.deploy_rows
end

-- DECOMPILER ERROR at PC151: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWcSceneCfg = function(self)
  -- function num : 0_43 , upvalues : _ENV
  local sceneCfg = (ConfigData.scene)[(self.wcLevelCfg).prefeb_id]
  if sceneCfg == nil then
    error("scene cfg is null,scene_id:" .. tostring((self.wcLevelCfg).prefeb_id))
  end
  return sceneCfg
end

-- DECOMPILER ERROR at PC154: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.GetWCRecommenPower = function(self)
  -- function num : 0_44
  return self.__recommendPower or 0
end

-- DECOMPILER ERROR at PC157: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager._TryGetStageBgmCfg = function(self)
  -- function num : 0_45 , upvalues : _ENV
  local sectorStateCfg = self:GetWCSectorStageCfg()
  if sectorStateCfg == nil or sectorStateCfg.stage_bgm_id == 0 then
    return nil
  end
  local stageBgmCfg = (ConfigData.sector_stage_bgm)[sectorStateCfg.stage_bgm_id]
  return stageBgmCfg
end

-- DECOMPILER ERROR at PC160: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.PlayWcAuBgm = function(self)
  -- function num : 0_46 , upvalues : _ENV
  local stageBgmCfg = self:_TryGetStageBgmCfg()
  if stageBgmCfg ~= nil then
    AudioManager:PlayAudioById(stageBgmCfg.bgm_id)
    return 
  end
  local sceneCfg = self:GetWcSceneCfg()
  AudioManager:PlayAudioById(sceneCfg.audio_id)
end

-- DECOMPILER ERROR at PC163: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.PlayWcAuSelctRoomSelect = function(self)
  -- function num : 0_47 , upvalues : _ENV
  local stageBgmCfg = self:_TryGetStageBgmCfg()
  if stageBgmCfg ~= nil and not (string.IsNullOrEmpty)(stageBgmCfg.selector) then
    AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, stageBgmCfg.selector, stageBgmCfg.label_lv_select)
    return 
  end
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Sector).name, (eAuSelct.Sector).roomSelect)
end

-- DECOMPILER ERROR at PC166: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.PlayWcAuSelctNormalCombat = function(self)
  -- function num : 0_48 , upvalues : _ENV
  local stageBgmCfg = self:_TryGetStageBgmCfg()
  if stageBgmCfg ~= nil and not (string.IsNullOrEmpty)(stageBgmCfg.selector) then
    AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, stageBgmCfg.selector, stageBgmCfg.label_normal_combat)
    return 
  end
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Sector).name, (eAuSelct.Sector).normalCombat)
end

-- DECOMPILER ERROR at PC169: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.PlayWcAuSelctBossCombat = function(self)
  -- function num : 0_49 , upvalues : _ENV
  local stageBgmCfg = self:_TryGetStageBgmCfg()
  if stageBgmCfg ~= nil and not (string.IsNullOrEmpty)(stageBgmCfg.selector) then
    AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, stageBgmCfg.selector, stageBgmCfg.label_boss_combat)
    return 
  end
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Sector).name, (eAuSelct.Sector).bossCombat)
end

-- DECOMPILER ERROR at PC172: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.ClearWcAudio = function(self)
  -- function num : 0_50 , upvalues : _ENV
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_Character)
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_Monster)
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_SupSkill)
  AudioManager:RemoveCueSheet(eAuCueSheet.Battle_Buff)
  AudioManager:RemoveCueSheet(eAuCueSheet.CommonSkill)
  AudioManager:RemoveCueSheet(eAuCueSheet.Ambience)
  AudioManager:RemoveAllVoice()
end

-- DECOMPILER ERROR at PC175: Confused about usage of register: R6 in 'UnsetPending'

WarChessManager.Delete = function(self)
  -- function num : 0_51 , upvalues : _ENV
  if self.finishCo ~= nil then
    (GR.StopCoroutine)(self.finishCo)
    self.finishCo = nil
  end
end

return WarChessManager

