-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_506 = class("bs_506", bs_1)
local base = bs_1
bs_506.config = {effectId_trail = 10107, audioId1 = 23, audioId2 = 23}
bs_506.config = setmetatable(bs_506.config, {__index = base.config})
bs_506.ctor = function(self)
  -- function num : 0_0
end

bs_506.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_506.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_506

