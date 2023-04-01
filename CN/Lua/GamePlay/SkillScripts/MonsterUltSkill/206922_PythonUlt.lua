-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104303_PythonUlt")
local bs_206922 = class("bs_206922", base)
bs_206922.config = {delayInvoke = 20, buffId_Super = 196, actionId_start = 1005}
bs_206922.config = setmetatable(bs_206922.config, {__index = base.config})
bs_206922.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206922.InternalInvoke = function(self, data, role)
  -- function num : 0_1 , upvalues : base
  (base.PlaySkill)(self, data, role, role)
end

bs_206922.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206922

