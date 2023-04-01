-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_300501 = class("bs_300501", bs_1)
local base = bs_1
bs_300501.config = {action1 = 1021, action2 = 1044, GS_Id = 8000, effectId_trail = 1017902, audioId1 = 111, time1 = 0, audioId2 = 112, time2 = 0, Imp = true}
bs_300501.config = setmetatable(bs_300501.config, {__index = base.config})
bs_300501.ctor = function(self)
  -- function num : 0_0
end

bs_300501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300501.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300501

