-- params : ...
-- function num : 0 , upvalues : _ENV
local UIExplorationResult = class("UIExplorationResult", UIBaseWindow)
local base = UIBaseWindow
local JumpManager = require("Game.Jump.JumpManager")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local EpCommonUtil = require("Game.Exploration.Util.EpCommonUtil")
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local cs_DoTween = ((CS.DG).Tweening).DOTween
local HeroData = require("Game.PlayerData.Hero.HeroData")
local SectorEnum = require("Game.Sector.SectorEnum")
UIExplorationResult.EpResultType = {None = 0, CompleteEp = 1, CompleteEpFloor = 2, Fail = 3}
UIExplorationResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINBaseItemWithCount, UIExplorationResult
  if not self.SettedTopStatus then
    (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
    self.SettedTopStatus = true
  end
  self.sectorNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  self.isWin = false
  self.rewardsRecord = {}
  self.rewardList = {}
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.OnReturnClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Again, self, self.OnRestartClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Detail, self, self.ShowAllChips)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ViewAllReward, self, self.ShowAllItems)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GoNext, self, self.OnGoNextBtnClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exit, self, self.OnExitBtnClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_FailGetReward, self, self.OnBtnFailGetReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GiveUp, self, self.OnBtnFailGiveUp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SuccessSettle, self, self.OnBtnSuccessSettle)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem1, self, self.OnClickJump2DefeatAdvise, 1)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem2, self, self.OnClickJump2DefeatAdvise, 2)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recomme, self, self.OnClickRecomme)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AutoModule, self, self.__OnClickRestartAuto)
  ;
  (((self.ui).btn_Again).gameObject):SetActive(false)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem)
  ;
  (((self.ui).rewardItem).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(false)
  self.__epResultType = (UIExplorationResult.EpResultType).None
  ;
  ((self.ui).tex_noReward):SetIndex(0)
end

UIExplorationResult.IsEpResultType = function(self, resultType)
  -- function num : 0_1
  do return self.__epResultType == resultType end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIExplorationResult.SetReturnCallback = function(self, callback)
  -- function num : 0_2
  self.returnCallback = callback
end

UIExplorationResult.CompleteExploration = function(self, rewards, firstClearRewards, needFirsPassReward, resultSettlementData, rewardDic, fixRewardDic)
  -- function num : 0_3 , upvalues : _ENV, UIExplorationResult
  AudioManager:PlayAudioById(3009)
  if not rewardDic then
    self.rewardsRecord = {}
    if not (ExplorationManager:GetDynPlayer()):GetWeekExtrReward() then
      local weekExtrReward = table.emptytable
    end
    ;
    (table.merge)(self.rewardsRecord, weekExtrReward)
    self.__isWCDouble = (ExplorationManager:GetDynPlayer()).weekExtrIsDouble
    self.__epResultType = (UIExplorationResult.EpResultType).CompleteEp
    self.__enableAutoMode = false
    if not rewards then
      self.backRewards = {}
      self.firstClearRewards = firstClearRewards
      self.fixRewardDic = fixRewardDic
      self.isWin = true
      self.resultSettlementData = resultSettlementData
      self:UpdataResultsUI(self.isWin, false, needFirsPassReward)
      self:__PopAddFriend()
    end
  end
end

UIExplorationResult.CompleteExplorationFloor = function(self)
  -- function num : 0_4 , upvalues : _ENV, UIExplorationResult
  if ExplorationManager:HasEpRewardBag() then
    self.rewardsRecord = ((ExplorationManager:GetDynPlayer()).dynRewardBag):GetEpRewardBagDataDic()
  else
    self.rewardsRecord = (ExplorationManager:GetDynPlayer()):GetEpRewardItemDic()
  end
  self.__epResultType = (UIExplorationResult.EpResultType).CompleteEpFloor
  self.backRewards = {eplGold = (ExplorationManager:GetDynPlayer()):GetMoneyCount()}
  self.isWin = true
  self:UpdataResultsUI(self.isWin, true)
end

UIExplorationResult.FailExploration = function(self, rewards, rewardDic, returnStamina)
  -- function num : 0_5 , upvalues : _ENV, UIExplorationResult
  AudioManager:PlayAudioById(3010)
  if not rewardDic then
    self.rewardsRecord = {}
    if not (ExplorationManager:GetDynPlayer()):GetWeekExtrReward() then
      local weekExtrReward = table.emptytable
    end
    ;
    (table.merge)(self.rewardsRecord, weekExtrReward)
    self.__epResultType = (UIExplorationResult.EpResultType).Fail
    if not rewards then
      self.backRewards = {}
      self.isWin = false
      self._returnStamina = returnStamina
      self:UpdataResultsUI(self.isWin)
      local returnStamina, remainLevelCount, costStamina = ExplorationManager:GetReturnStamina()
      ;
      ((self.ui).tex_RePoint):SetIndex(0, tostring(returnStamina))
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_AgainPoint).text = tostring(costStamina)
      GuideManager:TryTriggerGuide(eGuideCondition.InEpResultFail)
      self:__PopAddFriend()
      self:__RefreshDefeatJump()
    end
  end
end

UIExplorationResult.__PopAddFriend = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if ExplorationManager.astAv ~= nil and (PlayerDataCenter.friendDataCenter):TryGetFriendData((ExplorationManager.astAv).uid) == nil and not (PlayerDataCenter.friendDataCenter):GetIsFriendFull() then
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageSideAddFriend, function(window)
    -- function num : 0_6_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitAddHeroSide((ExplorationManager.astAv).uid, self.resloader)
  end
)
  end
end

UIExplorationResult.BackAction = function(self)
  -- function num : 0_7
  if ((self.ui).btn_Return).isActiveAndEnabled then
    self.SettedTopStatus = false
    if self.isWin then
      self:__AfterSettleWin()
    else
      if self.returnCallback ~= nil then
        (self.returnCallback)()
      end
    end
    return 
  else
    if ((self.ui).btn_SuccessSettle).isActiveAndEnabled then
      self.SettedTopStatus = false
      self:OnBtnSuccessSettle()
      return 
    else
      if ((self.ui).btn_GoNext).isActiveAndEnabled then
        self.SettedTopStatus = false
        self:OnGoNextBtnClicked()
        return 
      end
    end
  end
  return false
end

UIExplorationResult.OnReturnClicked = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.SettedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UIExplorationResult.OnRestartClicked = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon, JumpManager
  local moduleId = ExplorationManager:GetEpModuleId()
  local stageCfg = ExplorationManager:GetSectorStageCfg()
  local againCostStamina = stageCfg.cost_strength_num
  if not (PlayerDataCenter.sectorEntranceHandler):CheckSectorValid(ExplorationManager:GetEpSectorId()) then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(6033))
    return 
  end
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration and (PlayerDataCenter.stamina):GetCurrentStamina() < againCostStamina then
    JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
    return 
  else
    if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Endless and (PlayerDataCenter.infinityData):IsInfinityDungeonCompleted(stageCfg.dungeonId) and (PlayerDataCenter.stamina):GetCurrentStamina() < againCostStamina then
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
      return 
    end
  end
  ;
  (ExplorationManager.resultCtrl):ExecuteBattleEndClear()
  ExplorationManager:RestartExploratcion(self.__enableAutoMode)
end

UIExplorationResult.OnGoNextBtnClicked = function(self)
  -- function num : 0_10 , upvalues : _ENV
  ExplorationManager:EnterNextSectionExploration()
end

UIExplorationResult.OnExitBtnClicked = function(self)
  -- function num : 0_11
end

UIExplorationResult.EpFailNoReward = function(self)
  -- function num : 0_12
end

UIExplorationResult.OnBtnFailGetReward = function(self)
  -- function num : 0_13
  if self.returnCallback ~= nil then
    (self.returnCallback)()
  end
end

