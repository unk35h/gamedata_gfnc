-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseEpChipItem = class("UINBaseEpChipItem", UIBaseNode)
local base = UIBaseNode
local UINChipItem = require("Game.CommonUI.Item.UINChipItem")
UINBaseEpChipItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBaseEpChipItem.InitBaseEpChipUI = function(self, chipData, showCount)
  -- function num : 0_1 , upvalues : UINChipItem
  self.chipItem = (UINChipItem.New)()
  ;
  (self.chipItem):Init((self.ui).chipItem)
  ;
  (self.chipItem):InitChipItem(chipData, showCount)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_QuailtyColor).color = chipData:GetColor()
  self:_ShowChipSuitIcon(chipData)
end

UINBaseEpChipItem._ShowChipSuitIcon = function(self, chipData)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_SuitIcon).enabled = false
  local suitCfg = chipData:TryGetSuitCfg()
  if suitCfg == nil then
    return 
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_SuitIcon).enabled = true
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_SuitIcon).sprite = CRH:GetSprite(suitCfg.tag_icon, CommonAtlasType.ExplorationIcon)
end

UINBaseEpChipItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINBaseEpChipItem

