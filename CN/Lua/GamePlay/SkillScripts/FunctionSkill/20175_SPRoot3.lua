-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20175 = class("bs_20175", LuaSkillBase)
local base = LuaSkillBase
bs_20175.config = {}
bs_20175.ctor = function(self)
  -- function num : 0_0
end

bs_20175.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).shieldValue = ((self.caster).recordTable).shieldValue + (self.caster).maxHp * (self.arglist)[1] // 1000
end

bs_20175.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20175

