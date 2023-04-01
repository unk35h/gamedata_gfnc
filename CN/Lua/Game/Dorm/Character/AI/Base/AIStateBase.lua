-- params : ...
-- function num : 0 , upvalues : _ENV
local AIStateBase = class("AIStateBase")
AIStateBase.AIExecuteState = {Init = 0, Runnig = 1, Fail = 2, End = 4}
AIStateBase.ctor = function(self, aiCtrl, actionCfg, exitAction)
  -- function num : 0_0 , upvalues : AIStateBase
  self.duration = 0
  self.exeState = (AIStateBase.AIExecuteState).Init
  self.aiCtrl = aiCtrl
  self.actionCfg = actionCfg
  self.exitAction = exitAction
end

AIStateBase.SetStateDuration = function(self, duration)
  -- function num : 0_1
  self.duration = duration
end

AIStateBase.StartState = function(self)
  -- function num : 0_2
end

AIStateBase.InterruptState = function(self, gotoNext)
  -- function num : 0_3
end

AIStateBase.StartExitWait = function(self, action, ...)
  -- function num : 0_4
end

AIStateBase.EnableExitState = function(self)
  -- function num : 0_5
  return true
end

AIStateBase.GetStateName = function(self)
  -- function num : 0_6
  return ""
end

AIStateBase.OnExit = function(self)
  -- function num : 0_7 , upvalues : AIStateBase
  self.exeState = (AIStateBase.AIExecuteState).End
end

AIStateBase.ExitByWaitAction = function(self, action)
  -- function num : 0_8
  local autoNext = true
  if action ~= nil then
    autoNext = false
  end
  if self.exitAction ~= nil then
    (self.exitAction)(self, autoNext)
  end
  if action ~= nil then
    action(true)
  end
end

AIStateBase.OnUpdate = function(self)
  -- function num : 0_9
end

return AIStateBase

