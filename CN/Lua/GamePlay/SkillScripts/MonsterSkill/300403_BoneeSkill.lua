-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.102302_BoneeSkill")
local bs_300403 = class("bs_300403", base)
bs_300403.config = {buffId_Defup = 10230102, skill_time = 37, start_time = 17}
bs_300403.config = setmetatable(bs_300403.config, {__index = base.config})
bs_300403.ctor = function(self)
  -- function num : 0_0
end

bs_300403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300403.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300403

