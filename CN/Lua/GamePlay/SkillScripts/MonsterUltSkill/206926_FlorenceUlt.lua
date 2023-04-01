-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.101803_FlorenceUlt")
local bs_206926 = class("bs_206926", base)
bs_206926.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1001}
bs_206926.config = setmetatable(bs_206926.config, {__index = base.config})
bs_206926.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206926.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.PlaySkill)(self, data, nil, role, SelectRolesType.SingleRole)
end

bs_206926.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206926

