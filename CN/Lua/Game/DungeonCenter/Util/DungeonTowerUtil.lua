-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonTowerUtil = {}
DungeonTowerUtil.TowerHasRecommendFormation = function(stageId)
  -- function num : 0_0 , upvalues : _ENV
  local towerLevelCfg = (ConfigData.dungeon_tower)[stageId]
  if towerLevelCfg == nil then
    return false
  end
  return towerLevelCfg.team_record
end

return DungeonTowerUtil

