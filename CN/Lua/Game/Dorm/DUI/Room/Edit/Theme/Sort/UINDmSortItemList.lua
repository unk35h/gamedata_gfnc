-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINDmSortItemList = class("UINDmSortItemList", base)
local UINDmSortItem = require("Game.Dorm.DUI.Room.Edit.Theme.Sort.UINDmSortItem")
local DmThemeSortEnum = require("Game.Dorm.DUI.Room.Edit.Theme.Sort.DmThemeSortEnum")
local eDmFntThemeSortType = DmThemeSortEnum.eDmFntThemeSortType
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_InputUtility = CS.InputUtility
UINDmSortItemList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDmSortItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._sortItemPool = (UIItemPool.New)(UINDmSortItem, (self.ui).themeSortItem, false)
  self._OnClickSortItemFunc = BindCallback(self, self._OnClickSortItem)
  self.__onFingerDown = BindCallback(self, self.OnFingerDown)
end

UINDmSortItemList.InitDmSortItemList = function(self, sortData, themeRoot)
  -- function num : 0_1 , upvalues : cs_LeanTouch, eDmFntThemeSortType
  self:Show()
  ;
  (cs_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
  self._themeRoot = themeRoot
  self._sortData = sortData
  ;
  (self._sortItemPool):HideAll()
  for typeId = 1, eDmFntThemeSortType.Max - 1 do
    local sortItem = (self._sortItemPool):GetOne()
    sortItem:InitDmSortItem(typeId, sortData, self._OnClickSortItemFunc)
    if sortData:IsDmThemeCurSortType(typeId) then
      self._lastSortItem = sortItem
    end
  end
end

UINDmSortItemList._OnClickSortItem = function(self, sortItem, sortTypeId)
  -- function num : 0_2
  if (self._sortData):IsDmThemeCurSortType(sortTypeId) then
    (self._sortData):ChangeDmThemeCurSortTypeReverse(sortTypeId)
  else
    ;
    (self._sortData):SetDmThemeCurSortType(sortTypeId)
    ;
    (self._lastSortItem):UpdDmSortItem()
    self._lastSortItem = sortItem
  end
  sortItem:UpdDmSortItem()
  ;
  (self._themeRoot):DmThemeUpdSortFunc()
  ;
  (self._themeRoot):RefillDmRoomThemeList()
end

UINDmSortItemList.OnFingerDown = function(self, leanFinger)
  -- function num : 0_3 , upvalues : cs_InputUtility, _ENV
  if not (cs_InputUtility.OverUIValidTag)(TagConsts.ValidTarget) then
    self:Hide()
  end
end

UINDmSortItemList.OnHide = function(self)
  -- function num : 0_4 , upvalues : cs_LeanTouch, base
  (cs_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
  ;
  (base.OnHide)(self)
end

UINDmSortItemList.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self._sortItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINDmSortItemList

