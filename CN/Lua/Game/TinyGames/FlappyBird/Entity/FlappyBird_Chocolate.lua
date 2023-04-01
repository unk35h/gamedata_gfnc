-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_EntityBase")
local FlappyBird_Chocolate = class("FlappyBird_Chocolate", base)
FlappyBird_Chocolate.OnInit = function(self)
  -- function num : 0_0
  self:SetGravityInfluenceEnable(false)
  self:SetMoveFollowBackGroud()
  self.bonusScore = 3
end

return FlappyBird_Chocolate

