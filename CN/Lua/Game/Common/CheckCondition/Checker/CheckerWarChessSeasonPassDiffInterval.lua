-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerWarChessSeasonPassDiffInterval = {}
CheckerWarChessSeasonPassDiffInterval.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 3 then
    return true
  end
  return false
end

CheckerWarChessSeasonPassDiffInterval.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local seasonId = param[2]
  local diffIdMin = param[3] // 1000
  local diffIdMax = param[3] % 1000
  if diffIdMax < diffIdMin then
    if isGameDev then
      error("maxDiff < minDiff error,minDiffId:" .. tostring(diffIdMin) .. ",maxDiffId:" .. tostring(diffIdMax))
    end
    return false
  end
  local wcsPassedData = WarChessSeasonManager:GetWCSPassedTower()
  local sPassedData = wcsPassedData[seasonId]
  if sPassedData == nil then
    return false
  end
  local passedMap = sPassedData.difficultyRecord
  if passedMap == nil then
    return false
  end
  for i = diffIdMin, diffIdMax do
    if passedMap[i] then
      return true
    end
  end
  return false
end

CheckerWarChessSeasonPassDiffInterval.GetUnlockInfo = function(param)
  -- function num : 0_2
  return ""
end

return CheckerWarChessSeasonPassDiffInterval

