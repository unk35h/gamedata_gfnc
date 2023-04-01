-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Formation.Ctrl.FormationCtrlBase")
local FormationSceneCtrl = class("FormationSceneCtrl", base)
local UIN3DFormation = require("Game.Formation.UI.3DFormation.UIN3DFormation")
local FmtPlatformEntity = require("Game.Formation.Entity.FmtPlatformEntity")
local FmtHeroEntity = require("Game.Formation.Entity.FmtHeroEntity")
local FmtEnum = require("Game.Formation.FmtEnum")
local util = require("XLua.Common.xlua_util")
local FormationUtil = require("Game.Formation.FormationUtil")
local ExclusiveWeaponEffectUtil = require("Game.ExclusiveWeaponEffect.ExclusiveWeaponEffectUtil")
local FixedFmtHeroData = require("Game.PlayerData.Hero.FixedFmtHeroData")
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_Physics = CS.PhysicsUtility
local CS_InputUtility = CS.InputUtility
local CS_AnimationEffectController_Ins = (CS.AnimationEffectController).Instance
local FmtGroundCollider = "FmtGroundCollider"
local FmtWallCollider = "FmtWallCollider"
local FmtPlatformPreName = "BasePlatform"
local DragPosOffset = (Vector3.New)(0, 0.3, -0.3)
local IsPlatformUnlock = function(fmtIndex, enterFmtData)
  -- function num : 0_0 , upvalues : FormationUtil
  local banPlatform = false
  local isBench = enterFmtData:GetFormationMaxStageNum() < fmtIndex
  local unlcok = true
  if isBench then
    if enterFmtData:IsFmtInBattleDeploy() then
      unlcok = false
    else
      unlcok = (FormationUtil.CheckFmtBenchUnlock)(fmtIndex)
    end
  end
  if enterFmtData:IsFmtCtrlFiexd() and not enterFmtData:HasFmtFixedHeroIndex(fmtIndex) then
    banPlatform = true
  end
  if enterFmtData:IsFmtPlatformBan(fmtIndex) then
    banPlatform = true
  end
  if unlcok then
    do return not banPlatform end
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

FormationSceneCtrl.ctor = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.__OnClickPlatform = BindCallback(self, self.OnClickPlatform)
  self.__OnBeginDrag = BindCallback(self, self.OnBeginDrag)
  self.__OnDrag = BindCallback(self, self.OnDrag)
  self.__OnEndDrag = BindCallback(self, self.OnEndDrag)
end

FormationSceneCtrl.InitFmtSceneCtrl = function(self, go, enterFmtData)
  -- function num : 0_2 , upvalues : _ENV, UIN3DFormation, IsPlatformUnlock, FmtPlatformEntity
  self.gameObject = go
  self.enterFmtData = enterFmtData
  self.transform = go.transform
  self.bind = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.bind)
  local screenWidth = ((CS.UnityEngine).Screen).width
  self.__screenWidthRange = (Vector2.New)((self.bind).screenWidthOffset, screenWidth - (self.bind).screenWidthOffset)
  local halfScreenHeight = ((CS.UnityEngine).Screen).height / 2
  self.__screenHeightRange = (Vector2.New)(halfScreenHeight * ((self.bind).screenHeightOffset).x, halfScreenHeight * ((self.bind).screenHeightOffset).y)
  self.ui3dFmt = (UIN3DFormation.New)(self.fmtCtrl, self.enterFmtData)
  ;
  (self.ui3dFmt):Init((self.bind).uI_3DFormation)
  ;
  (self.ui3dFmt):Init3DFormation()
  ;
  ((self.bind).platformSelectEffect):SetActive(false)
  self.platformEntityDic = {}
  self.platformEntityGoDic = {}
  local fmtIndex = 0
  for idx,go in ipairs((self.bind).platform) do
    if not (self.enterFmtData):IsFormationIndexEnable(idx) then
      go:SetActive(false)
    else
      local banPlatform = false
      fmtIndex = fmtIndex + 1
      local isBench = (self.enterFmtData):GetFormationMaxStageNum() < fmtIndex
      local isUnlock = IsPlatformUnlock(fmtIndex, self.enterFmtData)
      local entity = (FmtPlatformEntity.New)()
      entity:InitFmtPlatEntity(go, fmtIndex, self, self.__OnClickPlatform, isBench, isUnlock)
      entity:SetFmtPlatformDragEvent(self.__OnBeginDrag, self.__OnDrag, self.__OnEndDrag)
      -- DECOMPILER ERROR at PC108: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (self.platformEntityDic)[fmtIndex] = entity
      -- DECOMPILER ERROR at PC110: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (self.platformEntityGoDic)[go] = entity
      if self.__platformPosY == nil then
        self.__platformPosY = ((go.transform).position).y
        self.__platformPosZ = ((go.transform).position).z
      end
    end
  end
  self.heroEntityIdDic = {}
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

FormationSceneCtrl.Get3DUIFormation = function(self)
  -- function num : 0_3
  return self.ui3dFmt
end

FormationSceneCtrl.GetFmtPlatEntityByIndex = function(self, index)
  -- function num : 0_4
  if self.platformEntityDic == nil then
    return nil
  end
  return (self.platformEntityDic)[index]
end

FormationSceneCtrl.RefreshFmtScene = function(self, forceAnim)
  -- function num : 0_5 , upvalues : _ENV
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local newHeroEntityIdDic = {}
  for index,heroId in pairs(formationData:GetFormationHeroDic()) do
    local heroEntity = (self.heroEntityIdDic)[heroId]
    if heroEntity ~= nil then
      local heroData = formationData:GetFormationHeroData(index)
      if heroData == heroEntity.heroData then
        heroEntity:UpdateFmtHeroEntityHeadInfo()
        newHeroEntityIdDic[heroId] = heroEntity
        -- DECOMPILER ERROR at PC23: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (self.heroEntityIdDic)[heroId] = nil
      end
    end
  end
  for k,heroEntity in pairs(self.heroEntityIdDic) do
    heroEntity:OnDelete()
  end
  self.heroEntityIdDic = newHeroEntityIdDic
  self.__loadHeroCo = nil
  self.heroEntityDic = {}
  for index,heroId in pairs(formationData:GetFormationHeroDic()) do
    local heroData = formationData:GetFormationHeroData(index)
    if heroData ~= nil then
      local platformEntity = (self.platformEntityDic)[index]
      platformEntity:ShowFmtPlatform(true)
      local heroEntity = self:__CreateHeroEntity(heroData, (platformEntity.transform).position, forceAnim)
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self.heroEntityDic)[index] = heroEntity
    end
  end
  ;
  (self.ui3dFmt):Refresh3DFmt()
end

FormationSceneCtrl.RefreshFmtPlatformIsBanned = function(self)
  -- function num : 0_6 , upvalues : _ENV, IsPlatformUnlock
  local bannedPlatformChanged = false
  for fmtIndex,entity in pairs(self.platformEntityDic) do
    local isUnlock = IsPlatformUnlock(fmtIndex, self.enterFmtData)
    if entity.unlock ~= isUnlock then
      entity.unlock = isUnlock
      bannedPlatformChanged = true
    end
  end
  if bannedPlatformChanged then
    for fmtIndex,platin in pairs((self.ui3dFmt):GetPlotformItemDic()) do
      local isUnlock = IsPlatformUnlock(fmtIndex, self.enterFmtData)
      platin.isBan = not isUnlock
    end
  end
end

FormationSceneCtrl.ClearFmtInEditorModel = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if not (self.fmtCtrl):IsFmtCtrlInEditState() then
    return 
  end
  for idx,heroEntity in pairs(self.heroEntityDic) do
    if not (heroEntity.heroData).isFixedFmtHero then
      heroEntity:OnDelete()
      -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.heroEntityIdDic)[(heroEntity.heroData).dataId] = nil
      -- DECOMPILER ERROR at PC21: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.heroEntityDic)[idx] = nil
    end
  end
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  formationData:CleanFormation()
  ;
  (self.ui3dFmt):Refresh3DFmt(formationData)
end

FormationSceneCtrl.__CreateHeroEntity = function(self, heroData, position, forceAnim)
  -- function num : 0_8 , upvalues : CS_GameObject, _ENV, FmtHeroEntity, util
  local heroEntity = (self.heroEntityIdDic)[heroData.dataId]
  local coFunc = nil
  if heroEntity == nil then
    local go = CS_GameObject(tostring(heroData.dataId))
    ;
    (go.transform):SetParent((self.bind).characters)
    heroEntity = (FmtHeroEntity.New)(self.fmtCtrl, self.enterFmtData)
    coFunc = heroEntity:InitFmtHeroEntity(go, heroData, (self.bind).camera)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.heroEntityIdDic)[heroData.dataId] = heroEntity
  else
    do
      if forceAnim then
        (heroEntity.gameObject):SetActive(false)
        coFunc = function()
    -- function num : 0_8_0 , upvalues : _ENV, heroEntity
    if not IsNull(heroEntity.gameObject) then
      (heroEntity.gameObject):SetActive(true)
      return heroEntity
    end
  end

      end
      heroEntity:SetFmtHeroEntityPos(position)
      if self.__loadHeroCoFuncList == nil then
        self.__loadHeroCoFuncList = {}
      end
      ;
      (table.insert)(self.__loadHeroCoFuncList, coFunc)
      do
        if self.__loadHeroCo == nil then
          local loadHeroListFunc = function()
    -- function num : 0_8_1 , upvalues : _ENV, self
    (coroutine.yield)(nil)
    while #self.__loadHeroCoFuncList > 0 do
      local coFunc = (table.remove)(self.__loadHeroCoFuncList, 1)
      local loadHeroEntity = coFunc()
      ;
      (coroutine.yield)(nil)
      if loadHeroEntity ~= nil then
        self:PlayExclusiveWeaponEffect(loadHeroEntity.heroData, loadHeroEntity.heroGo)
      end
    end
    do
      self.__loadHeroCo = nil
    end
  end

          self.__loadHeroCo = (GR.StartCoroutine)((util.cs_generator)(loadHeroListFunc))
        end
        return heroEntity
      end
    end
  end
