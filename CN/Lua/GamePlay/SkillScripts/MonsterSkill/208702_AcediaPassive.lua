-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208702 = class("bs_208702", LuaSkillBase)
local base = LuaSkillBase
bs_208702.config = {}
bs_208702.ctor = function(self)
  -- function num : 0_0
end

bs_208702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["208701_Roll"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["208701_arg2"] = (self.arglist)[2]
end

bs_208702.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208702

