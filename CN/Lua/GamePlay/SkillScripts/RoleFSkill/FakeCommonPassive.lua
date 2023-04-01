-- params : ...
-- function num : 0 , upvalues : _ENV
local base = LuaSkillBase
local FakeCommonPassive = class("FakeCommonPassive", base)
FakeCommonPassive.config = {}
FakeCommonPassive.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).hero_enemy = true
end

return FakeCommonPassive

