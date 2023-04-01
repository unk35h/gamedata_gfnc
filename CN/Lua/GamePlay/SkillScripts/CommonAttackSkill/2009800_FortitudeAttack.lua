-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_2009800 = class(" bs_2009800", bs_1)
local base = bs_1
bs_2009800.config = {effectId_1 = 2009801, effectId_2 = 2009802, audioId1 = 2009801, time1 = 0, audioId2 = 2009802, time2 = 0, audioId3 = 2009803}
bs_2009800.config = setmetatable(bs_2009800.config, {__index = base.config})
bs_2009800.ctor = function(self)
  -- function num : 0_0
end

bs_2009800.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_2009800.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2009800

