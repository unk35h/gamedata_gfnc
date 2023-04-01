-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseAIStateConfig = require("Game.Dorm.Character.AI.Base.BaseAIStateConfig")
local LittleManAIStateConfig = class("LittleManAIStateConfig", BaseAIStateConfig)
local eLittleManActionType = {Stand = 0, Move = 2}
local states = {[eLittleManActionType.Stand] = require("Game.LittleMan.AI.LittleManAIStandState"), [eLittleManActionType.Move] = require("Game.LittleMan.AI.LittleManAIMoveState")}
LittleManAIStateConfig.eLittleManActionType = eLittleManActionType
LittleManAIStateConfig.GetState = function(typeId)
  -- function num : 0_0 , upvalues : states, _ENV
  local stateClass = states[typeId]
  if stateClass == nil then
    error("LittleMan action type not define,type:" .. tostring(typeId))
  end
  return stateClass
end

LittleManAIStateConfig.GetLittleManMoveState = function()
  -- function num : 0_1 , upvalues : states, eLittleManActionType
  return states[eLittleManActionType.Move]
end

return LittleManAIStateConfig

