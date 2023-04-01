-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local DungeonLevelHeroGrow = class("DungeonLevelHeroGrow", DungeonLevelBase)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
DungeonLevelHeroGrow.SetDungeonHeroGrowAct = function(self, activityHeroData)
  -- function num : 0_0 , upvalues : _ENV
  self._activityHeroData = activityHeroData
  self._extraCfg = (ConfigData.activity_hero_level_detail)[self.__stageId]
end

DungeonLevelHeroGrow.GetDungeonHeroGrowActId = function(self)
  -- function num : 0_1
  return (self._activityHeroData):GetActId()
end

DungeonLevelHeroGrow.GetDungeonActName = function(self)
  -- function num : 0_2
  return (self._activityHeroData):GetActivityName()
end

DungeonLevelHeroGrow.GetDungeonLevelType = function(self)
  -- function num : 0_3 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).HeroGrow
end

DungeonLevelHeroGrow.GetDungeonLevelName = function(self)
  -- function num : 0_4 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__dungeonStageCfg).name)
end

DungeonLevelHeroGrow.GetDungeonInfoDesc = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._extraCfg).level_des)
end

DungeonLevelHeroGrow.GetDungeonLevelPic = function(self)
  -- function num : 0_6
  return (self._extraCfg).level_pic
end

DungeonLevelBase.GetEnterLevelCost = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local costId = ((self.__dungeonStageCfg).cost_itemIds)[1]
  if costId == nil then
    costId = ConstGlobalItem.SKey
  end
  return costId
end

DungeonLevelBase.GetConsumeKeyNum = function(self)
  -- function num : 0_8
  local costNum = ((self.__dungeonStageCfg).cost_itemNums)[1]
  if costNum == nil then
    costNum = 0
  end
  return costNum
end

DungeonLevelHeroGrow.GetCouldShowAutoPlay = function(self)
  -- function num : 0_9
  return true
end

DungeonLevelHeroGrow.GetCommonActDropData = function(self)
  -- function num : 0_10
  return (self._extraCfg).drop_show
end

DungeonLevelHeroGrow.GetIsLevelCompleteNoSup = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local isCompleted = (PlayerDataCenter.dungeonComplectedWhithoutSupport)[self:GetDungeonLevelStageId()] or false
  return isCompleted
end

return DungeonLevelHeroGrow

