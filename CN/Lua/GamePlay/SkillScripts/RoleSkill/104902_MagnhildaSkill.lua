-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104902 = class("bs_104902", LuaSkillBase)
local base = LuaSkillBase
bs_104902.config = {effectId_attack = 104903, effectId_hit1 = 104904, effectId_hit2 = 104905, effectId_hit3 = 104906, buffId_passive = 104901, buffId_skill = 104902, buffId_stun = 3006, shieldFormula = 3022, skill_time = 27, actionId = 1021, action_speed = 1, start_time = 6, start_time2 = 4, start_time3 = 7, hurtConfigId = 2}
bs_104902.ctor = function(self)
  -- function num : 0_0
end

bs_104902.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.BeforeAddBuff, "bs_104902_7", 1, self.OnBeforeAddBuff)
end

bs_104902.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    if target ~= nil then
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
      ;
      (self.caster):LookAtTarget(target)
      self:CallCasterWait((self.config).skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_attack, self, nil, nil, nil, true)
    end
  end
end

bs_104902.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skill, 1)
  self.Mask = LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_passive, 1)
  if (self.caster):GetBuffTier((self.config).buffId_passive) == 1 then
    self.MaskEffect = ((self.Mask).listBattleEffect)[0]
  end
  local MaskEffectNum = (self.caster):GetBuffTier((self.config).buffId_passive) - 1
  LuaSkillCtrl:EffectSetCountActive(self.MaskEffect, MaskEffectNum, true)
  if target == nil or target.hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit1, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[1]})
  skillResult:EndResult()
  LuaSkillCtrl:StartTimer(self, (self.config).start_time2, function()
    -- function num : 0_3_0 , upvalues : target, _ENV, self
    if target == nil or target.hp <= 0 then
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[2]})
    skillResult:EndResult()
    LuaSkillCtrl:StartTimer(self, (self.config).start_time3, function()
      -- function num : 0_3_0_0 , upvalues : target, _ENV, self
      if target == nil or target.hp <= 0 then
        return 
      end
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit3, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[3]})
      skillResult:EndResult()
      self:OnSkillDamageEnd()
    end
)
  end
)
end

bs_104902.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_4 , upvalues : _ENV
  if target == self.caster and ((context.buff).buffCfg).IsControl == true and (self.caster):GetBuffTier((self.config).buffId_skill) > 0 and (((context.buff).maker).belongNum ~= (self.caster).belongNum or ((context.buff).battleSkill).dataId == 20118) then
    context.active = false
    self.Mask = LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_passive, 1)
    if (self.caster):GetBuffTier((self.config).buffId_passive) == 1 then
      self.MaskEffect = ((self.Mask).listBattleEffect)[0]
    end
    local MaskEffectNum = (self.caster):GetBuffTier((self.config).buffId_passive) - 1
    LuaSkillCtrl:EffectSetCountActive(self.MaskEffect, MaskEffectNum, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_skill, 0)
  end
end

bs_104902.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104902.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.Mask = nil
  self.MaskEffect = nil
end

return bs_104902

