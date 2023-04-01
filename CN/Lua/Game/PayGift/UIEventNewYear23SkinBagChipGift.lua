-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChipGift = require("Game.PayGift.UIChipGift")
local UIEventNewYear23SkinBagChipGift = class("UIEventNewYear23SkinBagChipGift", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local CS_Resloader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
local JumpManager = require("Game.Jump.JumpManager")
UIEventNewYear23SkinBagChipGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount, JumpManager
  (UIUtil.SetTopStatus)(self, self.OnBackChipGift, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).backGround, self, self.OnClickCloseBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Popup, self, self.OnTogIgnore)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).obj_item)
  ;
  ((self.ui).obj_item):SetActive(false)
  self._lastCouldUseItemJump = JumpManager.couldUseItemJump
  JumpManager.couldUseItemJump = false
end

UIEventNewYear23SkinBagChipGift.InitSkinBag = function(self, giftInfo, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._giftInfo = giftInfo
  self._callback = callback
  self.rewardIds = ((self._giftInfo).defaultCfg).awardIds
  self.rewardCounts = ((self._giftInfo).defaultCfg).awardCounts
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  local flag, _, endTime = (self._giftInfo):IsUnlockTimeCondition()
  if flag and endTime > 0 then
    ((self.ui).time):SetActive(true)
    self.timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_1_0 , upvalues : self
    self:__RefreshTime()
  end
, self)
    self:__RefreshTime()
  else
    ;
    ((self.ui).time):SetActive(false)
  end
  local payId = ((self._giftInfo).defaultCfg).payId
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
  local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Price).text = priceStr
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).des)
  ;
  (self._itemPool):HideAll()
  local itemId = 0
  local itemNum = 0
  for iIndex = 1, #self.rewardIds do
    itemId = (self.rewardIds)[iIndex]
    itemNum = (self.rewardCounts)[iIndex]
    local itemCfg = (ConfigData.item)[itemId]
    local item = (self._itemPool):GetOne()
    item:InitItemWithCount(itemCfg, itemNum, nil)
  end
end

UIEventNewYear23SkinBagChipGift.__RefreshTime = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local _, _, endTime = (self._giftInfo):IsUnlockTimeCondition()
  local diff = endTime - PlayerDataCenter.timestamp
  if diff <= 0 then
    if self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
    ;
    ((self.ui).tex_Time):SetIndex(3, "0")
    return 
  end
  local d = (math.floor)(diff / 86400)
  diff = diff % 86400
  local h = (math.floor)(diff / 3600)
  diff = diff % 3600
  local m = (math.floor)(diff / 60)
  local s = (math.floor)(diff % 60)
  if d > 0 then
    ((self.ui).tex_Time):SetIndex(0, tostring(d), tostring(h), tostring(m))
  else
    if h > 0 then
      ((self.ui).tex_Time):SetIndex(1, tostring(h), tostring(m))
    else
      if m > 0 then
        ((self.ui).tex_Time):SetIndex(2, tostring(m), tostring(s))
      else
        ;
        ((self.ui).tex_Time):SetIndex(3, tostring(s))
      end
    end
  end
end

UIEventNewYear23SkinBagChipGift.OnClickBuy = function(self)
  -- function num : 0_3 , upvalues : CS_MessageCommon, _ENV
  if not (self._giftInfo):IsUnlock() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7208))
    return 
  end
  local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  giftCtrl:SendBuyGifit((self._giftInfo).defaultCfg, nil, function()
    -- function num : 0_3_0 , upvalues : self
    self:OnClickCloseBtn()
  end
)
end

UIEventNewYear23SkinBagChipGift.OnTogIgnore = function(self, value)
  -- function num : 0_4
  ((self.ui).img_Select):SetActive(value)
end

UIEventNewYear23SkinBagChipGift.OnClickCloseBtn = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIEventNewYear23SkinBagChipGift.OnBackChipGift = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if ((self.ui).tog_Popup).isOn then
    local time = TimeUtil:TimestampToDate((math.floor)(TimeUtil:TimpApplyLogicOffset(PlayerDataCenter.timestamp)))
    time.hour = 0
    time.min = 0
    time.sec = 0
    local endTimeStamp = TimeUtil:DateToTimestamp(time) + 86400 + 3600 * TimeUtil:GetDayPassTime()
    local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    userData:SetChipGiftPopIgnore(((self._giftInfo).groupCfg).id, PlayerDataCenter.timestamp, endTimeStamp)
  end
  do
    self:Delete()
    if self._callback ~= nil then
      (self._callback)()
    end
  end
end

UIEventNewYear23SkinBagChipGift.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base, _ENV, JumpManager
  (base.OnDelete)(self)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  JumpManager.couldUseItemJump = self._lastCouldUseItemJump
end

return UIEventNewYear23SkinBagChipGift

