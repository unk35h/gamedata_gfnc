-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105700 = class("bs_105700", bs_1)
local base = bs_1
bs_105700.config = {effectId_trail = 105701}
bs_105700.config = setmetatable(bs_105700.config, {__index = base.config})
bs_105700.ctor = function(self)
  -- function num : 0_0
end

bs_105700.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105700.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105700

