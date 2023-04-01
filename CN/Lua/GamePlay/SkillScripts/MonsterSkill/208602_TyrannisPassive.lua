-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208602 = class("bs_208602", LuaSkillBase)
local base = LuaSkillBase
bs_208602.config = {buffId_192 = 208602, effectId_skill = 208604, effectId_end = 208601, effectId_hit = 208602, radius = 50, spd = 15, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_208602.ctor = function(self)
  -- function num : 0_0
end

bs_208602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["208601_hurt"] = (self.arglist)[1]
end

bs_208602.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208602