UIExplorationResult.OnBtnFailGiveUp = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local returnStamina, _, costStamina = ExplorationManager:GetReturnStamina()
  if costStamina == 0 then
    if self.returnCallback ~= nil then
      (self.returnCallback)()
    end
    return 
  end
  local msg = nil
  if returnStamina == 0 then
    msg = ConfigData:GetTipContent(TipContent.exploration_Player_ExitExpo)
  else
    msg = (string.format)(ConfigData:GetTipContent(TipContent.exploration_Player_ExitExpoWithStaminaBack), returnStamina)
  end
  ;
  ((CS.MessageCommon).ShowMessageBox)(msg, function()
    -- function num : 0_14_0 , upvalues : self
    if self.returnCallback ~= nil then
      (self.returnCallback)()
    end
  end
, nil, false)
end

UIExplorationResult.OnBtnSuccessSettle = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if ExplorationManager:HasEpRewardBag() then
    if self.isWin then
      self:__AfterSettleWin()
    else
      if self.returnCallback ~= nil then
        (self.returnCallback)()
      end
    end
    self:Delete()
  else
    if ExplorationManager:GetIsInWeeklyChallenge() then
      if self.isWin then
        self:__AfterSettleWin()
      else
        self:Delete()
        if self.returnCallback ~= nil then
          (self.returnCallback)()
        end
      end
    else
      if self.isWin then
        self:__AfterSettleWin()
      else
        if self.returnCallback ~= nil then
          (self.returnCallback)()
        end
      end
      self:Delete()
    end
  end
end

UIExplorationResult.__OnClickRestartAuto = function(self)
  -- function num : 0_16
  self.__enableAutoMode = not self.__enableAutoMode
  ;
  ((self.ui).tex_AutoON):SetActive(self.__enableAutoMode)
  ;
  ((self.ui).tex_AutoOFF):SetActive(not self.__enableAutoMode)
  ;
  ((self.ui).img_AudoSelect):SetIndex(self.__enableAutoMode and 1 or 0)
end

UIExplorationResult.__ResetAllResultGroup = function(self)
  -- function num : 0_17
  ((self.ui).normalBtnGroup):SetActive(false)
  ;
  ((self.ui).overBtnGroup):SetActive(false)
  ;
  ((self.ui).failureBtnGroup):SetActive(false)
end

UIExplorationResult.ShowWCTokenTip = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if not ExplorationManager:GetIsInWeeklyChallenge() then
    return 
  end
  local rewardDic = (ExplorationManager:GetDynPlayer()):GetWeekExtrReward()
  if rewardDic ~= nil and (table.count)(rewardDic) > 0 then
    return 
  end
  ;
  ((self.ui).noReward):SetActive(true)
  ;
  ((self.ui).tex_noReward):SetIndex(0)
end

UIExplorationResult.UpdataResultsUI = function(self, isWin, isFloor, needFirsPassReward)
  -- function num : 0_19 , upvalues : _ENV, EpCommonUtil
  local resultBG_Material = ((self.ui).img_ResultBG).material
  local hasEpRewardBag = ExplorationManager:HasEpRewardBag()
  self:__ResetAllResultGroup()
  if not isFloor then
    isFloor = false
  end
  if isWin then
    AudioManager:PlayAudioById(1003)
    ;
    ((self.ui).img_ResultState):SetIndex(0)
    ;
    ((self.ui).tex_ResultState):SetIndex(0)
    ;
    ((self.ui).vectoryNode):SetActive(true)
    ;
    ((self.ui).failureNode):SetActive(false)
    resultBG_Material:SetFloat("_Decoloration", 0)
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_ResultBG).color = (self.ui).col_Success
    if (EpCommonUtil.IsSupportEpRestart)() then
      local stageCfg = ExplorationManager:GetSectorStageCfg()
      local againCostStamina = stageCfg.cost_strength_num
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_AgainPoint).text = tostring(againCostStamina)
      ;
      (((self.ui).btn_Again).gameObject):SetActive(true)
      local supportAutoMode = (EpCommonUtil.IsSupportEpAutoMode)()
      if supportAutoMode then
        (((self.ui).btn_AutoModule).gameObject):SetActive(true)
        self:__OnClickRestartAuto()
      end
    end
  else
    do
      AudioManager:PlayAudioById(1004)
      ;
      ((self.ui).img_ResultState):SetIndex(1)
      ;
      ((self.ui).tex_ResultState):SetIndex(1)
      ;
      ((self.ui).vectoryNode):SetActive(false)
      ;
      ((self.ui).failureNode):SetActive(true)
      resultBG_Material:SetFloat("_Decoloration", 1)
      ;
      ((self.ui).suggestBtn):SetActive(true)
      ;
      ((self.ui).suggestTips):SetActive(false)
      do
        local battleFailJumpUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleFailJump)
        if not battleFailJumpUnlock then
          (((self.ui).failureNode).gameObject):SetActive(false)
        end
        ;
        (((((self.ui).tex_CurLevelLayer).transform).parent).gameObject):SetActive(isFloor)
        if isFloor then
          ((self.ui).overBtnGroup):SetActive(true)
          ;
          ((self.ui).tex_CurLevelLayer):SetIndex(0, tostring(ExplorationManager:GetCurLevelIndex() + 1))
          ;
          ((self.ui).tex_ResultState):SetIndex(2)
          resultBG_Material:SetFloat("_Decoloration", 0)
          -- DECOMPILER ERROR at PC169: Confused about usage of register: R6 in 'UnsetPending'

          ;
          ((self.ui).img_ResultBG).color = (self.ui).col_Over
        end
        ;
        (((self.ui).tex_LevelName).gameObject):SetActive(not isFloor)
        if not isFloor then
          local sectorStageCfg = ExplorationManager:GetSectorStageCfg()
          if sectorStageCfg ~= nil then
            local msg = nil
            if sectorStageCfg.endlessCfg ~= nil then
              msg = ConfigData:GetEndlessInfoMsg(sectorStageCfg.endlessCfg, (sectorStageCfg.endlessCfg).index * 10)
            else
              if sectorStageCfg.challengeCfg ~= nil then
                local moduleId = ExplorationManager:GetEpModuleId()
                msg = ConfigData:GetChallengeInfoMsg(moduleId)
              else
                do
                  do
                    msg = ConfigData:GetSectorInfoMsg(sectorStageCfg.sector, sectorStageCfg.num, sectorStageCfg.difficulty)
                    -- DECOMPILER ERROR at PC217: Confused about usage of register: R8 in 'UnsetPending'

                    ;
                    ((self.ui).tex_LevelCount).text = msg
                    -- DECOMPILER ERROR at PC224: Confused about usage of register: R8 in 'UnsetPending'

                    ;
                    ((self.ui).tex_LevelName).text = (LanguageUtil.GetLocaleText)(sectorStageCfg.name)
                    self:ShowReward(isWin, isFloor, needFirsPassReward)
                    self:ShowChip()
                    self:ShowCoin()
                    self:ShowPowerIncrease()
                    self:ShowMVP()
                    self:ShowGBack()
                    if (not self._returnStamina and isFloor or 0 == 0) or isWin then
                      ((self.ui).failureBtnGroup):SetActive(false)
                      if #self.rewardList <= 0 then
                        local hasReward = not hasEpRewardBag
                        ;
                        ((self.ui).normalBtnGroup):SetActive(true)
                        ;
                        (((self.ui).btn_SuccessSettle).gameObject):SetActive(hasReward)
                        ;
                        (((self.ui).btn_Return).gameObject):SetActive(not hasReward)
                        ;
                        ((self.ui).noReward):SetActive(not hasReward)
                        ;
                        ((self.ui).rewardTips):SetActive(hasReward)
                        local dropList = ((ExplorationManager:GetDynPlayer()).dynRewardBag):GetEpRewardBagDataList()
                        do
                          local hasEpBagDrop = dropList ~= nil and #dropList > 0
                          ;
                          ((self.ui).tex_noReward):SetIndex(hasEpBagDrop and 1 or 0)
                          ;
                          ((self.ui).normalBtnGroup):SetActive(true)
                          ;
                          ((self.ui).failureBtnGroup):SetActive(true)
                          -- DECOMPILER ERROR at PC330: Confused about usage of register: R6 in 'UnsetPending'

                          ;
                          ((self.ui).tex_GetRewardPoint).text = tostring(self._returnStamina)
                          -- DECOMPILER ERROR at PC336: Confused about usage of register: R6 in 'UnsetPending'

                          ;
                          ((self.ui).tex_RetreatPoint).text = tostring(self._returnStamina)
                          self:ShowWCTokenTip()
                          -- DECOMPILER ERROR: 8 unprocessed JMP targets
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

UIExplorationResult.IsCanShowAth = function(self)
  -- function num : 0_20 , upvalues : _ENV
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm)
end

UIExplorationResult.UpdateAthReward = function(self)
  -- function num : 0_21 , upvalues : _ENV
  do
    if PlayerDataCenter.lastAthDiff ~= nil then
      local athIndex = 0
      for i = 1, #self.rewardList do
        local item = (self.rewardList)[i]
        local isAthItem = (item.itemCfg).type == eItemType.Arithmetic or ((ConfigData.item).athGiftDic)[(item.itemCfg).id] ~= nil
        if isAthItem then
          athIndex = athIndex + 1
          local ath = (PlayerDataCenter.lastAthDiff)[athIndex]
          if ath ~= nil then
            item = {num = 1, itemCfg = ath.itemCfg, isAth = true, ath = athData}
            -- DECOMPILER ERROR at PC45: Confused about usage of register: R9 in 'UnsetPending'

            ;
            (self.rewardList)[i] = item
            ;
            (table.remove)(PlayerDataCenter.lastAthDiff, #PlayerDataCenter.lastAthDiff)
          end
        end
      end
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R2 in 'UnsetPending'

      PlayerDataCenter.lastAthDiff = nil
      ExplorationManager:RewardSort(self.rewardList)
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIExplorationResult.SetCRTransDic = function(self, tranDic)
  -- function num : 0_22
  self.crTransDic = tranDic
end

UIExplorationResult.ShowReward = function(self, isWin, isFloor, needFirsPassReward)
  -- function num : 0_23 , upvalues : _ENV, cs_DoTween, cs_MessageCommon
  local isShowAth = self:IsCanShowAth()
  self.rewardList = {}
  local hasRandomAth = false
  local items = {}
  local addItem = function(itemId, num)
    -- function num : 0_23_0 , upvalues : _ENV, isFloor, hasRandomAth, isShowAth, items
    local itemCfg = (ConfigData.item)[itemId]
    local hasAth = ConfigData:IsRewardNotShowATH(itemCfg)
    if hasAth and not isFloor and PlayerDataCenter.lastAthDiff ~= nil then
      hasRandomAth = true
      return 
    end
    -- DECOMPILER ERROR at PC29: Unhandled construct in 'MakeBoolean' P1

    if (not hasAth or isShowAth) and items[itemId] ~= nil then
      items[itemId] = items[itemId] + num
    else
      items[itemId] = num
    end
  end

  for itemId,num in pairs(self.rewardsRecord) do
    do
      addItem(itemId, num)
    end
  end
  if self.firstClearRewards ~= nil then
    do
      for itemId,num in pairs(self.firstClearRewards) do
        addItem(itemId, num)
      end
    end
  end
  do
    if self.fixRewardDic ~= nil then
      for itemId,num in pairs(self.fixRewardDic) do
        addItem(itemId, num)
      end
    end
    do
      for itemId,itemNum in pairs(items) do
        local itemCfg = (ConfigData.item)[itemId]
        if itemCfg == nil then
          error("can\'t get itemCfg with id=" .. tostring(itemId))
        end
        ;
        (table.insert)(self.rewardList, {num = itemNum, itemCfg = itemCfg})
      end
      if hasRandomAth and not isFloor then
        if PlayerDataCenter.lastAthDiff ~= nil then
          for _,athData in ipairs(PlayerDataCenter.lastAthDiff) do
            (table.insert)(self.rewardList, {num = 1, itemCfg = athData.itemCfg, isAth = true, athData = athData})
          end
        end
        do
          -- DECOMPILER ERROR at PC94: Confused about usage of register: R8 in 'UnsetPending'

          PlayerDataCenter.lastAthDiff = nil
          ExplorationManager:RewardSort(self.rewardList)
          local containAth = false
          for k,v in ipairs(self.rewardList) do
            if not containAth and (v.itemCfg).type == eItemType.Arithmetic then
              containAth = true
            end
            local rewardItem = (self.rewardItemPool):GetOne()
            ;
            ((rewardItem.ui).obj_isDouble):SetActive(self.__isWCDouble)
            local num = 0
            num = not self.crTransDic or (self.crTransDic)[(v.itemCfg).id] or 0
            if (v.itemCfg).overflow_type == eItemTransType.actMoneyX then
              num = PlayerDataCenter:GetItemOverflowNum((v.itemCfg).id, v.num)
            end
            do
              do
                if num ~= 0 then
                  local trans_id, trans_num = nil, nil
                  if not (#(v.itemCfg).overflow_para % 2) == 0 then
                    error("this overflow type has error para")
                  end
                  trans_id = (ConfigData.item)[((v.itemCfg).overflow_para)[1]]
                  trans_num = ((v.itemCfg).overflow_para)[2] * num
                  v.itemCfg = trans_id
                  v.num = trans_num
                end
                rewardItem:InitItemWithCount(v.itemCfg, v.num, function()
    -- function num : 0_23_1 , upvalues : _ENV, self, k
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_23_1_0 , upvalues : self, k
      if win ~= nil then
        win:InitListDetail(self.rewardList, k)
      end
    end
)
  end
)
                -- DECOMPILER ERROR at PC177: LeaveBlock: unexpected jumping out DO_STMT

              end
            end
          end
          ;
          ((self.ui).noReward):SetActive(#self.rewardList == 0)
          local rewardSequence = (cs_DoTween.Sequence)()
          for index,item in ipairs((self.rewardItemPool).listItem) do
            item:SetFade(0)
            rewardSequence:AppendCallback(function()
    -- function num : 0_23_2 , upvalues : _ENV, item, self
    if ((ConfigData.game_config).itemWithGreatFxDic)[(item.itemCfg).id] then
      item:LoadGetGreatRewardFx(self.resloader, 5)
    else
      item:LoadGetRewardFx(self.resloader, 5)
    end
  end
)
            rewardSequence:Append(((item:GetFade()):DOFade(1, 0.15)):SetLink(item.gameObject))
          end
          rewardSequence:SetDelay(0.15)
          rewardSequence:Play()
          if self.rewardSequence ~= nil then
            (self.rewardSequence):Kill()
          end
          self.rewardSequence = rewardSequence
          if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
            (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
          end
          -- DECOMPILER ERROR: 4 unprocessed JMP targets
        end
      end
    end
  end
end

UIExplorationResult.ShowChip = function(self)
  -- function num : 0_24 , upvalues : _ENV
  self.chipList = ((ExplorationManager.epCtrl).dynPlayer):GetChipList()
  local chipNum = 0
  for _,chipData in ipairs(self.chipList) do
    chipNum = chipNum + chipData:GetCount()
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ChipCount).text = tostring(chipNum)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  if chipNum <= 0 then
    ((self.ui).btn_Detail).interactable = false
  else
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_Detail).interactable = true
  end
end

UIExplorationResult.ShowCoin = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local CCNum = (ExplorationManager:GetDynPlayer()):GetMoneyCount()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_MoneyCount).text = tostring(CCNum)
end

