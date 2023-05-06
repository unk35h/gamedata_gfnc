-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonResult = class("UIDungeonResult", UIBaseWindow)
local base = UIBaseWindow
local ItemData = require("Game.PlayerData.Item.ItemData")
local UIRewardItem = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UICharacterItem = require("Game.BattleResult.UIBattleResultCharacterItem")
local UIBattleSkadaPage = require("Game.BattleResult.Skada.UIBattleSkadaPage")
local UINBtResultWinterChallenge = require("Game.BattleDungeon.UI.WinterChallenge.UINBtResultWinterChallenge")
local UINResultCompleteNode = require("Game.BattleResult.UINResultCompleteNode")
local cs_BattleStatistics = (CS.BattleStatistics).Instance
local cs_GameObject = (CS.UnityEngine).GameObject
local cs_DOTween = ((CS.DG).Tweening).DOTween
local cs_MessageCommon = CS.MessageCommon
local DungeonTypeData = require("Game.Dungeon.DungeonTypeData")
UIDungeonResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIRewardItem, UICharacterItem, UINResultCompleteNode
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  self.rewardItemPool = (UIItemPool.New)(UIRewardItem, (self.ui).obj_rewardItem)
  self.heroHeadItemPool = (UIItemPool.New)(UICharacterItem, (self.ui).obj_heroHeadItem)
  ;
  (((self.ui).tex_levelName).gameObject):SetActive(false)
  if not (BattleUtil.IsInTDBattle)() then
    (((self.ui).btn_skada).gameObject):SetActive(true)
    ;
    (UIUtil.AddButtonListener)((self.ui).btn_skada, self, self.__OnBtnSkadaClick)
  else
    ;
    (((self.ui).btn_skada).gameObject):SetActive(false)
  end
  ;
  ((self.ui).obj_rewardItem):SetActive(false)
  ;
  ((self.ui).obj_heroHeadItem):SetActive(false)
  ;
  ((self.ui).obj_userSkillNode):SetActive(false)
  ;
  ((self.ui).obj_globalExpNode):SetActive(false)
  ;
  ((self.ui).tex_PlayAgainWinChallenge):SetIndex(0)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PlayAgain, self, self.__OnBtnPlayerAgainClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PlayAgainWinChallenge, self, self._OnClickWinClgPlayAgan)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self._OnClickWinClgBack)
  self.__updateHandle = BindCallback(self, self.Update)
  UpdateManager:AddUpdate(self.__updateHandle)
  self.__playAnim = BindCallback(self, self.StartExpAnimation)
  MsgCenter:AddListener(eMsgEventId.OnShowBattleResultComplete, self.__playAnim)
  self:__ToFackCameraCanvas()
  ;
  ((self.ui).resultBtnGroup):SetActive(true)
  ;
  ((self.ui).battleAutoNode):SetActive(false)
  self.__OnScreenSizeChanged = BindCallback(self, self.__ToFackCameraCanvas)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  self._completeNodePool = (UIItemPool.New)(UINResultCompleteNode, (self.ui).completeTime)
  ;
  ((self.ui).completeTime):SetActive(false)
end

UIDungeonResult.__ToFackCameraCanvas = function(self)
  -- function num : 0_1 , upvalues : cs_GameObject, _ENV
  local fakeCameraBattle = ((cs_GameObject.Find)("FakeCameraBattle")):FindComponent(eUnityComponentID.Camera)
  local epMapCamera = (((BattleDungeonManager.dungeonCtrl).sceneCtrl).bind).epMapCamera
  fakeCameraBattle.enabled = true
  fakeCameraBattle.enabled = false
  self:AlignToFakeCamera(fakeCameraBattle, epMapCamera)
end

