-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102204 = class("bs_102204", LuaSkillBase)
local base = LuaSkillBase
bs_102204.config = {buffId_critical = 102202, buffId_storage = 225, buffId_crit = 102201}
bs_102204.ctor = function(self)
  -- function num : 0_0
end

bs_102204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_102204_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_102204_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_102204.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critical, 1)
end

bs_102204.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack then
    if not isCrit then
      if (self.caster):GetBuffTier((self.config).buffId_crit) > 0 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_crit, 1, (self.arglist)[3], true)
      else
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_storage, 1, nil, true)
      end
    end
    if isCrit then
      local num = (self.caster):GetBuffTier((self.config).buffId_storage)
      if num > 0 and (self.caster):GetBuffTier((self.config).buffId_crit) == 0 then
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_storage, 0, true)
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_crit, num, (self.arglist)[3], true)
      end
    end
  end
end

bs_102204.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102204

