-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Battle = class("WCI_Battle", base)
WCI_Battle.ctor = function(self)
  -- function num : 0_0
  self.needWalk = not self:WCIsTeamOnPoint()
  self.isWalk2NearBy = true
end

WCI_Battle.PlayWCActOverAudio = function(self)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(1237)
end

return WCI_Battle