UIDungeonResult.CompleteDungeon = function(self, isGuide, rewardMsg, rewards, resultData, mvpGrade, dungeonType)
  -- function num : 0_2 , upvalues : _ENV
  self.resultData = resultData
  if isGuide then
    ((self.ui).obj_textContinue):SetActive(true)
    ;
    (((self.ui).btn_PlayAgain).gameObject):SetActive(false)
    ;
    (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnBtnContinueClick)
  else
    ;
    (((self.ui).btn_continue).gameObject):SetActive(true)
    ;
    (UIUtil.AddButtonListener)((self.ui).btn_continue, self, self.__OnBtnContinueClick)
  end
  ;
  ((self.ui).obj_heroHeadNode):SetActive(not isGuide)
  self._auBack = AudioManager:PlayAudioById(3009, function()
    -- function num : 0_2_0 , upvalues : self
    self._auBack = nil
  end
)
  local rewardList = {}
  self.dungeonType = dungeonType
  do
    if rewardMsg ~= nil then
      local exp = rewardMsg.totalExp
      self.heroIntimacy = rewardMsg.heroIntimacy
    end
    self:_mergeReward(rewardList, rewards)
    self:__InitBattleReward(rewardList, rewardMsg.getATH)
    self:__InitCharacterExp(resultData.lastHeroList)
    self:__InitMvpHeroPic(resultData.playerRoleList, mvpGrade)
    if (BattleDungeonManager.dungeonCtrl).enterMsgData ~= nil and ((BattleDungeonManager.dungeonCtrl).enterMsgData).ab ~= nil and (PlayerDataCenter.friendDataCenter):TryGetFriendData((((BattleDungeonManager.dungeonCtrl).enterMsgData).ab).uid) == nil and not (PlayerDataCenter.friendDataCenter):GetIsFriendFull() then
      UIManager:ShowWindowAsync(UIWindowTypeID.MessageSideAddFriend, function(window)
    -- function num : 0_2_1 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitAddHeroSide((((BattleDungeonManager.dungeonCtrl).enterMsgData).ab).uid, self.resloader)
  end
)
    end
  end
end

UIDungeonResult.InitDailyDgResult = function(self, isLastDungeon, enterNextLevelFunc)
  -- function num : 0_3
  self._enterNextLevelFunc = enterNextLevelFunc
  self._isLastDungeon = isLastDungeon
  ;
  ((self.ui).obj_WinterChallengeBtnGroup):SetActive(not isLastDungeon)
  ;
  ((self.ui).resultBtnGroup):SetActive(isLastDungeon)
  ;
  ((self.ui).obj_tex_BackInfo):SetActive(false)
end

UIDungeonResult.InitWinterChallengeDgResult = function(self, scoreAdd, scoreAll, isLastDungeon, enterNextLevelFunc)
  -- function num : 0_4 , upvalues : UINBtResultWinterChallenge
  self._enterNextLevelFunc = enterNextLevelFunc
  self._isLastDungeon = isLastDungeon
  ;
  ((self.ui).resultBtnGroup):SetActive(false)
  ;
  ((self.ui).rewardLayout):SetActive(false)
  ;
  ((self.ui).obj_WinterChallengeBtnGroup):SetActive(true)
  ;
  ((self.ui).winterChallengeNode):SetActive(true)
  ;
  (((self.ui).btn_Back).gameObject):SetActive(not isLastDungeon)
  ;
  ((self.ui).tex_PlayAgainWinChallenge):SetIndex(isLastDungeon and 1 or 0)
  local winChallengeNode = (UINBtResultWinterChallenge.New)()
  winChallengeNode:Init((self.ui).winterChallengeNode)
  winChallengeNode:InitBtResultWinterChallenge(scoreAdd, scoreAll)
  self.winChallengeNode = winChallengeNode
end

UIDungeonResult._OnClickWinClgPlayAgan = function(self)
  -- function num : 0_5
  if self._isLastDungeon then
    self:__OnBtnContinueClick()
    return 
  end
  if self._enterNextLevelFunc ~= nil then
    (self._enterNextLevelFunc)()
  end
end

UIDungeonResult._OnClickWinClgBack = function(self)
  -- function num : 0_6
  self:__OnBtnContinueClick()
end

UIDungeonResult._mergeReward = function(self, table, rewards)
  -- function num : 0_7 , upvalues : _ENV
  for key,value in pairs(rewards) do
    table[key] = (table[key] or 0) + value
  end
end

