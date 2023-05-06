-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerActivityLevel = {}
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local LockedDesId = {[(ActivityFrameEnum.eActivityType).Carnival] = 7122, [(ActivityFrameEnum.eActivityType).WhiteDay] = 7212, [(ActivityFrameEnum.eActivityType).Hallowmas] = 8702, [(ActivityFrameEnum.eActivityType).Season] = 9310}
local JustShowLevel = {[(ActivityFrameEnum.eActivityType).Carnival] = true, [(ActivityFrameEnum.eActivityType).Hallowmas] = true, [(ActivityFrameEnum.eActivityType).Season] = true}
CheckerActivityLevel.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerActivityLevel.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  local activityFrameId = param[2]
  local level = param[3]
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameData = actFrameCtrl:GetActivityFrameData(activityFrameId)
  if actFrameData == nil then
    return false
  end
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Carnival then
    local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival)
    if carnivalCtrl == nil then
      return false
    end
    local actId = actFrameData:GetActId()
    local carnivalData = carnivalCtrl:GetCarnivalAct(actId)
    if carnivalData == nil then
      return false
    end
    local actlevel = carnivalData:GetCarnivalLevelExp()
    return level <= actlevel
  end
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).WhiteDay then
    local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
    if whiteDayCtrl == nil then
      return false
    end
    local actId = actFrameData:GetActId()
    local whiteDayData = whiteDayCtrl:GetWhiteDayDataByActId(actId)
    if whiteDayData == nil then
      return false
    end
    local actlevel = whiteDayData:GetAWDFactoryLevel()
    return level <= actlevel
  end
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Hallowmas then
    local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
    if hallowmasCtrl == nil then
      return false
    end
    local actId = actFrameData:GetActId()
    local hallowmasData = hallowmasCtrl:GetHallowmasData(actId)
    if hallowmasData == nil then
      return false
    end
    local actlevel = hallowmasData:GetHallowmasLv()
    return level <= actlevel
  end
  if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Season then
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
    if seasonCtrl == nil then
      return false
    end
    local actId = actFrameData:GetActId()
    local seasonData = seasonCtrl:GetSeasonDataByActId(actId)
    if seasonData == nil then
      return false
    end
    local actlevel = seasonData:GetSeasonRewardCurLv()
    return level <= actlevel
  end
  do return false end
  -- DECOMPILER ERROR: 14 unprocessed JMP targets
end

CheckerActivityLevel.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV, LockedDesId, JustShowLevel
  local activityFrameId = param[2]
  local level = param[3]
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local actFrameData = actFrameCtrl:GetActivityFrameData(activityFrameId)
  if actFrameData == nil then
    return ""
  end
  local desId = LockedDesId[actFrameData:GetActivityFrameCat()]
  if desId == nil then
    return ""
  end
  if JustShowLevel[actFrameData:GetActivityFrameCat()] then
    return (string.format)(ConfigData:GetTipContent(desId), level)
  end
  local actName = actFrameData.name
  return (string.format)(ConfigData:GetTipContent(desId), actName, level)
end

return CheckerActivityLevel

