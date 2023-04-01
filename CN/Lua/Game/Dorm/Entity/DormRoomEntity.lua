-- params : ...
-- function num : 0 , upvalues : _ENV
local DormRoomEntity = class("DormRoomEntity")
local DormUtil = require("Game.Dorm.DormUtil")
local DormEnum = require("Game.Dorm.DormEnum")
local DormFurnitureEntity = require("Game.Dorm.Entity.DormFurnitureEntity")
local CS_EventTrigger = CS.EventTriggerListener
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_ResLoader = CS.ResLoader
DormRoomEntity.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__onRoomClicked = BindCallback(self, self.OnRoomClicked)
  self._AddFntEntityGoFunc = BindCallback(self, self.AddFntEntityGo)
end

DormRoomEntity.InitHouseData = function(self, x, y, spos, roomData)
  -- function num : 0_1
  self.x = x
  self.y = y
  self.spos = spos
  self.roomData = roomData
end

DormRoomEntity.SetDmRoomEntityData = function(self, roomData)
  -- function num : 0_2
  self.roomData = roomData
end

DormRoomEntity.IsEmptyRoom = function(self)
  -- function num : 0_3
  do return self.roomData == nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormRoomEntity.IsBigRoomType = function(self)
  -- function num : 0_4
  return (self.roomData):IsBigRoomType()
end

DormRoomEntity.ChangeDormRoomPos = function(self, spos)
  -- function num : 0_5 , upvalues : DormUtil, _ENV
  self.spos = spos
  local x, y = (DormUtil.RoomCoordToXY)(spos)
  self.x = x
  self.y = y
  ;
  (self.roomData):ChangePos(spos)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  if not IsNull(self.gameObject) then
    (self.transform).position = self:RoomHexToUnityCoord(self.x, self.y)
  end
  self:__RefreshDormDoorPos()
end

DormRoomEntity.RoomHexToUnityCoord = function(self, x, y)
  -- function num : 0_6 , upvalues : _ENV
  local z = -x - y
  local gridHeight = (self._roomCfg).grid_height
  local modelSize = (self._roomCfg).model_size
  local houseHeight = gridHeight * (ConfigData.game_config).HouseGridWidth + (ConfigData.game_config).HouseFloorHeight
  return (Vector3.New)(y * modelSize, z * houseHeight, x * modelSize)
end

DormRoomEntity.GetDormRoomCenterPos = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local pos = (self.transform).position
  local gridHeight = (self._roomCfg).grid_height
  pos.y = pos.y + (gridHeight * (ConfigData.game_config).HouseGridWidth - (ConfigData.game_config).HouseFloorHeight) / 2
  local resultPos = UIManager:World2UIPosition(pos)
  return (Vector3.New)(resultPos.x, resultPos.y, 0)
end

DormRoomEntity.LoadRoomEntity = function(self, dormHolder, comResDic, clickAction, showUnlockFx)
  -- function num : 0_8 , upvalues : _ENV, CS_EventTrigger
  self._comResDic = comResDic
  self._roomCfg = comResDic.defaultDmRoomCfg
  if not self:IsEmptyRoom() or not comResDic.lockRoomPrefab then
    local prefab = comResDic.roomPrefab
  end
  local go = prefab:Instantiate(dormHolder)
  go.name = (string.format)("%d_%d", self.x, self.y)
  self.gameObject = go
  self.transform = go.transform
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.transform).position = self:RoomHexToUnityCoord(self.x, self.y)
  local eventTrigger = (CS_EventTrigger.Get)(self.gameObject)
  eventTrigger:onClick("+", self.__onRoomClicked)
  self.clickAction = clickAction
  if showUnlockFx and not IsNull(comResDic.roomUnlockFxPrefab) and not self:IsEmptyRoom() then
    local unlockFxGo = (comResDic.roomUnlockFxPrefab):Instantiate(self.transform)
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (unlockFxGo.transform).position = Vector3.zero
    unlockFxGo:SetActive(false)
    self._unlockFxGo = unlockFxGo
    local lockGo = (comResDic.lockRoomPrefab):Instantiate(self.transform)
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (lockGo.transform).position = Vector3.zero
    self._lockGo = lockGo
  end
  do
    if self:IsEmptyRoom() then
      return 
    end
    self:InitRoomHolder()
    self:ChangeDmRoomFloor((self.roomData).floorId)
    self:ChangeDmRoomWall((self.roomData).wallId)
    self:InitAllFntEntity()
    self:__RefreshDormDoorPos()
  end
