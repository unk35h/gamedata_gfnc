-- params : ...
-- function num : 0 , upvalues : _ENV
local WCHeroEntity = class("WCHeroEntity")
local util = require("XLua.Common.xlua_util")
local cs_ResLoader = CS.ResLoader
local cs_GameObject = (CS.UnityEngine).GameObject
local Ghost_Color = (Color.New)(0.18, 0.91, 0.93)
local Not_Ghost_Color = (Color.New)(0.5471, 0.5471, 0.5471)
WCHeroEntity.ctor = function(self, heroData, teamIndex)
  -- function num : 0_0
  self.__parentGo = nil
  self.animator = nil
  self.heroData = heroData
  self.heroId = heroData.dataId
  self.teamIndex = teamIndex
  self.resloader = nil
  self.heroGo = nil
  self.__isGhost = false
  self.couldSelectFxGo = nil
end

WCHeroEntity.CheckFirstHeroModel = function(self, heroData, notWait, heroEntityRoot)
  -- function num : 0_1 , upvalues : _ENV
  if heroData == nil or (self.heroData):GetResModelName() == heroData:GetResModelName() then
    return 
  end
  self.heroData = heroData
  self.heroId = heroData.dataId
  local showPos = self:WCHeroEntityGetShowPos()
  return self:WCLoadHeroModel((Vector2.New)(showPos.x, showPos.z), notWait, heroEntityRoot)
end

WCHeroEntity.WCLoadHeroModel = function(self, creatLogicPos, notWait, heroEntityRoot, teamData)
  -- function num : 0_2 , upvalues : _ENV, cs_ResLoader, cs_GameObject
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.heroGo ~= nil then
    DestroyUnityObject(self.heroGo)
    self.heroGo = nil
  end
  self.resloader = (cs_ResLoader.Create)()
  if creatLogicPos ~= nil then
    self.__creatLogicPos = creatLogicPos
  end
  if not IsNull(self.__parentGo) then
    DestroyUnityObject(self.__parentGo)
    self.__parentGo = nil
  end
  local go = cs_GameObject("Team:" .. tostring(self.teamIndex))
  self.__parentGo = go
  do
    if self.__creatLogicPos ~= nil then
      local pos = (Vector3.New)((self.__creatLogicPos).x, 0, (self.__creatLogicPos).y)
      self:WCHeroEntitySetPos(pos)
    end
    local modelPath = PathConsts:GetCharacterModelPathEx((self.heroData):GetResModelName())
    local animatorCtrlPath = PathConsts:GetWarChessCharCtrlPath((self.heroData):GetResModelName())
    local heroAwait = (self.resloader):LoadABAssetAsyncAwait(modelPath, function(heroPrefab)
    -- function num : 0_2_0 , upvalues : self, notWait, heroEntityRoot, teamData
    self.__heroPrefab = heroPrefab
    if notWait and self.__animatorCtrl ~= nil then
      self:RealLoadModel(heroEntityRoot, teamData)
      return 
    end
  end
)
    local animatorAwait = (self.resloader):LoadABAssetAsyncAwait(animatorCtrlPath, function(animatorCtrl)
    -- function num : 0_2_1 , upvalues : self, notWait, heroEntityRoot, teamData
    self.__animatorCtrl = animatorCtrl
    if notWait and self.__heroPrefab ~= nil then
      self:RealLoadModel(heroEntityRoot, teamData)
      return 
    end
  end
)
    return {heroAwait, animatorAwait}, BindCallback(self, self.RealLoadModel, heroEntityRoot, teamData)
  end
end

WCHeroEntity.RealLoadModel = function(self, heroEntityRoot, teamData)
  -- function num : 0_3 , upvalues : _ENV, cs_GameObject
  if IsNull(self.__parentGo) then
    self.__parentGo = cs_GameObject("Team:" .. tostring(self.teamIndex))
  end
  ;
  ((self.__parentGo).transform):SetParent(heroEntityRoot)
  do
    if self.__creatLogicPos ~= nil then
      local pos = (Vector3.New)((self.__creatLogicPos).x, 0, (self.__creatLogicPos).y)
      self:WCHeroEntitySetPos(pos)
    end
    if self.__heroPrefab ~= nil then
      self.heroGo = (self.__heroPrefab):Instantiate((self.__parentGo).transform)
      self.animator = (self.heroGo):FindComponent(eUnityComponentID.Animator)
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.animator).runtimeAnimatorController = self.__animatorCtrl
    end
    self.__heroPrefab = nil
    self.__animatorCtrl = nil
    if teamData ~= nil then
      local isGhost = teamData:GetWCTeamIsGhost()
      self:SetWCHeroIsGhost(isGhost, true)
    else
      do
        self:SetWCHeroIsGhost(self.__isGhost, true)
      end
    end
  end
