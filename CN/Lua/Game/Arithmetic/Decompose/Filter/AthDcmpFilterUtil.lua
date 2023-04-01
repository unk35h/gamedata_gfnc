-- params : ...
-- function num : 0 , upvalues : _ENV
local AthDcmpFilterUtil = {}
AthDcmpFilterUtil.FilterTypeBaseMax = 3
AthDcmpFilterUtil.FilterType = {Area = 1, Quality = 2, Size = 3, Suit = 4, MainAttri = 5, Max = 6}
AthDcmpFilterUtil.FilterBaseValue = {
[(AthDcmpFilterUtil.FilterType).Area] = {1, 2, 3}
, 
[(AthDcmpFilterUtil.FilterType).Quality] = {3, 4, 5}
, 
[(AthDcmpFilterUtil.FilterType).Size] = {1, 2}
}
AthDcmpFilterUtil.FilterFunc = {[(AthDcmpFilterUtil.FilterType).Area] = function(athData, valueDic)
  -- function num : 0_0
  local area = athData:GetAthAreaType()
  do return valueDic[area] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(AthDcmpFilterUtil.FilterType).Quality] = function(athData, valueDic)
  -- function num : 0_1
  local quality = athData:GetAthQuality()
  do return valueDic[quality] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(AthDcmpFilterUtil.FilterType).Size] = function(athData, valueDic)
  -- function num : 0_2
  local size = athData:GetAthSize()
  do return valueDic[size] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(AthDcmpFilterUtil.FilterType).Suit] = function(athData, valueDic)
  -- function num : 0_3
  local suitId = athData:GetAthSuit()
  do return valueDic[suitId] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(AthDcmpFilterUtil.FilterType).MainAttri] = function(athData, valueDic)
  -- function num : 0_4
  local mainAttrId = athData:GetAthMainAttrId(true)
  do return valueDic[mainAttrId] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
}
AthDcmpFilterUtil.FilterGroupType = {Basic = 1, Title = 2, Dynamic = 3}
return AthDcmpFilterUtil

