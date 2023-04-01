-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21017 = class("bs_21017", LuaSkillBase)
local base = LuaSkillBase
bs_21017.config = {}
bs_21017.ctor = function(self)
  -- function num : 0_0
end

bs_21017.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21017_1", 1, self.OnAfterBattleStart)
end

bs_21017.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local Value = (math.max)(1, (self.arglist)[1] * (self.caster).maxHp // 1000)
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, Value)
end

bs_21017.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21017

