-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseCharacterAI = require("Game.Dorm.Character.AI.Base.BaseCharacterAI")
local LittleManCharacterAI = class("LittleManCharacterAI", BaseCharacterAI)
local LittleManAIStateConfig = require("Game.LittleMan.AI.LittleManAIStateConfig")
LittleManCharacterAI.ctor = function(self, aiCfg, autoNextState, littleman)
  -- function num : 0_0 , upvalues : _ENV
  self.littleMan = littleman
  self.aiCfg = aiCfg
  self.__OnCurStateExit = BindCallback(self, self.OnCurStateExit)
  self.__randNextOnExit = autoNextState
  self:InitAIData()
end

LittleManCharacterAI.InitAIData = function(self)
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

LittleManCharacterAI.GetStateClass = function(self, type)
  -- function num : 0_2 , upvalues : LittleManAIStateConfig
  return (LittleManAIStateConfig.GetState)(type)
end

return LittleManCharacterAI

