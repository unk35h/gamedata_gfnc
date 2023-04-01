-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWATechConditionItem = class("UINWATechConditionItem", UIBaseNode)
local base = UIBaseNode
UINWATechConditionItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWATechConditionItem.InitStOConditonItem = function(self, text, isComplete)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Condition).text = text
  if isComplete then
    ((self.ui).img_Root):SetIndex(1)
  else
    ;
    ((self.ui).img_Root):SetIndex(0)
  end
end

UINWATechConditionItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechConditionItem

