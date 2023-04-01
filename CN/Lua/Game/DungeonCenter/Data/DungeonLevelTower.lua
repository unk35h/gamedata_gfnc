-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local DungeonLevelTower = class("DungeonLevelTower", DungeonLevelBase)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
DungeonLevelTower.ctor = function(self, stageId)
  -- function num : 0_0 , upvalues : _ENV
  self.__dungeonTowerCfg = (ConfigData.dungeon_tower)[stageId]
  if self.__dungeonTowerCfg == nil then
    error("dungeon tower cfg is null:id:" .. tostring(stageId))
  end
end

DungeonLevelTower.BindLevelTowerTypeData = function(self, towerTypeData)
  -- function num : 0_1
  self.__towerTypeData = towerTypeData
end

DungeonLevelTower.GetLevelTowerTypeData = function(self)
  -- function num : 0_2
  return self.__towerTypeData
end

DungeonLevelTower.IsTwinTowerLevel = function(self)
  -- function num : 0_3
  return (self.__towerTypeData):IsTypeTwinTower()
end

DungeonLevelTower.GetDungeonLevelType = function(self)
  -- function num : 0_4 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).Tower
end

DungeonLevelBase.GetDungeonInfoDesc = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__dungeonTowerCfg).level_des)
end

DungeonLevelBase.GetDungeonLevelPic = function(self)
  -- function num : 0_6
  return (self.__dungeonTowerCfg).level_pic
end

DungeonLevelTower.GetDunTowerLevelNum = function(self)
  -- function num : 0_7
  return (self.__dungeonTowerCfg).level_num
end

DungeonLevelTower.IsTowerFlagLevel = function(self)
  -- function num : 0_8
  return (self.__dungeonTowerCfg).flag_level
end

DungeonLevelTower.GetDungeonTowerType = function(self)
  -- function num : 0_9
  return (self.__dungeonTowerCfg).tower_type
end

DungeonLevelTower.HasRecommendFormation = function(self)
  -- function num : 0_10
  return (self.__dungeonTowerCfg).team_record
end

DungeonLevelTower.GetTowerTypeTotalLevel = function(self)
  -- function num : 0_11
  return (self.__towerTypeData):GetTowerTotalLevel()
end

DungeonLevelTower.HasNextTowerLevel = function(self)
  -- function num : 0_12
  do return self:GetDunTowerLevelNum() < (self.__towerTypeData):GetTowerTotalLevel() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonLevelTower.GetNextTowerLevelData = function(self)
  -- function num : 0_13
  local nextLevelData = (self.__towerTypeData):GetTowerLevelByNum(self:GetDunTowerLevelNum() + 1)
  return nextLevelData
end

DungeonLevelTower.GetTowerLevelNounId = function(self)
  -- function num : 0_14
  return (self.__dungeonTowerCfg).tower_noun
end

DungeonLevelTower.GetTowerChipSelectMax = function(self)
  -- function num : 0_15
  return (self.__dungeonTowerCfg).chip_select_max
end

DungeonLevelTower.GetTowerChipQuality = function(self)
  -- function num : 0_16
  return (self.__dungeonTowerCfg).chip_quality
end

DungeonLevelTower.GetTowerChipSuitPool = function(self)
  -- function num : 0_17
  return (self.__dungeonTowerCfg).chip_pool
end

DungeonLevelTower.GetTowerTypeName = function(self)
  -- function num : 0_18
  return (self.__towerTypeData):GetDungeonTowerName()
end

DungeonLevelTower.GetTowerLvName = function(self)
  -- function num : 0_19
  return (self.__towerTypeData):GetDungeonTowerLvName()
end

DungeonLevelTower.GetDunServerRacingFrame = function(self)
  -- function num : 0_20 , upvalues : _ENV
  return (PlayerDataCenter.dungeonTowerSData):GetTowerLevelRacingFrame(self:GetDungeonTowerType(), self:GetDunTowerLevelNum())
end

return DungeonLevelTower

