-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94105 = class("bs_94105", LuaSkillBase)
local base = LuaSkillBase
bs_94105.config = {buffId = 1256}
bs_94105.ctor = function(self)
  -- function num : 0_0
end

bs_94105.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94105_1", 1, self.OnAfterBattleStart)
end

bs_94105.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_94105.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94105

