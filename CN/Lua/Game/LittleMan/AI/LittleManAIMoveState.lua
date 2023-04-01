-- params : ...
-- function num : 0 , upvalues : _ENV
local AIStateBase = require("Game.Dorm.Character.AI.Base.AIStateBase")
local LittleManAIMoveState = class("LittleManAIMoveState", AIStateBase)
LittleManAIMoveState.ctor = function(self, littleManCtrl, actionCfg, exitAction)
  -- function num : 0_0 , upvalues : _ENV
  self.time = 0
  self.littleManCtrl = littleManCtrl
  self.littleMan = littleManCtrl.littleMan
  self.actionCfg = actionCfg
  self.__onCompleteOneMove = BindCallback(self, self.CompleteOneMove)
end

LittleManAIMoveState.GetStateName = function(self)
  -- function num : 0_1
  return "littleman_move"
end

LittleManAIMoveState.StartState = function(self)
  -- function num : 0_2 , upvalues : AIStateBase
  self.exeState = (AIStateBase.AIExecuteState).Runnig
  self.__moveCount = 0
  self:StartNewMove()
end

LittleManAIMoveState.StartNewMove = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.duration <= self.time then
    self:OnExit()
    return 
  end
  local emojiIdList = (self.actionCfg).emoji
  local emojiId = emojiIdList[(math.random)(#emojiIdList)]
  ;
  (self.littleMan):ShowEmoji(emojiId)
  ;
  (self.littleMan):Move(self.__onCompleteOneMove)
end

LittleManAIMoveState.CompleteOneMove = function(self)
  -- function num : 0_4
  if self.duration <= self.time then
    self:OnExit()
    return 
  end
  self:StartNewMove()
end

LittleManAIMoveState.OnUpdate = function(self)
  -- function num : 0_5 , upvalues : AIStateBase, _ENV
  if self.exeState == (AIStateBase.AIExecuteState).End then
    return 
  end
  self.time = self.time + Time.deltaTime
  if self.exeState == (AIStateBase.AIExecuteState).Fail then
    self:OnExit()
  end
end

LittleManAIMoveState.StartExitWait = function(self, action)
  -- function num : 0_6
  self:OnExit(action)
end

LittleManAIMoveState.OnExit = function(self, action)
  -- function num : 0_7 , upvalues : _ENV, AIStateBase
  TimerManager:StopTimer(self.__nextTimer)
  ;
  (AIStateBase.OnExit)(self)
  self:ExitByWaitAction(action)
end

return LittleManAIMoveState