end

WCHeroEntity.GetWCHeroEntityGo = function(self)
  -- function num : 0_4
  return self.__parentGo
end

WCHeroEntity.GetWCHeroEntityTeamIndex = function(self)
  -- function num : 0_5
  return self.teamIndex
end

WCHeroEntity.WCHeroEntityGetShowPos = function(self)
  -- function num : 0_6
  return ((self.__parentGo).transform).position
end

WCHeroEntity.WCHeroEntitySetPos = function(self, pos)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.__parentGo).transform).position = pos
end

WCHeroEntity.WCHeroEntityGetForward = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local forward = ((self.__parentGo).transform).forward
  return (Vector3.New)(forward.x, forward.y, forward.z)
end

WCHeroEntity.WCHeroEntityGetRotate = function(self)
  -- function num : 0_9
  return ((self.__parentGo).transform).localRotation
end

WCHeroEntity.WCHeroEntitySetRotate = function(self, rotate)
  -- function num : 0_10
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.__parentGo).transform).localRotation = rotate
end

WCHeroEntity.WCAnimatorCrossFade = function(self, aniName, transTime)
  -- function num : 0_11
  if not transTime then
    transTime = 0.25
  end
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):CrossFadeInFixedTime(aniName, transTime)
end

WCHeroEntity.WCAnimatorSetTrigger = function(self, trigger)
  -- function num : 0_12
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):SetTrigger(trigger)
end

WCHeroEntity.WCAnimatorSetBool = function(self, boolName, value)
  -- function num : 0_13
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):SetBool(boolName, value)
end

WCHeroEntity.WCAnimatorSetFloat = function(self, floatName, value)
  -- function num : 0_14
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):SetFloat(floatName, value)
end

WCHeroEntity.WCAnimatorSetPickFloat = function(self, bool)
  -- function num : 0_15
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):SetBool("WarChess_Float", bool)
end

WCHeroEntity.WCAnimatorSetWalk = function(self, bool)
  -- function num : 0_16
  if self.animator == nil then
    return 
  end
  ;
  (self.animator):SetBool("WarChess_Walk", bool)
end

WCHeroEntity.SetWCHeroIsGhost = function(self, bool, isForce)
  -- function num : 0_17 , upvalues : _ENV, Ghost_Color, Not_Ghost_Color
  if bool == self.__isGhost and not isForce then
    return 
  end
  self.__isGhost = bool
  if bool then
    local mats = (self.__parentGo):GetComponentsInChildren(typeof((CS.UnityEngine).SkinnedMeshRenderer))
    for i = 0, mats.Length - 1 do
      local matArray = (mats[i]).materials
      for j = 0, matArray.Length - 1 do
        local mat = matArray[j]
        mat:SetColor("_Color", Ghost_Color)
        mat:SetFloat("_MainTexInvisible", 0.6)
      end
    end
  else
    do
      local mats = (self.__parentGo):GetComponentsInChildren(typeof((CS.UnityEngine).SkinnedMeshRenderer))
      for i = 0, mats.Length - 1 do
        local matArray = (mats[i]).materials
        for j = 0, matArray.Length - 1 do
          local mat = matArray[j]
          mat:SetColor("_Color", Not_Ghost_Color)
          mat:SetFloat("_MainTexInvisible", 0)
        end
      end
    end
  end
end

WCHeroEntity.GetWCHeroParentGo = function(self)
  -- function num : 0_18
  return self.__parentGo
end

WCHeroEntity.Show = function(self)
  -- function num : 0_19
  (self.__parentGo):SetActive(true)
end

WCHeroEntity.Hide = function(self)
  -- function num : 0_20
  (self.__parentGo):SetActive(false)
end

WCHeroEntity.Delete = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.__parentGo ~= nil then
    DestroyUnityObject(self.__parentGo)
    self.__parentGo = nil
  end
end

return WCHeroEntity

