-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleMetalGear = class("UINBattleMetalGear", UIBaseNode)
UINBattleMetalGear.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBattleMetalGear.InitBattleGridMetalGear = function(self, dynEffectGrid)
  -- function num : 0_1
  if dynEffectGrid == nil then
    return 
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_SkillIcon).sprite = dynEffectGrid:GetGridIconSprite()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = dynEffectGrid:GetGridName()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Info).text = dynEffectGrid:GetGridInfo()
end

return UINBattleMetalGear

