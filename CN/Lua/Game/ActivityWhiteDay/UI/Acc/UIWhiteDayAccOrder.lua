-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayAccOrder = class("UIWhiteDayAccOrder", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UIWhiteDayAccOrder.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINBaseItemWithCount, _ENV
  self.accSelectNum = 0
  self.ticketNum = 0
  self.ticketAccTime = 0
  self.ticketItemId = nil
  self.orderItem = (UINBaseItemWithCount.New)()
  ;
  (self.orderItem):Init((self.ui).uINBaseItemWithCount)
  self.accTicketItem = (UINBaseItemWithCount.New)()
  ;
  (self.accTicketItem):Init((self.ui).uINBaseItemWithCount_ticket)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.__OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.__OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.__OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QuickBy, self, self.__OnClickQuickBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Plus, self, self.AddOne)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reduce, self, self.MinusOne)
  ;
  (((self.ui).inputField_count).onEndEdit):AddListener(BindCallback(self, self._OnInputFieldEndEdit))
  ;
  (((self.ui).btn_Plus).onPress):AddListener(BindCallback(self, self.PressAdd))
  ;
  (((self.ui).btn_Reduce).onPress):AddListener(BindCallback(self, self.PressMinus))
  self.__onItemUpdate = BindCallback(self, self.__OnItemUpdate)
end

UIWhiteDayAccOrder.InitWDAccOrder = function(self, AWDCtrl, AWDLineData)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  self.AWDData = AWDLineData:GetAWDData()
  self.ticketAccTime = (self.AWDData):GetWDAccItemAcctime()
  self.ticketItemId = (self.AWDData):GetWDAccItemId()
  self.ticketNum = PlayerDataCenter:GetItemCount(self.ticketItemId)
  self:__RefreshItemUI()
  self:__RefreshQuickBuy()
  self:__AfterSelectNumChange()
  self:UpdateWDAccTimeChange()
  self.lineTimerId = TimerManager:StartTimer(1, self.__OnWDTimeUpdate, self, false, nil, true)
end

UIWhiteDayAccOrder.__RefreshItemUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local WDOrderData = (self.AWDLineData):GetWDProductionOrderData()
  local orderItemCfg, itemNum = WDOrderData:GetWDOrderItemIdAndNum()
  ;
  (self.orderItem):InitItemWithCount(orderItemCfg, itemNum)
  local itemCfg = (ConfigData.item)[self.ticketItemId]
  local wareHousNum = PlayerDataCenter:GetItemCount(self.ticketItemId)
  ;
  (self.accTicketItem):InitItemWithCount(itemCfg, wareHousNum)
end

UIWhiteDayAccOrder.__RefreshQuickBuy = function(self)
  -- function num : 0_3
  local isUnlockQuickBuy = (self.AWDData):GetWDCouldBuyAccItem()
  ;
  (((self.ui).btn_QuickBy).gameObject):SetActive(isUnlockQuickBuy)
end

UIWhiteDayAccOrder.__OnWDTimeUpdate = function(self)
  -- function num : 0_4
  self:UpdateWDAccTimeChange()
  self:_OnInputFieldEndEdit(self.accSelectNum)
end

UIWhiteDayAccOrder.UpdateWDAccTimeChange = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local leftTime = (self.AWDLineData):GetInProductionLeftTime()
  local accTime = self.accSelectNum * self.ticketAccTime
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CurTime).text = TimeUtil:TimestampToTime(leftTime, false, false, true)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_SpeedupTime).text = TimeUtil:TimestampToTime((math.clamp)(leftTime - accTime, 0, math.maxinteger), false, false, true)
end

UIWhiteDayAccOrder.__AfterSelectNumChange = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self:UpdateWDAccTimeChange()
  local numStr = tostring(self.accSelectNum)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).inputField_count).text = numStr
  ;
  ((self.ui).tex_Info):SetIndex(0, numStr)
end

UIWhiteDayAccOrder.AddOne = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.ticketNum < self.accSelectNum + 1 then
    return 
  end
  local leftTime = (self.AWDLineData):GetInProductionLeftTime()
  local leftTimeNeedNum = (math.ceil)(leftTime / self.ticketAccTime)
  if leftTimeNeedNum < self.accSelectNum + 1 then
    return 
  end
  AudioManager:PlayAudioById(1200)
  self.accSelectNum = self.accSelectNum + 1
  self:__AfterSelectNumChange()
end

