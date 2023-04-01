-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeShopMidPageInfo = class("UINRecommeShopMidPageInfo", UIBaseNode)
local base = UIBaseNode
UINRecommeShopMidPageInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (self.gameObject):SetActive(false)
  self.payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
end

UINRecommeShopMidPageInfo.InitRecommeShopMidPageInfo = function(self, middleCfg)
  -- function num : 0_1
  local recommendId = (middleCfg.jump_arg)[2]
  self.middleData = (self.payGiftCtrl):GetPayGiftDataById(recommendId)
  self:ShowMidPageInfo(self.middleData)
end

UINRecommeShopMidPageInfo.ShowMidPageInfo = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  if data == nil then
    (self.gameObject):SetActive(false)
    return 
  end
  ;
  (self.gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((data.groupCfg).name)
  local showOldPrice, oldPrice = data:TryGetPayGiftOldPrice()
  if showOldPrice then
    (((self.ui).tex_OldPrice).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_OldPrice).text = self:GetShopMidPageInfoPriceStr(oldPrice)
  else
    ;
    (((self.ui).tex_OldPrice).gameObject):SetActive(false)
  end
  local priceNum = (data.defaultCfg).cur_price
  if not data:IsUseItemPay() and LanguageUtil.LanguageInt == eLanguageType.EN_US then
    priceNum = FormatNum(priceNum / 100)
  end
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrentPrice).text = self:GetShopMidPageInfoPriceStr(priceNum)
  local _, times, limitTimes = data:GetLimitBuyCount()
  local limitType = (data.defaultCfg).limit_type
  if type(limitType) ~= "number" or limitType < 1 or limitType > 4 then
    (((self.ui).img_Tag).gameObject):SetActive(false)
  else
    ;
    (((self.ui).img_Tag).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Tag):SetIndex(limitType - 1, tostring(limitTimes - times))
  end
end

UINRecommeShopMidPageInfo.GetShopMidPageInfoPriceStr = function(self, price)
  -- function num : 0_3 , upvalues : _ENV
  return ConfigData:GetTipContent(TipContent.RecommandShopPayPriceUnit, tostring(price))
end

return UINRecommeShopMidPageInfo

