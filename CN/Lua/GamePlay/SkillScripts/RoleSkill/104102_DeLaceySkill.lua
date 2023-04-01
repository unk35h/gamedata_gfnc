-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104102 = class("bs_104102", LuaSkillBase)
local base = LuaSkillBase
bs_104102.config = {start_time = 22, end_time = 20, actionId = 1008, actionId_end = 1009, action_speed = 1, radius = 50, speed = 5, buffId_196 = 196, buffId_170 = 170, buffId_pow = 104101, buffId_skill = 104102, buffId_pow_weapon = 104103, buffId_skill_weapon = 104104, buffId_pow_skill = 104105, buffId_int_skill = 104106, effectId_line = 104108, effectId_trail = 104110, effectId_hit = 104109, effectId_skill1 = 104114, effectId_skill2 = 104115, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
, weaponLv = 0, effectId_line_weapon = 104124, effectId_line_weapon2 = 104128, effectId_hit_weapon = 104127}
bs_104102.ctor = function(self)
  -- function num : 0_0
end

bs_104102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_104102_11", 1, self.OnRoleDie)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["skill_arglist[1]"] = 0
  self.open = false
end

bs_104102.PlaySkill = function(self, data)
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

bs_104102.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    self.open = true
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[4])
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

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
    if (self.config).weaponLv >= 3 then
      if ((self.caster).recordTable).pass_target ~= nil then
        if (((self.caster).recordTable).pass_target):GetBuffTier((self.config).buffId_pow) > 0 then
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).pass_target, (self.config).buffId_pow_skill, 1, (self.arglist)[4])
        else
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).pass_target, (self.config).buffId_int_skill, 1, (self.arglist)[4])
        end
        self.loophit = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_hit_weapon, self, nil, nil, nil, true)
        self.loopLine_weapon = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_line_weapon, self, nil, nil, nil, true)
      end
      if ((self.caster).recordTable).weapon_target ~= nil then
        if (((self.caster).recordTable).weapon_target):GetBuffTier((self.config).buffId_pow_weapon) > 0 then
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).weapon_target, (self.config).buffId_pow_skill, 1, (self.arglist)[4])
        else
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).weapon_target, (self.config).buffId_int_skill, 1, (self.arglist)[4])
        end
        self.loopLine_weapon2 = LuaSkillCtrl:CallEffect(((self.caster).recordTable).weapon_target, (self.config).effectId_line_weapon2, self, nil, nil, nil, true)
        self.loophit_weapon = LuaSkillCtrl:CallEffect(((self.caster).recordTable).weapon_target, (self.config).effectId_hit_weapon, self, nil, nil, nil, true)
      end
    end
  end
end

bs_104102.onSkillHurt = function(self, target)
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

bs_104102.OnCollision = function(self, collider, index, entity)
  -- function num : 0_5 , upvalues : _ENV
  if LuaSkillCtrl:IsFixedObstacle(entity) then
    return 
  end
  LuaSkillCtrl:CallEffect(entity, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
  skillResult:EndResult()
end

bs_104102.OnOver = function(self)
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
  LuaSkillCtrl:DispelBuff(((self.caster).recordTable).pass_target, (self.config).buffId_pow_skill, 0, false)
  LuaSkillCtrl:DispelBuff(((self.caster).recordTable).pass_target, (self.config).buffId_int_skill, 0, false)
  LuaSkillCtrl:DispelBuff(((self.caster).recordTable).weapon_target, (self.config).buffId_pow_skill, 0, false)
  LuaSkillCtrl:DispelBuff(((self.caster).recordTable).weapon_target, (self.config).buffId_int_skill, 0, false)
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
  if self.loophit ~= nil then
    (self.loophit):Die()
    self.loophit = nil
  end
  if self.loophit_weapon ~= nil then
    (self.loophit_weapon):Die()
    self.loophit_weapon = nil
  end
  if self.loopLine_weapon ~= nil then
    (self.loopLine_weapon):Die()
    self.loopLine_weapon = nil
  end
  if self.loopLine_weapon2 ~= nil then
    (self.loopLine_weapon2):Die()
    self.loopLine_weapon2 = nil
  end
  self.open = false
  self:OnSkillDamageEnd()
end

bs_104102.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : base
  if role == self.caster then
    self:OnOver()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_104102.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_8
  if role == ((self.caster).recordTable).pass_target then
    self:OnOver()
  end
end

bs_104102.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104102.LuaDispose = function(self)
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
  if self.loophit ~= nil then
    (self.loophit):Die()
    self.loophit = nil
  end
  if self.loophit_weapon ~= nil then
    (self.loophit_weapon):Die()
    self.loophit_weapon = nil
  end
  if self.loopLine_weapon ~= nil then
    (self.loopLine_weapon):Die()
    self.loopLine_weapon = nil
  end
  if self.hurt_timer ~= nil then
    (self.hurt_timer):Stop()
    self.hurt_timer = nil
  end
end

return bs_104102

