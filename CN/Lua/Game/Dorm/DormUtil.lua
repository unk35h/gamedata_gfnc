-- params : ...
-- function num : 0 , upvalues : _ENV
local DormUtil = {}
local RoomPosOffset = 256
local cs_HighLighting = CS.HighLighting
local cs_RenderManager = CS.RenderManager
local DormEnum = require("Game.Dorm.DormEnum")
local hexSize = 30
local sqrt3 = (math.sqrt)(3)
local bedcount = 6
local sinTab = {[0] = 0, [90] = 1, [180] = 0, [270] = -1, [360] = 0}
local cosTab = {[0] = 1, [90] = 0, [180] = -1, [270] = 0, [360] = 1}
DormUtil.FntForOffset = {
{x = -1, y = -1}
, 
{x = -1, y = 0}
, 
{x = -1, y = 1}
, 
{x = 0, y = -1}
, 
{x = 0, y = 1}
, 
{x = 1, y = -1}
, 
{x = 1, y = 0}
, 
{x = 1, y = 1}
}
local DormWallRotation = {[1] = (Quaternion.Euler)(0, 0, 0), [2] = (Quaternion.Euler)(0, 90, 0), [3] = (Quaternion.Euler)(0, 180, 0), [4] = (Quaternion.Euler)(0, 270, 0)}
local DormWallRotReverse = {[1] = (Quaternion.Euler)(0, 180, 0), [2] = (Quaternion.Euler)(0, 270, 0), [3] = (Quaternion.Euler)(0, 0, 0), [4] = (Quaternion.Euler)(0, 90, 0)}
local cs_Screen = (CS.UnityEngine).Screen
DormUtil.NearInterPointDistance = 100 * cs_Screen.width / 1920
DormUtil.GetDormConfigAsset = function()
  -- function num : 0_0 , upvalues : _ENV
  local ctrl = ControllerManager:GetController(ControllerTypeId.Dorm)
  return ctrl:GetDormConfigAsset()
end

DormUtil.GetBedCount = function(self)
  -- function num : 0_1
  return 10
end

DormUtil.RoomCoordToXY = function(pos)
  -- function num : 0_2 , upvalues : RoomPosOffset, _ENV
  local x = (pos >> 16) - RoomPosOffset
  local y = (pos & CommonUtil.UInt16Max) - RoomPosOffset
  return x, y
end

DormUtil.XYToRoomCoord = function(x, y)
  -- function num : 0_3 , upvalues : RoomPosOffset
  local pos = x + RoomPosOffset << 16 | y + RoomPosOffset
  return pos
end

DormUtil.FntCoord2XY = function(pos)
  -- function num : 0_4 , upvalues : _ENV
  local x = pos >> 16
  local y = pos & CommonUtil.UInt16Max
  return x, y
end

DormUtil.XYCoord2Fnt = function(x, y)
  -- function num : 0_5
  local pos = x << 16 | y
  return pos
end

DormUtil.ToRectTransformPos = function(x, y)
  -- function num : 0_6 , upvalues : _ENV, hexSize, sqrt3
  local z = -x - y
  local position = (Vector2.New)()
  position.x = hexSize * sqrt3 * (x + z / 2)
  position.y = hexSize * z * 3 / 2
  return position
end

local roomPos2IndexDic = {}
DormUtil.GetRoomIndexByRoomposToxy = function(x, y, r)
  -- function num : 0_7 , upvalues : roomPos2IndexDic, _ENV
  local pos2IdxDic = roomPos2IndexDic[r]
  if pos2IdxDic == nil then
    pos2IdxDic = {}
    roomPos2IndexDic[r] = pos2IdxDic
    local n = r
    local idx = 0
    for dz = n, -n, -1 do
      for dx = (math.max)(-n, -dz - n), (math.min)(n, -dz + n) do
        local dy = -dz - dx
        idx = idx + 1
        if not pos2IdxDic[dx] then
          do
            pos2IdxDic[dx] = {}
            -- DECOMPILER ERROR at PC35: Confused about usage of register: R15 in 'UnsetPending'

            ;
            (pos2IdxDic[dx])[dy] = idx
            -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC36: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  do
    local idx = pos2IdxDic[x] and (pos2IdxDic[x])[y] or nil
    if idx == nil then
      error("Cant get room index")
      return 0
    end
    return idx
  end
end

DormUtil.FntCoord2Unity = function(x, y, fntType)
  -- function num : 0_8 , upvalues : _ENV, DormEnum
  local uX = x * (ConfigData.game_config).HouseGridWidth
  local uY = y * (ConfigData.game_config).HouseGridWidth
  local unityPos = nil
  if (DormEnum.IsFntWallType)(fntType) then
    unityPos = (Vector3.New)(-uX, -uY, 0)
  else
    unityPos = (Vector3.New)(uY, 0, uX)
  end
  return unityPos
end

DormUtil.GetFntUnityCoord = function(x, y)
  -- function num : 0_9 , upvalues : DormUtil, DormEnum
  return (DormUtil.FntCoord2Unity)(x, y, (DormEnum.eDormFntType).Furniture)
end

DormUtil.UnityCoord2Fnt = function(pos, fntType)
  -- function num : 0_10 , upvalues : DormEnum, _ENV
  local x, y = nil, nil
  if (DormEnum.IsFntWallType)(fntType) then
    x = -pos.x / (ConfigData.game_config).HouseGridWidth
    y = -pos.y / (ConfigData.game_config).HouseGridWidth
  else
    x = pos.z / (ConfigData.game_config).HouseGridWidth
    y = pos.x / (ConfigData.game_config).HouseGridWidth
  end
  x = (math.floor)(x + 0.5)
  y = (math.floor)(y + 0.5)
  return x, y
end

DormUtil.GetFntArea = function(posX, posY, sizeX, sizeY, angle)
  -- function num : 0_11 , upvalues : cosTab, sinTab, _ENV
  local areaList = {}
  for i = 0, sizeX - 1 do
    for j = 0, sizeY - 1 do
      local x = i
      local y = j
      local pos = {x = x * cosTab[angle] - y * sinTab[angle] + posX, y = x * sinTab[angle] + y * cosTab[angle] + posY}
      ;
      (table.insert)(areaList, pos)
    end
  end
  return areaList
end

DormUtil.IsDmRoomDefaultDoorId = function(fntId)
  -- function num : 0_12 , upvalues : _ENV
  do return fntId == (ConfigData.game_config).DmRoomDoorDefaultId or fntId == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

local DoorR = {[2] = proto_object_FT_R.R_0, [3] = proto_object_FT_R.R_90, [4] = proto_object_FT_R.R_180, [1] = proto_object_FT_R.R_270}
DormUtil.GetFntDoorR = function(wallId)
  -- function num : 0_13 , upvalues : DoorR, _ENV
  local r = DoorR[wallId]
  if r == nil then
    error("Cant get fnt door R,wallId = " .. tostring(wallId))
    return 0
  end
  return r
end

local genDoorPosFunc = {[2] = function(wallPosX, gridLength)
  -- function num : 0_14
  return wallPosX, 0
end
, [3] = function(wallPosX, gridLength)
  -- function num : 0_15
  return gridLength - 1, wallPosX
end
, [4] = function(wallPosX, gridLength)
  -- function num : 0_16
  return gridLength - 1 - wallPosX, gridLength - 1
end
, [1] = function(wallPosX, gridLength)
  -- function num : 0_17
  return 0, gridLength - 1 - wallPosX
end
}
DormUtil.GetFntDoorPosByWall = function(wallId, wallPosX, gridLength)
  -- function num : 0_18 , upvalues : genDoorPosFunc, _ENV
  local func = genDoorPosFunc[wallId]
  if func == nil then
    error("Cant get genDoorPosFunc,wallId = " .. tostring(wallId))
    return 0, 0
  end
  return func(wallPosX, gridLength)
end

DormUtil.FntAreaOutMap = function(posX, posY, sizeX, sizeY, angle, fntType, roomCfg)
  -- function num : 0_19 , upvalues : _ENV, cosTab, sinTab, DormEnum
  local mapX = roomCfg.grid_length - 1
  local mapY = roomCfg.grid_height - 1
  local areaList = {
{0, 0}
}
  if sizeX > 1 then
    (table.insert)(areaList, {sizeX - 1, 0})
  end
  if sizeY > 1 then
    (table.insert)(areaList, {0, sizeY - 1})
  end
  if sizeX > 1 and sizeY > 1 then
    (table.insert)(areaList, {sizeX - 1, sizeY - 1})
  end
  local outX = false
  local outY = false
  local offsetX = 0
  local offsetY = 0
  for k,v in pairs(areaList) do
    local x, y = v[1], v[2]
    local areaX = x * cosTab[angle] - y * sinTab[angle] + posX
    local areaY = x * sinTab[angle] + y * cosTab[angle] + posY
    if areaX < 0 then
      outX = true
      offsetX = (math.max)(-areaX, offsetX)
    else
      if mapX < areaX then
        outX = true
        offsetX = (math.min)(mapX - areaX, offsetX)
      end
    end
    if (DormEnum.IsFntWallType)(fntType) then
      if areaY < 0 then
        outY = true
        offsetY = (math.max)(offsetY, -areaY)
      else
        if mapY < areaY then
          outY = true
          offsetY = (math.min)(offsetY, mapY - areaY)
        end
      end
    else
      if areaY < 0 then
        outY = true
        offsetY = (math.max)(offsetY, -areaY)
      else
        if mapX < areaY then
          outY = true
          offsetY = (math.min)(offsetY, mapX - areaY)
        end
      end
    end
  end
  local newX = posX + offsetX
  local newY = posY + offsetY
  return outX, outY, newX, newY
