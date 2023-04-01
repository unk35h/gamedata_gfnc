-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityWhiteDayUtil = {}
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
ActivityWhiteDayUtil.GetAssistHeroTypeByHeroId = function(AWDData, heroCfg)
  -- function num : 0_0 , upvalues : _ENV
  local dormAI = heroCfg.dorm_ai
  local actId = AWDData:GetActId()
  local assistGroup = (ConfigData.activity_white_day_assist_hero)[actId]
  for assistType,assistCfg in pairs(assistGroup) do
    if (table.contain)(assistCfg.hero_ai, dormAI) then
      return assistType, assistCfg
    end
  end
end

ActivityWhiteDayUtil.GetAssistTypes = function(AWDData)
  -- function num : 0_1 , upvalues : _ENV
  local actId = AWDData:GetActId()
  local assistGroup = (ConfigData.activity_white_day_assist_hero)[actId]
  return assistGroup
end

ActivityWhiteDayUtil.CouldOpenWDHistoryAlbum = function()
  -- function num : 0_2 , upvalues : _ENV, eDynConfigData
  local actFrameId = 12001
  local actId = nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(actFrameId)
  if activityFrameData == nil then
    return true
  end
  actId = activityFrameData:GetActId()
  local isWDOpening = not activityFrameData:GetIsActivityFinished()
  if isWDOpening then
    return false
  end
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day)
  local wdCfg = (ConfigData.activity_white_day)[actId]
  local startAvgId = wdCfg.activity_avg
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day)
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local isUnlock = avgPlayCtrl:IsAvgPlayed(startAvgId)
  if not isUnlock then
    return false
  end
  return true
end

return ActivityWhiteDayUtil

