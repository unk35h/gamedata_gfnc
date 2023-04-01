-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessInputCtrl = class("WarChessInputCtrl", base)
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_LeanGesture = ((CS.Lean).Touch).LeanGesture
local CS_Physics = CS.PhysicsUtility
local CS_InputUtility = CS.InputUtility
local CS_RenderManager = CS.RenderManager
WarChessInputCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
end

WarChessInputCtrl.OnSceneLoadOver = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.__camMain = UIManager:GetMainCamera()
end

WarChessInputCtrl.GetMouseCurentGroundPos = function(self)
  -- function num : 0_2 , upvalues : CS_InputUtility, _ENV, CS_RenderManager
  local mousePos = CS_InputUtility.MousePosition
  mousePos = (Vector3.New)(mousePos.x, mousePos.y, 1)
  local worldPos = (self.__camMain):ScreenToWorldPoint(mousePos * CS_RenderManager.SceneCameraResolutionRatio)
  local camPos = ((self.__camMain).transform).position
  local rayDir = worldPos - camPos
  local hitPoint = MathUtil:GetIntersectWithLineAndPlane(camPos, rayDir, Vector3.up, Vector3.zero)
  return hitPoint
end

WarChessInputCtrl.WorldPos2ScreenPos = function(self, worldPos)
  -- function num : 0_3
  return (self.__camMain):WorldToScreenPoint(worldPos)
end

WarChessInputCtrl.GetIsOverSpecificGUI = function(self, UIName)
  -- function num : 0_4 , upvalues : CS_InputUtility, CS_LeanTouch, _ENV
  local mousePos = CS_InputUtility.MousePosition
  local result = (CS_LeanTouch.RaycastGui)(mousePos)
  for i = 0, result.Count - 1 do
    local uigo = (result[i]).gameObject
    if not IsNull(uigo) and uigo.name == UIName then
      return true
    end
  end
  return false
end

WarChessInputCtrl.Delete = function(self)
  -- function num : 0_5
end

return WarChessInputCtrl

