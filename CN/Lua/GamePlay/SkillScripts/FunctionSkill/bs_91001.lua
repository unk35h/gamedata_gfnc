-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91001 = class("bs_91001", LuaSkillBase)
local base = LuaSkillBase
bs_91001.config = {buffId = 2001, buffTier = 10}
bs_91001.ctor = function(self)
  -- function num : 0_0
end

bs_91001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91001_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_91001_3", 1, self.OnAfterHurt, nil, self.caster)
end

bs_91001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
end

bs_91001.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target == self.caster and not isMiss and not isTriggerSet then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  end
end

bs_91001.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91001

