-- params : ...
-- function num : 0 , upvalues : _ENV
local FlappyBird_Tube = class("FlappyBird_Tube")
local CollisionUtil = require("Game.TinyGames.FlappyBird.FlappyBirdUtil.FlappyBirdCollisionUtil")
FlappyBird_Tube.ctor = function(self, tubeType)
  -- function num : 0_0 , upvalues : _ENV
  self.__tubeType = tubeType
  self.offset = {x = 0, y = 0}
  self.pos = {x = 0, y = 0}
  self.viewPos = (Vector2.New)((self.pos).x / 1000, (self.pos).y / 1000)
end

FlappyBird_Tube.SetColliderSize = function(self, halfWidth, halfHeight)
  -- function num : 0_1
  self.colliderBox = {left = -halfWidth, bottom = -halfHeight, right = halfWidth, top = halfHeight}
end

FlappyBird_Tube.GetTubeType = function(self)
  -- function num : 0_2
  return self.__tubeType
end

FlappyBird_Tube.SetOffset2Center = function(self, x, y)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.offset).x = x
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.offset).y = y
end

FlappyBird_Tube.IsOnTubeCollission = function(self, otherEntity)
  -- function num : 0_4 , upvalues : CollisionUtil
  return (CollisionUtil.IsRectRectOnCollission)(self.pos, self.colliderBox, otherEntity.pos, otherEntity.colliderBox)
end

FlappyBird_Tube.SetTubePos = function(self, x, y)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  (self.pos).x = x + (self.offset).x
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.pos).y = y + (self.offset).y
end

FlappyBird_Tube.LogicPos2UnityPos = function(self)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  (self.viewPos).x = (self.pos).x / 1000
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.viewPos).y = (self.pos).y / 1000
  return self.viewPos
end

return FlappyBird_Tube

