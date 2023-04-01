-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22Shop = class("UIActSum22Shop", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local ShopEnum = require("Game.Shop.ShopEnum")
local cs_MessageCommon = CS.MessageCommon
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UIActSum22Shop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnClickShopClose)
  self:__SetNewClassNode()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._itemDic = {}
  self._shopSelectItemPool = (UIItemPool.New)(self.class_ShopPage, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__OnSelectShopCallback = BindCallback(self, self.__OnSelectShop)
  self.__OnBuyGoodsDataCallback = BindCallback(self, self.__OnBuyGoodsData)
end

UIActSum22Shop.__SetCoin = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).resNode, self, self.__OnClickResIcon)
  self.__CoinRefreshCallback = BindCallback(self, self.__CoinRefresh)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__CoinRefreshCallback)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSpriteByItemId(self._showToken, true)
end

UIActSum22Shop.__CancleCoin = function(self)
  -- function num : 0_2 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__CoinRefreshCallback)
end

UIActSum22Shop.__CoinRefresh = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Token).text = tostring(PlayerDataCenter:GetItemCount(self._showToken))
end

UIActSum22Shop.__SetNewClassNode = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.class_ShopGoodsItem = require("Game.ActivitySummer.Year22.Shop.UINActSum22ShopGoodsItem")
  self.class_ShopPage = require("Game.ActivitySummer.Year22.Shop.UINActSum22ShopPage")
  self.isTimeShotTitle = false
end

UIActSum22Shop.InitSum22Shop = function(self, sum22Data, callback)
  -- function num : 0_5 , upvalues : _ENV
  local mainCfg = sum22Data:GetSectorIIIMainCfg()
  local shopList = mainCfg.shop_list
  if #shopList == 0 then
    if isGameDev then
      error("商店列表是空")
    end
    return 
  end
  self:InitSum22ShopByShopList(sum22Data, shopList, mainCfg.token_item, callback)
end

UIActSum22Shop.InitSum22ShopByShopList = function(self, activityBase, shopList, showToken, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_LayoutRebuilder
  self._activityBase = activityBase
  self._showToken = showToken
  self._callback = callback
  self._shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop)
  ;
  (self._shopSelectItemPool):HideAll()
  for i,shopId in ipairs(shopList) do
    local item = (self._shopSelectItemPool):GetOne()
    item:InitSum22ShopPage(shopId, self.__OnSelectShopCallback)
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((((self.ui).pageItem).transform).parent)
  ;
  (((self._shopSelectItemPool).listItem)[1]):OnClickPage()
  if self._timerId == nil then
    self._timerId = TimerManager:StartTimer(1, self.__RefreshTime, self)
    self:__RefreshTime()
  end
  self:__SetCoin()
  self:__CoinRefresh()
end

UIActSum22Shop.__RefreshShop = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._shopData == nil then
    if isGameDev then
      error("商店内容是空")
    end
    return 
  end
  if self._shopGoodsDatas == nil then
    self._shopGoodsDatas = {}
  else
    ;
    (table.removeall)(self._shopGoodsDatas)
  end
  self:__RefreShopTitle()
  for _,goodsDatas in ipairs((self._shopData).shopGoodsDic) do
    (table.insert)(self._shopGoodsDatas, goodsDatas)
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).totalCount = #self._shopGoodsDatas
  ;
  ((self.ui).shopList):RefillCells(0, -50)
end

UIActSum22Shop.__RefreShopTitle = function(self)
  -- function num : 0_8
  ((self.ui).title):SetActive(((self._shopData).shopCfg).is_recommended)
end

UIActSum22Shop.__OnInstantiateItem = function(self, go)
  -- function num : 0_9
  local item = ((self.class_ShopGoodsItem).New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = item
end

UIActSum22Shop.__OnChangeItem = function(self, go, index)
  -- function num : 0_10
  local item = (self._itemDic)[go]
  local data = (self._shopGoodsDatas)[index + 1]
  item:InitCharDungeonShopItem(data, index + 1, self.__OnBuyGoodsDataCallback)
end

UIActSum22Shop.__RefreshTime = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivityFrameUtil
  if self._expireTime or 0 == 0 then
    self._expireTime = (self._activityBase):GetActivityDestroyTime()
    local date = TimeUtil:TimestampToDate(self._expireTime, false, true)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Time).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  end
  do
    local timeStr, time = (ActivityFrameUtil.GetCountdownTimeStr)(self._expireTime, self.isTimeShotTitle)
    if time <= 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_countdown).text = timeStr
  end
end

UIActSum22Shop.__OnSelectShop = function(self, shopId, item)
  -- function num : 0_12 , upvalues : _ENV
  if self._isReqing then
    return 
  end
  if self._curSelectShop == shopId then
    return 
  end
  for i,item in ipairs((self._shopSelectItemPool).listItem) do
    item:RefreshSum22ShopPageState(shopId)
  end
  self._curSelectShop = shopId
  self._isReqing = true
  ;
  (self._shopCtrl):GetShopData(self._curSelectShop, function(shopData)
    -- function num : 0_12_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self._isReqing = false
    self._shopData = shopData
    self:__RefreshShop()
  end
)
end

UIActSum22Shop.__OnBuyGoodsData = function(self, index)
  -- function num : 0_13 , upvalues : _ENV, ShopEnum, cs_MessageCommon
  local goodData = (self._shopGoodsDatas)[index]
  local Local_Buy = function()
    -- function num : 0_13_0 , upvalues : _ENV, self, goodData, ShopEnum
    if IsNull(self.transform) then
      return 
    end
    local isRecharge = goodData.shopType == (ShopEnum.eShopType).Recharge
    if isRecharge then
      (ControllerManager:GetController(ControllerTypeId.Shop, true)):ReqShopRecharge((goodData.goodCfg).pay_id)
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
      -- function num : 0_13_0_0 , upvalues : _ENV, goodData, self
      if win == nil then
        error("can\'t open QuickBuy win")
        return 
      end
      local resIds = {}
      ;
      (table.insert)(resIds, goodData.currencyId)
      if goodData.currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(resIds, ConstGlobalItem.PaidItem) then
        (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
      end
      win:SlideIn()
      win:InitBuyTarget(goodData, function()
        -- function num : 0_13_0_0_0 , upvalues : _ENV, self
        if IsNull(self.transform) then
          return 
        end
        self:__RefreshShop()
      end
, true, resIds)
      win:OnClickAdd(true)
    end
)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end

  do
    if (goodData.itemCfg).action_type == eItemActionType.HeroCardFrag then
      local heroData = (PlayerDataCenter.heroDic)[((goodData.itemCfg).arg)[1]]
      if heroData ~= nil and heroData:GetMaxNeedFragNum(true) <= 0 then
        (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(3010), Local_Buy, nil)
        return 
      end
    end
    Local_Buy()
  end
end

UIActSum22Shop.__OnClickResIcon = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self._showToken]
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_14_0 , upvalues : itemCfg
    if win == nil then
      return 
    end
    win:InitCommonItemDetail(itemCfg)
  end
)
end

UIActSum22Shop.OnClickShopClose = function(self)
  -- function num : 0_15
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActSum22Shop.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  self:__CancleCoin()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIActSum22Shop

