-- params : ...
-- function num : 0 , upvalues : _ENV
local ActDungeonLevelCollect = class("ActDungeonLevelCollect")
ActDungeonLevelCollect.InitActDungeonLevelCollect = function(self, dungeonLevelList, actBase)
  -- function num : 0_0
  self._actBase = actBase
  self._dungeonList = dungeonLevelList
end

ActDungeonLevelCollect.SetDungeonLevelCollectName = function(self, cnName, enName)
  -- function num : 0_1
  self._cnName = cnName
  self._enName = enName
end

ActDungeonLevelCollect.GetActDungeonSortList = function(self)
  -- function num : 0_2
  return self._dungeonList
end

ActDungeonLevelCollect.GetActDungeonActBase = function(self)
  -- function num : 0_3
  return self._actBase
end

ActDungeonLevelCollect.GetActDungeonTitle = function(self)
  -- function num : 0_4
  return self._cnName, self._enName
end

return ActDungeonLevelCollect

