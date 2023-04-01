-- params : ...
-- function num : 0 , upvalues : _ENV
local UIShop = class("UIShop", UIBaseWindow)
local base = UIBaseWindow
local cs_Resloader = CS.ResLoader
local ShopEnum = require("Game.Shop.ShopEnum")
local UINShopPageButtonList = require("Game.Shop.UI.UINShopPageButtonList")
local UINShopTogs = require("Game.Shop.UI.UINShopTogs")
local UINShopNormalGoodsList = require("Game.Shop.UINShopNormalGoodsList")
local UINShopHeroGoodsList = require("Game.Shop.UINShopHeroGoodsList")
local UINMonthCard = require("Game.ShopMain.UINMonthCard")
local UINRecommeShop = require("Game.ShopMain.UINRecommeShop")
local UINShopNormalGiftList = require("Game.Shop.UINShopNormalGiftList")
local UINShopNormalRechargeList = require("Game.Shop.UINShopNormalRechargeList")
local UINShopFntItemList = require("Game.Shop.Dorm.UINShopFntItemList")
local UINShopThemeSkinList = require("Game.Shop.UINShopThemeSkinList")
local UINShopRefreshNode = require("Game.Shop.UINShopRefreshNode")
local UINSupportShopBar = require("Game.ShopMain.UINSupportShopBar")
local UINTimeLimitShopBar = require("Game.ShopMain.UINTimeLimitShopBar")
local UINRuleTouchShopBar = require("Game.ShopMain.UINRuleTouchShopBar")
UIShop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_Resloader, UINShopPageButtonList, UINShopTogs, ShopEnum, UINShopNormalGoodsList, UINShopHeroGoodsList, UINMonthCard, UINRecommeShop, UINShopNormalGiftList, UINShopNormalRechargeList, UINShopFntItemList, UINShopThemeSkinList, UINShopRefreshNode, UINSupportShopBar, UINTimeLimitShopBar, UINRuleTouchShopBar
  (UIUtil.SetTopStatus)(self, self.OnReturnClicked, nil, nil, nil)
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  self.resloader = (cs_Resloader.Create)()
  self.curSelectShopId = nil
  self.curSelectShopPageId = nil
  self.shopGoodsNodeDic = {}
  self.__curGoodsNodeType = nil
  self.shopHeadBarNodeDic = {}
  self._refreshTime = math.maxinteger
  self.__OnClickPage = BindCallback(self, self.OnClickPage)
  self.__RefreshGoodsNode = BindCallback(self, self.RefreshGoodsNode)
  self.__OnClickRefreshShop = BindCallback(self, self.InitShop)
  self.__JudgeAndRefreshShopUI = BindCallback(self, self.JudgeAndRefreshShopUI)
  self.pageBtnListNode = (UINShopPageButtonList.New)()
  ;
  (self.pageBtnListNode):Init((self.ui).obj_pageButtonList)
  ;
  (self.pageBtnListNode):InitPageBtnList(self.shopCtrl, self.resloader, self.__OnClickPage, self)
  self.shopTogsNode = (UINShopTogs.New)()
  ;
  (self.shopTogsNode):Init((self.ui).obj_shopTogs)
  ;
  (self.shopTogsNode):InitShopTogs(self.shopCtrl, self.resloader, self.__RefreshGoodsNode)
  ;
  (self.shopTogsNode):Hide()
  self.shopGoodsNodes = {
[(ShopEnum.eGoodsShowType).normal] = {class = UINShopNormalGoodsList, ui = (self.ui).shopItemList}
, 
[(ShopEnum.eGoodsShowType).heroGoods] = {class = UINShopHeroGoodsList, ui = (self.ui).heroItemList}
, 
[(ShopEnum.eGoodsShowType).monthcard] = {class = UINMonthCard, ui = (self.ui).uI_ShopMonthCard}
, 
[(ShopEnum.eGoodsShowType).recommend] = {class = UINRecommeShop, ui = (self.ui).uI_ShopRecommend}
, 
[(ShopEnum.eGoodsShowType).giftBag] = {class = UINShopNormalGiftList, ui = (self.ui).giftBagList}
, 
[(ShopEnum.eGoodsShowType).recharge] = {class = UINShopNormalRechargeList, ui = (self.ui).quartzBagList}
, 
[(ShopEnum.eGoodsShowType).dormfnt] = {class = UINShopFntItemList, ui = (self.ui).furnitureList}
, 
[(ShopEnum.eGoodsShowType).themeSkin] = {class = UINShopThemeSkinList, ui = (self.ui).skinThemeList}
}
  self.shopHeadBar = {
[(ShopEnum.eHeadBarType).advTouchBar] = {class = UINShopRefreshNode, ui = (self.ui).advBar}
, 
[(ShopEnum.eHeadBarType).pointTouchBar] = {class = UINSupportShopBar, ui = (self.ui).pointTouchBar}
, 
[(ShopEnum.eHeadBarType).limitTimeBar] = {class = UINTimeLimitShopBar, ui = (self.ui).limitTimeShopBar}
, 
[(ShopEnum.eHeadBarType).ruleTouchBar] = {class = UINRuleTouchShopBar, ui = (self.ui).ruleTouchBar}
}
  ;
  (self.shopCtrl):AddShopTimerCallback(self.__JudgeAndRefreshShopUI, "uiMian")
  local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeCtrl ~= nil then
    homeCtrl:ResetShowHeroVoiceImme()
  end
end

UIShop.InitShop = function(self, shopId, shelfId, pageId)
  -- function num : 0_1 , upvalues : ShopEnum
  self.curSelectShopId = nil
  self.curSelectShopPageId = nil
  ;
  (self.pageBtnListNode):RefreshPageBtns()
  if shopId == nil or not (self.shopCtrl):ShopIsUnlock(shopId) then
    shopId = (ShopEnum.ShopId).recomme
  end
  if shelfId ~= 0 then
    pageId = nil
  end
  self:OnClickPage(shopId, shelfId, pageId)
end

UIShop.InitShopMainBeforeUnlock = function(self, shopId, shelfId, pageId)
  -- function num : 0_2 , upvalues : ShopEnum
  self.curSelectShopId = nil
  self.curSelectShopPageId = nil
  ;
  (self.pageBtnListNode):RefreshPageBtns(true)
  if shopId == nil then
    shopId = (ShopEnum.ShopId).recomme
  end
  if shelfId ~= 0 then
    pageId = nil
  end
  self:OnClickPage(shopId, shelfId, pageId)
end

UIShop.OnClickPage = function(self, shopId, shelfId, pageId)
  -- function num : 0_3
  if self.curSelectShopId == shopId then
    return 
  end
  self.curSelectShopId = shopId
  self.curSelectShopPageId = nil
  ;
  (self.pageBtnListNode):SelectShop(shopId)
  self:OpenShopNode(shopId, shelfId, pageId)
end

UIShop.OpenShopNode = function(self, shopId, shelfId, pageId)
  -- function num : 0_4 , upvalues : _ENV, ShopEnum
  local shopCfg = (ConfigData.shop)[shopId]
  if shopCfg.shop_type == (ShopEnum.eShopType).Recommend or shopCfg.shop_type == (ShopEnum.eShopType).PayGift then
    (self.shopTogsNode):RefreshShopTogs(shopId, nil, shelfId, pageId)
    return 
  end
  ;
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_4_0 , upvalues : self, shopId, shelfId, pageId
    (self.shopTogsNode):RefreshShopTogs(shopId, shopData, shelfId, pageId)
    ;
    (self.shopCtrl):OnOpenShopSetShopRedDot(shopId)
  end
)
end

UIShop.RefreshGoodsNode = function(self, shopId, pageId, autoSelectShelfId)
  -- function num : 0_5 , upvalues : _ENV, ShopEnum
  if pageId ~= nil and self.curSelectShopPageId == pageId then
    return 
  end
  self.curSelectShopPageId = pageId
  local shopCfg = (ConfigData.shop)[shopId]
  local goodsNodeType = shopCfg.ui_type
  do
    if shopCfg.shop_type == (ShopEnum.eShopType).PayGift then
      local pageCfg = (ConfigData.shop_page)[pageId]
      if pageCfg.mark == (ShopEnum.ePageMarkType).MonthCard then
        goodsNodeType = (ShopEnum.eGoodsShowType).monthcard
      end
    end
    do
      if self.__curGoodsNodeType ~= nil and self.__curGoodsNodeType ~= goodsNodeType then
        local lastNode = (self.shopGoodsNodeDic)[self.__curGoodsNodeType]
        if lastNode ~= nil then
          lastNode:Hide()
        end
      end
      self.__curGoodsNodeType = goodsNodeType
      local shopNode = (self.shopGoodsNodeDic)[goodsNodeType]
      do
        if shopNode == nil then
          local shopNodeCfg = (self.shopGoodsNodes)[goodsNodeType]
          if shopNodeCfg == nil then
            error("can\'t init shopPage with shopId:" .. tostring(shopId) .. " page:" .. tostring(pageId))
            return 
          end
          shopNode = ((shopNodeCfg.class).New)()
          shopNode:Init(shopNodeCfg.ui)
          shopNode:ShopCommonInit(self)
          -- DECOMPILER ERROR at PC71: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (self.shopGoodsNodeDic)[goodsNodeType] = shopNode
        end
        shopNode:Show()
        shopNode:RefreshShopNode(shopId, pageId, autoSelectShelfId)
        ;
        ((self.ui).pageHolderFade):DOKill(true)
        -- DECOMPILER ERROR at PC86: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self.ui).pageHolderFade).alpha = 0.2
        ;
        ((self.ui).pageHolderFade):DOFade(1, 0.45)
      end
    end
  end
