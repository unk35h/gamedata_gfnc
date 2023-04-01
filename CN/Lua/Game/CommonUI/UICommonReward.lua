-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonReward = class("UICommonReward", UIBaseWindow)
local base = UIBaseWindow
local UICommonItem = require("Game.CommonUI.Item.UICommonRewardItem")
local cs_ResLoader = CS.ResLoader
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UICommonReward.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resloader = (cs_ResLoader.Create)()
  self.rewardData = nil
  self.__isShowingReward = false
  self.commonRewardQueue = {}
  self.exitFuncList = {}
  self.__rewardItemDic = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  self.__OnRewardItemClick = BindCallback(self, self.OnRewardItemClick)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.__UpdateRewardShowFunc = BindCallback(self, self.__UpdateRewardShow)
  self.__SetCanClickClose = BindCallback(self, self.SetIsCanClickClose, true)
  self:SetIsCanClickClose(true)
  self._challengeStarWidth = (((self.ui).img_ChallengeAll).sizeDelta).x
  self.__onOPenShowReward = false
end

UICommonReward.AddAndTryShowReward = function(self, commonRewardData)
  -- function num : 0_1 , upvalues : _ENV
  local greadRewardData = commonRewardData:CutOutGreatRewards()
  if greadRewardData ~= nil then
    (table.insert)(self.commonRewardQueue, 1, greadRewardData)
  end
  if #commonRewardData.rewardIds > 0 then
    (table.insert)(self.commonRewardQueue, commonRewardData)
  end
  if commonRewardData.exitAction ~= nil then
    (table.insert)(self.exitFuncList, commonRewardData.exitAction)
  end
  if #self.commonRewardQueue > 0 then
    self:__ShowNextReward()
  else
    self:Delete()
    for index,func in ipairs(self.exitFuncList) do
      func()
    end
  end
end

UICommonReward.__ShowNextReward = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.__isShowingReward then
    return 
  end
  self.__isShowingReward = true
  if self.challengeFxGoList ~= nil then
    for i,v in ipairs(self.challengeFxGoList) do
      v:SetActive(false)
    end
  end
  do
    self.rewardData = (self.commonRewardQueue)[1]
    ;
    (table.remove)(self.commonRewardQueue, 1)
    ;
    (ControllerManager:GetController(ControllerTypeId.Skin, true)):CheckItemListsForSkins((self.rewardData).rewardIds, self.__UpdateRewardShowFunc, self.rewardData)
  end
end

UICommonReward.__UpdateRewardShow = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:Show()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  if not (string.IsNullOrEmpty)((self.rewardData).title) then
    ((self.ui).txt_RewardTitle).text = (self.rewardData).title
  end
  if not (string.IsNullOrEmpty)((self.rewardData).rewardTips) then
    (((self.ui).tex_Tips).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_Tips).text = (self.rewardData).rewardTips
  else
    ;
    (((self.ui).tex_Tips).gameObject):SetActive(false)
  end
  if ((Consts.GameChannelType).IsJp)() and (self.rewardData):HasCRQZ() then
    local itemDic = (self.rewardData):GetCRBeforeMergeItemDic()
    local freeQZNum = itemDic[ConstGlobalItem.PaidItem] or 0
    local paidQZNum = itemDic[ConstGlobalItem.PaidQZ] or 0
    ;
    ((self.ui).obj_JpQZTag):SetActive(true)
    ;
    ((self.ui).tex_FreeCount):SetIndex(0, tostring(freeQZNum))
    ;
    ((self.ui).tex_PayCount):SetIndex(0, tostring(paidQZNum))
  else
    do
      ;
      ((self.ui).obj_JpQZTag):SetActive(false)
      ;
      ((self.ui).monthCardTime):SetActive((self.rewardData):HasCRMonthCardTimeTips())
      if (self.rewardData).heroIdList ~= nil and #(self.rewardData).heroIdList > 0 then
        self:Hide()
        UIManager:ShowWindowAsync(UIWindowTypeID.GetHero, function(window)
    -- function num : 0_3_0 , upvalues : self, _ENV
    if window == nil then
      return 
    end
    if (self.rewardData).crUpHeroFragDic ~= nil then
      window:SetGetHeroConvertFrag((self.rewardData).crUpHeroFragDic)
    end
    window:InitGetHeroList((self.rewardData).heroIdList, false, true, (self.rewardData).newHeroIndexDic, function()
      -- function num : 0_3_0_0 , upvalues : self, _ENV
      self:Show()
      self:__RefreshList()
      AudioManager:PlayAudioById(1115)
      UIManager:DeleteWindow(UIWindowTypeID.GetHero)
    end
, (self.rewardData).skipOldHero)
  end
)
      else
        AudioManager:PlayAudioById(1029)
        self:__RefreshList()
      end
    end
  end
end

