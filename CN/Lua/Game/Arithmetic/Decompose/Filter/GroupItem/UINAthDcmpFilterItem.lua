-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAthDcmpFilterItem = class("UINAthDcmpFilterItem", UIBaseNode)
local base = UIBaseNode
local AthDcmpFilterUtil = require("Game.Arithmetic.Decompose.Filter.AthDcmpFilterUtil")
local GetFilterNameFuncDic = {[(AthDcmpFilterUtil.FilterType).Area] = function(self, filterValue)
  -- function num : 0_0 , upvalues : _ENV
  local areaCfg = (ConfigData.ath_area)[filterValue]
  if areaCfg == nil then
    error("Cant get ConfigData.ath_area, id = " .. tostring(filterValue))
    return 
  end
  ;
  ((self.ui).tex_ItemName):SetIndex(0, (LanguageUtil.GetLocaleText)(areaCfg.name2))
end
, [(AthDcmpFilterUtil.FilterType).Quality] = function(self, filterValue)
  -- function num : 0_1
  local idx = filterValue - 3
  ;
  ((self.ui).tex_ItemName):SetIndex(idx)
end
, [(AthDcmpFilterUtil.FilterType).Size] = function(self, filterValue)
  -- function num : 0_2
  local idx = filterValue - 1
  ;
  ((self.ui).tex_ItemName):SetIndex(idx)
end
, [(AthDcmpFilterUtil.FilterType).Suit] = function(self, filterValue)
  -- function num : 0_3 , upvalues : _ENV
  if filterValue == 0 then
    ((self.ui).tex_ItemName):SetIndex(1)
    return 
  end
  local suitCfg = ((ConfigData.ath_suit).suitParamDic)[filterValue]
  if suitCfg == nil then
    error("Cant get ConfigData.ath_suit.suitParamDic, id = " .. tostring(filterValue))
  end
  ;
  ((self.ui).tex_ItemName):SetIndex(0, (LanguageUtil.GetLocaleText)(suitCfg.name))
end
, [(AthDcmpFilterUtil.FilterType).MainAttri] = function(self, filterValue)
  -- function num : 0_4 , upvalues : _ENV
  local attrCfg = (ConfigData.attribute)[filterValue]
  local isPercent = attrCfg.num_type == 2
  local showAttrId = filterValue
  if attrCfg.merge_attribute ~= 0 then
    showAttrId = attrCfg.merge_attribute
  end
  local name = ConfigData:GetAttribute(showAttrId)
  if isPercent then
    name = name .. "%"
  end
  ;
  ((self.ui).tex_ItemName):SetIndex(0, name)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end
}
UINAthDcmpFilterItem.OnInit = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Root, self, self._OnChangeValue)
end

UINAthDcmpFilterItem.InitAthDcmpFilterItem = function(self, filterType, filterValue, changeValueFunc, isOn)
  -- function num : 0_6
  self.filterType = filterType
  self.filterValue = filterValue
  self.changeValueFunc = changeValueFunc
  self:SetAthDcmpFilterItemIsOn(isOn, true)
  self:_UpdName()
end

UINAthDcmpFilterItem._UpdName = function(self)
  -- function num : 0_7 , upvalues : GetFilterNameFuncDic, _ENV
  local getFilterNameFunc = GetFilterNameFuncDic[self.filterType]
  if getFilterNameFunc == nil then
    error("Unsupported filterType : " .. tostring(self.filterType))
    return 
  end
  getFilterNameFunc(self, self.filterValue)
end

UINAthDcmpFilterItem.SetAthDcmpFilterItemIsOn = function(self, isOn, isReset)
  -- function num : 0_8
  self.isReset = isReset
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tog_Root).isOn = isOn
  self.isReset = false
end

UINAthDcmpFilterItem._OnChangeValue = function(self, isOn)
  -- function num : 0_9
  ;
  ((self.ui).img_Select):SetIndex(isOn and 1 or 0)
  if self.isReset then
    return 
  end
  if self.changeValueFunc ~= nil then
    (self.changeValueFunc)(self.filterType, self.filterValue, isOn)
  end
end

UINAthDcmpFilterItem.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINAthDcmpFilterItem

