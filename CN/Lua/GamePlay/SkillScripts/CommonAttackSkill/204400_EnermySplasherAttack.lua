-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_204400 = class("bs_204400", bs_1)
local base = bs_1
bs_204400.config = {effectId_trail = 204402}
bs_204400.config = setmetatable(bs_204400.config, {__index = base.config})
bs_204400.ctor = function(self)
  -- function num : 0_0
end

bs_204400.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204400.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204400

