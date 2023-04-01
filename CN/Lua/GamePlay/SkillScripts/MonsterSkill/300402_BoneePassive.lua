-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.102301_BoneePassive")
local bs_300402 = class("bs_300402", base)
bs_300402.config = {}
bs_300402.config = setmetatable(bs_300402.config, {__index = base.config})
bs_300402.ctor = function(self)
  -- function num : 0_0
end

bs_300402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300402.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300402

