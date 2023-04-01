-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDcmpFilterDynamicGroup = class("UINAthDcmpFilterDynamicGroup", UIBaseNode)
local base = UIBaseNode
local UINAthDcmpFilterItem = require("Game.Arithmetic.Decompose.Filter.GroupItem.UINAthDcmpFilterItem")
UINAthDcmpFilterDynamicGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthDcmpFilterItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.filterItemPool = (UIItemPool.New)(UINAthDcmpFilterItem, (self.ui).item, false)
end

UINAthDcmpFilterDynamicGroup.SetAthDcmpFilterDynamicGroupFunc = function(self, valueChangeFunc)
  -- function num : 0_1
  self.valueChangeFunc = valueChangeFunc
end

UINAthDcmpFilterDynamicGroup.InitAthDcmpFilterDynamicGroup = function(self, scrollData)
  -- function num : 0_2 , upvalues : _ENV
  (self.filterItemPool):HideAll()
  local filterType = scrollData.filterType
  for k,filterValue in ipairs(scrollData.filterValueList) do
    local item = (self.filterItemPool):GetOne()
    local isSelect = (scrollData.isSelectFunc)(filterType, filterValue)
    item:InitAthDcmpFilterItem(filterType, filterValue, self.valueChangeFunc, isSelect)
  end
  ;
  ((self.ui).line):SetActive(not scrollData.isLast)
end

UINAthDcmpFilterDynamicGroup.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self.filterItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINAthDcmpFilterDynamicGroup

