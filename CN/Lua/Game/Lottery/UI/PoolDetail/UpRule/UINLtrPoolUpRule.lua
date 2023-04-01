-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLtrPoolUpRule = class("UINLtrPoolUpRule", UIBaseNode)
local base = UIBaseNode
UINLtrPoolUpRule.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINLtrPoolUpRule.InitLtrPoolUpRule = function(self, poolCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Des1Title).text = (LanguageUtil.GetLocaleText)(poolCfg.up_title)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Rule).text = (LanguageUtil.GetLocaleText)(poolCfg.up_des)
end

UINLtrPoolUpRule.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINLtrPoolUpRule

