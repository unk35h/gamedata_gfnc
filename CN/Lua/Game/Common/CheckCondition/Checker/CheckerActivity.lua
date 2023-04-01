-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerActivity = {}
CheckerActivity.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerActivity.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local activityFrameId = param[2]
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local activityData = activityFrameCtrl:GetActivityFrameData(activityFrameId)
  do return (activityData ~= nil and activityData:IsActivityOpen()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

CheckerActivity.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local activityFrameId = param[2]
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local activityData = activityFrameCtrl:GetActivityFrameData(activityFrameId)
  if activityData ~= nil then
    return (string.format)(ConfigData:GetTipContent(7401), activityData.name)
  end
  return ""
end

return CheckerActivity

