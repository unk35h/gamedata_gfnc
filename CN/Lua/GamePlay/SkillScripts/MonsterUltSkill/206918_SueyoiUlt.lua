-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104503_SueyoiUlt")
local bs_206918 = class("bs_206918", base)
bs_206918.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206918.config = setmetatable(bs_206918.config, {__index = base.config})
bs_206918.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  local casterWaitTime = 40 + (self.arglist)[1] + (self.config).end_time
  self.invokeTimer = self:PlayMonsterUltSkill(casterWaitTime, self.config)
end

bs_206918.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  local roles = {[0] = role}
  ;
  (base.PlaySkill)(self, data, role, roles)
end

bs_206918.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206918