UIDungeonResult.__InitBattleReward = function(self, rewardDic, getATH)
  -- function num : 0_8 , upvalues : _ENV, cs_DOTween
  self.rewardDic = rewardDic
  local rewardList = {}
  local hasAth = false
  for id,num in pairs(rewardDic) do
    do
      local itemCfg = (ConfigData.item)[id]
      do
        if itemCfg == nil then
          error("can\'t read itemCfg with id=" .. id)
        else
          if ConfigData:IsRewardNotShowATH(itemCfg) then
            hasAth = true
          else
            do
              ;
              (table.insert)(rewardList, {id = id, count = num, itemCfg = itemCfg})
              -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
      -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out DO_STMT

    end
  end
  if getATH ~= nil then
    for _,uid in pairs(getATH) do
      local athData = ((PlayerDataCenter.allAthData).athDic)[uid]
      if athData ~= nil then
        (table.insert)(rewardList, {id = athData.id, count = 1, itemCfg = athData.itemCfg, isAth = true, athData = athData})
      end
    end
  end
  do
    if #rewardList == 0 then
      ((self.ui).rewardLayout):SetActive(false)
      return 
    end
    ;
    ((self.ui).rewardLayout):SetActive(true)
    ExplorationManager:RewardSort(rewardList)
    local luckDropDic = (BattleDungeonManager.dunInterfaceData):GetAfterBattleLuckDropDic()
    for k,v in ipairs(rewardList) do
      local rewardItem = (self.rewardItemPool):GetOne()
      rewardItem:InitItemWithCount(v.itemCfg, v.count, function()
    -- function num : 0_8_0 , upvalues : _ENV, rewardList, k
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_8_0_0 , upvalues : rewardList, k
      if win ~= nil then
        win:InitListDetail(rewardList, k, true)
      end
    end
)
  end
)
      local isLuckDrop = false
      if luckDropDic[v.id] > v.count then
        do
          isLuckDrop = luckDropDic == nil or luckDropDic[v.id] == nil
          ;
          ((rewardItem.ui).obj_img_luckReward):SetActive(isLuckDrop)
          -- DECOMPILER ERROR at PC116: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC116: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    local rewardSequence = (cs_DOTween.Sequence)()
    for index,item in ipairs((self.rewardItemPool).listItem) do
      item:SetFade(0)
      rewardSequence:AppendCallback(function()
    -- function num : 0_8_1 , upvalues : _ENV, item, self
    if ((ConfigData.game_config).itemWithGreatFxDic)[item.itemCfg] then
      item:LoadGetGreatRewardFx(self.resloader, 5)
    else
      item:LoadGetRewardFx(self.resloader, 5)
    end
  end
)
      rewardSequence:Append(((item:GetFade()):DOFade(1, 0.15)):SetLink(item.gameObject))
    end
    rewardSequence:SetDelay(0.15)
    rewardSequence:SetAutoKill(false)
    rewardSequence:Pause()
    if self.rewardSequence ~= nil then
      (self.rewardSequence):Kill()
    end
    self.rewardSequence = rewardSequence
    if self.__animationStart then
      self:StartExpAnimation()
    end
    local hasReward = #rewardList > 0
    -- DECOMPILER ERROR at PC190: Confused about usage of register: R8 in 'UnsetPending'

    if not hasReward or not (Color.New)(1, 1, 1, 0.9) then
      ((self.ui).img_rewardBg).color = (Color.New)(0, 0, 0, 0.4)
      ;
      ((self.ui).obj_rewardText):SetActive(hasReward)
      local showDouble = false
      local multRewardInfo = nil
      if BattleDungeonManager.dunInterfaceData ~= nil then
        multRewardInfo = (BattleDungeonManager.dunInterfaceData):GetBattleWinRewardInfo()
      end
      if multRewardInfo ~= nil and multRewardInfo.isMultReward then
        if multRewardInfo.multRewardTotalNum < 0 then
          showDouble = true
          ;
          (((self.ui).tex_DropCount).gameObject):SetActive(false)
        elseif multRewardInfo.multRewardLeftNum < 0 then
          showDouble = false
        else
          showDouble = true
          ;
          (((self.ui).tex_DropCount).gameObject):SetActive(true)
        end
        if showDouble then
          if multRewardInfo.multRewardRate == 1 then
            ((self.ui).tex_dropInfo):SetIndex(1)
            ;
            ((self.ui).tex_DropCount):SetIndex(1, tostring(multRewardInfo.multRewardLeftNum), tostring(multRewardInfo.multRewardTotalNum))
          else
            ((self.ui).tex_dropInfo):SetIndex(0)
            ;
            ((self.ui).tex_DropCount):SetIndex(0, tostring(multRewardInfo.multRewardLeftNum), tostring(multRewardInfo.multRewardTotalNum))
          end
        end
      end
      ;
      ((self.ui).obj_DropUPTips):SetActive(showDouble)
      do
        if BattleDungeonManager.dunInterfaceData ~= nil and (BattleDungeonManager.dunInterfaceData):GetDgInterfaceDungeonDyncData() ~= nil then
          local dungeonDyncData = (BattleDungeonManager.dunInterfaceData):GetDgInterfaceDungeonDyncData()
          if dungeonDyncData:DgDyncIsHaveMultReward() then
            ((self.ui).obj_DropUPTips):SetActive(true)
            ;
            ((self.ui).tex_dropInfo):SetIndex(1)
            ;
            (((self.ui).tex_DropCount).gameObject):SetActive(false)
          end
        end
        -- DECOMPILER ERROR: 16 unprocessed JMP targets
      end
    end
  end
end

UIDungeonResult.__InitCharacterExp = function(self, lastHeroList)
  -- function num : 0_9 , upvalues : _ENV
  local heroList = ((BattleDungeonManager.dungeonCtrl).dynPlayer).heroList
  local levelupRoleIdDic = {}
  local hasLevelup = false
  self.heroHeadDic = {}
  local heroItem = nil
  for k,dynHero in ipairs(heroList) do
    if not dynHero:IsFriendSupport() then
      heroItem = (self.heroHeadDic)[k]
      if heroItem == nil then
        heroItem = (self.heroHeadItemPool):GetOne()
      end
      heroItem:InitCharacterItem(dynHero, self.resloader, nil)
      heroItem:RefershExpData(lastHeroList[k])
      heroItem:RefreshFriendShipData((self.heroIntimacy)[dynHero.dataId])
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self.heroHeadDic)[k] = heroItem
      local oldLevel = (lastHeroList[k]).level
      if dynHero:GetLevel() < oldLevel then
        levelupRoleIdDic[dynHero.dataId] = true
        hasLevelup = true
      end
    end
  end
end

UIDungeonResult.StartExpAnimation = function(self)
  -- function num : 0_10 , upvalues : _ENV, cs_MessageCommon
  self.__animationStart = true
  local containAth = false
  for id,num in pairs(self.rewardDic) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg ~= nil and itemCfg.type == eItemType.Arithmetic then
      containAth = true
      break
    end
  end
  do
    if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    end
    if self.rewardSequence ~= nil then
      (self.rewardSequence):Restart()
    end
    local dungeonStageData = nil
    if BattleDungeonManager.dunInterfaceData ~= nil then
      dungeonStageData = (BattleDungeonManager.dunInterfaceData):GetIDungeonStageData()
    end
    if dungeonStageData ~= nil and dungeonStageData.dungeonData ~= nil then
      local dungeonCfg = (dungeonStageData.dungeonData).dungeonCfg
      local resource_top = {}
      if dungeonCfg ~= nil then
        for k,v in pairs(dungeonCfg.resource_top) do
          resource_top[k] = v
        end
      end
      do
        ;
        (table.insert)(resource_top, ConstGlobalItem.SKey)
        ;
        (UIUtil.RefreshTopResId)(resource_top, nil, true)
        ;
        (UIUtil.SetCurButtonGroupActive)(false)
      end
    end
  end
end

UIDungeonResult.Update = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if not self.__animationStart then
    return 
  end
  if self.heroHeadDic ~= nil then
    for k,heroItem in pairs(self.heroHeadDic) do
      heroItem:UpdateExp()
    end
  end
end

