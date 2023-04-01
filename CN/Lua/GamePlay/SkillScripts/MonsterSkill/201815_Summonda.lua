-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_201811 = require("GamePlay.SkillScripts.MonsterSkill.201811_ZYZ_RefactorSummon")
local bs_201815 = class("bs_201815", bs_201811)
local base = bs_201811
bs_201815.config = {
middleMonsterId = {9, 10, 19}
, maxHpPer = 250, powPer = 800}
bs_201815.config = setmetatable(bs_201815.config, {__index = base.config})
bs_201815.ctor = function(self)
  -- function num : 0_0
end

bs_201815.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_201815.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_201815

