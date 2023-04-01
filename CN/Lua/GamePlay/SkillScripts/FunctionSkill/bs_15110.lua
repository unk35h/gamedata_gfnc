-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15110 = class("bs_15110", LuaSkillBase)
local base = LuaSkillBase
bs_15110.config = {buffId = 110089}
bs_15110.ctor = function(self)
  -- function num : 0_0
end

bs_15110.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15110_1", 1, self.OnAfterBattleStart)
end

bs_15110.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2], true)
end

bs_15110.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15110

