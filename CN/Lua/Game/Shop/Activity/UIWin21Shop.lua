-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWin21Shop = class("UIWin21Shop", UIBaseWindow)
local base = UIBaseWindow
local UINCharDungeonShopItem = require("Game.Shop.CharacterDungeon.UINCharDungeonShopItem")
local UINCharDungeonShopPage = require("Game.Shop.CharacterDungeon.UINCharDungeonShopPage")
local ShopUtil = require("Game.Shop.ShopUtil")
UIWin21Shop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__OnClickReturn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_token, self, self.__OnClickCoin)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__onPageItemValueChanged = BindCallback(self, self.OnPageItemValueChanged)
  self.__shopPageList = {}
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_shopList).onInstantiateItem = BindCallback(self, self.__OnShopNewItem)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_shopList).onChangeItem = BindCallback(self, self.__OnShopItemChanged)
  self.__shopItemDic = {}
  self.shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  self.__updateTopCurrencys = BindCallback(self, self.__UpdateShopCurrencys)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  self.__OnCharDungeonItemClicked = BindCallback(self, self.OnActShopItemClicked)
end

UIWin21Shop.InitActivityWinterShop = function(self, activtySector)
  -- function num : 0_1 , upvalues : _ENV
  self.__activtySector = activtySector
  self.__destoryTime = activtySector:GetActivityDestroyTime()
  self.__shopCurrencyId = activtySector:GetSectorIITokenId()
  self.__shopIdList = activtySector:GetSectorIIIShopList()
  self.__saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  self:InitActivityShopBaseInfo()
  self:__InitShopPage(self.__shopIdList)
  if (self.__activtySector):GetSectorIIActivityIsRemaster() then
    ((self.ui).obj_remasterTag):SetActive(true)
  else
    ;
    ((self.ui).obj_remasterTag):SetActive(false)
  end
  if self.__destoryTime < 0 then
    ((self.ui).obj_timer):SetActive(false)
  else
    local date = TimeUtil:TimestampToDate(self.__destoryTime, false, true)
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Time).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  end
  do
    local infoId = (self.__activtySector):GetSectorIIStoreInfo()
    ;
    (((self.ui).tex_Des).gameObject):SetActive(false)
    if infoId ~= 0 then
      (((self.ui).tex_Des).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC88: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Des).text = ConfigData:GetTipContent(infoId)
    end
  end
end

UIWin21Shop.InitActivityShopBaseInfo = function(self)
  -- function num : 0_2
  self:__InitCurrencySprite()
  self:__UpdateShopCurrencys()
end

UIWin21Shop.__InitCurrencySprite = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.__shopCurrencyId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(self.__shopCurrencyId))
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSprite(itemCfg.small_icon)
end

UIWin21Shop.__UpdateShopCurrencys = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local itemCount = PlayerDataCenter:GetItemCount(self.__shopCurrencyId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Token).text = tostring(itemCount)
end

UIWin21Shop.__InitShopPage = function(self, shopList)
  -- function num : 0_5 , upvalues : _ENV, UINCharDungeonShopPage
  if shopList == nil and #shopList == 0 then
    return 
  end
  for _,shopId in pairs(shopList) do
    local go = ((self.ui).pageItem):Instantiate()
    go:SetActive(true)
    local pageItem = (UINCharDungeonShopPage.New)()
    pageItem:Init(go)
    pageItem:InitCharDungeonShopPage(shopId, true, self.__onPageItemValueChanged)
    self:__RefreshBlueDot(shopId, pageItem)
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__shopPageList)[shopId] = pageItem
  end
  local firstShopId = shopList[1]
  ;
  ((self.__shopPageList)[firstShopId]):SetDungeonShopPageIsOn(true)
end

UIWin21Shop.__RefreshBlueDot = function(self, shopId, pageItem)
  -- function num : 0_6 , upvalues : _ENV
  local isNeedBlue = false
  local isLooked = (self.__saveUserData):GetSectorIIRecommendShopIsLooked(shopId)
  if not isLooked then
    local shopCfg = (ConfigData.shop)[shopId]
    do
      local isRecommend = shopCfg.is_recommended
      do
        local isHaveRecommendGood = nil
        do
          if not isRecommend then
            local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
            shopCtrl:GetShopData(shopId, function(shopData)
    -- function num : 0_6_0 , upvalues : _ENV, isHaveRecommendGood
    for shelfId,goodData in pairs(shopData.shopGoodsDic) do
      if goodData.isRecommendGood and not goodData.isSoldOut then
        isHaveRecommendGood = true
        break
      end
    end
  end
, true)
          end
          if isRecommend or isHaveRecommendGood then
            isNeedBlue = true
          end
        end
        pageItem:SetCharDungeonShopPageReddot(isNeedBlue)
      end
    end
  end
end

UIWin21Shop.OnPageItemValueChanged = function(self, pageItem, value)
  -- function num : 0_7
  if not value then
    pageItem:SetCharDungeonShopPageReddot(false)
    return 
  end
  ;
  (((self.ui).loop_shopList).gameObject):SetActive(false)
  self.__isRefeshData = true
  local shopId = pageItem:GetCharDungeonShopId()
  local IsRecommendShop = pageItem:IsItemRecommendShop()
  ;
  ((self.ui).obj_RecommendBG):SetActive(IsRecommendShop)
  ;
  ((self.ui).obj_Title):SetActive(IsRecommendShop)
  ;
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_7_0 , upvalues : self, shopId
    self.__isRefeshData = false
    self:ShowActivtySectorShop(shopData)
    ;
    (self.__saveUserData):SetSectorIIRecommendShopIsLooked(shopId, true)
    ;
    (self.__activtySector):RefreshSectorIIShopReddot()
  end
, true)
end

UIWin21Shop.ShowActivtySectorShop = function(self, shopData)
  -- function num : 0_8 , upvalues : _ENV, ShopUtil
  self.__shopData = shopData
  self.__shopDataList = {}
  for shelfId,goodData in pairs(shopData.shopGoodsDic) do
    (table.insert)(self.__shopDataList, goodData)
  end
  ;
  (ShopUtil.CommonSortGoodList)(self.__shopDataList)
  ;
  (((self.ui).loop_shopList).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).loop_shopList).totalCount = #self.__shopDataList
  ;
  ((self.ui).loop_shopList):RefillCells()
end

UIWin21Shop.__OnShopNewItem = function(self, go)
  -- function num : 0_9 , upvalues : UINCharDungeonShopItem
  local shopItem = (UINCharDungeonShopItem.New)()
  shopItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__shopItemDic)[go] = shopItem
end

UIWin21Shop.__OnShopItemChanged = function(self, go, index)
  -- function num : 0_10
  local shopItem = (self.__shopItemDic)[go]
  index = index + 1
  local shopGoodData = (self.__shopDataList)[index]
  shopItem:InitCharDungeonShopItem(shopGoodData, index, self.__OnCharDungeonItemClicked)
end

UIWin21Shop.__GetItemByIndex = function(self, index)
  -- function num : 0_11 , upvalues : _ENV
  local go = ((self.ui).loop_shopList):GetCellByIndex(index - 1)
  do
    if not IsNull(go) then
      local shopItem = (self.__shopItemDic)[go]
      return shopItem
    end
    return nil
  end
end

UIWin21Shop.__RefreshAllItem = function(self)
  -- function num : 0_12 , upvalues : _ENV
  for i,v in pairs(self.__shopItemDic) do
    v:RefreshCharDungeonShopItem()
  end
end

UIWin21Shop.OnActShopItemClicked = function(self, index, shopItem)
  -- function num : 0_13 , upvalues : _ENV
  local shopGoodData = shopItem:GetDungeonShopItemData()
  if not (self.shopCtrl):ShopIsUnlockOnly(shopGoodData.shopId) then
    return 
  end
  if shopGoodData.isSoldOut then
    return 
  end
  local isOverflow = false
  do
    if (shopGoodData.itemCfg).overflow_type == eItemTransType.actMoneyX then
      local num = PlayerDataCenter:GetItemOverflowNum(shopGoodData.itemId, 1)
      if num ~= 0 then
        isOverflow = true
      end
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
    -- function num : 0_13_0 , upvalues : _ENV, shopGoodData, self, isOverflow
    if win == nil then
      error("can\'t open QuickBuy win")
      return 
    end
    local resIds = {}
    ;
    (table.insert)(resIds, shopGoodData.currencyId)
    if shopGoodData.currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(resIds, ConstGlobalItem.PaidItem) then
      (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
    end
    win:SlideIn()
    win:InitBuyTarget(shopGoodData, function()
      -- function num : 0_13_0_0 , upvalues : self
      self:__RefreshAllItem()
    end
, true, resIds, nil, isOverflow)
    win:OnClickAdd(true)
  end
)
  end
end

UIWin21Shop.__OnClickReturn = function(self)
  -- function num : 0_14
  self:Delete()
end

UIWin21Shop.__OnClickCoin = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.__shopCurrencyId]
  if itemCfg == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_15_0 , upvalues : itemCfg
    if win ~= nil then
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
end

UIWin21Shop.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  ;
  (base.OnDelete)(self)
end

return UIWin21Shop

