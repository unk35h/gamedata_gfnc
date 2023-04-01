-- params : ...
-- function num : 0 , upvalues : _ENV
local FlappyBird_EntityBase = class("FlappyBird_EntityBase")
local CollisionUtil = require("Game.TinyGames.FlappyBird.FlappyBirdUtil.FlappyBirdCollisionUtil")
FlappyBird_EntityBase.ctor = function(self, mapEvnData)
  -- function num : 0_0 , upvalues : _ENV
  self.pos = {x = 0, y = 0}
  self.velocity = {x = 0, y = 0}
  self.colliderBox = {left = -1, bottom = -1, right = 1, top = 1}
  self.evnData = mapEvnData
  self.__isMoveFollowBackGround = false
  self.__enableGravityInfluence = false
  self.viewPos = (Vector2.New)((self.pos).x / 1000, (self.pos).y / 1000)
  self:OnInit()
end

FlappyBird_EntityBase.OnInit = function(self)
  -- function num : 0_1
end

FlappyBird_EntityBase.SetPos = function(self, x, y)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.pos).x = x
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.pos).y = y
end

FlappyBird_EntityBase.SetGravityInfluenceEnable = function(self, value)
  -- function num : 0_3
  self.__enableGravityInfluence = value
end

FlappyBird_EntityBase.SetColliderSize = function(self, left, bottom, right, top)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.colliderBox).left = left
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.colliderBox).bottom = bottom
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.colliderBox).right = right
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.colliderBox).top = top
end

FlappyBird_EntityBase.IsOnCollission = function(self, otherEntity)
  -- function num : 0_5 , upvalues : CollisionUtil
  return (CollisionUtil.IsRectRectOnCollission)(self.pos, self.colliderBox, otherEntity.pos, otherEntity.colliderBox)
end

FlappyBird_EntityBase.UpdatePos = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  if self.__enableGravityInfluence then
    (self.velocity).y = (self.velocity).y - (self.evnData).gravityScale
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.velocity).y = (math.max)((self.evnData).minVerticalVelocity, (self.velocity).y)
  end
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.pos).x = (self.pos).x + (self.velocity).x
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.pos).y = (self.pos).y + (self.velocity).y
end

FlappyBird_EntityBase.OnUpdateLogic = function(self)
  -- function num : 0_7
  self:UpdatePos()
end

FlappyBird_EntityBase.SetMoveFollowBackGroud = function(self)
  -- function num : 0_8
  self.velocity = (self.evnData).backGroudMoveSpeed
  self.__isMoveFollowBackGround = true
end

FlappyBird_EntityBase.LogicPos2UnityPos = function(self)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  (self.viewPos).x = (self.pos).x / 1000
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.viewPos).y = (self.pos).y / 1000
  return self.viewPos
end

return FlappyBird_EntityBase

