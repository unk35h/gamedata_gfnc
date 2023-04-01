-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventOptionalGift = class("UINEventOptionalGift", UIBaseNode)
local base = UIBaseNode
local UINOptionGiftBoxItem = require("Game.EventOptionalGift.UINOptionGiftBoxItem")
local cs_MessageCommon = CS.MessageCommon
UINEventOptionalGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINOptionGiftBoxItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINOptionGiftBoxItem, (self.ui).baseItemScale)
  ;
  ((self.ui).baseItemScale):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  self.__OnSelectCustomCallback = BindCallback(self, self.__OnSelectCustom)
end

UINEventOptionalGift.InitOptionalGift = function(self, giftInfo, selectCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._giftInfo = giftInfo
  self._selectCallback = selectCallback
  ;
  ((self.ui).img_Off):SetActive(((self._giftInfo).groupCfg).tagType == 1)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  if ((self._giftInfo).groupCfg).tagType == 1 then
    ((self.ui).tex_off).text = tostring(((self._giftInfo).groupCfg).tagValue // 10)
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_item).sprite = CRH:GetSpriteByItemId((((self._giftInfo).defaultCfg).awardIds)[1])
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = "x" .. tostring((((self._giftInfo).defaultCfg).awardCounts)[1])
  ;
  (self._itemPool):HideAll()
  local customCfg = (self._giftInfo):GetSelectGiftCustomCfg()
  for i = 1, (self._giftInfo):GetSelectGiftCustomCount() do
    local item = (self._itemPool):GetOne()
    item:InitOptionGiftSelect(i, self._giftInfo, self.__OnSelectCustomCallback)
  end
  if ((self._giftInfo).defaultCfg).cur_price == 0 then
    ((self.ui).tex_Price):SetIndex(0)
  else
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
    local payStr = payCtrl:GetPayPriceShow(((self._giftInfo).defaultCfg).payId)
    ;
    ((self.ui).tex_Price):SetIndex(1, payStr)
  end
  self:__RefreshSouldState()
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINEventOptionalGift.RefreshOptionalGift = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).img_SoldOut):SetActive((self._giftInfo):IsSoldOut())
  for i,v in ipairs((self._itemPool).listItem) do
    v:RefreshOptionGiftSelect()
  end
  self:__RefreshSouldState()
end

UINEventOptionalGift.__RefreshSouldState = function(self)
  -- function num : 0_3
  local soldOut = (self._giftInfo):IsSoldOut()
  ;
  ((self.ui).img_SoldOut):SetActive(soldOut)
  ;
  ((self.ui).tex_Buy):SetIndex(soldOut and 1 or 0)
  ;
  ((self.ui).bottom):SetIndex(soldOut and 1 or 0)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).reward).alpha = soldOut and 0.7 or 1
end

UINEventOptionalGift.__OnSelectCustom = function(self, index, item)
  -- function num : 0_4
  if (self._giftInfo):IsSoldOut() then
    return 
  end
  if self._selectCallback ~= nil then
    (self._selectCallback)(self._giftInfo, self)
  end
end

UINEventOptionalGift.OnClickBuy = function(self)
  -- function num : 0_5 , upvalues : cs_MessageCommon, _ENV
  if (self._giftInfo):IsSoldOut() then
    return 
  end
  if not (self._giftInfo):GetSelfSelectGiftIsSelected() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(423))
    return 
  end
  local giftCfg = (self._giftInfo).defaultCfg
  local params = (self._giftInfo):GetSelfSelectGiftParams()
  ;
  (ControllerManager:GetController(ControllerTypeId.PayGift)):SendBuyGifit(giftCfg, params, function()
    -- function num : 0_5_0 , upvalues : self, _ENV
    (self._giftInfo):CleanSelfSelectInfo()
    if not IsNull(self.transform) then
      self:RefreshOptionalGift()
    end
  end
)
end

return UINEventOptionalGift