end

DormUtil.FntSize2Unity = function(sizeX, sizeY, fntType)
  -- function num : 0_20 , upvalues : _ENV, DormEnum
  local uX = sizeX * (ConfigData.game_config).HouseGridWidth
  local uY = sizeY * (ConfigData.game_config).HouseGridWidth
  if (DormEnum.IsFntWallType)(fntType) then
    return (Vector3.New)(uX, 1, uY)
  else
    return (Vector3.New)(uY, 1, uX)
  end
end

DormUtil.AddFntToMapDic = function(mapDic, posX, posY, sizeX, sizeY, angle)
  -- function num : 0_21 , upvalues : cosTab, sinTab, DormUtil
  for x = 0, sizeX - 1 do
    for y = 0, sizeY - 1 do
      local curx = x * cosTab[angle] - y * sinTab[angle] + posX
      local cury = x * sinTab[angle] + y * cosTab[angle] + posY
      local pos = (DormUtil.XYCoord2Fnt)(curx, cury)
      mapDic[pos] = 1
    end
  end
end

DormUtil.IsFntCoordLegal = function(x, y, gridLenth)
  -- function num : 0_22
  if x < 0 or gridLenth <= x then
    return false
  end
  if y < 0 or gridLenth <= y then
    return false
  end
  return true
end

DormUtil.GetFntOffsetCoord = function(fntX, fntY, fntR, x, y)
  -- function num : 0_23 , upvalues : cosTab, sinTab
  local dstX = x * cosTab[fntR] - y * sinTab[fntR] + fntX
  local dstY = x * sinTab[fntR] + y * cosTab[fntR] + fntY
  return dstX, dstY
end

DormUtil.GetDormWallRot = function(wallId, reverse)
  -- function num : 0_24 , upvalues : DormWallRotReverse, DormWallRotation
  if reverse then
    return DormWallRotReverse[wallId]
  else
    return DormWallRotation[wallId]
  end
end

DormUtil.GetDmFntPrefabPath = function(roomType, fntCfg)
  -- function num : 0_25 , upvalues : _ENV
  local path = fntCfg.prefab
  do
    if roomType ~= 0 then
      local keyStr = "prefab_" .. tostring(roomType)
      if not (string.IsNullOrEmpty)(fntCfg[keyStr]) then
        path = fntCfg[keyStr]
      end
    end
    return PathConsts:GetDormFntPath(path)
  end
end

DormUtil.GetDmFntNumLimit = function(roomType, fntCatCfg)
  -- function num : 0_26 , upvalues : _ENV
  local value = fntCatCfg.limit
  do
    if roomType ~= 0 then
      local keyStr = "limit_" .. tostring(roomType)
      value = fntCatCfg[keyStr]
    end
    return value
  end
end

DormUtil.AddHighLightTarget = function(gameObject)
  -- function num : 0_27 , upvalues : cs_HighLighting, cs_RenderManager
  (cs_HighLighting.Instance):AddHighLightTarget(gameObject)
  if cs_RenderManager.IsRenderTextureMode == false then
    cs_RenderManager.IsRenderTextureMode = true
  end
end

DormUtil.RemovePointFntHighlight = function(gameObject)
  -- function num : 0_28 , upvalues : cs_HighLighting
  (cs_HighLighting.Instance):RemoveHighLightTarget(gameObject)
end

DormUtil.IsPositionWalkable = function(position, containNoLocked)
  -- function num : 0_29 , upvalues : _ENV
  if not containNoLocked then
    containNoLocked = false
  end
  return ((CS.DormAStarUtils).IsPositionWalkable)(position, containNoLocked)
end

DormUtil.IsPositionOnNavmesh = function(position)
  -- function num : 0_30 , upvalues : _ENV
  return ((CS.DormAStarUtils).IsPositionOnNavmesh)(position)
end

DormUtil.FindNearestActivePoint = function(position)
  -- function num : 0_31 , upvalues : _ENV
  return ((CS.DormAStarUtils).FindNearestActivePoint)(position)
end

DormUtil.GetDormCmderResName = function()
  -- function num : 0_32 , upvalues : _ENV
  if PlayerDataCenter:GetCmderSex() then
    return "professor"
  else
    return "professor_boy"
  end
end

DormUtil.GetDormCmderConfig = function()
  -- function num : 0_33 , upvalues : _ENV
  return (ConfigData.dorm_special_hero)[1]
end

return DormUtil

