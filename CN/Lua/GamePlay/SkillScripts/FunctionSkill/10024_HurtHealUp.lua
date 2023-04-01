-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10024 = class("bs_10024", LuaSkillBase)
local base = LuaSkillBase
bs_10024.config = {healBuffId = 72, injuredBuffId = 73, effectId1 = 12049, effectId2 = 12050}
bs_10024.ctor = function(self)
  -- function num : 0_0
end

bs_10024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10024_1", 1, self.OnAfterBattleStart)
end

bs_10024.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).healBuffId, (self.arglist)[1], nil, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).injuredBuffId, (self.arglist)[2], nil, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId2, self)
end

bs_10024.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10024

