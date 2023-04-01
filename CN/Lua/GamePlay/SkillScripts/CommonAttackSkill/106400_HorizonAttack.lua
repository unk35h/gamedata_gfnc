-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106400 = class("bs_106400", bs_1)
local base = bs_1
bs_106400.config = {effectId_start1 = 106401, effectId_start2 = 106402, effectId3 = 106409, action1 = 1001, action2 = 1004, action_pass = 1021, baseActionSpd = 1, skill_time = 40, start_time = 7, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, HurtConfig = 1, buffId_Back = 151, buffId_Stun = 3006}
bs_106400.config = setmetatable(bs_106400.config, {__index = base.config})
bs_106400.ctor = function(self)
  -- function num : 0_0
end

bs_106400.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.time = 0
end

bs_106400.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  self.time = self.time + 1
  if ((self.caster).recordTable)["106401_Roll"] <= self.time then
    self.time = 0
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
    LuaSkillCtrl:CallEffect(target, (self.config).effectId3, self)
  else
    do
      ;
      (base.RealPlaySkill)(self, target, data)
    end
  end
end

bs_106400.CalcAtkActionSpeedForAirplane = function(self, atkInterval, atkId)
  -- function num : 0_3
  local atkTotalFrames = (self.config).skill_time
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106400.GetAtkTriggerFrameForAirplane = function(self, atkId, atkInterval)
  -- function num : 0_4
  local atkTotalFrames = (self.config).skill_time
  local triggerFrameCfg = (self.config).start_time
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106400.OnAttackTrigger2 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    if ((self.caster).recordTable).completeFirstComatk == nil then
      ((self.caster).recordTable).completeFirstComatk = true
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    local num = 1000
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {num}, false, false)
    skillResult:EndResult()
    local targetX = target.x
    local targetY = target.y
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
    for i = 0, (skillResult.roleList).Count - 1 do
      if (skillResult.roleList)[i] ~= target then
        LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buffId_Back, 1, 3)
        LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnHorizonCauseBacklash, (skillResult.roleList)[i])
      end
    end
    skillResult:EndResult()
    local buff = nil
    if target.belongNum ~= eBattleRoleBelong.neutral then
      buff = LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_Back, 1, 3)
      if buff ~= nil and target.x == targetX and target.y == targetY then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_Stun, 1, ((self.caster).recordTable)["106401_TIME"])
      else
        LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnHorizonCauseBacklash, target)
      end
    end
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

bs_106400.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106400

