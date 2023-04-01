-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207402 = class("bs_207402", LuaSkillBase)
local base = LuaSkillBase
bs_207402.config = {}
bs_207402.ctor = function(self)
  -- function num : 0_0
end

bs_207402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).AttackDamage = (self.arglist)[1]
end

bs_207402.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207402

