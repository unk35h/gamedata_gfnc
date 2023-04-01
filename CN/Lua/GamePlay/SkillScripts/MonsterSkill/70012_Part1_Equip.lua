-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70010 = require("GamePlay.SkillScripts.MonsterSkill.70010_Core1_Equip")
local bs_70012 = class("bs_70012", bs_70010)
local base = bs_70010
bs_70012.config = {equipmentSummonerId = 1002, buffId_mark = 1231, skillId = 70023}
bs_70012.config = setmetatable(bs_70012.config, {__index = base.config})
bs_70012.ctor = function(self)
  -- function num : 0_0
end

bs_70012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70012.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70012

