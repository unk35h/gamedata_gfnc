-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.PlayerData.Item.ItemData")
local LimitTimeItemData = class("ItemData", base)
LimitTimeItemData.ctor = function(self, dataId, stackInfos)
  -- function num : 0_0 , upvalues : _ENV
  self.dataId = dataId
  self:UpdateStackInfos(stackInfos)
  local itemCfg = (ConfigData.item)[self.dataId]
  if itemCfg == nil then
    error("item cfg is null,Id:" .. tostring(self.dataId))
    return 
  end
  self.itemCfg = itemCfg
  self.type = (self.itemCfg).type
  local limitTimeItemCfg = (ConfigData.item_time_limit)[self.dataId]
  if limitTimeItemCfg == nil then
    error("limitTimeItemCfg cfg is null,Id:" .. tostring(self.dataId))
    return 
  end
  self.limitTimeItemCfg = limitTimeItemCfg
end

LimitTimeItemData.UpdateStackInfos = function(self, stackInfos)
  -- function num : 0_1 , upvalues : _ENV
  self.__stackInfos = stackInfos
  local curTime = PlayerDataCenter.timestamp
  local tempCount = 0
  self.__stackCount = 0
  for i = #stackInfos, 1, -1 do
    if curTime <= (stackInfos[i]).time then
      tempCount = tempCount + (stackInfos[i]).num
      self.__stackCount = self.__stackCount + 1
    else
      ;
      (table.remove)(self.__stackInfos, i)
    end
  end
  ;
  (table.sort)(self.__stackInfos, function(a, b)
    -- function num : 0_1_0
    if a.time >= b.time then
      do return a.time == b.time end
      do return false end
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
)
  if self.__count ~= tempCount then
    self.__count = tempCount
    self:OnCountChanged()
  end
end

LimitTimeItemData.UpdateData = function(self)
  -- function num : 0_2
end

LimitTimeItemData.GetCount = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local count = 0
  local curTime = PlayerDataCenter.timestamp
  for k,v in pairs(self.__stackInfos) do
    if curTime < v.time then
      count = count + v.num
    end
  end
  return count
end

LimitTimeItemData.SetCount = function(self, value)
  -- function num : 0_4
end

LimitTimeItemData.AddCount = function(self, num)
  -- function num : 0_5
end

LimitTimeItemData.GetStackInfoByIndex = function(self, index)
  -- function num : 0_6
  if self.__stackInfos ~= nil then
    return (self.__stackInfos)[index]
  end
  return nil
end

LimitTimeItemData.GetLimitTime = function(self)
  -- function num : 0_7
  return -1
end

LimitTimeItemData.GetSingStackCount = function(self, index)
  -- function num : 0_8
  local stackInfo = self:GetStackInfoByIndex(index)
  if stackInfo ~= nil then
    return stackInfo.count
  end
  return -1
end

LimitTimeItemData.GetLimitTime = function(self, index)
  -- function num : 0_9
  local stackInfo = self:GetStackInfoByIndex(index)
  if stackInfo ~= nil then
    return stackInfo.time
  end
  return -1
end

LimitTimeItemData.IsDynLimitTime = function(self)
  -- function num : 0_10
  return true
end

LimitTimeItemData.GetStackCount = function(self)
  -- function num : 0_11
  return self.__stackCount
end

return LimitTimeItemData

