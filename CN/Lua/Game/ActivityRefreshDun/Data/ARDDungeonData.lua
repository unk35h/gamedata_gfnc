-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local ARDDungeonData = class("ARDDungeonData", DungeonLevelBase)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
ARDDungeonData.ctor = function(self, dungeonStageId, isComplete, ARDData)
  -- function num : 0_0 , upvalues : _ENV
  self.__dungeonId = dungeonStageId
  self.__IsCompleted = isComplete
  self.ARDData = ARDData
  self.__dungeonCfg = (ConfigData.activity_refresh_dungeon_dun)[dungeonStageId]
  assert(self.__dungeonCfg ~= nil, "dungeonCfg is nil,dungeonId:" .. tostring(dungeonStageId))
  self.__heroCfg = (ConfigData.activity_refresh_dungeon_hero)[(self.__dungeonCfg).hero_id]
  assert(self.__heroCfg ~= nil, "heroCfg is nil,hero_id:" .. tostring((self.__dungeonCfg).hero_id))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ARDDungeonData.GetDungeonLevelType = function(self)
  -- function num : 0_1 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).AprilFool
end

ARDDungeonData.GetARDDunId = function(self)
  -- function num : 0_2
  return self.__dungeonId
end

ARDDungeonData.GetARDDunIsCompleted = function(self)
  -- function num : 0_3
  return self.__IsCompleted
end

ARDDungeonData.GetARDDunCfg = function(self)
  -- function num : 0_4
  return self.__dungeonCfg
end

ARDDungeonData.GetARDDLevelPicName = function(self)
  -- function num : 0_5
  return (self.__heroCfg).pic
end

ARDDungeonData.GetARDDLevelTag = function(self)
  -- function num : 0_6
  return (self.__dungeonCfg).difficulty
end

ARDDungeonData.GetCouldExchange = function(self)
  -- function num : 0_7
  if self:GetARDDunIsCompleted() then
    return false
  end
  return true
end

ARDDungeonData.GetARDDAvgId = function(self)
  -- function num : 0_8
  return (self.__heroCfg).avg_id
end

return ARDDungeonData

