-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Switch = class("WCI_Switch", base)
WCI_Switch.ctor = function(self)
  -- function num : 0_0
  self.needWalk = true
  self.isWalk2NearBy = true
end

return WCI_Switch

