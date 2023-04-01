-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94103 = class("bs_94103", LuaSkillBase)
local base = LuaSkillBase
bs_94103.config = {buffId = 196}
bs_94103.ctor = function(self)
  -- function num : 0_0
end

bs_94103.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94103_1", 1, self.OnAfterBattleStart)
end

bs_94103.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_94103.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94103

