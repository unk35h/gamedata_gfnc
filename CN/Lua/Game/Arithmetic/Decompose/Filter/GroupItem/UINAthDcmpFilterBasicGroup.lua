-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDcmpFilterBasicGroup = class("UINAthDcmpFilterBasicGroup", UIBaseNode)
local base = UIBaseNode
local UINAthDcmpFilterItem = require("Game.Arithmetic.Decompose.Filter.GroupItem.UINAthDcmpFilterItem")
local AthDcmpFilterUtil = require("Game.Arithmetic.Decompose.Filter.AthDcmpFilterUtil")
UINAthDcmpFilterBasicGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthDcmpFilterItem, AthDcmpFilterUtil
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.areaItemPool = (UIItemPool.New)(UINAthDcmpFilterItem, (self.ui).areaItem, false)
  self.qualityItemPool = (UIItemPool.New)(UINAthDcmpFilterItem, (self.ui).qualityItem, false)
  self.sizeItemPool = (UIItemPool.New)(UINAthDcmpFilterItem, (self.ui).sizeItem, false)
  self._OnItemValueChangeFunc = BindCallback(self, self._OnItemValueChange)
  for k,v in ipairs((AthDcmpFilterUtil.FilterBaseValue)[(AthDcmpFilterUtil.FilterType).Area]) do
    ((self.areaItemPool):GetOne()):InitAthDcmpFilterItem((AthDcmpFilterUtil.FilterType).Area, v, self._OnItemValueChangeFunc, false)
  end
  for k,v in ipairs((AthDcmpFilterUtil.FilterBaseValue)[(AthDcmpFilterUtil.FilterType).Quality]) do
    ((self.qualityItemPool):GetOne()):InitAthDcmpFilterItem((AthDcmpFilterUtil.FilterType).Quality, v, self._OnItemValueChangeFunc, false)
  end
  for k,v in ipairs((AthDcmpFilterUtil.FilterBaseValue)[(AthDcmpFilterUtil.FilterType).Size]) do
    ((self.sizeItemPool):GetOne()):InitAthDcmpFilterItem((AthDcmpFilterUtil.FilterType).Size, v, self._OnItemValueChangeFunc, false)
  end
end

UINAthDcmpFilterBasicGroup.ResetAthDcmpFilterBasicGroup = function(self)
  -- function num : 0_1 , upvalues : _ENV
  for k,v in ipairs((self.areaItemPool).listItem) do
    v:SetAthDcmpFilterItemIsOn(false, true)
  end
  for k,v in ipairs((self.qualityItemPool).listItem) do
    v:SetAthDcmpFilterItemIsOn(false, true)
  end
  for k,v in ipairs((self.sizeItemPool).listItem) do
    v:SetAthDcmpFilterItemIsOn(false, true)
  end
end

UINAthDcmpFilterBasicGroup.InitAthDcmpFilterBasicGroup = function(self, itemValueChangeFunc)
  -- function num : 0_2
  self.itemValueChangeFunc = itemValueChangeFunc
end

UINAthDcmpFilterBasicGroup._OnItemValueChange = function(self, filterType, filterValue, isOn)
  -- function num : 0_3
  if self.itemValueChangeFunc ~= nil then
    (self.itemValueChangeFunc)(filterType, filterValue, isOn)
  end
end

UINAthDcmpFilterBasicGroup.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.areaItemPool):DeleteAll()
  ;
  (self.qualityItemPool):DeleteAll()
  ;
  (self.sizeItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINAthDcmpFilterBasicGroup

