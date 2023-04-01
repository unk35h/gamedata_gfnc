-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINWarChessViewChipsChipItem = class("UINWarChessViewChipsChipItem", base)
UINWarChessViewChipsChipItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_chipItem, self, self.__OnClickItem)
end

UINWarChessViewChipsChipItem.InitWCViewChipChipItem = function(self, chipData, onClickFunc)
  -- function num : 0_1 , upvalues : base
  self.chipData = chipData
  ;
  (base.InitBaseEpChipUI)(self, chipData, false)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_QuailtyColor).color = (self.chipData):GetColor()
  self.onClickFunc = onClickFunc
  self:SetSelectUI(false)
  self:Show()
end

UINWarChessViewChipsChipItem.__OnClickItem = function(self)
  -- function num : 0_2
  if self.onClickFunc ~= nil then
    (self.onClickFunc)(self.chipData)
  end
  self:SetSelectUI(true)
end

UINWarChessViewChipsChipItem.SetSelectUI = function(self, isSelect)
  -- function num : 0_3
  self.isSelect = isSelect
  ;
  ((self.ui).obj_OnSelect):SetActive(isSelect)
end

UINWarChessViewChipsChipItem.OnDelete = function(self)
  -- function num : 0_4
end

return UINWarChessViewChipsChipItem

