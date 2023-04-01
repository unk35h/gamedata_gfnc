-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70015 = require("GamePlay.SkillScripts.MonsterSkill.70015_GaoDa1")
local bs_70017 = class("bs_70017", bs_70015)
local base = bs_70015
bs_70017.config = {monsterId = 1013, equipmentSummonerId = 1004}
bs_70017.config = setmetatable(bs_70017.config, {__index = base.config})
bs_70017.ctor = function(self)
  -- function num : 0_0
end

bs_70017.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70017.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70017

