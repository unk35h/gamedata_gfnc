-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponPointItem = class("UINSpecWeaponPointItem", UIBaseNode)
local base = UIBaseNode
UINSpecWeaponPointItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickPoint)
end

UINSpecWeaponPointItem.InitSpecWeaponPoint = function(self, level, callback)
  -- function num : 0_1
  self._level = level
  self._callback = callback
end

UINSpecWeaponPointItem.ForbidSpecWeaponBtn = function(self, flag)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).btn_root).enabled = flag
end

UINSpecWeaponPointItem.PlaySpecWeaponPoint = function(self)
  -- function num : 0_3
  ((self.ui).tween_root):DORewind()
  ;
  ((self.ui).tween_root):DOPlayForward()
end

UINSpecWeaponPointItem.OnClickPoint = function(self)
  -- function num : 0_4
  if self._callback then
    (self._callback)(self._level)
  end
end

UINSpecWeaponPointItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  ((self.ui).tween_root):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINSpecWeaponPointItem

