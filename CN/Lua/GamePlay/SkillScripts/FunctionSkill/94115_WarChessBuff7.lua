-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94115 = class("bs_94115", LuaSkillBase)
local base = LuaSkillBase
bs_94115.config = {}
bs_94115.ctor = function(self)
  -- function num : 0_0
end

bs_94115.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94115_1", 1, self.OnAfterBattleStart)
end

bs_94115.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, (self.caster).maxHp * (self.arglist)[1] * self.level // 1000)
end

bs_94115.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94115

