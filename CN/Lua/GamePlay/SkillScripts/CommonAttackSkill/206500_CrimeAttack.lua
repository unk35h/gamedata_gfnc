-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_206500 = class("bs_206500", bs_1)
local base = bs_1
bs_206500.config = {action1 = 1001, action2 = 1001, effectId_1 = 2065001, effectId_2 = 2065001, audioId1 = 440}
bs_206500.config = setmetatable(bs_206500.config, {__index = base.config})
bs_206500.ctor = function(self)
  -- function num : 0_0
end

bs_206500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206500.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206500

