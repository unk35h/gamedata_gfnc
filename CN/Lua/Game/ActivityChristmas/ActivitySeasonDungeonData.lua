-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.DungeonCenter.Data.DungeonLevelBase")
local ActivitySeasonDungeonData = class("ActivitySeasonDungeonData", base)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
ActivitySeasonDungeonData.ctor = function(self, stageId, __seasonDunCfg, seasonId, index)
  -- function num : 0_0
  self.__seasonId = seasonId
  self.__seasonDunCfg = __seasonDunCfg
  self.__index = index
end

ActivitySeasonDungeonData.GetDungeonIndex = function(self)
  -- function num : 0_1
  return self.__index
end

ActivitySeasonDungeonData.GetSeasonId = function(self)
  -- function num : 0_2
  return self.__seasonId
end

ActivitySeasonDungeonData.GetDungeonLevelType = function(self)
  -- function num : 0_3 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).Season
end

ActivitySeasonDungeonData.GetDungeonInfoDesc = function(self)
  -- function num : 0_4 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__seasonDunCfg).level_des)
end

ActivitySeasonDungeonData.GetDungeonLevelPic = function(self)
  -- function num : 0_5
  return (self.__seasonDunCfg).level_pic
end

ActivitySeasonDungeonData.GetCouldShowAutoPlay = function(self)
  -- function num : 0_6
  return true
end

ActivitySeasonDungeonData.GetIsLevelCompleteNoSup = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local isCompleted = (PlayerDataCenter.dungeonComplectedWhithoutSupport)[self:GetDungeonLevelStageId()] or false
  return isCompleted
end

ActivitySeasonDungeonData.GetLevelUnlockConditionCfg = function(self)
  -- function num : 0_8
  return (self.__seasonDunCfg).pre1_condition, (self.__seasonDunCfg).pre1_para1, (self.__seasonDunCfg).pre1_para2, (self.__seasonDunCfg).pre2_condition, (self.__seasonDunCfg).pre2_para1, (self.__seasonDunCfg).pre2_para2, (self.__seasonDunCfg).pre3_condition, (self.__seasonDunCfg).pre3_para1, (self.__seasonDunCfg).pre3_para2
end

ActivitySeasonDungeonData.GetSpecialUnlockInfo = function(self)
  -- function num : 0_9
  return (self.__seasonDunCfg).pre_desc
end

ActivitySeasonDungeonData.GetIsLevelUnlock = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local pre1_condition, pre1_para1, pre1_para2, pre2_condition, pre2_para1, pre2_para2, pre3_condition, pre3_para1, pre3_para2 = self:GetLevelUnlockConditionCfg()
  local lock1 = (CheckCondition.CheckLua)(pre1_condition, pre1_para1, pre1_para2)
  local lock2 = false
  local lock3 = false
  if lock1 then
    return true
  end
  if #pre2_condition > 0 then
    lock2 = (CheckCondition.CheckLua)(pre2_condition, pre2_para1, pre2_para2)
  end
  if lock2 then
    return true
  end
  if #pre3_condition > 0 then
    lock3 = (CheckCondition.CheckLua)(pre3_condition, pre3_para1, pre3_para2)
  end
  return lock3
end

ActivitySeasonDungeonData.GetCommonActDropData = function(self)
  -- function num : 0_11
  return (self.__seasonDunCfg).drop_show
end

return ActivitySeasonDungeonData

