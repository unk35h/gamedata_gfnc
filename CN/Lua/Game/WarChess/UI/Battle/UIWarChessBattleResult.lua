-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarChessBattleResult = class("UIWarChessBattleResult", UIBaseWindow)
local base = UIBaseWindow
local UIRewardItem = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINWarChessResultCoinItem = require("Game.WarChess.UI.Battle.UINWarChessResultCoinItem")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local cs_BattleStatistics = (CS.BattleStatistics).Instance
local cs_GameObject = (CS.UnityEngine).GameObject
local cs_DOTween = ((CS.DG).Tweening).DOTween
UIWarChessBattleResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIRewardItem, UINWarChessResultCoinItem
  self.resloader = ((CS.ResLoader).Create)()
  self.rewardItemPool = (UIItemPool.New)(UIRewardItem, (self.ui).obj_rewardItem)
  ;
  ((self.ui).obj_rewardItem):SetActive(false)
  ;
  ((self.ui).obj_CoinNode):SetActive(false)
  self._coinItemPool = (UIItemPool.New)(UINWarChessResultCoinItem, (self.ui).obj_CoinNode)
  if not (BattleUtil.IsInTDBattle)() then
    (UIUtil.AddButtonListener)((self.ui).btn_skada, self, self.__OnBtnSkadaClick)
  else
    ;
    (((self.ui).btn_skada).gameObject):SetActive(false)
  end
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_continue, self, self.__OnBtnContinueClick)
  self.__playAnim = BindCallback(self, self.__StartAnimation)
  MsgCenter:AddListener(eMsgEventId.OnShowBattleResultComplete, self.__playAnim)
  self.__OnScreenSizeChanged = BindCallback(self, self.__ToFackCameraCanvas)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  self:__ToFackCameraCanvas()
end

UIWarChessBattleResult.__ToFackCameraCanvas = function(self)
  -- function num : 0_1 , upvalues : cs_GameObject, _ENV
  local fakeCameraBattle = ((cs_GameObject.Find)("FakeCameraBattle")):FindComponent(eUnityComponentID.Camera)
  local epMapCamera = (UIManager:GetMainCamera()):FindComponent("EpMapCamera", eUnityComponentID.Camera)
  fakeCameraBattle.enabled = true
  fakeCameraBattle.enabled = false
  self:AlignToFakeCamera(fakeCameraBattle, epMapCamera)
end

UIWarChessBattleResult.SetWCBattleResultBattleData = function(self, playerRoleList, enemyRoleList, mvpGrade)
  -- function num : 0_2
  self.__playerRoleList = playerRoleList
  self.__enemyRoleList = enemyRoleList
  self:__InitMvpHeroPic(mvpGrade)
end

UIWarChessBattleResult.SetWCBattleResultRewardData = function(self, serverRewardDic)
  -- function num : 0_3
  self:__InitWCBattleReward(serverRewardDic)
end

UIWarChessBattleResult.SetContinueCallback = function(self, callback)
  -- function num : 0_4
  self.continueCallback = callback
end

UIWarChessBattleResult.SetWCBattleResultTitle = function(self, title)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_levelName).text = title
end

UIWarChessBattleResult.__InitWCBattleReward = function(self, serverRewardDic)
  -- function num : 0_6 , upvalues : _ENV, WarChessHelper, cs_DOTween
  local isShowAth = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm)
  local rewardDic = {}
  self.rewardDic = rewardDic
  for itemId,itemNum in pairs(serverRewardDic) do
    local itemCfg = (ConfigData.item)[itemId]
    do
      if not itemCfg.explorationHold then
        local hasAth = ConfigData:IsRewardNotShowATH(itemCfg)
        if not hasAth or isShowAth then
          if rewardDic[itemId] == nil then
            rewardDic[itemId] = {count = itemNum, itemCfg = itemCfg}
          else
            do
              -- DECOMPILER ERROR at PC37: Confused about usage of register: R11 in 'UnsetPending'

              ;
              (rewardDic[itemId]).count = (rewardDic[itemId]).count + itemNum
              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  local theRewardList = {}
  do
    local coinRewardList = {}
    for itemId,v in pairs(rewardDic) do
      if ConstWCShowCoin[itemId] ~= nil then
        (table.insert)(coinRewardList, v)
      else
        ;
        (table.insert)(theRewardList, v)
      end
    end
    ;
    (self._coinItemPool):HideAll()
    ;
    (WarChessHelper.WCCoinSort)(coinRewardList)
    for k,v in ipairs(coinRewardList) do
      local rewardItem = (self._coinItemPool):GetOne()
      rewardItem:InitResultCoinItem(v.itemCfg, v.count)
    end
    ExplorationManager:RewardSort(theRewardList)
    for k,v in ipairs(theRewardList) do
      local rewardItem = (self.rewardItemPool):GetOne()
      rewardItem:InitItemWithCount(v.itemCfg, v.count, function()
    -- function num : 0_6_0 , upvalues : _ENV, theRewardList, k
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_6_0_0 , upvalues : theRewardList, k
      if win ~= nil then
        win:InitListDetail(theRewardList, k)
      end
    end
)
  end
)
    end
    if self.rewardSequence ~= nil then
      (self.rewardSequence):Kill()
      self.rewardSequence = nil
    end
    local hasReward = #theRewardList > 0
    ;
    ((self.ui).obj_rewardNode):SetActive(hasReward)
    do
      if hasReward then
        local rewardSequence = (cs_DOTween.Sequence)()
        for index,item in ipairs((self.rewardItemPool).listItem) do
          item:SetFade(0)
          rewardSequence:AppendCallback(function()
    -- function num : 0_6_1 , upvalues : _ENV, item, self
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
        rewardSequence:Pause()
        self.rewardSequence = rewardSequence
      end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

UIWarChessBattleResult.__InitMvpHeroPic = function(self, mvpGrade)
  -- function num : 0_7
  local dynHero = (mvpGrade.role).character
  ;
  ((self.ui).tex_heroMvp):SetIndex(mvpGrade.MvpType)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_heroMvp).color = ((self.ui).color_MVP)[mvpGrade.MvpType + 1]
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_mvpName).text = dynHero:GetName()
  ;
  ((self.ui).tex_mvpDesc):SetIndex(mvpGrade.MvpType)
end

UIWarChessBattleResult.__OnBtnSkadaClick = function(self)
  -- function num : 0_8 , upvalues : _ENV, cs_BattleStatistics
  UIManager:ShowWindowAsync(UIWindowTypeID.ResultSkada, function(window)
    -- function num : 0_8_0 , upvalues : cs_BattleStatistics, self
    if window == nil then
      return 
    end
    window:InitBattleSkada(cs_BattleStatistics, self.__playerRoleList, self.__enemyRoleList)
  end
)
end

UIWarChessBattleResult.__OnBtnContinueClick = function(self)
  -- function num : 0_9
  self:ExitBattleResult()
end

UIWarChessBattleResult.ExitBattleResult = function(self)
  -- function num : 0_10
  if self.continueCallback ~= nil then
    (self.continueCallback)()
  end
  self:Delete()
end

UIWarChessBattleResult.__StartAnimation = function(self)
  -- function num : 0_11 , upvalues : _ENV
  AudioManager:PlayAudioById(1003)
  local containAth = false
  if self.rewardDic ~= nil then
    for id,num in pairs(self.rewardDic) do
      local itemCfg = (ConfigData.item)[id]
      if itemCfg ~= nil and itemCfg.type == eItemType.Arithmetic then
        containAth = true
        break
      end
    end
  end
  do
    if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    end
    self.__animationStart = true
    if self.rewardSequence ~= nil then
      (self.rewardSequence):Restart()
    end
  end
end

UIWarChessBattleResult.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
  MsgCenter:RemoveListener(eMsgEventId.OnShowBattleResultComplete, self.__playAnim)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.rewardSequence ~= nil then
    (self.rewardSequence):Kill()
    self.rewardSequence = nil
  end
  if self.weeklyResultNode ~= nil then
    (self.weeklyResultNode):Delete()
  end
  self.__playerRoleList = nil
  self.__enemyRoleList = nil
  ;
  (base.OnDelete)(self)
end

return UIWarChessBattleResult

