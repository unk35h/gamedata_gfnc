-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTimeLimitShopBar = class("UINTimeLimitShopBar", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINTimeLimitShopBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__RefreshTimeLimit = BindCallback(self, self.RefreshTimeLimit)
end

UINTimeLimitShopBar.OnShow = function(self)
  -- function num : 0_1
  (self.shopCtrl):AddShopTimerCallback(self.__RefreshTimeLimit, "timeLimitBar")
end

UINTimeLimitShopBar.HeadBarCommonInit = function(self, uiShop)
  -- function num : 0_2
  self.OpenShopePageCallback = uiShop.__OnClickRefreshShop
end

UINTimeLimitShopBar.RefreshHeadBarNode = function(self, shopData, shopCfg)
  -- function num : 0_3
  if shopCfg ~= nil then
    self:SetShopId(shopCfg.id)
    return 
  end
  self:SetShopId(shopData.shopId)
end

UINTimeLimitShopBar.SetShopId = function(self, shopId)
  -- function num : 0_4
  self.shopId = shopId
  local hav, inTime, outTime = (self.shopCtrl):GetIsThisShopHasTimeLimit(self.shopId)
  if hav then
    self.outTime = outTime
  else
    self.outTime = nil
  end
  self:RefreshTimeLimit()
  self:RefreshTxtDes()
end

UINTimeLimitShopBar.RefreshTxtDes = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local desId = ((ConfigData.shop)[self.shopId]).info_des
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  if desId == 0 then
    ((self.ui).tex_Adv).text = nil
    return 
  end
  local desTxt = ((ConfigData.shop_des)[desId]).info_des
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Adv).text = (LanguageUtil.GetLocaleText)(desTxt)
end

UINTimeLimitShopBar.RefreshTimeLimit = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.outTime == nil then
    return 
  end
  local remaindTime = self.outTime - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if h < 10 or not tostring(h) then
    local hStr = "0" .. tostring(h)
  end
  if m < 10 or not tostring(m) then
    local mStr = "0" .. tostring(m)
  end
  if s < 10 or not tostring(s) then
    local sStr = "0" .. tostring(s)
  end
  if d > 0 then
    ((self.ui).tex_Timer):SetIndex(0, tostring(d), hStr, mStr, sStr)
  else
    ;
    ((self.ui).tex_Timer):SetIndex(1, hStr, mStr, sStr)
  end
end

UINTimeLimitShopBar.OnHide = function(self)
  -- function num : 0_7 , upvalues : base
  (self.shopCtrl):RemoveShopTimerCallback(self.__RefreshTimeLimit)
  ;
  (base.OnHide)(self)
end

UINTimeLimitShopBar.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
end

return UINTimeLimitShopBar

