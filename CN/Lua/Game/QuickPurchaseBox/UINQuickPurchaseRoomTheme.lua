-- params : ...
-- function num : 0 , upvalues : _ENV
local UINQuickPurchaseRoomTheme = class("UINQuickPurchaseRoomTheme", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINBaseItemMaskWithCount = require("Game.CommonUI.Item.UINBaseItemMaskWithCount")
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local ShopEnum = require("Game.Shop.ShopEnum")
UINQuickPurchaseRoomTheme.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount, UINBaseItemMaskWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self._OnClickBuy)
  self.itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount, false)
  self.itemMaskPool = (UIItemPool.New)(UINBaseItemMaskWithCount, (self.ui).obj_hadItem, false)
end

UINQuickPurchaseRoomTheme.OnInitPayGift = function(self, shopGoodsDic, themeItem, parentWin)
  -- function num : 0_1 , upvalues : _ENV, cs_ResLoader
  self.quickBuyWindow = parentWin
  self.shopGoodsDic = shopGoodsDic
  self.themeItem = themeItem
  self.dormTheme = (ConfigData.dorm_theme)[((self.themeItem).shelfCfg).theme_id]
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.resloader = (cs_ResLoader.Create)()
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetShopFurnitureThemePath((self.dormTheme).theme_pic3), function(texture)
    -- function num : 0_1_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

    ((self.ui).img_GiftBag).texture = texture
  end
)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.dormTheme).theme_name)
  if (self.dormTheme).only_big then
    ((self.ui).img_OnlyBig):SetActive(true)
  else
    ;
    ((self.ui).img_OnlyBig):SetActive(false)
  end
  ;
  (self.itemPool):HideAll()
  ;
  (self.itemMaskPool):HideAll()
  self.shelf2Cnt = {}
  self.rewardIds = {}
  self.rewardCounts = {}
  local totalCost = 0
  local requiredCost = 0
  for i,itemData in pairs(self.shopGoodsDic) do
    if itemData.totallimitTime == nil or not itemData.totallimitTime then
      local limitCount = itemData.limitTime
    end
    local tempCost = (limitCount - itemData.purchases) * itemData.newCurrencyNum
    local rTempCost = limitCount * itemData.newCurrencyNum
    totalCost = totalCost + tempCost
    requiredCost = requiredCost + rTempCost
    -- DECOMPILER ERROR at PC92: Confused about usage of register: R14 in 'UnsetPending'

    if limitCount ~= itemData.purchases then
      (self.shelf2Cnt)[itemData.shelfId] = limitCount - itemData.purchases
      ;
      (table.insert)(self.rewardIds, itemData.itemId)
      ;
      (table.insert)(self.rewardCounts, limitCount - itemData.purchases)
    end
    local itemCfg = itemData.itemCfg
    local item = (self.itemPool):GetOne(true)
    local hadItem = (self.itemMaskPool):GetOne(true)
    hadItem:InitItemMaskWithCount(itemData.purchases, limitCount)
    item:InitItemWithCount(itemCfg, limitCount)
    ;
    (hadItem.transform):SetParent(item.transform, false)
  end
  self.totalCost = totalCost
  self.requiredCost = requiredCost
  self:ClearQPRoomThemeTimerId()
  self.timerId = TimerManager:StartTimer(1, self.ShowRoomThemeCutDown, self, false, false, false)
  self:ShowRoomThemeCutDown()
  self:RefreshBtnState()
end

UINQuickPurchaseRoomTheme.RefreshBtnState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local currencyItemCfg = (ConfigData.item)[(self.themeItem).currencyId]
  local smallIcon = currencyItemCfg.small_icon
  ;
  (((self.ui).img_money).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_money).sprite = CRH:GetSprite(smallIcon)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_totalcurrPrice).text = tostring(self.totalCost)
  local ownMoney = PlayerDataCenter:GetItemCount((self.themeItem).currencyId)
  if self.totalCost == self.requiredCost then
    ((self.ui).tex_btnDetail):SetIndex(0)
  else
    ;
    ((self.ui).tex_btnDetail):SetIndex(1)
  end
  if self.totalCost <= ownMoney and self.totalCost > 0 then
    self.canBuy = true
  else
    self.canBuy = false
  end
end

UINQuickPurchaseRoomTheme.ShowRoomThemeCutDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local hasTimeLimit, inTime, startTime, endTime = (self.themeItem):GetStillTime()
  local time = endTime - PlayerDataCenter.timestamp
  if time < 0 or not hasTimeLimit then
    (self.quickBuyWindow):TryClosePurchaseBox()
    return 
  end
  local d, h, m, s = TimeUtil:TimestampToTimeInter(time, false, true)
  if d > 0 then
    ((self.ui).text_time):SetIndex(0, tostring(d), tostring(h))
  else
    if h > 0 then
      ((self.ui).text_time):SetIndex(1, tostring(h), tostring(m))
    else
      if m > 0 then
        ((self.ui).text_time):SetIndex(2, tostring(m))
      else
        ;
        ((self.ui).text_time):SetIndex(2, tostring(1))
      end
    end
  end
end

UINQuickPurchaseRoomTheme._OnClickBuy = function(self)
  -- function num : 0_4 , upvalues : _ENV, ShopEnum, cs_MessageCommon
  local buyFunc = function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop)
    if shopCtrl:GetShopIsSouldOut((self.themeItem).shopId) then
      return 
    end
    shopCtrl:ReqBuySuitGoods((self.themeItem).shopId, self.shelf2Cnt, function()
      -- function num : 0_4_0_0 , upvalues : _ENV, self
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_4_0_0_0 , upvalues : _ENV, self
        if window == nil then
          return 
        end
        local CommonRewardData = require("Game.CommonUI.CommonRewardData")
        local CRData = (CommonRewardData.CreateCRDataUseList)(self.rewardIds, self.rewardCounts)
        window:AddAndTryShowReward(CRData)
      end
)
      ;
      (self.quickBuyWindow):TryClosePurchaseBox()
    end
)
  end

  if self.canBuy == false then
    local coinQuickBuyCfg = (ShopEnum.eQuickBuy).dormCoin
    do
      local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
      if not shopCtrl:ShopIsUnlock(coinQuickBuyCfg.shopId) then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_MoneyInsufficient))
        return 
      end
      local ownMoney = PlayerDataCenter:GetItemCount((self.themeItem).currencyId)
      shopCtrl:GetShopData(coinQuickBuyCfg.shopId, function(shopData)
    -- function num : 0_4_1 , upvalues : coinQuickBuyCfg, _ENV, self, ownMoney, shopCtrl, buyFunc
    local exChangeGoodData = (shopData.shopGoodsDic)[coinQuickBuyCfg.shelfId]
    if exChangeGoodData == nil then
      error("Cant get goodData from normalShop, itemId = " .. (self.themeItem).currencyId)
      return 
    end
    local needItemNum = (math.ceil)((self.totalCost - ownMoney) / exChangeGoodData.itemNum)
    local needCurrencyNum = exChangeGoodData.newCurrencyNum * needItemNum
    ;
    (self.quickBuyWindow):PaidCoinExecute(exChangeGoodData.currencyId, needCurrencyNum, (self.themeItem).currencyId, needItemNum * exChangeGoodData.itemNum, function()
      -- function num : 0_4_1_0 , upvalues : shopCtrl, exChangeGoodData, needItemNum, buyFunc
      shopCtrl:ReqBuyGoods(exChangeGoodData.shopId, exChangeGoodData.shelfId, needItemNum, function()
        -- function num : 0_4_1_0_0 , upvalues : buyFunc
        buyFunc()
      end
)
    end
)
  end
)
      return 
    end
  end
  do
    buyFunc()
  end
end

UINQuickPurchaseRoomTheme.ClearQPRoomThemeTimerId = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
end

UINQuickPurchaseRoomTheme.OnHide = function(self)
  -- function num : 0_6 , upvalues : base
  self:ClearQPRoomThemeTimerId()
  ;
  (base.OnHide)(self)
end

UINQuickPurchaseRoomTheme.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (self.itemPool):DeleteAll()
  ;
  (self.itemMaskPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINQuickPurchaseRoomTheme

