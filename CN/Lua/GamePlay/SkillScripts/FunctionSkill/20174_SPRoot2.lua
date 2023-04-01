-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20174 = class("bs_20174", LuaSkillBase)
local base = LuaSkillBase
bs_20174.config = {}
bs_20174.ctor = function(self)
  -- function num : 0_0
end

bs_20174.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).JudgeBuffTime = ((self.caster).recordTable).JudgeBuffTime + (self.arglist)[1]
end

bs_20174.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20174

