-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeShopLoopPicItemMid = class("UINRecommeShopLoopPicItemMid", UIBaseNode)
local base = UIBaseNode
local UINRecommeShopPicItemWithInfo = require("Game.ShopMain.UINRecommeShopPicItemWithInfo")
UINRecommeShopLoopPicItemMid.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINRecommeShopPicItemWithInfo
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.scrollRect = (((self.ui).bannerScroll).gameObject):GetComponent(typeof(((CS.UnityEngine).UI).ScrollRect))
  self.countSizeX = (((self.ui).tr_count).sizeDelta).x
  self.picPool = (UIItemPool.New)(UINRecommeShopPicItemWithInfo, (self.ui).middleBannerItem)
  ;
  ((self.ui).middleBannerItem):SetActive(false)
  self.__LoopBanner = BindCallback(self, self.LoopBanner)
  ;
  ((self.ui).bannerScroll):onPageIndexChanged("+", self.__LoopBanner)
end

UINRecommeShopLoopPicItemMid.RecShopLoopPicInit = function(self, resloader)
  -- function num : 0_1
  self.resloader = resloader
end

UINRecommeShopLoopPicItemMid.RefreshRecShopLoopPicItem = function(self, bannerCfgList)
  -- function num : 0_2 , upvalues : _ENV
  if self.midPicInfo ~= nil then
    (self.midPicInfo):RefreshRecommeShopMidPageInfo(bannerCfgList)
  end
  local bannerCount = #bannerCfgList
  ;
  (self.picPool):HideAll()
  for _,vCfg in ipairs(bannerCfgList) do
    local item = (self.picPool):GetOne()
    item:InitRecommeShopPicWithInfo(vCfg, self.resloader)
  end
  if bannerCount < 2 then
    (((self.ui).tr_count).gameObject):SetActive(false)
    self.countDefaultPos = nil
  else
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

    if self.scrollRect ~= nil then
      (self.scrollRect).horizontal = true
    end
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tr_count).sizeDelta = (Vector2.New)(self.countSizeX * bannerCount, (((self.ui).tr_count).sizeDelta).y)
    self.countDefaultPos = (Vector2.New)(0, (((self.ui).tr_CurrNum).localPosition).y)
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.countDefaultPos).x = -(((self.ui).tr_count).sizeDelta).x / 2
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tr_CurrNum).localPosition = self.countDefaultPos
  end
  ;
  ((self.ui).bannerScroll):InitPosList(bannerCount)
  ;
  ((self.ui).bannerScroll):SetPageIndexImmediate(0)
  ;
  ((self.ui).bannerScroll):SetInterval((ConfigData.game_config).shopBannerTime)
end

UINRecommeShopLoopPicItemMid.LoopBanner = function(self, index)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  if self.countDefaultPos ~= nil then
    ((self.ui).tr_CurrNum).localPosition = (Vector2.New)((self.countDefaultPos).x + self.countSizeX * index, (self.countDefaultPos).y)
  end
end

return UINRecommeShopLoopPicItemMid

