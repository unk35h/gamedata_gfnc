-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105800 = class("bs_105800", bs_1)
local base = bs_1
bs_105800.config = {effectId_trail = 105807, effectId_action_1 = 105809, action1 = 1001, action2 = 1001, action_pass1 = 1021, action_pass2 = 1004, baseActionSpd = 1, skill_time2 = 26, start_time2 = 8, skill_time = 38, start_time = 10, buffId_tr = 105602, effectId_passtrail = 105804, effectId_passqk = 105806, effectId_passqk2 = 105828, effectId_passtrail2 = 105821, effectId_passtrail3 = 105823, effectId_passAoe = 105803, HurtConfig1 = 17, HurtConfig2 = 17, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
}
bs_105800.config = setmetatable(bs_105800.config, {__index = base.config})
bs_105800.ctor = function(self)
  -- function num : 0_0
end

bs_105800.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105800.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  if LuaSkillCtrl:CallRange(1, 1000) <= ((self.caster).recordTable)["105801_Roll"] then
    local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, 59, 1, target)
    if targetList ~= nil and targetList.Count >= 2 then
      local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
      local atkSpeedRatio = 1
      local atkActionId = data.action_pass1
      local atkTriggerFrame = 0
      atkSpeedRatio = self:CalcAtkActionSpeedForAirplane(atkSpeed, 2) * (self.config).baseActionSpd
      atkActionId = data.action_pass1
      atkTriggerFrame = self:GetAtkTriggerFrameForAirplane(2, atkSpeed)
      local attackTrigger2 = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
      self:CallCasterWait(atkSpeed + 2)
      -- DECOMPILER ERROR at PC58: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.caster).recordTable).lastAttackRole = target
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action_pass1, atkSpeedRatio, atkTriggerFrame, attackTrigger2)
    else
      do
        local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
        local atkSpeedRatio = 1
        local atkActionId = data.action_pass2
        local atkTriggerFrame = 0
        atkSpeedRatio = self:CalcAtkActionSpeedForAirplane2(atkSpeed, 2) * (self.config).baseActionSpd
        atkActionId = data.action_pass2
        atkTriggerFrame = self:GetAtkTriggerFrameForAirplane2(2, atkSpeed)
        do
          local attackTrigger3 = BindCallback(self, self.OnAttackTrigger3, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
          self:CallCasterWait(atkSpeed + 2)
          -- DECOMPILER ERROR at PC106: Confused about usage of register: R9 in 'UnsetPending'

          ;
          ((self.caster).recordTable).lastAttackRole = target
          LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action_pass2, atkSpeedRatio, atkTriggerFrame, attackTrigger3)
          ;
          (base.RealPlaySkill)(self, target, data)
        end
      end
    end
  end
end

bs_105800.CalcAtkActionSpeedForAirplane = function(self, atkInterval, atkId)
  -- function num : 0_3
  local atkTotalFrames = (self.config).skill_time
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_105800.GetAtkTriggerFrameForAirplane = function(self, atkId, atkInterval)
  -- function num : 0_4
  local atkTotalFrames = (self.config).skill_time
  local triggerFrameCfg = (self.config).start_time
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_105800.CalcAtkActionSpeedForAirplane2 = function(self, atkInterval, atkId)
  -- function num : 0_5
  local atkTotalFrames = (self.config).skill_time2
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_105800.GetAtkTriggerFrameForAirplane2 = function(self, atkId, atkInterval)
  -- function num : 0_6
  local atkTotalFrames = (self.config).skill_time2
  local triggerFrameCfg = (self.config).start_time2
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_105800.OnAttackTrigger2 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passqk2, self)
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_passAoe, self, nil, false, self.SkillEventFunc2, data)
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

bs_105800.SkillEventFunc2 = function(self, data, effect, eventId, target)
  -- function num : 0_8 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig1, {((self.caster).recordTable)["105801_arg2"]})
    skillResult:EndResult()
  end
end

bs_105800.OnAttackTrigger3 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passqk, self)
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_passtrail2, self, nil, false, self.SkillEventFunc3, data)
    LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_9_0 , upvalues : _ENV, self, target, data
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passqk, self)
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_passtrail, self, nil, false, self.SkillEventFunc3, data)
  end
)
    LuaSkillCtrl:StartTimer(self, 5, function()
    -- function num : 0_9_1 , upvalues : _ENV, self, target, data
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_passqk, self)
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_passtrail3, self, nil, false, self.SkillEventFunc3, data)
  end
)
  else
    self:BreakSkill()
  end
  if self.isDoubleAttack then
    local attackTrigger = BindCallback(self, self.OnAttackTrigger3, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
  else
    do
      self:CancleCasterWait()
    end
  end
end

bs_105800.SkillEventFunc3 = function(self, data, effect, eventId, target)
  -- function num : 0_10 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and (effect.dataId == (self.config).effectId_passtrail or effect.dataId == (self.config).effectId_passtrail2 or effect.dataId == (self.config).effectId_passtrail3) then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig2, {((self.caster).recordTable)["105801_arg3"]}, false, false)
    skillResult:EndResult()
  end
end

bs_105800.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105800

