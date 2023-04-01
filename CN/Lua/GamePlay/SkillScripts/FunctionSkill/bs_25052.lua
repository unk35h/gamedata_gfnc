-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25052 = class("bs_25052", LuaSkillBase)
local base = LuaSkillBase
bs_25052.config = {}
bs_25052.ctor = function(self)
  -- function num : 0_0
end

bs_25052.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25052_1", 1, self.OnAfterBattleStart)
end

bs_25052.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local value = (self.arglist)[1]
  if value >= 0 then
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, value)
  end
end

bs_25052.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25052

