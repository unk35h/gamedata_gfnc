-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local EpActCheckCmdTimelinessFunc = {[(ActivityFrameEnum.eActivityType).SectorI] = function(actId, sectorId)
  -- function num : 0_0 , upvalues : _ENV
  local data = (PlayerDataCenter.allActivitySectorIData):GetSectorIData(actId)
  local isOver = data == nil or data:GetActivityDestroyTime() < PlayerDataCenter.timestamp - 1
  local sectorICfg = (ConfigData.activity_time_limit)[actId]
  if isOver and sectorICfg.hard_stage ~= sectorId then
    return false
  end
  do return true end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(actId, sectorId)
  -- function num : 0_1 , upvalues : _ENV
  local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
  if heroGrowCtrl == nil then
    return 
  end
  local data = heroGrowCtrl:GetHeroGrowActivity(actId)
  local isOver = data == nil or data:GetActivityDestroyTime() < PlayerDataCenter.timestamp - 1
  local heroGrowCfg = (ConfigData.activity_hero)[actId]
  if isOver and heroGrowCfg.main_stage ~= sectorId then
    return false
  end
  do return true end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end
, [(ActivityFrameEnum.eActivityType).SectorII] = function(actId, sectorId)
  -- function num : 0_2 , upvalues : _ENV
  local SectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if SectorIICtrl == nil then
    return false
  end
  local sectorIIdata = SectorIICtrl:GetSectorIIDataByActId(actId)
  if sectorIIdata == nil then
    return false
  end
  if sectorIIdata:GetActivityDestroyTime() < PlayerDataCenter.timestamp - 1 then
    return false
  end
  return true
end
, [(ActivityFrameEnum.eActivityType).WhiteDay] = function(actId, sectorId)
  -- function num : 0_3 , upvalues : _ENV
  local whiteCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay)
  if whiteCtrl == nil then
    return false
  end
  local whiteData = whiteCtrl:GetWhiteDayDataByActId(actId)
  if whiteData == nil then
    return false
  end
  if whiteData:GetActivityDestroyTime() < PlayerDataCenter.timestamp - 1 then
    return false
  end
  return true
end
}
return EpActCheckCmdTimelinessFunc

