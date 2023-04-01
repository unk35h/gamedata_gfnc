-- params : ...
-- function num : 0 , upvalues : _ENV
local ExplorationResultCtrl = class("ExplorationResultCtrl")
local EpMvpData = require("Game.Exploration.Data.EpMvpData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
ExplorationResultCtrl.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.epCtrl = ExplorationManager.epCtrl
  self.sectorId = nil
  self.__TryOpenStore = BindCallback(self, self._TryOpenStore)
  self.__ReqSettle = BindCallback(self, self._ReqSettle)
  self.__TryOpenStoreReward = BindCallback(self, self._TryOpenStoreReward)
  self.__TryOpenScore = BindCallback(self, self._TryOpenScore)
  self.__TryOpenResult = BindCallback(self, self._TryOpenResult)
  self.__ExitExplorationAndContinueProcess = BindCallback(self, self.ExitExplorationAndContinueProcess)
  self.__ContinueProcessEpExitAfter = BindCallback(self, self._ContinueProcessEpExitAfter)
  self.processTable_InEp = {self.__TryOpenStore, self.__ReqSettle, self.__TryOpenScore, self.__TryOpenResult, self.__ExitExplorationAndContinueProcess}
  self.processTable_OutEp = {self.__TryOpenStore, self.__ReqSettle, self.__TryOpenStoreReward, self.__ContinueProcessEpExitAfter}
end

ExplorationResultCtrl.EnterResultProcess = function(self, isWin, isInEp, battleEndClearCallback)
  -- function num : 0_1 , upvalues : _ENV
  if ExplorationManager.epCtrl ~= nil then
    ((ExplorationManager.epCtrl).autoCtrl):CloseAutoMode()
  end
  self.battleEndClearCallback = battleEndClearCallback
  self.isWin = isWin
  self.isInEp = isInEp
  self.storeRewardDic = nil
  self.pickInfo = nil
  self.resultMsg = nil
  self.firstRewardDic = nil
  self.normalRewardDic = nil
  self.fixRewardDic = nil
  self:CloseBattleUI()
  if not self.isInEp or not self.processTable_InEp then
    self.processTable = self.processTable_OutEp
    self:_ContinueNextStep(true)
  end
end

ExplorationResultCtrl.ExitExplorationAndContinueProcess = function(self, SceneName, loadMainCallback)
  -- function num : 0_2 , upvalues : _ENV
  self:ExecuteBattleEndClear()
  ExplorationManager:ExitExploration(SceneName, loadMainCallback, self.isWin, self.__ContinueProcessEpExitAfter)
end

ExplorationResultCtrl.ExecuteBattleEndClear = function(self)
  -- function num : 0_3
  if self.isExecutedBattleEndClear then
    return 
  end
  self.isExecutedBattleEndClear = true
  if self.battleEndClearCallback ~= nil then
    (self.battleEndClearCallback)()
  end
end

ExplorationResultCtrl.CloseBattleUI = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.DungeonStateInfo)
  UIManager:HideWindow(UIWindowTypeID.Exploration)
  UIManager:HideWindow(UIWindowTypeID.EpEventRoom)
  UIManager:HideWindow(UIWindowTypeID.BattlePause)
  UIManager:HideWindow(UIWindowTypeID.EpChipSuit)
end

ExplorationResultCtrl._TryOpenStore = function(self)
  -- function num : 0_5 , upvalues : _ENV, SectorStageDetailHelper
  local epBagDropList = ExplorationManager:GetStoreData()
  local hasBagDrop = epBagDropList ~= nil and #epBagDropList > 0
  if not hasBagDrop then
    self:_ContinueNextStep()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpRewardBag, function(window)
    -- function num : 0_5_0 , upvalues : self, _ENV, SectorStageDetailHelper, epBagDropList
    if window == nil then
      return 
    end
    local stageCfg, epModuleId, stageId = nil, nil, nil
    if self.isInEp then
      stageCfg = ExplorationManager:GetSectorStageCfg()
      epModuleId = ExplorationManager:GetEpModuleId()
      stageId = ExplorationManager:GetEpDungeonId()
    else
      stageCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)((SectorStageDetailHelper.PlayMoudleType).Ep)
      _ = ExplorationManager:HasUncompletedEp()
    end
    if not self.isWin or not ExplorationManager:GetEpFirstClearDic(stageId, R7_PC28) then
      local firstClearRewards = table.emptytable
    end
    -- DECOMPILER ERROR at PC45: Overwrote pending register: R7 in 'AssignReg'

    window:InitEpRewardBag(R7_PC28, stageCfg, self.isInEp, firstClearRewards, true, epModuleId, stageId)
    if self.mapCtrl ~= nil then
      (self.mapCtrl):HideMapCavasWithoutBg()
    end
    -- DECOMPILER ERROR at PC60: Overwrote pending register: R7 in 'AssignReg'

    window:SetEpRewardBagCloseFunc(R7_PC28)
  end
)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ExplorationResultCtrl._ReqFailRewardShowAndShow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.isWin then
    return 
  end
  local network = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  network:CS_EXPLORATION_RewardsShow(function(dataList)
    -- function num : 0_6_0 , upvalues : _ENV, self
    local msgData = nil
    if dataList.Count > 0 then
      msgData = dataList[0]
    else
      msgData = {}
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.ExplorationResult, function(window)
      -- function num : 0_6_0_0 , upvalues : _ENV, msgData, self
      if window == nil then
        return 
      end
      window:FailExploration(clearAction, msgData.rewards, msgData.backStm)
      window:SetReturnCallback(function()
        -- function num : 0_6_0_0_0 , upvalues : self
        self:_ContinueNextStep()
      end
)
    end
)
  end
)
end

ExplorationResultCtrl._ReqSettle = function(self)
  -- function num : 0_7 , upvalues : _ENV, EpMvpData, SectorStageDetailHelper
  local position = nil
  local isAutoSettle = false
  local isGiveUpLastEp = false
  local costumeStm = false
  local mvpHeroId = 0
  local refreshLastEp = nil
  local _, suitLevelMap = ExplorationManager:GetChipSuitMaxLevelDic()
  local epNormalStageId = nil
  if self.isInEp then
    local moduleId = ExplorationManager:GetEpModuleId()
    position = ((ExplorationManager:GetDynPlayer()):GetOperatorDetail()).curPostion
    if ExplorationManager.epMvpData == nil or not (ExplorationManager.epMvpData):GetBossFightMvp(true) then
      mvpHeroId = (((ExplorationManager:GetDynPlayer()).heroList)[1]).uid
    end
    local sectorCfg = ExplorationManager:GetSectorCfg()
    if sectorCfg ~= nil then
      self.sectorId = sectorCfg.id
      local stageCfg = ExplorationManager:GetSectorStageCfg()
      if stageCfg ~= nil and moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
        epNormalStageId = stageCfg.id
      end
    end
  else
    do
      local lastEpData = ExplorationManager:GetLastEpData()
      position = (lastEpData.epOp).curPostion
      local moduleId = (lastEpData.epMap).moduleId
      local mapData = (EpMvpData.New)((lastEpData.epRoleStc).heroes)
      mapData:AddServerSaveData((lastEpData.epStc).record)
      mvpHeroId = mapData:GetBossFightMvp(true)
      isGiveUpLastEp = true
      do
        local sectorStageCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)((SectorStageDetailHelper.PlayMoudleType).Ep)
        if sectorStageCfg ~= nil then
          self.sectorId = sectorStageCfg.sector
          if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
            epNormalStageId = sectorStageCfg.id
          end
        end
        local network = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
        local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
        self:CalEpTransDic()
        network:CS_EXPLORATION_Settle(position, isAutoSettle, isGiveUpLastEp, costumeStm, mvpHeroId, self.pickInfo, refreshLastEp, suitLevelMap, function(msg)
    -- function num : 0_7_0 , upvalues : self, isGiveUpLastEp, _ENV, epNormalStageId, heroIdSnapShoot
    self.resultMsg = msg
    if isGiveUpLastEp then
      MsgCenter:Broadcast(eMsgEventId.GiveUncompleteExploration)
    end
    self:_RewardSplit(epNormalStageId, heroIdSnapShoot)
    self:_ContinueNextStep()
    ExplorationManager:SettleDataDeal(msg)
  end
)
      end
    end
  end
end

