-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINChipDisplaceItem = class("UINChipDisplaceItem", base)
UINChipDisplaceItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_chipItem, self, self.OnClickItem)
end

UINChipDisplaceItem.InitItem = function(self, idx, chipData, onClickEvent)
  -- function num : 0_1 , upvalues : base, _ENV
  self.idx = idx
  self.chipData = chipData
  self.onClickEvent = onClickEvent
  ;
  (base.InitBaseEpChipUI)(self, chipData, true)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
  ;
  ((self.ui).tex_ChipLevel):SetIndex(0, tostring((self.chipData):GetCount()))
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_ChipTypeIcon).sprite = CRH:GetSprite(chipData:GetChipMarkIcon(), CommonAtlasType.ExplorationIcon)
end

UINChipDisplaceItem.OnClickItem = function(self)
  -- function num : 0_2
  if self.onClickEvent ~= nil then
    (self.onClickEvent)(self.idx)
  end
end

UINChipDisplaceItem.SetItemSelectState = function(self, isAllDisplace, isSelect)
  -- function num : 0_3
  local active = isAllDisplace and true or false
  ;
  ((self.ui).img_OnSelect):SetActive(active)
  local alpha = (isAllDisplace or isSelect) and 1 or 0.5
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = alpha
end

UINChipDisplaceItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINChipDisplaceItem

