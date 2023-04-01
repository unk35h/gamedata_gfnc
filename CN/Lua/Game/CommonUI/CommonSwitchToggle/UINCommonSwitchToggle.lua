-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonSwitchToggle = class("UINCommonSwitchToggle", UIBaseNode)
local base = UIBaseNode
UINCommonSwitchToggle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if (self.ui).btn_root ~= nil then
    (UIUtil.AddButtonListener)((self.ui).btn_root, self, self._onClickRoot)
  end
  self._autoSetValue = true
end

UINCommonSwitchToggle.InitCommonSwitchToggle = function(self, isOn, changeValueFunc)
  -- function num : 0_1
  self.changeValueFunc = changeValueFunc
  self:SetCommonSwitchToggleValue(isOn, false)
  self:_ResetSwitchTween(isOn)
end

UINCommonSwitchToggle.CommonSwitchTogAutoSetValue = function(self, auto)
  -- function num : 0_2
  self._autoSetValue = auto
end

UINCommonSwitchToggle.SetCommonSwitchToggleValue = function(self, isOn, withoutTween)
  -- function num : 0_3 , upvalues : _ENV
  if not isOn then
    isOn = false
  end
  if self._isOn == isOn then
    return 
  end
  self._isOn = isOn
  ;
  ((self.ui).tex_State):SetIndex(IsNull((self.ui).tex_State) or (isOn and 1) or 0)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Buttom).color = ((self.ui).color_toggleBg)[isOn and 2 or 1]
  if not withoutTween then
    self:_SwitchTween(isOn)
  end
end

UINCommonSwitchToggle._onClickRoot = function(self)
  -- function num : 0_4
  local isOn = not self._isOn
  if self.changeValueFunc ~= nil then
    (self.changeValueFunc)(isOn)
  end
  if self._autoSetValue then
    self:SetCommonSwitchToggleValue(isOn)
  end
end

UINCommonSwitchToggle._ResetSwitchTween = function(self, isOn)
  -- function num : 0_5
  if isOn then
    ((self.ui).dt_Icon):DORewind()
  else
    ;
    ((self.ui).dt_Icon):DOComplete()
  end
end

UINCommonSwitchToggle._SwitchTween = function(self, isOn)
  -- function num : 0_6
  if isOn then
    ((self.ui).dt_Icon):DOPlayBackwards()
  else
    ;
    ((self.ui).dt_Icon):DOPlayForward()
  end
end

UINCommonSwitchToggle.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINCommonSwitchToggle

