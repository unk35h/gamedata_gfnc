-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208100 = class("bs_208100", bs_1)
local base = bs_1
bs_208100.config = {effectId_start1 = 105011, effectId_start2 = 105011}
bs_208100.config = setmetatable(bs_208100.config, {__index = base.config})
bs_208100.ctor = function(self)
  -- function num : 0_0
end

bs_208100.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208100.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208100

