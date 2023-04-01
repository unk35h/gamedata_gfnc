-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91007 = class("bs_91007", LuaSkillBase)
local base = LuaSkillBase
bs_91007.config = {buffId = 2007, buffTier = 1}
bs_91007.ctor = function(self)
  -- function num : 0_0
end

bs_91007.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91007_1", 1, self.OnAfterBattleStart)
end

bs_91007.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, (self.arglist)[2], true)
end

bs_91007.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91007

