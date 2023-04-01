-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15140 = class("bs_15140", LuaSkillBase)
local base = LuaSkillBase
bs_15140.config = {buffId = 1203, buffId1 = 110093}
bs_15140.ctor = function(self)
  -- function num : 0_0
end

bs_15140.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15140_1", 1, self.OnAfterBattleStart)
end

bs_15140.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  self:PlayChipEffect()
end

bs_15140.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15140

