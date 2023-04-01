-- params : ...
-- function num : 0 , upvalues : _ENV
local DormHouseData = class("DormHouseData")
local DormRoomData = require("Game.Dorm.Data.DormRoomData")
local DormUtil = require("Game.Dorm.DormUtil")
local DormEnum = require("Game.Dorm.DormEnum")
DormHouseData.ctor = function(self)
  -- function num : 0_0
end

DormHouseData.CreateNewLockHouse = function(id)
  -- function num : 0_1 , upvalues : DormHouseData
  local housedata = {id = id}
  local dorm = (DormHouseData.New)()
  dorm:InitHouseData(housedata)
  dorm:SetDmHouseLock(true)
  return dorm
end

DormHouseData.InitHouseData = function(self, housedata)
  -- function num : 0_2 , upvalues : _ENV, DormRoomData
  self.id = housedata.id
  self.roomList = {}
  self.roomDic = {}
  self.HasBindHeroCount = 0
  self.houseCfg = (ConfigData.dorm_house)[self.id]
  if self.houseCfg == nil then
    error("dorm house cfg is null,id:" .. tostring(self.id))
    return 
  end
  local r = self:GetRoomHexRange()
  if housedata.data ~= nil then
    for spos,room in pairs(housedata.data) do
      local roomData = (DormRoomData.New)()
      roomData:InitRoomData(spos, room, self.id, r)
      ;
      (table.insert)(self.roomList, roomData)
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self.roomDic)[spos] = roomData
    end
  end
  do
    ;
    (table.sort)(self.roomList, function(x1, x2)
    -- function num : 0_2_0
    do return x1.spos < x2.spos end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
end

DormHouseData.SetDmHouseLock = function(self, isLock)
  -- function num : 0_3
  self._isLock = isLock
end

DormHouseData.IsDmHouseLock = function(self)
  -- function num : 0_4
  return self._isLock or false
end

DormHouseData.IsDefaultUnlockDmHouse = function(self)
  -- function num : 0_5 , upvalues : DormEnum
  do return (self.houseCfg).unlock_logic == (DormEnum.eDmHouseUnlockLogic).BuildingLevel and (self.houseCfg).unlock_level == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormHouseData.GetRoomDataByRoomIndex = function(self, RoomIndex)
  -- function num : 0_6 , upvalues : _ENV, DormUtil
  local r = self:GetRoomHexRange()
  for k,v in pairs(self.roomDic) do
    local x, y = (DormUtil.RoomCoordToXY)(k)
    local Index = (DormUtil.GetRoomIndexByRoomposToxy)(x, y, r)
    if Index == RoomIndex then
      return v
    end
  end
end

DormHouseData.RemoveHouseRoom = function(self, spos)
  -- function num : 0_7 , upvalues : _ENV
  local oldRoom = (self.roomDic)[spos]
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if oldRoom ~= nil then
    (self.roomDic)[spos] = nil
    ;
    (table.removebyvalue)(self.roomList, oldRoom)
  end
end

DormHouseData.AddHouseRoom = function(self, roomData)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.roomDic)[roomData.spos] = roomData
  ;
  (table.insert)(self.roomList, roomData)
end

DormHouseData.GetName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.houseCfg).name)
end

DormHouseData.GetRoomCount = function(self)
  -- function num : 0_10
  return #self.roomList
end

DormHouseData.GetDmHouseRoomList = function(self)
  -- function num : 0_11
  return self.roomList
end

DormHouseData.GetRoomHexRange = function(self)
  -- function num : 0_12
  return (self.houseCfg).type
end

DormHouseData.GetHouseDefaultRoom = function(self)
  -- function num : 0_13
  return (self.houseCfg).default_room
end

DormHouseData.GetComfortLimit = function(self)
  -- function num : 0_14
  return (self.houseCfg).comfort_limit
end

DormHouseData.GetDormEffectResPath = function(self)
  -- function num : 0_15
  return (self.houseCfg).dorm_effect
end

DormHouseData.IsBigRoomHouse = function(self)
  -- function num : 0_16
  do return (self.houseCfg).house_roomtype == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormHouseData.IsOnlyOneRoom = function(self)
  -- function num : 0_17
  do return #self.roomList <= 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormHouseData.GetDmHouseIconIdx = function(self)
  -- function num : 0_18
  return (self.houseCfg).icon_index
end

DormHouseData.GetDmHouseBuyCost = function(self)
  -- function num : 0_19
  return (self.houseCfg).unlock_item_id, (self.houseCfg).unlock_item_num
end

DormHouseData.GetComfort = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local comfort = 0
  for k,v in pairs(self.roomDic) do
    comfort = comfort + v:GetComfort()
  end
  comfort = (math.clamp)(comfort, 0, self:GetComfortLimit())
  return comfort
end

DormHouseData.GetHouseBindCount = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local count = 0
  for k,v in pairs(self.roomDic) do
    count = count + v:GetRoomBindCount()
  end
  return count
end

DormHouseData.GetHouseBindFntCount = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local count = 0
  for k,v in pairs(self.roomDic) do
    count = count + v:GetRoomBindCount()
  end
  return count
end

DormHouseData.IsHeroBindOnElseRoom = function(self, HeroId, CurRoomData)
  -- function num : 0_23 , upvalues : _ENV
  for k,v in pairs(self.roomDic) do
    if v.spos ~= CurRoomData.spos and v:IsHeroBindOnRoom(HeroId) then
      return true
    end
  end
  return false
end

DormHouseData.GetHeroOnElseRoomData = function(self, HeroId, CurRoomData)
  -- function num : 0_24 , upvalues : _ENV
  for k,v in pairs(self.roomDic) do
    if v.spos ~= CurRoomData.spos and v:IsHeroBindOnRoom(HeroId) then
      return v
    end
  end
end

DormHouseData.GetHouseCanBindFntCount = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local count = 0
  for k,v in pairs(self.roomDic) do
    count = count + v:GetRoomCanBindFntCount()
  end
  return count
end

DormHouseData.GetDmHouseBindNum = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local num = 0
  for k,roomData in ipairs(self.roomList) do
    num = num + roomData:GetRoomBindCount()
  end
  return num
end

DormHouseData.SwapHousePos = function(self, spos1, spos2)
  -- function num : 0_27
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  (self.roomDic)[spos1] = (self.roomDic)[spos2]
end

DormHouseData.GetDmHouseBindFntHeroDic = function(self, bindHeroIdFntDic, fntHeroIdDic)
  -- function num : 0_28 , upvalues : _ENV
  for k,v in pairs(self.roomDic) do
    for k2,fntData in ipairs(v:GetRoomCanBindList()) do
      local heroId = fntData:GetFntParam()
      if heroId > 0 then
        bindHeroIdFntDic[heroId] = fntData
      end
      fntHeroIdDic[fntData] = heroId
    end
  end
end

DormHouseData.GetHouseBindFntDataList = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local bindList = {}
  local count = 0
  for k,v in pairs(self.roomDic) do
    for k2,ftnData in pairs(v:GetRoomCanBindList()) do
      count = count + 1
      ;
      (table.insert)(bindList, ftnData)
    end
  end
  ;
  (table.sort)(bindList, function(a, b)
    -- function num : 0_29_0
    local aBind = a:GetFntParam() ~= 0
    local bBind = b:GetFntParam() ~= 0
    if a.id >= b.id then
      do return aBind ~= bBind end
      do return aBind end
      -- DECOMPILER ERROR: 5 unprocessed JMP targets
    end
  end
)
  local list = {}
  for k,v in ipairs(bindList) do
    (table.insert)(list, v)
  end
  return list
end

DormHouseData.IsDmHouseUnlockableReaded = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if not self:IsDmHouseLock() then
    return true
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  return saveUserData:GetUnlockableDormHouseReaded(self.id)
end

return DormHouseData

