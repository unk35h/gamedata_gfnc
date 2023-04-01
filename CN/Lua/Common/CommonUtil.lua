-- params : ...
-- function num : 0 , upvalues : _ENV
CommonUtil = {}
-- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.SplitStrToNumber = function(str, pattern)
  -- function num : 0_0 , upvalues : _ENV
  local list = (string.split)(str, pattern)
  for k,v in ipairs(list) do
    list[k] = tonumber(v)
  end
  return list
end

-- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.SplitStrToString = function(str, pattern)
  -- function num : 0_1 , upvalues : _ENV
  local list = (string.split)(str, pattern)
  for k,v in ipairs(list) do
    list[k] = v
  end
  return list
end

-- DECOMPILER ERROR at PC10: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.SplitStrToStrAndNumber = function(str, p1, p2)
  -- function num : 0_2 , upvalues : _ENV
  local list = (string.split)(str, p1)
  local list1 = {}
  local list2 = {}
  for k,v in ipairs(list) do
    local tmpList = (string.split)(v, p2)
    if #tmpList >= 2 then
      (table.insert)(list1, tmpList[1])
      ;
      (table.insert)(list2, tonumber(tmpList[2]))
    end
  end
  return list1, list2
end

-- DECOMPILER ERROR at PC13: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.SplitStrToDoubleNumber = function(str, p1, p2)
  -- function num : 0_3 , upvalues : _ENV
  local list = (string.split)(str, p1)
  local list1 = {}
  local list2 = {}
  for k,v in ipairs(list) do
    local tmpList = (string.split)(v, p2)
    if #tmpList >= 2 then
      (table.insert)(list1, tonumber(tmpList[1]))
      ;
      (table.insert)(list2, tonumber(tmpList[2]))
    end
  end
  return list1, list2
end

-- DECOMPILER ERROR at PC16: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.SplitStrToDic = function(str, p1, p2, KeyAction, valueAction)
  -- function num : 0_4 , upvalues : _ENV
  local list = (string.split)(str, p1)
  local dic = {}
  for k,v in ipairs(list) do
    local tmpList = (string.split)(v, p2)
    if #tmpList >= 2 then
      if not KeyAction or not KeyAction(tmpList[1]) then
        local key = tmpList[1]
      end
      if not valueAction or not valueAction(tmpList[2]) then
        local value = tmpList[2]
      end
      dic[key] = value
    end
  end
  return dic
end

-- DECOMPILER ERROR at PC19: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.NewFullList = function(len, content)
  -- function num : 0_5
  local list = {}
  for i = 1, len do
    list[i] = content
  end
  return list
end

-- DECOMPILER ERROR at PC22: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.GetDetailDescribeSetting = function(eGameSetDescType)
  -- function num : 0_6 , upvalues : _ENV
  local setCtrl = ControllerManager:GetController(ControllerTypeId.Setting, true)
  return setCtrl:GetIsShowDetailDescribe(eGameSetDescType)
end

-- DECOMPILER ERROR at PC25: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.GetIsNeedPlayUltrSkillAnimi = function(skillId, setPlayed)
  -- function num : 0_7 , upvalues : _ENV
  local setCtrl = ControllerManager:GetController(ControllerTypeId.Setting, true)
  local index = setCtrl:GetGSMultSettingIndex(eGameSetDescType.ultrSkillAnimi)
  if index == 0 then
    return false
  else
    if index == 1 then
      if setCtrl:IsTodayPlayedUltSkillAnimi(skillId) then
        return false
      end
      if setPlayed then
        setCtrl:SetIsTodayPlayedUltSkillAnimi(skillId, true)
      end
      return true
    else
      if setPlayed then
        setCtrl:SetIsTodayPlayedUltSkillAnimi(skillId, true)
      end
      return true
    end
  end
end

-- DECOMPILER ERROR at PC28: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.DefaultItemsSortList = function(item_ids, item_nums, sortDic)
  -- function num : 0_8 , upvalues : _ENV
  local itemList = {}
  local itemNumDic = {}
  for idx,id in pairs(item_ids) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg == nil then
      error("item cfg is null,id:" .. tostring(id))
    else
      itemNumDic[id] = item_nums[idx]
      ;
      (table.insert)(itemList, itemCfg)
    end
  end
  local itemList = (CommonUtil.DefaultItemsSort)(itemList, sortDic)
  ;
  (table.removeall)(item_ids)
  ;
  (table.removeall)(item_nums)
  for _,itemCfg in pairs(itemList) do
    local id = itemCfg.id
    ;
    (table.insert)(item_ids, id)
    ;
    (table.insert)(item_nums, itemNumDic[id])
  end
  return item_ids, item_nums
end

-- DECOMPILER ERROR at PC31: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.DefaultItemsSort = function(itemCfgs, sortDic)
  -- function num : 0_9 , upvalues : _ENV
  if #itemCfgs == 1 then
    return itemCfgs
  end
  local count = 0
  if sortDic ~= nil then
    count = (table.count)(sortDic)
  end
  ;
  (table.sort)(itemCfgs, function(a, b)
    -- function num : 0_9_0 , upvalues : count, sortDic
    local aSort = 1
    local bSort = 1
    if count ~= 0 then
      if not sortDic[a.order_sort] then
        aSort = count + 1
      end
      if not sortDic[b.order_sort] then
        bSort = count + 1
      end
    end
    if aSort >= bSort then
      do return aSort == bSort end
      aSort = a.order_sort
      bSort = b.order_sort
      if aSort >= bSort then
        do return aSort == bSort end
        if b.quality >= a.quality then
          do return a.quality == b.quality end
          do return a.id < b.id end
          -- DECOMPILER ERROR: 7 unprocessed JMP targets
        end
      end
    end
  end
)
  return itemCfgs
end

-- DECOMPILER ERROR at PC33: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.UInt32Max = 4294967295
-- DECOMPILER ERROR at PC35: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.Int32Max = 2147483647
-- DECOMPILER ERROR at PC37: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.UInt16Max = 65535
-- DECOMPILER ERROR at PC39: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.Int16Max = 32767
-- DECOMPILER ERROR at PC43: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.Int64Max = math.maxinteger
-- DECOMPILER ERROR at PC47: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.Int64Min = math.mininteger
-- DECOMPILER ERROR at PC49: Confused about usage of register: R0 in 'UnsetPending'

CommonUtil.DaySeconds = 86400