UICommonReward._ShowChallengeTask = function(self, rewardData)
  -- function num : 0_4 , upvalues : _ENV
  (((self.ui).img_ChallengeAll).gameObject):SetActive(true)
  local fromNum = rewardData.challengeModeTaskFromNum
  local toNum = rewardData.challengeModeTaskToNum
  local size = ((self.ui).img_ChallengeAll).sizeDelta
  size.x = self._challengeStarWidth * rewardData.challengeModeTaskTotalNum
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ChallengeAll).sizeDelta = size
  size.x = self._challengeStarWidth * fromNum
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ChallengeCur).sizeDelta = size
  if not self.challengeFxGoList then
    local fxGoList = {}
  end
  self.challengeFxGoList = fxGoList
  for i = 1, rewardData.challengeModeTaskTotalNum do
    local fxGo = fxGoList[i]
    if fxGo == nil then
      if i > 1 then
        local go = ((self.ui).challengeFxItem):Instantiate()
        fxGo = ((go.transform):GetChild(0)).gameObject
      else
        do
          do
            fxGo = ((((self.ui).challengeFxItem).transform):GetChild(0)).gameObject
            ;
            (table.insert)(fxGoList, fxGo)
            fxGo:SetActive(false)
            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  if self._challengeTimerId ~= nil then
    TimerManager:StopTimer(self._challengeTimerId)
  end
  self._challengeTimerId = TimerManager:StartTimer(0.2, function()
    -- function num : 0_4_0 , upvalues : fromNum, toNum, _ENV, self, fxGoList
    if toNum <= fromNum then
      TimerManager:StopTimer(self._challengeTimerId)
      self:__PlayTooMuchRewardAnima()
      return 
    end
    fromNum = fromNum + 1
    local fxGo = fxGoList[fromNum]
    if fxGo ~= nil then
      fxGo:SetActive(true)
    end
  end
, self, false)
end

UICommonReward._ShowReward = function(self)
  -- function num : 0_5
end

UICommonReward.__RefreshList = function(self)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).loopScroll).totalCount = #(self.rewardData).rewardIds
  self:__ShowGetRewardFx()
end

UICommonReward.__OnNewItem = function(self, go)
  -- function num : 0_7 , upvalues : UICommonItem, _ENV
  local item = (UICommonItem.New)()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (go.transform).localScale = Vector3.one
  item:Init(go)
  item:BindRewardResloader(self.resloader)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__rewardItemDic)[go] = item
end

UICommonReward.__OnChangeItem = function(self, go, index)
  -- function num : 0_8 , upvalues : _ENV
  local item = (self.__rewardItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local itemId = ((self.rewardData).rewardIds)[index + 1]
  local itemNum = ((self.rewardData).rewardNums)[index + 1]
  local itemCfg = (ConfigData.item)[itemId]
  if (self.rewardData).crUpHeroFragDic ~= nil then
    item:SetIsConvertHeroFrag()
  end
  do
    if (self.rewardData).crItemTransDic ~= nil then
      local transNum = ((self.rewardData).crItemTransDic)[itemId]
      if transNum ~= nil then
        item:SetItemTranNum(transNum)
        self:SetCannotClickCloseTimer()
      else
        item:SetItemTranNum(nil)
      end
    end
    ;
    ((item.baseItem).baseItem):SetIsShowNewTag(false)
    if (self.rewardData).crItemNewDic ~= nil and ((self.rewardData).crItemNewDic)[itemId] ~= nil then
      ((item.baseItem).baseItem):SetIsShowNewTag(true)
    end
    item:InitCommonRewardItem(itemCfg, itemNum, (self.rewardData).heroSnapshoot, self.__OnRewardItemClick)
    item:BindRewardClickCustomArg(index + 1)
  end
end

UICommonReward.__OnReturnItem = function(self, go)
  -- function num : 0_9
  local item = (self.__rewardItemDic)[go]
  ;
  (item.baseItem):CloseGreatRewardLoopFx()
  ;
  (item.baseItem):CloseQualityFx()
end

UICommonReward.__GetItemByIndex = function(self, index)
  -- function num : 0_10
  local go = ((self.ui).loopScroll):GetCellByIndex(index)
  if go ~= nil then
    return (self.__rewardItemDic)[go]
  end
  return nil
end

UICommonReward.OnRewardItemClick = function(self, itemCfg, index)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_11_0 , upvalues : self, index
    if win ~= nil then
      win:SetNotNeedAnyJump(true)
      win:InitListDetail((self.rewardData).rewardDataList, index)
    end
  end
)
end

UICommonReward.__ShowGetRewardFx = function(self)
  -- function num : 0_12
  ((self.ui).dotween_rewardContent):DORestart()
  ;
  ((self.ui).dotween_list):DORestart()
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill(true)
    self.tweenSeq = nil
  end
  self.__onOPenShowReward = true
  if not self.__isAdded then
    self.__isAdded = true
    ;
    (((self.ui).dotween_rewardContent).onComplete):AddListener(function()
    -- function num : 0_12_0 , upvalues : self
    self.__onOPenShowReward = false
    if (self.rewardData).challengeModeTaskFromNum == nil then
      (((self.ui).img_ChallengeAll).gameObject):SetActive(false)
      self:__PlayTooMuchRewardAnima()
      return 
    end
    self:_ShowChallengeTask(self.rewardData)
  end
)
  end
