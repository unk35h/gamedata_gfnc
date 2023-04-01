-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtHeroFilterTypeToggle = class("UINFmtHeroFilterTypeToggle", UIBaseNode)
local base = UIBaseNode
UINFmtHeroFilterTypeToggle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).toggle, self, self.__OnToggle)
  self.defalutBgColor = ((self.ui).img_toggle).color
  self.unSelectBgColor = (Color.New)(0, 0, 0, 0)
end

UINFmtHeroFilterTypeToggle.InitFilterTypeToggle = function(self, index, callback)
  -- function num : 0_1
  self._callback = callback
  ;
  ((self.ui).tex_Text):SetIndex(index)
end

UINFmtHeroFilterTypeToggle.OnToggleHeroFilterType = function(self, flag)
  -- function num : 0_2
  if ((self.ui).toggle).isOn == flag then
    self:__OnToggle(flag)
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).toggle).isOn = flag
  end
end

UINFmtHeroFilterTypeToggle.__OnToggle = function(self, flag)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).img_toggle).color = self.defalutBgColor
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Text).text).color = Color.black
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_toggle).color = self.unSelectBgColor
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Text).text).color = Color.white
  end
  if flag then
    (self._callback)()
  end
end

return UINFmtHeroFilterTypeToggle