ExplorationResultCtrl.CalEpTransDic = function(self)
  -- function num : 0_8 , upvalues : _ENV, SectorStageDetailHelper
  local stageCfg = nil
  if self.isInEp then
    stageCfg = ExplorationManager:GetSectorStageCfg()
  else
    stageCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)((SectorStageDetailHelper.PlayMoudleType).Ep)
  end
  if not stageCfg then
    return 
  end
  if stageCfg.challengeCfg then
    return 
  end
  local rewardIds = {}
  local rewardNums = {}
  local rewardDic = {}
  if stageCfg.endlessCfg then
    for index,id in pairs((stageCfg.endlessCfg).clear_reward_itemIds) do
      rewardDic[id] = (rewardDic[id] or 0) + ((stageCfg.endlessCfg).clear_reward_itemNums)[index]
    end
  else
    do
      for index,id in pairs(stageCfg.first_reward_ids) do
        rewardDic[id] = (rewardDic[id] or 0) + (stageCfg.first_reward_nums)[index]
      end
      for index,id in pairs(stageCfg.reward_ids) do
        rewardDic[id] = (rewardDic[id] or 0) + (stageCfg.reward_nums)[index]
      end
      do
        for id,num in pairs(rewardDic) do
          (table.insert)(rewardIds, id)
          ;
          (table.insert)(rewardNums, num)
        end
        local crTransDic = PlayerDataCenter:CalCrItemTransDic(rewardIds, rewardNums)
        self.crTransDic = crTransDic
      end
    end
  end
end

ExplorationResultCtrl._TryOpenScore = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if not ExplorationManager:GetIsInWeeklyChallenge() then
    self:_ContinueNextStep()
    return 
  end
  if self.resultMsg == nil or (self.resultMsg).Count < 1 then
    error("can\'t get msg arg0")
    self:_ContinueNextStep()
    return 
  end
  local data = (self.resultMsg)[0]
  if data.scoreShow ~= nil then
    (ExplorationManager:GetDynPlayer()):SetWeekExtrReward(((PlayerDataCenter.allWeeklyChallengeData).ConvetTypeReward2RewadDic)((data.scoreShow).reward))
    ;
    (ExplorationManager:GetDynPlayer()).weekExtrIsDouble = (data.scoreShow).double
    if self.isWin then
      (NetworkManager:GetNetwork(NetworkTypeID.Sector)):CS_WEEKLYCHALLENGE_Detail()
    end
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WCDebuffResult, function(win)
    -- function num : 0_9_0 , upvalues : _ENV, data, self
    if win ~= nil then
      local resultWin = UIManager:GetWindow(UIWindowTypeID.ExplorationResult)
      if resultWin ~= nil then
        resultWin:Hide()
      end
      win:InitWCDebuffResult(data.scoreShow, self.isWin, function()
      -- function num : 0_9_0_0 , upvalues : self
      self:_ContinueNextStep()
    end
)
      if ExplorationManager.epCtrl ~= nil and (ExplorationManager.epCtrl).mapCtrl ~= nil then
        ((ExplorationManager.epCtrl).mapCtrl):HideMapCavasWithoutBg()
      end
    else
      do
        self:_ContinueNextStep()
      end
    end
  end
)
end

ExplorationResultCtrl._TryOpenStoreReward = function(self)
  -- function num : 0_10 , upvalues : _ENV, CommonRewardData
  if self.storeRewardDic == nil or (table.count)(self.storeRewardDic) == 0 then
    self:_ContinueNextStep()
    return 
  end
  local ShowWinFunc = function(window)
    -- function num : 0_10_0 , upvalues : CommonRewardData, self
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(self.storeRewardDic)):SetCRShowOverFunc(function()
      -- function num : 0_10_0_0 , upvalues : self
      self:_ContinueNextStep()
    end
)
    window:AddAndTryShowReward(CRData)
  end

  local rewardWin = UIManager:GetWindow(UIWindowTypeID.CommonReward)
  if rewardWin ~= nil then
    ShowWinFunc(rewardWin)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_10_1 , upvalues : ShowWinFunc
    if window == nil then
      return 
    end
    ShowWinFunc(window)
  end
)
  end
end

ExplorationResultCtrl._TryOpenResult = function(self)
  -- function num : 0_11 , upvalues : _ENV
  (PlayerDataCenter.cacheSaveData):SetIsEndBattleForHeroInteration(true)
  if ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge then
    self:_ContinueNextStep()
    return 
  end
  local data = nil
  if self.resultMsg == nil or (self.resultMsg).Count < 1 then
    data = {}
  else
    data = (self.resultMsg)[0]
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ExplorationResult, function(window)
    -- function num : 0_11_0 , upvalues : self, _ENV, data
    if window == nil then
      return 
    end
    if self.isWin then
      local epModuleId = ExplorationManager:GetEpModuleId()
      local stageId = (ExplorationManager:GetEpDungeonId())
      -- DECOMPILER ERROR at PC12: Overwrote pending register: R3 in 'AssignReg'

      local resultSettlementData = .end
      if ExplorationManager.epCtrl ~= nil then
        resultSettlementData = ((ExplorationManager.epCtrl).dynPlayer):SetResultSettlementData()
      end
      window:SetCRTransDic(self.crTransDic)
      window:CompleteExploration(data.rewards, self.firstRewardDic, nil, resultSettlementData, self.normalRewardDic, self.fixRewardDic)
    else
      do
        window:FailExploration(data.rewards, self.normalRewardDic, data.backStm)
        window:SetReturnCallback(function()
      -- function num : 0_11_0_0 , upvalues : _ENV, self
      UIManager:DeleteWindow(UIWindowTypeID.ExplorationResult, true)
      self:_ContinueNextStep()
    end
)
      end
    end
  end
)
end

