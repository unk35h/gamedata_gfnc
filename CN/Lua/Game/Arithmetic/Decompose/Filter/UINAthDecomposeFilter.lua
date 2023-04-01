-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDecomposeFilter = class("UINAthDecomposeFilter", UIBaseNode)
local base = UIBaseNode
local UINAthDcmpFilterGroup = require("Game.Arithmetic.Decompose.Filter.UINAthDcmpFilterGroup")
local UINAthDcmpFilterBasicGroup = require("Game.Arithmetic.Decompose.Filter.GroupItem.UINAthDcmpFilterBasicGroup")
local UINAthDcmpFilterDynamicGroup = require("Game.Arithmetic.Decompose.Filter.GroupItem.UINAthDcmpFilterDynamicGroup")
local UINAthDcmpFilterDynamicTitleGroup = require("Game.Arithmetic.Decompose.Filter.GroupItem.UINAthDcmpFilterDynamicTitleGroup")
local AthDcmpFilterUtil = require("Game.Arithmetic.Decompose.Filter.AthDcmpFilterUtil")
local itemNumPerLine = 3
UINAthDecomposeFilter.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthDcmpFilterBasicGroup, UINAthDcmpFilterDynamicGroup, UINAthDcmpFilterDynamicTitleGroup
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.groupItemDic = {}
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.basicGroupItem = (UINAthDcmpFilterBasicGroup.New)()
  ;
  (self.basicGroupItem):Init((self.ui).baseGroup)
  ;
  (self.basicGroupItem):InitAthDcmpFilterBasicGroup(BindCallback(self, self._OnSelectBasicFilter))
  self.dyncItemPool = (UIItemPool.New)(UINAthDcmpFilterDynamicGroup, (self.ui).dynamicGroup, false)
  self.dyncTitleItemPool = (UIItemPool.New)(UINAthDcmpFilterDynamicTitleGroup, (self.ui).dynamicTitleGroup, false)
  ;
  (((self.ui).prefabHolder).gameObject):SetActive(false)
  self._GetItemFunc = BindCallback(self, self.GetAthDecomposeFilterGroupItem)
  self._RecycleItemFunc = BindCallback(self, self._ReturnGroupItem)
  self._IsAthDecomposeFilterSelectBasic = BindCallback(self, self.IsAthDecomposeFilterSelectBasic)
  self._IsSelectFunc = BindCallback(self, self._IsSelect)
  self.__onAthDataUpdate = BindCallback(self, self._OnAthDataUpdate)
  MsgCenter:AddListener(eMsgEventId.OnAthDataUpdate, self.__onAthDataUpdate)
end

UINAthDecomposeFilter.SetAthDecomposeFilterFunc = function(self, changeFilterFunc)
  -- function num : 0_1
  self.changeFilterFunc = changeFilterFunc
end

UINAthDecomposeFilter.InitAthDecomposeFilter = function(self, ignoreInstalled)
  -- function num : 0_2
  self.ignoreInstalled = ignoreInstalled
  ;
  (self.basicGroupItem):ResetAthDcmpFilterBasicGroup()
  self.selectedFilterDic = {}
  self:_UpdOriginAthDataList()
  self:_UpdFilterAll()
end

UINAthDecomposeFilter._UpdOriginAthDataList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.athDataListOrigin = (PlayerDataCenter.allAthData):GetAllAthList(nil, self.ignoreInstalled)
end

UINAthDecomposeFilter._InitData = function(self)
  -- function num : 0_4 , upvalues : _ENV, AthDcmpFilterUtil
  self.scrollDataList = {}
  ;
  (table.insert)(self.scrollDataList, {groupType = (AthDcmpFilterUtil.FilterGroupType).Basic})
end

local GetAttrInfo = function(attrId)
  -- function num : 0_5 , upvalues : _ENV
  local attrCfg = (ConfigData.attribute)[attrId]
  local isPercent = attrCfg.num_type == 2
  local showAttrId = attrId
  if attrCfg.merge_attribute ~= 0 then
    showAttrId = attrCfg.merge_attribute
    attrCfg = (ConfigData.attribute)[showAttrId]
  end
  local priority = attrCfg.attribute_priority
  if priority ~= 0 or not CommonUtil.UInt32Max then
    do return priority, isPercent, showAttrId end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINAthDecomposeFilter._RemoveInvalidFilter = function(self, filterType, valueDic)
  -- function num : 0_6 , upvalues : _ENV
  local selectDic = (self.selectedFilterDic)[filterType]
  if selectDic == nil then
    return 
  end
  for filterValue,v in pairs(selectDic) do
    if valueDic[filterValue] == nil then
      self:_ChangeSelect(filterType, filterValue, false)
    end
  end
