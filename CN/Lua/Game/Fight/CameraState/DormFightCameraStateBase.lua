-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightCameraStateBase = class("DormFightCameraStateBase")
DormFightCameraStateBase.Init = function(self, owner)
  -- function num : 0_0
  self._owner = owner
  self:OnInit()
end

DormFightCameraStateBase.OnInit = function(self)
  -- function num : 0_1
end

DormFightCameraStateBase.OnEnter = function(self, prevState)
  -- function num : 0_2
end

DormFightCameraStateBase.OnExit = function(self, nextState)
  -- function num : 0_3
end

DormFightCameraStateBase.OnUpdate = function(self, deltaTime)
  -- function num : 0_4
end

return DormFightCameraStateBase

