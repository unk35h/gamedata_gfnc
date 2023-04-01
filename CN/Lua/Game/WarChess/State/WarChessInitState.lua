-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.State.Base.WarChessStateBase")
local WarChessInitState = class("WarChessInitState", base)
WarChessInitState.ctor = function(self)
  -- function num : 0_0
end

WarChessInitState.OnEnterState = function(self)
  -- function num : 0_1
end

WarChessInitState.OnExitState = function(self)
  -- function num : 0_2
end

return WarChessInitState

