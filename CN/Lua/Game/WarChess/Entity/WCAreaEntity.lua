-- params : ...
-- function num : 0 , upvalues : _ENV
local WCAreaEntity = class("WCAreaEntity")
local cs_ResLoader = CS.ResLoader
local cs_LightmapSettings = (CS.UnityEngine).LightmapSettings
local cs_List = (((CS.System).Collections).Generic).List
local cs_MeshRenderer = (CS.UnityEngine).MeshRenderer
local cs_LightmapData = (CS.UnityEngine).LightmapData
local cs_LightMapDataLoader = CS.LightMapDataLoader
local cs_Shader = (CS.UnityEngine).Shader
local cs_MaterialPropertyBlock = (CS.UnityEngine).MaterialPropertyBlock
local type_wcAreaRoot = typeof(CS.WarChessAreaRoot)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
WCAreaEntity.ctor = function(self, areaData)
  -- function num : 0_0
  self.resloader = nil
  self.areaData = areaData
  self.areaGo = nil
  self.areaGroundGo = nil
  self.wcAreaRoot = nil
  self.wcAreaGroundRoot = nil
end

WCAreaEntity.WCAreaEntityPreLoad = function(self, isReuse)
  -- function num : 0_1 , upvalues : _ENV, cs_ResLoader
  if not isReuse and self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.areaGo ~= nil then
    DestroyUnityObject(self.heroGo)
    self.areaGo = nil
  end
  local path = PathConsts:GetWarChessAreaPrefabPath((self.areaData):GetWCAreaResName())
  local path_ground = PathConsts:GetWarChessAreaPrefabPath((self.areaData):GetWCAreaResName() .. "_ground")
  if not isReuse or self.resloader == nil then
    self.resloader = (cs_ResLoader.Create)()
  end
  local areaAwait = ((self.resloader):LoadABAssetAsyncAwait(path, function(prefab)
    -- function num : 0_1_0 , upvalues : self
    self.__prefab = prefab
  end
))
  local areaGroundAwait = nil
  local openFogOfWar = true
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl ~= nil and wcCtrl.mapCtrl ~= nil then
    openFogOfWar = (wcCtrl.mapCtrl):IsOpenFogOfWar()
  end
  if openFogOfWar then
    areaGroundAwait = (self.resloader):LoadABAssetAsyncAwait(path_ground, function(prefab)
    -- function num : 0_1_1 , upvalues : self
    self.__groundPrefab = prefab
  end
)
  end
  return {areaAwait, areaGroundAwait}, BindCallback(self, self.RealLoadModel)
end

WCAreaEntity.RealLoadModel = function(self, bind)
  -- function num : 0_2 , upvalues : _ENV, eWarChessEnum, WarChessHelper, type_wcAreaRoot
  local modelRoot = bind.trans_AreaRoot
  local x, y = (self.areaData):GetWCAreaLogicPosXY()
  local width, height = (self.areaData):GetWCAreaSizeXY()
  local showPos = (Vector3.New)(x, 0, y)
  local towards = ((self.areaData):GetWCAreaLogicToward())
  local rotae = nil
  if towards ~= (eWarChessEnum.eGridToward).up then
    rotae = (WarChessHelper.GridToward2RotateValue)(towards)
    if towards == (eWarChessEnum.eGridToward).right then
      showPos.z = showPos.z + width - 1
    else
      if towards == (eWarChessEnum.eGridToward).left then
        showPos.x = showPos.x + height - 1
      else
        if towards == (eWarChessEnum.eGridToward).down then
          showPos.x = showPos.x + width - 1
          showPos.z = showPos.z + height - 1
        end
      end
    end
  end
  if self.__prefab ~= nil then
    self.areaGo = (self.__prefab):Instantiate(modelRoot)
    if rotae ~= nil then
      ((self.areaGo).transform):Rotate(rotae)
    end
    -- DECOMPILER ERROR at PC77: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.areaGo).name = (string.format)("%s,%s", x, y)
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.areaGo).transform).position = showPos
    self.wcAreaRoot = (self.areaGo):GetComponent(type_wcAreaRoot)
    self:ReSetLightMap(self.areaGo)
  end
  if self.__groundPrefab ~= nil then
    self.areaGroundGo = (self.__groundPrefab):Instantiate(modelRoot)
    if rotae ~= nil then
      ((self.areaGroundGo).transform):Rotate(rotae)
    end
    -- DECOMPILER ERROR at PC111: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.areaGroundGo).name = (string.format)("%s,%s_ground", x, y)
    -- DECOMPILER ERROR at PC114: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.areaGroundGo).transform).position = showPos
    self.wcAreaGroundRoot = (self.areaGroundGo):GetComponent(type_wcAreaRoot)
    self:ReSetLightMap(self.areaGroundGo)
  end
  self.__prefab = nil
  self.__groundPrefab = nil
end

WCAreaEntity.ReSetLightMap = function(self, root)
  -- function num : 0_3 , upvalues : cs_List, cs_MeshRenderer, _ENV, cs_LightMapDataLoader, cs_LightmapSettings, cs_LightmapData
  local lightMapRenders = (cs_List(cs_MeshRenderer))()
  local renderList = root:GetComponentsInChildren(typeof(cs_MeshRenderer))
  for i = 0, renderList.Length - 1 do
    if ((renderList[i]).gameObject):CompareTag(TagConsts.WarChessLightmapped) then
      lightMapRenders:Add(renderList[i])
    end
    self:__ReplaceArenaBox(renderList[i])
  end
  local lightMapLoader = root:GetComponent(typeof(cs_LightMapDataLoader))
  if IsNull(lightMapLoader) then
    return 
  end
  local asset = lightMapLoader.Asset
  if IsNull(asset) then
    return 
  end
  local datas = asset.LightMapDatas
  local lightmaps = cs_LightmapSettings.lightmaps
  local lightmapList = (cs_List(cs_LightmapData))(lightmaps)
  if lightMapRenders.Count == 0 then
    return 
  end
  if lightMapRenders.Count ~= datas.Length then
    print("烘培贴图物体数量和静态物体数量不一致！")
    return 
  end
  for i = 0, lightMapRenders.Count - 1 do
    local lightMapIndex = -1
    local nullIndex = -1
    local currentData = nil
    for j = lightmapList.Count - 1, 0, -1 do
      local lightmap = lightmapList[j]
      if ((datas[i]).LightmapData):IsA(lightmap) then
        lightMapIndex = j
        currentData = lightmap
      end
      if IsNull(lightmap.lightmapColor) and IsNull(lightmap.lightmapDir) and IsNull(lightmap.shadowMask) then
        nullIndex = j
      end
    end
    if lightMapIndex == -1 then
      currentData = ((datas[i]).LightmapData):GetLightmapData()
      if nullIndex == -1 then
        lightmapList:Add(currentData)
        lightMapIndex = lightmapList.Count - 1
      else
        lightmapList[nullIndex] = currentData
        lightMapIndex = nullIndex
      end
    end
    local render = lightMapRenders[i]
    render.lightmapIndex = lightMapIndex
    render.lightmapScaleOffset = (datas[i]).LightmapScaleOffset
  end
  cs_LightmapSettings.lightmaps = lightmapList:ToArray()
end

WCAreaEntity.__InitBoxPropertyBlockMap = function(self)
  -- function num : 0_4 , upvalues : cs_Shader, cs_MaterialPropertyBlock, _ENV
  if self.boxPropertyBlockMap == nil then
    local oneHalf = 0.5
    do
      local oneFourth = 0.25
      local ScaleAndOffsetNameID = (cs_Shader.PropertyToID)("_ScaleAndOffset")
      local CreateScaleAndOffsetPropertyBlock = function(scaleAndOffset)
    -- function num : 0_4_0 , upvalues : cs_MaterialPropertyBlock, ScaleAndOffsetNameID
    local pb = cs_MaterialPropertyBlock()
    pb:SetVector(ScaleAndOffsetNameID, scaleAndOffset)
    return pb
  end

      self.boxPropertyBlockMap = {ground_007_Arena_001_G_Box01 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 0 * oneFourth, oneHalf)), ground_007_Arena_001_G_Box02 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 1 * oneFourth, oneHalf)), ground_007_Arena_001_G_Box03 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 2 * oneFourth, oneHalf)), ground_007_Arena_001_G_Box04 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 3 * oneFourth, oneHalf)), ground_007_Arena_001_G_Box05 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 0 * oneFourth, 2 * oneHalf)), ground_007_Arena_001_G_Box06 = CreateScaleAndOffsetPropertyBlock((Vector4.New)(oneFourth, oneHalf, 1 * oneFourth, 2 * oneHalf))}
    end
  end
end

WCAreaEntity.__ReplaceArenaBox = function(self, meshRenderer)
  -- function num : 0_5
  self:__InitBoxPropertyBlockMap()
  local meshName = meshRenderer.name
  local propertyBlock = (self.boxPropertyBlockMap)[meshName]
  if propertyBlock ~= nil then
    meshRenderer:SetPropertyBlock(propertyBlock)
  end
end

WCAreaEntity.WCAreaEnityGetGoByXY = function(self, x, y)
  -- function num : 0_6
  if self.wcAreaRoot == nil then
    return nil
  end
  return (self.wcAreaRoot):GetGrid(x, y)
end

WCAreaEntity.WCAreaEnityGetGroundGoByXY = function(self, x, y)
  -- function num : 0_7
  if self.wcAreaGroundRoot == nil then
    return nil
  end
  return (self.wcAreaGroundRoot):GetGrid(x, y)
end

return WCAreaEntity

