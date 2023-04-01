-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopNormalGoogsItem = require("Game.Shop.UINShopNormalGoogsItem")
local base = UINShopNormalGoogsItem
local UINShopFntNormalItem = class("UINShopFntNormalItem", base)
local ShopEnum = require("Game.Shop.ShopEnum")
UINShopFntNormalItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINShopFntNormalItem.InitFntItem = function(self, goodData, baseObj)
  -- function num : 0_1 , upvalues : _ENV
  self.goodData = goodData
  self.baseObj = baseObj
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((goodData.itemCfg).name)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite((goodData.itemCfg).icon)
  self:RefreshCurrencyUI(goodData)
  self:RefreshLimitUI(goodData)
  self:RefreshLeftSellTime()
  ;
  ((self.ui).soldOut):SetActive((self.goodData).isSoldOut)
  for i = 1, #self.texItemList do
    ((self.texItemList)[i]):StartScrambleTypeWriter()
  end
  self:InitDormFntInfo(goodData)
end

UINShopFntNormalItem.InitDormFntInfo = function(self, goodData)
  -- function num : 0_2 , upvalues : _ENV
  local fntCfg = (ConfigData.dorm_furniture)[(goodData.itemCfg).id]
  if fntCfg == nil then
    error("can\'t not find dorm fnt cfg,id:" .. tostring((goodData.itemCfg).id))
    return 
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Comfort).text = tostring(fntCfg.comfort)
  ;
  ((self.ui).obj_img_ThemeFurniture):SetActive(fntCfg.is_theme)
  ;
  ((self.ui).obj_img_CheckIn):SetActive(fntCfg.can_binding)
  ;
  ((self.ui).obj_img_OnlyBig):SetActive(fntCfg.only_big)
end

UINShopFntNormalItem.RefreshLimitUI = function(self, goodData)
  -- function num : 0_3 , upvalues : ShopEnum, _ENV
  ((self.ui).obj_Times):SetActive(false)
  if goodData.isLimit and goodData.shopType ~= (ShopEnum.eShopType).Random then
    ((self.ui).obj_Times):SetActive(true)
    if goodData.shopType ~= (ShopEnum.eShopType).ResourceRefresh or not 0 then
      local timesTypeIndex = goodData.limitType
    end
    ;
    ((self.ui).tex_Times_type):SetIndex(timesTypeIndex)
    if goodData.totallimitTime == nil or not goodData.totallimitTime then
      local limitCount = goodData.limitTime
    end
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Times).text = tostring(limitCount - goodData.purchases) .. "/" .. tostring(limitCount)
  end
end

UINShopFntNormalItem.RefreshLeftSellTime = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_BuyTime):SetActive(false)
  if (self.goodData).isSoldOut then
    return 
  end
  local hasTimeLimit, inTime, startTime, endTime = (self.goodData):GetStillTime()
  if hasTimeLimit and not inTime then
    return true
  end
  do return  end
  ;
  ((self.ui).obj_BuyTime):SetActive(true)
  local remaindTime = endTime - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if d > 0 then
    ((self.ui).tex_BuyLeftTime):SetIndex(0, tostring(d), tostring(h))
    return 
  end
  if h > 0 then
    ((self.ui).tex_BuyLeftTime):SetIndex(1, tostring(h), tostring(m))
    return 
  end
  if s > 0 then
    m = m + 1
  end
  ;
  ((self.ui).tex_BuyLeftTime):SetIndex(2, tostring(m))
end

UINShopFntNormalItem.RefreshGoods = function(self)
  -- function num : 0_5
  if self.baseObj ~= nil then
    (self.baseObj):RefreshGoods()
  end
end

return UINShopFntNormalItem

