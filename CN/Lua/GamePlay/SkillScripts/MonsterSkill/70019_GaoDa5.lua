-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70015 = require("GamePlay.SkillScripts.MonsterSkill.70015_GaoDa1")
local bs_70019 = class("bs_70019", bs_70015)
local base = bs_70015
bs_70019.config = {monsterId = 1015, equipmentSummonerId = 1003, effectId = 12025}
bs_70019.config = setmetatable(bs_70019.config, {__index = base.config})
bs_70019.ctor = function(self)
  -- function num : 0_0
end

bs_70019.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70019.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70019

