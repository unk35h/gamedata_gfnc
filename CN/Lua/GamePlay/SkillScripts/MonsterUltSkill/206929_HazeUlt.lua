-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104603_HazeUlt")
local bs_206929 = class("bs_206929", base)
bs_206929.config = {delayInvoke = 20, actionId_start = 1005, buffId_Super = 196}
bs_206929.config = setmetatable(bs_206929.config, {__index = base.config})
bs_206929.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  local time = (self.arglist)[3] + (self.config).start_time + (self.config).end_time + 20
  self.invokeTimer = self:PlayMonsterUltSkill(time, self.config)
end

bs_206929.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self, data, role)
end

bs_206929.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206929

