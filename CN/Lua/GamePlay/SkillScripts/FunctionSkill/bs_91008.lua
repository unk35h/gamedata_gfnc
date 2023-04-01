-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91008 = class("bs_91008", LuaSkillBase)
local base = LuaSkillBase
bs_91008.config = {}
bs_91008.ctor = function(self)
  -- function num : 0_0
end

bs_91008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91008_1", 1, self.OnAfterBattleStart)
end

bs_91008.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local shieldValue = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue)
end

bs_91008.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91008

