-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91024 = class("bs_91024", LuaSkillBase)
local base = LuaSkillBase
bs_91024.config = {buffId = 2046, buffTier = 1}
bs_91024.ctor = function(self)
  -- function num : 0_0
end

bs_91024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultEndTrigger("bs_91024_16", 1, self.OnHurtResultEnd, nil, self.caster, nil, eBattleRoleBelong.player)
  self:AddHealResultEndTrigger("bs_91024_17", 1, self.OnHealResultEnd, nil, self.caster, nil, eBattleRoleBelong.player)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91024_18", 1, self.OnAfterBattleStart)
end

bs_91024.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.arglist)[1] < (self.caster).hp * 1000 // (self.caster).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil)
  end
end

bs_91024.OnHealResultEnd = function(self, skill, targetRole, healValue)
  -- function num : 0_3 , upvalues : _ENV
  if (self.arglist)[1] < (self.caster).hp * 1000 // (self.caster).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil)
  end
end

bs_91024.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_4 , upvalues : _ENV
  if (self.caster).hp * 1000 // (self.caster).maxHp < (self.arglist)[1] then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_91024.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91024

