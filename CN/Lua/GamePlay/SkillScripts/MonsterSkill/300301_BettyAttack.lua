-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.CommonAttackSkill.101300_BettyAttack")
local bs_300301 = class("bs_300301", base)
bs_300301.config = {action1 = 1004, action2 = 1004}
bs_300301.config = setmetatable(bs_300301.config, {__index = base.config})
bs_300301.ctor = function(self)
  -- function num : 0_0
end

bs_300301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300301.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300301

