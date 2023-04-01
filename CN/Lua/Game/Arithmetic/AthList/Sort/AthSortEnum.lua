-- params : ...
-- function num : 0 , upvalues : _ENV
local AthSortEnum = {}
AthSortEnum.eKindType = {GetOrder = 1, Quality = 2, Attribute = 3}
AthSortEnum.KindTypeMaxCount = 3
AthSortEnum.eKindTypeNum = {[(AthSortEnum.eKindType).GetOrder] = 1, [(AthSortEnum.eKindType).Quality] = 1, [(AthSortEnum.eKindType).Attribute] = #(ConfigData.game_config).athSortAttrList}
local normalSortFunc = function(a, b)
  -- function num : 0_0
  local powerA = a:GetAthFightPower()
  local powerB = b:GetAthFightPower()
  if a.id >= b.id then
    do return powerA ~= powerB end
    do return powerB < powerA end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

local subAttrQualityWeightDic = {}
local attrSortFunc = function(a, b)
  -- function num : 0_1 , upvalues : subAttrQualityWeightDic
  if subAttrQualityWeightDic[a.uid] == nil then
    subAttrQualityWeightDic[a.uid] = a:GetAthSubAttrQualityWeight()
  end
  local weightA = subAttrQualityWeightDic[a.uid]
  if subAttrQualityWeightDic[b.uid] == nil then
    subAttrQualityWeightDic[b.uid] = b:GetAthSubAttrQualityWeight()
  end
  local weightB = subAttrQualityWeightDic[b.uid]
  if weightB >= weightA then
    do return weightA == weightB end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

AthSortEnum.ResetAthSort = function(areaId)
  -- function num : 0_2 , upvalues : subAttrQualityWeightDic
  subAttrQualityWeightDic = {}
end

local curKindValue, curReverseOrder = nil, nil
AthSortEnum.SetAthSortKindParam = function(kindValue, reverseOrder)
  -- function num : 0_3 , upvalues : curKindValue, curReverseOrder
  curKindValue = kindValue
  curReverseOrder = reverseOrder
end

AthSortEnum.GetSortFunc = function(kindType, kindValue, isConsumeSort)
  -- function num : 0_4 , upvalues : AthSortEnum
  if isConsumeSort then
    return (AthSortEnum.eConsumeSortFunc)[kindType]
  end
  return (AthSortEnum.eSortFunc)[kindType]
end

AthSortEnum.eSortFunc = {[(AthSortEnum.eKindType).GetOrder] = function(a, b)
  -- function num : 0_5 , upvalues : normalSortFunc, curReverseOrder
  local hasBindA = a.bindInfo ~= nil
  local hasBindB = b.bindInfo ~= nil
  if hasBindA == hasBindB then
    if a.athTs == b.athTs then
      return normalSortFunc(a, b)
    elseif b.athTs >= a.athTs then
      do return not curReverseOrder end
      do return a.athTs < b.athTs end
      do return hasBindB end
      -- DECOMPILER ERROR: 8 unprocessed JMP targets
    end
  end
end
, [(AthSortEnum.eKindType).Quality] = function(a, b)
  -- function num : 0_6 , upvalues : curReverseOrder, _ENV, attrSortFunc
  local hasBindA = a.bindInfo ~= nil
  local hasBindB = b.bindInfo ~= nil
  if hasBindA ~= hasBindB then
    return hasBindB
  end
  local qualtyA = a:GetAthQuality()
  local qualtyB = b:GetAthQuality()
  if curReverseOrder then
    if qualtyB >= qualtyA then
      do return qualtyA == qualtyB end
      do return qualtyA < qualtyB end
      local suitNumA = a:GetAthDataSuitNum()
      local suitNumB = b:GetAthDataSuitNum()
      if curReverseOrder then
        if suitNumB >= suitNumA then
          do return suitNumA == suitNumB end
          do return suitNumA < suitNumB end
          local suitIdA, cfltIdA = a:GetAthSuit()
          local suitIdB, cfltIdB = b:GetAthSuit()
          if suitIdB >= suitIdA then
            do return suitIdA == suitIdB end
            if cfltIdA >= cfltIdB then
              do return cfltIdA == cfltIdB end
              local mainAttrIdA = ((a.athMainAttrCfg).attrtibute_id)[1]
              local mainAttrIdB = ((b.athMainAttrCfg).attrtibute_id)[1]
              if not ((ConfigData.game_config).athAtrSortDic)[mainAttrIdA] then
                local mainAtrOrderA = math.maxinteger
              end
              if not ((ConfigData.game_config).athAtrSortDic)[mainAttrIdB] then
                local mainAtrOrderB = math.maxinteger
              end
              if mainAtrOrderA >= mainAtrOrderB then
                do return mainAtrOrderA == mainAtrOrderB end
                if mainAttrIdA >= mainAttrIdB then
                  do return mainAttrIdA == mainAttrIdB end
                  local attrValueA = ((a.athMainAttrCfg).attrtibute_num)[1]
                  local attrValueB = ((b.athMainAttrCfg).attrtibute_num)[1]
                  if curReverseOrder then
                    if attrValueB >= attrValueA then
                      do return attrValueA == attrValueB end
                      do return attrValueA < attrValueB end
                      do return attrSortFunc(a, b) end
                      -- DECOMPILER ERROR: 25 unprocessed JMP targets
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
, [(AthSortEnum.eKindType).Attribute] = function(a, b)
  -- function num : 0_7 , upvalues : _ENV, curKindValue, curReverseOrder, attrSortFunc
  local hasBindA = a.bindInfo ~= nil
  local hasBindB = b.bindInfo ~= nil
  if hasBindA ~= hasBindB then
    return hasBindB
  end
  local attrId = ((ConfigData.game_config).athSortAttrList)[curKindValue]
  local mainAttrIdA = ((a.athMainAttrCfg).attrtibute_id)[1]
  local mainAttrIdB = ((b.athMainAttrCfg).attrtibute_id)[1]
  local attrCfgA = (ConfigData.attribute)[mainAttrIdA]
  local attrCfgB = (ConfigData.attribute)[mainAttrIdB]
  local hasAttrA = mainAttrIdA == attrId or attrCfgA.merge_attribute == attrId
  local hasAttrB = mainAttrIdB == attrId or attrCfgB.merge_attribute == attrId
  if hasAttrA ~= hasAttrB then
    return hasAttrA
  end
  local isPersentA = attrCfgA.num_type == 2
  local isPersentB = attrCfgB.num_type == 2
  if isPersentA ~= isPersentB then
    return isPersentA
  end
  local attrValueA = ((a.athMainAttrCfg).attrtibute_num)[1]
  local attrValueB = ((b.athMainAttrCfg).attrtibute_num)[1]
  if curReverseOrder then
    if attrValueB >= attrValueA then
      do return attrValueA == attrValueB end
      do return attrValueA < attrValueB end
      do return attrSortFunc(a, b) end
      -- DECOMPILER ERROR: 13 unprocessed JMP targets
    end
  end
end
}
AthSortEnum.eConsumeSortFunc = {[(AthSortEnum.eKindType).GetOrder] = (AthSortEnum.eSortFunc)[(AthSortEnum.eKindType).GetOrder], [(AthSortEnum.eKindType).Quality] = (AthSortEnum.eSortFunc)[(AthSortEnum.eKindType).Quality]}
return AthSortEnum

