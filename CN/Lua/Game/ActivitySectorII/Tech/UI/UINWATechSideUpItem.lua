-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWATechSideUpItem = class("UINWATechSideUpItem", UIBaseNode)
local base = UIBaseNode
UINWATechSideUpItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWATechSideUpItem.RefreshWATechSideUpItem = function(self, isUnlocked, isMaxLevel, shortDes, valueDes, nextLevelValue)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R6 in 'UnsetPending'

  ((self.ui).tex_Name).text = shortDes
  if isMaxLevel or valueDes == nextLevelValue then
    ((self.ui).tex_Value):SetIndex(0, valueDes)
  else
    if not isUnlocked then
      ((self.ui).tex_Value):SetIndex(2, valueDes)
    else
      ;
      ((self.ui).tex_Value):SetIndex(1, valueDes, nextLevelValue)
    end
  end
end

UINWATechSideUpItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechSideUpItem

