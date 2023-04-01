-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.103703_BlackHole")
local bs_206914 = class("bs_206914", base)
bs_206914.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206914.config = setmetatable(bs_206914.config, {__index = base.config})
bs_206914.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1101)
  self.startEffect = LuaSkillCtrl:CallEffect(self.caster, 10342, self)
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206914.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self, data, role, role)
end

bs_206914.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206914

