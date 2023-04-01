-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameUtil = class("ActivityFrameUtil")
ActivityFrameUtil.GetShowEndTimeStr = function(activityBase)
  -- function num : 0_0 , upvalues : _ENV
  local title = ""
  local timeStr = ""
  local expireTime = math.maxinteger
  local endTime = activityBase:GetActivityEndTime()
  local destroyTime = activityBase:GetActivityDestroyTime()
  if endTime == destroyTime then
    endTime = -1
  end
  if PlayerDataCenter.timestamp < endTime then
    expireTime = endTime
    title = ConfigData:GetTipContent(6036)
  else
    if PlayerDataCenter.timestamp < destroyTime then
      expireTime = destroyTime
      title = ConfigData:GetTipContent(6037)
    else
      expireTime = destroyTime
      title = ConfigData:GetTipContent(6033)
    end
  end
  expireTime = (math.max)(expireTime, 0)
  local timeTable = TimeUtil:TimestampToDate(expireTime, false, true)
  timeStr = (string.format)("%02d/%02d %02d:%02d", timeTable.month, timeTable.day, timeTable.hour, timeTable.min)
  return title, timeStr, expireTime
end

ActivityFrameUtil.GetCountdownTimeStr = function(expireTime, isShotTitle)
  -- function num : 0_1 , upvalues : _ENV
  local timeStr = ""
  local diff = expireTime - PlayerDataCenter.timestamp
  if diff < 0 then
    timeStr = (string.format)(ConfigData:GetTipContent(6045), "0")
    return timeStr, diff
  end
  local d, h, m = TimeUtil:TimestampToTimeInter(diff, false, true)
  do
    if not isShotTitle or not 9201 then
      local tip = d <= 0 or 6043
    end
    timeStr = (string.format)(ConfigData:GetTipContent(tip), tostring(d))
    do
      if not isShotTitle or not 9202 then
        local tip = h <= 0 or 6044
      end
      timeStr = (string.format)(ConfigData:GetTipContent(tip), tostring(h))
      do
        local tip = isShotTitle and 9203 or 6045
        timeStr = (string.format)(ConfigData:GetTipContent(tip), tostring(m))
        return timeStr, diff
      end
    end
  end
end

ActivityFrameUtil.CalActTechRedWithSpBranchAndItem = function(actBase, actTechTree, spBranch, itemCountLimit)
  -- function num : 0_2 , upvalues : _ENV
  if not actBase:IsActivityRunning() then
    return false
  end
  local flag = actTechTree:IsExsitCouldLvUpTechInBranch(spBranch)
  if flag or itemCountLimit == nil then
    return flag
  end
  local needItemRed, itemId = actTechTree:GetTreeResetReturnItemId()
  if not needItemRed or PlayerDataCenter:GetItemCount(itemId) < itemCountLimit then
    return flag
  end
  local treeDic = actTechTree:GetTechDataDic()
  for k,v in pairs(treeDic) do
    if k ~= spBranch and actTechTree:IsExsitCouldLvUpTechInBranch(k) then
      flag = true
      break
    end
  end
  do
    return flag
  end
end

return ActivityFrameUtil

