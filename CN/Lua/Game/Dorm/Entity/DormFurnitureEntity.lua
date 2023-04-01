-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFurnitureEntity = class("DormFurnitureEntity")
local DormUtil = require("Game.Dorm.DormUtil")
local DormEnum = require("Game.Dorm.DormEnum")
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_ResLoader = CS.ResLoader
local CS_Collider = (CS.UnityEngine).Collider
local EnableTouchAnimatorNameHash = (((CS.UnityEngine).Animator).StringToHash)("EnableTouch")
local DormFntCenterType = {Center = 0, BottomCenter = 1}
DormFurnitureEntity.ctor = function(self)
  -- function num : 0_0
end

DormFurnitureEntity.InitFntEntity = function(self, fntData, holder)
  -- function num : 0_1 , upvalues : CS_GameObject, _ENV
  self.fntData = fntData
  self.type = (self.fntData):GetFntType()
  self._enableTouch = false
  self.rootGo = CS_GameObject(tostring((self.fntData).id))
  self.rootTran = (self.rootGo).transform
  ;
  (self.rootTran):SetParent(holder)
  self:InitFntEntityRoot()
end

DormFurnitureEntity.InitFntEntityRoot = function(self)
  -- function num : 0_2 , upvalues : DormFntCenterType, DormUtil
  local sizeX, sizeY = (self.fntData):GetFntSize()
  if (self.fntData):GetFntCenterCfg() == DormFntCenterType.BottomCenter then
    self._tranformLocalPos = (DormUtil.FntCoord2Unity)(sizeX / 2 - 0.5, sizeY - 0.5, self.type)
    self._tranformLocalCenterPos = (DormUtil.FntCoord2Unity)(sizeX / 2 - 0.5, sizeY / 2 - 0.5, self.type)
  else
    self._tranformLocalPos = (DormUtil.FntCoord2Unity)(sizeX / 2 - 0.5, sizeY / 2 - 0.5, self.type)
    self._tranformLocalCenterPos = self._tranformLocalPos
  end
  self:SetFntEntityPos((self.fntData).x, (self.fntData).y)
  self:__SetRotation()
  self._isLoadedGo = false
end

DormFurnitureEntity._ClearResLoader = function(self)
  -- function num : 0_3
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
end

DormFurnitureEntity.LoadFntEntityGo = function(self, path, callback)
  -- function num : 0_4 , upvalues : CS_ResLoader, _ENV
  self:_ClearResLoader()
  self.resLoader = (CS_ResLoader.Create)()
  self._inLoadingModel = true
  ;
  (UIUtil.AddOneCover)(self)
  ;
  (self.resLoader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_4_0 , upvalues : self, _ENV, callback
    self._inLoadingModel = false
    ;
    (UIUtil.CloseOneCover)(self)
    if IsNull(self.rootGo) or IsNull(prefab) then
      return 
    end
    local go = prefab:Instantiate()
    self:SetFntEntityGo(go)
    if callback ~= nil then
      callback(self)
    end
    self:TryUpdDmFntWallpaperLayer()
  end
)
end

DormFurnitureEntity.IsDmFntEntityInLoading = function(self)
  -- function num : 0_5
  return self._inLoadingModel
end

DormFurnitureEntity.SetFntEntityGo = function(self, obj)
  -- function num : 0_6 , upvalues : _ENV, CS_Collider
  self.gameObject = obj
  self.transform = obj.transform
  ;
  (self.transform):SetParent(self.rootTran, false)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).localPosition = self._tranformLocalPos
  self._colliders = (self.rootTran):GetComponentsInChildren(typeof(CS_Collider))
  self._visibleHolderTransform = (self.transform):Find("VisibleHolder")
  self._isLoadedGo = true
  self:InitFntTouchAnimator()
end

DormFurnitureEntity.EnableDmFntCollider = function(self, enable)
  -- function num : 0_7
  if self._colliders == nil then
    return 
  end
  for i = 0, (self._colliders).Length - 1 do
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

    ((self._colliders)[i]).enabled = enable
  end
end

DormFurnitureEntity.EnableDmFntVisibleHolder = function(self, enable)
  -- function num : 0_8
  if self._visibleHolderTransform == nil then
    return 
  end
  ;
  ((self._visibleHolderTransform).gameObject):SetActive(enable)
end

DormFurnitureEntity.ResetFntEntityByData = function(self, parent)
  -- function num : 0_9 , upvalues : DormEnum
  (self.rootTran):SetParent(parent)
  self:SetFntEntityPos((self.fntData).x, (self.fntData).y)
  self:__SetRotation()
  if self.type == (DormEnum.eDormFntType).Wallpaper then
    self:TryUpdDmFntWallpaperLayer()
  end
end

DormFurnitureEntity.SetFntEntityPos = function(self, x, y, tween)
  -- function num : 0_10 , upvalues : DormUtil
  local unityPos = (DormUtil.FntCoord2Unity)(x, y, self.type)
  ;
  (self.fntData):SetFntPos(x, y)
  ;
  (self.rootTran):DOKill()
  if tween then
    ((self.rootTran):DOLocalMove(unityPos, 0.1)):SetLink(self.rootGo)
  else
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.rootTran).localPosition = unityPos
  end
end

DormFurnitureEntity.GetFntEntityLocalPos = function(self)
  -- function num : 0_11
  return (self.rootTran).localPosition
end

DormFurnitureEntity.GetFntEntityCenterTrasform = function(self)
  -- function num : 0_12 , upvalues : CS_GameObject
  if self.rootCenterTran == nil then
    self.rootCenterGo = CS_GameObject("Center")
    self.rootCenterTran = (self.rootCenterGo).transform
    ;
    (self.rootCenterTran):SetParent(self.rootTran)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.rootCenterTran).localPosition = self._tranformLocalCenterPos
  end
  return self.rootCenterTran
end

DormFurnitureEntity.SetFntEntityPosFromUnity = function(self, unityPos, force)
  -- function num : 0_13 , upvalues : DormUtil, DormEnum
  local newX, newY = (DormUtil.UnityCoord2Fnt)(unityPos, self.type)
  local sizeX, sizeY = (self.fntData):GetFntSize()
  if self.type == (DormEnum.eDormFntType).Door then
    newY = (self.fntData):GetFntDoorY(sizeY)
  end
  local oldX = (self.fntData).x
  local oldY = (self.fntData).y
  local move = newX == oldX and newY == oldY and force
  if move then
    local outX, outY, newX, newY = (DormUtil.FntAreaOutMap)(newX, newY, sizeX, sizeY, (self.fntData).r, self.type, ((self.fntData).roomData).roomCfg)
    if newX == oldX and newY == oldY then
      do
        move = force
        move = move
        if move then
          self:SetFntEntityPos(newX, newY, true)
        end
        do return move, oldX, oldY end
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
end

DormFurnitureEntity.RotateFntEntity = function(self)
  -- function num : 0_14 , upvalues : _ENV
  (self.fntData):RotateFnt()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.rootTran).eulerAngles = (Vector3.New)(0, (self.fntData).r, 0)
  if (self.fntData):CheckOutMap() then
    self:SetFntEntityPos((self.fntData).x, (self.fntData).y, true)
  end
end

DormFurnitureEntity.__SetRotation = function(self)
  -- function num : 0_15 , upvalues : _ENV, DormEnum
  local angle = (Vector3.New)()
  if (DormEnum.IsFntWallType)(self.type) then
    angle.z = (self.fntData).r
  else
    angle.y = (self.fntData).r
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.rootTran).localEulerAngles = angle
end

DormFurnitureEntity.GetFntEntityType = function(self)
  -- function num : 0_16
  return self.type
end

DormFurnitureEntity.GetFntAreaList = function(self, x, y)
  -- function num : 0_17 , upvalues : DormUtil
  if x == nil or y == nil then
    x = (self.fntData).x
    y = (self.fntData).y
  end
  local sizeX, sizeY = (self.fntData):GetFntSize()
  local areaList = (DormUtil.GetFntArea)(x, y, sizeX, sizeY, (self.fntData).r)
  return areaList
