-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105400 = class("bs_105400", bs_1)
local base = bs_1
bs_105400.config = {effectId_1 = 105401, effectId_2 = 105402}
bs_105400.config = setmetatable(bs_105400.config, {__index = base.config})
bs_105400.ctor = function(self)
  -- function num : 0_0
end

bs_105400.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105400.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105400

