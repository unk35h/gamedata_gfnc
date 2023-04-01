-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.100403_SimoUlt")
local bs_206912 = class("bs_206912", base)
bs_206912.config = {delayInvoke = 10, actionId_start = 1005}
bs_206912.config = setmetatable(bs_206912.config, {__index = base.config})
bs_206912.PlaySkill = function(self, data)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206912.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self, data)
end

bs_206912.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206912

