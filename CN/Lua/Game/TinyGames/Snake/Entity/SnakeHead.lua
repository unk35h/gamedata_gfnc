-- params : ...
-- function num : 0 , upvalues : _ENV
local SnakeBase = require("Game.TinyGames.Snake.Entity.SnakeBase")
local SnakeHead = class("SnakeHead", SnakeBase)
local SnakeGameConfig = require("Game.TinyGames.Snake.Config.SnakeGameConfig")
local cs_Tweening = (CS.DG).Tweening
SnakeHead.ctor = function(self, go, x, z)
  -- function num : 0_0
end

SnakeHead.PlaySnakeMoveAni = function(self, tween)
  -- function num : 0_1 , upvalues : cs_Tweening
  tween:SetEase((cs_Tweening.Ease).Linear)
end

return SnakeHead

