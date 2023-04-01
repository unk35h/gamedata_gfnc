-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_209200 = class("bs_209200", bs_1)
local base = bs_1
bs_209200.config = {effectId_trail = 209201}
bs_209200.config = setmetatable(bs_209200.config, {__index = base.config})
bs_209200.ctor = function(self)
  -- function num : 0_0
end

bs_209200.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_209200.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209200

