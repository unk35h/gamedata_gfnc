-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_210800 = class("bs_210800", bs_1)
local base = bs_1
bs_210800.config = {effectId_trail = 210801, action1 = 1001, action2 = 1001, effectId_action_1 = 210802, effectId_action_2 = 210802}
bs_210800.config = setmetatable(bs_210800.config, {__index = base.config})
bs_210800.ctor = function(self)
  -- function num : 0_0
end

bs_210800.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_210800.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210800

