-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHistoryTinyGame.HTGPlayer.Base.HTGPlayerBase")
local _2048TinyGameData = class("_2048TinyGameData", base)
_2048TinyGameData.ctor = function(self, tinyGameType, tinyGameInstanceId)
  -- function num : 0_0
end

_2048TinyGameData.EnterTinyGame = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local Game2048Controller = require("Game.TinyGames.2048.Game2048Controller")
  local gameCtrl = (Game2048Controller.New)()
  local actFrameId = self.actFrameId
  local instanceId = self.__tinyGameInstanceId
  gameCtrl:InitGame2048(actFrameId, instanceId, nil, true, self)
end

return _2048TinyGameData

