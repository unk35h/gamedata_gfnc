-- params : ...
-- function num : 0 , upvalues : _ENV
local ShowCharacterUtil = {}
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_LeanGesture = ((CS.Lean).Touch).LeanGesture
ShowCharacterUtil.DoGestureFunc = function(trackedDolly, fingerList)
  -- function num : 0_0 , upvalues : CS_LeanGesture, CS_LeanTouch
  if trackedDolly == nil then
    return 
  end
  local screenDelta = nil
  if fingerList.Count == 0 then
    screenDelta = (CS_LeanGesture.GetScreenDelta)(CS_LeanTouch.Fingers)
  else
    screenDelta = (CS_LeanGesture.GetScreenDelta)(fingerList)
  end
  trackedDolly.m_PathPosition = trackedDolly.m_PathPosition + -screenDelta.x * 0.00025
end

return ShowCharacterUtil

