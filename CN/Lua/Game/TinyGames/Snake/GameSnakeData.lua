-- params : ...
-- function num : 0 , upvalues : _ENV
local TinyGameDataBase = require("Game.TinyGames.Common.TinyGameDataBase")
local GameSnakeData = class("GameSnakeData", TinyGameDataBase)
local TinyGameUtil = require("Game.TinyGames.TinyGameUtil")
GameSnakeData.ctor = function(self, uid, gameId, cat)
  -- function num : 0_0 , upvalues : _ENV
  self._cfg = (ConfigData.tiny_snake)[gameId]
end

GameSnakeData.GetSnakeRewardState = function(self)
  -- function num : 0_1
  local maxScore = self:GetTinyGameHistoryScore()
  local isRewarded = (self._cfg).join_score <= maxScore
  do return (self._cfg).join_score, isRewarded end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

GameSnakeData.GetSnakeGameReward = function(self)
  -- function num : 0_2
  return (self._cfg).join_reward_ids, (self._cfg).join_reward_nums
end

GameSnakeData.GetSnakeRuleId = function(self)
  -- function num : 0_3
  return (self._cfg).snake_guide_id
end

return GameSnakeData

