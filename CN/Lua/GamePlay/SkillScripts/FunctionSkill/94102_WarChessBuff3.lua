-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94102 = class("bs_94102", LuaSkillBase)
local base = LuaSkillBase
bs_94102.config = {}
bs_94102.ctor = function(self)
  -- function num : 0_0
end

bs_94102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94102_1", 1, self.OnAfterBattleStart)
end

bs_94102.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local hurt = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:RemoveLife(hurt, self, self.caster, true, nil, true, true, eHurtType.RealDmg)
end

bs_94102.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94102

