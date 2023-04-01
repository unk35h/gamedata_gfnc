-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseCharacterAI = class("BaseCharacterAI")
local Messenger = require("Framework.Common.Messenger")
BaseCharacterAI.ctor = function(self, aiCfg, autoNextState)
  -- function num : 0_0 , upvalues : _ENV
  self.aiCfg = aiCfg
  self.__OnCurStateExit = BindCallback(self, self.OnCurStateExit)
  self.__randNextOnExit = autoNextState
  self:InitAIData()
end

BaseCharacterAI.InitAIData = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.desires = {}
  for k,v in ipairs((self.aiCfg).desire_init) do
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

    (self.desires)[k] = v
  end
  self.desireOpen = {}
  for i = 1, #self.desires do
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

    (self.desireOpen)[i] = true
  end
  self.state = nil
end

BaseCharacterAI.GetCurAIState = function(self)
  -- function num : 0_2
  return self.state
end

BaseCharacterAI.RefreshDesireOpen = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.weightSum = 0
  for index,actionId in ipairs((self.aiCfg).actions) do
    local actionCfg = (ConfigData.dorm_action)[actionId]
    local ableOpen = false
    if actionCfg ~= nil then
      ableOpen = true
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

    if ableOpen then
      (self.desireOpen)[index] = true
      self.weightSum = self.weightSum + (self.desires)[index]
    else
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.desireOpen)[index] = false
    end
  end
end

BaseCharacterAI.RandNewAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self:RefreshDesireOpen()
  local rangValue = (math.random)(self.weightSum)
  local weightCount = 0
  for index,v in pairs(self.desireOpen) do
    if v then
      weightCount = weightCount + (self.desires)[index]
      if rangValue <= weightCount then
        self:SetCurState(index)
        break
      end
    end
  end
end

BaseCharacterAI.GetStateClass = function(self, type)
  -- function num : 0_5
end

BaseCharacterAI.SetCurState = function(self, index)
  -- function num : 0_6 , upvalues : _ENV
  local actionId = ((self.aiCfg).actions)[index]
  local actionCfg = (ConfigData.dorm_action)[actionId]
  if actionCfg == nil then
    return 
  end
  local stateClass = self:GetStateClass(actionCfg.type)
  if stateClass == nil then
    return 
  end
  local state = (stateClass.New)(self, actionCfg, self.__OnCurStateExit)
  self.state = state
  self.stateType = actionCfg.type
  local duration = self:CalAIStateDuration(index)
  ;
  (self.state):SetStateDuration(duration)
  ;
  (self.state):StartState()
  self:ReassignDesires(index)
end

BaseCharacterAI.CalAIStateDuration = function(self, index)
  -- function num : 0_7 , upvalues : _ENV
  local mintime = ((self.aiCfg).min_time)[index]
  local maxTime = ((self.aiCfg).max_time)[index]
  local time = mintime + (math.random)(maxTime - mintime + 1) - 1
  do
    if #self.desires > 1 then
      local otherUpRateSum = 0
      for curindex,v in pairs((self.aiCfg).desire_up_rate) do
        if curindex ~= index then
          otherUpRateSum = otherUpRateSum + v
        end
      end
      time = time + ((self.aiCfg).time_weight)[index] * ((self.desires)[index] // (otherUpRateSum))
    end
    return time
  end
end

BaseCharacterAI.ReassignDesires = function(self, index)
  -- function num : 0_8 , upvalues : _ENV
  if #self.desires <= 1 then
    return 
  end
  local otherUpRateSum = 0
  for curindex,v in ipairs(self.desireOpen) do
    if v then
      otherUpRateSum = otherUpRateSum + ((self.aiCfg).desire_up_rate)[curindex]
    end
  end
  local currentDesireNewValue = (self.desires)[index] % (otherUpRateSum)
  local currentDesireConsumption = (self.desires)[index] - currentDesireNewValue
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.desires)[index] = currentDesireNewValue
  if currentDesireConsumption <= 0 then
    return 
  end
  while currentDesireConsumption > 0 do
    for curindex,v in ipairs(self.desireOpen) do
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R10 in 'UnsetPending'

      if v then
        (self.desires)[curindex] = (self.desires)[curindex] + ((self.aiCfg).desire_up_rate)[curindex]
        currentDesireConsumption = currentDesireConsumption - ((self.aiCfg).desire_up_rate)[curindex]
      end
    end
  end
end

BaseCharacterAI.AIInterruptCurrState = function(self, gotoNext)
  -- function num : 0_9
  if self.state ~= nil then
    (self.state):InterruptState(gotoNext)
  end
  self.state = nil
end

BaseCharacterAI.AIStartExitWait = function(self, action, ...)
  -- function num : 0_10
  if self.state == nil then
    if action ~= nil then
      action(false)
    end
    return 
  end
  ;
  (self.state):StartExitWait(action, ...)
end

BaseCharacterAI.EnableExitCurrentState = function(self)
  -- function num : 0_11
  if self.state == nil then
    return true
  end
  return (self.state):EnableExitState()
end

BaseCharacterAI.OnUpdate = function(self)
  -- function num : 0_12
  if self.state ~= nil then
    (self.state):OnUpdate()
  end
end

BaseCharacterAI.OnCurStateExit = function(self, state, enterNext)
  -- function num : 0_13
  local stateType = self.stateType
  self.state = nil
  self.stateType = 0
  if self.__randNextOnExit and enterNext then
    self:RandNewAction()
  end
end

return BaseCharacterAI