end

DormRoomEntity.TryPlayDmRoomUnlockFx = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if not IsNull(self._lockGo) then
    (self._lockGo):SetActive(false)
  end
  if not IsNull(self._unlockFxGo) then
    (self._unlockFxGo):SetActive(true)
  end
end

DormRoomEntity._InstantiateFloor = function(self, prefab)
  -- function num : 0_10 , upvalues : _ENV
  DestroyUnityObject(self.__floorObject)
  local go = prefab:Instantiate(self.floorObjHolder)
  go.name = prefab.name
  self.__floorObject = go
end

DormRoomEntity._InstantiateWall = function(self, prefab)
  -- function num : 0_11 , upvalues : _ENV
  if not self.__wallObjectList then
    self.__wallObjectList = {}
    local wallsGo = prefab:Instantiate()
    for k,holder in ipairs(self.wallHolder) do
      DestroyUnityObject((self.__wallObjectList)[k])
      local wall = (wallsGo.transform):Find(tostring(k))
      if IsNull(wall) then
        error((string.format)("Cant find dorm wall, prefab name : %s, wall index : %s", prefab.name, k))
      else
        wall:SetParent(holder.parent, false)
        wall.localEulerAngles = Vector3.zero
        wall:SetAsFirstSibling()
        -- DECOMPILER ERROR at PC46: Confused about usage of register: R9 in 'UnsetPending'

        ;
        (wall.gameObject).name = prefab.name
        -- DECOMPILER ERROR at PC49: Confused about usage of register: R9 in 'UnsetPending'

        ;
        (self.__wallObjectList)[k] = wall.gameObject
      end
    end
    DestroyUnityObject(wallsGo)
  end
end

DormRoomEntity._InitWallFntEntityDic = function(self)
  -- function num : 0_12
  self.wallFntEntityDic = {}
  for i = 1, 4 do
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

    (self.wallFntEntityDic)[i] = {}
  end
end

DormRoomEntity.InitAllFntEntity = function(self)
  -- function num : 0_13 , upvalues : _ENV
  self.fntObjDic = {}
  self.fntEntityDic = {}
  self:_InitWallFntEntityDic()
  if self.roomData ~= nil then
    for k,fntData in ipairs((self.roomData).fntDataList) do
      self:CreateFntEntity(fntData, false)
    end
  end
  do
    self:CreateFntEntity((self.roomData).dmRoomDoorData, false)
  end
end

DormRoomEntity.ResetDmRoomFntEntity = function(self, fntEntity, isResetOneFnt)
  -- function num : 0_14 , upvalues : DormEnum
  local fntData = fntEntity.fntData
  local fntType = (fntData:GetFntType())
  local wallpaperChangeWall = nil
  if isResetOneFnt then
    self:UpdateFntMap(fntEntity, false)
    if fntType == (DormEnum.eDormFntType).Wallpaper then
      wallpaperChangeWall = fntData:IsFntDataParam2Change()
    else
      wallpaperChangeWall = false
    end
    if wallpaperChangeWall then
      (self.roomData):RemoveDmWallpaper(fntData)
    end
  end
  fntData:ResetFntData()
  local holder = self:GetFntHolder(fntType, fntData:GetFntParam())
  fntEntity:ResetFntEntityByData(holder)
  if isResetOneFnt then
    self:UpdateFntMap(fntEntity, true)
    if wallpaperChangeWall then
      (self.roomData):InsertDmWallpaper(fntData)
    end
  end
end

DormRoomEntity.ReinitAllFntEntity = function(self)
  -- function num : 0_15 , upvalues : _ENV
  for fntData,fntEntity in pairs(self.originFntEntityDic) do
    if not fntData:IsDmFntDoor() then
      self:ResetDmRoomFntEntity(fntEntity)
      if (self.fntEntityDic)[fntData] == nil then
        fntEntity:OnRecoveryOriginFnt()
        self:AddFntEntityGo(fntEntity)
        self:AddFntEntityData(fntEntity)
      end
    end
  end
  ;
  (self.roomData):RestoreDmRoomDntList()
