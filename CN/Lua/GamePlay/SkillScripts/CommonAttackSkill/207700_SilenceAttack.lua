-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_207700 = class("bs_207700", bs_1)
local base = bs_1
bs_207700.config = {effectId_trail = 207701, effectId_start1 = 207700, effectId_start2 = 207700, action1 = 1002, action2 = 1002}
bs_207700.config = setmetatable(bs_207700.config, {__index = base.config})
bs_207700.ctor = function(self)
  -- function num : 0_0
end

bs_207700.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_207700.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207700