end

UIShop.RefreshHeadBar = function(self, shopData, shopCfg)
  -- function num : 0_6 , upvalues : ShopEnum, _ENV
  local headBarType = (ShopEnum.eHeadBarType).advTouchBar
  if shopData ~= nil then
    if shopData.shopId == (ShopEnum.ShopId).supportShop then
      headBarType = (ShopEnum.eHeadBarType).pointTouchBar
    else
      if shopData.shopId == (ShopEnum.ShopId).remasterDailyShop or shopData.shopId == (ShopEnum.ShopId).photoCommemorate then
        headBarType = (ShopEnum.eHeadBarType).ruleTouchBar
      else
        if (self.shopCtrl):GetIsThisShopHasTimeLimit(shopData.shopId) then
          headBarType = (ShopEnum.eHeadBarType).limitTimeBar
        end
      end
    end
  end
  if shopCfg ~= nil and (self.shopCtrl):GetIsThisShopHasTimeLimit(shopCfg.id) then
    headBarType = (ShopEnum.eHeadBarType).limitTimeBar
  end
  for eHeadBarType,headBarNode in pairs(self.shopHeadBarNodeDic) do
    headBarNode:Hide()
  end
  local headBarNode = (self.shopHeadBarNodeDic)[headBarType]
  do
    if headBarNode == nil then
      local headBarNodeCfg = (self.shopHeadBar)[headBarType]
      if headBarNodeCfg == nil then
        error("can\'t init headBarNode with headBarType:" .. tostring(headBarType))
        return 
      end
      headBarNode = ((headBarNodeCfg.class).New)()
      headBarNode:Init(headBarNodeCfg.ui)
      headBarNode:HeadBarCommonInit(self)
      -- DECOMPILER ERROR at PC78: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.shopHeadBarNodeDic)[headBarType] = headBarNode
    end
    headBarNode:Show()
    headBarNode:RefreshHeadBarNode(shopData, shopCfg)
  end
end

UIShop.SetNeedRefreshTm = function(self, tm)
  -- function num : 0_7
  if tm ~= nil and tm > 0 and tm < self._refreshTime then
    self._refreshTime = tm
  end
end

UIShop.JudgeAndRefreshShopUI = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self._refreshTime ~= math.maxinteger and self._refreshTime + 1 < PlayerDataCenter.timestamp then
    self._refreshTime = math.maxinteger
    local isUnlock = (self.shopCtrl):ShopIsUnlock(self.curSelectShopId)
    if not isUnlock then
      self:InitShop(nil)
    else
      self:InitShop(self.curSelectShopId)
    end
  end
end

UIShop.SetShopMainCloseFunc = function(self, closeCallback)
  -- function num : 0_9
  self.closeCallback = closeCallback
end

UIShop.OnReturnClicked = function(self)
  -- function num : 0_10
  self:OnCloseWin()
  self:Delete()
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
end

UIShop.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  (self.shopCtrl):RemoveShopTimerCallback(self.__JudgeAndRefreshShopUI)
  ;
  ((self.ui).pageHolderFade):DOKill()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  for eGoodsShowType,shopNode in pairs(self.shopGoodsNodeDic) do
    shopNode:Delete()
  end
  for eHeadBarType,headBarNode in pairs(self.shopHeadBarNodeDic) do
    headBarNode:Delete()
  end
  ;
  (self.pageBtnListNode):Delete()
  ;
  (self.shopTogsNode):Delete()
  ;
  (base.OnDelete)(self)
end

return UIShop

