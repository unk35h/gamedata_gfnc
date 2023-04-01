-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINChipSmallItem = class("UINChipSmallItem", base)
UINChipSmallItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINChipSmallItem.InitChipSmallItem = function(self, chipData)
  -- function num : 0_1 , upvalues : _ENV
  local color = chipData:GetColor()
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Quality).color = color
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  if chipData:IsConsumeSkillChip() then
    ((self.ui).img_Icon).sprite = CRH:GetSprite(chipData:GetIcon(), CommonAtlasType.SkillIcon)
  else
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite(chipData:GetIcon())
  end
end

return UINChipSmallItem

