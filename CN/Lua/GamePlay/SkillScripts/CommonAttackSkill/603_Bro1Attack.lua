-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_603 = class(" bs_603", bs_1)
local base = bs_1
bs_603.config = {effectId_1 = 10121, effectId_2 = 10122}
bs_603.config = setmetatable(bs_603.config, {__index = base.config})
bs_603.ctor = function(self)
  -- function num : 0_0
end

bs_603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_603.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_603

