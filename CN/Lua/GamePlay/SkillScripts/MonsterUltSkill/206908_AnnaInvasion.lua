-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.100203_AnnaInvasion")
local bs_206908 = class("bs_206908", base)
bs_206908.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206908.config = setmetatable(bs_206908.config, {__index = base.config})
bs_206908.PlaySkill = function(self, data)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206908.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self, data)
end

bs_206908.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206908

