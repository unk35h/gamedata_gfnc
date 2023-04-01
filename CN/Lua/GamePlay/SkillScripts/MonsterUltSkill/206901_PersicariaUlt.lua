-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.100103_PersicariaUlt")
local bs_206901 = class("bs_206901", base)
bs_206901.config = {delayInvoke = 20, actionId_start = 1005}
bs_206901.config = setmetatable(bs_206901.config, {__index = base.config})
bs_206901.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206901.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.PlaySkill)(self, data, nil, role, SelectRolesType.SingleRole)
end

bs_206901.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206901

