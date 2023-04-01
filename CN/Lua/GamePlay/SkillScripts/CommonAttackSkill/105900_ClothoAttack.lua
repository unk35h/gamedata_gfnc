-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105900 = class("bs_105900", bs_1)
local base = bs_1
bs_105900.config = {effectId_1 = 105901, effectId_2 = 105902}
bs_105900.config = setmetatable(bs_105900.config, {__index = base.config})
bs_105900.ctor = function(self)
  -- function num : 0_0
end

bs_105900.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105900.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105900

