-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102402 = class("bs_102402", LuaSkillBase)
local base = LuaSkillBase
bs_102402.config = {buffId_236 = 236, buffId_196 = 196, buffId_170 = 170, skill_time = 20, effectId_DDL = 10744, effectId_DDLs = 102408, 
Aoe = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0}
, start_time = 20, actionId = 1002, actionId_end = 1009, action_speed = 1, end_time = 32, audioId1 = 246, audio_loop = 247}
bs_102402.ctor = function(self)
  -- function num : 0_0
end

bs_102402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_102402_1", 1, self.BeforeEndBattle)
  self.DD = 0
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).skill_arg1 = (self.arglist)[1]
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).cskill = self.cskill
end

bs_102402.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.config).start_time + (self.arglist)[2], true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.config).start_time + (self.arglist)[2], true)
  self.action = true
end

bs_102402.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.action = false
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[2])
  local over = BindCallback(self, self.Onover)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_236, 1, (self.arglist)[2], true)
  self.loopAudio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audio_loop)
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and last_target:IsUnSelect(self.caster) then
    target = last_target
  else
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 1001, 0)
    if targetList.Count > 0 then
      target = (targetList[0]).targetRole
    end
  end
  do
    if target ~= nil then
      if LuaSkillCtrl:GetCasterSkinId(self.caster) == 302404 then
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_DDLs, self, self.SkillEventFunc)
      else
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_DDL, self, self.SkillEventFunc)
      end
    end
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).curStartShowDurationSkill = self
    self.onOverTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], over)
  end
end

bs_102402.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target.targetRole, (self.config).Aoe)
    LuaSkillCtrl:PlayAuHit(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_102402.Onover = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 1, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 1, true)
  self:CallCasterWait((self.config).end_time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  self:OnSkillDamageEnd()
end

bs_102402.OnBreakSkill = function(self, role)
  -- function num : 0_6 , upvalues : _ENV
  if role == self.caster and self.action == true then
    self.action = false
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 1, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 1, true)
    self:CancleCasterWait()
  end
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
  if role ~= self.caster then
    return 
  end
  if self.timers ~= nil then
    local leng = (table.length)(self.timers)
    if leng > 0 then
      for i = 1, leng do
        if (self.timers)[i] ~= nil then
          ((self.timers)[i]):Stop()
          -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.timers)[i] = nil
        end
      end
    end
    do
      do
        self.timers = {}
        self:RemoveAllBreakKillEffects()
        if self.isSkillUncompleted then
          (self.caster):RemoveSkillWaitBuff()
          ;
          (self.cskill):ReturnCDTimeFromBreak()
          self.isSkillUncompleted = false
        end
        self:OnSkillDamageEnd()
      end
    end
  end
end

bs_102402.BeforeEndBattle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
end

bs_102402.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
  if self.onOverTimer ~= nil then
    (self.onOverTimer):Stop()
    self.onOverTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_102402

