-- params : ...
-- function num : 0 , upvalues : _ENV
local UICharacterDungeonShop = class("UICharacterDungeonShop", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local UINCharDungeonShopItem = require("Game.Shop.CharacterDungeon.UINCharDungeonShopItem")
local UINCharDungeonShopPage = require("Game.Shop.CharacterDungeon.UINCharDungeonShopPage")
local ShopUtil = require("Game.Shop.ShopUtil")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
UICharacterDungeonShop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, ConditionListener, cs_ResLoader
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
  self.__OnCharDungeonItemClicked = BindCallback(self, self.OnCharDungeonItemClicked)
  self.__conditionListener = (ConditionListener.New)()
  self.__OnCharShopUnlockEvent = BindCallback(self, self.__OnCharShopUnlock)
  self.__updateTopCurrencys = BindCallback(self, self.__UpdateShopCurrencys)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  self.__heroGrowActivityEvent = BindCallback(self, self.__RefreshCurShopUnlockInfo)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUpdate, self.__heroGrowActivityEvent)
  self.resLoader = (cs_ResLoader.Create)()
  ;
  (((self.ui).recommendTitle).gameObject):SetActive(false)
end

UICharacterDungeonShop.InitCharacterDungeonShop = function(self, heroGrowAct)
  -- function num : 0_1 , upvalues : _ENV
  self.heroGrowAct = heroGrowAct
  self.__ShopRedDotNode = heroGrowAct:GetActivityHeroShopReddotNode()
  self.__shopRedDotNodePath = heroGrowAct:GetActivityHeroShopPath()
  self.activityHeroCfg = heroGrowAct:GetHeroGrowCfg()
  self.__destoryTime = heroGrowAct:GetActivityDestroyTime()
  self.__bornTime = heroGrowAct:GetActivityBornTime()
  self.__shopCurrencyId = heroGrowAct:GetHeroGrowCostId()
  self.shop_name = (self.activityHeroCfg).shop_name
  self.shop_bg = (self.activityHeroCfg).shop_bg
  self.shop_bgfullPath = nil
  self.actFrameId = (heroGrowAct.actInfo):GetActivityFrameId()
  self.tagCol = self:__GetColor((self.activityHeroCfg).color_shop)
  self.selCol = self:__GetColor((self.activityHeroCfg).color_shoplist)
  self:InitCharShopBaseInfo()
  self:__InitCharacterShopReddot()
  self:__InitShopPage((self.activityHeroCfg).shop_list)
  self:RefreshShopLastDay()
  TimerManager:StopTimer(self.__refrehsDayTimerId)
  self.__refrehsDayTimerId = TimerManager:StartTimer(2, self.RefreshShopLastDay, self, false, false, true)
end

UICharacterDungeonShop.ExtraInitCharacterDungeonShop = function(self, extrData)
  -- function num : 0_2 , upvalues : _ENV
  self.__shopCurrencyId = extrData.currencyId
  self.__destoryTime = extrData.destoryTime
  self.__bornTime = extrData.bornTime
  self.tagCol = self:__GetColor(extrData.color_shop)
  self.selCol = self:__GetColor(extrData.color_shoplist)
  self.shop_name = extrData.shop_name
  self.shop_bg = nil
  self.shop_bgfullPath = extrData.shop_bgfullPath
  self.actFrameId = extrData.actFrameId
  local shopList = extrData.shop_list
  self:InitCharShopBaseInfo()
  self:__InitShopPage(shopList)
  self:RefreshShopLastDay()
  TimerManager:StopTimer(self.__refrehsDayTimerId)
  self.__refrehsDayTimerId = TimerManager:StartTimer(2, self.RefreshShopLastDay, self, false, false, true)
end

UICharacterDungeonShop.__InitCharacterShopReddot = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.__shopReddotFunc = function(node)
    -- function num : 0_3_0 , upvalues : self
    local shopId = node.nodeId
    local pageItem = (self.__shopPageList)[shopId]
    if node:GetRedDotCount() <= 0 then
      pageItem:SetCharDungeonShopPageReddot(pageItem == nil)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end

  RedDotController:AddListener(self.__shopRedDotNodePath, self.__shopReddotFunc)
end

UICharacterDungeonShop.RefreshShopLastDay = function(self)
  -- function num : 0_4 , upvalues : _ENV, ActivityFrameUtil
  local futureOpen = PlayerDataCenter.timestamp < self.__bornTime
  if self.__lastFutureOpen ~= futureOpen then
    self.__lastFutureOpen = futureOpen
    local date = nil
    if futureOpen then
      date = TimeUtil:TimestampToDate(self.__bornTime, false, true)
      ;
      ((self.ui).tex_DateType):SetIndex(1)
    else
      date = TimeUtil:TimestampToDate(self.__destoryTime, false, true)
      ;
      ((self.ui).tex_DateType):SetIndex(0)
    end
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Time).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  end
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R2 in 'UnsetPending'

  if futureOpen then
    ((self.ui).tex_Day).text = (ActivityFrameUtil.GetCountdownTimeStr)(self.__bornTime)
  else
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R2 in 'UnsetPending'

    ((self.ui).tex_Day).text = (ActivityFrameUtil.GetCountdownTimeStr)(self.__destoryTime)
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UICharacterDungeonShop.InitCharShopBaseInfo = function(self)
  -- function num : 0_5
  self:__InitBackground()
  self:__InitTag()
  self:__InitCurrencySprite()
  self:__UpdateShopCurrencys()
end

UICharacterDungeonShop.__InitBackground = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_background).enabled = false
  local path = nil
  if self.shop_bgfullPath ~= nil then
    path = self.shop_bgfullPath
  else
    path = PathConsts:GetCharDunPath(self.shop_bg)
  end
  ;
  (self.resLoader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_6_0 , upvalues : self
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_background).enabled = true
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_background).texture = texture
  end
)
end

UICharacterDungeonShop.__InitTag = function(self)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_HeadTile).color = self.tagCol
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_TileName).text = (LanguageUtil.GetLocaleText)(self.shop_name) or ""
end

UICharacterDungeonShop.__InitCurrencySprite = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.__shopCurrencyId]
  if itemCfg == nil then
    error("Cant get itemCfg, id = " .. tostring(self.__shopCurrencyId))
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSprite(itemCfg.icon)
end

UICharacterDungeonShop.__UpdateShopCurrencys = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local itemCount = PlayerDataCenter:GetItemCount(self.__shopCurrencyId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Token).text = tostring(itemCount)
end

UICharacterDungeonShop.__InitShopPage = function(self, shopList)
  -- function num : 0_10 , upvalues : _ENV, UINCharDungeonShopPage
  if shopList == nil and #shopList == 0 then
    return 
  end
  for _,shopId in pairs(shopList) do
    local go = ((self.ui).pageItem):Instantiate()
    go:SetActive(true)
    local pageItem = (UINCharDungeonShopPage.New)()
    pageItem:Init(go)
    local isUnlock = (self.shopCtrl):ShopIsUnlockOnly(shopId)
    do
      if not isUnlock then
        local shopCfg = (ConfigData.shop)[shopId]
        ;
        (self.__conditionListener):AddConditionChangeListener(shopId, self.__OnCharShopUnlockEvent, shopCfg.pre_condition, shopCfg.pre_para1, shopCfg.pre_para2)
      end
      pageItem:InitCharDungeonShopPage(shopId, isUnlock, self.__onPageItemValueChanged)
      pageItem:SetSelectColor(self.selCol)
      do
        do
          if self.__ShopRedDotNode ~= nil then
            local shopNode = (self.__ShopRedDotNode):GetChild(shopId)
            pageItem:SetCharDungeonShopPageReddot(shopNode ~= nil and shopNode:GetRedDotCount() > 0)
          end
          -- DECOMPILER ERROR at PC65: Confused about usage of register: R10 in 'UnsetPending'

          ;
          (self.__shopPageList)[shopId] = pageItem
          -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
  local firstShopId = shopList[1]
  ;
  ((self.__shopPageList)[firstShopId]):SetDungeonShopPageIsOn(true)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UICharacterDungeonShop.OnPageItemValueChanged = function(self, pageItem, value)
  -- function num : 0_11 , upvalues : _ENV
  if not value then
    return 
  end
  ;
  (((self.ui).loop_shopList).gameObject):SetActive(false)
  self.__isRefeshData = true
  local shopId = pageItem:GetCharDungeonShopId()
  ;
  (self.shopCtrl):GetShopData(shopId, function(shopData)
    -- function num : 0_11_0 , upvalues : self
    self.__isRefeshData = false
    self:ShowCharDungeonShop(shopData)
  end
, true)
  if (self.shopCtrl):ShopIsUnlockOnly(shopId) then
    do
      if self.heroGrowAct ~= nil then
        local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
        saveUserData:SetActivityHeroShopReaded((self.heroGrowAct):GetActId(), shopId)
      end
      do
        if self.__ShopRedDotNode ~= nil then
          local shopNode = (self.__ShopRedDotNode):GetChild(shopId)
          if shopNode ~= nil then
            shopNode:SetRedDotCount(0)
          end
        end
        self:SetRecommend(pageItem)
      end
    end
  end
end

UICharacterDungeonShop.SetRecommend = function(self, pageItem)
  -- function num : 0_12
  local IsRecommendShop = pageItem:IsItemRecommendShop()
  ;
  ((self.ui).recommendTitle):SetActive(IsRecommendShop)
end

UICharacterDungeonShop.ShowCharDungeonShop = function(self, shopData)
  -- function num : 0_13 , upvalues : _ENV, ShopUtil
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
  self:__RefreshCurShopUnlockInfo()
end

UICharacterDungeonShop.__RefreshCurShopUnlockInfo = function(self)
  -- function num : 0_14 , upvalues : CheckerTypeId, _ENV
  if self.__shopData == nil then
    return 
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  if (self.shopCtrl):ShopIsUnlockOnly((self.__shopData).shopId) then
    ((self.ui).cg_shopList).alpha = 1
    ;
    ((self.ui).conditionHead):SetActive(false)
  else
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).cg_shopList).alpha = 0.8
    ;
    ((self.ui).conditionHead):SetActive(true)
    local isConsumeUnlock = (((self.__shopData).shopCfg).pre_condition)[1] == CheckerTypeId.CharDungeonConsume
    ;
    ((self.ui).obj_withIcon):SetActive(isConsumeUnlock)
    ;
    (((self.ui).tex_Condition).gameObject):SetActive(not isConsumeUnlock)
    if isConsumeUnlock then
      if self.heroGrowAct == nil then
        error("consume unlock not fit extra shop init")
        return 
      end
      -- DECOMPILER ERROR at PC70: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_Costs).text = (string.format)("%d/%d", (self.heroGrowAct):GetHeroGrowCostNum(), (((self.__shopData).shopCfg).pre_para2)[1])
    else
      local lockInfo = (CheckCondition.GetUnlockInfoLua)(((self.__shopData).shopCfg).pre_condition, ((self.__shopData).shopCfg).pre_para1, ((self.__shopData).shopCfg).pre_para2)
      -- DECOMPILER ERROR at PC86: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Condition).text = lockInfo
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UICharacterDungeonShop.__OnCharShopUnlock = function(self, shopId)
  -- function num : 0_15
  local pageItem = (self.__shopPageList)[shopId]
  pageItem:RefreshCharDungeonUnlock(true)
  if self.__isRefeshData then
    return 
  end
  if self.__shopData == nil then
    return 
  end
  if (self.__shopData).shopId == shopId then
    self:__RefreshCurShopUnlockInfo()
  end
end

UICharacterDungeonShop.__OnShopNewItem = function(self, go)
  -- function num : 0_16 , upvalues : UINCharDungeonShopItem
  local shopItem = (UINCharDungeonShopItem.New)()
  shopItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__shopItemDic)[go] = shopItem
end

UICharacterDungeonShop.__OnShopItemChanged = function(self, go, index)
  -- function num : 0_17
  local shopItem = (self.__shopItemDic)[go]
  index = index + 1
  local shopGoodData = (self.__shopDataList)[index]
  shopItem:InitCharDungeonShopItem(shopGoodData, index, self.__OnCharDungeonItemClicked)
end

UICharacterDungeonShop.__GetItemByIndex = function(self, index)
  -- function num : 0_18 , upvalues : _ENV
  local go = ((self.ui).loop_shopList):GetCellByIndex(index - 1)
  do
    if not IsNull(go) then
      local shopItem = (self.__shopItemDic)[go]
      return shopItem
    end
    return nil
  end
end

UICharacterDungeonShop.OnCharDungeonItemClicked = function(self, index, shopItem)
  -- function num : 0_19 , upvalues : _ENV
  local shopGoodData = shopItem:GetDungeonShopItemData()
  if not (self.shopCtrl):ShopIsUnlockOnly(shopGoodData.shopId) then
    return 
  end
  if shopGoodData.isSoldOut then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
    -- function num : 0_19_0 , upvalues : _ENV, shopGoodData, self, index
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
      -- function num : 0_19_0_0 , upvalues : self, index
      local tmpShopItem = self:__GetItemByIndex(index)
      tmpShopItem:RefreshCharDungeonShopItem()
    end
, true, resIds)
    win:OnClickAdd(true)
  end
)
end

UICharacterDungeonShop.__OnClickReturn = function(self)
  -- function num : 0_20
  self:Delete()
end

UICharacterDungeonShop.__OnClickCoin = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.__shopCurrencyId]
  if itemCfg == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_21_0 , upvalues : itemCfg
    if win ~= nil then
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
end

UICharacterDungeonShop.__GetColor = function(self, colCfg)
  -- function num : 0_22 , upvalues : _ENV
  local colR = colCfg[1] / 255
  local colG = colCfg[2] / 255
  local colB = colCfg[3] / 255
  return (Color.New)(colR, colG, colB, 1)
end

UICharacterDungeonShop.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
  if self.__shopReddotFunc ~= nil then
    RedDotController:RemoveListener(self.__shopRedDotNodePath, self.__shopReddotFunc)
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUpdate, self.__heroGrowActivityEvent)
  TimerManager:StopTimer(self.__refrehsDayTimerId)
  ;
  (self.__conditionListener):Delete()
  self.__conditionListener = nil
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICharacterDungeonShop

