-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerDungeonTower = {}
CheckerDungeonTower.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 3 then
    return true
  end
  return false
end

CheckerDungeonTower.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local towerId = param[2]
  local floorId = param[3]
  local ok = floorId <= (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
  do return ok end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerDungeonTower.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local towerId = param[2]
  local floorId = param[3]
  local towerCfg = (ConfigData.dungeon_tower_type)[towerId]
  if towerCfg == nil then
    error("Cant\'t find dungeon tower type cfg,id = " .. tostring(towerId))
    return ""
  end
  local stageId = (towerCfg.tower_list)[floorId]
  if stageId == nil then
    return ""
  end
  local stageCfg = (ConfigData.battle_dungeon)[stageId]
  if stageCfg == nil then
    error("Cant\'t find battleDungeon cfg,id = " .. tostring(stageId))
    return ""
  end
  return (string.format)(ConfigData:GetTipContent(TipContent.FunctionUnlockDescription_BattleDungeon), (LanguageUtil.GetLocaleText)(stageCfg.name))
end

return CheckerDungeonTower

