-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105000 = class("bs_105000", bs_1)
local base = bs_1
bs_105000.config = {effectId_start1 = 105001, effectId_start2 = 105002, effectId_trail = 105014}
bs_105000.config = setmetatable(bs_105000.config, {__index = base.config})
bs_105000.ctor = function(self)
  -- function num : 0_0
end

bs_105000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105000.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105000

