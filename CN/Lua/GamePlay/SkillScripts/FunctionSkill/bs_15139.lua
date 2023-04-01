-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15139 = class("bs_15139", LuaSkillBase)
local base = LuaSkillBase
bs_15139.config = {buffId = 1121, buffId1 = 110092}
bs_15139.ctor = function(self)
  -- function num : 0_0
end

bs_15139.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15139_1", 1, self.OnAfterBattleStart)
end

bs_15139.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  self:PlayChipEffect()
end

bs_15139.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15139

