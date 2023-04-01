-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessChipBagItem = class("UINWarChessChipBagItem", base)
local UINChipItem = require("Game.CommonUI.Item.UINChipItem")
UINWarChessChipBagItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChipItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._chipItem = (UINChipItem.New)()
  ;
  (self._chipItem):Init((self.ui).uINChipItem)
  self._onChipBagItemClick = BindCallback(self, self.OnChipBagItemClick)
end

UINWarChessChipBagItem.InitWCChipBagItem = function(self, chipData, onClickEvent)
  -- function num : 0_1
  self._onClickEvent = onClickEvent
  ;
  (self._chipItem):InitChipItem(chipData, true, self._onChipBagItemClick)
  local name = chipData:GetName()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ChipName).text = name
end

UINWarChessChipBagItem.OnChipBagItemClick = function(self)
  -- function num : 0_2
  if self._onClickEvent ~= nil then
    (self._onClickEvent)(self, (self._chipItem).chipData)
  end
end

UINWarChessChipBagItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessChipBagItem

