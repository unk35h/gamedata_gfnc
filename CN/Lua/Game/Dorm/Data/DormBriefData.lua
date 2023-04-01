-- params : ...
-- function num : 0 , upvalues : _ENV
local DormBriefData = class("DormBriefData")
local DormEnum = require("Game.Dorm.DormEnum")
DormBriefData.ctor = function(self)
  -- function num : 0_0
  self.__dormHasReward = false
  self.dormComfort = 0
  self.__comfortLevel = 0
end

local RoomBinaryLock = function(unlockBinary, roomId)
  -- function num : 0_1
  local sign = 1 << roomId
  do return unlockBinary & sign == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormBriefData.CreateDormBriefByServer = function(dormBrief)
  -- function num : 0_2 , upvalues : DormBriefData
  local dormBriefData = (DormBriefData.New)()
  dormBriefData:UpdateDormBriefByServer(dormBrief)
  dormBriefData:_InitUnlock(dormBrief)
  dormBriefData:CheckDmHouseUnlock()
  return dormBriefData
end

DormBriefData._InitUnlock = function(self, dormBrief)
  -- function num : 0_3 , upvalues : _ENV, RoomBinaryLock
  for houseId,houseUnlockCfg in pairs(ConfigData.dorm_room_unlock) do
    local unlockBinary = (dormBrief.unlockedRoom)[houseId]
    local OnUnlockRoomFunc = BindCallback(self, self._OnUnlockRoom, houseId)
    for roomId,unlockCfg in pairs(houseUnlockCfg) do
      if unlockBinary == nil or RoomBinaryLock(unlockBinary, roomId) then
        UnlockCenter:AddUnlockElemEvent(OnUnlockRoomFunc, unlockCfg.unlock_logic, unlockCfg.unlock_para1)
      end
    end
  end
end

DormBriefData._OnUnlockRoom = function(self, houseId, logicId, para1)
  -- function num : 0_4 , upvalues : _ENV
  local dormNetwork = NetworkManager:GetNetwork(NetworkTypeID.Dorm)
  dormNetwork:CS_DORM_BriefDetailWhenUnlock()
end

DormBriefData.SetDmHouseInUnlock = function(self, houseId, isInUnlock)
  -- function num : 0_5
  if not self._inUnlockHouseDic then
    self._inUnlockHouseDic = {}
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._inUnlockHouseDic)[houseId] = isInUnlock
  end
end

DormBriefData.CheckDmHouseUnlock = function(self)
  -- function num : 0_6 , upvalues : _ENV, DormEnum
  for k,houseId in ipairs((ConfigData.dorm_house).id_sort_list) do
    if (self.unlockedRoom)[houseId] == nil and (not self._inUnlockHouseDic or not (self._inUnlockHouseDic)[houseId]) then
      local houseCfg = (ConfigData.dorm_house)[houseId]
      if houseCfg.unlock_logic == (DormEnum.eDmHouseUnlockLogic).CostItem and (houseCfg.unlock_house_before == 0 or (self.unlockedRoom)[houseCfg.unlock_house_before]) then
        local ownNum = PlayerDataCenter:GetItemCount(houseCfg.unlock_item_id)
        if houseCfg.unlock_item_num <= ownNum then
          local dormNetwork = NetworkManager:GetNetwork(NetworkTypeID.Dorm)
          dormNetwork:CS_DORM_DormPurchase(houseId)
          return 
        end
      end
    end
  end
end

DormBriefData.CheckDmItemChange = function(self, itemDic)
  -- function num : 0_7 , upvalues : _ENV
  local hasChange = false
  for itemId,v in pairs((ConfigData.dorm_house).dmHouseUnlockItemIdDic) do
    if itemDic[itemId] ~= nil then
      hasChange = true
      break
    end
  end
  do
    if not hasChange then
      return 
    end
    self:CheckDmHouseUnlock()
  end
end

DormBriefData.UpdateDormBriefByServer = function(self, dormBrief)
  -- function num : 0_8 , upvalues : _ENV
  self.rewardsRecord = dormBrief.RewardsRecord
  self.unlockedRoom = dormBrief.unlockedRoom
  self.furnitureTotal = dormBrief.furnitureTotal
  self._hasThemeFnt = false
  for itemId,num in pairs(self.furnitureTotal) do
    local fntCfg = (ConfigData.dorm_furniture)[itemId]
    if fntCfg and fntCfg.is_theme then
      self._hasThemeFnt = true
      break
    end
  end
  do
    if not self:UpdateHistoryMaxComfort(dormBrief.comfort) then
      self:__CalcDormLevelAndReward()
    end
    self:RefreshNewDormHouseReddot()
  end
end

DormBriefData.UpdateDormBriefFurnitureTotal = function(self, updateDic)
  -- function num : 0_9 , upvalues : _ENV
  if updateDic then
    if not self.furnitureTotal then
      self.furnitureTotal = {}
    end
    for k,v in pairs(updateDic) do
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R7 in 'UnsetPending'

      if not (self.furnitureTotal)[k] then
        (self.furnitureTotal)[k] = v
      else
        -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.furnitureTotal)[k] = (self.furnitureTotal)[k] + v
        -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

        if (self.furnitureTotal)[k] == 0 then
          (self.furnitureTotal)[k] = nil
        end
      end
      if not self._hasThemeFnt then
        local fntCfg = (ConfigData.dorm_furniture)[k]
        if fntCfg and fntCfg.is_theme then
          self._hasThemeFnt = true
        end
      end
    end
  end
end

DormBriefData.RefreshNewDormHouseReddot = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local unlockDorm = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm)
  if not unlockDorm then
    return 
  end
  local ok, newHouseNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormNewHouse)
  if not ok then
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local count = 0
  for k,houseId in ipairs((ConfigData.dorm_house).id_sort_list) do
    if houseId ~= 1 and (self.unlockedRoom)[houseId] and (self.unlockedRoom)[houseId] > 0 then
      local readedNew = saveUserData:GetNewDormHouseReaded(houseId)
      if not readedNew then
        count = count + 1
      end
    end
  end
  newHouseNode:SetRedDotCount(count)
end

DormBriefData.GetDormHouseIsNew = function(self, houseId)
  -- function num : 0_11 , upvalues : _ENV
  if houseId == 1 then
    return false
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  do
    if (self.unlockedRoom)[houseId] and (self.unlockedRoom)[houseId] > 0 then
      local readedNew = saveUserData:GetNewDormHouseReaded(houseId)
      return not readedNew
    end
    return false
  end
end

DormBriefData.SetDormHouseNewReaded = function(self, houseId)
  -- function num : 0_12 , upvalues : _ENV
  if houseId == 1 then
    return 
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local changed = saveUserData:SetNewDormHouseReaded(houseId, true)
  if changed then
    local ok, newHouseNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormNewHouse)
    newHouseNode:OffsetRedDotCount(-1)
  end
end

DormBriefData.SetDmHouseUnlockableReaded = function(self, houseId)
  -- function num : 0_13 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetUnlockableDormHouseReaded(houseId, true)
end

DormBriefData.IsDormComfortPicked = function(self, level)
  -- function num : 0_14
  local sign = 1 << level - 1
  do return self.rewardsRecord & sign > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormBriefData.RecordComfortPicked = function(self, level)
  -- function num : 0_15
  local sign = 1 << level - 1
  self.rewardsRecord = self.rewardsRecord | sign
  self:__CalcDormLevelAndReward()
end

DormBriefData.HistoryMaxComfort = function(self)
  -- function num : 0_16
  return self.dormComfort
end

DormBriefData.UpdateHistoryMaxComfort = function(self, comfort)
  -- function num : 0_17 , upvalues : _ENV
  if comfort <= self.dormComfort then
    return false
  end
  self.dormComfort = comfort
  self:__CalcDormLevelAndReward()
  MsgCenter:Broadcast(eMsgEventId.DormMaxComfortChanged, self.dormComfort, self.__comfortLevel)
  return true
end

DormBriefData.IsDormHasReward = function(self)
  -- function num : 0_18
  return self.__dormHasReward
end

DormBriefData.GetDormComfortLevel = function(self)
  -- function num : 0_19 , upvalues : _ENV
  return self.__comfortLevel, (ConfigData.dorm_comfort).max_level
end

DormBriefData.GetDormComfortLevelCfg = function(self)
  -- function num : 0_20 , upvalues : _ENV
  return (ConfigData.dorm_comfort)[self.__comfortLevel]
end

DormBriefData.__CalcDormLevelAndReward = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local dormHasReward = false
  local templevel = 1
  for _,level in ipairs((ConfigData.dorm_comfort).level_sort) do
    local comfortCfg = (ConfigData.dorm_comfort)[level]
    if comfortCfg == nil then
      error("dorm comfort cfg is null,id:" .. tostring(level))
      return nil
    end
    if comfortCfg.comfort <= self.dormComfort then
      templevel = level
      if not dormHasReward and #comfortCfg.rewardIds > 0 and not self:IsDormComfortPicked(level) then
        dormHasReward = true
      end
    else
      break
    end
  end
  do
    if self.__comfortLevel ~= templevel then
      if self.__comfortLevel > 0 then
        local levelCfg = (ConfigData.dorm_comfort)[self.__comfortLevel]
        for k,logic in ipairs(levelCfg.logic) do
          local para1 = (levelCfg.para1)[k]
          local para2 = (levelCfg.para2)[k]
          local para3 = (levelCfg.para3)[k]
          ;
          (PlayerDataCenter.playerBonus):UninstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm, 0, logic, para1, para2, para3)
        end
      end
      do
        self.__comfortLevel = templevel
        local levelCfg = (ConfigData.dorm_comfort)[self.__comfortLevel]
        for k,logic in ipairs(levelCfg.logic) do
          local para1 = (levelCfg.para1)[k]
          local para2 = (levelCfg.para2)[k]
          local para3 = (levelCfg.para3)[k]
          ;
          (PlayerDataCenter.playerBonus):InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm, 0, logic, para1, para2, para3)
        end
        do
          self:__UpdateDormHasReward(dormHasReward)
        end
      end
    end
  end
end

DormBriefData.__UpdateDormHasReward = function(self, hasReward)
  -- function num : 0_22 , upvalues : _ENV
  if self.__dormHasReward == hasReward then
    return 
  end
  self.__dormHasReward = hasReward
  local ok, comfortNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormComfort)
  if hasReward then
    comfortNode:SetRedDotCount(1)
  else
    comfortNode:SetRedDotCount(0)
  end
end

DormBriefData.GetFurnitureItemCountInDorm = function(self, itemId)
  -- function num : 0_23
  local count = (self.furnitureTotal)[itemId]
  if count then
    return count
  end
  return 0
end

DormBriefData.ExistDormFntItem = function(self, fntItemId)
  -- function num : 0_24 , upvalues : _ENV
  if self:GetFurnitureItemCountInDorm(fntItemId) > 0 then
    return true
  end
  do return (PlayerDataCenter.itemDic)[fntItemId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormBriefData.IsHasAnyDmtThemeFntInstalled = function(self)
  -- function num : 0_25
  return self._hasThemeFnt
end

return DormBriefData

