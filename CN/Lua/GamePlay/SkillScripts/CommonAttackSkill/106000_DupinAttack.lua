-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106000 = class("bs_106000", bs_1)
local base = bs_1
bs_106000.config = {effectId_1 = 106002, effectId_2 = 106001, effectId_4 = 106004, effectId_5 = 106005, action3 = 1025, action4 = 1043, hurtConfigId = 10, hurtConfigId_2 = 5, buffId_skill = 106002, buffId_zhimang = 3012, audioId1 = 106001, audioId2 = 106002, audioId1_ex = 106005, audioId2_ex = 106006, audioId_ex_hit = 106007}
bs_106000.config = setmetatable(bs_106000.config, {__index = base.config})
bs_106000.ctor = function(self)
  -- function num : 0_0
end

bs_106000.RealPlaySkill = function(self, target, data)
  -- function num : 0_1 , upvalues : base, _ENV
  if (self.caster):GetBuffTier((self.config).buffId_skill) == 0 then
    (base.RealPlaySkill)(self, target, data)
    return 
  end
  self:CallSelectEffect()
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = 1
  local atkActionId = data.action3
  local atkTriggerFrame = 0
  if self.attackNum >= 0 then
    local prob = LuaSkillCtrl:CallRange(1, 2)
    if self.attackNum == 1 then
      if data.audioId4 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time2, function()
    -- function num : 0_1_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId2_ex)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed2(atkSpeed, 4) * (self.config).baseActionSpd
      atkActionId = data.action4
      atkTriggerFrame = self:GetAtkTriggerFrame2(4, atkSpeed)
      self.attackNum = 0
    else
      if data.audioId3 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_1_1 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1_ex)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed2(atkSpeed, 3)
      atkActionId = data.action3
      atkTriggerFrame = self:GetAtkTriggerFrame2(3, atkSpeed) * (self.config).baseActionSpd
      self.attackNum = self.attackNum + 1
    end
  else
    do
      if data.audioId3 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_1_2 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1_ex)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed2(atkSpeed, 3) * (self.config).baseActionSpd
      atkTriggerFrame = self:GetAtkTriggerFrame2(3, atkSpeed)
      atkActionId = data.action3
      self.attackNum = self.attackNum + 1
      -- DECOMPILER ERROR at PC112: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.caster).recordTable).lastAttackRole = target
      -- DECOMPILER ERROR at PC123: Confused about usage of register: R7 in 'UnsetPending'

      if LuaSkillCtrl.IsInTDBattle and (self.caster).belongNum == 2 then
        ((self.caster).recordTable).lastAttackRole = nil
      end
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
      local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
      if waitTime > 0 then
        self:CallCasterWait(waitTime + 2)
      end
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger)
      -- DECOMPILER ERROR at PC177: Confused about usage of register: R9 in 'UnsetPending'

      if (self.caster).attackRange == 1 and data.effectId_4 ~= nil then
        if atkActionId == data.action3 then
          ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_4, self, nil, nil, atkSpeedRatio, true)
        else
          -- DECOMPILER ERROR at PC190: Confused about usage of register: R9 in 'UnsetPending'

          ;
          ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_5, self, nil, nil, atkSpeedRatio, true)
        end
      end
    end
  end
end

bs_106000.CalcAtkActionSpeed2 = function(self, atkInterval, atkId)
  -- function num : 0_2
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106000.GetTotalAtkActionFrames2 = function(self, atkId)
  -- function num : 0_3
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  if atkId == 3 then
    return 38
  else
    if atkId == 4 then
      return 46
    else
      return 0
    end
  end
end

bs_106000.GetAtkTriggerFrame2 = function(self, atkId, atkInterval)
  -- function num : 0_4
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  local triggerFrameCfg = 0
  if atkId == 3 then
    triggerFrameCfg = 8
  else
    if atkId == 4 then
      triggerFrameCfg = 6
    end
  end
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106000.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_5 , upvalues : _ENV
  if atkActionId == data.action1 or atkActionId == data.action2 then
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local hurt = 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {hurt})
      skillResult:EndResult()
      LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.DupinAttack, target)
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R8 in 'UnsetPending'

      if ((self.caster).recordTable).completeFirstComatk == nil then
        ((self.caster).recordTable).completeFirstComatk = true
      end
    else
      do
        self:BreakSkill()
        if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
          local hurt = ((self.caster).recordTable).passive_arg4
          local rool = ((self.caster).recordTable).passive_arg5
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId_2, {hurt})
          skillResult:EndResult()
          LuaSkillCtrl:PlayAuSource(self.caster, data.audioId_ex_hit)
          LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.DupinAttack, target)
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_zhimang, 1, ((self.caster).recordTable).passive_arg6)
          -- DECOMPILER ERROR at PC114: Confused about usage of register: R9 in 'UnsetPending'

          if ((self.caster).recordTable).completeFirstComatk == nil then
            ((self.caster).recordTable).completeFirstComatk = true
          end
        else
          do
            self:BreakSkill()
            if self.isDoubleAttack then
              local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
              self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
            else
              do
                self:CancleCasterWait()
              end
            end
          end
        end
      end
    end
  end
end

bs_106000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_6 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106000.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106000

