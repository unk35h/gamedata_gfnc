-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104403_KuroUlt")
local bs_206910 = class("bs_206910", base)
bs_206910.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206910.config = setmetatable(bs_206910.config, {__index = base.config})
bs_206910.HandleSelectTarget = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local grid = LuaSkillCtrl:CallFindGridMostRolesArounded(eBattleRoleBelong.player)
  local targetGrid = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  ;
  (self.caster):LookAtTarget(targetGrid)
  return grid
end

bs_206910.PlaySkill = function(self, data, selectTargetCoord, selectRolesdata)
  -- function num : 0_1
  self.invokeTimer = self:PlayMonsterUltSkill(30, self.config)
end

bs_206910.InternalInvoke = function(self, data, role)
  -- function num : 0_2 , upvalues : base
  (base.PlaySkill)(self, data, role)
end

bs_206910.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206910

