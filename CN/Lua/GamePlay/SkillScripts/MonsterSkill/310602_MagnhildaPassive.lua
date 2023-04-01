-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_310602 = class("bs_310602", LuaSkillBase)
local base = LuaSkillBase
bs_310602.config = {buffId_doblueTower = 196, effectId_passive = 10491702, effectId_shield = 10491802, buffId = 104901, buffId_stun = 3006, buffId_live = 3009, nanaka_buffId = 102603, healConfigId = 4, hurtConfigId = 2, shieldFormula = 3022}
bs_310602.ctor = function(self)
  -- function num : 0_0
end

bs_310602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_310602_1", 99, self.OnSetDeadHurt, nil, self.caster)
  self:AddAfterHurtTrigger("bs_310602_2", 1, self.OnAfterHurt, nil, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.OnBreakShield, "bs_310602_22", 1, self.OnBreakShield)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_310602_3", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnRealSummonerCaster)
  self.hpNum = (math.max)(1, (self.caster).maxHp * (self.arglist)[1] // 1000)
  self.recordNum = 0
end

bs_310602.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_doblueTower, 1)
end

bs_310602.OnRealSummonerCaster = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= self.caster then
    return val
  end
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_doblueTower, 1)
end

bs_310602.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if target == self.caster and hurt > 0 then
    self.recordNum = self.recordNum + hurt
  end
  while self.hpNum <= self.recordNum do
    self.recordNum = self.recordNum - self.hpNum
    LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[2])
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passive, self)
  end
end

bs_310602.OnSetDeadHurt = function(self, context)
  -- function num : 0_5 , upvalues : _ENV
  if context.target == self.caster and (context.target):GetBuffTier((self.config).buffId) > 0 and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_live, 1, 1, true)
    LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_5_0 , upvalues : context, self, _ENV
    if context.target == nil or (context.target).hp <= 0 then
      return 
    end
    local tier = (context.target):GetBuffTier((self.config).buffId)
    local num = (self.arglist)[3] * tier
    local shieldValue = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).shieldFormula, self.caster, self.caster, self, num)
    if shieldValue > 0 then
      LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue)
    end
    self.shieldEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_shield, self)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
)
  end
end

bs_310602.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_6
  if self.shieldEffect ~= nil then
    (self.shieldEffect):Die()
    self.shieldEffect = nil
  end
end

bs_310602.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.shieldEffect ~= nil then
    (self.shieldEffect):Die()
    self.shieldEffect = nil
  end
end

bs_310602.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
  self.shieldEffect = nil
end

return bs_310602

