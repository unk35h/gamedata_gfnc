-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104900 = class("bs_104900", bs_1)
local base = bs_1
bs_104900.config = {effectId_1 = 104901, effectId_2 = 104902}
bs_104900.config = setmetatable(bs_104900.config, {__index = base.config})
bs_104900.ctor = function(self)
  -- function num : 0_0
end

bs_104900.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104900.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104900

