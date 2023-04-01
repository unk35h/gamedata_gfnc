-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsMainAnimCtrl = class("SmashingPenguinsMainAnimCtrl")
local TinyGameFrameController = require("Game.TinyGames.TinyGameFrameController")
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsCharacterAnimState = SmashingPenguinsEnum.eCharacterAnimState
local animType = {directMove = 1, fire = 2}
local animAction = {[animType.directMove] = function(self, cfg)
  -- function num : 0_0
  self:GetFakeCharacterDirectMoveCfg(cfg)
end
, [animType.fire] = function(self, cfg)
  -- function num : 0_1
  self:GetFakeCharacterFireCfg(cfg)
end
}
SmashingPenguinsMainAnimCtrl.ctor = function(self, fakeCharacterEntity)
  -- function num : 0_2 , upvalues : TinyGameFrameController
  self.fakeCharacterEntity = fakeCharacterEntity
  self.frameCtrl = (TinyGameFrameController.New)()
  self:OnInit()
end

SmashingPenguinsMainAnimCtrl.OnInit = function(self)
  -- function num : 0_3 , upvalues : _ENV, SmashingPenguinsConfig
  self.__OnRenderFrameUpdate = BindCallback(self, self.OnRenderFrameUpdate)
  self.__OnLogicFrameUpdate = BindCallback(self, self.OnLogicFrameUpdate)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.fakeCharacterEntity).transform).localPosition = (Vector3.New)((SmashingPenguinsConfig.StartPosBeforeAnim).x, (SmashingPenguinsConfig.StartPosBeforeAnim).y, 0)
  ;
  (self.frameCtrl):StartRunning(self.__OnLogicFrameUpdate, self.__OnRenderFrameUpdate)
end

SmashingPenguinsMainAnimCtrl.GetRandomAnimType = function(self)
  -- function num : 0_4 , upvalues : SmashingPenguinsConfig, _ENV
  local data = (SmashingPenguinsConfig.MainUiAnimData)[(math.random)(#SmashingPenguinsConfig.MainUiAnimData)]
  self:SetCurrentAnimType(data)
end

SmashingPenguinsMainAnimCtrl.SetCurrentAnimType = function(self, data)
  -- function num : 0_5 , upvalues : animAction
  if animAction[data.animType] ~= nil then
    (animAction[data.animType])(self, data.cfg)
    self.currentAnimType = data.animType
  end
end

SmashingPenguinsMainAnimCtrl.RefreshFakeCharacterState = function(self, isUsePhysics)
  -- function num : 0_6 , upvalues : _ENV, SmashingPenguinsCharacterAnimState
  if self._fireTimer ~= nil then
    TimerManager:StopTimer(self._fireTimer)
    self._fireTimer = nil
  end
  ;
  ((self.fakeCharacterEntity).transform):DOKill(false)
  ;
  (self.fakeCharacterEntity):SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Cry)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.fakeCharacterEntity).rigidbody).velocity = Vector3.zero
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.fakeCharacterEntity).canLookAtDir = true
  ;
  (self.fakeCharacterEntity):LookAtDir(Vector3.left, true)
  self:SetFakeCharacterPhysics(isUsePhysics)
end

SmashingPenguinsMainAnimCtrl.SetFakeCharacterPhysics = function(self, isUsePhysics)
  -- function num : 0_7
  (self.fakeCharacterEntity):SetSmashingPenguinsColliderEnabled(isUsePhysics)
  ;
  (self.fakeCharacterEntity):SetSmashingPenguinsUseGravity(isUsePhysics)
end

SmashingPenguinsMainAnimCtrl.GetFakeCharacterDirectMoveCfg = function(self, cfg)
  -- function num : 0_8
  if cfg ~= nil then
    self:RefreshFakeCharacterState(false)
    self:PlayFakeCharacterDirectMoveAnim(cfg)
  end
end

