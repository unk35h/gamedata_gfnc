-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1000 = class("bs_1000", LuaSkillBase)
local base = LuaSkillBase
bs_1000.config = {buffId_def = 500}
bs_1000.ctor = function(self)
  -- function num : 0_0
end

bs_1000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1000_1", 1, self.OnAfterBattleStart)
end

bs_1000.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, nil, true)
end

bs_1000.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1000