end

FormationSceneCtrl.PlayExclusiveWeaponEffect = function(self, heroData, heroObj)
  -- function num : 0_9 , upvalues : ExclusiveWeaponEffectUtil, _ENV
  ExclusiveWeaponEffectUtil:PlayEWEffectByHeroData(heroData, heroObj, (ExclusiveWeaponEffectUtil.EEwEffectType).Formation, LayerMask.Formation)
end

FormationSceneCtrl.GetHeroEntity = function(self, fmtIndex)
  -- function num : 0_10
  return (self.heroEntityDic)[fmtIndex]
end

FormationSceneCtrl.GetFmtPlatformEntityByGo = function(self, gameObject)
  -- function num : 0_11
  return (self.platformEntityGoDic)[gameObject]
end

FormationSceneCtrl.SwapFmtPlatformHero = function(self, fromFmtIndex, toFmtIndex)
  -- function num : 0_12
  local heroDic = self.heroEntityDic
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local newFmtData = formationData.data
  heroDic[fromFmtIndex] = heroDic[toFmtIndex]
  formationData:Exchange2Hero(fromFmtIndex, toFmtIndex)
  ;
  (self.fmtCtrl):ModifyFormation(formationData)
  ;
  (self.fmtCtrl):OnCurrentFmtChanged()
  ;
  (self.ui3dFmt):RefreshFmtPlatformUI(fromFmtIndex)
  ;
  (self.ui3dFmt):RefreshFmtPlatformUI(toFmtIndex)
  ;
  (self.ui3dFmt):RefreshFmtHeroQuickLvUpByFmtIndex(fromFmtIndex)
  ;
  (self.ui3dFmt):RefreshFmtHeroQuickLvUpByFmtIndex(toFmtIndex)
end

FormationSceneCtrl.GuideDisableClickPlat = function(self, active)
  -- function num : 0_13
  self.__inFmtGuide = active
end

FormationSceneCtrl.OnClickPlatform = function(self, fmtIndex)
  -- function num : 0_14 , upvalues : _ENV, FixedFmtHeroData
  if self.__inFmtGuide then
    return 
  end
  if self.__dragPlatform ~= nil then
    return 
  end
  local formationData = ((self.fmtCtrl):GetFmtCtrlFmtData())
  -- DECOMPILER ERROR at PC11: Overwrote pending register: R3 in 'AssignReg'

  local heroData = .end
  local heroEntity = (self.heroEntityDic)[fmtIndex]
  if heroEntity ~= nil then
    heroData = heroEntity:GetFmtHeroEntityData()
  end
  if formationData.isVirtualFormation then
    (self.fmtCtrl):ShowQuickFormation(heroData)
  else
    if heroData ~= nil then
      if heroData.isFriendSupport or IsInstanceOfClass(heroData, FixedFmtHeroData) then
        UIManager:ShowWindowAsync(UIWindowTypeID.SupportHeroState, function(win)
    -- function num : 0_14_0 , upvalues : heroData
    if win == nil then
      return 
    end
    win:InitSupportHeroState(heroData)
  end
)
        return 
      end
      local heroDataList = {}
      for i = 1, (ConfigData.game_config).max_formation_hero do
        local heroEntity = (self.heroEntityDic)[i]
        if heroEntity ~= nil and heroEntity:GetFmtHeroEntityData() ~= nil then
          local heroData = heroEntity:GetFmtHeroEntityData()
          if not heroData.isFriendSupport and not heroData.isFixedFmtHero then
            (table.insert)(heroDataList, heroData)
          end
        end
      end
      ;
      (self.fmtCtrl):ShowHeroState(heroData, heroDataList)
    else
      do
        if not (self.fmtCtrl):IsFmtCtrlInEditState() then
          (self.fmtCtrl):FmtCtrlEnterEditSate()
        end
      end
    end
  end
end

FormationSceneCtrl.OnSkinChange = function(self, heroId, skinId)
  -- function num : 0_15 , upvalues : _ENV, util
  if self.heroEntityIdDic == nil then
    return 
  end
  local heroEntity = (self.heroEntityIdDic)[heroId]
  if heroEntity == nil then
    return 
  end
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if formationData.isVirtualFormation then
    (heroEntity.heroData):UpdateSkin(skinId)
  end
  if heroEntity.modelPath == PathConsts:GetCharacterModelPathEx((heroEntity.heroData):GetResModelName()) then
    return 
  end
  local coFunc = heroEntity:LoadModel()
  if self.__loadHeroCoFuncList == nil then
    self.__loadHeroCoFuncList = {}
  end
  ;
  (table.insert)(self.__loadHeroCoFuncList, coFunc)
  if self.__loadHeroCo == nil then
    local loadHeroListFunc = function()
    -- function num : 0_15_0 , upvalues : self, _ENV
    do
      while #self.__loadHeroCoFuncList > 0 do
        local coFunc = (table.remove)(self.__loadHeroCoFuncList, 1)
        coFunc()
        ;
        (coroutine.yield)(nil)
      end
      self.__loadHeroCo = nil
    end
  end

    self.__loadHeroCo = (GR.StartCoroutine)((util.cs_generator)(loadHeroListFunc))
  end
end

FormationSceneCtrl.OnBeginDrag = function(self, platformItem, eventData)
  -- function num : 0_16 , upvalues : _ENV, CS_AnimationEffectController_Ins
  if GuideManager.inGuide then
    return 
  end
  if self.__dragPlatform ~= nil then
    return 
  end
  if not platformItem:IsFmtPlatformUnlock() then
    return 
  end
  local heroEntity = self:GetHeroEntity(platformItem:GetFmtIndex())
  if heroEntity == nil then
    return 
  end
  if (heroEntity.heroData).isFixedFmtHero then
    return 
  end
  self.__dragHero = heroEntity
  ;
  (self.__dragHero):FmtHeroOnDrag(true)
  platformItem:EnableFmtPlatformRaycast(false)
  self.__dragPlatform = platformItem
  AudioManager:PlayAudioById(1018)
  CS_AnimationEffectController_Ins:KillRoleEffect((self.__dragHero).heroGo)
  CS_AnimationEffectController_Ins:RecycleRoleEffect((self.__dragHero).heroGo)
end

FormationSceneCtrl.OnDrag = function(self, platformItem, eventData)
  -- function num : 0_17 , upvalues : DragPosOffset
  if self.__dragPlatform == nil or self.__dragPlatform ~= platformItem then
    return 
  end
  local targetPlatIsFixedHero = false
  local newPos = self:__GetGroundPoint()
  newPos = newPos + DragPosOffset
  ;
  (self.__dragHero):SetFmtHeroEntityPos(newPos)
  local targetPlatform = self:__GetTargetPlatform(newPos)
  -- DECOMPILER ERROR at PC29: Unhandled construct in 'MakeBoolean' P1

  if targetPlatform == nil and self.__swappedHero ~= nil then
    (self.__swappedHero):DragHeroEndTweenHeroDetailItem(((self.__swappedPlatform).transform).position)
    self.__swappedHero = nil
    self.__swappedPlatform = nil
  end
  if targetPlatform ~= platformItem and targetPlatform ~= self.__swappedPlatform then
    if self.__swappedHero ~= nil then
      (self.__swappedHero):DragHeroEndTweenHeroDetailItem(((self.__swappedPlatform).transform).position)
      self.__swappedHero = nil
      self.__swappedPlatform = nil
    end
    if targetPlatform:IsFmtPlatformUnlock() then
      local targetFmtIndex = targetPlatform:GetFmtIndex()
      local heroEntity = self:GetHeroEntity(targetPlatform:GetFmtIndex())
      targetPlatIsFixedHero = self:_PlatformIsFixedHero(targetPlatform)
      if heroEntity ~= nil and not targetPlatIsFixedHero then
        heroEntity:DragHeroEndTweenHeroDetailItem((platformItem.transform).position)
        self.__swappedPlatform = targetPlatform
        self.__swappedHero = heroEntity
      end
    end
  end
  do
    if self:PullFormationDrag(eventData.position) then
      self:RecoverHeroPutPlatform()
    else
      local lightPlat = targetPlatform ~= nil and targetPlatform:IsFmtPlatformUnlock() and not targetPlatIsFixedHero and targetPlatform or platformItem
      if lightPlat ~= nil then
        ((self.bind).platformSelectEffect):SetActive(true)
        -- DECOMPILER ERROR at PC105: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (((self.bind).platformSelectEffect).transform).localPosition = ((lightPlat.gameObject).transform).localPosition
      else
        ;
        ((self.bind).platformSelectEffect):SetActive(false)
      end
      self._lastSeekHeroPlat = lightPlat
    end
  end
