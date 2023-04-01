-- params : ...
-- function num : 0 , upvalues : _ENV
local LotteryPoolGroupData = class("LotteryPoolGroupData")
LotteryPoolGroupData.ctor = function(self, ltrPoolData, ltrGroupId)
  -- function num : 0_0 , upvalues : _ENV
  self.ltrPoolData = ltrPoolData
  self.ltrGroupCfg = (ConfigData.lottery_group)[ltrGroupId]
end

LotteryPoolGroupData.HasLtrMoreGroup = function(self)
  -- function num : 0_1
  do return self.ltrGroupCfg ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolGroupData.GetLtrMoreGroupId = function(self)
  -- function num : 0_2
  if self.ltrGroupCfg == nil then
    return 
  end
  return (self.ltrGroupCfg).lottery_group
end

LotteryPoolGroupData.ContainLtrGroupPool = function(self, ltrId)
  -- function num : 0_3 , upvalues : _ENV
  if (self.ltrPoolData).poolId == ltrId then
    return true
  end
  if ltrId == nil then
    return 
  end
  do return self:HasLtrMoreGroup() and ((((ConfigData.lottery_group).ltrGroupIdMap)[ltrId] == (self.ltrGroupCfg).lottery_group and (PlayerDataCenter.allLtrData):GetIsSpecificPoolOpen(ltrId))) end
  do return false end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

LotteryPoolGroupData.GetLtrInGroupDataList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if not self:HasLtrMoreGroup() then
    return table.emptytable
  end
  if self._ltrDataList ~= nil then
    return self._ltrDataList
  end
  local dataList = {}
  for k,ltrId in ipairs((self.ltrGroupCfg).list) do
    if (PlayerDataCenter.allLtrData):GetIsSpecificPoolOpen(ltrId) then
      local ltrData = ((PlayerDataCenter.allLtrData).ltrDataDic)[ltrId]
      ;
      (table.insert)(dataList, ltrData)
    end
  end
  self._ltrDataList = dataList
  return dataList
end

LotteryPoolGroupData.TryGetLastLtrPoolData = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if not self:HasLtrMoreGroup() then
    return 
  end
  local groupId = self:GetLtrMoreGroupId()
  local lastLtrId = 0
  lastLtrId = (PlayerDataCenter.allLtrData):GetIsSelectByGroupId(groupId)
  if lastLtrId == 0 then
    lastLtrId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLtrGroupSelectedLtrId(groupId)
  end
  if self:ContainLtrGroupPool(lastLtrId) then
    return ((PlayerDataCenter.allLtrData).ltrDataDic)[lastLtrId]
  else
    return nil
  end
  return 
end

LotteryPoolGroupData.HasLtrGroupHeroConvertFrag = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not self:HasLtrMoreGroup() then
    return (self.ltrPoolData):IsLtrHeroConvertFrag()
  end
  local dataList = self:GetLtrInGroupDataList()
  for k,ltrData in ipairs(dataList) do
    if ltrData:IsLtrHeroConvertFrag() then
      return true
    end
  end
  return false
end

return LotteryPoolGroupData

