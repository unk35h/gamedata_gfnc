-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_211500 = class("bs_211500", bs_1)
local base = bs_1
bs_211500.config = {effectId_trail = 204300}
bs_211500.config = setmetatable(bs_211500.config, {__index = base.config})
bs_211500.ctor = function(self)
  -- function num : 0_0
end

bs_211500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_211500.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_211500

