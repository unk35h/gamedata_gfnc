-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessSeasonAddtionData = class("WarChessSeasonAddtionData")
WarChessSeasonAddtionData.SetSeasonScoreData = function(self, score, maxScore)
  -- function num : 0_0 , upvalues : _ENV
  self._score = score
  self._maxScore = maxScore
  MsgCenter:Broadcast(eMsgEventId.WCS_ExtraneouslyRefresh)
end

WarChessSeasonAddtionData.SetSeasonScoreToken = function(self, itemId)
  -- function num : 0_1
  self._tokenItemId = itemId
end

WarChessSeasonAddtionData.SetSeasonCompleteFloor = function(self, floor)
  -- function num : 0_2
  self._completeFloor = floor
end

WarChessSeasonAddtionData.SetSeasonCompleteFloorTip = function(self, tip)
  -- function num : 0_3
  self._completeFloorTip = tip
end

WarChessSeasonAddtionData.SetSeasonHighesScore = function(self, score)
  -- function num : 0_4
  self._highesScore = score
end

WarChessSeasonAddtionData.SetSelectLevelTokenCallback = function(self, callback)
  -- function num : 0_5
  self._selectLevelTokenCallback = callback
end

WarChessSeasonAddtionData.SetSeasonRecommendPower = function(self, power)
  -- function num : 0_6
  self._recommonPower = power
end

WarChessSeasonAddtionData.SetSeasonSaveUIType = function(self, uiWindowType)
  -- function num : 0_7
  self._saveUIWindowType = uiWindowType
end

WarChessSeasonAddtionData.GetSeasonScoreToken = function(self)
  -- function num : 0_8
  return self._tokenItemId
end

WarChessSeasonAddtionData.GetSeasonScore = function(self)
  -- function num : 0_9
  return self._score, self._maxScore
end

WarChessSeasonAddtionData.GetSeasonCompleteFloor = function(self)
  -- function num : 0_10
  return self._completeFloor
end

WarChessSeasonAddtionData.GetSeasonCompleteFloorTip = function(self)
  -- function num : 0_11
  return self._completeFloorTip
end

WarChessSeasonAddtionData.IsSetSeasonCompleteFloor = function(self)
  -- function num : 0_12
  do return self._completeFloor ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessSeasonAddtionData.GetSeasonHighesScore = function(self)
  -- function num : 0_13
  return self._highesScore or 0
end

WarChessSeasonAddtionData.GetSelectLevelTokenCallback = function(self)
  -- function num : 0_14
  return self._selectLevelTokenCallback
end

WarChessSeasonAddtionData.GetSeasonRecommendPower = function(self)
  -- function num : 0_15
  return self._recommonPower
end

WarChessSeasonAddtionData.GetSeasonSaveUIType = function(self)
  -- function num : 0_16
  return self._saveUIWindowType
end

return WarChessSeasonAddtionData

