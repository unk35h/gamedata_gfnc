-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10296 = class("bs_10296", LuaSkillBase)
local base = LuaSkillBase
bs_10296.config = {buffId1 = 110005, buffId2 = 110004}
bs_10296.ctor = function(self)
  -- function num : 0_0
end

bs_10296.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10296_1", 2, self.OnAfterBattleStart)
end

bs_10296.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 1, nil, true)
end

bs_10296.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10296

