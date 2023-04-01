-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local CarnivalDungeonLevelData = class("CarnivalDungeonLevelData", DungeonLevelBase)
local base = DungeonLevelBase
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
CarnivalDungeonLevelData.SetCarnivalLevelPic = function(self, pic)
  -- function num : 0_0
  self._carnivalLevelPic = pic
end

CarnivalDungeonLevelData.GetDungeonLevelPic = function(self)
  -- function num : 0_1
  return self._carnivalLevelPic
end

CarnivalDungeonLevelData.GetDungeonLevelType = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).Carnival
end

CarnivalDungeonLevelData.GetDungeonInfoDesc = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._carnivalLevelCfg == nil then
    self._carnivalLevelCfg = (ConfigData.activity_carnival_level_detail)[self:GetDungeonLevelStageId()]
  end
  if self._carnivalLevelCfg == nil then
    return ""
  end
  return (LanguageUtil.GetLocaleText)((self._carnivalLevelCfg).level_des)
end

return CarnivalDungeonLevelData

