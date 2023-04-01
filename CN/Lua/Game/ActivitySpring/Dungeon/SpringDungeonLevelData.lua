-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local SpringDungeonLevelData = class("CarnivalDungeonLevelData", DungeonLevelBase)
local base = DungeonLevelBase
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
SpringDungeonLevelData.ctor = function(self, stageId, levelCfg, index)
  -- function num : 0_0
  self.levelCfg = levelCfg
  self.__index = index
end

SpringDungeonLevelData.SetSpringLevelPic = function(self, pic)
  -- function num : 0_1
  self._springLevelPic = pic
end

SpringDungeonLevelData.GetDungeonLevelPic = function(self)
  -- function num : 0_2
  return self._springLevelPic
end

SpringDungeonLevelData.GetDungeonLevelType = function(self)
  -- function num : 0_3 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).Spring
end

SpringDungeonLevelData.GetDungeonInfoDesc = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._carnivalLevelCfg == nil then
    self._carnivalLevelCfg = (ConfigData.activity_spring_level_detail)[self:GetDungeonLevelStageId()]
  end
  if self._carnivalLevelCfg == nil then
    return ""
  end
  return (LanguageUtil.GetLocaleText)((self._carnivalLevelCfg).level_des)
end

return SpringDungeonLevelData