end

DormFurnitureEntity.GetFntDoorAreaList = function(self, x, y, wallId)
  -- function num : 0_18 , upvalues : DormUtil
  if x == nil or y == nil then
    x = (self.fntData).x
    y = (self.fntData).y
  end
  if wallId == nil then
    wallId = (self.fntData):GetFntParam()
  end
  x = (DormUtil.GetFntDoorPosByWall)(wallId, x, ((self.fntData).roomData):GetRoomGridLengthCount())
  local sizeX, _, sizeY = (self.fntData):GetFntSize()
  local rot = (DormUtil.GetFntDoorR)(wallId)
  local areaList = (DormUtil.GetFntArea)(x, y, sizeX, sizeY, rot)
  return areaList
end

DormFurnitureEntity.SetFntOverlap = function(self, overlap)
  -- function num : 0_19
  self.overlap = overlap
  self:ShowFntOverlap()
end

DormFurnitureEntity.IsOverlap = function(self)
  -- function num : 0_20
  return self.overlap
end

DormFurnitureEntity.ShowFntOverlap = function(self)
  -- function num : 0_21
  if self.fntBottom ~= nil then
    (self.fntBottom):ShowOverlap(self.overlap)
  end
  if self.fntFloorBottom ~= nil then
    (self.fntFloorBottom):ShowOverlap(self.overlap)
  end
end

DormFurnitureEntity.AddFntBottom = function(self, bottom)
  -- function num : 0_22 , upvalues : DormUtil
  local sizeX, sizeY = (self.fntData):GetFntSize()
  local unityScale = (DormUtil.FntSize2Unity)(sizeX, sizeY, self.type)
  bottom:InitFntBottom(unityScale, self.type, self.rootTran, self._tranformLocalCenterPos)
  self.fntBottom = bottom
  self:ShowFntOverlap()
end

DormFurnitureEntity.RemoveFntBottom = function(self)
  -- function num : 0_23
  local bottom = self.fntBottom
  self.fntBottom = nil
  return bottom
end

DormFurnitureEntity.ResetFntBottom = function(self)
  -- function num : 0_24 , upvalues : DormUtil, DormEnum, _ENV
  local sizeX, sizeY, sizeZ = (self.fntData):GetFntSize()
  do
    if self.fntBottom ~= nil then
      local unityScale = (DormUtil.FntSize2Unity)(sizeX, sizeY, self.type)
      ;
      (self.fntBottom):InitFntBottom(unityScale, self.type, self.rootTran, self._tranformLocalCenterPos)
    end
    if self.fntFloorBottom ~= nil then
      local unityScale = (DormUtil.FntSize2Unity)(sizeX, sizeZ, (DormEnum.eDormFntType).Door)
      local wallUnityScale = (DormUtil.FntSize2Unity)(sizeX, sizeY, (DormEnum.eDormFntType).Door)
      local y = -wallUnityScale.z / 2
      local z = unityScale.z / 2
      local pos = (Vector3.New)(0, y, z) + self._tranformLocalCenterPos
      ;
      (self.fntFloorBottom):InitFntBottom(unityScale, (DormEnum.eDormFntType).Furniture, self.rootTran, pos)
    end
  end
end

DormFurnitureEntity.AddFntDoorBottom = function(self, bottom)
  -- function num : 0_25 , upvalues : DormUtil, DormEnum, _ENV
  local sizeX, sizeY, sizeZ = (self.fntData):GetFntSize()
  local unityScale = (DormUtil.FntSize2Unity)(sizeX, sizeZ, (DormEnum.eDormFntType).Door)
  local wallUnityScale = (DormUtil.FntSize2Unity)(sizeX, sizeY, (DormEnum.eDormFntType).Door)
  local y = -wallUnityScale.z / 2
  local z = unityScale.z / 2
  local pos = (Vector3.New)(0, y, z) + self._tranformLocalCenterPos
  bottom:InitFntBottom(unityScale, (DormEnum.eDormFntType).Furniture, self.rootTran, pos)
  self.fntFloorBottom = bottom
  self:ShowFntOverlap()
end

DormFurnitureEntity.RemoveFntDoorBottom = function(self, bottom)
  -- function num : 0_26
  local bottom = self.fntFloorBottom
  self.fntFloorBottom = nil
  return bottom
end

DormFurnitureEntity.ChangeDmFntWall = function(self, wallHolder, wallIndex)
  -- function num : 0_27 , upvalues : DormEnum, _ENV
  local roomData = (self.fntData):GetFntRoom()
  local isWallpaper = self.type == (DormEnum.eDormFntType).Wallpaper
  if isWallpaper then
    roomData:RemoveDmWallpaper(self.fntData)
  end
  ;
  (self.fntData):SetFntParam(wallIndex)
  if isWallpaper then
    roomData:AddDmWallpaper(self.fntData)
    self:TryUpdDmFntWallpaperLayer()
  end
  ;
  (self.rootTran):SetParent(wallHolder)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.rootTran).localEulerAngles = Vector3.zero
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

DormFurnitureEntity.TryUpdDmFntWallpaperLayer = function(self)
  -- function num : 0_28 , upvalues : DormEnum
  if self.type ~= (DormEnum.eDormFntType).Wallpaper then
    return 
  end
  local layerIdx = (self.fntData):GetFntDataLayer()
  self:SetDmFntWallpaperLayer(layerIdx)
end

DormFurnitureEntity.SetDmFntWallpaperLayer = function(self, layerIdx)
  -- function num : 0_29 , upvalues : _ENV
  do
    if IsNull(self._wallPaperMat) then
      local renderer = (self.transform):FindComponent(eUnityComponentID.Renderer)
      self._wallPaperMat = renderer.material
    end
    local value = layerIdx * -0.3
    ;
    (self._wallPaperMat):SetFloat("_Factor", value)
    ;
    (self._wallPaperMat):SetFloat("_Units", value)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._wallPaperMat).renderQueue = 3030 + layerIdx
  end
end

DormFurnitureEntity.InitFntTouchAnimator = function(self)
  -- function num : 0_30 , upvalues : _ENV, DormEnum
  if (self.fntData):HasFntAnimator() then
    self._fntAnimator = (self.gameObject):FindComponent(eUnityComponentID.Animator)
    if IsNull(self._fntAnimator) then
      error("dorm furniture not find Animator component,obj name:" .. (self.gameObject).name)
      return 
    end
  end
  if not (self.fntData):IsFntEnableTouch() then
    return 
  end
  self._enableTouch = true
  local actList = (self.fntData):GetFntTouchActList()
  if #actList == 0 or actList[1] ~= DormEnum.FntInterReadyState then
    (self.fntData):SetFntInteractState(false)
  end
end

DormFurnitureEntity.ResetFntAnimatorState = function(self)
  -- function num : 0_31 , upvalues : _ENV, DormEnum, EnableTouchAnimatorNameHash
  self:StopFntAudio()
  if not (self.fntData):HasFntAnimator() then
    return 
  end
  if (self.fntData):IsFntEnableTouch() then
    if self._touchTimerId ~= nil then
      TimerManager:StopTimer(self._touchTimerId)
      self._touchTimerId = nil
    end
    local actList = (self.fntData):GetFntTouchActList()
    if #actList == 0 or actList[1] ~= DormEnum.FntInterReadyState then
      (self.fntData):SetFntInteractState(false)
    else
      ;
      (self.fntData):SetFntInteractState(true)
    end
    self._enableTouch = true
    ;
    (self._fntAnimator):SetBool(EnableTouchAnimatorNameHash, false)
  end
  do
    ;
    (self._fntAnimator):SetTrigger("Reset")
  end
end

DormFurnitureEntity.StartFntTouch = function(self)
  -- function num : 0_32 , upvalues : _ENV, EnableTouchAnimatorNameHash
  if not self._enableTouch or self._touchTimerId ~= nil then
    return 
  end
  for _,ipointData in pairs((self.fntData).interpoint) do
    if ipointData:HasBindCharacter() then
      return 
    end
  end
  local isAnimatorEnableTouch = (self._fntAnimator):GetBool(EnableTouchAnimatorNameHash)
  ;
  (self._fntAnimator):SetBool(EnableTouchAnimatorNameHash, not isAnimatorEnableTouch)
  self._enableTouch = false
  ;
  (self.fntData):SetFntInteractState(false)
  self._touchTimerId = TimerManager:StartTimer(0.1, self.FntEntityTouchChecker, self, false, false)
end

DormFurnitureEntity.FntEntityTouchChecker = function(self)
  -- function num : 0_33 , upvalues : _ENV, DormEnum
  local isOk = false
  local curAnimInfo = (self._fntAnimator):GetCurrentAnimatorStateInfo(0)
  for _,actName in pairs((self.fntData):GetFntTouchActList()) do
    if curAnimInfo:IsName(actName) then
      self._enableTouch = true
      if actName == DormEnum.FntInterReadyState then
        (self.fntData):SetFntInteractState(true)
      end
      isOk = true
      break
    end
  end
  do
    if isOk then
      TimerManager:StopTimer(self._touchTimerId)
      self._touchTimerId = nil
    end
  end
end

DormFurnitureEntity.CallFntCommonAnim = function(self)
  -- function num : 0_34
  (self._fntAnimator):SetTrigger("Play")
end

DormFurnitureEntity.PlayFntAudio = function(self, auidoId)
  -- function num : 0_35 , upvalues : _ENV
  self:StopFntAudio()
  if auidoId ~= 0 then
    self.audioCallback = AudioManager:PlayAudioById(auidoId, function(audioCallback)
    -- function num : 0_35_0 , upvalues : self
    if self.audioCallback == audioCallback then
      self.audioCallback = nil
    end
  end
)
  end
end

DormFurnitureEntity.StopFntAudio = function(self)
  -- function num : 0_36 , upvalues : _ENV
  if self.audioCallback ~= nil then
    AudioManager:StopAudioByBack(self.audioCallback)
    self.audioCallback = nil
  end
end

DormFurnitureEntity.OnDormFntInterExit = function(self)
  -- function num : 0_37 , upvalues : _ENV
  if self._fntAnimator == nil then
    return 
  end
  local hasAnim = false
  local hasBind = false
  for _,point in pairs((self.fntData).interpoint) do
    if point:GetInterAnimType() > 0 then
      hasAnim = true
      if point:HasBindCharacter() then
        hasBind = true
      end
    end
  end
  if hasAnim and not hasBind then
    (self._fntAnimator):ResetTrigger("Play")
    ;
    (self._fntAnimator):SetTrigger("Reset")
  end
  self:StopFntAudio()
end

DormFurnitureEntity.GetFntBindTrans = function(self, path)
  -- function num : 0_38 , upvalues : _ENV
  if (string.IsNullOrEmpty)(path) then
    return self.transform
  end
  return (self.transform):Find(path)
end

DormFurnitureEntity.OnRecycleOriginFnt = function(self)
  -- function num : 0_39 , upvalues : DormEnum
  self._savePos = (self.rootTran).position
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.rootTran).position = DormEnum.DormInvisiblePos
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  if self._fntAnimator ~= nil then
    (self._fntAnimator).speed = 0
  end
end

DormFurnitureEntity.OnRecoveryOriginFnt = function(self)
  -- function num : 0_40
  if self._savePos == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.rootTran).position = self._savePos
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if self._fntAnimator ~= nil then
    (self._fntAnimator).speed = 1
  end
end

DormFurnitureEntity.DestroyDmFntEntityGo = function(self)
  -- function num : 0_41 , upvalues : _ENV
  DestroyUnityObject(self.gameObject, true)
  self.gameObject = nil
  self.transform = nil
  self._colliders = nil
  self._visibleHolderTransform = nil
end

DormFurnitureEntity.OnDelete = function(self)
  -- function num : 0_42 , upvalues : _ENV
  self._fntAnimator = nil
  TimerManager:StopTimer(self._touchTimerId)
  DestroyUnityObject(self.rootGo)
  self:StopFntAudio()
  self:_ClearResLoader()
end

return DormFurnitureEntity

