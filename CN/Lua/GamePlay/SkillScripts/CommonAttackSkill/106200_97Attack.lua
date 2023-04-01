-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106200 = class("bs_106200", bs_1)
local base = bs_1
bs_106200.config = {effectId_start1 = 106201, effectId_start2 = 106202, action1 = 1001, action2 = 1004}
bs_106200.config = setmetatable(bs_106200.config, {__index = base.config})
bs_106200.ctor = function(self)
  -- function num : 0_0
end

bs_106200.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106200.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106200

