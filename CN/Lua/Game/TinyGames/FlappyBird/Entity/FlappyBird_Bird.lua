-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_EntityBase")
local FlappyBird_Bird = class("FlappyBird_Bird", base)
FlappyBird_Bird.OnInit = function(self)
  -- function num : 0_0
  self:SetGravityInfluenceEnable(false)
  self.__invinciable = false
end

FlappyBird_Bird.SetColliderSize = function(self, size)
  -- function num : 0_1 , upvalues : base
  (base.SetColliderSize)(self, size.left, size.bottom, size.right, size.top)
end

FlappyBird_Bird.InjectUpdateInvinciableView = function(self, updateInvinciable, remainFrame)
  -- function num : 0_2
  self.__updateInvinciable = updateInvinciable
  self.__invinciableRemainFrame = remainFrame
end

FlappyBird_Bird.ReSetVelocity = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

  (self.velocity).x = 0
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.velocity).y = 0
end

FlappyBird_Bird.SetInvinciable = function(self, value, duration)
  -- function num : 0_4
  if self.__invinciable ~= value then
    self.__invinciable = value
  end
  self.invinciableDuration = duration
end

FlappyBird_Bird.UpdateInvinciable = function(self)
  -- function num : 0_5
  if not self.__invinciable then
    return 
  end
  if self.invinciableDuration <= 0 then
    self:SetInvinciable(false, 0)
    self.remainInvinciable = false
    if self.__updateInvinciable ~= nil then
      (self.__updateInvinciable)(false)
    end
  else
    self.invinciableDuration = self.invinciableDuration - 1
    if self.invinciableDuration <= self.__invinciableRemainFrame and not self.remainInvinciable then
      self.remainInvinciable = true
      ;
      (self.__updateInvinciable)(true, 3)
    end
  end
end

FlappyBird_Bird.IsInvinciable = function(self)
  -- function num : 0_6
  return self.__invinciable
end

FlappyBird_Bird.Jump = function(self, jumpForce)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.velocity).y = jumpForce
  if not self.__firstJump then
    self.__firstJump = true
    self:SetGravityInfluenceEnable(true)
  end
end

FlappyBird_Bird.IsCompletedFirstJump = function(self)
  -- function num : 0_8
  return self.__firstJump
end

FlappyBird_Bird.OnUpdateLogic = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnUpdateLogic)(self)
  if self:IsInvinciable() then
    self:UpdateInvinciable()
  end
end

FlappyBird_Bird.ResetBird = function(self)
  -- function num : 0_10
  self.remainInvinciable = false
  self.__firstJump = false
  self:SetGravityInfluenceEnable(false)
  self:SetPos(0, 0)
  self:ReSetVelocity()
end

return FlappyBird_Bird

