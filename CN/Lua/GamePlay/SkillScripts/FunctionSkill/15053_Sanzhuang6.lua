-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15053 = class("bs_15053", LuaSkillBase)
local base = LuaSkillBase
bs_15053.config = {buffId = 1244}
bs_15053.ctor = function(self)
  -- function num : 0_0
end

bs_15053.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15053_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_15053_3", 1, self.OnAfterHurt, nil, self.caster)
  self:AddAfterHealTrigger("bs_15053_5", 1, self.OnAfterHeal, nil, self.caster)
end

bs_15053.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).hp == (self.caster).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  else
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_15053.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if (self.caster).hp == (self.caster).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  else
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_15053.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if (self.caster).hp == (self.caster).maxHp then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  else
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_15053.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15053

