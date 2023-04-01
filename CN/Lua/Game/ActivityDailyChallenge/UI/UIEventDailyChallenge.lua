-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventDailyChallenge = class("UIEventDailyChallenge", UIBaseWindow)
local base = UIBaseWindow
local UINADCDungeonItem = require("Game.ActivityDailyChallenge.UI.UINADCDungeonItem")
local UINADCRewardNode = require("Game.ActivityDailyChallenge.UI.UINADCRewardNode")
local ADCDungeonLevelData = require("Game.ActivityDailyChallenge.ADCDungeonLevelData")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
UIEventDailyChallenge.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINADCDungeonItem
  (UIUtil.SetTopStatus)(self, self.OnClickADCClose, nil, function()
    -- function num : 0_0_0 , upvalues : _ENV
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)(23, nil)
  end
)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ScoreReward, self, self.OnClickReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_icon, self, self.OnClickTickets)
  self.__OnOpenDungeonCallback = BindCallback(self, self.__OnOpenDungeon)
  self._itemPool = (UIItemPool.New)(UINADCDungeonItem, (self.ui).taskItem)
  ;
  ((self.ui).taskItem):SetActive(false)
  ;
  ((self.ui).rewardList):SetActive(false)
  self.__RefreshItemKeyCallback = BindCallback(self, self.__RefreshItemKey)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__RefreshItemKeyCallback)
  self.__RefreshChallengeCallback = BindCallback(self, self.__RefreshChallenge)
  MsgCenter:AddListener(eMsgEventId.ActivityDailyChallengeDungeonUpdate, self.__RefreshChallengeCallback)
  self.__RefreshPointAndRewardCallback = BindCallback(self, self.__RefreshPointAndReward)
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).text_icon_des).text = ConfigData:GetTipContent(8402)
end

UIEventDailyChallenge.InitADCMain = function(self, adcData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._adcData = adcData
  self._callback = callback
  self._mainCfg = (self._adcData):GetADCMainCfg()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).icon).sprite = CRH:GetSpriteByItemId((self._mainCfg).unlock_item)
  self._timerId = TimerManager:StartTimer(1, self.__TimeCountdown, self)
  self:__TimeCountdown()
  self:__RefreshItemKey()
  self:__RefreshPointAndReward()
  ;
  (self._itemPool):HideAll()
  local dungeonList = {}
  for k,v in pairs((self._adcData):GetADCDungeonCfg()) do
    (table.insert)(dungeonList, v)
  end
  ;
  (table.sort)(dungeonList, function(a, b)
    -- function num : 0_1_0
    do return a.dungeon_order < b.dungeon_order end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self._dungeonItemDic = {}
  for _,cfg in ipairs(dungeonList) do
    local item = (self._itemPool):GetOne()
    item:InitADCDungeonItem(self._adcData, cfg, self.__OnOpenDungeonCallback)
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self._dungeonItemDic)[cfg.dungeon_id] = item
  end
  ;
  (self._adcData):SetAdcOpend()
  if (self._mainCfg).first_avg > 0 and (self._adcData):IsActivityRunning() then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed((self._mainCfg).first_avg)
    if not played then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, (self._mainCfg).first_avg)
    end
  end
  do
    if (self._mainCfg).last_avg > 0 and (self._adcData):IsADCAllPass() and (self._adcData):IsActivityRunning() then
      local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
      local played = avgPlayCtrl:IsAvgPlayed((self._mainCfg).last_avg)
      if not played then
        (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, (self._mainCfg).last_avg)
      end
    end
  end
end

UIEventDailyChallenge.__RefreshItemKey = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local hasCount = (self._adcData):GetADCKeyItemCount()
  local maxCount = (self._mainCfg).unlock_item_max
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = tostring(hasCount) .. "/" .. tostring(maxCount)
  if hasCount < maxCount and not (self._adcData):IsEnoughADCItemKey() then
    local shopCfg = ControllerManager:GetController(ControllerTypeId.Shop)
    shopCfg:GetShopData((self._mainCfg).unlock_item_shop, function(shopData)
    -- function num : 0_2_0 , upvalues : self
    if shopData == nil then
      (((self.ui).btn_Add).gameObject):SetActive(false)
      return 
    end
    local goodsData = shopData:GetShopGoodDataByItemId((self._mainCfg).unlock_item)
    if goodsData ~= nil and goodsData:GetCouldBuyMaxBuyNum() > 0 then
      (((self.ui).btn_Add).gameObject):SetActive(true)
    else
      ;
      (((self.ui).btn_Add).gameObject):SetActive(false)
    end
  end
)
  else
    do
      ;
      (((self.ui).btn_Add).gameObject):SetActive(false)
      if (UIUtil.CheckIsHaveSpecialMarker)(UIWindowTypeID.QuickBuy) then
        (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.EventDaliyChallenge, false)
      end
    end
  end
end

