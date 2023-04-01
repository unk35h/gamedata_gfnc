-- params : ...
-- function num : 0 , upvalues : _ENV
local DormRoomData = class("DormRoomData")
local DormUtil = require("Game.Dorm.DormUtil")
local DormEnum = require("Game.Dorm.DormEnum")
local DormFurnitureData = require("Game.Dorm.Data.DormFurnitureData")
DormRoomData.ctor = function(self)
  -- function num : 0_0
end

DormRoomData.CreateNewRoom = function(spos, roomId)
  -- function num : 0_1 , upvalues : DormRoomData
  local roomdata = {id = roomId}
  local room = (DormRoomData.New)()
  room:InitRoomData(spos, roomdata)
  return room
end

DormRoomData.InitRoomData = function(self, spos, roomdata, houseid, houseHexRange)
  -- function num : 0_2 , upvalues : DormUtil
  local x, y = (DormUtil.RoomCoordToXY)(spos)
  self.belongtohouseid = houseid
  self._houseHexRange = houseHexRange
  self.x = x
  self.y = y
  self.spos = spos
  self:__InitDormRoomData(roomdata)
end

DormRoomData.InitPrefabRoom = function(self, uid, roomdata)
  -- function num : 0_3
  self.uid = uid
  self:__InitDormRoomData(roomdata)
end

DormRoomData.__InitDormRoomData = function(self, roomdata)
  -- function num : 0_4 , upvalues : _ENV
  self.id = roomdata.id
  self.roomCfg = (ConfigData.dorm_room)[self.id]
  if self.roomCfg == nil then
    error("dorm room cfg is null,id:" .. tostring(self.id))
  end
  self.__roomName = roomdata.name
  self.isPrefab = self.uid ~= nil
  self:UpdateRoomFntData(roomdata.data, true)
  self:_InitDmRoomDoorData(roomdata.door)
  self:SetDmRoomFloor(roomdata.floorId)
  self:SetDmRoomWall(roomdata.wallId)
  self:RecordOrnginalDmRoomData(roomdata)
  self.__enableUnbind = roomdata.unbind
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormRoomData.UpdateRoomFntData = function(self, data, createFntData)
  -- function num : 0_5 , upvalues : _ENV, DormFurnitureData, DormEnum
  self.data = data
  if createFntData then
    self.canBindfntDataList = {}
    self._wallPaperData = {
[1] = {}
, 
[2] = {}
, 
[3] = {}
, 
[4] = {}
}
    self.fntDataList = {}
    self.fntDataDic = {}
    if self.data ~= nil then
      local wallPaperDataTemp = {}
      do
        local wallPaperIdxDicTemp = {}
        for k,v in ipairs(self.data) do
          local fntData = (DormFurnitureData.New)()
          fntData:InitFntData(v.id, self, v)
          -- DECOMPILER ERROR at PC36: Confused about usage of register: R11 in 'UnsetPending'

          ;
          (self.fntDataList)[k] = fntData
          -- DECOMPILER ERROR at PC38: Confused about usage of register: R11 in 'UnsetPending'

          ;
          (self.fntDataDic)[fntData] = true
          if #self.canBindfntDataList <= self:GetDormRoomMaxHero() and fntData:CanBindRole() then
            (table.insert)(self.canBindfntDataList, fntData)
          end
          if fntData:GetFntType() == (DormEnum.eDormFntType).Wallpaper then
            local wallId = fntData:GetFntParam()
            if not wallPaperDataTemp[wallId] then
              do
                wallPaperDataTemp[wallId] = {}
                ;
                (table.insert)(wallPaperDataTemp[wallId], fntData)
                wallPaperIdxDicTemp[fntData] = k
                -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC73: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
        for wallId,papaerList in pairs(wallPaperDataTemp) do
          (table.sort)(papaerList, function(fntA, fntB)
    -- function num : 0_5_0 , upvalues : wallPaperIdxDicTemp
    local layerIdxA = fntA:GetFntDataLayer()
    local layerIdxB = fntB:GetFntDataLayer()
    local idxA = wallPaperIdxDicTemp[fntA]
    local idxB = wallPaperIdxDicTemp[fntB]
    if layerIdxA >= layerIdxB then
      do return layerIdxA == layerIdxB end
      do return idxA < idxB end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
          for layerIdx,fntData in ipairs(papaerList) do
            -- DECOMPILER ERROR at PC90: Confused about usage of register: R15 in 'UnsetPending'

            ((self._wallPaperData)[wallId])[layerIdx] = fntData
            fntData:SetFntDataLayer(layerIdx)
          end
        end
      end
    end
  else
    do
      for k,fntData in ipairs(self.fntDataList) do
        fntData:RecordOriginalFntData()
      end
      do
        self.interpoint = {}
        for k,v in ipairs(self.fntDataList) do
          for _,pointData in pairs(v.interpoint) do
            pointData:UnBindInterPoint()
            ;
            (table.insert)(self.interpoint, R15_PC124)
          end
        end
      end
    end
  end
end

DormRoomData.GetDormRoomMaxHero = function(self)
  -- function num : 0_6
  return (self.roomCfg).max_hero
end

DormRoomData.GetRoomGridHeightCount = function(self)
  -- function num : 0_7
  return (self.roomCfg).grid_height
end

DormRoomData.GetRoomGridLengthCount = function(self)
  -- function num : 0_8
  return (self.roomCfg).grid_length
end

DormRoomData.GetRoomModelSize = function(self)
  -- function num : 0_9
  return (self.roomCfg).model_size
end

DormRoomData.GetDmRoomType = function(self)
  -- function num : 0_10
  return (self.roomCfg).room_type
end

DormRoomData.IsBigRoomType = function(self)
  -- function num : 0_11
  do return (self.roomCfg).room_type == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormRoomData.GetDmRoomEditCamDistace = function(self)
  -- function num : 0_12 , upvalues : _ENV
  return (Vector2.New)(((self.roomCfg).edit_cam_distance)[1], ((self.roomCfg).edit_cam_distance)[2])
end

DormRoomData.GetEnableUnbind = function(self)
  -- function num : 0_13
  return self.__enableUnbind
end

DormRoomData.SetEnableUnbind = function(self, unbind)
  -- function num : 0_14
  self.__enableUnbind = unbind
end

DormRoomData._InitDmRoomDoorData = function(self, doorData)
  -- function num : 0_15 , upvalues : _ENV, DormFurnitureData
  if doorData == nil then
    error("Door door data from server is nil, roomId = " .. tostring(self.id))
    return 
  end
  local fntData = (DormFurnitureData.New)()
  fntData:InitFntData(doorData.id, self, doorData, true)
  self.dmRoomDoorData = fntData
end

DormRoomData.RecordOrnginalDmRoomData = function(self, roomdata)
  -- function num : 0_16
  self.oldRoomdata = roomdata
end

DormRoomData.ClearDormRoom = function(self)
  -- function num : 0_17 , upvalues : _ENV
  for _,pointData in pairs(self.interpoint) do
    pointData:UnBindInterPoint()
  end
end

DormRoomData.__UpdateRoomInterPoint = function(self)
  -- function num : 0_18
end

DormRoomData.ChangePos = function(self, spos)
  -- function num : 0_19 , upvalues : DormUtil
  if self.isPrefab then
    self.isPrefab = false
    self.uid = nil
  end
  local x, y = (DormUtil.RoomCoordToXY)(spos)
  self.x = x
  self.y = y
  self.spos = spos
end

DormRoomData.GetName = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if not (string.IsNullOrEmpty)(self.__roomName) then
    return self.__roomName
  end
  return (LanguageUtil.GetLocaleText)((self.roomCfg).name)
end

DormRoomData.SetRoomName = function(self, name)
  -- function num : 0_21
  self.__roomName = name
end

DormRoomData.GetComfort = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local comfort = 0
  for k,v in pairs(self.fntDataList) do
    comfort = comfort + v:GetFntComfort()
  end
  comfort = comfort + (self.dmRoomDoorData):GetFntComfort()
  do
    if self.floorId > 0 then
      local fntCfg = (ConfigData.dorm_furniture)[self.floorId]
      if fntCfg == nil then
        error("Can\'t find dorm_furniture cfg, id = " .. tostring(self.floorId))
        return 
      end
      comfort = comfort + fntCfg.comfort
    end
    do
      if self.wallId > 0 then
        local fntCfg = (ConfigData.dorm_furniture)[self.wallId]
        if fntCfg == nil then
          error("Can\'t find dorm_furniture cfg, id = " .. tostring(self.wallId))
          return 
        end
        comfort = comfort + fntCfg.comfort
      end
      return comfort
    end
  end
end

DormRoomData.BackupDmRoomDntList = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local backupFntList = {}
  for k,v in ipairs(self.fntDataList) do
    backupFntList[k] = v
  end
  self._backupFntList = backupFntList
  local backupCanBindFntList = {}
  for k,v in ipairs(self.canBindfntDataList) do
    backupCanBindFntList[k] = v
  end
  self._backupCanBindFntList = backupCanBindFntList
end

DormRoomData.ClearDmRoomDntListBackup = function(self)
  -- function num : 0_24
  self._backupFntList = nil
  self._backupCanBindFntList = nil
end

DormRoomData.RestoreDmRoomDntList = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if self._backupFntList ~= nil then
    for k,v in ipairs(self._backupFntList) do
      -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

      (self.fntDataList)[k] = v
    end
  end
  do
    if self._backupCanBindFntList ~= nil then
      for k,v in ipairs(self._backupCanBindFntList) do
        -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

        (self.canBindfntDataList)[k] = v
      end
    end
  end
end

DormRoomData.AddFntData = function(self, fntData)
  -- function num : 0_26 , upvalues : DormEnum, _ENV
  if fntData == nil then
    return 
  end
  local fntType = fntData:GetFntType()
  if fntData == (DormEnum.eDormFntType).Door then
    return 
  end
  if (self.fntDataDic)[fntData] ~= nil then
    return 
  end
  ;
  (table.insert)(self.fntDataList, fntData)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.fntDataDic)[fntData] = true
  if #self.canBindfntDataList <= self:GetDormRoomMaxHero() and fntData:CanBindRole() then
    (table.insert)(self.canBindfntDataList, fntData)
  end
end

DormRoomData.RemoveFntData = function(self, fntData)
  -- function num : 0_27 , upvalues : DormEnum, _ENV
  local fntType = fntData:GetFntType()
  if fntData == (DormEnum.eDormFntType).Door then
    return 
  end
  ;
  (table.removebyvalue)(self.fntDataList, fntData)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.fntDataDic)[fntData] = nil
  if fntData:CanBindRole() then
    (table.removebyvalue)(self.canBindfntDataList, fntData)
  end
end

DormRoomData.GetFntDatas = function(self, withCheckPaper)
  -- function num : 0_28 , upvalues : _ENV
  local dataList = {}
  for k,fntData in ipairs(self.fntDataList) do
    local data = fntData:GetDmFntServerData()
    dataList[k] = data
  end
  if withCheckPaper then
    self:_CheckWallpaperData()
  end
  return dataList
end

DormRoomData._CheckWallpaperData = function(self)
  -- function num : 0_29 , upvalues : _ENV
  for wallId,paperList in pairs(self._wallPaperData) do
    for layerIdx,fntData in ipairs(paperList) do
      local fntLayer = fntData:GetFntDataLayer()
      local fntWallIdx = fntData:GetFntParam()
      if wallId ~= fntWallIdx or layerIdx ~= fntLayer then
        error((string.format)("CheckWallpaperData error, fntId:%s, wallId:%s, fntWallIdx:%s, layerIdx:%s, fntLayer:%s", fntData.id, wallId, fntWallIdx, layerIdx, fntLayer))
      end
    end
  end
end

DormRoomData.GetRoomBindCount = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local count = 0
  for k,fntData in ipairs(self.canBindfntDataList) do
    local param = fntData:GetFntParam()
    if param ~= 0 then
      count = count + 1
    end
  end
  return count
end

DormRoomData.GetRoomBindList = function(self)
  -- function num : 0_31 , upvalues : _ENV
  local list = {}
  for k,fntData in pairs(self.canBindfntDataList) do
    local param = fntData:GetFntParam()
    if param ~= 0 then
      (table.insert)(list, fntData)
    end
  end
  return list
end

DormRoomData.GetRoomCanBindFntCount = function(self)
  -- function num : 0_32
  return #self.canBindfntDataList
end

DormRoomData.GetRoomCanBindList = function(self)
  -- function num : 0_33
  return self.canBindfntDataList
end

DormRoomData.GetFntDataByBindHeroId = function(self, HeroID)
  -- function num : 0_34 , upvalues : _ENV
  for k,fntData in ipairs(self.canBindfntDataList) do
    local param = fntData:GetFntParam()
    if param == HeroID then
      return fntData
    end
  end
  return nil
end

DormRoomData.GetFntDataIndex = function(self, fntData)
  -- function num : 0_35 , upvalues : _ENV
  for index,v in ipairs(self.fntDataList) do
    if fntData == v then
      return index - 1
    end
  end
  error("Can\'t get FntData index")
end

DormRoomData.UnbindAllRoomFntData = function(self)
  -- function num : 0_36 , upvalues : _ENV
  for k,fntData in ipairs(self.canBindfntDataList) do
    local param = fntData:GetFntParam()
    if param > 0 then
      fntData:SetFntParam(0, true)
    end
  end
end