UIDungeonResult.__InitMvpHeroPic = function(self, playerRoleList, mvpGrade)
  -- function num : 0_12 , upvalues : _ENV
  local heroData = ((mvpGrade.role).character).heroData
  ;
  ((self.ui).tex_heroMvp):SetIndex(mvpGrade.MvpType)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_heroMvp).color = ((self.ui).color_MVP)[mvpGrade.MvpType + 1]
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_mvpName).text = tostring((LanguageUtil.GetLocaleText)((heroData.heroCfg).name))
  ;
  ((self.ui).tex_mvpDesc):SetIndex(mvpGrade.MvpType)
end

UIDungeonResult.InitAutoModeShow = function(self, battleCount, totalCount)
  -- function num : 0_13 , upvalues : _ENV
  if battleCount == totalCount then
    ((self.ui).resultBtnGroup):SetActive(true)
    ;
    ((self.ui).battleAutoNode):SetActive(false)
    ;
    (((self.ui).btn_continue).gameObject):SetActive(true)
    ;
    (((self.ui).btn_PlayAgain).gameObject):SetActive(false)
    return 
  end
  ;
  ((self.ui).resultBtnGroup):SetActive(false)
  ;
  ((self.ui).battleAutoNode):SetActive(true)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_AutoCount).text = (string.format)("%d/%d", battleCount, totalCount)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_AutoTimer).text = tostring((ConfigData.game_config).dungeonAutoWaitingTime)
end

UIDungeonResult.RefreshAutoCutdown = function(self, time)
  -- function num : 0_14 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_AutoTimer).text = tostring(time)
end

UIDungeonResult.SetContinueCallback = function(self, callback)
  -- function num : 0_15
  self.continueCallback = callback
end

UIDungeonResult.BackAction = function(self)
  -- function num : 0_16
  if self.continueCallback ~= nil then
    (self.continueCallback)()
  end
  self:Delete()
end

UIDungeonResult.__OnBtnContinueClick = function(self)
  -- function num : 0_17 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIDungeonResult.InitDungeonRacingResult = function(self, frame, isCheat, isNew)
  -- function num : 0_18
  local item = (self._completeNodePool):GetOne()
  item:InitResultCompleteTime(frame, isCheat, isNew)
end

UIDungeonResult.InitDungeonScoreResult = function(self, score, isNew)
  -- function num : 0_19 , upvalues : _ENV
  local item = (self._completeNodePool):GetOne()
  item:InitResultCompleteItem(2, tostring(score), isNew)
end

UIDungeonResult.InitDungeonScoreAddRateResult = function(self, scoreAdd, isNew)
  -- function num : 0_20 , upvalues : _ENV
  local item = (self._completeNodePool):GetOne()
  item:InitResultCompleteItem(1, tostring((math.floor)(scoreAdd / 10)) .. "%", isNew)
end

