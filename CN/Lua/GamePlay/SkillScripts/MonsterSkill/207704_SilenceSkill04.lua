-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_207704 = class("bs_207704", bs_1)
local base = bs_1
bs_207704.config = {action1 = 0, action2 = 0}
bs_207704.config = setmetatable(bs_207704.config, {__index = base.config})
bs_207704.ctor = function(self)
  -- function num : 0_0
end

bs_207704.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_207704.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).attackRange == 1 then
    if data.audioId3 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3)
    end
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
      local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          local target = targetList[i]
          if data.Imp == true then
            LuaSkillCtrl:PlayAuHit(self, target)
          end
        end
      end
      do
        do
          -- DECOMPILER ERROR at PC52: Confused about usage of register: R7 in 'UnsetPending'

          if ((self.caster).recordTable).completeFirstComatk == nil then
            ((self.caster).recordTable).completeFirstComatk = true
          end
          self:BreakSkill()
          if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
            if data.effectId_action_1 ~= nil then
              if atkActionId == data.action1 then
                LuaSkillCtrl:CallEffect(self.caster, data.effectId_action_1, self)
              else
                LuaSkillCtrl:CallEffect(self.caster, data.effectId_action_2, self)
              end
            end
            if data.effectId_start3 ~= nil then
              if atkActionId == data.action1 then
                LuaSkillCtrl:CallEffect(target, data.effectId_start3, self, nil, nil, atkSpeedRatio)
              else
                LuaSkillCtrl:CallEffect(target, data.effectId_start4, self, nil, nil, atkSpeedRatio)
              end
            end
            local extraTarget = self:CheckAndGetExtraEffectTarget(target)
            self:ExecuteEffectAttack(data, atkActionId, target)
            if extraTarget ~= nil then
              self:ExecuteEffectAttack(data, atkActionId, extraTarget, data.effectId_split_shoot, data.effectId_split_shoot_ex)
            end
            -- DECOMPILER ERROR at PC132: Confused about usage of register: R7 in 'UnsetPending'

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
end

bs_207704.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207704

