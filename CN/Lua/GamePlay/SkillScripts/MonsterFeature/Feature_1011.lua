-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1011 = class("bs_1011", LuaSkillBase)
local base = LuaSkillBase
bs_1011.config = {buffId_dodge = 504}
bs_1011.ctor = function(self)
  -- function num : 0_0
end

bs_1011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1000_1", 1, self.OnAfterBattleStart)
end

bs_1011.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_dodge, 1, nil, true)
end

bs_1011.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1011

