-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_EntityBase")
local FlappyBird_AccItem = class("FlappyBird_AccItem", base)
FlappyBird_AccItem.OnInit = function(self)
  -- function num : 0_0
  self:SetGravityInfluenceEnable(false)
  self:SetMoveFollowBackGroud()
  self.accLastFrame = 90
  self.invinciableDuration = 150
  self.speedRatio = 4
end

FlappyBird_AccItem.GetAccLastFrame = function(self)
  -- function num : 0_1
  return self.accLastFrame
end

return FlappyBird_AccItem

