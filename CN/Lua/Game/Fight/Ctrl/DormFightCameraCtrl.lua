-- params : ...
-- function num : 0 , upvalues : _ENV
local CS_UnityEngine_Camera = (CS.UnityEngine).Camera
local DormFightConst = require("Game.Fight.DormFightConst")
local DormFightCtrlBase = require("Game.Fight.Ctrl.DormFightCtrlBase")
local DormFightCameraStateFactory = require("Game.Fight.CameraState.DormFightCameraStateFactory")
local DormFightCameraCtrl = class("DormFightCameraCtrl", DormFightCtrlBase)
DormFightCameraCtrl.ctor = function(self, _)
  -- function num : 0_0
  self._camera = nil
  self._cameraTrans = nil
  self._curState = nil
  self._cachedState = {}
end

DormFightCameraCtrl.OnEnterFightScene = function(self)
  -- function num : 0_1 , upvalues : CS_UnityEngine_Camera, _ENV, DormFightConst
  self._camera = CS_UnityEngine_Camera.main
  if not IsNull(self._camera) then
    self._cameraTrans = (self._camera).transform
  end
  self:TransferTo((DormFightConst.CameraStateEnum).RotateScene)
end

DormFightCameraCtrl.OnFightStart = function(self)
  -- function num : 0_2 , upvalues : DormFightConst
  self:TransferTo((DormFightConst.CameraStateEnum).FollowCharacter)
end

DormFightCameraCtrl.OnExitFightScene = function(self)
  -- function num : 0_3
  self._camera = nil
  self._cameraTrans = nil
  self._curState = nil
  self._cachedState = {}
end

DormFightCameraCtrl.OnUpdate = function(self, deltaTime)
  -- function num : 0_4
  if self._curState ~= nil then
    (self._curState):OnUpdate(deltaTime)
  end
end

DormFightCameraCtrl.GetCameraTrans = function(self)
  -- function num : 0_5
  return self._cameraTrans
end

DormFightCameraCtrl.TransferTo = function(self, stateType)
  -- function num : 0_6 , upvalues : DormFightCameraStateFactory
  if stateType == nil or self._cachedState == nil then
    return 
  end
  do
    if (self._cachedState)[stateType] == nil then
      local state = (DormFightCameraStateFactory.CreateCameraState)(stateType)
      if state ~= nil then
        state:Init(self)
        -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

        ;
        (self._cachedState)[stateType] = state
      end
    end
    local nextState = (self._cachedState)[stateType]
    if self._curState ~= nil then
      (self._curState):OnExit(nextState)
    end
    local prevState = self._curState
    self._curState = nextState
    ;
    (self._curState):OnEnter(prevState)
  end
end

return DormFightCameraCtrl

