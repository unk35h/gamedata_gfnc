-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210201 = class("bs_210201", LuaSkillBase)
local base = LuaSkillBase
bs_210201.config = {skill_time = 25, start_time = 6, start_time2 = 4, dd_time = 3, hdRate = 30, actionId_attack3 = 1025, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, action_speed = 1, buffIdHD = 207802, effectId_skill = 10779, effectId_bnfffire = 100307, effectId_trail2 = 210202, effectId_qk = 210205, effectId_bd = 207805, buffId_170 = 3008, audioId = 207803, 
hurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, crithur_ratio = 0}
, buffId_js = 210201, time_loop = 7}
bs_210201.ctor = function(self)
  -- function num : 0_0
end

bs_210201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_210201.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local noAttack_time = 17
  self:CallCasterWait(noAttack_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 35, true)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, 35, true)
end

bs_210201.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
  self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_qk, self, nil, nil, nil, true)
  local num_now = (self.arglist)[1]
  local num = 0
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  while 1 do
    if targetList ~= nil and num_now > 0 and targetList.Count > 0 then
      if targetList.Count < num_now then
        for i = 0, targetList.Count - 1 do
          self:AttackEnemy(targetList[i], num)
        end
        num_now = num_now - targetList.Count
        num = num + 1
        -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

        -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  for i = 0, num_now - 1 do
    self:AttackEnemy(targetList[i], num)
  end
  do
    LuaSkillCtrl:StartTimer(self, (num) * (self.config).time_loop + (self.config).time_loop - 2, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:BreakCurrentAction(self.caster)
    if self.skillLoop ~= nil then
      (self.skillLoop):Die()
      self.skillLoop = nil
    end
    LuaSkillCtrl:StartTimer(self, 1, function()
      -- function num : 0_3_0_0 , upvalues : _ENV, self
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
      LuaSkillCtrl:DispelBuff(self.caster, 196, 0)
      self:CancleCasterWait()
    end
)
  end
)
    local time1 = (num) * (self.config).time_loop + (self.config).time_loop
    LuaSkillCtrl:StartShowSkillDurationTime(self, time1)
    self:AddCasterWait(time1 + 2)
    LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, time1, true)
    LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, time1, true)
  end
end

bs_210201.AttackEnemy = function(self, target, num)
  -- function num : 0_4 , upvalues : _ENV
  local Time = num * (self.config).time_loop
  LuaSkillCtrl:StartTimer(self, Time, function()
    -- function num : 0_4_0 , upvalues : _ENV, target, self
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail2, self, self.OnEffectTrigger)
  end
)
end

bs_210201.OnEffectTrigger = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail2 and eventId == eBattleEffectEvent.Trigger and target ~= nil and (target.targetRole).hp > 0 then
    local num = (target.targetRole):GetBuffTier((self.config).buffId_js)
    if num <= 4 then
      local hurt = (self.arglist)[2] + (self.arglist)[3] * num
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurtConfig, {hurt})
      skillResult:EndResult()
    else
      do
        local hurt2 = (self.arglist)[2] + (self.arglist)[3] * 4 + (self.arglist)[5]
        do
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurtConfig, {hurt2})
          skillResult:EndResult()
          LuaSkillCtrl:DispelBuff(target.targetRole, (self.config).buffId_js, 0)
          LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_js, 1, (self.arglist)[4])
        end
      end
    end
  end
end

bs_210201.OnBreakSkill = function(self, role)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnBreakSkill)(self, role)
  if role == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
    LuaSkillCtrl:DispelBuff(self.caster, 196, 0)
    LuaSkillCtrl:StopShowSkillDurationTime(self)
    self:CancleCasterWait()
    if self.skillLoop ~= nil then
      (self.skillLoop):Die()
      self.skillLoop = nil
    end
  end
end

bs_210201.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
end

return bs_210201

