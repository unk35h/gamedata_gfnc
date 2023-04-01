-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponStepItem = class("UINSpecWeaponStepItem", UIBaseNode)
local base = UIBaseNode
UINSpecWeaponStepItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickSpecWeaponStep)
end

UINSpecWeaponStepItem.BindSpecWeaponStep = function(self, callback)
  -- function num : 0_1
  self._callback = callback
end

UINSpecWeaponStepItem.InitSpecWeaponStep = function(self, stepId, specWeaponData)
  -- function num : 0_2
  self._stepId = stepId
  self._specWeaponData = specWeaponData
  ;
  ((self.ui).tex_NowLv):SetIndex(self._stepId - 1)
  self:RefreshSpecWeaponStep()
  self:OnSelectSpecWeaponStep(false)
end

UINSpecWeaponStepItem.RefreshSpecWeaponStep = function(self)
  -- function num : 0_3
  ((self.ui).img_lock):SetActive((self._specWeaponData):GetSpecWeaponCurStep() < self._stepId)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINSpecWeaponStepItem.OnSelectSpecWeaponStep = function(self, flag)
  -- function num : 0_4
  ((self.ui).obj_click):SetActive(flag)
end

UINSpecWeaponStepItem.OnClickSpecWeaponStep = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)(self._stepId)
  end
end

return UINSpecWeaponStepItem

