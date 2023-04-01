-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104100 = class("bs_104100", bs_1)
local base = bs_1
bs_104100.config = {effectId_trail = 104101, effectId_action_1 = 104103, effectId_action_2 = 104103}
bs_104100.config = setmetatable(bs_104100.config, {__index = base.config})
bs_104100.ctor = function(self)
  -- function num : 0_0
end

bs_104100.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104100.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104100

