-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.CommonAttackSkill.102300_BoneeAttack")
local bs_300401 = class("bs_300401", base)
bs_300401.config = {}
bs_300401.config = setmetatable(bs_300401.config, {__index = base.config})
bs_300401.ctor = function(self)
  -- function num : 0_0
end

bs_300401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300401.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300401

