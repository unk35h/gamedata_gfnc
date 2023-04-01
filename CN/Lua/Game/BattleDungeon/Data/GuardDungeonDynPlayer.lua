-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.BattleDungeon.Data.DungeonDynPlayer")
local GuardDungeonDynPlayer = class("GuardDungeonDynPlayer", base)
local CS_BattleManager = (CS.BattleManager).Instance
GuardDungeonDynPlayer.CreateGuardDungeonPlayer = function(roles, playerData, dungeonCfg, lastDeployData, treeId)
  -- function num : 0_0 , upvalues : GuardDungeonDynPlayer
  local player = (GuardDungeonDynPlayer.New)()
  player.__lastHeroPos = lastDeployData and lastDeployData.hero_pos or nil
  player:InitDynPlayer(roles, dungeonCfg, playerData, treeId)
  return player
end

GuardDungeonDynPlayer.InitDynPlayer = function(self, roles, dungeonCfg, playerData, treeId)
  -- function num : 0_1 , upvalues : base
  (base.InitDynPlayer)(self, roles, dungeonCfg, playerData, treeId)
end

GuardDungeonDynPlayer.ApplyPlayerDungeonRoleHpPer = function(self, csPlayerDungeonRoleHpPerDic)
  -- function num : 0_2 , upvalues : _ENV
  if csPlayerDungeonRoleHpPerDic == nil or csPlayerDungeonRoleHpPerDic.Count <= 0 then
    return 
  end
  self.dungeonRoleHpPerDic = {}
  for k,v in pairs(csPlayerDungeonRoleHpPerDic) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

    (self.dungeonRoleHpPerDic)[k] = v
  end
end

return GuardDungeonDynPlayer

