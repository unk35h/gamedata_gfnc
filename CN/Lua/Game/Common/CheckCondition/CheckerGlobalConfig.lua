-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerTypeId = {PlayerLevel = 1, CompleteTask = 2, CompleteStage = 3, BuildingLevel = 4, FunctionUnlock = 5, FrienshipLevel = 6, CompleteDungeon = 7, CompleteAvg = 8, MinHeroStar = 9, MaxHeroStar = 10, InfinityDungeon = 11, TimeRange = 12, PlayerLevelUpLimit = 13, UserChannel = 14, StOCareerLevelLimit = 16, CharDungeonConsume = 18, DungeonTowerUnlock = 19, ActivityOpen = 21, ActivityTechBranchLevel = 22, ActivityLevel = 23, HeroPotential = 24, HeroLevel = 25, ActivityTask = 26, SectorStagePassTm = 27, WarChessSeasonPassDiff = 28, SkinVoice = 29, LastLoginBefore = 32, WarChessSeasonPassDiffInterval = 33}
local CheckerExtra = {}
CheckerExtra.CheckerActivityType = {[CheckerTypeId.ActivityOpen] = true, [CheckerTypeId.ActivityTechBranchLevel] = true, [CheckerTypeId.ActivityLevel] = true}
CheckerExtra.IsHasActivityChecker = function(checkerTypes)
  -- function num : 0_0 , upvalues : _ENV, CheckerExtra
  if checkerTypes == nil then
    return false
  end
  for _,checkerType in ipairs(checkerTypes) do
    if (CheckerExtra.CheckerActivityType)[checkerType] then
      return true
    end
  end
  return false
end

local CheckerGlobalConfig = {
[CheckerTypeId.PlayerLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerPlayLevel")}
, 
[CheckerTypeId.CompleteTask] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerTask")}
, 
[CheckerTypeId.CompleteStage] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerSectorStage")}
, 
[CheckerTypeId.BuildingLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerBuilding")}
, 
[CheckerTypeId.FunctionUnlock] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerFuncUnlock")}
, 
[CheckerTypeId.FrienshipLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CherkerFriendshipLevel")}
, 
[CheckerTypeId.CompleteDungeon] = {Checker = require("Game.Common.CheckCondition.Checker.CherkerGeneralDungeon")}
, 
[CheckerTypeId.CompleteAvg] = {Checker = require("Game.Common.CheckCondition.Checker.CheckAvg")}
, 
[CheckerTypeId.MinHeroStar] = {Checker = require("Game.Common.CheckCondition.Checker.CheckMinHeroStar")}
, 
[CheckerTypeId.MaxHeroStar] = {Checker = require("Game.Common.CheckCondition.Checker.CheckMaxHeroStar")}
, 
[CheckerTypeId.InfinityDungeon] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerInfinityDungeon")}
, 
[CheckerTypeId.TimeRange] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerTimeRange")}
, 
[CheckerTypeId.PlayerLevelUpLimit] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerPlayerLevelUpLimit")}
, 
[CheckerTypeId.UserChannel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerUserChannel")}
, 
[CheckerTypeId.StOCareerLevelLimit] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerStOCareerLevel")}
, 
[CheckerTypeId.CharDungeonConsume] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerCharDungeonConsume")}
, 
[CheckerTypeId.DungeonTowerUnlock] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerDungeonTower")}
, 
[CheckerTypeId.ActivityOpen] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerActivity")}
, 
[CheckerTypeId.ActivityTechBranchLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerActivityTechBranchLevel")}
, 
[CheckerTypeId.ActivityLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerActivityLevel")}
, 
[CheckerTypeId.HeroPotential] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerHeroPotential")}
, 
[CheckerTypeId.HeroLevel] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerHeroLevel")}
, 
[CheckerTypeId.ActivityTask] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerActivityTask")}
, 
[CheckerTypeId.SectorStagePassTm] = {Checker = require("Game.Common.CheckCondition.Checker.CheckSectorStagePassTm")}
, 
[CheckerTypeId.SkinVoice] = {Checker = require("Game.Common.CheckCondition.Checker.CheckSkinVoice")}
, 
[CheckerTypeId.WarChessSeasonPassDiff] = {Checker = require("Game.Common.CheckCondition.Checker.CheckWarChessSeasonPassDiff")}
, 
[CheckerTypeId.LastLoginBefore] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerLastLoginBefore")}
, 
[CheckerTypeId.WarChessSeasonPassDiffInterval] = {Checker = require("Game.Common.CheckCondition.Checker.CheckerWarChessSeasonPassDiffInterval")}
}
local ChckerCfg = {CheckerTypeId, CheckerGlobalConfig, CheckerExtra}
return ChckerCfg

