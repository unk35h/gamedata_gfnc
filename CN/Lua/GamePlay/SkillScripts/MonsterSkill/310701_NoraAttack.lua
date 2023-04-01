-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_310701 = class("bs_310701", bs_1)
local base = bs_1
bs_310701.config = {effectId_trail = 10480102, action1 = 1021, action2 = 1044, audioId1 = 104301, audioId2 = 104303}
bs_310701.config = setmetatable(bs_310701.config, {__index = base.config})
bs_310701.ctor = function(self)
  -- function num : 0_0
end

bs_310701.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_310701.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_310701

