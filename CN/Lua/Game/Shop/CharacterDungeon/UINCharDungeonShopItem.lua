-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharDungeonShopItem = class("UINCharDungeonShopItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINCharDungeonShopItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_goodItem, self, self.OnDungeonShopItemClicked)
  self.itemWithCount = (UINBaseItemWithCount.New)()
  ;
  (self.itemWithCount):Init((self.ui).obj_itemWithCount)
  ;
  (self.itemWithCount):SetNotNeedAnyJump(true)
end

UINCharDungeonShopItem.InitCharDungeonShopItem = function(self, shopGoodData, index, clickEvent)
  -- function num : 0_1
  self.__shopGoodData = shopGoodData
  self.__clickEvent = clickEvent
  self.__dataIndex = index
  self:RefreshCharDungeonShopItem()
end

UINCharDungeonShopItem.RefreshCharDungeonShopItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_GoodName).text = (LanguageUtil.GetLocaleText)(((self.__shopGoodData).itemCfg).name)
  ;
  (self.itemWithCount):InitItemWithCount((self.__shopGoodData).itemCfg, (self.__shopGoodData).itemNum)
  local priceItem = (ConfigData.item)[(self.__shopGoodData).currencyId]
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Cost).sprite = CRH:GetSprite(priceItem.small_icon)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Price).text = tostring((self.__shopGoodData).newCurrencyNum)
  ;
  (((self.ui).tex_surplusCount).gameObject):SetActive((self.__shopGoodData).isLimit)
  local num = (self.__shopGoodData).limitTime - (self.__shopGoodData).purchases
  local isSoldOut = (self.__shopGoodData).isSoldOut
  ;
  ((self.ui).obj_price):SetActive(not isSoldOut)
  ;
  ((self.ui).obj_isSellOut):SetActive(isSoldOut)
  if (self.__shopGoodData).isRecommendGood then
    local showRecommend = not isSoldOut
  end
  ;
  ((self.ui).obj_Recommend):SetActive(showRecommend)
  ;
  ((self.ui).obj_outTag):SetActive(false)
  do
    if ((self.__shopGoodData).itemCfg).overflow_type == eItemTransType.actMoneyX then
      local overflowNum = PlayerDataCenter:GetItemOverflowNum((self.__shopGoodData).itemId, 1)
      if overflowNum ~= 0 then
        ((self.ui).obj_outTag):SetActive(true)
      end
    end
    if (self.__shopGoodData).isLimit then
      ((self.ui).tex_surplusCount):SetIndex(0, tostring(num))
    end
  end
end

UINCharDungeonShopItem.GetDungeonShopItemData = function(self)
  -- function num : 0_3
  return self.__shopGoodData
end

UINCharDungeonShopItem.GetDungeonShopDataIndex = function(self)
  -- function num : 0_4
  return self.__dataIndex
end

UINCharDungeonShopItem.OnDungeonShopItemClicked = function(self)
  -- function num : 0_5
  if self.__clickEvent ~= nil then
    (self.__clickEvent)(self.__dataIndex, self)
  end
end

UINCharDungeonShopItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINCharDungeonShopItem

