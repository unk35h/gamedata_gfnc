-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Interact.Base.WCI_Base")
local WCI_Store = class("WCI_Store", base)
WCI_Store.ctor = function(self)
  -- function num : 0_0
  self.needWalk = true
  self.isWalk2NearBy = true
end

WCI_Store.PlayWCActOverAudio = function(self)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(1244)
end

return WCI_Store