end

DormRoomEntity.InitRoomHolder = function(self)
  -- function num : 0_16 , upvalues : _ENV, CS_GameObject
  local offset = (ConfigData.game_config).HouseGridWidth / 2
  local gridLength = (self._roomCfg).grid_length
  local gridHeight = (self._roomCfg).grid_height
  local groundX = gridLength * (ConfigData.game_config).HouseGridWidth / 2 - offset
  local wallY = gridHeight * (ConfigData.game_config).HouseGridWidth - offset
  local floorPos = (Vector3.New)(-groundX, 0, -groundX)
  local wallSizeX = (self._roomCfg).model_size
  local wallSizeY = gridHeight * (ConfigData.game_config).HouseGridWidth
  local wallThickness = (ConfigData.game_config).HouseFloorHeight
  self.editCollider = (self.transform):FindComponent(eUnityComponentID.Collider)
  self.characterHolder = (self.transform):FindComponent("Character", eUnityComponentID.Transform)
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.characterHolder).localPosition = floorPos
  self.fntHolder = (self.transform):FindComponent("Furniture", eUnityComponentID.Transform)
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.fntHolder).localPosition = floorPos
  self.floorHolder = (self.transform):FindComponent("FloorHolder", eUnityComponentID.Transform)
  -- DECOMPILER ERROR at PC66: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.floorHolder).localPosition = floorPos
  local floorCollider = (self.transform):FindComponent("Floor", eUnityComponentID.Collider)
  floorCollider.center = (Vector3.New)(0, -wallThickness / 2, 0)
  local floorWidth = wallSizeX
  if self:IsBigRoomType() then
    floorWidth = floorWidth + 10
  end
  floorCollider.size = (Vector3.New)(floorWidth, wallThickness, floorWidth)
  self.floorObjHolder = floorCollider.transform
  self.wallHolder = {}
  self.wallObjDic = {}
  self.wallColliderDic = {}
  local wallCenterV3 = (Vector3.New)(0, wallSizeY / 2, -(wallSizeX / 2 - wallThickness / 2))
  local wallSizeV3 = (Vector3.New)(wallSizeX, wallSizeY, wallThickness)
  for i = 1, 4 do
    local wall = (self.transform):FindComponent("Wall/" .. tostring(i), eUnityComponentID.Transform)
    local wallLocalPos = ((Quaternion.Euler)(0, (i - 1) * 90, 0)):MulVec3((Vector3.New)(groundX, wallY, -groundX - offset))
    local holder = (CS_GameObject("WallHolder" .. tostring(i))).transform
    -- DECOMPILER ERROR at PC156: Confused about usage of register: R21 in 'UnsetPending'

    ;
    (self.wallHolder)[i] = holder
    holder:SetParent(wall, false)
    holder.position = (self.transform).position + wallLocalPos
    -- DECOMPILER ERROR at PC167: Confused about usage of register: R21 in 'UnsetPending'

    ;
    (self.wallObjDic)[i] = wall.gameObject
    local collider = wall:FindComponent(eUnityComponentID.Collider)
    if IsNull(collider) then
      error("wall collider is nil, wallId" .. tostring(i))
    else
      -- DECOMPILER ERROR at PC186: Confused about usage of register: R22 in 'UnsetPending'

      ;
      (self.wallColliderDic)[i] = collider
      collider.center = wallCenterV3
      collider.size = wallSizeV3
    end
  end
end

DormRoomEntity.SetEditColliderEnable = function(self, enable)
  -- function num : 0_17
  if self:IsEmptyRoom() then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.editCollider).enabled = enable
end

DormRoomEntity.InitFntMapData = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local groundX = (self._roomCfg).grid_length
  local wallY = (self._roomCfg).grid_height
  self.mapData = {}
  local wallMapList = {}
  local wallpaperMapList = {}
  for i = 1, 4 do
    wallMapList[i] = {}
    wallpaperMapList[i] = {}
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.mapData).wallMapList = wallMapList
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.mapData).wallpaperMapList = wallpaperMapList
  local fntMap = {}
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.mapData).fntMap = fntMap
  local groundMap = {}
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.mapData).groundMap = groundMap
  for k,fntEntity in pairs(self.fntObjDic) do
    self:UpdateFntMap(fntEntity, true)
  end
