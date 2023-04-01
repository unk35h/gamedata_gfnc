-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70010 = require("GamePlay.SkillScripts.MonsterSkill.70010_Core1_Equip")
local bs_70013 = class("bs_70013", bs_70010)
local base = bs_70010
bs_70013.config = {equipmentSummonerId = 1003, buffId_mark = 1232, skillId = 70024}
bs_70013.config = setmetatable(bs_70013.config, {__index = base.config})
bs_70013.ctor = function(self)
  -- function num : 0_0
end

bs_70013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70013.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70013