end

FormationSceneCtrl.OnEndDrag = function(self, platformItem, eventData)
  -- function num : 0_18 , upvalues : _ENV
  self:RecoverHeroPutPlatform()
  if self.__dragPlatform == nil or self.__dragPlatform ~= platformItem then
    return 
  end
  local targetPlatform = self:__GetTargetPlatform(((self.__dragHero).transform).position)
  local targetPlatIsFixedHero = self:_PlatformIsFixedHero(targetPlatform)
  -- DECOMPILER ERROR at PC36: Unhandled construct in 'MakeBoolean' P3

  if (self:PullFormationEnd(eventData.position, self.__dragHero) and targetPlatform == nil) or targetPlatIsFixedHero then
    (self.__dragHero):DragHeroEndTweenHeroDetailItem((platformItem.transform).position)
  else
    if targetPlatform ~= platformItem then
      local targetFmtIndex = targetPlatform:GetFmtIndex()
      local heroEntity = self:GetHeroEntity(targetPlatform:GetFmtIndex())
      if heroEntity ~= nil and not (heroEntity.heroData).isFixedFmtHero then
        heroEntity:DragHeroEndTweenHeroDetailItem((platformItem.transform).position)
        ;
        (self.__dragHero):DragHeroEndTweenHeroDetailItem((targetPlatform.transform).position)
        self:SwapFmtPlatformHero(platformItem:GetFmtIndex(), targetFmtIndex)
        ;
        (self.ui3dFmt):RefreshRefresh3DFmtFightPower()
      end
    end
  end
  do
    local needExEffect = true
    if needExEffect then
      self:PlayExclusiveWeaponEffect((self.__dragHero).heroData, (self.__dragHero).heroGo)
    end
    ;
    (self.__dragHero):FmtHeroOnDrag(false)
    self.__dragHero = nil
    self.__swappedPlatform = nil
    self.__swappedHero = nil
    self.__dragPlatform = nil
    platformItem:EnableFmtPlatformRaycast(true)
    AudioManager:PlayAudioById(1019)
  end
end

FormationSceneCtrl.__GetGroundPoint = function(self)
  -- function num : 0_19 , upvalues : CS_InputUtility, _ENV
  local mousePos = CS_InputUtility.MousePosition
  mousePos.x = (math.clamp)(mousePos.x, (self.__screenWidthRange).x, (self.__screenWidthRange).y)
  mousePos.y = (math.clamp)(mousePos.y, (self.__screenHeightRange).x, (self.__screenHeightRange).y)
  self:__RaycastGround(mousePos, (self.fmtCtrl):IsFmtCtrlInEditState())
  if (self.fmtCtrl):IsFmtCtrlInEditState() and (self.__lastGroundPos).y < self.__platformPosY then
    local ratio = ((self.__lastGroundPos).x - ((((self.bind).camera).transform).position).x) / ((self.__lastGroundPos).y - ((((self.bind).camera).transform).position).y)
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__lastGroundPos).y = self.__platformPosY
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__lastGroundPos).x = ratio * ((self.__lastGroundPos).y - ((((self.bind).camera).transform).position).y) + ((((self.bind).camera).transform).position).x
  else
    do
      -- DECOMPILER ERROR at PC75: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.__lastGroundPos).y = self.__platformPosY
      -- DECOMPILER ERROR at PC83: Confused about usage of register: R2 in 'UnsetPending'

      if self.__platformPosZ < (self.__lastGroundPos).z then
        (self.__lastGroundPos).z = self.__platformPosZ
      end
      return self.__lastGroundPos
    end
  end
end

FormationSceneCtrl.__RaycastGround = function(self, mousePos, isUseWallCollider)
  -- function num : 0_20 , upvalues : CS_Physics, _ENV, FmtGroundCollider, FmtWallCollider
  local fixZ = nil
  local hits = (CS_Physics.Raycast)((self.bind).camera, 1 << LayerMask.Raycast, true, mousePos)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) then
      if hitCollider.name == FmtGroundCollider then
        if not isUseWallCollider then
          self.__lastGroundPos = (hits[i]).point
          break
        else
          fixZ = ((hits[i]).point).z
        end
      end
      if hitCollider.name == FmtWallCollider and isUseWallCollider then
        self.__lastGroundPos = (hits[i]).point
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

    if fixZ ~= nil then
      (self.__lastGroundPos).z = fixZ
    end
  end
end

FormationSceneCtrl.__GetTargetPlatform = function(self, originPos)
  -- function num : 0_21 , upvalues : CS_Physics, _ENV
  local targetGo = nil
  originPos.y = originPos.y + 5
  local hits = (CS_Physics.Raycast)(originPos, Vector3.down, 1 << LayerMask.Formation)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) then
      targetGo = hitCollider.gameObject
      break
    end
  end
  do
    local targetPlatform = nil
    if not IsNull(targetGo) then
      targetPlatform = self:GetFmtPlatformEntityByGo(targetGo)
    end
    return targetPlatform
  end
end

FormationSceneCtrl._PlatformIsFixedHero = function(self, targetPlatform)
  -- function num : 0_22
  local heroEntity = targetPlatform ~= nil and self:GetHeroEntity(targetPlatform:GetFmtIndex()) or nil
  local targetPlatIsFixedHero = (heroEntity ~= nil and (heroEntity.heroData).isFixedFmtHero)
  do return targetPlatIsFixedHero end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

FormationSceneCtrl.SeekHeroPutPlatform = function(self)
  -- function num : 0_23 , upvalues : DragPosOffset, _ENV
  local newPos = self:__GetGroundPoint()
  newPos = newPos + DragPosOffset
  local targetPlatform = self:__GetTargetPlatform(newPos)
  local dragCardHeroData = (self.fmtCtrl):GetOnDragCardHeroData()
  for fmtIndex,_ in ipairs((self.bind).platform) do
    if (self.heroEntityDic)[fmtIndex] ~= nil and (((self.heroEntityDic)[fmtIndex]):GetFmtHeroEntityData()).dataId == dragCardHeroData.dataId and ((self.platformEntityDic)[fmtIndex]):IsFmtPlatformUnlock() then
      targetPlatform = (self.platformEntityDic)[fmtIndex]
      break
    end
  end
  do
    if self:_PlatformIsFixedHero(targetPlatform) then
      targetPlatform = nil
    end
    if targetPlatform == nil or not targetPlatform:IsFmtPlatformUnlock() then
      targetPlatform = nil
      for fmtIndex,_ in ipairs((self.bind).platform) do
        if (self.heroEntityDic)[fmtIndex] == nil and (self.platformEntityDic)[fmtIndex] ~= nil and ((self.platformEntityDic)[fmtIndex]):IsFmtPlatformUnlock() then
          targetPlatform = (self.platformEntityDic)[fmtIndex]
          break
        end
      end
    end
    do
      if targetPlatform ~= nil then
        ((self.bind).platformSelectEffect):SetActive(true)
        -- DECOMPILER ERROR at PC88: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (((self.bind).platformSelectEffect).transform).localPosition = ((targetPlatform.gameObject).transform).localPosition
      else
        ;
        ((self.bind).platformSelectEffect):SetActive(false)
      end
      self._lastSeekHeroPlat = targetPlatform
    end
  end
end

FormationSceneCtrl.GetFmtLastSeekHeroPlat = function(self)
  -- function num : 0_24
  return self._lastSeekHeroPlat
end

FormationSceneCtrl.RecoverHeroPutPlatform = function(self)
  -- function num : 0_25
  ((self.bind).platformSelectEffect):SetActive(false)
  self._lastSeekHeroPlat = nil
end

FormationSceneCtrl.ConfirmHeroPutPlatform = function(self, heroData)
  -- function num : 0_26 , upvalues : _ENV
  local targetPlatform = self._lastSeekHeroPlat
  self:RecoverHeroPutPlatform()
  if targetPlatform == nil then
    return false
  end
  local index = nil
  for k,v in pairs(self.platformEntityDic) do
    if v == targetPlatform then
      index = k
      break
    end
  end
  do
    local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
    for formatindex,heroId in pairs(formationData:GetFormationHeroDic()) do
      if heroId == heroData.dataId and formatindex ~= index then
        index = formatindex
        targetPlatform = (self.platformEntityDic)[index]
        break
      end
    end
    do
      if index == nil then
        return false
      end
      local heroEntity = (self.heroEntityDic)[index]
      local beReplaceHeroData = heroEntity ~= nil and heroEntity:GetFmtHeroEntityData() or nil
      if heroData.isFriendSupport then
        local dailyUseLastHero = false
        if (self.enterFmtData):IsFmtInBattleDeploy() then
          dailyUseLastHero = ((self.enterFmtData):GetFmtDungeonDyncData()):HasDgDyncLastAstHero()
        end
        formationData:SetSupportHeroData(heroData, index, dailyUseLastHero)
      else
        do
          if heroData.isOfficialSupport then
            formationData:SetOfficialSupportHeroData(heroData, index)
          else
            formationData:SetHero2Formation(index, heroData.dataId)
          end
          -- DECOMPILER ERROR at PC87: Confused about usage of register: R7 in 'UnsetPending'

          if beReplaceHeroData ~= nil then
            (self.heroEntityIdDic)[beReplaceHeroData.dataId] = nil
            heroEntity:OnDelete()
          end
          targetPlatform:ShowFmtPlatform(true)
          heroEntity = self:__CreateHeroEntity(heroData, (targetPlatform.transform).position, true)
          -- DECOMPILER ERROR at PC101: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.heroEntityDic)[index] = heroEntity
          -- DECOMPILER ERROR at PC104: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.heroEntityIdDic)[heroData.dataId] = heroEntity
          ;
          (self.ui3dFmt):Refresh3DFmt(formationData)
          return true, beReplaceHeroData
        end
      end
    end
  end
end

FormationSceneCtrl.RegisterPullFormationDragAct = function(self, onDragAct, pullFormatonDealAct)
  -- function num : 0_27
  self.__OnpullFormationDrag = onDragAct
  self.__OnpullFormatonDeal = pullFormatonDealAct
end

FormationSceneCtrl.RemovePullFormationDragAct = function(self)
  -- function num : 0_28
  self.__OnpullFormationDrag = nil
  self.__OnpullFormatonDeal = nil
end

FormationSceneCtrl.PullFormationDrag = function(self, touchPos)
  -- function num : 0_29
  if self.__OnpullFormationDrag ~= nil then
    return (self.__OnpullFormationDrag)(touchPos)
  end
  return false
end

FormationSceneCtrl.PullFormationEnd = function(self, touchPos, heroEntity)
  -- function num : 0_30 , upvalues : _ENV
  if heroEntity == nil then
    return false
  end
  if self.__OnpullFormatonDeal == nil or self.__OnpullFormationDrag == nil then
    return false
  end
  local isPull = (self.__OnpullFormationDrag)(touchPos)
  if isPull then
    local index = nil
    for k,v in pairs(self.heroEntityDic) do
      if v == heroEntity then
        index = k
        break
      end
    end
    do
      if index ~= nil then
        local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
        local heroData = heroEntity:GetFmtHeroEntityData()
        formationData:SetHero2Formation(index, nil)
        -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.heroEntityDic)[index] = nil
        -- DECOMPILER ERROR at PC43: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.heroEntityIdDic)[heroData.dataId] = nil
        ;
        (self.ui3dFmt):Refresh3DFmt(formationData)
        heroEntity:OnDelete()
        ;
        (self.__OnpullFormatonDeal)(heroEntity:GetFmtHeroEntityData())
        return true
      end
      do
        ;
        (self.__OnpullFormatonDeal)(nil)
        return false
      end
    end
  end
end

FormationSceneCtrl.SetFormationCameraActive = function(self, active)
  -- function num : 0_31
  ((self.bind).formationCam):SetActive(active)
end

FormationSceneCtrl.PlayTimeLine = function(self, endAction, updateAction)
  -- function num : 0_32 , upvalues : _ENV
  if self._tlCoroutine ~= nil then
    return 
  end
  self._tlCoroutine = (TimelineUtil.Play)((self.bind).timeLine, function()
    -- function num : 0_32_0 , upvalues : _ENV, self, endAction
    (TimelineUtil.StopTlCo)(self._tlCoroutine)
    self._tlCoroutine = nil
    if endAction ~= nil then
      endAction()
    end
  end
, nil, nil, nil, updateAction)
end

FormationSceneCtrl.RewindTimeLine = function(self, endAction, updateAction)
  -- function num : 0_33 , upvalues : _ENV
  if self._tlCoroutine ~= nil then
    return 
  end
  self._tlCoroutine = (TimelineUtil.Rewind)((self.bind).timeLine, function()
    -- function num : 0_33_0 , upvalues : _ENV, self, endAction
    (TimelineUtil.StopTlCo)(self._tlCoroutine)
    self._tlCoroutine = nil
    if endAction ~= nil then
      endAction()
    end
  end
, nil, nil, nil, updateAction)
end

FormationSceneCtrl.RefreshFmtPlatUIAll = function(self)
  -- function num : 0_34
  local fmtRoleCount = (self.enterFmtData):GetFormationRoleMax()
  for fmtIndex = 1, fmtRoleCount do
    (self.ui3dFmt):RefreshFmtPlatformUI(fmtIndex)
  end
  ;
  (self.ui3dFmt):RefreshRefresh3DFmtFightPower()
  ;
  (self.ui3dFmt):ShowFmtHeroQuickLvUp()
