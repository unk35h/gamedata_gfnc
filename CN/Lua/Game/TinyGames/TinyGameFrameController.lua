-- params : ...
-- function num : 0 , upvalues : _ENV
local TinyGameFrameController = class("TinyGameFrameController")
local LOGIC_FRAME_LEN = 33
TinyGameFrameController.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__isGameRunning = false
  self.logicFrameNum = 0
  self.__passedTimeSum = 0
  self.logicCallback = nil
  self.renderCallback = nil
  self._OnUpdate = BindCallback(self, self.__OnUpdate)
end

TinyGameFrameController.StartRunning = function(self, logicCallback, renderCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.__isGameRunning = true
  self:CleanLogic()
  self.logicCallback = logicCallback
  self.renderCallback = renderCallback
  UpdateManager:AddUpdate(self._OnUpdate)
end

TinyGameFrameController.StopRunning = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.__isGameRunning = false
  self:CleanLogic()
  self.logicCallback = nil
  self.renderCallback = nil
  UpdateManager:RemoveUpdate(self._OnUpdate)
end

TinyGameFrameController.CleanLogic = function(self)
  -- function num : 0_3
  self.logicFrameNum = 0
  self.__passedTimeSum = 0
end

TinyGameFrameController.__OnUpdate = function(self)
  -- function num : 0_4 , upvalues : _ENV, LOGIC_FRAME_LEN
  if not self.__isGameRunning then
    return 
  end
  local deltaTime = Time.deltaTime
  self.__passedTimeSum = self.__passedTimeSum + deltaTime * 1000
  while LOGIC_FRAME_LEN < self.__passedTimeSum do
    self.logicFrameNum = self.logicFrameNum + 1
    self.__passedTimeSum = self.__passedTimeSum - LOGIC_FRAME_LEN
    self:__OnUpdateLogic(self.logicFrameNum)
  end
  self:__OnUpdateRender()
end

TinyGameFrameController.__OnUpdateLogic = function(self, logicFrameNum)
  -- function num : 0_5
  if self.logicCallback ~= nil then
    (self.logicCallback)(logicFrameNum)
  end
end

TinyGameFrameController.__OnUpdateRender = function(self)
  -- function num : 0_6 , upvalues : LOGIC_FRAME_LEN
  local timeRate = self.__passedTimeSum / LOGIC_FRAME_LEN
  if self.renderCallback ~= nil then
    (self.renderCallback)(timeRate)
  end
end

TinyGameFrameController.GetCurLogicFrameNum = function(self)
  -- function num : 0_7
  return self.logicFrameNum
end

TinyGameFrameController.GetLogicFrameLen = function(self)
  -- function num : 0_8 , upvalues : LOGIC_FRAME_LEN
  return LOGIC_FRAME_LEN
end

TinyGameFrameController.GetIsRunning = function(self)
  -- function num : 0_9
  return self.__isGameRunning
end

TinyGameFrameController.OnDelete = function(self)
  -- function num : 0_10
end

return TinyGameFrameController

