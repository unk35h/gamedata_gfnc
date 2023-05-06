-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1017 = class("bs_1017", LuaSkillBase)
local base = LuaSkillBase
bs_1017.config = {buffId_bati = 196}
bs_1017.ctor = function(self)
  -- function num : 0_0
end

bs_1017.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1017", 1, self.OnAfterBattleStart)
end

bs_1017.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_bati, 1, nil, true)
end

bs_1017.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1017

