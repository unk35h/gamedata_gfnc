-- params : ...
-- function num : 0 , upvalues : _ENV
local CS_UnityEngine_Input = (CS.UnityEngine).Input
local CS_UnityEngine_Camera = (CS.UnityEngine).Camera
local DormFightConst = require("Game.Fight.DormFightConst")
local DormFightCharacterFeatureBase = require("Game.Fight.Character.Feature.DormFightCharacterFeatureBase")
local DormFightKeyboardInputController = class("DormFightKeyboardInputController", DormFightCharacterFeatureBase)
DormFightKeyboardInputController.ctor = function(self)
  -- function num : 0_0
  self._modelCtrl = nil
  self._cameraTrans = nil
end

DormFightKeyboardInputController.OnInit = function(self)
  -- function num : 0_1 , upvalues : DormFightConst, CS_UnityEngine_Camera
  self._modelCtrl = self:GetFeature((DormFightConst.FeatureEnum).ModelController)
  self._cameraTrans = (CS_UnityEngine_Camera.main).transform
end

DormFightKeyboardInputController.OnUpdate = function(self, _)
  -- function num : 0_2
  self:UpdateAttack()
  self:UpdateMovement()
end

DormFightKeyboardInputController.UpdateAttack = function(self)
  -- function num : 0_3 , upvalues : CS_UnityEngine_Input, _ENV, DormFightConst
  if (CS_UnityEngine_Input.GetKeyDown)(((CS.UnityEngine).KeyCode).Keypad1) then
    (self._modelCtrl):PostEvent((DormFightConst.EventEnum).Attack)
  end
end

DormFightKeyboardInputController.UpdateMovement = function(self)
  -- function num : 0_4 , upvalues : CS_UnityEngine_Input, _ENV, DormFightConst
  local axisH = (CS_UnityEngine_Input.GetAxis)("Horizontal")
  local axisV = (CS_UnityEngine_Input.GetAxis)("Vertical")
  if (math.abs)(axisH) <= 1e-05 and (math.abs)(axisV) <= 1e-05 then
    (self._modelCtrl):PostEvent((DormFightConst.EventEnum).StopMoving)
    return 
  end
  local cameraDir = (Quaternion.Euler)(0, (((self._cameraTrans).rotation).eulerAngles).y, 0)
  local target = (Vector3.New)(axisH, 0, axisV)
  local targetDir = (Vector3.Normalize)(target) * cameraDir
  if (CS_UnityEngine_Input.GetKeyDown)(((CS.UnityEngine).KeyCode).Keypad2) then
    (self._modelCtrl):PostEvent((DormFightConst.EventEnum).Run, targetDir)
  else
    ;
    (self._modelCtrl):PostEvent((DormFightConst.EventEnum).Move, targetDir)
  end
end

return DormFightKeyboardInputController

