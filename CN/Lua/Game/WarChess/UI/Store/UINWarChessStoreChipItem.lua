-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINWarChessStoreChipItem = class("UINWarChessStoreChipItem", base)
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
UINWarChessStoreChipItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_storeItem, self, self.__OnStoreItemClicked)
end

UINWarChessStoreChipItem.InitWCStoreChipItem = function(self, storeData, MoneyIconId, clickAction, isSell)
  -- function num : 0_1 , upvalues : base, _ENV
  ((self.ui).img_SellOut):SetActive(false)
  if isSell then
    self.chipData = storeData
    local buyPrice = (self.chipData):GetChipBuyPriceForWarChess()
    self.epDiscountPriceCfg = nil
    self.salePrice = (self.chipData):GetChipSellPriceForWarChess()
    self:__showSellPrice(buyPrice, self.salePrice, MoneyIconId)
    ;
    (((self.ui).itemTitle).gameObject):SetActive(true)
  else
    do
      self.epStoreItemData = storeData
      self.chipData = storeData.chipData
      do
        local buyPrice = (self.chipData):GetChipBuyPriceForWarChess()
        self:__ShowPrice(buyPrice, storeData.discount, MoneyIconId)
        self:WCRefreshShowSaledType(storeData.saled)
        ;
        (((self.ui).itemTitle).gameObject):SetActive(not storeData.saled)
        ;
        (base.InitBaseEpChipUI)(self, self.chipData, true)
        ;
        ((self.ui).itemTitle):SetIndex(isSell and 1 or 0)
        -- DECOMPILER ERROR at PC74: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).img_ChipTypeIcon).sprite = CRH:GetSprite((self.chipData):GetChipMarkIcon(), CommonAtlasType.ExplorationIcon)
        self.index = storeData.idx
        self.clickAction = clickAction
        -- DECOMPILER ERROR at PC85: Confused about usage of register: R5 in 'UnsetPending'

        if not isSell then
          ((self.ui).tex_ItemName).text = (self.chipData):GetName()
          self:SetNewTagActive(false)
        end
      end
    end
  end
end

UINWarChessStoreChipItem.__showSellPrice = function(self, originPrice, price, MoneyIconId)
  -- function num : 0_2 , upvalues : _ENV
  self.price = price
  ;
  ((self.ui).discountNode):SetActive(false)
  ;
  ((self.ui).originalPrice):SetActive(false)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = tostring(self.price)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSprite(MoneyIconId)
end

UINWarChessStoreChipItem.WCRefreshShowSaledType = function(self, isSaled)
  -- function num : 0_3
  ((self.ui).img_SellOut):SetActive(isSaled)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).btn_storeItem).enabled = not isSaled
end

UINWarChessStoreChipItem.__ShowPrice = function(self, price, discount, MoneyIconId)
  -- function num : 0_4 , upvalues : _ENV
  self.price = price
  local hasDiscount = false
  if discount == 100 then
    hasDiscount = true
    ;
    ((self.ui).tex_Discount):SetIndex(0, tostring(100 - discount))
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_originalCost).text = tostring(self.price)
    self.price = (math.ceil)(self.price * discount / 100)
    ;
    ((self.ui).discountNode):SetActive(hasDiscount)
    ;
    ((self.ui).originalPrice):SetActive(hasDiscount)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Money).text = tostring(self.price)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_Money).sprite = CRH:GetSprite(MoneyIconId)
  end
end

UINWarChessStoreChipItem.SetStoreItemSelect = function(self, selected)
  -- function num : 0_5 , upvalues : _ENV
  if selected then
    (((self.ui).img_OnSelect).transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_OnSelect).transform).anchoredPosition = Vector2.zero
  end
end

UINWarChessStoreChipItem.__OnStoreItemClicked = function(self)
  -- function num : 0_6
  if self.clickAction ~= nil then
    (self.clickAction)(self)
  end
end

UINWarChessStoreChipItem.SetNewTagActive = function(self, active, chipShowState)
  -- function num : 0_7 , upvalues : _ENV, ChipEnum
  if IsNull((self.ui).tex_isNew) then
    return 
  end
  ;
  ((self.ui).obj_isNew):SetActive(active)
  if active then
    if chipShowState == (ChipEnum.eChipShowState).UpState then
      ((self.ui).tex_isNew):SetIndex(1)
    else
      if chipShowState == (ChipEnum.eChipShowState).NewState then
        ((self.ui).tex_isNew):SetIndex(0)
      else
        ;
        ((self.ui).obj_isNew):SetActive(false)
      end
    end
  end
end

return UINWarChessStoreChipItem

