-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityTinyGameData = class("ActivityTinyGameData")
ActivityTinyGameData.UpdateTinyGameData = function(self, tinyGameMsg)
  -- function num : 0_0
  self._uid = tinyGameMsg.uid
  self._id = tinyGameMsg.id
  self._cat = tinyGameMsg.cat
  self._actLongId = tinyGameMsg.actLongId
  self._score = tinyGameMsg.score
  self._highest = tinyGameMsg.highest
end

ActivityTinyGameData.GetTinyGameUid = function(self)
  -- function num : 0_1
  return self._uid
end

ActivityTinyGameData.GetTinyGameId = function(self)
  -- function num : 0_2
  return self._id
end

ActivityTinyGameData.GetTinyGameCat = function(self)
  -- function num : 0_3
  return self._cat
end

ActivityTinyGameData.GetTinyGameActFrameId = function(self)
  -- function num : 0_4
  return self._actLongId
end

ActivityTinyGameData.GetTinyGameHighest = function(self)
  -- function num : 0_5
  return self._highest
end

return ActivityTinyGameData