UIWhiteDayAccOrder.PressAdd = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.accSelectNum == self.ticketNum then
    return 
  end
  local pressedTime = ((self.ui).btn_Plus):GetPressedTime()
  local addNum = (math.ceil)(pressedTime * pressedTime / 5)
  local leftTime = (self.AWDLineData):GetInProductionLeftTime()
  local leftTimeNeedNum = (math.ceil)(leftTime / self.ticketAccTime)
  do
    if self.ticketNum < self.accSelectNum + addNum or leftTimeNeedNum < self.accSelectNum + addNum then
      local remainNum = self.ticketNum - self.accSelectNum
      addNum = (math.min)(remainNum, leftTimeNeedNum - self.accSelectNum)
      if addNum <= 0 then
        return 
      end
    end
    AudioManager:PlayAudioById(1200)
    self.accSelectNum = self.accSelectNum + addNum
    self:__AfterSelectNumChange()
  end
end

UIWhiteDayAccOrder.MinusOne = function(self)
  -- function num : 0_9 , upvalues : _ENV
  AudioManager:PlayAudioById(1200)
  if self.accSelectNum - 1 < 0 then
    local leftTime = (self.AWDLineData):GetInProductionLeftTime()
    local leftTimeNeedNum = (math.ceil)(leftTime / self.ticketAccTime)
    local num = (math.min)(self.ticketNum, leftTimeNeedNum)
    self.accSelectNum = num
    self:__AfterSelectNumChange()
    return 
  end
  do
    self.accSelectNum = self.accSelectNum - 1
    self:__AfterSelectNumChange()
  end
end

UIWhiteDayAccOrder.PressMinus = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.accSelectNum == 0 then
    return 
  end
  local pressedTime = ((self.ui).btn_Reduce):GetPressedTime()
  local minusNum = (math.ceil)(pressedTime * pressedTime / 10)
  if self.accSelectNum - minusNum <= 0 then
    self.accSelectNum = 0
  else
    self.accSelectNum = self.accSelectNum - minusNum
    AudioManager:PlayAudioById(1200)
  end
  self:__AfterSelectNumChange()
end

UIWhiteDayAccOrder._OnInputFieldEndEdit = function(self, value)
  -- function num : 0_11 , upvalues : _ENV
  local num = 0
  if type(value) == "number" then
    num = value
  else
    if not (string.IsNullOrEmpty)(value) then
      num = tonumber(value)
    end
  end
  local leftTime = (self.AWDLineData):GetInProductionLeftTime()
  local leftTimeNeedNum = (math.ceil)(leftTime / self.ticketAccTime)
  if self.ticketNum <= num or leftTimeNeedNum < num then
    num = (math.min)(self.ticketNum, leftTimeNeedNum)
  end
  if self.accSelectNum == num then
    return 
  end
  self.accSelectNum = num
  self:__AfterSelectNumChange()
end

UIWhiteDayAccOrder.__OnClickConfirm = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.accSelectNum <= 0 then
    return 
  end
  local actFrameId = (self.AWDData):GetActFrameId()
  local lineId = (self.AWDLineData):GetWDLDLineID()
  ;
  (self.AWDCtrl):WDAccLineOrder(actFrameId, self.ticketItemId, self.accSelectNum, lineId, function()
    -- function num : 0_12_0 , upvalues : self, _ENV
    self.accSelectNum = 0
    self:__AfterSelectNumChange()
    ;
    (UIUtil.OnClickBackByUiTab)(self)
  end
)
end

UIWhiteDayAccOrder.__OnClickQuickBuy = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local ShopEnum = require("Game.Shop.ShopEnum")
  local quickBuyData = (ShopEnum.eQuickBuy).whiteDayAcc
  local cfg = (self.AWDData):GetWDCfg()
  local shopId = cfg.speed_shop
  local shelfId = cfg.speed_shelve
  local ctrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ctrl:GetShopData(shopId, function(shopData)
    -- function num : 0_13_0 , upvalues : shelfId, _ENV, quickBuyData
    local goodData = (shopData.shopGoodsDic)[shelfId]
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
      -- function num : 0_13_0_0 , upvalues : _ENV, goodData, quickBuyData
      if win == nil then
        error("can\'t open QuickBuy win")
        return 
      end
      win:SlideIn()
      win:InitBuyTarget(goodData, nil, true, quickBuyData.resourceIds)
      win:OnClickAdd(true)
    end
)
  end
)
end

UIWhiteDayAccOrder.__OnItemUpdate = function(self, itemUpdate)
  -- function num : 0_14 , upvalues : _ENV
  if self.ticketItemId == nil or itemUpdate[self.ticketItemId] == nil then
    return 
  end
  self.ticketNum = PlayerDataCenter:GetItemCount(self.ticketItemId)
  self:__RefreshItemUI()
end

UIWhiteDayAccOrder.BackAction = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  self.accSelectNum = 0
  self:Hide()
end

UIWhiteDayAccOrder.__OnClickClose = function(self)
  -- function num : 0_16 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIWhiteDayAccOrder.OnShow = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  ;
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  ;
  (base.OnShow)(self)
end

UIWhiteDayAccOrder.OnHide = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  ;
  (base.OnHide)(self)
end

UIWhiteDayAccOrder.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, base
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayAccOrder

