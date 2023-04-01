-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_211600 = class("bs_211600", bs_1)
local base = bs_1
bs_211600.config = {action2 = 1001, effectId_trail = 208401}
bs_211600.config = setmetatable(bs_211600.config, {__index = base.config})
bs_211600.ctor = function(self)
  -- function num : 0_0
end

bs_211600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_211600.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_211600

