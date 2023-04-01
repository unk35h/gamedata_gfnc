-- params : ...
-- function num : 0 , upvalues : _ENV
local AllDormData = class("AllDormData")
local DormHouseData = require("Game.Dorm.Data.DormHouseData")
local DormRoomData = require("Game.Dorm.Data.DormRoomData")
AllDormData.ctor = function(self)
  -- function num : 0_0
  self.allBindFntDataDirty = true
end

AllDormData.InitDormData = function(self, dormdata)
  -- function num : 0_1 , upvalues : _ENV, DormRoomData, DormHouseData
  self.comfort = dormdata.comfort
  self.prefabDic = {}
  for uid,room in pairs(dormdata.prefab) do
    local roomData = (DormRoomData.New)()
    roomData:InitPrefabRoom(uid, room)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.prefabDic)[uid] = roomData
  end
  self.houseDic = {}
  self.houseIdList = {}
  for k,houseId in ipairs((ConfigData.dorm_house).id_sort_list) do
    local houseData = nil
    local houseMsg = (dormdata.house)[houseId]
    local houseCfg = (ConfigData.dorm_house)[houseId]
    if houseMsg then
      houseData = (DormHouseData.New)()
      houseData:InitHouseData(houseMsg)
    else
      if houseCfg.unlock_house_before == 0 or (dormdata.house)[houseCfg.unlock_house_before] then
        houseData = (DormHouseData.CreateNewLockHouse)(houseId)
      end
    end
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R10 in 'UnsetPending'

    if houseData ~= nil then
      (self.houseDic)[houseId] = houseData
      ;
      (table.insert)(self.houseIdList, houseId)
    end
  end
  ;
  (table.sort)(self.houseIdList)
  self.__dormHeroTalk = dormdata.heroTalk
end

AllDormData.AddNewHouse = function(self, houseId)
  -- function num : 0_2 , upvalues : _ENV, DormHouseData
  local ownHouse = (self.houseDic)[houseId]
  ownHouse:SetDmHouseLock(false)
  local unlockHouseId = ((ConfigData.dorm_house).dmHouseUnlockPreHouseIdDic)[houseId]
  if unlockHouseId == nil then
    return 
  end
  local houseData = (DormHouseData.CreateNewLockHouse)(unlockHouseId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.houseDic)[unlockHouseId] = houseData
  ;
  (table.insert)(self.houseIdList, unlockHouseId)
  ;
  (table.sort)(self.houseIdList)
end

AllDormData.RemovePrefabRoom = function(self, uid)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.prefabDic)[uid] = nil
end

AllDormData.UpdatePrefabRoom = function(self, uid, room)
  -- function num : 0_4 , upvalues : DormRoomData
  self:RemovePrefabRoom(uid)
  local roomData = (DormRoomData.New)()
  roomData:InitPrefabRoom(uid, room)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.prefabDic)[uid] = roomData
end

AllDormData.GetFirstHouse = function(self)
  -- function num : 0_5
  if #self.houseIdList == 0 then
    return nil
  end
  return (self.houseDic)[(self.houseIdList)[1]]
end

AllDormData.IsHouseUnlock = function(self, id)
  -- function num : 0_6
  do return (self.houseDic)[id] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllDormData.GetTotalComfort = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.houseDic == nil then
    return 0
  end
  local comfort = 0
  for _,houseData in pairs(self.houseDic) do
    comfort = comfort + houseData:GetComfort()
  end
  return comfort
end

AllDormData.GetHistoryComfortCfg = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local curLevel = 1
  for _,level in ipairs((ConfigData.dorm_comfort).level_sort) do
    local comfortCfg = (ConfigData.dorm_comfort)[level]
    if comfortCfg == nil then
      error("dorm comfort cfg is null,id:" .. tostring(level))
      return nil
    end
    if comfortCfg.comfort <= self.comfort then
      curLevel = level
    else
      break
    end
  end
  do
    return (ConfigData.dorm_comfort)[curLevel]
  end
end

AllDormData.GetAllBindFntData = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if not self.allBindFntDataDirty then
    return self.allBindFntData
  end
  self.allBindFntDataDirty = false
  local allBindFntData = {
allList = {}
, 
boundDic = {}
}
  for houseId,houseData in pairs(self.houseDic) do
    for spos,roomData in pairs(houseData.roomDic) do
      for k,fntData in ipairs(roomData.canBindfntDataList) do
        (table.insert)(allBindFntData.allList, fntData)
        local heroId = fntData:GetFntParam()
        -- DECOMPILER ERROR at PC33: Confused about usage of register: R18 in 'UnsetPending'

        if heroId > 0 then
          (allBindFntData.boundDic)[heroId] = fntData
        end
      end
    end
  end
  self.allBindFntData = allBindFntData
  return self.allBindFntData
end

AllDormData.SetAllBindFntDataDirty = function(self)
  -- function num : 0_10
  self.allBindFntDataDirty = true
end

AllDormData.IsDormHeroTalked = function(self, heroId, talkIndex)
  -- function num : 0_11
  local talkKey = (self.__dormHeroTalk)[heroId]
  if talkKey == nil then
    return false
  end
  local sign = 1 << talkIndex - 1
  do return talkKey & sign > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

AllDormData.AddDormHeroTalked = function(self, heroId, talkIndex)
  -- function num : 0_12
  local talkKey = (self.__dormHeroTalk)[heroId]
  if talkKey == nil then
    talkKey = 0
  end
  local sign = 1 << talkIndex - 1
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.__dormHeroTalk)[heroId] = talkKey | sign
end

AllDormData.GetDormHeroTalkKey = function(self, heroId)
  -- function num : 0_13
  local talkKey = (self.__dormHeroTalk)[heroId]
  if talkKey == nil then
    return 0
  end
  return talkKey
end

AllDormData.GetDmBindHeroIdFntAllDic = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local bindHeroIdFntDic = {}
  local fntHeroIdDic = {}
  for houseId,houseData in pairs(self.houseDic) do
    houseData:GetDmHouseBindFntHeroDic(bindHeroIdFntDic, fntHeroIdDic)
  end
  return bindHeroIdFntDic, fntHeroIdDic
end

AllDormData.IsAnyDmHouseUnlockableUnread = function(self)
  -- function num : 0_15 , upvalues : _ENV
  for k,houseData in pairs(self.houseDic) do
    if not houseData:IsDmHouseUnlockableReaded() then
      return true
    end
  end
  return false
end

return AllDormData

