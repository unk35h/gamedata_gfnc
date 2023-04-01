-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102205 = class("bs_102205", LuaSkillBase)
local base = LuaSkillBase
bs_102205.config = {buffId_critical = 102202, buffId_storage = 225, buffId_crit = 102201}
bs_102205.ctor = function(self)
  -- function num : 0_0
end

bs_102205.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_102205_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_102205_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2 = true
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2_target = (self.arglist)[5]
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2_caster = (self.arglist)[6]
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2_max = (self.arglist)[7]
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2_time = (self.arglist)[8]
end

bs_102205.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critical, 1)
end

bs_102205.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
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

bs_102205.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102205

