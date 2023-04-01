-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22Ball = class("UINCarnival22Ball", UIBaseNode)
local base = UIBaseNode
UINCarnival22Ball.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  local collider2DTrigger = ((CS.ColliderEventListener).Get)(self.transform)
  collider2DTrigger:CollisionEnter2DEvent("+", BindCallback(self, self.__CollisionEnter))
end

UINCarnival22Ball.InitWaltermelonItem = function(self, id, collisionCallback)
  -- function num : 0_1
  self._id = id
  self._callback = collisionCallback
end

UINCarnival22Ball.GetWaltermelonType = function(self)
  -- function num : 0_2
  return self._id
end

UINCarnival22Ball.SetRigidBody = function(self, flag)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).rigidbody).simulated = flag
end

UINCarnival22Ball.GetRigidSpeed = function(self)
  -- function num : 0_4
  return ((self.ui).rigidbody).velocity
end

UINCarnival22Ball.GetColliderRadius = function(self)
  -- function num : 0_5
  return ((self.transform).rect).width / 2
end

UINCarnival22Ball.__CollisionEnter = function(self, other)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self, other)
  end
end

return UINCarnival22Ball

