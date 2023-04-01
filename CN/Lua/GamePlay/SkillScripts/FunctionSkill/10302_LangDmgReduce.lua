-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10302 = class("bs_10302", LuaSkillBase)
local base = LuaSkillBase
bs_10302.config = {}
bs_10302.ctor = function(self)
  -- function num : 0_0
end

bs_10302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["10302_arg"] = (self.arglist)[1]
end

bs_10302.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10302

