-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.Data.DynPlayer")
local GuardProfessorDynPlayer = class("GuardProfessorDynPlayer", base)
GuardProfessorDynPlayer.ApplyPlayerDungeonRoleHpPer = function(self, csPlayerDungeonRoleHpPerDic)
  -- function num : 0_0 , upvalues : _ENV
  if csPlayerDungeonRoleHpPerDic == nil or csPlayerDungeonRoleHpPerDic.Count <= 0 then
    return 
  end
  self.dungeonRoleHpPerDic = {}
  for k,v in pairs(csPlayerDungeonRoleHpPerDic) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

    (self.dungeonRoleHpPerDic)[k] = v
  end
end

return GuardProfessorDynPlayer

