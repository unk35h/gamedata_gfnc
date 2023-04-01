-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.CommonAttackSkill.100200_AnnaAttack")
local bs_300101 = class("bs_300101", base)
bs_300101.config = {action1 = 1021, action2 = 1044}
bs_300101.config = setmetatable(bs_300101.config, {__index = base.config})
bs_300101.ctor = function(self)
  -- function num : 0_0
end

bs_300101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300101.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300101

