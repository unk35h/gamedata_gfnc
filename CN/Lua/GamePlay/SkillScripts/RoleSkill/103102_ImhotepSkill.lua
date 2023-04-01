-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103102 = class("bs_103102", LuaSkillBase)
local base = LuaSkillBase
bs_103102.config = {audioId1 = 103103, audioId2 = 103104, effectId_heal = 103104, effectId_trail = 103103, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010}
, 
heal_config = {baseheal_formula = 3021}
, 
hurtConfig2 = {hit_formula = 0, basehurt_formula = 3010, def_formula = 103102, crit_formula = 9992, returndamage_formula = 0}
, weaponLv = 0, buffId_weapon = 103105, effectId_weapon = 103109, 
HealConfig = {baseheal_formula = 501}
, effectId_heal1 = 103114, HurtConfigID1 = 21}
bs_103102.ctor = function(self)
  -- function num : 0_0
end

bs_103102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_103103_3", 1, self.OnAfterHurt, nil, nil)
end

bs_103102.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 10) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    self:CallCasterWait(15)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
    if target ~= nil then
      (self.caster):LookAtTarget(target)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, 1002, 1.5, 1, attackTrigger)
      LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
    end
    if (self.config).weaponLv >= 1 then
      self.friNum = 0
      local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, true)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          local role = targetList[i]
          if role.belongNum == (self.caster).belongNum then
            self.friNum = self.friNum + 1
          end
        end
      end
    end
  end
end

bs_103102.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self, self.SkillEventFunc)
end

bs_103102.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    self.target_effect = LuaSkillCtrl:GetTargetWithGrid((target.targetRole).x, (target.targetRole).y)
    local caster_effect = LuaSkillCtrl:GetTargetWithGrid((self.caster).x, (self.caster).y)
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target.targetRole)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
    if (self.config).weaponLv >= 1 then
      local hurtNum = (self.arglist)[1]
      hurtNum = hurtNum + (self.arglist)[4] * self.friNum
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurtConfig2, {hurtNum})
      skillResult:EndResult()
      self:OnSkillDamageEnd()
    else
      do
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]})
        skillResult:EndResult()
        self:OnSkillDamageEnd()
        if (self.config).weaponLv >= 1 then
          LuaSkillCtrl:CallEffect(self.target_effect, (self.config).effectId_weapon, self, self.SkillEventFunc_heal)
        else
          LuaSkillCtrl:CallEffect(self.target_effect, (self.config).effectId_heal, self, self.SkillEventFunc_heal)
        end
        LuaSkillCtrl:CallEffect(caster_effect, (self.config).effectId_heal, self, self.SkillEventFunc_heal)
      end
    end
  end
end

bs_103102.SkillEventFunc_heal = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Create then
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, true)
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum == (self.caster).belongNum then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        local healNum = (self.arglist)[2]
        LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healNum})
        skillResult:EndResult()
        if (self.config).weaponLv >= 3 and self.target_effect == target then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_weapon, 1, (self.arglist)[7])
        end
      end
    end
  end
end

bs_103102.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_6 , upvalues : _ENV
  local boneTarget = sender:GetBuffTier((self.config).buffId_weapon)
  if target ~= sender and boneTarget > 0 and skill.isCommonAttack and not isTriggerSet then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID1, {(self.arglist)[5]}, true)
    skillResult:EndResult()
    local target_heal = sender
    LuaSkillCtrl:CallEffectWithArgOverride(target_heal, (self.config).effectId_heal1, self, target, nil, nil, self.SkillEventFunc1)
  end
  do
    if (self.config).weaponLv >= 1 and sender == self.caster and (skill.dataId == 103102 or skill.dataId == 103104 or skill.dataId == 103106) and not isTriggerSet then
      local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, true)
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role.belongNum == (self.caster).belongNum then
          local healNum1 = hurt * (self.arglist)[3] // 1000
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {healNum1})
          skillResult:EndResult()
        end
      end
    end
  end
end

bs_103102.SkillEventFunc1 = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and target ~= nil and (target.targetRole).hp > 0 then
    local heal = (target.targetRole).maxHp * (self.arglist)[6] // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {heal}, true)
    skillResult:EndResult()
  end
end

bs_103102.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  self.target_effect = nil
end

bs_103102.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.target_effect = nil
end

return bs_103102