UIDungeonResult.DungeonSetPlayeAgain = function(self, playerAgainCallback, dInterfaceData, dungeonStageData)
  -- function num : 0_21 , upvalues : _ENV
  self.playerAgainCallback = playerAgainCallback
  self.dungeonStageData = dungeonStageData
  self.__dInterfaceData = dInterfaceData
  if dungeonStageData ~= nil then
    (((self.ui).btn_PlayAgain).gameObject):SetActive(true)
    ;
    ((self.ui).tex_PlayName):SetIndex(0)
    local IsReach2Limit = dungeonStageData:GetIsReach2Limit()
    local IsDungeonReach2Limit = (dungeonStageData.dungeonData):GetDungeonPlayLeftLimitNum() == 0
    local couldRestart = (not IsReach2Limit and not IsDungeonReach2Limit)
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R7 in 'UnsetPending'

    if couldRestart then
      ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite()
      local costStamina = dungeonStageData:GetStaminaCost()
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_RestartPoint).text = tostring(costStamina)
    else
      (((self.ui).btn_PlayAgain).gameObject):SetActive(false)
    end
    self:__updateBattleRemainLimit(dungeonStageData, couldRestart)
    ;
    (((self.ui).dungeonDataRoot).gameObject):SetActive(true)
  elseif dInterfaceData:AbleContinueReplayLevel() then
    ((self.ui).tex_PlayName):SetIndex(0)
    local costId = dInterfaceData:GetReplayStaminaReplaceItemId()
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite(costId)
    -- DECOMPILER ERROR at PC89: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_RestartPoint).text = tostring(dInterfaceData:GetReplayStaminaCost())
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UIDungeonResult.__updateBattleRemainLimit = function(self, dungeonStageData, isDisplayDungeonLimit)
  -- function num : 0_22 , upvalues : _ENV
  do
    if dungeonStageData ~= nil then
      local moduleRemainNum, moduleTotalNum, moduleUsedNum = (dungeonStageData.dungeonData):GetDungeonPlayLeftLimitNum()
      ;
      (((self.ui).text_ModuleName).gameObject):SetActive(moduleRemainNum > -1)
      if moduleRemainNum > -1 then
        ((self.ui).text_moduleRemainCount):SetIndex(0, tostring(moduleRemainNum), tostring(moduleTotalNum))
        local dungeonModuleCfg = (ConfigData.material_dungeon)[(dungeonStageData.dungeonData).dungeonId]
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R7 in 'UnsetPending'

        if dungeonModuleCfg ~= nil then
          ((self.ui).text_ModuleName).text = (LanguageUtil.GetLocaleText)(((ConfigData.material_dungeon)[(dungeonStageData.dungeonData).dungeonId]).name)
        else
          error("在battle_dungeon:material_duungeon中找不到对应的dungeon配置:" .. (dungeonStageData.dungeonData).dungeonId)
          ;
          (((self.ui).text_ModuleName).gameObject):SetActive(false)
        end
      end
      if isDisplayDungeonLimit and (dungeonStageData.dungeonStageCfg).frequency_day > -1 then
        ((self.ui).dungeonLimitData):SetActive(true)
        local dungeonRemainNum, dungeonTotalNum, dungeonUsedNum = dungeonStageData:GetCurDungeonDailyLimit()
        ;
        ((self.ui).text_dungeonRemainCount):SetIndex(0, tostring(dungeonRemainNum), tostring(dungeonTotalNum))
      else
        ((self.ui).dungeonLimitData):SetActive(false)
      end
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UIDungeonResult.DungeonSetPlayeNext = function(self, playerAgainCallback, dInterfaceData)
  -- function num : 0_23 , upvalues : _ENV
  self.playerAgainCallback = playerAgainCallback
  self.__dInterfaceData = dInterfaceData
  if dInterfaceData ~= nil and dInterfaceData:AbleContinueNextLevel() then
    ((self.ui).tex_PlayName):SetIndex(1)
    ;
    (((self.ui).btn_PlayAgain).gameObject):SetActive(true)
    local costId = dInterfaceData:GetINextStaminaReplaceItemId()
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite(costId)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_RestartPoint).text = tostring(dInterfaceData:GetINextStaminaCost())
  end
end

UIDungeonResult.__OnBtnPlayerAgainClick = function(self)
  -- function num : 0_24
  if self.playerAgainCallback ~= nil then
    (self.playerAgainCallback)(self.__dInterfaceData)
  end
end

UIDungeonResult.__OnBtnSkadaClick = function(self)
  -- function num : 0_25 , upvalues : _ENV, cs_BattleStatistics
  UIManager:ShowWindowAsync(UIWindowTypeID.ResultSkada, function(window)
    -- function num : 0_25_0 , upvalues : cs_BattleStatistics, self
    if window == nil then
      return 
    end
    window:InitBattleSkada(cs_BattleStatistics, (self.resultData).playerRoleList, (self.resultData).enemyRoleList)
  end
)
end

UIDungeonResult.OnDelete = function(self)
  -- function num : 0_26 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  UIManager:DeleteWindow(UIWindowTypeID.BattleResultExtra)
  self.resultData = nil
  if self._auBack ~= nil then
    AudioManager:StopAudioByBack(self._auBack)
    self._auBack = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.rewardSequence ~= nil then
    (self.rewardSequence):Kill()
    self.rewardSequence = nil
  end
  if self.winChallengeNode ~= nil then
    (self.winChallengeNode):Delete()
  end
  UpdateManager:RemoveUpdate(self.__updateHandle)
  MsgCenter:RemoveListener(eMsgEventId.OnShowBattleResultComplete, self.__playAnim)
  ;
  (base.OnDelete)(self)
end

return UIDungeonResult

