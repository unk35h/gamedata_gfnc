-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsEntityBase = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsEntityBase")
local SmashingPenguinsCharacterEntity = class("SmashingPenguinsCharacterEntity", SmashingPenguinsEntityBase)
local base = SmashingPenguinsEntityBase
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsCharacterAnimState = SmashingPenguinsEnum.eCharacterAnimState
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local CS_UnityEngine_ForceMode = (CS.UnityEngine).ForceMode2D
local SmashingPenguinsGameState = SmashingPenguinsEnum.eGameState
SmashingPenguinsCharacterEntity.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  self.rigidbody = (self.ui).rig_characterRigidbody
  self.collider = (self.ui).collider_shengCan
  local listener = ((CS.ColliderEventListener).Get)(self.transform)
  listener:CollisionEnter2DEvent("+", BindCallback(self, self._OnCollisionEnter))
end

SmashingPenguinsCharacterEntity.InitEntityData = function(self, characterEntity, controller)
  -- function num : 0_1 , upvalues : SmashingPenguinsCharacterAnimState, base
  self:SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Cry)
  self._currentLogicFrameNumRoll = 0
  ;
  (base.InitEntityData)(self, characterEntity, controller)
  self.canPlayCollisionAudio = true
  self.canLookAtDir = true
  self.canPlayRollAnim = true
end

SmashingPenguinsCharacterEntity.SetSmashingPenguinsAnimState = function(self, animState)
  -- function num : 0_2 , upvalues : _ENV
  if IsNull(((self.ui).array_characterAnimState)[animState]) then
    return 
  end
  if not IsNull(self.currentAnimState) and not IsNull(((self.ui).array_characterAnimState)[self.currentAnimState]) then
    ((((self.ui).array_characterAnimState)[self.currentAnimState]).gameObject):SetActive(false)
  end
  self._currentLogicFrameNumRoll = 0
  ;
  ((((self.ui).array_characterAnimState)[animState]).gameObject):SetActive(true)
  self.currentAnimState = animState
end

SmashingPenguinsCharacterEntity.UpdateSmashingPenguinsAnimState = function(self)
  -- function num : 0_3 , upvalues : SmashingPenguinsCharacterAnimState, SmashingPenguinsConfig
  if self.currentAnimState ~= SmashingPenguinsCharacterAnimState.Roll then
    return 
  end
  self._currentLogicFrameNumRoll = self._currentLogicFrameNumRoll + 1
  if SmashingPenguinsConfig.MaxLogicFrameNumKeepRoll < self._currentLogicFrameNumRoll then
    self:SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Cry)
  end
end

SmashingPenguinsCharacterEntity.SetSmashingPenguinsUseGravity = function(self, isUseGravity)
  -- function num : 0_4 , upvalues : _ENV, SmashingPenguinsConfig
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  if isUseGravity == false then
    (self.rigidbody).gravityScale = 0
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.rigidbody).velocity = Vector2.zero
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.rigidbody).gravityScale = SmashingPenguinsConfig.GravityScale
  end
end

SmashingPenguinsCharacterEntity.SetSmashingPenguinsColliderEnabled = function(self, isEnabled)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  (self.collider).enabled = isEnabled == true
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SmashingPenguinsCharacterEntity.AddForceToSmashingPenguinsCharacter = function(self, forceDir, forcePower, maxForcePower)
  -- function num : 0_6 , upvalues : _ENV, CS_UnityEngine_ForceMode
  if maxForcePower ~= nil then
    forcePower = (math.clamp)(forcePower, 0, maxForcePower)
  else
    forcePower = (math.clamp)(forcePower, 0, forcePower)
  end
  local force = (Vector2.New)(forceDir.x * forcePower, forceDir.y * forcePower)
  ;
  (self.rigidbody):AddForce(force, CS_UnityEngine_ForceMode.Impulse)
end

SmashingPenguinsCharacterEntity._OnCollisionEnter = function(self, collider)
  -- function num : 0_7 , upvalues : SmashingPenguinsGameState, _ENV, SmashingPenguinsCharacterAnimState
  if (self.mainController):GetSmashingPenguinsGameState() == SmashingPenguinsGameState.Fly then
    if self.canPlayCollisionAudio then
      AudioManager:PlayAudioById(1278)
    end
    if self.canPlayRollAnim then
      self:SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Roll)
    end
  end
end

SmashingPenguinsCharacterEntity.LookAtDir = function(self, moveForward, forceSet)
  -- function num : 0_8 , upvalues : SmashingPenguinsGameState, _ENV
  if not forceSet then
    if not self.canLookAtDir then
      moveForward.y = 0
    end
    if (self.mainController):GetSmashingPenguinsGameState() == SmashingPenguinsGameState.PrepareToFly then
      return 
    end
  end
  local localScale = (self.transform).localScale
  if moveForward.x <= 0 then
    localScale.y = (math.abs)(localScale.y)
  else
    localScale.y = -(math.abs)(localScale.y)
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localScale = localScale
  local forward = (Vector3.New)(moveForward.y, -moveForward.x, 0)
  local rotation = (Quaternion.LookRotation)(Vector3.forward, forward)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).rotation = rotation
end

return SmashingPenguinsCharacterEntity

