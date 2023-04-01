-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopPageButtonList = class("UINShopPageButtonList", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
local UINShopLeftPage = require("Game.ShopMain.UINShopLeftPage")
local UINShopLeftPageWithSub = require("Game.ShopMain.UINShopLeftPageWithSub")
UINShopPageButtonList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINShopLeftPage, UINShopLeftPageWithSub
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.shopCtrl = nil
  self.resloader = nil
  self.openPageCallback = nil
  self.groupItemDic = nil
  self.shopItemDic = nil
  self.leftPagePool = (UIItemPool.New)(UINShopLeftPage, (self.ui).obj_btn_Page)
  ;
  ((self.ui).obj_btn_Page):SetActive(false)
  self.leftPageWithSubPool = (UIItemPool.New)(UINShopLeftPageWithSub, (self.ui).obj_btn_PageHasSub)
  ;
  ((self.ui).obj_btn_PageHasSub):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recommend, self, self.OnClickRecomand)
  self.__RedDotEvent = BindCallback(self, self.OnShopReddotRefresh)
  RedDotController:AddListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
end

UINShopPageButtonList.InitPageBtnList = function(self, shopCtrl, resloader, openPageCallback, uishop)
  -- function num : 0_1
  self.shopCtrl = shopCtrl
  self.resloader = resloader
  self.openPageCallback = openPageCallback
  self.uishop = uishop
end

UINShopPageButtonList.RefreshPageBtns = function(self, isBeforeUnlockShop)
  -- function num : 0_2 , upvalues : _ENV, ShopEnum
  (self.leftPagePool):HideAll()
  ;
  (self.leftPageWithSubPool):HideAll()
  self.groupItemDic = {}
  self.shopItemDic = {}
  local groups = {}
  for _,groupCfg in pairs(ConfigData.shop_classification) do
    (table.insert)(groups, groupCfg)
  end
  ;
  (table.sort)(groups, function(a, b)
    -- function num : 0_2_0
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local showShopdic = {}
  for index,groupCfg in ipairs(groups) do
    local isOpen = false
    for _,shopId in ipairs(groupCfg.sub_ids) do
      if (self.shopCtrl):ShopIsUnlock(shopId) then
        isOpen = true
        break
      end
    end
    do
      local subIds = groupCfg.sub_ids
      if groupCfg.soldout == (ShopEnum.ButtonListRule).gift then
        subIds = {}
        local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
        for _,pageId in ipairs(groupCfg.sub_ids) do
          if payGiftCtrl:CheckPageIdIsGiftShop(pageId) and #payGiftCtrl:GetShowPayGiftByPageId(pageId, false) > 0 then
            (table.insert)(subIds, pageId)
          end
        end
      end
      do
        if isOpen then
          if #subIds == 1 then
            local shopId = subIds[1]
            if not isBeforeUnlockShop or ((ConfigData.game_config).shopShowBeforeUnlockDic)[shopId] then
              local item = (self.leftPagePool):GetOne(true)
              item:InitPage(groupCfg, self.openPageCallback, self.resloader, shopId)
              -- DECOMPILER ERROR at PC112: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (item.gameObject).name = tostring(shopId)
              local isHaveTime, _, limitTime = (self.shopCtrl):GetIsThisShopHasTimeLimit(shopId)
              if isHaveTime and limitTime ~= nil and limitTime ~= -1 then
                (self.uishop):SetNeedRefreshTm(limitTime)
              end
              -- DECOMPILER ERROR at PC128: Confused about usage of register: R16 in 'UnsetPending'

              ;
              (self.shopItemDic)[shopId] = item
            end
          else
            do
              local item = (self.leftPageWithSubPool):GetOne(true)
              local subItems = item:InitPage(groupCfg, self.openPageCallback, self.resloader, self.uishop, isBeforeUnlockShop, subIds)
              -- DECOMPILER ERROR at PC146: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (item.gameObject).name = tostring(groupCfg.id)
              -- DECOMPILER ERROR at PC149: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (self.groupItemDic)[groupCfg.id] = item
              if subItems ~= nil then
                for _,subItem in pairs(subItems) do
                  -- DECOMPILER ERROR at PC158: Confused about usage of register: R18 in 'UnsetPending'

                  (self.shopItemDic)[subItem.shopId] = subItem
                end
              end
              do
                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out DO_STMT

              end
            end
          end
        end
      end
    end
  end
  local recommendShopUnlock = (self.shopCtrl):ShopIsUnlock((ShopEnum.ShopId).recomme)
  if recommendShopUnlock then
    (((self.ui).btn_Recommend).gameObject):SetActive(not isBeforeUnlockShop)
  end
end

UINShopPageButtonList.Roll2SelectShopBtn = function(self, selectItem)
  -- function num : 0_3 , upvalues : _ENV
  if selectItem ~= nil then
    (UIUtil.ScrollRectLocation)((self.ui).scroll, selectItem, true, true)
  end
end

UINShopPageButtonList.SelectShop = function(self, selectShopId)
  -- function num : 0_4 , upvalues : _ENV
  for shopId,item in pairs(self.shopItemDic) do
    item:RefreshState(selectShopId == shopId)
  end
  for groupId,groupItem in pairs(self.groupItemDic) do
    groupItem:RefreshState(false)
  end
  do
    if (self.shopItemDic)[selectShopId] ~= nil then
      local selectGroupItem = ((self.shopItemDic)[selectShopId]).parentBtn
      if selectGroupItem ~= nil then
        selectGroupItem:RefreshState(true)
        self:Roll2SelectShopBtn((self.shopItemDic)[selectShopId])
      else
        self:Roll2SelectShopBtn((self.shopItemDic)[selectShopId])
      end
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINShopPageButtonList.OnClickRecomand = function(self)
  -- function num : 0_5 , upvalues : ShopEnum
  if self.openPageCallback ~= nil then
    (self.openPageCallback)((ShopEnum.ShopId).recomme)
  end
end

UINShopPageButtonList.OnShopReddotRefresh = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for _,groupItem in pairs(self.groupItemDic) do
    groupItem:RefreshRedDotState()
  end
  for _,shopItme in pairs(self.shopItemDic) do
    if shopItme.RefreshRedDotState ~= nil then
      shopItme:RefreshRedDotState()
    end
  end
end

UINShopPageButtonList.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  RedDotController:RemoveListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
  ;
  (base.OnDelete)(self)
end

return UINShopPageButtonList

