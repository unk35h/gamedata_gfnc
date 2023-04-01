-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightConst = require("Game.Fight.DormFightConst")
local DormFightCameraStateFactory = {}
DormFightCameraStateFactory.CreateCameraState = function(stateType)
  -- function num : 0_0 , upvalues : DormFightConst, _ENV
  local ret = nil
  if stateType == (DormFightConst.CameraStateEnum).RotateScene then
    ret = ((require("Game.Fight.CameraState.DFCameraRotateSceneState")).New)()
  else
    if stateType == (DormFightConst.CameraStateEnum).FollowCharacter then
      ret = ((require("Game.Fight.CameraState.DFCameraFollowState")).New)()
    end
  end
  return ret
end

return DormFightCameraStateFactory

