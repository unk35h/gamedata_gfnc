-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsCtrlBase = class("SmashingPenguinsCtrlBase")
SmashingPenguinsCtrlBase.ctor = function(self, owner)
  -- function num : 0_0 , upvalues : _ENV
  self.owner = owner
  ;
  (table.insert)(owner.ctrls, self)
  self:OnInit()
end

SmashingPenguinsCtrlBase.OnInit = function(self)
  -- function num : 0_1
end

SmashingPenguinsCtrlBase.OnGamePrepare = function(self)
  -- function num : 0_2
end

SmashingPenguinsCtrlBase.OnGameStart = function(self)
  -- function num : 0_3
end

SmashingPenguinsCtrlBase.OnGameEnd = function(self)
  -- function num : 0_4
end

return SmashingPenguinsCtrlBase

