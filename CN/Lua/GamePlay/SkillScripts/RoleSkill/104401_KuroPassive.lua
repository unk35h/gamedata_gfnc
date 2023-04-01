-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104401 = class("bs_104401", LuaSkillBase)
local base = LuaSkillBase
bs_104401.config = {}
bs_104401.ctor = function(self)
  -- function num : 0_0
end

bs_104401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["self.roll"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["self.number"] = (self.arglist)[2]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["self.max"] = (self.arglist)[3]
end

bs_104401.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104401

