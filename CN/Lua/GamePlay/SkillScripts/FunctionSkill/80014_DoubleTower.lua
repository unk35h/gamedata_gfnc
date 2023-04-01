-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80014 = class("bs_80014", LuaSkillBase)
local base = LuaSkillBase
bs_80014.config = {}
bs_80014.ctor = function(self)
  -- function num : 0_0
end

bs_80014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_80014_1", 1, self.OnAfterBattleStart)
end

bs_80014.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local life = (self.caster).hp * (1000 - (self.arglist)[1]) // 1000
  ;
  (self.caster):SubHp(life)
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, life)
  LuaSkillCtrl:RemoveLife(1, self, self.caster, true, nil, false, true, eHurtType.RealDmg)
end

bs_80014.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80014

