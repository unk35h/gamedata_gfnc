-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.100202_AnnaSkill")
local bs_300103 = class("bs_300103", base)
bs_300103.config = {action1 = 1044, skill_time = 37, start_time = 17}
bs_300103.config = setmetatable(bs_300103.config, {__index = base.config})
bs_300103.ctor = function(self)
  -- function num : 0_0
end

bs_300103.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300103.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300103

