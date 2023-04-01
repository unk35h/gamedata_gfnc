-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessFogOfWarCtrl = class("WarChessFogOfWarCtrl", base)
local cs_ResLoader = CS.ResLoader
local WarChessHelper = require("Game.WarChess.WarChessHelper")
WarChessFogOfWarCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : cs_ResLoader
  self.resloader = (cs_ResLoader.Create)()
  self.__isOpenFog = true
  self.fogMap = {}
  self.mapWidth = nil
  self.mapHeight = nil
  self.__allMatTweens = {}
  self.__allFogTweens = {}
end

WarChessFogOfWarCtrl.GenFog = function(self, BFId)
  -- function num : 0_1 , upvalues : _ENV
  local fogRoot = ((self.wcCtrl).bind).trans_fogRoot
  local mapFogInfo = ((self.wcCtrl).mapCtrl):GetMapFogInfo(BFId)
  self.__isOpenFog = mapFogInfo.openFogOfWar
  if self.__isOpenFog then
    self.fogMap = {}
    self.mapWidth = mapFogInfo.mapWidth
    self.mapHeight = mapFogInfo.mapHeight
    local fogOfWarPrefab = (self.resloader):LoadABAsset(PathConsts:GetWarChessEffectPrefabPath("FXP_WarFog"))
    do
      self.fogItemPool = (CommonPool.New)(function()
    -- function num : 0_1_0 , upvalues : fogOfWarPrefab, fogRoot
    local fogOfWarObj = fogOfWarPrefab:Instantiate(fogRoot)
    return fogOfWarObj
  end
, function(fogOfWarObj)
    -- function num : 0_1_1
    (fogOfWarObj.gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (fogOfWarObj.gameObject).name = "recycled"
    return true
  end
)
      local meshRender = fogOfWarPrefab:GetComponentInChildren(typeof((CS.UnityEngine).MeshRenderer))
      if not IsNull(meshRender) then
        self.shardFogMats = meshRender.sharedMaterials
      end
      self:UpdateAllFog(BFId)
    end
  end
end

WarChessFogOfWarCtrl.UpdateFog = function(self, sightDiff)
  -- function num : 0_2 , upvalues : _ENV, WarChessHelper
  if not self.__isOpenFog then
    return 
  end
  local hasFogClear = false
  for BFId,diffDatas in pairs(sightDiff) do
    for coordination,bool in pairs(diffDatas.update) do
      local fogOfWarObj = (self.fogMap)[coordination]
      local x, y = (WarChessHelper.Coordination2Pos)(coordination)
      if fogOfWarObj ~= nil and bool then
        self:__OpenFog(fogOfWarObj, coordination, x, y)
        hasFogClear = true
      end
      if not bool then
        self:__CreatFog(coordination, x, y)
      end
    end
  end
  if hasFogClear then
    AudioManager:PlayAudioById(1232)
  end
end

WarChessFogOfWarCtrl.UpdateAllFog = function(self, BFId)
  -- function num : 0_3 , upvalues : WarChessHelper, _ENV
  if not self.__isOpenFog then
    return 
  end
  local fogDic = ((self.wcCtrl).mapCtrl):GetWCFogData(BFId)
  if fogDic == nil then
    return 
  end
  for x = 0, self.mapWidth do
    for y = 0, self.mapHeight do
      local coordination = (WarChessHelper.Pos2Coordination)((Vector2.New)(x, y))
      local fogOfWarObj = (self.fogMap)[coordination]
      if fogOfWarObj ~= nil and fogDic[coordination] then
        self:__OpenFog(fogOfWarObj, coordination, x, y)
      end
      if not fogDic[coordination] then
        self:__CreatFog(coordination, x, y)
      else
        local gridObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, false)
        local groundObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, true)
        if not IsNull(gridObj) then
          gridObj:SetActive(true)
        end
        if not IsNull(groundObj) then
          groundObj:SetActive(false)
        end
      end
    end
  end
end

WarChessFogOfWarCtrl.__OpenFog = function(self, fogOfWarObj, coordination, x, y)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R5 in 'UnsetPending'

  (self.__allFogTweens)[fogOfWarObj] = ((fogOfWarObj.transform):DOLocalMoveY(-0.5, 0.5)):OnComplete(function()
    -- function num : 0_4_0 , upvalues : self, fogOfWarObj
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    (self.__allFogTweens)[fogOfWarObj] = nil
  end
)
  local meshRender = fogOfWarObj:GetComponentInChildren(typeof((CS.UnityEngine).MeshRenderer))
  local materials = meshRender.materials
  for i = 0, materials.Length - 1 do
    local mat = materials[i]
    do
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R12 in 'UnsetPending'

      (self.__allMatTweens)[mat] = (mat:DOFloat(0, "_Alpha", 0.5)):OnComplete(function()
    -- function num : 0_4_1 , upvalues : self, coordination, fogOfWarObj, mat
    if (self.fogMap)[coordination] ~= nil then
      (self.fogItemPool):PoolPut(fogOfWarObj)
      -- DECOMPILER ERROR at PC11: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.fogMap)[coordination] = nil
    end
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.__allMatTweens)[mat] = nil
  end
)
    end
  end
  local gridObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, false)
  local groundObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, true)
  if not IsNull(gridObj) then
    gridObj:SetActive(true)
  end
  if not IsNull(groundObj) then
    groundObj:SetActive(false)
  end
end

WarChessFogOfWarCtrl.__CreatFog = function(self, coordination, x, y)
  -- function num : 0_5 , upvalues : _ENV
  local fogOfWarObj = (self.fogItemPool):PoolGet()
  ;
  (fogOfWarObj.gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (fogOfWarObj.transform).position = (Vector3.New)(x, 0, y)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (fogOfWarObj.gameObject).name = tostring(x) .. "," .. tostring(y)
  local meshRender = fogOfWarObj:GetComponentInChildren(typeof((CS.UnityEngine).MeshRenderer))
  if not IsNull(meshRender) then
    meshRender.sharedMaterials = self.shardFogMats
  end
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.fogMap)[coordination] = fogOfWarObj
  local gridObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, false)
  local groundObj = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, x, y, true)
  if not IsNull(gridObj) then
    gridObj:SetActive(false)
  end
  if not IsNull(groundObj) then
    groundObj:SetActive(true)
  end
end

WarChessFogOfWarCtrl.OnSceneUnload = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for mat,tween in pairs(self.__allMatTweens) do
    tween:Kill()
  end
  for fogOfWarObj,tween in pairs(self.__allFogTweens) do
    tween:Kill()
  end
  self.__allMatTweens = {}
  self.__allFogTweens = {}
  self.fogMap = {}
  self.fogItemPool = nil
  self.shardFogMats = nil
end

return WarChessFogOfWarCtrl

