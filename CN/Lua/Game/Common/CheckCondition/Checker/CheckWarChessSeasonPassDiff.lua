-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerWarChessSeasonPassDiff = {}
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
CheckerWarChessSeasonPassDiff.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 3 then
    return true
  end
  return false
end

CheckerWarChessSeasonPassDiff.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local actFrameId = param[2]
  local diffId = param[3]
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameData = actFrameCtrl:GetActivityFrameData(actFrameId)
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Hallowmas then
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
    local seasonData = seasonCtrl:GetHallowmasData(actFrameData:GetActId())
    if seasonData == nil then
      return false
    end
    return (seasonData:GetCompleteDiffDic())[diffId]
  else
    do
      if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Winter23 then
        local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
        local winter23Data = winter23Ctrl:GetWinter23DataByActId(actFrameData:GetActId())
        if winter23Data == nil then
          return false
        end
        local seasonId = winter23Data:GetWinter23WarchessSeasonId()
        local wcsPassedData = WarChessSeasonManager:GetWCSPassedTower()
        local sPassedData = wcsPassedData[seasonId]
        if sPassedData == nil then
          return false
        end
        local passedMap = sPassedData.difficultyRecord
        if passedMap == nil then
          return false
        end
        return passedMap[diffId]
      else
        do
          if isGameDev then
            warn("activity is nil")
          end
          return false
        end
      end
    end
  end
end

CheckerWarChessSeasonPassDiff.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV, ActivityFrameEnum
  local actFrameId = param[2]
  local diffId = param[3]
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameData = actFrameCtrl:GetActivityFrameData(actFrameId)
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Hallowmas then
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
    local seasonData = seasonCtrl:GetHallowmasData(actFrameData:GetActId())
    if seasonData == nil then
      return ""
    end
    local envId = seasonData:GetHallowmasEnvIdByDifficultyId(diffId)
    local envName = (LanguageUtil.GetLocaleText)(((ConfigData.activity_hallowmas_general_env)[envId]).general_env_name)
    local stageInfoCfg = seasonData:GetHallowmasStageInfoCfg()
    return (string.format)(ConfigData:GetTipContent(8709), envName, (LanguageUtil.GetLocaleText)((stageInfoCfg[diffId]).difficulty_name))
  else
    do
      if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Winter23 then
        local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
        local winter23Data = winter23Ctrl:GetWinter23DataByActId(actFrameData:GetActId())
        if winter23Data == nil then
          return false
        end
        local seasonId = winter23Data:GetWinter23WarchessSeasonId()
        local envCfg = WarChessSeasonManager:GetEnvCfgBySeasonAndDiff(seasonId, diffId)
        local envName = (LanguageUtil.GetLocaleText)(envCfg.general_env_name)
        local stageInfoCfg = WarChessSeasonManager:GetWCSStageInfoByDiffId(seasonId, diffId)
        local diffName = (LanguageUtil.GetLocaleText)(stageInfoCfg.difficulty_name)
        return (string.format)(ConfigData:GetTipContent(8709), envName, diffName)
      else
        do
          if isGameDev then
            warn("activity is nil")
          end
          return ""
        end
      end
    end
  end
end

return CheckerWarChessSeasonPassDiff

