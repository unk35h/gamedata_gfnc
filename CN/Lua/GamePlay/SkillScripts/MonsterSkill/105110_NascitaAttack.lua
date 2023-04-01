-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105110 = class("bs_105110", bs_1)
local base = bs_1
bs_105110.config = {effectId_1 = 105101, effectId_2 = 105102}
bs_105110.config = setmetatable(bs_105110.config, {__index = base.config})
bs_105110.ctor = function(self)
  -- function num : 0_0
end

bs_105110.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105110.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105110