UIExplorationResult.ShowPowerIncrease = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local newPower = ((ExplorationManager.epCtrl).dynPlayer):GetTotalFightingPower(true, false)
  local oldPower = ((ExplorationManager.epCtrl).dynPlayer):GetMirrorTeamFightPower(true, false) or 1
  local increase = (newPower / oldPower - 1) * 100
  if increase <= 0 or not increase then
    increase = 0
  end
  ;
  ((self.ui).tex_BuffRate):SetIndex(0, GetPreciseDecimalStr(increase, 0))
end

UIExplorationResult.ShowMVP = function(self)
  -- function num : 0_27 , upvalues : _ENV, HeroData
  if not self.isWin then
    return 
  end
  if self:_ShowEpSpecialMvp() then
    return 
  end
  if ExplorationManager.epMvpData ~= nil then
    local heroId, MvpType, diggestRate = (ExplorationManager.epMvpData):GetEpMvpData()
    local heroData = ((ExplorationManager:GetDynPlayer()).heroDic)[heroId]
    do
      if heroData == nil then
        local heroCfg = (ConfigData.hero_data)[heroId]
        heroData = (HeroData.New)({
basic = {id = heroId, level = 1, exp = 0, star = heroCfg.rank, potentialLvl = 0, ts = -1, career = heroCfg.career, company = heroCfg.camp}
})
      end
      ExplorationManager:PlayMVPVoice(heroId)
      ;
      ((self.ui).tex_MvpType):SetIndex(MvpType)
      ;
      ((self.ui).tex_Rate):SetIndex(0, GetPreciseDecimalStr(diggestRate * 100, 0))
      self:_LoadMvpPic(heroData:GetResPicName())
    end
  end
