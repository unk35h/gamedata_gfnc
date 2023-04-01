-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerCharDungeonConsume = {}
CheckerCharDungeonConsume.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 3 then
    return true
  end
  return false
end

CheckerCharDungeonConsume.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local activityId = param[2]
  local needCount = param[3]
  local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
  if heroGrowCtrl == nil then
    return false
  end
  local actHeroData = heroGrowCtrl:GetHeroGrowActivity(activityId)
  if actHeroData == nil then
    return false
  end
  do return needCount <= actHeroData:GetHeroGrowCostNum() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerCharDungeonConsume.GetUnlockInfo = function(param)
  -- function num : 0_2
  return ""
end

return CheckerCharDungeonConsume

