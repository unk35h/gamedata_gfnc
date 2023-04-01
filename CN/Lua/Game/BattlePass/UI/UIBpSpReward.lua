-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIBpSpReward = class("UIBpSpReward", base)
local UICommonItem = require("Game.CommonUI.Item.UICommonRewardItem")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UIBpSpReward.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.resloader = ((CS.ResLoader).Create)()
  self.rewardData = nil
  self.exitFuncList = {}
  self.buyFuncList = {}
  self.__rewardItemDic = {}
  self.__rewardSubItemDic = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnBuyBpClick)
  self.__OnRewardItemClick = BindCallback(self, self.OnRewardItemClick)
  self.__OnSubItemClick = BindCallback(self, self.OnSubItemClick)
  self.__UpdateSpRewardShowFunc = BindCallback(self, self.__UpdateSpRewardShow)
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScroll).onReturnItem = BindCallback(self, self.__OnReturnItem)
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).subLoopScroll).onInstantiateItem = BindCallback(self, self.__OnNewSubItem)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).subLoopScroll).onChangeItem = BindCallback(self, self.__OnChangeSubItem)
  -- DECOMPILER ERROR at PC84: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).subLoopScroll).onReturnItem = BindCallback(self, self.__OnReturnSubItem)
  self.__SetCanClickClose = BindCallback(self, self.SetIsCanClickClose, true)
  self:SetIsCanClickClose(true)
  self.__onOPenShowReward = false
end

UIBpSpReward.AddAndTryShowReward = function(self, commonRewardData)
  -- function num : 0_1 , upvalues : _ENV
  self.rewardData = commonRewardData
  if commonRewardData.exitAction ~= nil then
    (table.insert)(self.exitFuncList, commonRewardData.exitAction)
  end
  if commonRewardData.buyAction ~= nil then
    (table.insert)(self.buyFuncList, commonRewardData.buyAction)
  end
  self:__ShowNextReward()
end

UIBpSpReward.__ShowNextReward = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (ControllerManager:GetController(ControllerTypeId.Skin, true)):CheckItemListsForSkins((self.rewardData).rewardIds, self.__UpdateSpRewardShowFunc, self.rewardData)
end

UIBpSpReward.__UpdateSpRewardShow = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:Show()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  if not (string.IsNullOrEmpty)((self.rewardData).title) then
    ((self.ui).txt_RewardTitle).text = (self.rewardData).title
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

UIBpSpReward.__SetLoopItem = function(self, item, itemId, itemNum)
  -- function num : 0_4
  if (self.rewardData).crUpHeroFragDic ~= nil then
    item:SetIsConvertHeroFrag()
  end
  do
    if (self.rewardData).crItemTransDic ~= nil then
      local transNum = ((self.rewardData).crItemTransDic)[itemId]
      if transNum ~= nil then
        item:SetItemTranNum(transNum)
        self:SetCannotClickCloseTimer()
      end
    end
    ;
    ((item.baseItem).baseItem):SetIsShowNewTag(false)
    if (self.rewardData).crItemNewDic ~= nil and ((self.rewardData).crItemNewDic)[itemId] ~= nil then
      ((item.baseItem).baseItem):SetIsShowNewTag(true)
    end
  end
end

UIBpSpReward.__OnNewItem = function(self, go)
  -- function num : 0_5 , upvalues : UICommonItem, _ENV
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

UIBpSpReward.__OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local item = (self.__rewardItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local itemId = ((self.rewardData).rewardIds)[index + 1]
  local itemNum = ((self.rewardData).rewardNums)[index + 1]
  self:__SetLoopItem(item, itemId, itemNum)
  local itemCfg = (ConfigData.item)[itemId]
  item:InitCommonRewardItem(itemCfg, itemNum, (self.rewardData).heroSnapshoot, self.__OnRewardItemClick)
  item:BindRewardClickCustomArg(index + 1)
end

UIBpSpReward.__OnReturnItem = function(self, go)
  -- function num : 0_7 , upvalues : _ENV
  local item = (self.__rewardItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  ;
  (item.baseItem):CloseGreatRewardLoopFx()
  ;
  (item.baseItem):CloseQualityFx()
end

UIBpSpReward.__GetItemByIndex = function(self, index)
  -- function num : 0_8
  local go = ((self.ui).loopScroll):GetCellByIndex(index)
  if go ~= nil then
    return (self.__rewardItemDic)[go]
  end
  return nil
end

UIBpSpReward.__OnNewSubItem = function(self, go)
  -- function num : 0_9 , upvalues : UINBaseItemWithCount, _ENV
  local item = (UINBaseItemWithCount.New)()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (go.transform).localScale = Vector3.one
  item:Init(go)
  item:BindBaseItemResloader(self.resloader)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__rewardSubItemDic)[go] = item
end

UIBpSpReward.__OnChangeSubItem = function(self, go, index)
  -- function num : 0_10 , upvalues : _ENV
  local item = (self.__rewardSubItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local hasBpSpReward, bpSpRewardIds, bpSpRewardNums = (self.rewardData):GetBpSpRewardPreview()
  local itemId = bpSpRewardIds[index + 1]
  local itemNum = bpSpRewardNums[index + 1]
  local itemCfg = (ConfigData.item)[itemId]
  item:InitItemWithCount(itemCfg, itemNum, self.__OnSubItemClick)
  item:BindClickCustomArg(index + 1)
end

UIBpSpReward.__OnReturnSubItem = function(self, go)
  -- function num : 0_11 , upvalues : _ENV
  local item = (self.__rewardSubItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  item:CloseGreatRewardLoopFx()
  item:CloseQualityFx()
end

UIBpSpReward.OnRewardItemClick = function(self, itemCfg, index)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_12_0 , upvalues : self, index
    if win ~= nil then
      win:SetNotNeedAnyJump(true)
      win:InitListDetail((self.rewardData).rewardDataList, index)
    end
  end
)
end

UIBpSpReward.OnSubItemClick = function(self, itemCfg, index)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_13_0 , upvalues : self, index
    if win ~= nil then
      win:SetNotNeedAnyJump(true)
      win:InitListDetail((self.rewardData):GetBpSpRewardList(), index)
    end
  end
)
end

UIBpSpReward.__RefreshList = function(self)
  -- function num : 0_14
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).loopScroll).totalCount = #(self.rewardData).rewardIds
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).subLoopScroll).totalCount = (self.rewardData):GetBpSpRewardCount()
  self:__ShowGetRewardFx()
