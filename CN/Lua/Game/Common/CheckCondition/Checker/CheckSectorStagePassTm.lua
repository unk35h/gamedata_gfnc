-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckSectorStagePassTm = {}
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
CheckSectorStagePassTm.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 3 then
    return true
  end
  return false
end

CheckSectorStagePassTm.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local sectorId = param[2]
  local passTime = param[3]
  local ok, outRange = (PlayerDataCenter.sectorStage):CheckSectorPassTmInRange(sectorId, passTime)
  if ok and not outRange then
    return true
  end
  return false
end

CheckSectorStagePassTm.GetUnlockInfo = function(param)
  -- function num : 0_2
  return ""
end

return CheckSectorStagePassTm

