-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRaffleDetailItem = class("UINRaffleDetailItem", UIBaseNode)
local base = UIBaseNode
UINRaffleDetailItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINRaffleDetailItem.InitRaffleDetailItem = function(self, itemCfg, count, weight)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_DropInfo):SetIndex(0, (LanguageUtil.GetLocaleText)(itemCfg.name), count)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rate).text = tostring(weight) .. "%"
end

return UINRaffleDetailItem

