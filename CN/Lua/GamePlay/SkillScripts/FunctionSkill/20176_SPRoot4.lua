-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20176 = class("bs_20176", LuaSkillBase)
local base = LuaSkillBase
bs_20176.config = {}
bs_20176.ctor = function(self)
  -- function num : 0_0
end

bs_20176.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).root4 = true
end

bs_20176.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20176