UIEventDailyChallenge.__RefreshPointAndReward = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local awardCfg = (self._adcData):GetADCAwardCfg()
  local extraCfg = (self._adcData):GetADCCycleAward()
  local curPoint = (self._adcData):GetADCTotalPoint()
  local hasReward = false
  local nextPoint = 0
  for index,cfg in ipairs(awardCfg) do
    if curPoint < cfg.need_point then
      nextPoint = cfg.need_point
      break
    end
    if not hasReward then
      hasReward = (self._adcData):IsCanADCFixedReward(cfg.need_point)
    end
  end
  do
    if nextPoint == 0 then
      if not hasReward then
        hasReward = (self._adcData):IsCanADCExtraReward()
      end
      local diff = curPoint - (self._adcData):GetADCMaxFixedPoint()
      diff = (math.floor)(diff / extraCfg.need_point) + 1
      nextPoint = (self._adcData):GetADCMaxFixedPoint() + (diff) * extraCfg.need_point
    end
    do
      ;
      ((self.ui).info):SetActive(curPoint == 0)
      if curPoint > 0 then
        ((self.ui).tex_score):SetIndex(1, tostring(curPoint))
      else
        ((self.ui).tex_score):SetIndex(0)
      end
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_num).text = tostring(nextPoint)
      ;
      ((self.ui).img_NewReward):SetActive(hasReward)
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

UIEventDailyChallenge.__RefreshChallenge = function(self, dungeonId)
  -- function num : 0_4
  local item = (self._dungeonItemDic)[dungeonId]
  if item == nil then
    return 
  end
  item:RefreshADCDungeonItem()
  self:__RefreshItemKey()
end

UIEventDailyChallenge.__OnOpenDungeon = function(self, dungeonId, item)
  -- function num : 0_5 , upvalues : _ENV, ADCDungeonLevelData
  item:RefreshADCSelectState(dungeonId)
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(win)
    -- function num : 0_5_0 , upvalues : ADCDungeonLevelData, dungeonId, self, _ENV, item
    if win == nil then
      return 
    end
    local dunLevelData = (ADCDungeonLevelData.New)(dungeonId)
    dunLevelData:SetDungeonADCData(self._adcData)
    win:InitDungeonLevelDetail(dunLevelData, not dunLevelData:IsADCDungeonLevelUnlock())
    win:SetDungeonLevelBgClose(true)
    win:SetDunLevelDetaiHideStartEvent(function()
      -- function num : 0_5_0_0 , upvalues : _ENV, item
      if not IsNull(item.transform) then
        item:RefreshADCSelectState(nil)
      end
    end
)
  end
)
end

UIEventDailyChallenge.OnClickReward = function(self)
  -- function num : 0_6 , upvalues : UINADCRewardNode
  if self._rewardNode == nil then
    ((self.ui).rewardList):SetActive(true)
    self._rewardNode = (UINADCRewardNode.New)()
    ;
    (self._rewardNode):Init((self.ui).rewardList)
    ;
    (self._rewardNode):InitADCRewardNode(self._adcData, self.__RefreshPointAndRewardCallback)
  else
    if not (self._rewardNode).active then
      (self._rewardNode):Show()
      ;
      (self._rewardNode):RefreshADCRewardNode()
    end
  end
end

UIEventDailyChallenge.OnClickBuy = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if ((self._adcData):GetADCMainCfg()).unlock_item_max <= (self._adcData):GetADCKeyItemCount() then
    return 
  end
  local shopCfg = ControllerManager:GetController(ControllerTypeId.Shop)
  shopCfg:GetShopData((self._mainCfg).unlock_item_shop, function(shopData)
    -- function num : 0_7_0 , upvalues : self, _ENV
    if shopData == nil then
      (((self.ui).btn_Add).gameObject):SetActive(false)
      return 
    end
    local goodsData = shopData:GetShopGoodDataByItemId((self._mainCfg).unlock_item)
    if goodsData == nil or goodsData.isSoldOut then
      return 
    end
    local resIds = {}
    ;
    (table.insert)(resIds, goodsData.currencyId)
    if not (table.contain)(resIds, ConstGlobalItem.PaidItem) and (goodsData.currencyId == ConstGlobalItem.PaidSubItem or goodsData.currencyId == ConstGlobalItem.SkinTicket) then
      (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
      -- function num : 0_7_0_0 , upvalues : goodsData, resIds, self
      window:SlideIn()
      window:InitBuyFixedCountGood(1, goodsData, true, resIds, function()
        -- function num : 0_7_0_0_0 , upvalues : self
        self:__RefreshItemKey()
      end
)
    end
)
  end
)
end

UIEventDailyChallenge.__TimeCountdown = function(self)
  -- function num : 0_8 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._nextTime or 0 < PlayerDataCenter.timestamp then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._adcData)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_TimeTitle).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_EndTime).text = timeStr
      self._nextTime = expireTime
    end
    local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._nextTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_day).text = countdownStr
    if diff < 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIEventDailyChallenge.OnClickTickets = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_9_0 , upvalues : _ENV, self
    if win ~= nil then
      win:SetNotNeedAnyJump(true)
      win:InitCommonItemDetail((ConfigData.item)[(self._mainCfg).unlock_item])
    end
  end
)
end

UIEventDailyChallenge.OnClickADCClose = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (self._adcData):SetAdcOpend()
  self:Delete()
  UIManager:DeleteWindow(UIWindowTypeID.DungeonLevelDetail)
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIEventDailyChallenge.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__RefreshItemKeyCallback)
  MsgCenter:RemoveListener(eMsgEventId.ActivityDailyChallengeDungeonUpdate, self.__RefreshChallengeCallback)
  ;
  (base.OnDelete)(self)
end

return UIEventDailyChallenge

