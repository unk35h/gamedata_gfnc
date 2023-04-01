-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonTowerDynData = class("DungeonTowerDynData")
DungeonTowerDynData.ctor = function(self)
  -- function num : 0_0
  self.__towerData = {}
  self.__newTower = {}
  self.__inited = false
end

DungeonTowerDynData.InitTowerServerData = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  if msg == nil then
    self:__RefreshAllNewTwinTower()
    return 
  end
  for k,v in pairs(msg.towers) do
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

    (self.__towerData)[v.towerId] = v
    self:_OnDungeTowerDataUpdate(v.towerId, v)
  end
  self:__RefreshAllNewTwinTower()
end

DungeonTowerDynData.UpdateTowerServerData = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV
  for k,v in pairs(msg.update) do
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R7 in 'UnsetPending'

    (self.__towerData)[v.towerId] = v
    self:_OnDungeTowerDataUpdate(v.towerId, v)
  end
  if not self:__RefreshAllNewTwinTower() then
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    for k,v in pairs(msg.update) do
      self:__RefreshNewTwinTower(v.towerId, userDataCache)
    end
  end
end

DungeonTowerDynData.__RefreshAllNewTwinTower = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.__inited then
    return false
  end
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for _,towerId in pairs((ConfigData.dungeon_tower_type).twin_towers) do
    self:__RefreshNewTwinTower(towerId, userDataCache)
  end
  local towerId = self:GetDefaultTowerId()
  local normalTowerCfg = (ConfigData.dungeon_tower_type)[towerId]
  local lastLevel = userDataCache:GetNormalTowerLevel()
  if lastLevel < normalTowerCfg.total_level then
    local normalTower = self:GetDynTowerDataById(towerId)
    local lastTowerNum = (math.min)(normalTowerCfg.total_level, normalTowerCfg.total_level - (ConfigData.game_config).towerLastUpdate + 1)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R7 in 'UnsetPending'

    if normalTower == nil or normalTower.currentCompletedId < lastTowerNum then
      (self.__newTower)[towerId] = true
    else
      userDataCache:SetNormalTowerLevel(normalTowerCfg.total_level)
    end
  end
  do
    self.__inited = true
    return true
  end
end

DungeonTowerDynData.__RefreshNewTwinTower = function(self, towerId, userDataCache)
  -- function num : 0_4
  if (self.__towerData)[towerId] ~= nil then
    userDataCache:SetTwinTowerNewReaded(towerId)
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__newTower)[towerId] = nil
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    if not userDataCache:GetTwinTowerNewReaded(towerId) then
      (self.__newTower)[towerId] = true
    end
  end
end

DungeonTowerDynData.HasNewDunTower = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return not (table.IsEmptyTable)(self.__newTower)
end

DungeonTowerDynData.HasNewDunTwinTower = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local dtowerId = self:GetDefaultTowerId()
  for towerId,_ in pairs(self.__newTower) do
    if towerId ~= dtowerId then
      return true
    end
  end
  return false
end

DungeonTowerDynData.IsNewDunTower = function(self, towerId)
  -- function num : 0_7
  return (self.__newTower)[towerId] or false
end

DungeonTowerDynData.ClearNewDunTower = function(self, towerId)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__newTower)[towerId] = nil
end

DungeonTowerDynData.IsNewNormalDunTower = function(self)
  -- function num : 0_9
  return self:IsNewDunTower(self:GetDefaultTowerId())
end

DungeonTowerDynData.GetDynTowerDataById = function(self, id)
  -- function num : 0_10
  return (self.__towerData)[id]
end

DungeonTowerDynData.GetDefaultTowerId = function(self)
  -- function num : 0_11
  return 1
end

DungeonTowerDynData.GetDefaultTowerTotalLevel = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local towerTypeCfg = (ConfigData.dungeon_tower_type)[self:GetDefaultTowerId()]
  return towerTypeCfg.total_level
end

DungeonTowerDynData.GetDefaultTowerCompleteLevel = function(self)
  -- function num : 0_13
  local towerData = self:GetDynTowerDataById(self:GetDefaultTowerId())
  if towerData == nil then
    return 0
  end
  return towerData.currentCompletedId
end

DungeonTowerDynData.GetTowerCompleteLevel = function(self, towerId)
  -- function num : 0_14
  local towerData = self:GetDynTowerDataById(towerId)
  if towerData == nil then
    return 0
  end
  return towerData.currentCompletedId
end

DungeonTowerDynData.IsTowerRacingRewardPick = function(self, towerId, rewardId)
  -- function num : 0_15
  local towerData = self:GetDynTowerDataById(towerId)
  if towerData == nil then
    return false
  end
  do return towerData.rewardMask & 1 << rewardId > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonTowerDynData.GetTowerLevelRacingFrame = function(self, towerId, floorId)
  -- function num : 0_16 , upvalues : _ENV
  local towerData = self:GetDynTowerDataById(towerId)
  if towerData == nil or towerData.racing == nil then
    return -1
  end
  if towerData.currentCompletedId < floorId then
    return -1
  end
  local floorInfo = ((towerData.racing).floorInfo)[floorId]
  if floorInfo ~= nil and floorInfo.floorId == floorId then
    return floorInfo.frame
  end
  for _,floorInfo in pairs((towerData.racing).floorInfo) do
    if floorInfo.floorId == floorId then
      return floorInfo.frame
    end
  end
  return -1
end

DungeonTowerDynData.GetTowerTotalRacingFrame = function(self, towerId)
  -- function num : 0_17 , upvalues : _ENV
  local towerTypeCfg = (ConfigData.dungeon_tower_type)[towerId]
  if towerTypeCfg == nil then
    return false, 0
  end
  local totalLevel = towerTypeCfg.total_level
  local towerData = self:GetDynTowerDataById(towerId)
  if towerData == nil then
    return false, 0
  end
  local completeLevel = towerData.currentCompletedId
  if completeLevel < totalLevel then
    return false, 0
  end
  if towerData.racing == nil then
    return false, 0
  end
  local frame = 0
  for _,floorInfo in pairs((towerData.racing).floorInfo) do
    frame = frame + floorInfo.frame
  end
  return true, frame
end

DungeonTowerDynData.GetTwinTowerProgressInfo = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local twinTowerList = (ConfigData.dungeon_tower_type).twin_towers
  local completeCount = 0
  local towerCount = #twinTowerList
  for _,towerId in pairs(twinTowerList) do
    local towerTypeCfg = (ConfigData.dungeon_tower_type)[towerId]
    local completeLevel = self:GetTowerCompleteLevel(towerId)
    if towerTypeCfg.total_level <= completeLevel then
      completeCount = completeCount + 1
    end
  end
  return completeCount, towerCount
end

DungeonTowerDynData.GetTwinTowerFirstNoComplete = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local twinTowerList = (ConfigData.dungeon_tower_type).twin_towers
  local completeCount = 0
  local towerCount = #twinTowerList
  for index,towerId in pairs(twinTowerList) do
    local towerTypeCfg = (ConfigData.dungeon_tower_type)[towerId]
    local completeLevel = self:GetTowerCompleteLevel(towerId)
    if completeLevel < towerTypeCfg.total_level then
      return index, towerId
    end
  end
  return 0, 0
end

DungeonTowerDynData._OnDungeTowerDataUpdate = function(self, towerId, towerData)
  -- function num : 0_20 , upvalues : _ENV
  local towerTypeCfg = (ConfigData.dungeon_tower_type)[towerId]
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  if towerTypeCfg == nil then
    (self.__towerData)[towerId] = nil
    return 
  end
  if towerTypeCfg.tower_cat ~= 1 then
    return 
  end
  local totalLevel = towerTypeCfg.total_level
  local completeLevel = towerData.currentCompletedId
  if completeLevel < totalLevel then
    return 
  end
  if towerTypeCfg.racing_reward_mask <= towerData.rewardMask then
    local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
    local rewardNode = twinTowerNode:GetChild(towerId)
    if rewardNode ~= nil then
      rewardNode:SetRedDotCount(0)
    end
    return 
  end
  do
    local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
    local rewardNode = twinTowerNode:AddChildWithPath(towerId, RedDotDynPath.DunTwinTowerReward)
    local _, totalFrame = self:GetTowerTotalRacingFrame(towerId)
    local count = 0
    local racingCfg = (ConfigData.dungeon_tower_racing)[towerId]
    for rewardId,racingCfg in pairs(racingCfg) do
      local isPicked = towerData.rewardMask & 1 << rewardId > 0
      if not isPicked then
        local frame = (BattleUtil.SecondToFrame)(racingCfg.time_limit)
        if totalFrame <= frame then
          count = count + 1
        end
      end
    end
    rewardNode:SetRedDotCount(count)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

return DungeonTowerDynData