end

UIExplorationResult._ShowEpSpecialMvp = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local epId = ExplorationManager:GetCurExplorationId()
  local epMvpSpecialCfg = (ConfigData.ep_mvp_special)[epId]
  if epMvpSpecialCfg == nil then
    return false
  end
  ;
  ((self.ui).obj_mvpInfo):SetActive(false)
  self:_LoadMvpPic(epMvpSpecialCfg.lpic)
  return true
end

UIExplorationResult._LoadMvpPic = function(self, resPicName)
  -- function num : 0_29 , upvalues : cs_ResLoader, _ENV
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
  end
  self.bigImgResloader = (cs_ResLoader.Create)()
  ;
  (self.bigImgResloader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(resPicName), function(prefab)
    -- function num : 0_29_0 , upvalues : _ENV, self
    DestroyUnityObject(self.bigImgGameObject)
    self.bigImgGameObject = prefab:Instantiate((self.ui).heroBigImgNode)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroList")
  end
)
end

UIExplorationResult.ShowAllChips = function(self)
  -- function num : 0_30 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ViewChips, function(windows)
    -- function num : 0_30_0 , upvalues : self
    if windows ~= nil then
      self.viewAllChipWin = windows
      if self.chipList ~= nil then
        windows:InitChips(self.chipList, self.resloader)
      end
    end
  end
)
end

UIExplorationResult.ShowAllItems = function(self)
  -- function num : 0_31 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ViewItems, function(windows)
    -- function num : 0_31_0 , upvalues : self
    if windows ~= nil then
      self.viewAllItemWin = windows
      windows:InitItems(self.rewardList, self.resloader)
    end
  end
)
end

UIExplorationResult.ShowGBack = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local convertItemId = (ConfigData.game_config).epMoneyConvert
  local convertMoney = (self.backRewards).exByte or 0
  do
    if convertMoney > 0 then
      local itemCfg = (ConfigData.item)[convertItemId]
      -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

      if itemCfg ~= nil then
        ((self.ui).img_BackItemIcom).sprite = CRH:GetSprite(itemCfg.small_icon)
        -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).Tex_BackCount).text = "+" .. tostring(convertMoney)
        ;
        ((self.ui).resTransformation):SetActive(true)
        return 
      end
    end
    ;
    ((self.ui).resTransformation):SetActive(false)
  end