end

UIBpSpReward.__ShowGetRewardFx = function(self)
  -- function num : 0_15
  ((self.ui).dotween_rewardContent):DORestart()
  ;
  ((self.ui).dotween_list):DORestart()
  ;
  ((self.ui).dotween_sublist):DORestart()
  if self.tweenSeq ~= nil then
    (self.tweenSeq):Kill(true)
    self.tweenSeq = nil
  end
  self.__onOPenShowReward = true
  if not self.__isAdded then
    self.__isAdded = true
    ;
    (((self.ui).dotween_rewardContent).onComplete):AddListener(function()
    -- function num : 0_15_0 , upvalues : self
    self.__onOPenShowReward = false
    self:__PlayTooMuchRewardAnima()
    self:__PlaySubListRewardAnima()
  end
)
  end
end

local anchorLeft = (Vector2.New)(0, 0.5)
local anchorMid = (Vector2.New)(0.5, 0.5)
UIBpSpReward.__PlayTooMuchRewardAnima = function(self)
  -- function num : 0_16 , upvalues : _ENV, anchorLeft, anchorMid, cs_DoTween, cs_Ease
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
    -- function num : 0_16_0 , upvalues : self, maxPage, cs_DoTween, maxCouldContainNum, _ENV, cs_Ease, ShowOnePage
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
      -- function num : 0_16_0_0 , upvalues : _ENV, item, self
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
      -- function num : 0_16_0_1 , upvalues : ShowOnePage, pageIndex
      ShowOnePage(pageIndex + 1)
    end
)
  end

  ShowOnePage(0)
end

UIBpSpReward.__PlaySubListRewardAnima = function(self)
  -- function num : 0_17 , upvalues : _ENV, anchorLeft, anchorMid
  local hasBpSpReward, bpSpRewardIds, bpSpRewardNums = (self.rewardData):GetBpSpRewardPreview()
  if not hasBpSpReward then
    return 
  end
  local maxCouldContainNum = (math.ceil)((((((self.ui).subLoopScroll).transform).rect).width - (((self.ui).subLayoutGroup).padding).left) / ((((self.ui).subLayoutGroup).cellSize).x + (((self.ui).subLayoutGroup).spacing).x))
  local maxPage = (math.ceil)(#bpSpRewardIds / maxCouldContainNum)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

  if maxPage > 1 then
    (((self.ui).subLayoutGroup).transform).anchorMax = anchorLeft
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).subLayoutGroup).transform).anchorMin = anchorLeft
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).subLayoutGroup).transform).pivot = anchorLeft
  else
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).subLayoutGroup).transform).anchorMax = anchorMid
    -- DECOMPILER ERROR at PC61: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).subLayoutGroup).transform).anchorMin = anchorMid
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).subLayoutGroup).transform).pivot = anchorMid
  end
  ;
  ((self.ui).subLoopScroll):RefillCells()
end

UIBpSpReward.SetIsCanClickClose = function(self, isCan)
  -- function num : 0_18
  self.__isCanClickClose = isCan
end

UIBpSpReward.SetCannotClickCloseTimer = function(self)
  -- function num : 0_19 , upvalues : _ENV
  self:SetIsCanClickClose(false)
  if self.__cannotClickCloseTimerId ~= nil then
    TimerManager:StopTimer(self.__cannotClickCloseTimerId)
  end
  self.__cannotClickCloseTimerId = TimerManager:StartTimer(3, self.__SetCanClickClose)
end

UIBpSpReward.OnClickClose = function(self)
  -- function num : 0_20
  self:__CloseInternal(self.exitFuncList)
end

UIBpSpReward.OnBuyBpClick = function(self)
  -- function num : 0_21
  self:__CloseInternal(self.buyFuncList)
end

UIBpSpReward.__CloseInternal = function(self, funcList)
  -- function num : 0_22 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  if self.tweenSeq ~= nil and (self.tweenSeq):IsPlaying() then
    (self.tweenSeq).timeScale = 1000
  else
    if self.__isAdded and not self.__onOPenShowReward then
      if not self.__isCanClickClose then
        return 
      end
      self:Delete()
      for index,func in ipairs(funcList) do
        func()
      end
    end
  end
end

UIBpSpReward.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
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
  ((self.ui).dotween_sublist):DOKill()
  ;
  ((self.ui).dotween_rewardContent):DOKill()
  for go,item in pairs(self.__rewardItemDic) do
    item:Delete()
  end
  if self.__cannotClickCloseTimerId ~= nil then
    TimerManager:StopTimer(self.__cannotClickCloseTimerId)
    self.__cannotClickCloseTimerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIBpSpReward

