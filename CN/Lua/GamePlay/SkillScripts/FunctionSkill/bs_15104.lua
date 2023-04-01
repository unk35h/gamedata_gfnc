-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15104 = class("bs_15104", LuaSkillBase)
local base = LuaSkillBase
bs_15104.config = {}
bs_15104.ctor = function(self)
  -- function num : 0_0
end

bs_15104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15104_1", 1, self.OnAfterBattleStart)
end

bs_15104.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local heal = (self.caster).maxHp * (self.arglist)[1] // 1000
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
  LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {heal}, true, true)
  skillResult:EndResult()
end

bs_15104.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15104

