-- params : ...
-- function num : 0 , upvalues : _ENV
local AIStateBase = require("Game.Dorm.Character.AI.Base.AIStateBase")
local LittleManAIStandState = class("LittleManAIStandState", AIStateBase)
LittleManAIStandState.ctor = function(self, littleManCtrl, actionCfg, exitAction)
  -- function num : 0_0
  self.time = 0
  self.littleManCtrl = littleManCtrl
  self.actionCfg = actionCfg
  self.littleMan = littleManCtrl.littleMan
end

LittleManAIStandState.GetStateName = function(self)
  -- function num : 0_1
  return "littleman_stand"
end

LittleManAIStandState.StartState = function(self)
  -- function num : 0_2 , upvalues : AIStateBase
  (self.littleMan):Stand()
  self.exeState = (AIStateBase.AIExecuteState).Runnig
end

LittleManAIStandState.OnUpdate = function(self)
  -- function num : 0_3 , upvalues : AIStateBase, _ENV
  if self.exeState == (AIStateBase.AIExecuteState).End then
    return 
  end
  self.time = self.time + Time.deltaTime
  if self.duration <= self.time then
    self:OnExit()
  end
end

LittleManAIStandState.InterruptState = function(self, gotoNext)
  -- function num : 0_4
  if gotoNext then
    self:OnExit()
    return 
  end
end

LittleManAIStandState.StartExitWait = function(self, action)
  -- function num : 0_5
  self:OnExit(action)
end

LittleManAIStandState.OnExit = function(self, action)
  -- function num : 0_6 , upvalues : AIStateBase
  (AIStateBase.OnExit)(self)
  self:ExitByWaitAction(action)
end

return LittleManAIStandState

