-- params : ...
-- function num : 0 , upvalues : _ENV
local WCMonsterEntity = class("WCMonsterEntity")
local cs_ResLoader = CS.ResLoader
local cs_GameObject = (CS.UnityEngine).GameObject
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local rotae = (WarChessHelper.rotateValue)[(eWarChessEnum.eGridToward).down]
local TEAM_MOVE_SPEED_PER_SECOND = 1.8
local ROTATE_COST_TIME = 0.2
WCMonsterEntity.ctor = function(self, entityData)
  -- function num : 0_0
  self.__parentGo = nil
  self.resloader = nil
  self.entityData = entityData
  self.monsterGo = nil
  self.animator = nil
end

WCMonsterEntity.PreLoadModel = function(self, notWait, bind)
  -- function num : 0_1 , upvalues : _ENV, cs_GameObject, cs_ResLoader
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.monsterGo ~= nil then
    DestroyUnityObject(self.monsterGo)
    self.monsterGo = nil
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
    local resName, isShadow = (self.entityData):GetResModelName()
    local specSign = isShadow and (ResConsts.ModelSignType).GrayMode or 0
    local modelPath = PathConsts:GetCharacterModelPathEx(resName, specSign)
    self.resloader = (cs_ResLoader.Create)()
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

WCMonsterEntity.RealLoadModel = function(self, bind)
  -- function num : 0_2 , upvalues : _ENV, cs_GameObject, rotae
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
  ;
  ((self.__parentGo).transform):Rotate(rotae)
  if self.__prefab ~= nil then
    self.monsterGo = (self.__prefab):Instantiate((self.__parentGo).transform)
    self:WCntitySetRotate((self.entityData):GetEntityRandonRotate())
    self.animator = (self.monsterGo):FindComponent(eUnityComponentID.Animator)
    ;
    (self.animator):SetBool("IsBattle", true)
    do
      if creatLogicPos ~= nil then
        local pos = (Vector3.New)(creatLogicPos.x, 0, creatLogicPos.y)
        self:WCEntitySetPos(pos)
      end
      local haveOutLine, colorCfg, hdr, wider, scale = (self.entityData):GetMonsterMatConfig()
      if haveOutLine then
        local mat = ((self.monsterGo):GetComponentInChildren(typeof((CS.UnityEngine).SkinnedMeshRenderer))).material
        local color = (Color.New)(colorCfg[1], colorCfg[2], colorCfg[3])
        color = color * (hdr / 100)
        mat:SetColor("_OutlineColor", color)
        mat:SetFloat("_OutlineWidth", wider / 100)
        mat:SetFloat("_OutlineScale", scale / 1000)
      end
      do
        self.__prefab = nil
        self.__realLoadModel = nil
      end
    end
  end
end

WCMonsterEntity.GetWCEntityMoverOverCallback = function(self, moveOverCallback)
  -- function num : 0_3
  self.moveOverCallback = moveOverCallback
end