SmashingPenguinsMainAnimCtrl.PlayFakeCharacterDirectMoveAnim = function(self, directMoveCfg)
  -- function num : 0_9 , upvalues : _ENV
  local startPos = (Vector3.New)(directMoveCfg.startX, directMoveCfg.startY, 0)
  local endPos = (Vector3.New)(directMoveCfg.endX, directMoveCfg.endY, 0)
  ;
  (self.fakeCharacterEntity):LookAtDir(endPos - startPos)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.fakeCharacterEntity).transform).localPosition = startPos
  ;
  ((((self.fakeCharacterEntity).transform):DOLocalMove(endPos, directMoveCfg.time)):SetLink(self)):OnComplete(function()
    -- function num : 0_9_0 , upvalues : self
    self:GetRandomAnimType()
  end
)
end

SmashingPenguinsMainAnimCtrl.GetFakeCharacterFireCfg = function(self, cfg)
  -- function num : 0_10
  if cfg ~= nil then
    self:RefreshFakeCharacterState(true)
    self:PlayFakeCharacterFireAnim(cfg)
  end
end

SmashingPenguinsMainAnimCtrl.PlayFakeCharacterFireAnim = function(self, fireCfg)
  -- function num : 0_11 , upvalues : _ENV
  local startPos = (Vector3.New)(fireCfg.startX, fireCfg.startY, 0)
  local forceDir = ((Vector2.New)(fireCfg.dirX, fireCfg.dirY)).normalized
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.fakeCharacterEntity).transform).localPosition = startPos
  ;
  (self.fakeCharacterEntity):AddForceToSmashingPenguinsCharacter(forceDir, fireCfg.power)
  if self._fireTimer ~= nil then
    TimerManager:StopTimer(self._fireTimer)
    self._fireTimer = nil
  end
  self._fireTimer = TimerManager:StartTimer(fireCfg.time, function()
    -- function num : 0_11_0 , upvalues : self
    self:GetRandomAnimType()
  end
)
end

SmashingPenguinsMainAnimCtrl.OnRenderFrameUpdate = function(self, timeRate)
  -- function num : 0_12 , upvalues : animType
  if self.currentAnimType ~= animType.fire then
    return 
  end
  ;
  (self.fakeCharacterEntity):LookAtDir(((self.fakeCharacterEntity).rigidbody).velocity)
end

SmashingPenguinsMainAnimCtrl.OnLogicFrameUpdate = function(self, logicFrameNum)
  -- function num : 0_13 , upvalues : animType, SmashingPenguinsConfig, SmashingPenguinsEnum
  if self.currentAnimType ~= animType.fire then
    return 
  end
  local currentVelocity = ((self.fakeCharacterEntity).rigidbody).velocity
  local sqrtSpeed = currentVelocity.sqrMagnitude
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.fakeCharacterEntity).canLookAtDir = SmashingPenguinsConfig.MinSqrtSpeedKeepDir < sqrtSpeed
  ;
  (self.fakeCharacterEntity):UpdateSmashingPenguinsAnimState()
  if sqrtSpeed < SmashingPenguinsConfig.MinSqrtSpeedKeepRoll then
    (self.fakeCharacterEntity):SetSmashingPenguinsAnimState((SmashingPenguinsEnum.eCharacterAnimState).Cry)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.fakeCharacterEntity).canPlayRollAnim = false
  else
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

    (self.fakeCharacterEntity).canPlayRollAnim = true
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

SmashingPenguinsMainAnimCtrl.Delete = function(self)
  -- function num : 0_14 , upvalues : _ENV
  self:RefreshFakeCharacterState(false)
  if (self.frameCtrl):GetIsRunning() then
    (self.frameCtrl):StopRunning()
  end
  if self._fireTimer ~= nil then
    TimerManager:StopTimer(self._fireTimer)
    self._fireTimer = nil
  end
end

return SmashingPenguinsMainAnimCtrl

