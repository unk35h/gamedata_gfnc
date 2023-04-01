-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208200 = class("bs_208200", bs_1)
local base = bs_1
bs_208200.config = {action1 = 1001, action2 = 1004, effectId_start1 = 208201, effectId_start2 = 208202}
bs_208200.config = setmetatable(bs_208200.config, {__index = base.config})
bs_208200.ctor = function(self)
  -- function num : 0_0
end

bs_208200.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208200.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208200

