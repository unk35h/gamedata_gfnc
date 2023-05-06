-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106700 = class("bs_106700", bs_1)
local base = bs_1
bs_106700.config = {effectId_1 = 106701, action1 = 1001, action2 = 1001, baseActionSpd = 1, skill_time = 28, start_time = 7, skill_time1 = 31, start_time1 = 10, buffId_tr = 106702, action_pass = 1004, effectId_pass1 = 106702, effectId_pass2 = 106704, HurtConfig = 29, HurtConfig2 = 30}
bs_106700.config = setmetatable(bs_106700.config, {__index = base.config})
bs_106700.ctor = function(self)
  -- function num : 0_0
end

bs_106700.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.num = 0
end

bs_106700.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV
  self.num = self.num + 1
  if ((self.caster).recordTable)["106701_Roll"] <= self.num then
    self.num = 0
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
      local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
      local atkSpeedRatio = 1
      local atkActionId = data.action1
      local atkTriggerFrame = 0
      atkSpeedRatio = self:CalcAtkActionSpeedForAirplane2(atkSpeed, 2) * (self.config).baseActionSpd
      atkActionId = data.action1
      atkTriggerFrame = self:GetAtkTriggerFrameForAirplane2(2, atkSpeed)
      local attackTrigger3 = BindCallback(self, self.OnAttackTrigger3, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
      self:CallCasterWait(atkSpeed + 2)
      -- DECOMPILER ERROR at PC94: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).lastAttackRole = target
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action1, atkSpeedRatio, atkTriggerFrame, attackTrigger3)
    end
  end
end

bs_106700.CalcAtkActionSpeedForAirplane = function(self, atkInterval, atkId)
  -- function num : 0_3
  local atkTotalFrames = (self.config).skill_time
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106700.CalcAtkActionSpeedForAirplane2 = function(self, atkInterval, atkId)
  -- function num : 0_4
  local atkTotalFrames = (self.config).skill_time1
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106700.GetAtkTriggerFrameForAirplane = function(self, atkId, atkInterval)
  -- function num : 0_5
  local atkTotalFrames = (self.config).skill_time
  local triggerFrameCfg = (self.config).start_time
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106700.GetAtkTriggerFrameForAirplane2 = function(self, atkId, atkInterval)
  -- function num : 0_6
  local atkTotalFrames = (self.config).skill_time1
  local triggerFrameCfg = (self.config).start_time1
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106700.OnAttackTrigger2 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_pass1, self)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_pass2, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {((self.caster).recordTable)["106701_break"]}, false, false)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig2, {((self.caster).recordTable)["106701_break"], ((self.caster).recordTable)["106701_arg2"]}, false, false)
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tr, 1, 1)
  else
    do
      self:BreakSkill()
      if self.isDoubleAttack then
        local attackTrigger = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
        self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
      else
        do
          self:CancleCasterWait()
        end
      end
    end
  end
end

bs_106700.OnAttackTrigger3 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_1, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {((self.caster).recordTable)["106701_break"]}, false, false)
    skillResult:EndResult()
  else
    do
      self:BreakSkill()
      if self.isDoubleAttack then
        local attackTrigger = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
        self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
      else
        do
          self:CancleCasterWait()
        end
      end
    end
  end
end

bs_106700.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106700

