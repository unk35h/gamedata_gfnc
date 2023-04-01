-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15107 = class("bs_15107", LuaSkillBase)
local base = LuaSkillBase
bs_15107.config = {buffId = 110087}
bs_15107.ctor = function(self)
  -- function num : 0_0
end

bs_15107.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15107_1", 1, self.OnAfterBattleStart)
end

bs_15107.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1], true)
end

bs_15107.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15107