end

UINAthDecomposeFilter._ChangeDynamicData = function(self, athDataList)
  -- function num : 0_7 , upvalues : _ENV, AthDcmpFilterUtil, GetAttrInfo, itemNumPerLine
  local mainAttriIdDic = {}
  local mainAttriIdList = {}
  local suitIdDic = {}
  local suitIdList = {}
  for k,athData in ipairs(athDataList) do
    local suitId = athData:GetAthSuit()
    if suitIdDic[suitId] == nil then
      suitIdDic[suitId] = true
      ;
      (table.insert)(suitIdList, suitId)
    end
    local mainAttrId = athData:GetAthMainAttrId(true)
    if mainAttriIdDic[mainAttrId] == nil then
      mainAttriIdDic[mainAttrId] = true
      ;
      (table.insert)(mainAttriIdList, mainAttrId)
    end
  end
  self:_RemoveInvalidFilter((AthDcmpFilterUtil.FilterType).Suit, suitIdDic)
  self:_RemoveInvalidFilter((AthDcmpFilterUtil.FilterType).MainAttri, mainAttriIdDic)
  ;
  (table.sort)(mainAttriIdList, function(attrIdA, attrIdB)
    -- function num : 0_7_0 , upvalues : GetAttrInfo
    local priorityA, isPercentA, showAttrIdA = GetAttrInfo(attrIdA)
    local priorityB, isPercentB, showAttrIdB = GetAttrInfo(attrIdB)
    if priorityA >= priorityB then
      do return priorityA == priorityB end
      if showAttrIdA >= showAttrIdB then
        do return showAttrIdA == showAttrIdB end
        if isPercentA ~= isPercentB then
          return isPercentB
        end
        do return attrIdA < attrIdB end
        -- DECOMPILER ERROR: 6 unprocessed JMP targets
      end
    end
  end
)
  ;
  (table.sort)(suitIdList, function(suitIdA, suitIdB)
    -- function num : 0_7_1 , upvalues : _ENV
    local suitCfgListA = (ConfigData.ath_suit)[suitIdA]
    if suitCfgListA ~= nil or not 0 then
      local maxSuitNumA = (suitCfgListA[#suitCfgListA]).num
    end
    local suitCfgListB = (ConfigData.ath_suit)[suitIdB]
    if suitCfgListB ~= nil or not 0 then
      local maxSuitNumB = (suitCfgListB[#suitCfgListB]).num
    end
    if maxSuitNumA >= maxSuitNumB then
      do return maxSuitNumA == maxSuitNumB end
      do return suitIdA < suitIdB end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  ;
  (table.insert)(self.scrollDataList, {groupType = (AthDcmpFilterUtil.FilterGroupType).Title, tileIdx = 0, isEmpty = (table.IsEmptyTable)(suitIdList)})
  local groupData = nil
  local groupNum = -1
  local allNum = (math.ceil)(#suitIdList / itemNumPerLine)
  for k,suitId in ipairs(suitIdList) do
    local curGroupNum = (math.ceil)(k / itemNumPerLine)
    if groupNum < curGroupNum then
      groupNum = curGroupNum
      groupData = {groupType = (AthDcmpFilterUtil.FilterGroupType).Dynamic, filterType = (AthDcmpFilterUtil.FilterType).Suit, 
filterValueList = {}
, isSelectFunc = self._IsSelectFunc, isLast = allNum == curGroupNum}
      ;
      (table.insert)(self.scrollDataList, groupData)
    end
    ;
    (table.insert)(groupData.filterValueList, suitId)
  end
  ;
  (table.insert)(self.scrollDataList, {groupType = (AthDcmpFilterUtil.FilterGroupType).Title, tileIdx = 1, isEmpty = (table.IsEmptyTable)(mainAttriIdList)})
  groupData = nil
  groupNum = -1
  allNum = (math.ceil)(#mainAttriIdList / itemNumPerLine)
  for k,mainAttriId in ipairs(mainAttriIdList) do
    local curGroupNum = (math.ceil)(k / itemNumPerLine)
    if groupNum < curGroupNum then
      groupNum = curGroupNum
      groupData = {groupType = (AthDcmpFilterUtil.FilterGroupType).Dynamic, filterType = (AthDcmpFilterUtil.FilterType).MainAttri, 
filterValueList = {}
, isSelectFunc = self._IsSelectFunc, isLast = allNum == curGroupNum}
      ;
      (table.insert)(self.scrollDataList, groupData)
    end
    ;
    (table.insert)(groupData.filterValueList, mainAttriId)
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINAthDecomposeFilter._RefillList = function(self, isRfill)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).scrollRect).totalCount = #self.scrollDataList
  if isRfill then
    ((self.ui).scrollRect):RefillCells()
  else
    ;
    ((self.ui).scrollRect):RefreshCells()
  end
end

UINAthDecomposeFilter.__OnNewItem = function(self, go)
  -- function num : 0_9 , upvalues : UINAthDcmpFilterGroup
  local item = (UINAthDcmpFilterGroup.New)()
  item:Init(go)
  item:SetAthDcmpFilterGroupFunc(self._GetItemFunc, self._RecycleItemFunc, self._IsAthDecomposeFilterSelectBasic)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.groupItemDic)[go] = item
end

UINAthDecomposeFilter.__OnChangeItem = function(self, go, index)
  -- function num : 0_10 , upvalues : _ENV
  local item = (self.groupItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local scrollData = (self.scrollDataList)[index + 1]
  if scrollData == nil then
    error("Cant get scrollData by index : " .. tostring(index))
    return 
  end
  item:InitAthDcmpFilterGroup(scrollData)
end

UINAthDecomposeFilter.IsAthDecomposeFilterSelectBasic = function(self)
  -- function num : 0_11 , upvalues : AthDcmpFilterUtil, _ENV
  for filterType = 1, AthDcmpFilterUtil.FilterTypeBaseMax do
    local selectDic = (self.selectedFilterDic)[filterType]
    if selectDic ~= nil and not (table.IsEmptyTable)(selectDic) then
      return true
    end
  end
  return false
end

local GetGroupItemFuncDic = {[(AthDcmpFilterUtil.FilterGroupType).Basic] = function(self, scrollData)
  -- function num : 0_12
  return self.basicGroupItem
end
, [(AthDcmpFilterUtil.FilterGroupType).Title] = function(self, scrollData)
  -- function num : 0_13
  local item = (self.dyncTitleItemPool):GetOne()
  return item
end
, [(AthDcmpFilterUtil.FilterGroupType).Dynamic] = function(self, scrollData)
  -- function num : 0_14 , upvalues : _ENV
  if not self._OnSelectDyncFilterFunc then
    self._OnSelectDyncFilterFunc = BindCallback(self, self._OnSelectDyncFilter)
    local item = (self.dyncItemPool):GetOne()
    item:SetAthDcmpFilterDynamicGroupFunc(self._OnSelectDyncFilterFunc)
    return item
  end
end
}
UINAthDecomposeFilter.GetAthDecomposeFilterGroupItem = function(self, scrollData)
  -- function num : 0_15 , upvalues : GetGroupItemFuncDic, _ENV
  local getGroupItemFunc = GetGroupItemFuncDic[scrollData.groupType]
  if getGroupItemFunc == nil then
    error("Cant get getGroupItemFunc, groupType = " .. tostring(scrollData.groupType))
    return 
  end
  return getGroupItemFunc(self, scrollData)
end

local ReturnGroupItemFuncDic = {[(AthDcmpFilterUtil.FilterGroupType).Basic] = function(self, item)
  -- function num : 0_16
end
, [(AthDcmpFilterUtil.FilterGroupType).Title] = function(self, item)
  -- function num : 0_17
  (self.dyncTitleItemPool):HideOne(item)
end
, [(AthDcmpFilterUtil.FilterGroupType).Dynamic] = function(self, item)
  -- function num : 0_18
  (self.dyncItemPool):HideOne(item)
end
}
UINAthDecomposeFilter.__OnReturnItem = function(self, go)
  -- function num : 0_19
  local groupItem = (self.groupItemDic)[go]
  groupItem:RecycleAthDcmpFilterGroup()
end

UINAthDecomposeFilter._ReturnGroupItem = function(self, scrollData, groupItem)
  -- function num : 0_20 , upvalues : ReturnGroupItemFuncDic, _ENV
  (groupItem.transform):SetParent((self.ui).prefabHolder)
  local returnFunc = ReturnGroupItemFuncDic[scrollData.groupType]
  if returnFunc == nil then
    error("Cant get returnFunc, groupType = " .. tostring(scrollData.groupType))
    return 
  end
  returnFunc(self, groupItem)
end

UINAthDecomposeFilter._FilterBasicFunc = function(self, athData)
  -- function num : 0_21 , upvalues : AthDcmpFilterUtil, _ENV
  for filterType = 1, AthDcmpFilterUtil.FilterTypeBaseMax do
    local selectedDic = (self.selectedFilterDic)[filterType]
    local filterFunc = (AthDcmpFilterUtil.FilterFunc)[filterType]
    if selectedDic ~= nil and not (table.IsEmptyTable)(selectedDic) and filterFunc(athData, selectedDic) == false then
      return false
    end
  end
  return true
end

UINAthDecomposeFilter._FilterAllFunc = function(self, athData)
  -- function num : 0_22 , upvalues : AthDcmpFilterUtil, _ENV
  for filterType = 1, (AthDcmpFilterUtil.FilterType).Max - 1 do
    local selectedDic = (self.selectedFilterDic)[filterType]
    local filterFunc = (AthDcmpFilterUtil.FilterFunc)[filterType]
    if selectedDic ~= nil and not (table.IsEmptyTable)(selectedDic) and filterFunc(athData, selectedDic) == false then
      return false
    end
  end
  return true
end

UINAthDecomposeFilter._ChangeSelect = function(self, filterType, filterValue, isOn)
  -- function num : 0_23
  if not (self.selectedFilterDic)[filterType] then
    local selectedDic = {}
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.selectedFilterDic)[filterType] = selectedDic
  if isOn then
    selectedDic[filterValue] = true
  else
    selectedDic[filterValue] = nil
  end
end

UINAthDecomposeFilter._IsSelect = function(self, filterType, filterValue)
  -- function num : 0_24
  local selectedDic = (self.selectedFilterDic)[filterType]
  if selectedDic == nil then
    return false
  end
  do return selectedDic[filterValue] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAthDecomposeFilter._OnSelectBasicFilter = function(self, filterType, filterValue, isOn)
  -- function num : 0_25
  self:_ChangeSelect(filterType, filterValue, isOn)
  self:_UpdFilterAll(true, true)
end

UINAthDecomposeFilter._UpdFilterAll = function(self, triggerChangeFilter, isClickFilter)
  -- function num : 0_26 , upvalues : _ENV
  local selectedBasic = self:IsAthDecomposeFilterSelectBasic()
  local athDataList = {}
  for k,athData in ipairs(self.athDataListOrigin) do
    if self:_FilterBasicFunc(athData) then
      (table.insert)(athDataList, athData)
    end
  end
  self:_InitData()
  if not selectedBasic or not athDataList then
    self:_ChangeDynamicData(table.emptytable)
    self:_RefillList(not selectedBasic)
    if triggerChangeFilter then
      self:_ChangeFilter(selectedBasic, isClickFilter)
    end
  end
end

UINAthDecomposeFilter._OnSelectDyncFilter = function(self, filterType, filterValue, isOn)
  -- function num : 0_27
  self:_ChangeSelect(filterType, filterValue, isOn)
  self:_ChangeFilter(true, true)
end

UINAthDecomposeFilter._ChangeFilter = function(self, isSelectedBasic, isClickFilter)
  -- function num : 0_28
  local filterFunc = nil
  if isSelectedBasic then
    filterFunc = function(athData)
    -- function num : 0_28_0 , upvalues : self
    return self:_FilterAllFunc(athData)
  end

  end
  ;
  (self.changeFilterFunc)(filterFunc, isClickFilter)
end

UINAthDecomposeFilter._OnAthDataUpdate = function(self)
  -- function num : 0_29
  self:_UpdOriginAthDataList()
  self:_UpdFilterAll(true)
end

UINAthDecomposeFilter.OnDelete = function(self)
  -- function num : 0_30 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnAthDataUpdate, self.__onAthDataUpdate)
  for k,v in pairs(self.groupItemDic) do
    v:Delete()
  end
  ;
  (self.basicGroupItem):Delete()
  ;
  (self.dyncItemPool):DeleteAll()
  ;
  (self.dyncTitleItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINAthDecomposeFilter

