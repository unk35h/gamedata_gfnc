-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarehouse = class("UIWarehouse", UIBaseWindow)
local base = UIBaseWindow
local UINSortButtonItem = require("Game.Hero.NewUI.SortList.UINSortButtonItem")
local UINWarehouseItem = require("Game.Warehouse.UINWarehouseItem")
local UINWarehouseTab = require("Game.Warehouse.UINWarehouseTab")
local JumpManager = require("Game.Jump.JumpManager")
local cs_Canvas = (CS.UnityEngine).Canvas
local cs_ResLoader = CS.ResLoader
local eWareHouseType = require("Game.Warehouse.eWareHouseType")
local allShowTabId = (eWareHouseType.wharehouseType).all
UIWarehouse.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSortButtonItem, UINWarehouseTab, cs_ResLoader
  (UIUtil.SetTopStatus)(self, self.OnClickClose)
  self.itemDic = {}
  self.dataList = {}
  self.dataDic = {}
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).itemScroll).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).itemScroll).onChangeItem = BindCallback(self, self.OnChangeItem)
  self.SortButtonItem = (UINSortButtonItem.New)()
  ;
  (self.SortButtonItem):Init((self.ui).sortBtnItem)
  ;
  (self.SortButtonItem):InitSortButtonItem(0, true, BindCallback(self, self.OnSortChangeCallback))
  self.tabPool = (UIItemPool.New)(UINWarehouseTab, (self.ui).btn_Page_pre)
  ;
  ((self.ui).btn_Page_pre):SetActive(false)
  self.resloader = (cs_ResLoader.Create)()
  self.__OnTabSelectCallback = BindCallback(self, self.OnTabSelectCallback)
  self.__OnItemUpdate = BindCallback(self, self.OnItemUpdateWarehouse)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemUpdate)
  self.__OnListenReddotWarehouse = BindCallback(self, self.OnListenReddotWarehouse)
  RedDotController:AddListener(RedDotDynPath.WarehousePath, self.__OnListenReddotWarehouse)
  self._onWarehouseItemClick = BindCallback(self, self._OnWarehouseItemClick)
end

UIWarehouse.InitWarehouse = function(self, itemId, openType)
  -- function num : 0_1 , upvalues : JumpManager, _ENV, cs_Canvas, eWareHouseType, allShowTabId
  self._lastCouldUseItemJump = JumpManager.couldUseItemJump
  JumpManager.couldUseItemJump = true
  self.tabId = 0
  self.isAscendState = 0
  ;
  (self.SortButtonItem):SetAllStateUI(false)
  local tabList = {}
  for _,cfg in pairs(ConfigData.warehouse) do
    (table.insert)(tabList, cfg)
  end
  ;
  (table.sort)(tabList, function(a, b)
    -- function num : 0_1_0
    if a.order_id >= b.order_id then
      do return a.order_id == b.order_id end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  local rectTr = ((self.ui).rect):GetComponent(typeof((CS.UnityEngine).RectTransform))
  local count = ((rectTr.rect).width - (((self.ui).rect).padding).left - (((self.ui).rect).padding).right + (((self.ui).rect).spacing).x) / ((((self.ui).rect).cellSize).x + (((self.ui).rect).spacing).x)
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).rect).constraintCount = (math.floor)(count)
  ;
  (self.tabPool):HideAll()
  for _,cfg in ipairs(tabList) do
    if cfg.id ~= (eWareHouseType.wharehouseType).LimitTimeItem or PlayerDataCenter:GetIsHasLimitTime() then
      local item = (self.tabPool):GetOne()
      item:InitWarehouseTab(cfg, self.__OnTabSelectCallback, self.resloader)
    end
  end
  if openType == nil then
    self:OnTabSelectCallback(allShowTabId)
  else
    self:OnTabSelectCallback(openType)
  end
  if itemId ~= nil then
    local index = (self.dataDic)[itemId]
    if index ~= nil then
      ((self.ui).itemScroll):LocationItem(index - 1, 0)
    end
  end
end

UIWarehouse.OnTabSelectCallback = function(self, id)
  -- function num : 0_2 , upvalues : _ENV
  if self.tabId == id then
    return 
  end
  for _,tab in ipairs((self.tabPool).listItem) do
    if (tab.warehouseTabCfg).id == self.tabId then
      tab:SetSelectState(false)
    end
    if (tab.warehouseTabCfg).id == id then
      tab:SetSelectState(true)
    end
  end
  self.tabId = id
  self:UpdateItemShow(false)
end

UIWarehouse.OnSortChangeCallback = function(self, sortType)
  -- function num : 0_3
  (self.SortButtonItem):ReversalAscend()
  self.isAscendState = (self.SortButtonItem).isAscend and 1 or -1
  self:UpdateItemShow(true)
end

UIWarehouse.UpdateItemShow = function(self, isJustSortChange)
  -- function num : 0_4 , upvalues : _ENV, allShowTabId, eWareHouseType, cs_Canvas
  self.__LimitTimeItems = {}
  if not isJustSortChange then
    self.dataList = {}
    local mergeItemDic = {}
    for itemId,itemData in pairs(PlayerDataCenter.itemDic) do
      local mergeList = eItemMergeDic[itemId]
      local itemCfg = itemData.itemCfg
      if mergeList ~= nil then
        itemId = mergeList[1]
        if mergeItemDic[itemId] == nil then
          mergeItemDic[itemId] = true
          itemCfg = (ConfigData.item)[itemId]
          local page = itemCfg.warehouse_page
          local isInPage = (self.tabId == allShowTabId and page > 0) or page == self.tabId
          isInPage = not itemData:IsLimitTime() or isInPage or (page > 0 and self.tabId == (eWareHouseType.wharehouseType).LimitTimeItem)
          if isInPage then
            if itemData:IsDynLimitTime() then
              for i = 1, itemData:GetStackCount() do
                (table.insert)(self.dataList, itemCfg)
              end
            else
              (table.insert)(self.dataList, itemCfg)
            end
          end
        end
        -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
    self.dataDic = {}
    for index,itemCfg in pairs(self.dataList) do
      -- DECOMPILER ERROR at PC85: Confused about usage of register: R8 in 'UnsetPending'

      (self.dataDic)[itemCfg.id] = index
    end
    local hasItem = #self.dataList > 0
    ;
    (((self.ui).itemScroll).gameObject):SetActive(hasItem)
    ;
    ((self.ui).scrollbar):SetActive(hasItem)
    ;
    ((self.ui).objEmpty):SetActive(not hasItem)
    if hasItem then
      (self.SortButtonItem):Show()
    else
      (self.SortButtonItem):Hide()
      return 
    end
  end
  if self.isAscendState == 1 then
    (table.sort)(self.dataList, function(a, b)
    -- function num : 0_4_0
    if a.quality >= b.quality then
      do return a.quality == b.quality end
      if a.warehouse_order >= b.warehouse_order then
        do return a.warehouse_order == b.warehouse_order end
        do return a.id < b.id end
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
)
  elseif self.isAscendState == -1 then
    (table.sort)(self.dataList, function(a, b)
    -- function num : 0_4_1
    if b.quality >= a.quality then
      do return a.quality == b.quality end
      if a.warehouse_order >= b.warehouse_order then
        do return a.warehouse_order == b.warehouse_order end
        do return a.id < b.id end
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
)
  else
    (table.sort)(self.dataList, function(a, b)
    -- function num : 0_4_2
    if a.warehouse_order >= b.warehouse_order then
      do return a.warehouse_order == b.warehouse_order end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  end
  self.dataDic = {}
  for index,itemCfg in pairs(self.dataList) do
    -- DECOMPILER ERROR at PC151: Confused about usage of register: R7 in 'UnsetPending'

    (self.dataDic)[itemCfg.id] = index
  end
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  -- DECOMPILER ERROR at PC160: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).itemScroll).totalCount = #self.dataList
  ;
  ((self.ui).itemScroll):RefillCells()
  -- DECOMPILER ERROR: 14 unprocessed JMP targets
end

UIWarehouse.OnInstantiateItem = function(self, go)
  -- function num : 0_5 , upvalues : UINWarehouseItem
  local item = (UINWarehouseItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UIWarehouse.OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local item = (self.itemDic)[go]
  local itemCfg = (self.dataList)[index + 1]
  local itemId = itemCfg.id
  local limitTimeItemCfg = (ConfigData.item_time_limit)[itemId]
  if limitTimeItemCfg ~= nil then
    if limitTimeItemCfg.type == eLimitTimeItemType.Dyn then
      local lastIndex = (self.dataDic)[itemId]
      local stackCount = PlayerDataCenter:GetDynLimtTimeItemStackCount(itemId)
      local tempIndex = index + 1 - lastIndex + stackCount
      local stackInfo = PlayerDataCenter:GetDynLimtTimeItemStackInfo(itemId, tempIndex)
      item:InitWarehouseDynLimitTimeItem(itemCfg, stackInfo, self._onWarehouseItemClick)
    else
      do
        do
          if limitTimeItemCfg.type == eLimitTimeItemType.Fixed then
            local count = PlayerDataCenter:GetItemCount(itemCfg.id)
            item:InitWarehouseLimitTimeItem(itemCfg, count, limitTimeItemCfg.time, self._onWarehouseItemClick)
          end
          if self.__LimitTimeItems == nil then
            self.__LimitTimeItems = {}
          end
          -- DECOMPILER ERROR at PC57: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.__LimitTimeItems)[item] = item
          if self.__LimitTimeUpdateTimerId == nil then
            self.__LimitTimeUpdateTimerId = TimerManager:StartTimer(60, self.__LimitTimeItemUpdate, self, false, false, true)
          end
          local count = PlayerDataCenter:GetItemCount(itemCfg.id)
          item:InitWarehouseItem(itemCfg, count, self._onWarehouseItemClick)
          -- DECOMPILER ERROR at PC89: Confused about usage of register: R8 in 'UnsetPending'

          if self.__LimitTimeItems ~= nil and (self.__LimitTimeItems)[item] ~= nil then
            (self.__LimitTimeItems)[item] = nil
          end
        end
      end
    end
  end
end

UIWarehouse.__LimitTimeItemUpdate = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.__LimitTimeItems == nil then
    TimerManager:StopTimer(self.__LimitTimeUpdateTimerId)
    self.__LimitTimeUpdateTimerId = nil
    return 
  end
  for k,v in pairs(self.__LimitTimeItems) do
    v:UpdateLimitTimeDetail()
  end
end

UIWarehouse.GetWarehouseItemByIndex = function(self, index)
  -- function num : 0_8
  local go = ((self.ui).itemScroll):GetCellByIndex(index - 1)
  return (self.itemDic)[go]
end

UIWarehouse.OnItemUpdateWarehouse = function(self, itemUpdate)
  -- function num : 0_9 , upvalues : _ENV
  for itemId,isdelete in pairs(itemUpdate) do
    if self:IsItemInCurTab(itemId) then
      local index = (self.dataDic)[itemId]
      if isdelete or index == nil then
        self:UpdateItemShow(false)
        break
      else
        local count = PlayerDataCenter:GetItemCount(itemId)
        local item = self:GetWarehouseItemByIndex(index)
        if item ~= nil then
          item:SetNum(count)
        end
      end
    end
  end
end

UIWarehouse.IsItemInCurTab = function(self, itemId)
  -- function num : 0_10 , upvalues : _ENV, allShowTabId, eWareHouseType
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg ~= nil then
    local page = itemCfg.warehouse_page
    local isInPage = (self.tabId == allShowTabId and page > 0) or page == self.tabId
    local limitTimeItemCfg = (ConfigData.item_time_limit)[itemId]
    -- DECOMPILER ERROR at PC31: Unhandled construct in 'MakeBoolean' P1

    if not isInPage and (page <= 0 or self.tabId ~= (eWareHouseType.wharehouseType).LimitTimeItem) then
      do
        isInPage = limitTimeItemCfg == nil
        do return isInPage end
        do return false end
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
end

UIWarehouse.OnListenReddotWarehouse = function(self)
  -- function num : 0_11 , upvalues : _ENV
  for _,tabItem in ipairs((self.tabPool).listItem) do
    tabItem:RefreshRedDotState()
  end
  for _,warehouseItem in pairs(self.itemDic) do
    warehouseItem:RefreshRedDotState()
  end
end

UIWarehouse._OnWarehouseItemClick = function(self, itemCfg, stackInfo)
  -- function num : 0_12 , upvalues : _ENV
  if GuideManager.inGuide and not GuideManager:HasGuideFeature((GuideEnum.GuideFeature).ItemDetail) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_12_0 , upvalues : _ENV, itemCfg, stackInfo
    if win ~= nil then
      local limitTimeItemCfg = (ConfigData.item_time_limit)[itemCfg.id]
      if limitTimeItemCfg ~= nil then
        win:InitLimitTimeItemDetail(itemCfg, stackInfo)
        win:ShowUseGiftBtn(itemCfg)
      else
        win:InitCommonItemDetail(itemCfg)
        win:ShowUseGiftBtn(itemCfg)
      end
    end
  end
)
end

UIWarehouse.OnClickClose = function(self)
  -- function num : 0_13 , upvalues : JumpManager
  JumpManager.couldUseItemJump = self._lastCouldUseItemJump
  self:OnCloseWin()
  self:Delete()
end

UIWarehouse.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  self.__LimitTimeItems = nil
  TimerManager:StopTimer(self.__LimitTimeUpdateTimerId)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemUpdate)
  RedDotController:RemoveListener(RedDotDynPath.WarehousePath, self.__OnListenReddotWarehouse)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWarehouse

