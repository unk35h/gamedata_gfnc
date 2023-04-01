-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_310601 = class("bs_310601", bs_1)
local base = bs_1
bs_310601.config = {action1 = 1004, action2 = 1004, effectId_1 = 10490102, effectId_2 = 10490202}
bs_310601.config = setmetatable(bs_310601.config, {__index = base.config})
bs_310601.ctor = function(self)
  -- function num : 0_0
end

bs_310601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_310601.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_310601

