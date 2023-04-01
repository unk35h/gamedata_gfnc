-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106600 = class("bs_106600", bs_1)
local base = bs_1
bs_106600.config = {action3 = 1021, effectId_trail_pa = 106606, effectId_trail = 106601, effectId_trail_ex = 106602, effectId_action_1 = 106603, effectId_action_2 = 106604, effectId_action_passive = 106615, audioId1 = 106601, time1 = 0, audioId2 = 106602, time2 = 0, audioId3_ex = 106604}
bs_106600.config = setmetatable(bs_106600.config, {__index = base.config})
bs_106600.ctor = function(self)
  -- function num : 0_0
end

bs_106600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106600.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  local range = ((self.caster).recordTable).arglist1
  if range < LuaSkillCtrl:CallRange(1, 1000) then
    (base.RealPlaySkill)(self, target, data)
    return 
  end
  self:CallSelectEffect()
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = 1
  local atkActionId = data.action3
  local atkTriggerFrame = 0
  if data.audioId1_ex ~= nil then
    LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1_ex)
  end
)
  end
  atkSpeedRatio = self:CalcAtkActionSpeed2(atkSpeed, 3)
  atkActionId = data.action3
  atkTriggerFrame = self:GetAtkTriggerFrame2(3, atkSpeed) * (self.config).baseActionSpd
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.caster).recordTable).lastAttackRole = target
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R8 in 'UnsetPending'

  if LuaSkillCtrl.IsInTDBattle and (self.caster).belongNum == 2 then
    ((self.caster).recordTable).lastAttackRole = nil
  end
  local attackTrigger2 = BindCallback(self, self.OnAttackTrigger2, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
  if waitTime > 0 then
    self:CallCasterWait(waitTime + 2)
  end
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger2)
  LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3_ex)
end

bs_106600.OnAttackTrigger2 = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    local extraTarget = self:CheckAndGetExtraEffectTarget(target)
    self:ExecuteEffectAttack2(data, atkActionId, target)
    if extraTarget ~= nil then
      self:ExecuteEffectAttack2(data, atkActionId, extraTarget, data.effectId_split_shoot, data.effectId_split_shoot_ex)
    end
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R7 in 'UnsetPending'

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

bs_106600.ExecuteEffectAttack2 = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_action_passive, self)
  LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_pa, self, nil, false, self.SkillEventFunc2, data)
end

bs_106600.SkillEventFunc2 = function(self, configData, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnErikaAttackEx, target)
  end
end

bs_106600.CalcAtkActionSpeed2 = function(self, atkInterval, atkId)
  -- function num : 0_6
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106600.GetTotalAtkActionFrames2 = function(self, atkId)
  -- function num : 0_7
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  if atkId == 3 then
    return 38
  else
    return 0
  end
end

bs_106600.GetAtkTriggerFrame2 = function(self, atkId, atkInterval)
  -- function num : 0_8
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  local triggerFrameCfg = 0
  if atkId == 3 then
    triggerFrameCfg = 11
  end
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106600.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106600

