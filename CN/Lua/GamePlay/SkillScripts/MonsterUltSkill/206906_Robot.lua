-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.100503_Robot")
local bs_206906 = class("bs_206906", base)
bs_206906.config = {delayInvoke = 20, actionId_start = 1005}
bs_206906.config = setmetatable(bs_206906.config, {__index = base.config})
bs_206906.PlaySkill = function(self)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206906.InternalInvoke = function(self)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self)
end

bs_206906.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206906