end

FormationSceneCtrl.OnUpdateHero = function(self, heroUpdateDic)
  -- function num : 0_35 , upvalues : _ENV
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  for index,heroId in pairs(formationData:GetFormationHeroDic()) do
    if heroUpdateDic[heroId] ~= nil then
      (self.ui3dFmt):RefreshFmtPlatformUI(index)
      local heroEntity = (self.heroEntityIdDic)[heroId]
      heroEntity:UpdateFmtHeroEntityHeadInfo()
    end
  end
  ;
  (self.ui3dFmt):RefreshRefresh3DFmtFightPower()
end

FormationSceneCtrl.ShowHeroQuickLvUpEffect = function(self, fmtIdx)
  -- function num : 0_36
  local platformItem = self:GetFmtPlatEntityByIndex(fmtIdx)
  if platformItem == nil then
    return 
  end
  local effectCommon = nil
  if self.effectQuickLvUpInUseDic == nil or (self.effectQuickLvUpInUseDic)[fmtIdx] == nil then
    effectCommon = self:_GetQuickLvUpEffect(fmtIdx)
  else
    effectCommon = (self.effectQuickLvUpInUseDic)[fmtIdx]
    effectCommon:Stop()
  end
  effectCommon:Play((platformItem.transform).position)
end

FormationSceneCtrl._GetQuickLvUpEffect = function(self, fmtIdx)
  -- function num : 0_37 , upvalues : _ENV
  if not self.effectQuickLvUpPool then
    self.effectQuickLvUpPool = {}
    if not self.effectQuickLvUpInUseDic then
      self.effectQuickLvUpInUseDic = {}
      local effectCommon = nil
      if #self.effectQuickLvUpPool > 0 then
        effectCommon = (table.remove)(self.effectQuickLvUpPool)
      else
        effectCommon = ((self.bind).fXP_QuickLevelUp_sj):Instantiate()
        self._ReturnFmtEffectFunc = BindCallback(self, self._ReturnQuickLvUpEffect)
        effectCommon:InitEffectCommon(self._ReturnFmtEffectFunc, tostring(fmtIdx))
      end
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.effectQuickLvUpInUseDic)[fmtIdx] = effectCommon
      return effectCommon
    end
  end
end

FormationSceneCtrl._ReturnQuickLvUpEffect = function(self, effectCommon)
  -- function num : 0_38 , upvalues : _ENV
  (table.insert)(self.effectQuickLvUpPool, effectCommon)
  local fmtIdx = tonumber(effectCommon:GetEffectName())
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.effectQuickLvUpInUseDic)[fmtIdx] = nil
end

FormationSceneCtrl.RefreshSupportHeroInfo = function(self, fmtIndex)
  -- function num : 0_39
  (self.ui3dFmt):RefreshFmtPlatformUI(fmtIndex)
  local heroEntity = self:GetHeroEntity(fmtIndex)
  heroEntity:UpdateFmtHeroEntityHeadInfo()
end

FormationSceneCtrl.RefreshQuickLevelUpByIndex = function(self, fmtIndex)
  -- function num : 0_40
  (self.ui3dFmt):RefreshFmtHeroQuickLvUpByFmtIndex(fmtIndex)
end

FormationSceneCtrl.RefreshAllQuickLevel = function(self)
  -- function num : 0_41
  (self.ui3dFmt):ShowFmtHeroQuickLvUp()
end

FormationSceneCtrl.SetWarningTipState = function(self, active)
  -- function num : 0_42
  (self.ui3dFmt):SetWarningTipState(active)
end

FormationSceneCtrl.OnDelete = function(self)
  -- function num : 0_43 , upvalues : _ENV
  if self.__loadHeroCo ~= nil then
    (GR.StopCoroutine)(self.__loadHeroCo)
  end
  if self.heroEntityIdDic ~= nil then
    for k,heroEntity in pairs(self.heroEntityIdDic) do
      heroEntity:OnDelete()
    end
  end
  do
    self.heroEntityIdDic = nil
    if self.platformEntityDic ~= nil then
      for k,entity in pairs(self.platformEntityDic) do
        entity:OnDelete()
      end
      self.platformEntityDic = nil
    end
    if self._tlCoroutine ~= nil then
      (TimelineUtil.StopTlCo)(self._tlCoroutine)
      self._tlCoroutine = nil
    end
    DestroyUnityObject(self.gameObject)
  end
end

return FormationSceneCtrl