end

UIExplorationResult.__RefreshDefeatJump = function(self)
  -- function num : 0_33 , upvalues : _ENV
  local list = table.emptytable
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if sectorIICtrl ~= nil then
    local stageCfg = ExplorationManager:GetSectorStageCfg()
    if stageCfg ~= nil then
      local sectorId = stageCfg.sector
      local sectorIIData = sectorIICtrl:GetSectorIIDataBySectorId(sectorId)
      if sectorIIData ~= nil then
        list = sectorIIData:GetBeDefeatJumpList()
      end
    end
  end
  do
    local cfg1 = (ConfigData.defeat_jump)[list[1] or 1]
    local cfg2 = (ConfigData.defeat_jump)[list[2] or 2]
    self.__defeatJumpCfgList = {cfg1, cfg2}
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem2).enabled = false
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem1).enabled = false
    ;
    (self.resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("ExplorationResultFailures"), function(spriteAtlas)
    -- function num : 0_33_0 , upvalues : _ENV, self, cfg1, cfg2
    if spriteAtlas == nil then
      return 
    end
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem1).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, cfg1.pic_path)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem2).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, cfg2.pic_path)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem2).enabled = true
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem1).enabled = true
  end
)
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).text_GotoItem1).text = (LanguageUtil.GetLocaleText)(cfg1.des)
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).text_GotoItem2).text = (LanguageUtil.GetLocaleText)(cfg2.des)
  end
end

UIExplorationResult.OnClickJump2DefeatAdvise = function(self, typeIndex)
  -- function num : 0_34 , upvalues : _ENV, JumpManager
  (ExplorationManager.resultCtrl):ExecuteBattleEndClear()
  ExplorationManager:ExitExploration((Consts.SceneName).Main, function()
    -- function num : 0_34_0 , upvalues : self, typeIndex, _ENV, JumpManager
    local defeatJumpCfg = (self.__defeatJumpCfgList)[typeIndex]
    if defeatJumpCfg == nil then
      error("defeatJumpCfg is nil with index " .. tostring(typeIndex))
      return 
    end
    local jumpId = defeatJumpCfg.jump_id
    local jumpArg = defeatJumpCfg.jump_arg
    JumpManager:Jump(jumpId, nil, function()
      -- function num : 0_34_0_0 , upvalues : _ENV
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
      if aftertTeatmentCtrl ~= nil then
        aftertTeatmentCtrl:TeatmentBengin()
      end
    end
, jumpArg)
  end
)
end

UIExplorationResult.OnClickRecomme = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local recommeCtr = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  recommeCtr:ReqRecommeFormationNew(self:GetDungeonId(), false)
end

UIExplorationResult.GetDungeonId = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local dungeonId = nil
  local moduleId = ExplorationManager:GetEpModuleId()
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
    dungeonId = (ExplorationManager.stageCfg).id
  else
    if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Endless then
      dungeonId = (ExplorationManager.stageCfg).dungeonId
    end
  end
  return dungeonId
end

UIExplorationResult.__AfterSettleWin = function(self)
  -- function num : 0_37 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  avgPlayCtrl:TryPlayTaskAvg(2, function()
    -- function num : 0_37_0 , upvalues : self
    if self.returnCallback ~= nil then
      (self.returnCallback)()
    end
  end
)
end

UIExplorationResult.OnDelete = function(self)
  -- function num : 0_38 , upvalues : _ENV, base
  if self.SettedTopStatus then
    self.SettedTopStatus = false
    ;
    (UIUtil.PopFromBackStack)()
  end
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if self.viewAllChipWin ~= nil then
    (self.viewAllChipWin):Delete()
  end
  if self.viewAllItemWin ~= nil then
    (self.viewAllItemWin):Delete()
  end
  if self.rewardSequence ~= nil then
    (self.rewardSequence):Kill()
    self.rewardSequence = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIExplorationResult

