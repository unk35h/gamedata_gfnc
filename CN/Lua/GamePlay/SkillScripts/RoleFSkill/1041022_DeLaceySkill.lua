-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1041022 = class("bs_1041022", LuaSkillBase)
local base = LuaSkillBase
bs_1041022.config = {start_time = 22, end_time = 20, actionId = 1008, actionId_end = 1009, action_speed = 1, radius = 50, speed = 5, buffId_196 = 19601, buffId_170 = 170, effectId_line = 104108, effectId_trail = 104110, effectId_hit = 104109, effectId_skill1 = 104114, effectId_skill2 = 104115, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_1041022.ctor = function(self)
  -- function num : 0_0
end

bs_1041022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_1041022_11", 1, self.OnRoleDie)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["skill_arglist[1]"] = 0
  self.open = false
end

bs_1041022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = ((self.caster).recordTable).pass_target
  if target ~= nil and LuaSkillCtrl.IsInTDBattle and target.x == (ConfigData.buildinConfig).BenchX then
    return 
  end
  if target ~= nil and target.hp > 0 then
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
    ;
    (self.caster):LookAtTarget(target)
    self:CallCasterWait((self.config).start_time + (self.arglist)[4])
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.config).start_time + (self.arglist)[4], true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.config).start_time + (self.arglist)[4], true)
  end
end

bs_1041022.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    self.open = true
    LuaSkillCtrl:CallRoleAction(self.caster, 1007)
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[4])
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.caster).recordTable)["skill_arglist[1]"] = (self.arglist)[1]
    local num = (self.arglist)[4] // (self.arglist)[2] - 1
    local skill_hurt = BindCallback(self, self.onSkillHurt, target)
    local onOver = BindCallback(self, self.OnOver)
    self.loopLine = LuaSkillCtrl:CallEffect(target, (self.config).effectId_line, self, nil, nil, nil, true)
    self.loop_skill1 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skill1, self, nil, nil, nil, true)
    self.loop_skill2 = LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill2, self, nil, nil, nil, true)
    self.hurt_timer = LuaSkillCtrl:StartTimer(self, (self.arglist)[2], skill_hurt, self, num, (self.arglist)[2] - 1)
    LuaSkillCtrl:StartTimer(self, (self.arglist)[4], onOver, self)
  end
end

bs_1041022.onSkillHurt = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  if target ~= nil and LuaSkillCtrl.IsInTDBattle and target.x == (ConfigData.buildinConfig).BenchX then
    self:OnOver()
    return 
  end
  if target ~= nil and target.hp > 0 then
    local cusEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_trail, self)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (cusEffect.lsObject).localPosition = ((self.caster).lsObject).localPosition
    local collisionTrigger = BindCallback(self, self.OnCollision)
    LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, target, (self.config).radius, (self.config).speed, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, cusEffect, false, true, nil)
  end
end

bs_1041022.OnCollision = function(self, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if LuaSkillCtrl:IsFixedObstacle(entity) then
    return 
  end
  LuaSkillCtrl:CallEffect(entity, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
  skillResult:EndResult()
end

bs_1041022.OnOver = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 0, true)
  if self.open == false then
    return 
  end
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["skill_arglist[1]"] = 0
  self:CancleCasterWait()
  self:CallCasterWait((self.config).end_time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  if self.loopLine ~= nil then
    (self.loopLine):Die()
    self.loopLine = nil
  end
  if self.loop_skill1 ~= nil then
    (self.loop_skill1):Die()
    self.loop_skill1 = nil
  end
  if self.loop_skill2 ~= nil then
    (self.loop_skill2):Die()
    self.loop_skill2 = nil
  end
  if self.hurt_timer ~= nil then
    (self.hurt_timer):Stop()
    self.hurt_timer = nil
  end
  self.open = false
end

bs_1041022.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : base
  if role == self.caster then
    self:OnOver()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_1041022.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_8
  if role == ((self.caster).recordTable).pass_target then
    self:OnOver()
  end
end

bs_1041022.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_1041022.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  if self.loopLine ~= nil then
    (self.loopLine):Die()
    self.loopLine = nil
  end
  if self.loop_skill1 ~= nil then
    (self.loop_skill1):Die()
    self.loop_skill1 = nil
  end
  if self.loop_skill2 ~= nil then
    (self.loop_skill2):Die()
    self.loop_skill2 = nil
  end
  if self.hurt_timer ~= nil then
    (self.hurt_timer):Stop()
    self.hurt_timer = nil
  end
end

return bs_1041022

