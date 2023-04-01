-- params : ...
-- function num : 0 , upvalues : _ENV
local HTGPlayerBase = class("HTGPlayerBase")
HTGPlayerBase.ctor = function(self, tinyGameData, selfHistoryHighScore, playEndTime)
  -- function num : 0_0
  self.__tinyGameData = tinyGameData
  self.__tinyGameUID = tinyGameData:GetTinyGameUid()
  self.__tinyGameType = tinyGameData:GetTinyGameCat()
  self.__tinyGameInstanceId = tinyGameData:GetTinyGameId()
  self.__playEndTime = playEndTime
  self.__selfHistoryHighScore = selfHistoryHighScore
  self.__selfHighScore = tinyGameData:GetTinyGameHighest()
  self.__rankData = {}
  self:InitTinyGameData()
  self:UpdateRankData()
end

HTGPlayerBase.InitTinyGameData = function(self)
  -- function num : 0_1
end

HTGPlayerBase.EnterTinyGame = function(self)
  -- function num : 0_2 , upvalues : _ENV
  error("please write specific tiny game enter func for every tiny game")
end

HTGPlayerBase.UpdateSelfHighScore = function(self)
  -- function num : 0_3
  self.__selfHighScore = (self.__tinyGameData):GetTinyGameHighest()
  return self.__selfHighScore
end

HTGPlayerBase.UpdateRankData = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local mineGrade = self:__CreateMineGrade()
  if not self:__GetFriendGradeData() then
    local allFriendData = {}
  end
  ;
  (table.insert)(allFriendData, mineGrade)
  self:__SortRankData(allFriendData)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__rankData).mineGrade = mineGrade
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__rankData).allFriendData = allFriendData
end

HTGPlayerBase.__CreateMineGrade = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.mineGrade == nil then
    self.mineGrade = {}
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).uid = PlayerDataCenter:GetSelfId()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).name = PlayerDataCenter:GetSelfName()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.mineGrade).score = self.__selfHighScore
  return self.mineGrade
end

HTGPlayerBase.__GetFriendGradeData = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not (PlayerDataCenter.friendDataCenter):IsFriendDataCenterInited() then
    return nil
  end
  local friendDataList = (PlayerDataCenter.friendDataCenter):GetFreindList()
  if friendDataList == nil or #friendDataList <= 0 then
    return nil
  end
  local allGrades = {}
  for _,friendData in ipairs(friendDataList) do
    local eachFriendGrade = {}
    eachFriendGrade.uid = friendData:GetUserUID()
    eachFriendGrade.name = friendData:GetUserName()
    eachFriendGrade.score = 0
    local tinyGameData = friendData:GetTinyGameData(self.__tinyGameType, self.__tinyGameInstanceId)
    if tinyGameData ~= nil then
      eachFriendGrade.score = tinyGameData.score
    end
    ;
    (table.insert)(allGrades, eachFriendGrade)
  end
  return allGrades
end

HTGPlayerBase.__SortRankData = function(self, allFriendData)
  -- function num : 0_7 , upvalues : _ENV
  if #allFriendData > 1 then
    (table.sort)(allFriendData, function(a, b)
    -- function num : 0_7_0
    if a.uid >= b.uid then
      do return a.score ~= b.score end
      do return b.score < a.score end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  end
end

HTGPlayerBase.GetHTGMineRank = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if (self.__rankData).mineGrade == nil then
    return 0
  end
  if (self.__rankData).allFriendData == nil then
    return 1
  end
  return (table.indexof)((self.__rankData).allFriendData, (self.__rankData).mineGrade)
end

HTGPlayerBase.GetTinyGameType = function(self)
  -- function num : 0_9
  return self.__tinyGameType
end

HTGPlayerBase.GetPlayEndTime = function(self)
  -- function num : 0_10
  return self.__playEndTime or 0
end

HTGPlayerBase.GetPlayEndTimeStr = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local time = self:GetPlayEndTime()
  local date = TimeUtil:TimestampToDate(time)
  return (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
end

HTGPlayerBase.GetHTGRankData = function(self)
  -- function num : 0_12
  self:UpdateRankData()
  return self.__rankData
end

HTGPlayerBase.GetHTGHistoryHighScore = function(self)
  -- function num : 0_13
  return self.__selfHistoryHighScore or 0
end

HTGPlayerBase.HTGCommonSettle = function(self, score, callback)
  -- function num : 0_14 , upvalues : _ENV
  local activityFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNet:CS_TinyGame_Settle(self.__tinyGameUID, score, function(msg)
    -- function num : 0_14_0 , upvalues : _ENV, self, callback
    if msg.Count <= 0 then
      error("CS_TinyGame_Settle msg.Count error:" .. tostring(msg.Count))
      return 
    end
    local tinyGameCenterElem = msg[0]
    if self:GetHTGHistoryHighScore() < tinyGameCenterElem.highest then
      self.__selfHistoryHighScore = tinyGameCenterElem.highest
    end
    self:UpdateSelfHighScore()
    self:UpdateRankData()
    if callback ~= nil then
      callback(tinyGameCenterElem)
    end
  end
)
end

return HTGPlayerBase

