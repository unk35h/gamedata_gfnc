-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_StandSwitch = class("WCI_StandSwitch", base)
WCI_StandSwitch.ctor = function(self)
  -- function num : 0_0
  self.needWalk = true
  self.isWalk2NearBy = false
end

return WCI_StandSwitch

