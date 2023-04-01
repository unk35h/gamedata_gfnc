-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySummer.Year22.Shop.UINActSum22ShopGoodsItem")
local UINWinter23ShopGoodsItem = class("UINWinter23ShopGoodsItem", base)
UINWinter23ShopGoodsItem.RefreshCharDungeonShopItem = function(self)
  -- function num : 0_0 , upvalues : base
  (base.RefreshCharDungeonShopItem)(self)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).alpha = (self.__shopGoodData).isSoldOut and (self.ui).alpha_sellOut or 1
end

return UINWinter23ShopGoodsItem

