-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208500 = class("bs_208500", bs_1)
local base = bs_1
bs_208500.config = {effectId_start1 = 208503, effectId_start2 = 208504}
bs_208500.config = setmetatable(bs_208500.config, {__index = base.config})
bs_208500.ctor = function(self)
  -- function num : 0_0
end

bs_208500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208500.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208500

