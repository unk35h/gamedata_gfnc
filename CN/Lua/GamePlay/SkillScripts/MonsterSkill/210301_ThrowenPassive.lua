-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210301 = class("bs_210301", LuaSkillBase)
local base = LuaSkillBase
bs_210301.config = {}
bs_210301.ctor = function(self)
  -- function num : 0_0
end

bs_210301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).attack = 1
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arg = (self.arglist)[1]
end

bs_210301.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210301

