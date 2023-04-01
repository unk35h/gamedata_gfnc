-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70010 = require("GamePlay.SkillScripts.MonsterSkill.70010_Core1_Equip")
local bs_70011 = class("bs_70011", bs_70010)
local base = bs_70010
bs_70011.config = {equipmentSummonerId = 1001, buffId_mark = 1235, skillId = 70027}
bs_70011.config = setmetatable(bs_70011.config, {__index = base.config})
bs_70011.ctor = function(self)
  -- function num : 0_0
end

bs_70011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70011.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70011

