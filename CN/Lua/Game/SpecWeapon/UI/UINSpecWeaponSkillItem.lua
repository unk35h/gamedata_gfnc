-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponSkillItem = class("UINSpecWeaponSkillItem", UIBaseNode)
local base = UIBaseNode
local UINBaseSkillItem = require("Game.CommonUI.Item.UINBaseSkillItem")
UINSpecWeaponSkillItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseSkillItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_info, self, self.OnClickItem)
  self.skillItem = (UINBaseSkillItem.New)()
  ;
  (self.skillItem):Init((self.ui).uINSkillItem)
end

UINSpecWeaponSkillItem.InitSpecWeaponSkilDes = function(self, skillData, des, resloader, callback)
  -- function num : 0_1
  (self.skillItem):InitBaseSkillItem(skillData, resloader)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkillName).text = skillData:GetName()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = des
  self._callback = callback
end

UINSpecWeaponSkillItem.OnClickItem = function(self)
  -- function num : 0_2
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UINSpecWeaponSkillItem

