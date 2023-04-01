-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINEpChipDiscardItem = class("UINEpChipDiscardItem", base)
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
UINEpChipDiscardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_storeItem, self, self.__OnStoreItemClicked)
end

UINEpChipDiscardItem.InitDiscardChipItem = function(self, discardId, chipData, clickAction, dynPlayer)
  -- function num : 0_1 , upvalues : _ENV
  self:__InitDiscardChipDefault(discardId, chipData, clickAction, dynPlayer)
  self.price = ConfigData:CalculateEpChipDiscardSalePrice(discardId, ((self.chipData).chipBattleData).level, (self.chipData):GetChipBuyPrice(ExplorationManager:GetEpModuleTypeCfgId(), true), self.dynPlayer)
  self:__showSellPrice(((ConfigData.item)[(self.discardCfg).discard_scaleId]).icon)
end

UINEpChipDiscardItem.InitDiscardChipItemInSellout = function(self, discardId, chipData, clickAction, dynPlayer)
  -- function num : 0_2 , upvalues : _ENV
  self:__InitDiscardChipDefault(discardId, chipData, clickAction, dynPlayer)
  local epTypeCfg = ExplorationManager:GetEpTypeCfg()
  local buyPrice = chipData:GetChipBuyPrice(ExplorationManager:GetEpModuleTypeCfgId(), true)
  self.price = ConfigData:CalculateEpChipSalePrice(epTypeCfg.store_pool, chipData:GetCount(), buyPrice, ExplorationManager:GetDynPlayer())
  self:__showSellPrice(((ConfigData.item)[(self.discardCfg).discard_scaleId]).icon)
end

UINEpChipDiscardItem.__InitDiscardChipDefault = function(self, discardId, chipData, clickAction, dynPlayer)
  -- function num : 0_3 , upvalues : _ENV, base
  self.chipData = chipData
  self.clickAction = clickAction
  self.discardCfg = (ConfigData.exploration_discard)[discardId]
  self.dynPlayer = dynPlayer
  ;
  (base.InitBaseEpChipUI)(self, chipData, true)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ChipTypeIcon).sprite = CRH:GetSprite(chipData:GetChipMarkIcon(), CommonAtlasType.ExplorationIcon)
end

UINEpChipDiscardItem.__showSellPrice = function(self, MoneyIconId)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Money).text = tostring(self.price)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSprite(MoneyIconId)
end

UINEpChipDiscardItem.SetItemSelect = function(self, selected)
  -- function num : 0_5
  ((self.ui).img_OnSelect):SetActive(selected)
end

UINEpChipDiscardItem.__OnStoreItemClicked = function(self)
  -- function num : 0_6
  if self.clickAction ~= nil then
    (self.clickAction)(self)
  end
end

UINEpChipDiscardItem.GetEpChipDiscardItemMoneyIconSpriteNum = function(self)
  -- function num : 0_7
  return ((self.ui).img_Money).sprite, ((self.ui).tex_Money).text
end

return UINEpChipDiscardItem

