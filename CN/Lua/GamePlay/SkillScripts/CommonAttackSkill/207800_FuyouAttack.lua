-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_207800 = class("bs_207800", bs_1)
local base = bs_1
bs_207800.config = {}
bs_207800.config = setmetatable(bs_207800.config, {__index = base.config})
bs_207800.ctor = function(self)
  -- function num : 0_0
end

bs_207800.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_207800.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207800

