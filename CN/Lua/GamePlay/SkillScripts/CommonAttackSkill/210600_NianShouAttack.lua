-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_210600 = class("bs_210600", bs_1)
local base = bs_1
bs_210600.config = {effectId_1 = 210601, effectId_2 = 210602}
bs_210600.config = setmetatable(bs_210600.config, {__index = base.config})
bs_210600.ctor = function(self)
  -- function num : 0_0
end

bs_210600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_210600.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210600

