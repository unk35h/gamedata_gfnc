-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_204500 = class("bs_204500", bs_1)
local base = bs_1
bs_204500.config = {effectId_1 = 204502, effectId_2 = 204503, audioId1 = 65, time1 = 10, audioId2 = 66}
bs_204500.config = setmetatable(bs_204500.config, {__index = base.config})
bs_204500.ctor = function(self)
  -- function num : 0_0
end

bs_204500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204500.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204500

