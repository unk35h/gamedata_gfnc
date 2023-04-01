-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessStateBase = class("WarChessStateBase")
WarChessStateBase.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.wcCtrl = wcCtrl
end

WarChessStateBase.EnterState = function(self, enterArgs)
  -- function num : 0_1
  self:OnEnterState(enterArgs)
end

WarChessStateBase.OnEnterState = function(self)
  -- function num : 0_2
end

WarChessStateBase.ExitState = function(self)
  -- function num : 0_3
  self:OnExitState()
end

WarChessStateBase.OnExitState = function(self)
  -- function num : 0_4
end

WarChessStateBase.IsCanOpenMenu = function(self)
  -- function num : 0_5
  return true
end

return WarChessStateBase

