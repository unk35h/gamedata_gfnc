-- params : ...
-- function num : 0 , upvalues : _ENV
local RotateAngularSpeed = 15
local DormFightCameraStateBase = require("Game.Fight.CameraState.DormFightCameraStateBase")
local DormFightCameraRotateSceneState = class("DormFightCameraRotateSceneState", DormFightCameraStateBase)
DormFightCameraRotateSceneState.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._cameraTrans = nil
  self._height = 0
  self._radius = nil
  self._angle = 0
  self._focusPoint = Vector3.zero
  self._curPosition = (Vector3.New)(0, 0, 0)
end

DormFightCameraRotateSceneState.OnEnter = function(self, prevState)
  -- function num : 0_1 , upvalues : _ENV
  self._cameraTrans = (self._owner):GetCameraTrans()
  local position = (self._cameraTrans).position
  self._height = position.y - (self._focusPoint).y
  local dx = position.x - (self._focusPoint).x
  local dz = position.z - (self._focusPoint).z
  self._radius = (math.sqrt)(dx * dx + dz * dz)
  self._angle = (math.acos)(dx / self._radius) * 180 / math.pi
end

DormFightCameraRotateSceneState.OnUpdate = function(self, deltaTime)
  -- function num : 0_2 , upvalues : RotateAngularSpeed, _ENV
  self._angle = self._angle + RotateAngularSpeed * deltaTime
  if self._angle < 0 then
    self._angle = self._angle + 360
  else
    if self._angle > 360 then
      self._angle = self._angle - 360
    end
  end
  local radians = self._angle * math.pi / 180
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._curPosition).x = self._radius * (math.cos)(radians) + (self._focusPoint).x
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._curPosition).y = (self._focusPoint).y + self._height
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._curPosition).z = self._radius * (math.sin)(radians) + (self._focusPoint).z
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

  if not IsNull(self._cameraTrans) then
    (self._cameraTrans).position = self._curPosition
    ;
    (self._cameraTrans):LookAt(self._focusPoint)
  end
end

return DormFightCameraRotateSceneState

