-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessCoinDetail = class("UINWarChessCoinDetail", UIBaseNode)
local base = UIBaseNode
UINWarChessCoinDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessCoinDetail.InitCoinDetail = function(self, itemCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemConfig(itemCfg)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)(itemCfg.describe)
end

UINWarChessCoinDetail.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessCoinDetail

