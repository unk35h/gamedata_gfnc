-- params : ...
-- function num : 0 , upvalues : _ENV
local UILotteryResult = class("UILotteryResult", UIBaseWindow)
local base = UIBaseWindow
local UINLtrResultHero = require("Game.Lottery.UI.Result.UINLtrResultHero")
local UINLtrResultHeroConvert = require("Game.Lottery.UI.Result.UINLtrResultHeroConvert")
local UINLtrResultItem = require("Game.Lottery.UI.Result.UINLtrResultItem")
local UINLtrResultFrag = require("Game.Lottery.UI.Result.UINLtrResultFrag")
local UINShareCommonBtn = require("Game.Share.UI.UINShareCommonBtn")
local eShare = require("Game.Share.eShare")
local cs_ResLoader = CS.ResLoader
local cs_DoTween = ((CS.DG).Tweening).DOTween
UILotteryResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLtrResultHero, UINLtrResultHeroConvert, UINLtrResultItem, cs_ResLoader, UINShareCommonBtn
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  ;
  ((self.ui).heroItem):SetActive(false)
  self.heroPool = (UIItemPool.New)(UINLtrResultHero, (self.ui).heroItem)
  ;
  ((self.ui).changeItem):SetActive(false)
  self.heroConvertPool = (UIItemPool.New)(UINLtrResultHeroConvert, (self.ui).changeItem)
  ;
  ((self.ui).lotteryItem):SetActive(false)
  self.itemPool = (UIItemPool.New)(UINLtrResultItem, (self.ui).lotteryItem)
  self.resLoader = (cs_ResLoader.Create)()
  ;
  (self.resLoader):LoadABAssetAsync(ItemEffPatch.greetBlastThenLoop)
  self.heroItemList = {}
  self._shareBtn = (UINShareCommonBtn.New)()
  ;
  (self._shareBtn):Init((self.ui).shareCommonButton)
  ;
  (self._shareBtn):Hide()
end

UILotteryResult.InitLtrResult = function(self, rewardElemList, isConvrtFrag, upHeroFragDic)
  -- function num : 0_1 , upvalues : _ENV, UINLtrResultFrag, eShare
  (self.heroConvertPool):HideAll()
  ;
  (self.heroPool):HideAll()
  local upFragNum = 0
  local upHeroFragId = nil
  self.isOnce = #rewardElemList == 1
  self:_RefreshLotteryResultUI(self.isOnce)
  self:_InitShowTween(self.isOnce)
  local allCoverDic = {}
  for k,elem in ipairs(rewardElemList) do
    if elem.heroData ~= nil then
      local heroItem = (self.heroPool):GetOne()
      heroItem:InitLtrResultHero(elem.heroData, elem.isNewHero, self.resLoader)
      self:_SetItemParent(heroItem.transform, k)
      heroItem:SetStarQualityActive(elem.isNewHero)
      heroItem:SetLtrRsultHeroQulityItemHolderParent((self.ui).qualityItemHolder)
      local convertItem = nil
      if not elem.isNewHero then
        do
          if not isConvrtFrag or not heroItem:GetRepeatExtraFragList() then
            local convertList = heroItem:GetRepeatExtraItemList()
          end
          if convertList ~= nil and #convertList > 0 then
            convertItem = (self.heroConvertPool):GetOne()
            ;
            (convertItem.transform):SetParent((heroItem:GetLtrResultHeroUIRoot()).transform)
            convertItem:HideAllChild()
            for _,data in ipairs(convertList) do
              convertItem:GetOneChlid(data.itemCfg, data.num, self.resLoader)
              local count = allCoverDic[data.itemCfg]
              if count == nil then
                count = 0
              end
              allCoverDic[data.itemCfg] = count + data.num
            end
            self:_JoinItemTween(heroItem:GetLtrResultHeroUIRoot(), k, convertItem)
            ;
            (table.insert)(self.heroItemList, heroItem)
            if upHeroFragDic ~= nil and upHeroFragDic[(elem.heroData).dataId] ~= nil then
              upFragNum = upFragNum + upHeroFragDic[(elem.heroData).dataId]
              upHeroFragId = (elem.heroData).fragId
            end
          end
          do
            local item = (self.itemPool):GetOne()
            item:InitLtrResultItem(elem.itemCfg, elem.num)
            self:_SetItemParent(item.transform, k)
            self:_JoinItemTween(item:GetLtrResultItemUIRoot(), k)
            -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC137: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local rewardNum = #rewardElemList
  if rewardNum > 1 and rewardNum < 5 then
    self:_FillEmptyItem(rewardNum + 1, 5)
  elseif rewardNum > 5 and rewardNum < 10 then
    self:_FillEmptyItem(rewardNum + 1, 10)
  end
  if rewardNum > 1 and rewardNum <= 5 then
    ((self.ui).lowerList):SetActive(false)
    ;
    ((self.ui).upperListLine):SetActive(false)
    -- DECOMPILER ERROR at PC179: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).upperList).transform).anchoredPosition = (Vector2.New)(20, 0)
  end
  local baseInsert = #rewardElemList * 0.1
  ;
  (self.showSeq):InsertCallback(baseInsert + 0.3, function()
    -- function num : 0_1_0 , upvalues : self
    (((self.ui).btn_Close).gameObject):SetActive(true)
  end
)
  self:_RefreshConverTotalCount(baseInsert, allCoverDic)
  if isConvrtFrag or upHeroFragId ~= nil then
    self._resultFragNode = (UINLtrResultFrag.New)()
    ;
    (self._resultFragNode):Init((self.ui).obj_ConvertFrag)
    if not self.isOnce or not (self.ui).spOnceChangeParent then
      ((self._resultFragNode).transform):SetParent((self.ui).spTotalChangeParent)
      -- DECOMPILER ERROR at PC220: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self._resultFragNode).transform).anchoredPosition = Vector2.zero
      do
        local hasRepeatConvert = not (table.IsEmptyTable)(allCoverDic)
        ;
        (self._resultFragNode):InitLtrResultFrag(hasRepeatConvert, upFragNum, upHeroFragId)
        local shareCtr = ControllerManager:GetController(ControllerTypeId.Share, true)
        if shareCtr:IsShareUnlock() then
          self._shareId = (eShare.eShareType).CommonReward
          ;
          (self._shareBtn):Show()
          ;
          (self._shareBtn):InitShareCommonBtn(BindCallback(self, self._OnClickShare), self._shareId)
        end
        -- DECOMPILER ERROR: 16 unprocessed JMP targets
      end
    end
  end