end

DormRoomEntity.ClearFntMapData = function(self)
  -- function num : 0_19
  self.mapData = nil
end

DormRoomEntity.__GetFntMap = function(self, fntType, param)
  -- function num : 0_20 , upvalues : DormEnum, _ENV
  local map = nil
  if fntType == (DormEnum.eDormFntType).FloorDecoration then
    map = (self.mapData).groundMap
  else
    if fntType == (DormEnum.eDormFntType).WallDecoration or fntType == (DormEnum.eDormFntType).Door then
      map = ((self.mapData).wallMapList)[param]
    else
      if fntType == (DormEnum.eDormFntType).Wallpaper then
        map = ((self.mapData).wallpaperMapList)[param]
      else
        if fntType == (DormEnum.eDormFntType).Furniture then
          map = (self.mapData).fntMap
        end
      end
    end
  end
  if map == nil then
    error("fnt map is nil, fntType = " .. tostring(fntType) .. ", param = " .. tostring(param))
    return 
  end
  return map
end

DormRoomEntity.UpdateFntMap = function(self, fntEntity, isAdd, areaList, wallIndex, doorFloorAreaList)
  -- function num : 0_21 , upvalues : DormEnum, _ENV
  local fntType = (fntEntity.fntData):GetFntType()
  if not wallIndex then
    local param = (fntEntity.fntData):GetFntParam()
  end
  if areaList == nil then
    areaList = fntEntity:GetFntAreaList()
  end
  local overlapEntityDic = {}
  do
    if fntType ~= (DormEnum.eDormFntType).Wallpaper then
      local map = self:__GetFntMap(fntType, param)
      self:_UpdMapAreaList(areaList, isAdd, map, fntType, fntEntity, overlapEntityDic)
    end
    do
      if (fntEntity.fntData):IsInFntWallpaperMap() then
        local map = self:__GetFntMap((DormEnum.eDormFntType).Wallpaper, param)
        self:_UpdMapAreaList(areaList, isAdd, map, fntType, fntEntity, overlapEntityDic, true)
      end
      if fntType == (DormEnum.eDormFntType).Door then
        if doorFloorAreaList == nil then
          doorFloorAreaList = fntEntity:GetFntDoorAreaList()
        end
        local floorMap = self:__GetFntMap((DormEnum.eDormFntType).Furniture)
        self:_UpdMapAreaList(doorFloorAreaList, isAdd, floorMap, (DormEnum.eDormFntType).Furniture, fntEntity, overlapEntityDic)
      end
      do
        for entity,notOnlyOne in pairs(overlapEntityDic) do
          if entity == fntEntity then
            entity:SetFntOverlap(notOnlyOne)
          else
            local overlap = self:_CheckFntOverlap(entity)
            entity:SetFntOverlap(overlap)
          end
        end
        local wallFntEntityDic = (self.wallFntEntityDic)[param]
        if wallFntEntityDic ~= nil then
          if isAdd then
            wallFntEntityDic[fntEntity.fntData] = fntEntity
          else
            wallFntEntityDic[fntEntity.fntData] = nil
          end
        end
      end
    end
  end
end

DormRoomEntity._UpdMapAreaList = function(self, areaList, isAdd, map, fntType, fntEntity, overlapEntityDic, isWallpaperMap)
  -- function num : 0_22 , upvalues : _ENV
  for k,pos in pairs(areaList) do
    if isAdd and self:FntPosOutMap(pos.x, pos.y, fntType) then
      overlapEntityDic[fntEntity] = true
    else
      if map[pos.x] == nil then
        map[pos.x] = {}
      end
      -- DECOMPILER ERROR at PC32: Confused about usage of register: R13 in 'UnsetPending'

      if (map[pos.x])[pos.y] == nil then
        (map[pos.x])[pos.y] = {}
      end
      local grid = (map[pos.x])[pos.y]
      if isAdd then
        grid[fntEntity] = true
      else
        grid[fntEntity] = nil
      end
      local overlap = self:_CheckAreaGridOverlap(grid, isWallpaperMap)
      for entity,_ in pairs(grid) do
        overlapEntityDic[entity] = overlapEntityDic[entity] or overlap
      end
    end
  end
end

DormRoomEntity.FntPosOutMap = function(self, x, y, fntType)
  -- function num : 0_23 , upvalues : DormEnum
  local sizeX = (self._roomCfg).grid_length
  local sizeY = (self._roomCfg).grid_height
  if x >= 0 and sizeX > x and y >= 0 and sizeY > y then
    do return not (DormEnum.IsFntWallType)(fntType) end
    do return x < 0 or sizeX <= x or y < 0 or sizeX <= y end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

DormRoomEntity._CheckFntOverlap = function(self, fntEntity)
  -- function num : 0_24 , upvalues : DormEnum
  local fntType = (fntEntity.fntData):GetFntType()
  local areaList = fntEntity:GetFntAreaList()
  local param = (fntEntity.fntData):GetFntParam()
  local map = self:__GetFntMap(fntType, param)
  if fntType ~= (DormEnum.eDormFntType).Wallpaper and self:_CheckAreaListOverlap(areaList, fntType, map) then
    return true
  end
  do
    if (fntEntity.fntData):IsInFntWallpaperMap() then
      local mapPaper = self:__GetFntMap((DormEnum.eDormFntType).Wallpaper, param)
      if self:_CheckAreaListOverlap(areaList, fntType, mapPaper, true) then
        return true
      end
    end
    if fntType == (DormEnum.eDormFntType).Door then
      local doorFloorAreaList = fntEntity:GetFntDoorAreaList()
      local floorMap = self:__GetFntMap((DormEnum.eDormFntType).Furniture)
      if self:_CheckAreaListOverlap(doorFloorAreaList, (DormEnum.eDormFntType).Furniture, floorMap) then
        return true
      end
    end
    do
      return false
    end
  end
end

DormRoomEntity._CheckAreaListOverlap = function(self, areaList, fntType, map, isWallpaperMap)
  -- function num : 0_25 , upvalues : _ENV
  for k,pos in pairs(areaList) do
    if self:FntPosOutMap(pos.x, pos.y, fntType) then
      return true
    end
    if map[pos.x] ~= nil and (map[pos.x])[pos.y] ~= nil then
      local grid = (map[pos.x])[pos.y]
      if self:_CheckAreaGridOverlap(grid, isWallpaperMap) then
        return true
      end
    end
  end
  return false
end

DormRoomEntity._CheckAreaGridOverlap = function(self, gridDic, isWallpaperMap)
  -- function num : 0_26 , upvalues : _ENV
  local overlap = false
  local num = 0
  local hasWallpaperOverlap = false
  for entity,_ in pairs(gridDic) do
    if isWallpaperMap and not hasWallpaperOverlap and (entity.fntData):IsFntWallpaperOverlap() then
      hasWallpaperOverlap = true
    end
    num = num + 1
    if num > 1 and isWallpaperMap and hasWallpaperOverlap then
      overlap = true
      break
    end
    overlap = true
    do break end
  end
  do
    return overlap
  end
end

DormRoomEntity.FntMapOverlap = function(self)
  -- function num : 0_27 , upvalues : _ENV
  for k,v in pairs(self.fntObjDic) do
    if v:IsOverlap() then
      return true
    end
  end
  return false
end

DormRoomEntity.OnRoomClicked = function(self, go, eventData)
  -- function num : 0_28
  if self.clickAction ~= nil then
    (self.clickAction)(self)
  end
end

DormRoomEntity.GetFntHolder = function(self, fntType, wallId)
  -- function num : 0_29 , upvalues : DormEnum, _ENV
  if (DormEnum.IsFntWallType)(fntType) then
    return (self.wallHolder)[wallId]
  else
    if fntType == (DormEnum.eDormFntType).Furniture then
      return self.fntHolder
    else
      if fntType == (DormEnum.eDormFntType).FloorDecoration then
        return self.floorHolder
      else
        error("Furniture type error, id = " .. tostring(fntType))
      end
    end
  end
end

DormRoomEntity.CreateFntEntity = function(self, fntData, isNew)
  -- function num : 0_30 , upvalues : DormFurnitureEntity
  local path = fntData:GetFntPrefab()
  local fntType = fntData:GetFntType()
  local entity = (DormFurnitureEntity.New)()
  local parent = self:GetFntHolder(fntType, fntData.param)
  entity:InitFntEntity(fntData, parent)
  self:AddFntEntityData(entity)
  if isNew then
    (self.roomData):AddFntData(fntData)
    self:UpdateFntMap(entity, true)
  end
  entity:LoadFntEntityGo(path, self._AddFntEntityGoFunc)
  return entity
end

DormRoomEntity.ChangeDmRoomDoorGo = function(self)
  -- function num : 0_31
  local fntData = (self.roomData).dmRoomDoorData
  local entity = self:GetFntByData(fntData)
  entity:InitFntEntityRoot()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if not entity:IsDmFntEntityInLoading() then
    (self.fntObjDic)[entity.gameObject] = nil
    entity:DestroyDmFntEntityGo()
  end
  entity:ResetFntBottom()
  local path = fntData:GetFntPrefab()
  entity:LoadFntEntityGo(path, self._AddFntEntityGoFunc)
end

DormRoomEntity.AddFntEntityGo = function(self, fntEntity)
  -- function num : 0_32
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.fntObjDic)[fntEntity.gameObject] = fntEntity
end

DormRoomEntity.AddFntEntityData = function(self, fntEntity)
  -- function num : 0_33
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.fntEntityDic)[fntEntity.fntData] = fntEntity
  local wallFntEntityDic = (self.wallFntEntityDic)[(fntEntity.fntData):GetFntParam()]
  if wallFntEntityDic ~= nil then
    wallFntEntityDic[fntEntity.fntData] = fntEntity
  end
end

DormRoomEntity.RemoveFntEntity = function(self, fntEntity, isRemoveAll)
  -- function num : 0_34 , upvalues : DormEnum
  local fntData = fntEntity.fntData
  local fntType = fntData:GetFntType()
  self:UpdateFntMap(fntEntity, false)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.fntObjDic)[fntEntity.gameObject] = nil
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.fntEntityDic)[fntEntity.fntData] = nil
  local wallFntEntityDic = (self.wallFntEntityDic)[(fntEntity.fntData):GetFntParam()]
  if wallFntEntityDic ~= nil then
    wallFntEntityDic[fntEntity.fntData] = nil
  end
  ;
  (self.roomData):RemoveFntData(fntEntity.fntData)
  if fntType == (DormEnum.eDormFntType).Wallpaper and not isRemoveAll then
    (self.roomData):RemoveDmWallpaper(fntData)
  end
end

DormRoomEntity.GetFntByGo = function(self, go)
  -- function num : 0_35 , upvalues : _ENV
  local entity = (self.fntObjDic)[go]
  if entity == nil then
    error("Can\'t get fnt entity by go, go = " .. tostring(go))
  end
  return entity
end

DormRoomEntity.GetFntByData = function(self, fntData)
  -- function num : 0_36
  return (self.fntEntityDic)[fntData]
end

DormRoomEntity.GetFntObjDic = function(self)
  -- function num : 0_37
  return self.fntObjDic
end

DormRoomEntity.GetFntCount = function(self)
  -- function num : 0_38
  return #(self.roomData).fntDataList
end

DormRoomEntity.IsOriginDmRoomFnt = function(self, fntData)
  -- function num : 0_39
  do return (self.originFntEntityDic)[fntData] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormRoomEntity.EnterRoomEditMode = function(self, floorGo, wallGoDic, roomCtrl)
  -- function num : 0_40 , upvalues : _ENV
  (self.roomData):BackupDmRoomDntList()
  ;
  (floorGo.transform):SetParent(self.transform, false)
  floorGo:SetActive(false)
  for k,go in pairs(wallGoDic) do
    (go.transform):SetParent(((self.wallHolder)[k]).parent, false)
    go:SetActive(false)
  end
  self:InitFntMapData()
  local originFntEntityDic = {}
  for k,fntEntity in pairs(self.fntObjDic) do
    local fntBottomItem = roomCtrl:GetFntBottomItem()
    fntEntity:AddFntBottom(fntBottomItem)
    do
      do
        if (fntEntity.fntData):IsDmFntDoor() then
          local bottomItem = roomCtrl:GetFntBottomItem()
          fntEntity:AddFntDoorBottom(bottomItem)
        end
        originFntEntityDic[fntEntity.fntData] = fntEntity
        -- DECOMPILER ERROR at PC51: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  self.originFntEntityDic = originFntEntityDic
  for k,fntEntity in pairs(self.fntEntityDic) do
    fntEntity:ResetFntAnimatorState()
  end
  self._dmRoomCtrl = roomCtrl
end

DormRoomEntity.ExitRoomEditMode = function(self, roomCtrl, editSuccess)
  -- function num : 0_41 , upvalues : _ENV
  self:ClearFntMapData()
  ;
  (self.roomData):ClearDmRoomDntListBackup()
  for k,fntEntity in pairs(self.fntEntityDic) do
    local fntBottomItem = fntEntity:RemoveFntBottom()
    if fntBottomItem ~= nil then
      roomCtrl:RecycleFntBottomItem(fntBottomItem)
    end
    local bottomItem = fntEntity:RemoveFntDoorBottom()
    if bottomItem ~= nil then
      roomCtrl:RecycleFntBottomItem(bottomItem)
    end
  end
  if editSuccess then
    self:__RefreshDormDoorPos()
  end
  self.originFntEntityDic = nil
  self._dmRoomCtrl = nil
end

DormRoomEntity.ResetAllFntAniState = function(self)
  -- function num : 0_42 , upvalues : _ENV
  if self.fntEntityDic == nil then
    return 
  end
  for k,fntEntity in pairs(self.fntEntityDic) do
    fntEntity:ResetFntAnimatorState()
  end
end

DormRoomEntity.StartHideRoom = function(self)
  -- function num : 0_43
  (self.gameObject):SetActive(false)
end

DormRoomEntity.StartShowRoom = function(self)
  -- function num : 0_44
  (self.gameObject):SetActive(true)
end

DormRoomEntity.ResetDormRoomWall = function(self)
  -- function num : 0_45
  self:Show2Hide2DormRoom(1, 2, 3, 4)
end

DormRoomEntity.Show3Hide1DormRoom = function(self, hideIndex)
  -- function num : 0_46
  for i = 1, 4 do
    self:SetDormRoomWallActive(i, hideIndex ~= i)
  end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormRoomEntity.Show2Hide2DormRoom = function(self, index1, index2, index3, index4)
  -- function num : 0_47
  self:SetDormRoomWallActive(index1, true)
  self:SetDormRoomWallActive(index2, true)
  self:SetDormRoomWallActive(index3, false)
  self:SetDormRoomWallActive(index4, false)
end

DormRoomEntity.SetDormRoomWallActive = function(self, index, active)
  -- function num : 0_48 , upvalues : _ENV
  if self.wallColliderDic == nil then
    return 
  end
  local wallCollider = (self.wallColliderDic)[index]
  if wallCollider ~= nil then
    wallCollider.enabled = active
  end
  local wallFntEntityDic = (self.wallFntEntityDic)[index]
  for fntData,fntEntity in pairs(wallFntEntityDic) do
    fntEntity:EnableDmFntCollider(active)
    fntEntity:EnableDmFntVisibleHolder(active)
  end
  if self._dmRoomCtrl ~= nil then
    (self._dmRoomCtrl):OnDmRoomWallShow(index, active)
  end
end

DormRoomEntity.ChangeDmRoomFloor = function(self, id)
  -- function num : 0_49 , upvalues : _ENV, DormUtil, CS_ResLoader
  if id == 0 then
    self:_InstantiateFloor((self._comResDic).defaultFloorPrefab)
    return 
  end
  local fntCfg = (ConfigData.dorm_furniture)[id]
  if fntCfg == nil then
    error("Can\'t find dorm_furniture cfg, id = " .. tostring(id))
    return 
  end
  local roomType = (self.roomData):GetDmRoomType()
  local path = (DormUtil.GetDmFntPrefabPath)(roomType, fntCfg)
  self:_ClearFloorResLoader()
  local resLoader = (CS_ResLoader.Create)()
  resLoader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_49_0 , upvalues : _ENV, self
    if IsNull(prefab) then
      return 
    end
    self:_InstantiateFloor(prefab)
  end
)
  self._floorResLoader = resLoader