end

local anchorLeft = (Vector2.New)(0, 0.5)
local anchorMid = (Vector2.New)(0.5, 0.5)
UICommonReward.__PlayTooMuchRewardAnima = function(self)
  -- function num : 0_13 , upvalues : _ENV, anchorLeft, anchorMid, cs_DoTween, cs_Ease
  local maxCouldContainNum = (math.ceil)((((((self.ui).loopScroll).transform).rect).width - (((self.ui).layoutGroup).padding).left) / ((((self.ui).layoutGroup).cellSize).x + (((self.ui).layoutGroup).spacing).x))
  local maxPage = (math.ceil)(#(self.rewardData).rewardIds / maxCouldContainNum)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  if maxPage > 1 then
    (((self.ui).layoutGroup).transform).anchorMax = anchorLeft
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).layoutGroup).transform).anchorMin = anchorLeft
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).layoutGroup).transform).pivot = anchorLeft
  else
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).layoutGroup).transform).anchorMax = anchorMid
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).layoutGroup).transform).anchorMin = anchorMid
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).layoutGroup).transform).pivot = anchorMid
  end
  local ShowOnePage = function(pageIndex)
    -- function num : 0_13_0 , upvalues : self, maxPage, cs_DoTween, maxCouldContainNum, _ENV, cs_Ease, ShowOnePage
    if self.tweenSeq ~= nil then
      (self.tweenSeq):Kill(true)
      self.tweenSeq = nil
    end
    if maxPage <= pageIndex then
      return 
    end
    self.tweenSeq = (cs_DoTween.Sequence)()
    ;
    (self.tweenSeq):AppendInterval(0.05)
    ;
    ((self.ui).loopScroll):RefillCells(pageIndex * maxCouldContainNum)
    for i = pageIndex * maxCouldContainNum, (pageIndex + 1) * maxCouldContainNum - 1 do
      if #(self.rewardData).rewardIds > i then
        do
          local item = self:__GetItemByIndex(i)
          do
            -- DECOMPILER ERROR at PC47: Confused about usage of register: R6 in 'UnsetPending'

            if item ~= nil then
              (item.transform).localScale = Vector3.one
              ;
              (self.tweenSeq):Append((((item.transform):DOScale(Vector3.zero, 0.2)):From()):SetEase(cs_Ease.OutBack))
              ;
              (self.tweenSeq):AppendCallback(function()
      -- function num : 0_13_0_0 , upvalues : _ENV, item, self
      if ((ConfigData.game_config).itemWithGreatFxDic)[(item.itemCfg).id] then
        (item.baseItem):LoadGetGreatRewardFx(self.resloader, 0)
      else
        ;
        (item.baseItem):LoadGetRewardFx(self.resloader, 0)
      end
    end
)
            end
          end
          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    ;
    (self.tweenSeq):AppendCallback(function()
      -- function num : 0_13_0_1 , upvalues : ShowOnePage, pageIndex
      ShowOnePage(pageIndex + 1)
    end
)
  end

  ShowOnePage(0)
end

UICommonReward.SetIsCanClickClose = function(self, isCan)
  -- function num : 0_14
  self.__isCanClickClose = isCan
end

UICommonReward.SetCannotClickCloseTimer = function(self)
  -- function num : 0_15 , upvalues : _ENV
  self:SetIsCanClickClose(false)
  if self.__cannotClickCloseTimerId ~= nil then
    TimerManager:StopTimer(self.__cannotClickCloseTimerId)
  end
  self.__cannotClickCloseTimerId = TimerManager:StartTimer(3, self.__SetCanClickClose)
end

UICommonReward.OnClickClose = function(self)
  -- function num : 0_16 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  if self.tweenSeq ~= nil and (self.tweenSeq):IsPlaying() then
    (self.tweenSeq).timeScale = 1000
  else
    if self.__isAdded and not self.__onOPenShowReward then
      if not self.__isCanClickClose then
        return 
      end
      if #self.commonRewardQueue > 0 then
        self.__isShowingReward = false
        self:__ShowNextReward()
      else
        self:Delete()
        for index,func in ipairs(self.exitFuncList) do
          func()
        end
      end
    end
  end
end

UICommonReward.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill(true)
    self.tweenSeq = nil
  end
  ;
  ((self.ui).dotween_list):DOKill()
  ;
  ((self.ui).dotween_rewardContent):DOKill()
  for go,item in pairs(self.__rewardItemDic) do
    item:Delete()
  end
  if self._challengeTimerId ~= nil then
    TimerManager:StopTimer(self._challengeTimerId)
  end
  if self.__cannotClickCloseTimerId ~= nil then
    TimerManager:StopTimer(self.__cannotClickCloseTimerId)
    self.__cannotClickCloseTimerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonReward

