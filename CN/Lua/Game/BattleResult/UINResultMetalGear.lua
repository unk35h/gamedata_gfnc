-- params : ...
-- function num : 0 , upvalues : _ENV
local UINResultMetalGear = class("UINResultMetalGear", UIBaseNode)
UINResultMetalGear.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINResultMetalGear.InitBattleResultMetalGear = function(self, chipData)
  -- function num : 0_1 , upvalues : _ENV
  if chipData == nil then
    return 
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_SkillIcon).sprite = chipData:GetChipIconSprite()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = chipData:GetName()
  local showDesc = (CommonUtil.GetDetailDescribeSetting)(eGameSetDescType.chip)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Info).text = chipData:GetChipDescription(showDesc)
end

return UINResultMetalGear

