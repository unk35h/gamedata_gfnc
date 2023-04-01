-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20178 = class("bs_20178", LuaSkillBase)
local base = LuaSkillBase
bs_20178.config = {}
bs_20178.ctor = function(self)
  -- function num : 0_0
end

bs_20178.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).RootCurseUp = (self.arglist)[1]
end

bs_20178.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20178

