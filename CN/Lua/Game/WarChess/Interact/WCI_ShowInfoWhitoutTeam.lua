-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.WCI_ShowInfo")
local WCI_ShowInfoWhitoutTeam = class("WCI_ShowInfoWhitoutTeam", base)
WCI_ShowInfoWhitoutTeam.ctor = function(self)
  -- function num : 0_0
  self.needWalk = false
end

return WCI_ShowInfoWhitoutTeam

