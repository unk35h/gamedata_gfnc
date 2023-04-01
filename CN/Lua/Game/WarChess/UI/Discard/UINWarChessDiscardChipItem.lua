-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINWarChessDiscardChipItem = class("UINWarChessDiscardChipItem", base)
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
UINWarChessDiscardChipItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_storeItem, self, self.__OnStoreItemClicked)
end

UINWarChessDiscardChipItem.InitWCDiscardChipItem = function(self, chipData, discardPrice, MoneyIconId, clickAction)
  -- function num : 0_1 , upvalues : base, _ENV
  self.chipData = chipData
  ;
  ((self.ui).img_SellOut):SetActive(false)
  self:__ShowPrice(discardPrice, 0, MoneyIconId)
  ;
  (base.InitBaseEpChipUI)(self, self.chipData, true)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ChipTypeIcon).sprite = CRH:GetSprite((self.chipData):GetChipMarkIcon(), CommonAtlasType.ExplorationIcon)
  self.clickAction = clickAction
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
end

UINWarChessDiscardChipItem.__ShowPrice = function(self, price, discount, MoneyIconId)
  -- function num : 0_2 , upvalues : _ENV
  self.price = price
  local hasDiscount = false
  ;
  ((self.ui).discountNode):SetActive(hasDiscount)
  ;
  ((self.ui).originalPrice):SetActive(hasDiscount)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = price
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSpriteByItemId(MoneyIconId, false)
end

UINWarChessDiscardChipItem.SetStoreItemSelect = function(self, selected)
  -- function num : 0_3
  ((self.ui).img_OnSelect):SetActive(selected)
end

UINWarChessDiscardChipItem.__OnStoreItemClicked = function(self)
  -- function num : 0_4
  if self.clickAction ~= nil then
    (self.clickAction)(self)
  end
end

return UINWarChessDiscardChipItem

