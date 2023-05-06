-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.ActivitySeasonDungeonData")
local ActivitySeasonDungeonDataI = class("ActivitySeasonDungeonDataI", base)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
ActivitySeasonDungeonDataI.GetDungeonNameEn = function(self)
  -- function num : 0_0
  return (self.__seasonDunCfg).level_name_en
end

ActivitySeasonDungeonDataI.GetDungeonIcon = function(self)
  -- function num : 0_1
  return (self.__seasonDunCfg).level_icon
end

ActivitySeasonDungeonDataI.GetDungeonLevelType = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).SeasonI
end

return ActivitySeasonDungeonDataI