ExplorationResultCtrl._ContinueProcessEpExitAfter = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
  if aftertTeatmentCtrl ~= nil then
    aftertTeatmentCtrl:TeatmentBengin()
  end
end

ExplorationResultCtrl._RewardSplit = function(self, epNormalStageId, heroIdSnapShoot)
  -- function num : 0_13 , upvalues : _ENV
  self.firstRewardDic = {}
  self.normalRewardDic = {}
  local StOCareerRewardDic = {}
  local activityExchangeDic = {}
  local newHeroDic = {}
  if self.resultMsg == nil or (self.resultMsg).Count <= 0 then
    return 
  end
  local StOCareerItemIdDic = (ConfigData.game_config).STOCareerCostDic
  local extrAwardDic = {}
  ;
  (table.merge)(extrAwardDic, (ConfigData.activity_time_limit).exchangeMapping)
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  do
    if sectorIICtrl ~= nil then
      local idDic = sectorIICtrl:GetAfterBattleShowItemDic()
      ;
      (table.merge)(extrAwardDic, idDic)
    end
    local AddItemFunc = function(id, count, finalDic, isFirstReward)
    -- function num : 0_13_0 , upvalues : _ENV, heroIdSnapShoot, newHeroDic, StOCareerItemIdDic, StOCareerRewardDic, extrAwardDic, activityExchangeDic
    local dic = nil
    local itemCfg = (ConfigData.item)[id]
    if itemCfg == nil then
      error("can\'t get itemCfg with id " .. tostring(id))
      return 
    end
    do
      if itemCfg.action_type == eItemActionType.HeroCard then
        local heroId = (itemCfg.arg)[1]
        if not heroIdSnapShoot[heroId] then
          newHeroDic[heroId] = true
        end
      end
      if StOCareerItemIdDic[id] ~= nil then
        dic = StOCareerRewardDic
      else
        if not isFirstReward and extrAwardDic[id] then
          dic = activityExchangeDic
        else
          dic = finalDic
        end
      end
      local newCount = dic[id] or 0
      dic[id] = newCount + count
    end
  end

    local data = (self.resultMsg)[0]
    if data.firstClearRewards ~= nil then
      for id,count in pairs(data.firstClearRewards) do
        AddItemFunc(id, count, self.firstRewardDic, true)
      end
    end
    do
      self.fixRewardDic = data.normalRewards
      local challengeQuestRewards = nil
      if data.rewards ~= nil and (data.rewards).rewards ~= nil then
        for id,count in pairs((data.rewards).rewards) do
          AddItemFunc(id, count, self.normalRewardDic, false)
        end
        challengeQuestRewards = (data.rewards).challengeQuestRewards
      end
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
      aftertTeatmentCtrl:AddShowStOCareerReward(StOCareerRewardDic)
      aftertTeatmentCtrl:AddShowReward(activityExchangeDic)
      aftertTeatmentCtrl:SaveSectorId(self.sectorId)
      aftertTeatmentCtrl:AddNewHeroReward(newHeroDic)
      local challengeQuestList = data.challengeQuestIds
      if challengeQuestRewards ~= nil and #challengeQuestList > 0 then
        local fromNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskCompleteNum(epNormalStageId)
        local toNum = fromNum + #challengeQuestList
        local totalNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskNum(epNormalStageId)
        aftertTeatmentCtrl:SetShowChallengeModeReward(challengeQuestRewards, fromNum, toNum, totalNum)
      end
      do
        for k,questId in ipairs(challengeQuestList) do
          (PlayerDataCenter.sectorAchievementDatas):SetChallengeTaskComplete(epNormalStageId, questId)
        end
      end
    end
  end
end

ExplorationResultCtrl._ContinueNextStep = function(self, isFirst)
  -- function num : 0_14
  if isFirst then
    self.currentProcess = 0
    self.isExecutedBattleEndClear = false
  end
  self.currentProcess = self.currentProcess + 1
  if #self.processTable < self.currentProcess then
    return 
  end
  ;
  ((self.processTable)[self.currentProcess])()
end

return ExplorationResultCtrl

