-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_2100001 = class("bs_2100001", bs_1)
local base = bs_1
bs_2100001.config = {effectId_trail = 210001}
bs_2100001.config = setmetatable(bs_2100001.config, {__index = base.config})
bs_2100001.ctor = function(self)
  -- function num : 0_0
end

bs_2100001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_2100001.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2100001

