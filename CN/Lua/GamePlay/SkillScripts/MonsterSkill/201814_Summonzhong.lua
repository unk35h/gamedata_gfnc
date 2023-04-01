-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_201811 = require("GamePlay.SkillScripts.MonsterSkill.201811_ZYZ_RefactorSummon")
local bs_201814 = class("bs_201814", bs_201811)
local base = bs_201811
bs_201814.config = {
middleMonsterId = {7, 9, 10}
, maxHpPer = 210, powPer = 750}
bs_201814.config = setmetatable(bs_201814.config, {__index = base.config})
bs_201814.ctor = function(self)
  -- function num : 0_0
end

bs_201814.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_201814.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_201814

