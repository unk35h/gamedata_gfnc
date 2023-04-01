-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHistoryTinyGame.HTGPlayer.Base.HTGPlayerBase")
local FlappyBirdTinyGameData = class("FlappyBirdTinyGameData", base)
FlappyBirdTinyGameData.ctor = function(self, tinyGameType, tinyGameInstanceId)
  -- function num : 0_0
end

FlappyBirdTinyGameData.InitTinyGameData = function(self)
  -- function num : 0_1 , upvalues : base
  (base.InitTinyGameData)(self)
end

FlappyBirdTinyGameData.EnterTinyGame = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local activityFwId = nil
  local birdConfigId = self.__tinyGameInstanceId
  local maxScore = self.__selfHighScore
  local joinRewards = true
  local ctrl = ((require("Game.TinyGames.FlappyBird.Ctrl.FlappyBirdController")).New)(activityFwId, birdConfigId, joinRewards, maxScore, true, self)
  ctrl:InjectExitAction(function()
    -- function num : 0_2_0 , upvalues : _ENV
    (UIUtil.ReShowTopStatus)()
    AudioManager:PlayAudioById(3002)
  end
)
  ctrl:InjectModifyBirdMsgAction(nil, nil)
  ctrl:ShowFlappyBirdUI(true)
  AudioManager:PlayAudioById(1139)
end

return FlappyBirdTinyGameData

