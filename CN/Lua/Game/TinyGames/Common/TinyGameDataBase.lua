-- params : ...
-- function num : 0 , upvalues : _ENV
local TinyGameDataBase = class("TinyGameDataBase")
local TinyGameUtil = require("Game.TinyGames.TinyGameUtil")
TinyGameDataBase.ctor = function(self, uid, gameId, cat)
  -- function num : 0_0
  self._uid = uid
  self._cat = cat
  self._gameId = gameId
  self:__GetTinyGameData()
end

TinyGameDataBase.__GetTinyGameData = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._gameData = activityFrameCtrl:GetTinyGameData(self._uid)
end

TinyGameDataBase.GetTinyGameHistoryScore = function(self)
  -- function num : 0_2
  if self._gameData == nil then
    self:__GetTinyGameData()
  end
  return self._gameData ~= nil and (self._gameData):GetTinyGameHighest() or 0
end

TinyGameDataBase.GetTinyGameRankInfo = function(self)
  -- function num : 0_3 , upvalues : TinyGameUtil, _ENV
  local mineGrade = (TinyGameUtil.CreateMineTinyGameGrade)(self:GetTinyGameHistoryScore())
  local allFriendRanks = (TinyGameUtil.CreateFriendTinyGameDatas)(self._cat, self._gameId)
  ;
  (table.insert)(allFriendRanks, mineGrade)
  return allFriendRanks, mineGrade
end

TinyGameDataBase.UploadTinyGameScore = function(self, score, callback)
  -- function num : 0_4 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_TinyGame_Settle(self._uid, score, callback)
end

return TinyGameDataBase

