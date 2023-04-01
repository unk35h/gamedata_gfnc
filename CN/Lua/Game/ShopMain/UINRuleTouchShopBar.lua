-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRuleTouchShopBar = class("UINInfoBtnShopBar", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
UINRuleTouchShopBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rule, self, self._OnClickRuleBtn)
end

UINRuleTouchShopBar.HeadBarCommonInit = function(self, uiShop)
  -- function num : 0_1
end

UINRuleTouchShopBar.RefreshHeadBarNode = function(self, shopData, shopCfg)
  -- function num : 0_2 , upvalues : _ENV
  local shopId = shopData.shopId
  local desId = ((ConfigData.shop)[shopId]).info_des
  if desId == 0 then
    return 
  end
  local desTxt = ((ConfigData.shop_des)[desId]).info_des
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Adv).text = (LanguageUtil.GetLocaleText)(desTxt)
  self.ruleInfoId = ((ConfigData.shop_des)[desId]).info_rule
end

UINRuleTouchShopBar._OnClickRuleBtn = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_3_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitCommonInfoByRule(self.ruleInfoId, true)
  end
)
end

UINRuleTouchShopBar.OnHide = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnHide)(self)
end

UINRuleTouchShopBar.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINRuleTouchShopBar

