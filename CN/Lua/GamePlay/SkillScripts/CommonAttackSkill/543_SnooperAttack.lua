-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_204300 = class("bs_204300", bs_1)
local base = bs_1
bs_204300.config = {effectId_trail = 204300}
bs_204300.config = setmetatable(bs_204300.config, {__index = base.config})
bs_204300.ctor = function(self)
  -- function num : 0_0
end

bs_204300.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204300.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204300

