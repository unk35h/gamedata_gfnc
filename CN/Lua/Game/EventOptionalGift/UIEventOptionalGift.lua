-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventOptionalGift = class("UIEventOptionalGift", UIBaseWindow)
local base = UIBaseWindow
local UINEventOptionalGift = require("Game.EventOptionalGift.UINEventOptionalGift")
local UINEventOptionGiftSelect = require("Game.EventOptionalGift.UINEventOptionGiftSelect")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
UIEventOptionalGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventOptionalGift
  (UIUtil.AddButtonListener)((self.ui).tip, self, self.OnClickTip)
  self._itemPool = (UIItemPool.New)(UINEventOptionalGift, (self.ui).giftItem)
  ;
  ((self.ui).giftItem):SetActive(false)
  self.__OnSelectCallback = BindCallback(self, self.__OnSelect)
  self.__RefreshGiftChangeCallback = BindCallback(self, self.__RefreshGiftChange)
  MsgCenter:AddListener(eMsgEventId.PayGiftChange, self.__RefreshGiftChangeCallback)
end

UIEventOptionalGift.InitEventOptionalGift = function(self, id)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum, ActivityFrameUtil
  self._actGiftCfg = (ConfigData.activity_gift)[id]
  local actFrame = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._actInfo = actFrame:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Gift, id)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftName).text = tostring((self._actInfo):GetActivityFrameName())
  ;
  ((self.ui).tex_Number):SetIndex(0, ConfigData:GetTipContent((self._actGiftCfg).subtitle))
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent((self._actGiftCfg).desc)
  local _, timeStr = (ActivityFrameUtil.GetShowEndTimeStr)(self._actInfo)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = timeStr
  ;
  (self._itemPool):HideAll()
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  for i,giftId in ipairs((self._actGiftCfg).giftlist) do
    local payGiftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    local item = (self._itemPool):GetOne()
    payGiftInfo:CleanSelfSelectInfo()
    item:InitOptionalGift(payGiftInfo, self.__OnSelectCallback)
  end
  self._ruleId = ((ConfigData.activity)[(self._actInfo):GetActivityFrameId()]).rule_id
end

UIEventOptionalGift.OnClickTip = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(win)
    -- function num : 0_2_0 , upvalues : self
    if win ~= nil then
      win:InitCommonInfoByRule(self._ruleId, true)
    end
  end
)
end

UIEventOptionalGift.__OnSelect = function(self, payGiftInfo, item)
  -- function num : 0_3 , upvalues : UINEventOptionGiftSelect, _ENV
  if self._selectWindow == nil then
    ((self.ui).window):SetActive(true)
    self._selectWindow = (UINEventOptionGiftSelect.New)()
    ;
    (self._selectWindow):Init((self.ui).window)
  end
  ;
  (self._selectWindow):Show()
  ;
  (self._selectWindow):InitEventOptionGiftSelect(payGiftInfo, function(payGiftInfo, itemIds, itemNums)
    -- function num : 0_3_0 , upvalues : _ENV, item
    local params = {}
    for i,itemId in ipairs(itemIds) do
      (table.insert)(params, {param = itemId})
    end
    payGiftInfo:SetSelfSelectInfo(itemIds, itemNums, params)
    item:RefreshOptionalGift()
  end
)
end

UIEventOptionalGift.__RefreshGiftChange = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local reddot = (self._actInfo):GetActivityReddotNode()
  local reddoutCount = 0
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  for i,giftid in ipairs((self._actGiftCfg).giftlist) do
    local gift = payGiftCtrl:GetPayGiftDataById(giftid)
    if gift ~= nil and not gift:IsSoldOut() and gift:IsFreeGift() then
      reddoutCount = 1
      break
    end
  end
  do
    reddot:SetRedDotCount(reddoutCount)
  end
end

UIEventOptionalGift.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.PayGiftChange, self.__RefreshGiftChangeCallback)
  ;
  (base.OnDelete)(self)
end

return UIEventOptionalGift

