-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105600 = class("bs_105600", bs_1)
local base = bs_1
bs_105600.config = {effectId_trail = 105608, action1 = 1001, action2 = 1001, effectId_action_1 = 105610, baseActionSpd = 1, skill_time = 39, start_time = 15, buffId_tr = 105602, effectId_passtrail = 105611, effectId_passqk = 105613, action_pass = 1004, HurtConfig = 15}
bs_105600.config = setmetatable(bs_105600.config, {__index = base.config})
bs_105600.ctor = function(self)
  -- function num : 0_0
end

bs_105600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105600.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  if LuaSkillCtrl:CallRange(1, 1000) <= ((self.caster).recordTable)["105601_Roll"] then
    local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
    local atkSpeedRatio = 1
    local atkActionId = data.action_pass
    local atkTriggerFrame = 0
    atkSpeedRatio = self:CalcAtkActionSpeedForAirplane(atkSpeed, 2) * (self.config).baseActionSpd
    atkActionId = data.action_pass
    atkTriggerFrame = self:GetAtkTriggerFrameForAirplane(2, atkSpeed)
    local attackTrigger2 = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    self:CallCasterWait(atkSpeed + 2)
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = target
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action_pass, atkSpeedRatio, atkTriggerFrame, attackTrigger2)
  else
    do
      ;
      (base.RealPlaySkill)(self, target, data)
    end
  end
end

bs_105600.CalcAtkActionSpeedForAirplane = function(self, atkInterval, atkId)
  -- function num : 0_3
  local atkTotalFrames = (self.config).skill_time
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_105600.GetAtkTriggerFrameForAirplane = function(self, atkId, atkInterval)
  -- function num : 0_4
  local atkTotalFrames = (self.config).skill_time
  local triggerFrameCfg = (self.config).start_time
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_105600.OnAttackTrigger2 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passqk, self)
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_passtrail, self, nil, false, self.SkillEventFunc2, data)
  else
    self:BreakSkill()
  end
  if self.isDoubleAttack then
    local attackTrigger = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
  else
    do
      self:CancleCasterWait()
    end
  end
end

bs_105600.SkillEventFunc2 = function(self, data, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {((self.caster).recordTable)["105601_arg2"]}, false, false)
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_tr, 1, 1)
  end
end

bs_105600.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105600

