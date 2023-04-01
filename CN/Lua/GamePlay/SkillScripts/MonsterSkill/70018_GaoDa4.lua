-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70015 = require("GamePlay.SkillScripts.MonsterSkill.70015_GaoDa1")
local bs_70018 = class("bs_70018", bs_70015)
local base = bs_70015
bs_70018.config = {monsterId = 1014, equipmentSummonerId = 1002, effectId = 12025}
bs_70018.config = setmetatable(bs_70018.config, {__index = base.config})
bs_70018.ctor = function(self)
  -- function num : 0_0
end

bs_70018.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70018.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70018

