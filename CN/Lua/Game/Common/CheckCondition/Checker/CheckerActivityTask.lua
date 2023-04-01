-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerActivityTask = {}
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
CheckerActivityTask.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerActivityTask.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local activityFrameId = param[2]
  local taskId = param[3]
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameData = actFrameCtrl:GetActivityFrameData(activityFrameId)
  if actFrameData == nil then
    return false
  end
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).HeroGrow then
    local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
    if heroGrowCtrl ~= nil then
      local heroGrowData = heroGrowCtrl:GetHeroGrowActivity(actFrameData:GetActId())
      if heroGrowData ~= nil then
        local finishTask = heroGrowData:GetHeroGrowFinishTask()
        return (finishTask ~= nil and finishTask[taskId])
      end
    end
  elseif isGameDev then
    warn("activity is nil")
  end
  do return false end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

CheckerActivityTask.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local tip = ConfigData:GetTipContent(801)
  local taskId = param[3]
  local taskCfg = (ConfigData.task)[taskId]
  if taskCfg == nil then
    error("task is nil " .. tostring(taskId))
    return ""
  end
  local title = (LanguageUtil.GetLocaleText)(taskCfg.name)
  local intro = (LanguageUtil.GetLocaleText)(taskCfg.task_intro)
  return (string.format)(tip, title, intro)
end

return CheckerActivityTask