end

UILotteryResult._FillEmptyItem = function(self, fromIdx, toIdx)
  -- function num : 0_2
  for i = fromIdx, toIdx do
    local item = (self.itemPool):GetOne()
    item:SetLtrResultItemEmpty()
    self:_SetItemParent(item.transform, i)
    self:_JoinItemTween(item:GetLtrResultItemUIRoot(), i)
  end
end

UILotteryResult._RefreshLotteryResultUI = function(self, isOnce)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).obj_isOnce):SetActive(isOnce)
  if not isOnce or not (self.ui).onceTotalParent then
    local totalChangeParent = (self.ui).tenTotalParent
  end
  ;
  ((self.ui).rect_totalChange):SetParent(totalChangeParent)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_totalChange).localPosition = Vector3.zero
  ;
  ((self.ui).obj_isTen):SetActive(not isOnce)
end

UILotteryResult._RefreshConverTotalCount = function(self, baseInsert, allCoverDic)
  -- function num : 0_4 , upvalues : _ENV
  self.__isShowFragChanged = false
  ;
  (self.showSeq):InsertCallback(baseInsert + 0.15, function()
    -- function num : 0_4_0 , upvalues : self, _ENV, allCoverDic
    (((self.ui).rect_totalChange).gameObject):SetActive(false)
    for cfg,count in pairs(allCoverDic) do
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

      if cfg.id == 1006 then
        ((self.ui).tex_totalItemCount).text = count
        -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).img_totalItemPic).sprite = CRH:GetSprite(cfg.icon)
        ;
        (((self.ui).rect_totalChange).gameObject):SetActive(true)
        self.__isShowFragChanged = true
        GuideManager:TryTriggerGuide(eGuideCondition.InLotteryFragChanged)
        break
      end
    end
    do
      if self._resultFragNode ~= nil then
        (self._resultFragNode):Show()
      end
    end
  end
)
end

UILotteryResult.IsLotteryFragChanged = function(self)
  -- function num : 0_5
  return self.__isShowFragChanged
end

UILotteryResult.GetLotteryFragChangeUI = function(self)
  -- function num : 0_6
  return (self.ui).rect_totalChange
end

UILotteryResult._InitShowTween = function(self, isOnce)
  -- function num : 0_7 , upvalues : cs_DoTween
  (((self.ui).btn_Close).gameObject):SetActive(false)
  local sequence = (cs_DoTween.Sequence)()
  if not isOnce then
    sequence:Insert(0, (((self.ui).upper):DOAnchorPosX((((self.ui).upper).anchoredPosition).x - 300, 1)):From())
    sequence:Insert(0, (((self.ui).lowerArrow):DOAnchorPosX((((self.ui).lowerArrow).anchoredPosition).x - 300, 1.2)):From())
    sequence:Insert(0, (((self.ui).upperArrow):DOAnchorPosX((((self.ui).upperArrow).anchoredPosition).x + 300, 1.2)):From())
    sequence:Insert(0, (((self.ui).lowerRight):DOAnchorPosX((((self.ui).lowerRight).anchoredPosition).x + 300, 1)):From())
  end
  self.showSeq = sequence
end

UILotteryResult._JoinItemTween = function(self, canvasGroup, index, convertItem)
  -- function num : 0_8 , upvalues : _ENV
  local tween, deplay = nil, nil
  if not self.isOnce then
    if index <= 5 then
      deplay = (index - 1) * 0.1
      tween = (((canvasGroup.transform):DOLocalMoveY(150, 0.15)):From()):SetDelay(deplay)
    else
      deplay = (10 - index) * 0.1
      tween = (((canvasGroup.transform):DOLocalMoveY(-150, 0.15)):From()):SetDelay(deplay)
    end
  else
    deplay = 0.2
    tween = (((canvasGroup.transform):DOLocalMoveY(150, 0.15)):From()):SetDelay(deplay)
  end
  tween.onComplete = function()
    -- function num : 0_8_0 , upvalues : self, index, _ENV, convertItem
    local item = (self.heroItemList)[index]
    if not IsNull(item) then
      item:ShowFlashFx()
    end
    if convertItem ~= nil then
      convertItem:ShowHeroConvertFx()
    end
  end

  ;
  (self.showSeq):Insert(0, tween)
  canvasGroup.alpha = 0
  ;
  (self.showSeq):Insert(0, (canvasGroup:DOFade(1, 0.6)):SetDelay(deplay))
end

UILotteryResult.BindLotteryResultExit = function(self, exitAction)
  -- function num : 0_9
  self.__exitAction = exitAction
end

UILotteryResult._SetItemParent = function(self, transform, index)
  -- function num : 0_10
  if self.isOnce then
    transform:SetParent(((self.ui).obj_isOnce).transform)
    return 
  end
  if index <= 5 then
    transform:SetParent((self.ui).heroList_Up)
  else
    transform:SetParent((self.ui).heroList_Low)
  end
end

UILotteryResult._OnClickShare = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Share, function(win)
    -- function num : 0_11_0 , upvalues : self
    if win == nil then
      return 
    end
    ;
    ((win:SetShareBeforeCaptureFunc(function()
      -- function num : 0_11_0_0 , upvalues : self
      self:_ShareShow(false)
    end
)):SetShareAfterCaptureFunc(function()
      -- function num : 0_11_0_1 , upvalues : self
      self:_ShareShow(true)
    end
)):InitShare(self._shareId)
  end
)
end

UILotteryResult._ShareShow = function(self, show)
  -- function num : 0_12 , upvalues : _ENV
  ((self._shareBtn).gameObject):SetActive(show)
  ;
  (((self.ui).tenTotalParent).gameObject):SetActive(show)
  ;
  (((self.ui).onceTotalParent).gameObject):SetActive(show)
  ;
  (((self.ui).spTotalChangeParent).gameObject):SetActive(show)
  ;
  (((self.ui).spOnceChangeParent).gameObject):SetActive(show)
  for k,item in ipairs((self.heroConvertPool).listItem) do
    (item.gameObject):SetActive(show)
  end
  ;
  (((self.ui).btn_Close).gameObject):SetActive(show)
end

UILotteryResult.BackAction = function(self)
  -- function num : 0_13
  self:Delete()
  if self.__exitAction ~= nil then
    (self.__exitAction)()
  end
end

UILotteryResult._OnClickClose = function(self)
  -- function num : 0_14 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UILotteryResult.OnDelete = function(self)
  -- function num : 0_15 , upvalues : base
  if self._resultFragNode ~= nil then
    (self._resultFragNode):Delete()
  end
  ;
  (self.heroPool):DeleteAll()
  ;
  (self.heroConvertPool):DeleteAll()
  ;
  (self.itemPool):DeleteAll()
  ;
  (self._shareBtn):Delete()
  ;
  (self.resLoader):Put2Pool()
  self.resLoader = nil
  if self.showSeq ~= nil then
    (self.showSeq):Kill()
    self.showSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UILotteryResult