WCMonsterEntity.WCEntitySetPos = function(self, pos, playAnim, oldLogicPos, logicPos)
  -- function num : 0_4 , upvalues : _ENV, WarChessHelper, TEAM_MOVE_SPEED_PER_SECOND, ROTATE_COST_TIME, eWarChessEnum
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R5 in 'UnsetPending'

  if not playAnim then
    ((self.__parentGo).transform).position = pos
    if self.moveOverCallback ~= nil then
      (self.moveOverCallback)()
      self.moveOverCallback = nil
    end
  else
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    do
      local startGrid = (wcCtrl.mapCtrl):GetGridDataByLogicPos(nil, oldLogicPos)
      local gridData = (wcCtrl.mapCtrl):GetGridDataByLogicPos(nil, logicPos)
      local isOK, pathList = (WarChessHelper.AStrarPathFind)(wcCtrl.mapCtrl, startGrid, gridData, true, self.entityData)
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R10 in 'UnsetPending'

      if not isOK then
        ((self.__parentGo).transform).position = pos
        if self.moveOverCallback ~= nil then
          (self.moveOverCallback)()
          self.moveOverCallback = nil
        end
        return 
      end
      ;
      (self.animator):SetBool("BattleRun", true)
      local index = #pathList
      local targetRotate = nil
      local rotatePassedTime = 0
      local needCalRotate = true
      local MoveEntity_Update = function()
    -- function num : 0_4_0 , upvalues : _ENV, TEAM_MOVE_SPEED_PER_SECOND, pathList, index, self, WarChessHelper, needCalRotate, targetRotate, rotatePassedTime, ROTATE_COST_TIME, wcCtrl
    local deltaTime = Time.deltaTime
    local maxMoveDis = TEAM_MOVE_SPEED_PER_SECOND * deltaTime
    local targeGrid = pathList[index]
    local targeShowPos = targeGrid:GetGridShowPos()
    local entityCurPos = self:WCEntityGetShowPos()
    local pos = (WarChessHelper.Vector3MoveToward)(entityCurPos, targeShowPos, maxMoveDis)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.__parentGo).transform).position = pos
    if needCalRotate then
      local moveToward = (Vector3.Normalize)(targeShowPos - entityCurPos)
      if self:WCEntityGetForward() ~= moveToward then
        local mag = moveToward:Magnitude()
        do
          do
            do
              if mag > 0 then
                local newRotate = (Quaternion.LookRotation)(moveToward, Vector3.up)
                targetRotate = newRotate
              end
              rotatePassedTime = 0
              needCalRotate = false
              if targetRotate ~= nil then
                rotatePassedTime = rotatePassedTime + deltaTime
                local rate = rotatePassedTime / ROTATE_COST_TIME
                local curRotate = self:WCEntityGetRotate()
                local rotate = (Quaternion.Slerp)(curRotate, targetRotate, rate)
                self:WCntitySetRotate(rotate)
                if rate >= 1 then
                  targetRotate = nil
                end
              end
              do
                MsgCenter:Broadcast(eMsgEventId.WC_EntityInfoUpdate, self.entityData)
                if pos == targeShowPos then
                  index = index - 1
                  needCalRotate = true
                end
                if index == 0 then
                  (wcCtrl.wcCamCtrl):WcCamCustomFollow(nil)
                  ;
                  (self.animator):SetBool("BattleRun", false)
                  if self.moveOverCallback ~= nil then
                    (self.moveOverCallback)()
                    self.moveOverCallback = nil
                  end
                  return true
                end
                return false
              end
            end
          end
        end
      end
    end
  end

      if wcCtrl.state == (eWarChessEnum.eWarChessState).play then
        local entityId = (self.entityData):GetEntityUnitId()
        ;
        (wcCtrl.curState):WCAddMonsterMove(entityId, MoveEntity_Update)
      end
    end
  end
end

WCMonsterEntity.WCEntityGetParentGO = function(self)
  -- function num : 0_5
  return self.__parentGo
end

WCMonsterEntity.WCEntityGetShowPos = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if IsNull(self.__parentGo) then
    error("enity not load or not exist")
    return nil
  end
  return ((self.__parentGo).transform).position
end

WCMonsterEntity.WCEntityGetForward = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local forward = ((self.__parentGo).transform).forward
  return (Vector3.New)(forward.x, forward.y, forward.z)
end

WCMonsterEntity.WCEntityGetRotate = function(self)
  -- function num : 0_8
  return ((self.__parentGo).transform).localRotation
end

WCMonsterEntity.WCntitySetRotate = function(self, rotate)
  -- function num : 0_9
  if rotate == nil then
    return 
  end
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.__parentGo).transform).localRotation = rotate
end

WCMonsterEntity.PlayWCMonsterAnimation = function(self, animaId, trigger, callback)
  -- function num : 0_10 , upvalues : _ENV
  if animaId == -1 and not IsNull(self.monsterGo) then
    (self.animator):SetTrigger("BattleDie")
    ;
    (((((self.monsterGo).transform):DOLocalMoveY(-1, 1)):SetDelay(0.5)):OnComplete(function()
    -- function num : 0_10_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    self:Delete()
  end
)):SetLink(self.monsterGo)
  end
end

WCMonsterEntity.PlayAttackAnimation = function(self, targetPos, playSpeedRate)
  -- function num : 0_11
  (((self.monsterGo).transform):DOLookAt(targetPos, 0.1)):SetLink(self.monsterGo)
  self.__oldSpeed = (self.animator).speed
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.animator).speed = playSpeedRate
  ;
  (self.animator):CrossFadeInFixedTime("battle_skill_attack1", 0.1)
end

WCMonsterEntity.EndPlayAttackAnimation = function(self)
  -- function num : 0_12
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  (self.animator).speed = self.__oldSpeed
end

WCMonsterEntity.GetGameObject = function(self)
  -- function num : 0_13
  return self.monsterGo
end

WCMonsterEntity.Show = function(self)
  -- function num : 0_14
  (self.__parentGo):SetActive(true)
end

WCMonsterEntity.Hide = function(self)
  -- function num : 0_15
  (self.__parentGo):SetActive(false)
end

WCMonsterEntity.EntityOnSceneUnload = function(self)
  -- function num : 0_16
end

WCMonsterEntity.Delete = function(self)
  -- function num : 0_17 , upvalues : _ENV
  self:EntityOnSceneUnload()
  DestroyUnityObject(self.__parentGo)
  self.__parentGo = nil
  self.monsterGo = nil
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return WCMonsterEntity

