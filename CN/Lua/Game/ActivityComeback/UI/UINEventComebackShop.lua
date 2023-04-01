-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackShop = class("UINEventComebackShop", UIBaseNode)
local base = UIBaseNode
local UINEventComebackShopItem = require("Game.ActivityComeback.UI.UINEventComebackShopItem")
UINEventComebackShop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackShopItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._giftPool = (UIItemPool.New)(UINEventComebackShopItem, (self.ui).giftItem)
  ;
  ((self.ui).giftItem):SetActive(false)
  self.__BuyGiftCallback = BindCallback(self, self.__BuyGift)
end

UINEventComebackShop.InitComebackShop = function(self, comebackId)
  -- function num : 0_1 , upvalues : _ENV
  local comebackCfg = (ConfigData.activity_user_return)[comebackId]
  self._pageId = comebackCfg.inPage
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local giftInfos = payGiftCtrl:GetShowPayGiftByPageId(self._pageId, true)
  ;
  (self._giftPool):HideAll()
  for i,giftInfo in ipairs(giftInfos) do
    local item = (self._giftPool):GetOne()
    item:InitComebackGift(giftInfo, self.__BuyGiftCallback)
  end
end

UINEventComebackShop.__RefreshGiftItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,item in ipairs((self._giftPool).listItem) do
    item:RefreshComebackShopItem()
  end
end

UINEventComebackShop.__BuyGift = function(self, giftInfo)
  -- function num : 0_3 , upvalues : _ENV
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  payGiftCtrl:SendBuyGifit(giftInfo.defaultCfg, nil, function()
    -- function num : 0_3_0 , upvalues : self
    self:__RefreshGiftItem()
  end
)
end

return UINEventComebackShop

