-- params : ...
-- function num : 0 , upvalues : _ENV
local ItemData = class("ItemData")
ItemData.ctor = function(self, dataId, count)
  -- function num : 0_0 , upvalues : _ENV
  self.dataId = dataId
  self.__count = count or 1
  local itemCfg = (ConfigData.item)[self.dataId]
  if itemCfg == nil then
    error("item cfg is null,Id:" .. tostring(self.dataId))
    return 
  end
  self.itemCfg = itemCfg
  self.type = (self.itemCfg).type
  local limitTimeItemCfg = (ConfigData.item_time_limit)[self.dataId]
  if limitTimeItemCfg ~= nil then
    self.limitTimeItemCfg = limitTimeItemCfg
  end
end

ItemData.UpdateData = function(self, data)
  -- function num : 0_1
  self:SetCount(data.count)
end

ItemData.GetCount = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsLimitTime() and self:GetLimitTime() <= PlayerDataCenter.timestamp then
    return 0
  end
  return self.__count
end

ItemData.SetCount = function(self, value)
  -- function num : 0_3
  if self.__count ~= value then
    self.__count = value
    self:OnCountChanged()
  end
end

ItemData.AddCount = function(self, num)
  -- function num : 0_4
  if num ~= 0 then
    self.__count = self.__count + num
    self:OnCountChanged()
  end
end

ItemData.OnCountChanged = function(self)
  -- function num : 0_5
end

ItemData.ContainActionType = function(self, actionId)
  -- function num : 0_6
  do return (self.itemCfg).action_type == actionId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ItemData.GetActionArg = function(self, index)
  -- function num : 0_7
  return ((self.itemCfg).arg)[index] or 0
end

ItemData.GetName = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.itemCfg).name)
end

ItemData.GetIcon = function(self)
  -- function num : 0_9
  return (self.itemCfg).icon
end

ItemData.GetDescribe = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.itemCfg).describe)
end

ItemData.GetColor = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return ItemQualityColor[self:GetQuality()]
end

ItemData.GetQuality = function(self)
  -- function num : 0_12
  return (self.itemCfg).quality
end

ItemData.GetItemPrice = function(self)
  -- function num : 0_13
  return (self.itemCfg).price
end

ItemData.IsExplorationHold = function(self)
  -- function num : 0_14
  return (self.itemCfg).explorationHold
end

ItemData.GetItemTopLimit = function(self)
  -- function num : 0_15
  return (self.itemCfg).holdlimit
end

ItemData.IsDynLimitTime = function(self)
  -- function num : 0_16
  return false
end

ItemData.IsLimitTime = function(self)
  -- function num : 0_17
  do return self.limitTimeItemCfg ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ItemData.GetLimitTime = function(self)
  -- function num : 0_18
  if self.limitTimeItemCfg ~= nil then
    return (self.limitTimeItemCfg).time
  end
  return -1
end

ItemData.GetWareHousePage = function(self)
  -- function num : 0_19
  if self.itemCfg ~= nil then
    return (self.itemCfg).warehouse_page
  end
  return 0
end

return ItemData

