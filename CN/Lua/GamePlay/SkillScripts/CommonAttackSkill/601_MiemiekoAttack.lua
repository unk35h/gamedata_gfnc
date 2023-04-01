-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_601 = class("bs_601", bs_1)
local base = bs_1
bs_601.config = {action1 = 1106, action2 = 1106}
bs_601.config = setmetatable(bs_601.config, {__index = base.config})
bs_601.ctor = function(self)
  -- function num : 0_0
end

bs_601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_601.PlaySkill = function(self, passdata)
  -- function num : 0_2
end

bs_601.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_601