end

DormRoomEntity._ClearFloorResLoader = function(self)
  -- function num : 0_50
  if self._floorResLoader ~= nil then
    (self._floorResLoader):Put2Pool()
    self._floorResLoader = nil
  end
end

DormRoomEntity.ChangeDmRoomWall = function(self, id)
  -- function num : 0_51 , upvalues : _ENV, DormUtil, CS_ResLoader
  if id == 0 then
    self:_InstantiateWall((self._comResDic).defaultWallPrefab)
    return 
  end
  local fntCfg = (ConfigData.dorm_furniture)[id]
  if fntCfg == nil then
    error("Can\'t find dorm_furniture cfg, id = " .. tostring(id))
    return 
  end
  local roomType = (self.roomData):GetDmRoomType()
  local path = (DormUtil.GetDmFntPrefabPath)(roomType, fntCfg)
  self:_ClearWallResLoader()
  local resLoader = (CS_ResLoader.Create)()
  resLoader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_51_0 , upvalues : _ENV, self
    if IsNull(prefab) then
      return 
    end
    self:_InstantiateWall(prefab)
  end
)
  self._wallResLoader = resLoader
end

DormRoomEntity._ClearWallResLoader = function(self)
  -- function num : 0_52
  if self._wallResLoader ~= nil then
    (self._wallResLoader):Put2Pool()
    self._wallResLoader = nil
  end
end

DormRoomEntity.IsDmRoomWall = function(self, gameObject)
  -- function num : 0_53 , upvalues : _ENV
  for wallIndex,go in pairs(self.wallObjDic) do
    if go == gameObject then
      return true, wallIndex, (self.wallHolder)[wallIndex]
    end
  end
  return false
end

DormRoomEntity.__RefreshDormDoorPos = function(self)
  -- function num : 0_54 , upvalues : _ENV, DormUtil
  local doorData = (self.roomData).dmRoomDoorData
  local offsetX = (doorData:GetFntSize() - 1) * (ConfigData.game_config).HouseGridWidth / 2
  local wallpos = (DormUtil.FntCoord2Unity)(doorData.x, doorData.y, doorData:GetFntType())
  local wallId = doorData:GetFntParam()
  local holder = (self.wallHolder)[wallId]
  if holder == nil then
    error("dorm holder ")
    return Vector3.zero
  end
  wallpos.x = wallpos.x - offsetX
  wallpos.z = -0.2
  local worldPos = holder:TransformPoint(wallpos)
  local y = ((self.transform).position).y
  worldPos.y = y
  wallpos.z = 0.2
  local doorFrontPos = holder:TransformPoint(wallpos)
  doorFrontPos.y = y
  self.__doorWorldPos = worldPos
  self.__doorFrontPos = doorFrontPos
end

DormRoomEntity.GetRoomDoorPos = function(self)
  -- function num : 0_55
  local wallId = ((self.roomData).dmRoomDoorData):GetFntParam()
  return wallId, self.__doorWorldPos, self.__doorFrontPos
end

DormRoomEntity.IsAnyDmFntEntityInLoading = function(self)
  -- function num : 0_56 , upvalues : _ENV
  for k,fntEntity in pairs(self.fntEntityDic) do
    if fntEntity:IsDmFntEntityInLoading() then
      return true
    end
  end
  return false
end

DormRoomEntity.GetDmRoomDoorWallId = function(self)
  -- function num : 0_57
  if self.roomData == nil then
    return 0
  end
  return ((self.roomData).dmRoomDoorData):GetFntParam()
end

DormRoomEntity.OnDelete = function(self)
  -- function num : 0_58 , upvalues : _ENV
  self:_ClearFloorResLoader()
  self:_ClearWallResLoader()
  self.wallObjDic = nil
  self.wallColliderDic = nil
  if self.fntEntityDic ~= nil then
    for fntData,fntEntity in pairs(self.fntEntityDic) do
      fntEntity:OnDelete()
    end
    self.fntEntityDic = nil
  end
end

return DormRoomEntity

