-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210101 = class("bs_210101", LuaSkillBase)
local base = LuaSkillBase
bs_210101.config = {buffId = 210101, buffId_speed = 210102, effectId_change1 = 210100, effectId_change = 210101}
bs_210101.ctor = function(self)
  -- function num : 0_0
end

bs_210101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_210101_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_210101_2", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).attack_id = 0
end

bs_210101.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isMiss then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[4], true)
    if ((self.caster).recordTable).attack_id == 1 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_change, self)
    else
      if ((self.caster).recordTable).attack_id == 2 then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_change1, self)
      end
    end
  end
  if sender == self.caster and skill.isCommonAttack and isMiss and (self.caster):GetBuffTier((self.config).buffId) > 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  end
  local buffTier = sender:GetBuffTier((self.config).buffId)
  if buffTier > 0 then
    local scale = buffTier * 0.1 + 1
    LuaSkillCtrl:CallStartLocalScale(sender, (Vector3.New)(scale, scale, scale))
  else
    do
      LuaSkillCtrl:CallStartLocalScale(sender, (Vector3.New)(1, 1, 1))
    end
  end
end

bs_210101.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1)
end

bs_210101.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210101

