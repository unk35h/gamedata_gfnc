-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.101301_BettyPassive")
local bs_300302 = class("bs_300302", base)
bs_300302.config = {}
bs_300302.config = setmetatable(bs_300302.config, {__index = base.config})
bs_300302.ctor = function(self)
  -- function num : 0_0
end

bs_300302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300302.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300302

