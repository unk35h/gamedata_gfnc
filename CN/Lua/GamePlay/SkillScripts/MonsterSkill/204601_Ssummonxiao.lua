-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_201801 = require("GamePlay.SkillScripts.MonsterSkill.201801_ZYZ_RefactorSummon")
local bs_204601 = class("bs_204601", bs_201801)
local base = bs_201801
bs_204601.config = {
middleMonsterId = {20, 21, 22}
, maxHpPer = 180, powPer = 700, buffId = 1033, effectId = 10264, effectId1 = 10263, startAnimID = 1002, maxEnemyNum = 8, maxSummonNum = 10, buffId_196 = 196, buffId_1033 = 1033, skill_time = 18, audioId1 = 300}
bs_204601.config = setmetatable(bs_204601.config, {__index = base.config})
bs_204601.ctor = function(self)
  -- function num : 0_0
end

bs_204601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204601.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204601

