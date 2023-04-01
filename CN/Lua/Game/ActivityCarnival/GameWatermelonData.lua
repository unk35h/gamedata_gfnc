-- params : ...
-- function num : 0 , upvalues : _ENV
local GameWatermelonData = class("GameWatermelonData")
local TinyGameEnum = require("Game.TinyGames.TinyGameEnum")
GameWatermelonData.ctor = function(self, uid, gameId)
  -- function num : 0_0 , upvalues : _ENV
  self._uid = uid
  self._gameId = gameId
  self._cfg = (ConfigData.mash_up)[gameId]
  self:__GetTinyGameData()
end

GameWatermelonData.GetWatermeScore = function(self, index)
  -- function num : 0_1
  return ((self._cfg).score_per_ball)[index] or 0
end

GameWatermelonData.GetWatermeRank = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not self:__GenFirendScoreData() then
    local allFriendData = {}
  end
  local mineGrade = self:__GenMineScoreData()
  ;
  (table.insert)(allFriendData, mineGrade)
  self:__SortFriendData(allFriendData)
  return allFriendData, mineGrade
end

GameWatermelonData.UploadWatermelonScore = function(self, score, callback)
  -- function num : 0_3 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_TinyGame_Settle(self._uid, score, callback)
end

GameWatermelonData.GetWatermeHistoryScore = function(self)
  -- function num : 0_4
  if self._gameData == nil then
    self:__GetTinyGameData()
  end
  return self._gameData ~= nil and (self._gameData):GetTinyGameHighest() or 0
end

GameWatermelonData.__GetTinyGameData = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._gameData = activityFrameCtrl:GetTinyGameData(self._uid)
end

GameWatermelonData.__GenFirendScoreData = function(self)
  -- function num : 0_6 , upvalues : _ENV, TinyGameEnum
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendsData = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendsData == nil or #friendsData <= 0 then
    return nil
  end
  local allScoreGrades = {}
  for _,v in ipairs(friendsData) do
    local eachFriendGrade = {}
    eachFriendGrade.name = v:GetUserName()
    eachFriendGrade.score = 0
    eachFriendGrade.uid = v:GetUserUID()
    local tinyGame = v:GetTinyGameData((TinyGameEnum.eType).ballMerge, self._gameId)
    if tinyGame ~= nil then
      eachFriendGrade.score = tinyGame.score
    end
    ;
    (table.insert)(allScoreGrades, eachFriendGrade)
  end
  return allScoreGrades
end

GameWatermelonData.__GenMineScoreData = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._mineGrade == nil then
    self._mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._mineGrade).score = self._gameData ~= nil and (self._gameData):GetTinyGameHighest() or 0
  return self._mineGrade
end

GameWatermelonData.__SortFriendData = function(self, allFriendData)
  -- function num : 0_8 , upvalues : _ENV
  if #allFriendData <= 1 then
    return 
  end
  ;
  (table.sort)(allFriendData, function(a, b)
    -- function num : 0_8_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
end

return GameWatermelonData

