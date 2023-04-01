-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209206 = class("bs_209206", LuaSkillBase)
local base = LuaSkillBase
bs_209206.config = {buffId_fly = 209204, buffId_hurt = 209206, actionId_start = 1050, actionId_loop = 1049, actionId_end = 1051, actionId_end1 = 1052, action_speed = 1, actionId_start_time = 16, actionId_end_time = 35, actionId_end1_time = 38, effectId_fly = 209213, effectId_loop = 209214, effectId_aim = 209215, effectId_hit = 209216, effectId_interrupt = 209217, configId = 3}
bs_209206.ctor = function(self)
  -- function num : 0_0
end

bs_209206.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = (self.arglist)[2]
end

bs_209206.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:OnSkillTake()
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_209206_1", 1, self.OnBreakShield)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_fly, self)
  local tempTarget = LuaSkillCtrl:CallTargetSelect(self, 19, 10)
  if tempTarget == nil then
    return 
  end
  local target = (tempTarget[0]).targetRole
  ;
  (self.caster):LookAtTarget(target)
  if target == nil or target.hp <= 0 then
    return 
  end
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
  self:CallCasterWait(time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  self.loopAttack = LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, (self.config).action_speed)
    self.loop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self)
  end
, nil)
  self.finishAttack = LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time + self.loopTime, function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
    self:RemoveSkillTrigger(eSkillTriggerType.OnBreakShield)
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, time, true)
  self:AbandonSkillCdAutoReset(true)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(self, time, callnextskill)
end

bs_209206.OnAttackTrigger = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_fly, 1, self.loopTime)
  local value = (self.caster).maxHp * (self.arglist)[3] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, value)
  self.aim = LuaSkillCtrl:CallEffect(target, (self.config).effectId_aim, self)
  local shoot = BindCallback(self, self.ShootWave, target)
  self.onLoopAttack = LuaSkillCtrl:StartTimer(self, self.loopTime + 3, shoot, self, nil)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[2])
  self.boom = LuaSkillCtrl:StartTimer(self, (self.arglist)[2], function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, 3)
    if SelfShieldValue ~= 0 then
      LuaSkillCtrl:ClearShield(self.caster, 3)
    end
  end
)
end

bs_209206.ShootWave = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  if self.loop ~= nil then
    (self.loop):Die()
    self.loop = nil
  end
  if self.aim ~= nil then
    (self.aim):Die()
    self.aim = nil
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
  skillResult:EndResult()
end

bs_209206.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_5 , upvalues : _ENV
  if target == self.caster and shieldType == 3 then
    if self.boom ~= nil then
      (self.boom):Stop()
      self.boom = nil
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_interrupt, self)
    if self.loopAttack ~= nil then
      (self.loopAttack):Stop()
      self.loopAttack = nil
    end
    if self.finishAttack ~= nil then
      (self.finishAttack):Stop()
      self.finishAttack = nil
    end
    if self.onLoopAttack ~= nil then
      (self.onLoopAttack):Stop()
      self.onLoopAttack = nil
    end
    if self.loop ~= nil then
      (self.loop):Die()
      self.loop = nil
    end
    if self.aim ~= nil then
      (self.aim):Die()
      self.aim = nil
    end
    local OnDropTrigger = BindCallback(self, self.OnDropTrigger)
    self:RemoveSkillTrigger(eSkillTriggerType.OnBreakShield)
    local time = (self.config).actionId_end1_time
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_end1, (self.config).action_speed, (self.config).actionId_end1_time, OnDropTrigger)
  end
end

bs_209206.OnDropTrigger = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, 170, 1)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_fly, 1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_hurt, 1, (self.arglist)[4])
  self:EndSkillAndCallNext()
end

bs_209206.EndSkillAndCallNext = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  ;
  (self.caster):CallUnFreezeNextSkill()
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_209206.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.loopAttack ~= nil then
    (self.loopAttack):Stop()
    self.loopAttack = nil
  end
  if self.finishAttack ~= nil then
    (self.finishAttack):Stop()
    self.finishAttack = nil
  end
  if self.onLoopAttack ~= nil then
    (self.onLoopAttack):Stop()
    self.onLoopAttack = nil
  end
  if self.loop ~= nil then
    (self.loop):Die()
    self.loop = nil
  end
  if self.aim ~= nil then
    (self.aim):Die()
    self.aim = nil
  end
end

return bs_209206

