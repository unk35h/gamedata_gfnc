-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UIEpUpgradeRoomItem = class("UIEpUpgradeRoomItem", base)
UIEpUpgradeRoomItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_chipItem, self, self.__OnChipItemClicked)
end

UIEpUpgradeRoomItem.InitUpgradeRoomItem = function(self, roomId, moneyIconId, price, chipData, clickAction)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitBaseEpChipUI)(self, chipData, true)
  self.upgradeRoomId = roomId
  self.chipData = chipData
  self.index = chipData.idx
  self.clickAction = clickAction
  self.upgradePrice = price
  self:__ShowPrice(self.upgradePrice, moneyIconId)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_ChipTypeIcon).sprite = CRH:GetSprite(chipData:GetChipMarkIcon(), CommonAtlasType.ExplorationIcon)
  ;
  ((self.ui).Obj_LevelMax):SetActive((self.chipData):IsChipFullLevel())
end

UIEpUpgradeRoomItem.__ShowPrice = function(self, price, MoneyIconId)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).originalPrice):SetActive(false)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = tostring(price)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSprite(MoneyIconId)
end

UIEpUpgradeRoomItem.SetChipItemSelect = function(self, selected)
  -- function num : 0_3
  ((self.ui).img_OnSelect):SetActive(selected)
end

UIEpUpgradeRoomItem.__OnChipItemClicked = function(self)
  -- function num : 0_4
  if self.clickAction ~= nil then
    (self.clickAction)(self)
  end
end

UIEpUpgradeRoomItem.GetChipItemName = function(self)
  -- function num : 0_5
  return (self.chipData):GetName()
end

UIEpUpgradeRoomItem.GetChipItem = function(self)
  -- function num : 0_6
  return self.chipItem
end

return UIEpUpgradeRoomItem

