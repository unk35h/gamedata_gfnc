-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22ShopGoodsItem = class("UINActSum22ShopGoodsItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINActSum22ShopGoodsItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_goodItem, self, self.OnDungeonShopItemClicked)
  self.itemWithCount = (UINBaseItemWithCount.New)()
  ;
  (self.itemWithCount):Init((self.ui).obj_itemWithCount)
  ;
  (self.itemWithCount):SetNotNeedAnyJump(true)
  self.__OnBuyShopDataCallback = BindCallback(self, self.OnDungeonShopItemClicked)
end

UINActSum22ShopGoodsItem.InitCharDungeonShopItem = function(self, shopGoodData, index, clickEvent)
  -- function num : 0_1
  self.__shopGoodData = shopGoodData
  self.__clickEvent = clickEvent
  self.__dataIndex = index
  self:RefreshCharDungeonShopItem()
end

UINActSum22ShopGoodsItem.RefreshCharDungeonShopItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_GoodName).text = (LanguageUtil.GetLocaleText)(((self.__shopGoodData).itemCfg).name)
  ;
  ((self.ui).tex_stock):SetIndex(0, tostring((self.__shopGoodData).limitTime - (self.__shopGoodData).purchases))
  ;
  (self.itemWithCount):InitItemWithCount((self.__shopGoodData).itemCfg, (self.__shopGoodData).itemNum, self.__OnBuyShopDataCallback)
  local priceItem = (ConfigData.item)[(self.__shopGoodData).currencyId]
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Cost).sprite = CRH:GetSprite(priceItem.small_icon)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Price).text = tostring((self.__shopGoodData).newCurrencyNum)
  ;
  ((self.ui).obj_price):SetActive(not (self.__shopGoodData).isSoldOut)
  ;
  ((self.ui).obj_isSellOut):SetActive((self.__shopGoodData).isSoldOut)
end

UINActSum22ShopGoodsItem.GetDungeonShopItemData = function(self)
  -- function num : 0_3
  return self.__shopGoodData
end

UINActSum22ShopGoodsItem.GetDungeonShopDataIndex = function(self)
  -- function num : 0_4
  return self.__dataIndex
end

UINActSum22ShopGoodsItem.OnDungeonShopItemClicked = function(self)
  -- function num : 0_5
  if self.__clickEvent ~= nil and not (self.__shopGoodData).isSoldOut then
    (self.__clickEvent)(self.__dataIndex, self)
  end
end

UINActSum22ShopGoodsItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22ShopGoodsItem

