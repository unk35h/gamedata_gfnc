-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonRewardData = class("CommonRewardData")
CommonRewardData.CreateCRDataUseDic = function(rewardDic)
  -- function num : 0_0 , upvalues : CommonRewardData, _ENV
  local data = (CommonRewardData.New)()
  local rewardIds = {}
  local rewardNums = {}
  for itemId,num in pairs(rewardDic) do
    if (CommonRewardData.IsNeedShowItem)(itemId) then
      (table.insert)(rewardIds, itemId)
      ;
      (table.insert)(rewardNums, num)
    end
  end
  data.rewardIds = rewardIds
  data.rewardNums = rewardNums
  data.rewardDataList = data:GenRewardDataList(data.rewardIds)
  return data
end

CommonRewardData.CreateCRDataUseList = function(rewardIds, rewardNums)
  -- function num : 0_1 , upvalues : CommonRewardData, _ENV
  local data = (CommonRewardData.New)()
  data.rewardIds = {}
  data.rewardNums = {}
  local count = 0
  for index,itemId in ipairs(rewardIds) do
    if (CommonRewardData.IsNeedShowItem)(itemId) then
      count = count + 1
      -- DECOMPILER ERROR at PC18: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (data.rewardIds)[count] = itemId
      -- DECOMPILER ERROR at PC21: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (data.rewardNums)[count] = rewardNums[index]
    end
  end
  data.rewardDataList = data:GenRewardDataList(data.rewardIds)
  return data
end

CommonRewardData.ctor = function(self)
  -- function num : 0_2
  self.rewardIds = nil
  self.rewardNums = nil
  self.heroSnapshoot = nil
  self.skipOldHero = nil
  self.title = nil
  self.rewardTips = nil
  self.exitAction = nil
  self.buyAction = nil
  self.isNotHandledGreat = nil
  self.isCRCutted = nil
  self.rewardDataList = nil
  self.newHeroIndexDic = nil
  self.heroIdList = nil
end

CommonRewardData.IsNeedShowItem = function(itemId)
  -- function num : 0_3 , upvalues : _ENV
  local removePassPoint = true
  if (PlayerDataCenter.battlepassData):GetMainBattlePass() ~= nil then
    removePassPoint = false
  end
  if CommonUtil.UInt32Max < itemId then
    do
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        error("item cfg is null, id:" .. tostring(itemId))
        return false
      end
      if itemCfg.type == eItemType.BattlePassPoint and removePassPoint then
        return false
      end
      if itemCfg.is_shielded then
        return false
      end
      return true
    end
  end
end

CommonRewardData.GenRewardDataList = function(self, rewardIds)
  -- function num : 0_4 , upvalues : _ENV
  local rewardDataList = {}
  for index = 1, #rewardIds do
    local rewardId = rewardIds[index]
    local athUid = 0
    if CommonUtil.UInt32Max < rewardId then
      athUid = rewardId
      rewardId = athUid >> 32
      rewardIds[index] = rewardId
    end
    local itemCfg = (ConfigData.item)[rewardId]
    local rewardShowData = {itemCfg = itemCfg, athData = nil}
    if itemCfg.type == eItemType.Arithmetic and athUid > 0 then
      rewardShowData.athData = ((PlayerDataCenter.allAthData).athDic)[athUid]
    end
    rewardDataList[index] = rewardShowData
  end
  return rewardDataList
end

CommonRewardData.CRHandleHero = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for index = 1, #self.rewardIds do
    local rewardId = (self.rewardIds)[index]
    if CommonUtil.UInt32Max >= rewardId then
      local itemCfg = (ConfigData.item)[rewardId]
      if itemCfg.action_type == eItemActionType.HeroCard then
        if self.heroIdList == nil then
          self.heroIdList = {}
        end
        if self.newHeroIndexDic == nil then
          self.newHeroIndexDic = {}
        end
        if itemCfg.arg == nil or (itemCfg.arg)[1] == nil then
          error("hero card item cfg error id=" .. rewardId)
        else
          ;
          (table.insert)(self.heroIdList, (itemCfg.arg)[1])
          -- DECOMPILER ERROR at PC60: Confused about usage of register: R7 in 'UnsetPending'

          if self.heroSnapshoot ~= nil and not (self.heroSnapshoot)[(itemCfg.arg)[1]] then
            (self.newHeroIndexDic)[#self.heroIdList] = true
          end
        end
      end
    end
  end
end

CommonRewardData.CRSortRewards = function(self)
  -- function num : 0_6
  return self
end

CommonRewardData.SetCRHeroSnapshoot = function(self, heroSnapshoot, skipOldHero)
  -- function num : 0_7
  self.heroSnapshoot = heroSnapshoot
  self.skipOldHero = skipOldHero
  self:CRHandleHero()
  return self
end

CommonRewardData.SetCRHeroUpFragDic = function(self, upHeroFragDic)
  -- function num : 0_8
  self.crUpHeroFragDic = upHeroFragDic
  return self
end

CommonRewardData.SetCRItemTransDic = function(self, crItemTransDic)
  -- function num : 0_9
  self.crItemTransDic = crItemTransDic
  return self
end

CommonRewardData.SetCRItemNewDic = function(self, crItemNewDic)
  -- function num : 0_10
  self.crItemNewDic = crItemNewDic
  return self
end

CommonRewardData.SetCRTitle = function(self, title)
  -- function num : 0_11
  self.title = title
  return self
end

CommonRewardData.SetCRRewardTips = function(self, rewardTips)
  -- function num : 0_12
  self.rewardTips = rewardTips
  return self
end

CommonRewardData.SetCRShowOverFunc = function(self, exitAction)
  -- function num : 0_13
  self.exitAction = exitAction
  return self
end

CommonRewardData.SetCRShowOverBuyFunc = function(self, buyAction)
  -- function num : 0_14
  self.buyAction = buyAction
  return self
end

CommonRewardData.SetCRNotHandledGreat = function(self, bool)
  -- function num : 0_15
  self.isNotHandledGreat = bool
  return self
end

CommonRewardData.SetCRChallengeTask = function(self, fromNum, toNum, totalNum)
  -- function num : 0_16
  self.challengeModeTaskFromNum = fromNum
  self.challengeModeTaskToNum = toNum
  self.challengeModeTaskTotalNum = totalNum
  return self
end

CommonRewardData.SetCRBeforeMergeItemDic = function(self, rewardDic)
  -- function num : 0_17
  self._beforeMergeItemDic = rewardDic
  return self
end

CommonRewardData.SetCRMonthCardTimeTips = function(self)
  -- function num : 0_18
  self._monthCardTimeTips = true
  return self
end

CommonRewardData.SetBpSpRewardPreview = function(self, ids, nums)
  -- function num : 0_19
  self._hasBpSpReward = true
  self._bpSpRewardIds = ids
  self._bpSpRewardNums = nums
  self._bpSpRewardList = self:GenRewardDataList(self._bpSpRewardIds)
  return self
end

CommonRewardData.GetCRBeforeMergeItemDic = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self:HasCRQZ() then
    if self._beforeMergeItemDic ~= nil then
      return self._beforeMergeItemDic
    end
    local itemDic = {}
    for k,id in ipairs(self.rewardIds) do
      itemDic[id] = (self.rewardNums)[k]
    end
    return itemDic
  end
  do
    if not self._beforeMergeItemDic then
      return table.emptytable
    end
  end
end

CommonRewardData.CutOutGreatRewards = function(self)
  -- function num : 0_21 , upvalues : _ENV, CommonRewardData
  if self.rewardIds == nil then
    return nil
  end
  local greatCRData = nil
  if not self.isNotHandledGreat then
    local isHaveGreatRewards = false
    local greatItems, greatNums = nil, nil
    for index = #self.rewardIds, 1, -1 do
      local itemId = (self.rewardIds)[index]
      if ((ConfigData.game_config).itemWithGreatFxDic)[itemId] then
        if not isHaveGreatRewards then
          isHaveGreatRewards = true
          greatItems = {}
          greatNums = {}
        end
        ;
        (table.insert)(greatItems, 1, itemId)
        ;
        (table.insert)(greatNums, 1, (self.rewardNums)[index])
        ;
        (table.remove)(self.rewardIds, index)
        ;
        (table.remove)(self.rewardNums, index)
        ;
        (table.remove)(self.rewardDataList, index)
      end
    end
    if isHaveGreatRewards then
      greatCRData = ((((CommonRewardData.CreateCRDataUseList)(greatItems, greatNums)):SetCRTitle(self.title)):SetCRRewardTips(self.rewardTips)):SetCRBeforeMergeItemDic(self._beforeMergeItemDic)
      if self._monthCardTimeTips then
        greatCRData:SetCRMonthCardTimeTips()
      end
    end
  end
  do
    self.isCRCutted = true
    return greatCRData
  end
end

CommonRewardData.IsCRDHasCouldShow = function(self)
  -- function num : 0_22
  if #self.rewardIds == 0 then
    return false
  end
  return true
end

CommonRewardData.HasCRQZ = function(self)
  -- function num : 0_23 , upvalues : _ENV
  for k,itemId in ipairs(self.rewardIds) do
    if itemId == ConstGlobalItem.PaidQZ or itemId == ConstGlobalItem.PaidItem then
      return true
    end
  end
  return false
end

CommonRewardData.HasCRMonthCardTimeTips = function(self)
  -- function num : 0_24
  return self._monthCardTimeTips or false
end

CommonRewardData.GetBpSpRewardPreview = function(self)
  -- function num : 0_25
  return self._hasBpSpReward, self._bpSpRewardIds, self._bpSpRewardNums
end

CommonRewardData.GetBpSpRewardCount = function(self)
  -- function num : 0_26
  if self._hasBpSpReward and self._bpSpRewardIds ~= nil then
    return #self._bpSpRewardIds
  end
  return 0
end

CommonRewardData.GetBpSpRewardList = function(self)
  -- function num : 0_27
  return self._bpSpRewardList
end

CommonRewardData.Delete = function(self)
  -- function num : 0_28
end

return CommonRewardData

