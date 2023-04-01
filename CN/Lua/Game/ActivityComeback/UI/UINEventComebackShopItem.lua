-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackShopItem = class("UINEventComebackShopItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_ResLoader = CS.ResLoader
UINEventComebackShopItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bottom, self, self.__OnClickBuy)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
end

UINEventComebackShopItem.InitComebackGift = function(self, payGiftInfo, callback)
  -- function num : 0_1 , upvalues : cs_ResLoader, _ENV
  self._payGiftInfo = payGiftInfo
  self._callback = callback
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  self._resloader = (cs_ResLoader.Create)()
  ;
  (((self.ui).img_gift).gameObject):SetActive(false)
  local textureName = ((self._payGiftInfo).groupCfg).icon
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if not IsNull(texture) then
      (((self.ui).img_gift).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_gift).texture = texture
    end
  end
)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftName).text = (LanguageUtil.GetLocaleText)(((self._payGiftInfo).groupCfg).name)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_GiftInfo).text = (LanguageUtil.GetLocaleText)(((self._payGiftInfo).groupCfg).des)
  local defaultGiftCfg = (self._payGiftInfo).defaultCfg
  local awardIds = defaultGiftCfg.awardIds
  local awardCounts = defaultGiftCfg.awardCounts
  ;
  (self._itemPool):HideAll()
  for index,id in ipairs(awardIds) do
    local itemCfg = (ConfigData.item)[id]
    local itemCount = awardCounts[index]
    local item = (self._itemPool):GetOne()
    item:InitItemWithCount(itemCfg, itemCount)
  end
  local isOff = ((self._payGiftInfo).groupCfg).tagType == 1
  ;
  ((self.ui).off):SetActive(isOff)
  if isOff then
    ((self.ui).tex_Off):SetIndex(0, tostring(((self._payGiftInfo).groupCfg).tagValue))
  end
  local payId = defaultGiftCfg.payId
  local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
  local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
  -- DECOMPILER ERROR at PC107: Confused about usage of register: R12 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrentPrice).text = priceStr
  local showOldPrice, oldPrice = (self._payGiftInfo):TryGetPayGiftOldPrice()
  ;
  (((self.ui).tex_OriginalPrice).gameObject):SetActive(showOldPrice)
  -- DECOMPILER ERROR at PC124: Confused about usage of register: R14 in 'UnsetPending'

  if showOldPrice then
    ((self.ui).tex_OriginalPrice).text = tostring(oldPrice)
  end
  self:RefreshComebackShopItem()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINEventComebackShopItem.RefreshComebackShopItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isLimit, times, totalTimes = (self._payGiftInfo):GetLimitBuyCount()
  ;
  ((self.ui).obj_Limit):SetActive(isLimit)
  do
    if isLimit then
      local remain = totalTimes - times
      ;
      ((self.ui).tex_Limit):SetIndex(0, tostring(remain))
      ;
      ((self.ui).soldOut):SetActive(remain == 0)
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINEventComebackShopItem.__OnClickBuy = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._payGiftInfo)
  end
end

UINEventComebackShopItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
  ;
  (self._itemPool):DeleteAll()
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
end

return UINEventComebackShopItem

