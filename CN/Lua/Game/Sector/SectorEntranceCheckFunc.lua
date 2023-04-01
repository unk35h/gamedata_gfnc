-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local SectorEntranceCheckFunc = {[(ActivityFrameEnum.eActivityType).SectorI] = function(actId, sectorId, actFrameData)
  -- function num : 0_0 , upvalues : _ENV
  if actFrameData ~= nil and actFrameData:IsActivityOpen() then
    return (PlayerDataCenter.allActivitySectorIData):IsOpenSectorIEntrance()
  end
  return (PlayerDataCenter.sectorStage):IsSectorUnlock(sectorId)
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(actId, sectorId, actFrameData)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity) then
    return false
  end
  local heroGrowCfg = (ConfigData.activity_hero)[actId]
  local isChange = heroGrowCfg.rechallenge_stage == sectorId
  do return isChange and ((actFrameData == nil or actFrameData:IsActivityOpen()) and not actFrameData:IsActivityRunningTimeout()) end
  if actFrameData == nil or actFrameData:GetIsActivityFinished() then
    local actFrameId = (((ConfigData.activity).actTypeMapping)[(ActivityFrameEnum.eActivityType).HeroGrow])[actId]
    if ((ConfigData.handbook_activity).handBookActFrameIdDic)[actFrameId] == nil then
      return false
    end
    if (ConfigData.game_config).heroDungeonSwitch then
      return true
    end
    local heroId = heroGrowCfg ~= nil and heroGrowCfg.hero_id or nil
    return (heroId ~= nil and PlayerDataCenter:ContainsHeroData(heroId))
  end
  do return actFrameData:GetCouldShowActivity() end
  -- DECOMPILER ERROR: 12 unprocessed JMP targets
end
}
return SectorEntranceCheckFunc

