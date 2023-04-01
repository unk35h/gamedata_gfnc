-- params : ...
-- function num : 0 , upvalues : _ENV
local SnakeBase = class("SnakeBase")
local SnakeGameConfig = require("Game.TinyGames.Snake.Config.SnakeGameConfig")
SnakeBase.ctor = function(self, go, x, z)
  -- function num : 0_0 , upvalues : _ENV
  self.gameObject = go
  self.transform = go.transform
  self.animator = (self.gameObject):FindComponent(eUnityComponentID.Animator)
  self.x = x
  self.z = z
  self._pos = (Vector3.New)(0, 0, 0)
  self._aniSpeed = 1
  if x ~= nil then
    (self._pos):Set(-x, 0, z)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.transform).localPosition = self._pos
  end
end

SnakeBase.DirectSetSnakePosDir = function(self, x, z, dir)
  -- function num : 0_1 , upvalues : SnakeGameConfig
  self.x = x
  self.z = z
  ;
  (self._pos):Set(-x, 0, z)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localPosition = self._pos
  self.esdir = dir
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localEulerAngles = (SnakeGameConfig.DirRorate)[dir]
end

SnakeBase.SetSnakeActive = function(self, active)
  -- function num : 0_2
  (self.gameObject):SetActive(active)
  if not active then
    (self.transform):DOKill()
  end
end

SnakeBase.ResetSnakeAnimator = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

  (self.animator).speed = 1
  self._aniSpeed = 1
  ;
  (self.animator):ResetTrigger("Dead")
  ;
  (self.animator):SetBool("Start", false)
  ;
  (self.animator):SetTrigger("Reset")
end

SnakeBase.PlaySnakeStartAni = function(self)
  -- function num : 0_4
  (self.animator):SetBool("Start", true)
end

SnakeBase.PlaySnakeMoveAni = function(self, tween)
  -- function num : 0_5
end

SnakeBase.SnakeEntityDead = function(self)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

  (self.animator).speed = 1
  ;
  (self.animator):SetTrigger("Dead")
end

SnakeBase.SetSnakeAniSpeed = function(self, speed)
  -- function num : 0_7
  self._aniSpeed = speed
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.animator).speed = speed
end

SnakeBase.ResetSnakeFastForward = function(self)
  -- function num : 0_8
  (self.transform):DOKill()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.animator).speed = self._aniSpeed
  ;
  (self._pos):Set(-self.x, 0, self.z)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localPosition = self._pos
end

SnakeBase.SetSnakeQuick = function(self, timeScale)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  if self._moveTween ~= nil then
    (self._moveTween).timeScale = timeScale
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.animator).speed = self._aniSpeed * timeScale
  end
end

SnakeBase.MoveSnakeEntity = function(self, x, z, time)
  -- function num : 0_10
  self.x = x
  self.z = z
  ;
  (self._pos):Set(-x, 0, z)
  self._moveTween = ((self.transform):DOLocalMove(self._pos, time)):SetLink(self.gameObject)
  self:PlaySnakeMoveAni(self._moveTween)
end

SnakeBase.RotateSnakeDir = function(self, dir, time)
  -- function num : 0_11 , upvalues : SnakeGameConfig
  if self.esdir == dir then
    return 
  end
  self.esdir = dir
  local rot = (SnakeGameConfig.DirRorate)[dir]
  ;
  ((self.transform):DORotate(rot, SnakeGameConfig.RotateAniRatio * time)):SetLink(self.gameObject)
end

return SnakeBase

