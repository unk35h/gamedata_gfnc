-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70010 = require("GamePlay.SkillScripts.MonsterSkill.70010_Core1_Equip")
local bs_70014 = class("bs_70014", bs_70010)
local base = bs_70010
bs_70014.config = {equipmentSummonerId = 1004, buffId_mark = 1233, skillId = 70025}
bs_70014.config = setmetatable(bs_70014.config, {__index = base.config})
bs_70014.ctor = function(self)
  -- function num : 0_0
end

bs_70014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70014.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70014

