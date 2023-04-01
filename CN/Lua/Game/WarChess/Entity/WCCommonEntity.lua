-- params : ...
-- function num : 0 , upvalues : _ENV
local WCCommonEntity = class("WCCommonEntity")
local cs_ResLoader = CS.ResLoader
local cs_GameObject = (CS.UnityEngine).GameObject
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
WCCommonEntity.ctor = function(self, entityData)
  -- function num : 0_0
  self.__parentGo = nil
  self.resloader = nil
  self.entityData = entityData
  self.entityGo = nil
end

WCCommonEntity.PreLoadModel = function(self, notWait, bind)
  -- function num : 0_1 , upvalues : _ENV, cs_GameObject, cs_ResLoader
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.entityGo ~= nil then
    DestroyUnityObject(self.entityGo)
    self.entityGo = nil
  end
  if not IsNull(self.__parentGo) then
    DestroyUnityObject(self.__parentGo)
    self.__parentGo = nil
  end
  local go = cs_GameObject()
  self.__parentGo = go
  local creatLogicPos = (self.entityData):GetEntityLogicPos()
  do
    if creatLogicPos ~= nil then
      local pos = (Vector3.New)(creatLogicPos.x, 0, creatLogicPos.y)
      self:WCEntitySetPos(pos)
    end
    local modelPath = PathConsts:GetWarChessPrefabPath((self.entityData):GetResModelName())
    self.resloader = (cs_ResLoader.Create)()
    if (self.entityData):GetIsEmptyEntity() then
      if notWait then
        self:RealLoadModel(bind)
        return 
      end
      return nil, BindCallback(self, self.RealLoadModel)
    end
    if notWait then
      self.__prefab = (self.resloader):LoadABAsset(modelPath)
      self:RealLoadModel(bind)
      return 
    end
    local areaAwait = (self.resloader):LoadABAssetAsyncAwait(modelPath, function(prefab)
    -- function num : 0_1_0 , upvalues : self
    self.__prefab = prefab
  end
)
    return areaAwait, BindCallback(self, self.RealLoadModel)
  end
end

WCCommonEntity.RealLoadModel = function(self, bind)
  -- function num : 0_2 , upvalues : _ENV, cs_GameObject
  local creatLogicPos = (self.entityData):GetEntityLogicPos()
  local parentName = "Entity:" .. tostring(creatLogicPos.x) .. "," .. tostring(creatLogicPos.y)
  if IsNull(self.__parentGo) then
    self.__parentGo = cs_GameObject()
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__parentGo).name = parentName
  ;
  ((self.__parentGo).transform):SetParent(bind.entityRoot)
  if self.__prefab ~= nil then
    self.entityGo = (self.__prefab):Instantiate((self.__parentGo).transform)
  end
  do
    if creatLogicPos ~= nil then
      local pos = (Vector3.New)(creatLogicPos.x, 0, creatLogicPos.y)
      self:WCEntitySetPos(pos)
    end
    self.__prefab = nil
  end
end

WCCommonEntity.GetWCEntityMoverOverCallback = function(self, moveOverCallback)
  -- function num : 0_3
  self.moveOverCallback = moveOverCallback
end

WCCommonEntity.WCEntitySetPos = function(self, pos, playAnim)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  if not playAnim then
    ((self.__parentGo).transform).position = pos
    if self.moveOverCallback ~= nil then
      (self.moveOverCallback)()
      self.moveOverCallback = nil
    end
  else
    ;
    ((((self.__parentGo).transform):DOMove(pos, 0.5)):OnUpdate(function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    if not (self.entityData):GetWCEntityIsAlive() then
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.WC_EntityInfoUpdate, self.entityData)
  end
)):OnComplete(function()
    -- function num : 0_4_1 , upvalues : self
    if self.moveOverCallback ~= nil then
      (self.moveOverCallback)()
      self.moveOverCallback = nil
    end
  end
)
  end
  local rotate = (self.entityData):GetWCEntityRotate()
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

  if rotate ~= nil then
    ((self.__parentGo).transform).localRotation = (Quaternion.Euler)(rotate.x, rotate.y, rotate.z)
  end
end

WCCommonEntity.WCEntityGetParentGO = function(self)
  -- function num : 0_5
  return self.__parentGo
end

WCCommonEntity.WCEntityGetShowPos = function(self)
  -- function num : 0_6
  if self.__parentGo == nil then
    return nil
  end
  return ((self.__parentGo).transform).position
end

WCCommonEntity.Show = function(self)
  -- function num : 0_7
  (self.__parentGo):SetActive(true)
end

WCCommonEntity.Hide = function(self)
  -- function num : 0_8
  (self.__parentGo):SetActive(false)
end

WCCommonEntity.PlayWCEntityAnimation = function(self, animaId, animaTrigger)
  -- function num : 0_9 , upvalues : _ENV
  if not (self.entityData):GetWCEntityIsAlive() then
    (self.entityData):WCDeleteEntityGo()
    return 
  end
  local entityGoAnimState = (self.__parentGo):GetComponentInChildren(typeof(CS.WarChessGridAnimState))
  if entityGoAnimState ~= nil then
    entityGoAnimState:SetStageValue(animaId)
    if animaTrigger then
      entityGoAnimState:Tigger()
    end
    local nameHash = entityGoAnimState:GetCurrentStateNameHash()
    ;
    (self.entityData):SaveEnitityAnimArg(nameHash, animaId)
  end
end

WCCommonEntity.PlayWCEntityDownTween = function(self, time, delay)
  -- function num : 0_10 , upvalues : _ENV
  ;
  ((((self.__parentGo).transform):DOLocalMoveY(-1, IsNull(self.__parentGo) or 0.5)):SetDelay(not time and delay or 0)):OnComplete(function()
    -- function num : 0_10_0 , upvalues : self
    (self.entityData):WCDeleteEntityGo()
  end
)
end

WCCommonEntity.SetWCEntityAnimation = function(self, nameHash, animaId)
  -- function num : 0_11 , upvalues : _ENV
  if IsNull(self.__parentGo) then
    error("entity is nil")
    return 
  end
  local entityGoAnimState = (self.__parentGo):GetComponentInChildren(typeof(CS.WarChessGridAnimState))
  if entityGoAnimState ~= nil then
    entityGoAnimState:ReSetState(nameHash, animaId)
  end
end

WCCommonEntity.EntityOnSceneUnload = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if not IsNull(self.__parentGo) then
    ((self.__parentGo).transform):DOKill()
  end
end

WCCommonEntity.Delete = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self.__parentGo ~= nil then
    DestroyUnityObject(self.__parentGo)
    self.__parentGo = nil
  end
  self.entityGo = nil
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return WCCommonEntity

