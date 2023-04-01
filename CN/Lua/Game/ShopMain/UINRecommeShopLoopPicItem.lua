-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeShopLoopPicItem = class("UINRecommeShopLoopPicItem", UIBaseNode)
local base = UIBaseNode
local UINRecommeShopPicItem = require("Game.ShopMain.UINRecommeShopPicItem")
local JumpManager = require("Game.Jump.JumpManager")
UINRecommeShopLoopPicItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINRecommeShopPicItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.scrollRect = (((self.ui).bannerScroll).gameObject):GetComponent(typeof(((CS.UnityEngine).UI).ScrollRect))
  self.countSizeX = (((self.ui).tr_count).sizeDelta).x
  self.picPool = (UIItemPool.New)(UINRecommeShopPicItem, (self.ui).bannerItem)
  ;
  ((self.ui).bannerItem):SetActive(false)
  self.__LoopBanner = BindCallback(self, self.LoopBanner)
  ;
  ((self.ui).bannerScroll):onPageIndexChanged("+", self.__LoopBanner)
end

UINRecommeShopLoopPicItem.RecShopLoopPicInit = function(self, resloader)
  -- function num : 0_1
  self.resloader = resloader
end

UINRecommeShopLoopPicItem.RefreshRecShopLoopPicItem = function(self, bannerCfgList)
  -- function num : 0_2 , upvalues : _ENV
  local bannerCount = #bannerCfgList
  ;
  (self.picPool):HideAll()
  for i,v in ipairs(bannerCfgList) do
    local item = (self.picPool):GetOne()
    item:InitRecommeShopPic(v, self.resloader)
  end
  if bannerCount < 2 then
    (((self.ui).tr_count).gameObject):SetActive(false)
    self.countDefaultPos = nil
  else
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    if self.scrollRect ~= nil then
      (self.scrollRect).horizontal = true
    end
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tr_count).sizeDelta = (Vector2.New)(self.countSizeX * bannerCount, (((self.ui).tr_count).sizeDelta).y)
    self.countDefaultPos = (Vector2.New)(0, (((self.ui).tr_CurrNum).localPosition).y)
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.countDefaultPos).x = -(((self.ui).tr_count).sizeDelta).x / 2
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

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

UINRecommeShopLoopPicItem.LoopBanner = function(self, index)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  if self.countDefaultPos ~= nil then
    ((self.ui).tr_CurrNum).localPosition = (Vector2.New)((self.countDefaultPos).x + self.countSizeX * index, (self.countDefaultPos).y)
  end
end

UINRecommeShopLoopPicItem.InitRecommeShopPic = function(self)
  -- function num : 0_4
end

return UINRecommeShopLoopPicItem

