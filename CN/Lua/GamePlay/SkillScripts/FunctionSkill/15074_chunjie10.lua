-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15074 = class("bs_15074", LuaSkillBase)
local base = LuaSkillBase
bs_15074.config = {buffId = 1267, buffId1 = 1267, buffTierFormula = 10036}
bs_15074.ctor = function(self)
  -- function num : 0_0
end

bs_15074.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15074_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_15074_3", 1, self.OnAfterHurt, nil, self.caster)
  self:AddAfterHealTrigger("bs_15074_5", 1, self.OnAfterHeal, nil, self.caster)
end

bs_15074.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and target.hp > 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0, true)
    local buffTier = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).buffTierFormula, self.caster, self.caster, self)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier, nil, true)
    end
  end
end

bs_15074.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local buffTier = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).buffTierFormula, self.caster, self.caster, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier)
end

bs_15074.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if target == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0, true)
    local buffTier = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).buffTierFormula, self.caster, self.caster, self)
    if buffTier > 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier, nil, true)
    end
  end
end

bs_15074.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15074