DormRoomData.IsHeroBindOnRoom = function(self, HeroID)
  -- function num : 0_37 , upvalues : _ENV
  for k,fntData in pairs(self.canBindfntDataList) do
    local param = fntData:GetFntParam()
    if param == HeroID then
      return true
    end
  end
  return false
end

DormRoomData.SetDmRoomWall = function(self, wallId)
  -- function num : 0_38
  self.wallId = wallId
end

DormRoomData.SetDmRoomFloor = function(self, floorId)
  -- function num : 0_39
  self.floorId = floorId
end

DormRoomData.SaveDmRoomData = function(self)
  -- function num : 0_40
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  (self.oldRoomdata).data = self.data
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.oldRoomdata).wallId = self.wallId
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.oldRoomdata).floorId = self.floorId
  ;
  (self.dmRoomDoorData):RecordOriginalFntData()
end

DormRoomData.GetDmRoomOldFloor = function(self)
  -- function num : 0_41
  return (self.oldRoomdata).floorId
end

DormRoomData.GetDmRoomOldWall = function(self)
  -- function num : 0_42
  return (self.oldRoomdata).wallId
end

DormRoomData.GetDmRoomOldDoor = function(self)
  -- function num : 0_43
  return (self.dmRoomDoorData):GetFntOldId()
end

DormRoomData.GetDmRoomFntCategoryNum = function(self, categoryId)
  -- function num : 0_44 , upvalues : _ENV
  local num = 0
  for k,fntData in ipairs(self.fntDataList) do
    if fntData:GetFntCategory() == categoryId then
      num = num + 1
    end
  end
  return num
end

DormRoomData.GetDmRoomIndex = function(self)
  -- function num : 0_45 , upvalues : DormUtil
  return (DormUtil.GetRoomIndexByRoomposToxy)(self.x, self.y, self._houseHexRange)
end

DormRoomData.AddDmWallpaper = function(self, fntData, wallIdx)
  -- function num : 0_46 , upvalues : _ENV
  if not wallIdx then
    local wallIdx = fntData:GetFntParam()
  end
  local wallList = (self._wallPaperData)[wallIdx]
  ;
  (table.insert)(wallList, fntData)
  fntData:SetFntDataLayer(#wallList)
end

DormRoomData.InsertDmWallpaper = function(self, fntData)
  -- function num : 0_47 , upvalues : _ENV
  local layerIndex = fntData:GetFntDataLayer()
  local wallIdx = fntData:GetFntParam()
  local wallList = (self._wallPaperData)[wallIdx]
  layerIndex = (math.min)(#wallList + 1, layerIndex)
  fntData:SetFntDataLayer(layerIndex)
  ;
  (table.insert)(wallList, layerIndex, fntData)
  self:_ChangeOtherFntLayer(wallList, layerIndex + 1)
end

DormRoomData._ChangeOtherFntLayer = function(self, wallList, layerIndex)
  -- function num : 0_48 , upvalues : _ENV
  local changeLayerFntDic = nil
  for i = layerIndex, #wallList do
    local fntDt = wallList[i]
    fntDt:SetFntDataLayer(i)
    if not changeLayerFntDic then
      changeLayerFntDic = {}
    end
    changeLayerFntDic[fntDt] = true
  end
  if changeLayerFntDic ~= nil then
    MsgCenter:Broadcast(eMsgEventId.DmWallpaperLayerIdxChanged, changeLayerFntDic)
  end
end

DormRoomData.RemoveDmWallpaper = function(self, fntData)
  -- function num : 0_49 , upvalues : _ENV
  local wallIdx = fntData:GetFntParam()
  local wallList = (self._wallPaperData)[wallIdx]
  local layerIndex = fntData:GetFntDataLayer()
  ;
  (table.remove)(wallList, layerIndex)
  self:_ChangeOtherFntLayer(wallList, layerIndex)
end

DormRoomData.DmRoomResetWallpaper = function(self)
  -- function num : 0_50 , upvalues : _ENV, DormEnum
  self:DmRoomClearWallpaper()
  for k,fntData in ipairs(self.fntDataList) do
    if fntData:GetFntType() == (DormEnum.eDormFntType).Wallpaper then
      local wallId = fntData:GetFntParam()
      local layerIdx = fntData:GetFntDataLayer()
      -- DECOMPILER ERROR at PC18: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self._wallPaperData)[wallId])[layerIdx] = fntData
    end
  end
end

DormRoomData.DmRoomClearWallpaper = function(self)
  -- function num : 0_51 , upvalues : _ENV
  for wallId,wallList in pairs(self._wallPaperData) do
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R6 in 'UnsetPending'

    (self._wallPaperData)[wallId] = {}
  end
end

return DormRoomData

