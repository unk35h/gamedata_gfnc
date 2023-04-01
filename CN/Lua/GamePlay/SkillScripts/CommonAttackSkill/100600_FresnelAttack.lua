-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_100600 = class("bs_100600", bs_1)
local base = bs_1
bs_100600.config = {effectId_trail = 100601, effectId_start11 = 100603, effectId_start22 = 100604, effectId_start33 = 100602, audioId6 = 100601, effectId_trail_wuxia = 100615}
bs_100600.config = setmetatable(bs_100600.config, {__index = base.config})
bs_100600.ctor = function(self)
  -- function num : 0_0
end

bs_100600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_100600.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    ((self.caster).recordTable).lastAttackRole = target
    local extraTarget = self:CheckAndGetExtraEffectTarget(target)
    self:CallShoot(target, data, atkActionId)
    if extraTarget ~= nil then
      self:CallShoot(extraTarget, data, atkActionId)
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

bs_100600.CallShoot = function(self, target, data, atkActionId)
  -- function num : 0_3 , upvalues : _ENV
  if atkActionId == data.action1 then
    if data.audioId6 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId6)
    end
    if LuaSkillCtrl:GetCasterSkinId(self.caster) == 300605 then
      LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail_wuxia, self, true, false, self.SkillEventFunc, data)
      return 
    end
    LuaSkillCtrl:CallEffect(target, data.effectId_start11, self)
    LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail, self, true, false, self.SkillEventFunc, data)
  else
    if data.audioId6 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId6)
    end
    if LuaSkillCtrl:GetCasterSkinId(self.caster) == 300605 then
      LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail_wuxia, self, true, false, self.SkillEventFunc, data)
      return 
    end
    LuaSkillCtrl:CallEffect(target, data.effectId_start33, self)
    LuaSkillCtrl:CallEffect(target, data.effectId_start22, self)
    LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail, self, true, false, self.SkillEventFunc, data)
  end
end

bs_100600.SkillEventFunc = function(self, configData, effect, eventId, target)
  -- function num : 0_4 , upvalues : base
  (base.SkillEventFunc)(self, configData, effect, eventId, target)
end

bs_100600.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100600

