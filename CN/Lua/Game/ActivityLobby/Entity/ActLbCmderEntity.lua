-- params : ...
-- function num : 0 , upvalues : _ENV
local ActLbCmderEntity = class("ActLbCmderEntity")
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
ActLbCmderEntity.ctor = function(self)
  -- function num : 0_0
end

ActLbCmderEntity.InitActLbCmderEntity = function(self, cmderCtrl, cmderHeadFxGo, cmderObject, playerRigidbodyTran)
  -- function num : 0_1 , upvalues : _ENV
  self._cmderCtrl = cmderCtrl
  self:_InitHeadFx(cmderHeadFxGo, cmderObject)
  self.gameObject = cmderObject
  self.transform = cmderObject.transform
  self.animator = cmderObject:FindComponent(eUnityComponentID.Animator)
  ;
  (self.animator):SetBool("DormMoveRun", true)
  self.cmderCharacter = ((CS.DormAStarCharacter).Create)(cmderObject)
  ;
  (self.cmderCharacter):AddAStarComponents(true)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.cmderCharacter).aiPath).canSearch = false
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.cmderCharacter).aiPath).rotationSpeed = 1000
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.cmderCharacter).aiPath).slowWhenNotFacingTarget = false
  playerRigidbodyTran:SetParent(self.transform, false)
  local listener = ((CS.ColliderEventListener).Get)(playerRigidbodyTran.gameObject)
  listener:TriggerEnterEvent("+", BindCallback(self, self._OnTriggerEnter))
  listener:TriggerExitEvent("+", BindCallback(self, self._OnTriggerExit))
  ;
  (playerRigidbodyTran.gameObject):SetActive(false)
  ;
  (playerRigidbodyTran.gameObject):SetActive(true)
  self._characterUnit = (self.gameObject):GetComponent(typeof(CS.CharacterUnit))
  if IsNull(self._characterUnit) then
    error("cant get CharacterUnit on character, obj:" .. (self.gameObject).name)
  end
end

ActLbCmderEntity._InitHeadFx = function(self, cmderHeadFxGo, cmderObject)
  -- function num : 0_2 , upvalues : _ENV
  self._cmderHeadFxGo = cmderHeadFxGo
  local posConstraint = cmderHeadFxGo:GetComponent(typeof(((CS.UnityEngine).Animations).PositionConstraint))
  if posConstraint ~= nil then
    local constraintSource = posConstraint:GetSource(0)
    local headPath = (self._cmderCtrl):GetActLbCmderResPath() .. "/root/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Neck/Bip001 Head"
    local headTran = (cmderObject.transform):Find(headPath)
    if IsNull(headTran) then
      warn("Commander head point is null : " .. tostring(headPath))
    end
    constraintSource.sourceTransform = headTran
    posConstraint:SetSource(0, constraintSource)
  end
end

ActLbCmderEntity.SetActLbCmdMoveSpeed = function(self, speed)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.cmderCharacter).speed = speed
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.cmderCharacter).aiPath).maxSpeed = speed
end

ActLbCmderEntity.SetActLbCmdPos = function(self, posV3)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.transform).position = posV3
end

ActLbCmderEntity.SetLbCmderStarAIPathActive = function(self, active)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.cmderCharacter).aiPath).canMove = active
end

ActLbCmderEntity.GetLbCharAStarComp = function(self)
  -- function num : 0_6
  return self.cmderCharacter
end

ActLbCmderEntity.ActLbCmderStartMove = function(self, moveData)
  -- function num : 0_7
  self:SetLbCmderStarAIPathActive(true)
  ;
  (self.cmderCharacter):MoveByJoystickData(moveData)
  self:SetLbCmdMoveAniSpeed((((self.cmderCharacter).aiPath).velocity).magnitude)
  ;
  (((self._cmderCtrl).actLbCtrl).actLbCamCtrl):SetActLbCamFollowTarget(self.transform)
  self:PlayActLbCmdMoveAudio(true)
end

ActLbCmderEntity.SetLbCmdMoveAniSpeed = function(self, value)
  -- function num : 0_8
  (self.animator):SetFloat("DormWalkSpeed", value)
end

ActLbCmderEntity.LbCmdEntMoveDestPos = function(self, worldPos)
  -- function num : 0_9
  (((self._cmderCtrl).actLbCtrl).actLbCamCtrl):SetActLbCamFollowTarget(self.transform)
  self:SetLbCmderStarAIPathActive(true)
  ;
  (self.cmderCharacter):StopSmoothDownSpeed()
  self:PlayActLbCmdMoveAudio(true)
  ;
  (self.cmderCharacter):MoveDestPos(worldPos, function(ok)
    -- function num : 0_9_0 , upvalues : self
    self:PlayActLbCmdMoveAudio(false)
  end
, true, 0)
  ;
  ((self.cmderCharacter).aiPath):SearchPath()
end

ActLbCmderEntity.LbCmderEndMove = function(self)
  -- function num : 0_10
  (self.cmderCharacter):ForceStopMove()
  ;
  (self.cmderCharacter):StartSmoothDownSpeed()
  self:PlayActLbCmdMoveAudio(false)
end

ActLbCmderEntity._OnTriggerEnter = function(self, collider)
  -- function num : 0_11 , upvalues : ActLbEnum
  if ActLbEnum.InteractRangeName ~= collider.name then
    return 
  end
  ;
  (((self._cmderCtrl).actLbCtrl).actLbIntrctCtrl):OnLbInteractChange(collider.gameObject, true)
end

ActLbCmderEntity._OnTriggerExit = function(self, collider)
  -- function num : 0_12 , upvalues : ActLbEnum
  if ActLbEnum.InteractRangeName ~= collider.name then
    return 
  end
  ;
  (((self._cmderCtrl).actLbCtrl).actLbIntrctCtrl):OnLbInteractChange(collider.gameObject, false)
end

ActLbCmderEntity.LbCmdStartSmoothLookAtTarget = function(self, transform, action)
  -- function num : 0_13
  (self.cmderCharacter):StartSmoothLookAtTarget(transform, action)
end

ActLbCmderEntity.PlayActLbCmdMoveAudio = function(self, isPlay)
  -- function num : 0_14 , upvalues : _ENV
  do return  end
  if isPlay then
    if self._moveAuBack ~= nil then
      return 
    end
    self._moveAuBack = AudioManager:PlayAudioById(1254, function(auback)
    -- function num : 0_14_0 , upvalues : self
    if self._moveAuBack == auback then
      self._moveAuBack = nil
    end
  end
)
  else
    if self._moveAuBack then
      AudioManager:StopAudioByBack(self._moveAuBack)
      self._moveAuBack = nil
    end
  end
end

ActLbCmderEntity.HideLbEnttRenderer = function(self, hide)
  -- function num : 0_15 , upvalues : _ENV
  if IsNull(self._characterUnit) then
    return 
  end
  if self._renderList == nil then
    self._renderList = {}
    for i = 0, ((self._characterUnit).smrArray).Length - 1 do
      (table.insert)(self._renderList, ((self._characterUnit).smrArray)[i])
    end
    for i = 0, ((self._characterUnit).extraRendererArray).Length - 1 do
      (table.insert)(self._renderList, ((self._characterUnit).extraRendererArray)[i])
    end
  end
  do
    for k,renderer in ipairs(self._renderList) do
      (renderer.gameObject):SetActive(not hide)
    end
    ;
    (self._cmderHeadFxGo):SetActive(not hide)
  end
end

ActLbCmderEntity.OnDelete = function(self)
  -- function num : 0_16
  self:PlayActLbCmdMoveAudio(false)
end

return ActLbCmderEntity

