-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHistoryTinyGame.HTGPlayer.Base.HTGPlayerBase")
local DamieTinyGameData = class("DamieTinyGameData", base)
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
DamieTinyGameData.ctor = function(self)
  -- function num : 0_0
end

DamieTinyGameData.EnterTinyGame = function(self)
  -- function num : 0_1 , upvalues : _ENV, eDynConfigData
  local actFrameId = nil
  local instanceId = self.__tinyGameInstanceId
  local maxScore = self.__selfHighScore
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
  UIManager:ShowWindowAsync(UIWindowTypeID.AprilGameDamie, function(window)
    -- function num : 0_1_0 , upvalues : actFrameId, instanceId, maxScore, self, _ENV, eDynConfigData
    window:InitDamieWithData(actFrameId, instanceId, maxScore, true, self)
    window:InjectExitAction(function()
      -- function num : 0_1_0_0 , upvalues : _ENV, eDynConfigData
      ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
    end
)
  end
)
end

return DamieTinyGameData

