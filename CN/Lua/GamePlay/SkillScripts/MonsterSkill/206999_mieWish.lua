-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206999 = class("bs_206999", LuaSkillBase)
local base = LuaSkillBase
bs_206999.config = {buffId = 206901}
bs_206999.ctor = function(self)
  -- function num : 0_0
end

bs_206999.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206999_1", 1, self.OnAfterBattleStart)
end

bs_206999.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_206999.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206999

