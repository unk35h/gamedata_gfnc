-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGiftItemListPage = class("UINGiftItemListPage", UIBaseNode)
local base = UIBaseNode
local UINChipGiftRewardItem = require("Game.PayGift.UINChipGiftRewardItem")
UINGiftItemListPage.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChipGiftRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  self._itemPool = (UIItemPool.New)(UINChipGiftRewardItem, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
end

UINGiftItemListPage.InitGiftItemListPage = function(self, giftInfo, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._giftInfo = giftInfo
  self._callback = callback
  ;
  (self._itemPool):HideAll()
  local itemids, itemnums = (self._giftInfo):GetPayGiftRewards()
  for i,itemid in ipairs(itemids) do
    local item = (self._itemPool):GetOne()
    local itemCount = itemnums[i]
    item:InitChipGiftReward(itemid, itemCount)
  end
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftName).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).name)
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Buy).text = payCtrl:GetPayPriceShow(((self._giftInfo).defaultCfg).payId)
end

UINGiftItemListPage.OnClickBuy = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  payGiftCtrl:SendBuyGifit((self._giftInfo).defaultCfg, nil, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    (UIUtil.OnClickBack)()
    if self._callback ~= nil then
      (self._callback)()
    end
  end
)
end

return UINGiftItemListPage

