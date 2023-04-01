-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDcmpFilterGroup = class("UINAthDcmpFilterGroup", UIBaseNode)
local base = UIBaseNode
local AthDcmpFilterUtil = require("Game.Arithmetic.Decompose.Filter.AthDcmpFilterUtil")
UINAthDcmpFilterGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

local updItemFuncDic = {[(AthDcmpFilterUtil.FilterGroupType).Basic] = function(self, item, scrollData)
  -- function num : 0_1
end
, [(AthDcmpFilterUtil.FilterGroupType).Title] = function(self, item, scrollData)
  -- function num : 0_2
  local isSelectBasic = (self.isSelectBasicFunc)()
  item:InitAthDcmpFilterDynamicTitleGroup(scrollData, isSelectBasic)
end
, [(AthDcmpFilterUtil.FilterGroupType).Dynamic] = function(self, item, scrollData)
  -- function num : 0_3
  item:InitAthDcmpFilterDynamicGroup(scrollData)
end
}
UINAthDcmpFilterGroup.SetAthDcmpFilterGroupFunc = function(self, getItemFunc, recycleItemFunc, isSelectBasicFunc)
  -- function num : 0_4
  self.getItemFunc = getItemFunc
  self.recycleItemFunc = recycleItemFunc
  self.isSelectBasicFunc = isSelectBasicFunc
end

UINAthDcmpFilterGroup.InitAthDcmpFilterGroup = function(self, scrollData)
  -- function num : 0_5 , upvalues : updItemFuncDic, _ENV
  if self.scrollData == nil or (self.scrollData).groupType ~= scrollData.groupType then
    if self.scrollData ~= nil and self.groupItem ~= nil then
      self:RecycleAthDcmpFilterGroup()
    end
    self.groupItem = (self.getItemFunc)(scrollData)
  end
  local updItemFunc = updItemFuncDic[scrollData.groupType]
  if updItemFunc == nil then
    error("Cant get updItemFunc, groupType = " .. tostring(scrollData.groupType))
  else
    updItemFunc(self, self.groupItem, scrollData)
  end
  self.scrollData = scrollData
  ;
  ((self.groupItem).transform):SetParent(self.transform)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.groupItem).transform).anchoredPosition = Vector2.zero
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).layoutElement).minHeight = (((self.groupItem).transform).rect).height
end

UINAthDcmpFilterGroup.RecycleAthDcmpFilterGroup = function(self)
  -- function num : 0_6
  if self.scrollData == nil or self.groupItem == nil or ((self.groupItem).transform).parent ~= self.transform then
    return 
  end
  ;
  (self.recycleItemFunc)(self.scrollData, self.groupItem)
  self.scrollData = nil
  self.groupItem = nil
end

UINAthDcmpFilterGroup.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINAthDcmpFilterGroup

