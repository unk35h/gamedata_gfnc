-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINDmFntThemeList = class("UINDmFntThemeList", base)
local UINDmFntThemeListItem = require("Game.Dorm.DUI.Room.Edit.Theme.UINDmFntThemeListItem")
local ShopEnum = require("Game.Shop.ShopEnum")
local DmFntThemeData = require("Game.Dorm.DUI.Room.Edit.Theme.Data.DmFntThemeData")
local DmFntThemeSortData = require("Game.Dorm.DUI.Room.Edit.Theme.Data.DmFntThemeSortData")
local DmThemeSortEnum = require("Game.Dorm.DUI.Room.Edit.Theme.Sort.DmThemeSortEnum")
local eDmFntThemeSortType = DmThemeSortEnum.eDmFntThemeSortType
UINDmFntThemeList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SortTheme, self, self._OnClickSort)
  ;
  ((self.ui).themeSortList):SetActive(false)
  self._SelectThemeFunc = BindCallback(self, self._OnSelectTheme)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.themeItemDic = {}
end

UINDmFntThemeList.InitDmFntThemeList = function(self, inBigRoom, editRoomData, resLoader, roomEditRoot)
  -- function num : 0_1 , upvalues : DmFntThemeSortData, _ENV
  self._sortData = (DmFntThemeSortData.New)()
  self._roomEditRoot = roomEditRoot
  self:Show()
  self._inBigRoom = inBigRoom
  self._editRoomData = editRoomData
  self._resLoader = resLoader
  self._inShopThemeIdDic = {}
  local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  local curNum, totalNum = 0, #(ConfigData.shop).dmThemeShopIdList
  for k,shopId in ipairs((ConfigData.shop).dmThemeShopIdList) do
    shopCtrl:GetShopData(shopId, function(shopData)
    -- function num : 0_1_0 , upvalues : self, curNum, totalNum
    if shopData ~= nil then
      shopData:GetShopInSellDormThemeDic(self._inShopThemeIdDic)
    end
    curNum = curNum + 1
    if curNum == totalNum then
      self:_InitData()
      self:RefillDmRoomThemeList(true)
    end
  end
)
  end
end

UINDmFntThemeList._InitData = function(self)
  -- function num : 0_2 , upvalues : _ENV, DmFntThemeData
  self._themeDataList = {}
  for k,themeCfg in pairs(ConfigData.dorm_theme) do
    local inSell = (self._inShopThemeIdDic)[themeCfg.id] == true
    local data = (DmFntThemeData.New)(themeCfg, inSell, self._editRoomData)
    ;
    (table.insert)(self._themeDataList, data)
  end
  self:DmThemeUpdSortFunc()
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINDmFntThemeList.DmThemeUpdSortFunc = function(self, sortType, isReverse)
  -- function num : 0_3 , upvalues : _ENV
  local sortFunc = (self._sortData):GetDmThemeSortFunc(self._inBigRoom)
  ;
  (table.sort)(self._themeDataList, sortFunc)
  ;
  ((self._sortData).ClearDmThemeSort)()
end

UINDmFntThemeList.RefillDmRoomThemeList = function(self, refill)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).scrollRect).totalCount = #self._themeDataList
  if refill then
    ((self.ui).scrollRect):RefillCells()
  else
    ;
    ((self.ui).scrollRect):RefreshCells()
  end
end

UINDmFntThemeList.__OnNewItem = function(self, go)
  -- function num : 0_5 , upvalues : UINDmFntThemeListItem
  local item = (UINDmFntThemeListItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.themeItemDic)[go] = item
end

UINDmFntThemeList.__OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local item = (self.themeItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local themeData = (self._themeDataList)[index + 1]
  if themeData == nil then
    error("Can\'t find themeData by index, index = " .. tonumber(index))
  end
  item:InitDmFntThemeListItem(themeData, self._editRoomData, self._resLoader, self._SelectThemeFunc)
end

UINDmFntThemeList._OnSelectTheme = function(self, themeCfg)
  -- function num : 0_7
  (self._roomEditRoot):ShowDmRoomEditThemeFntList(themeCfg)
end

UINDmFntThemeList._OnClickSort = function(self)
  -- function num : 0_8 , upvalues : _ENV
  do
    if self._sortList == nil then
      local UINDmSortItemList = require("Game.Dorm.DUI.Room.Edit.Theme.Sort.UINDmSortItemList")
      self._sortList = (UINDmSortItemList.New)()
      ;
      (self._sortList):Init((self.ui).themeSortList)
    end
    if (self._sortList).active then
      (self._sortList):Hide()
    else
      ;
      (self._sortList):InitDmSortItemList(self._sortData, self)
    end
  end
end

UINDmFntThemeList.OnShow = function(self)
  -- function num : 0_9
  (((self.ui).btn_SortTheme).gameObject):SetActive(true)
end

UINDmFntThemeList.OnHide = function(self)
  -- function num : 0_10
  (((self.ui).btn_SortTheme).gameObject):SetActive(false)
end

UINDmFntThemeList.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  if self._sortList then
    (self._sortList):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINDmFntThemeList

