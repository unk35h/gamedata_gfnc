-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_207400 = class("bs_207400", bs_1)
local base = bs_1
bs_207400.config = {effectId_start1 = 207400, effectId_start2 = 207400, HurtConfigID = 1, action1 = 1001, action2 = 1001}
bs_207400.config = setmetatable(bs_207400.config, {__index = base.config})
bs_207400.ctor = function(self)
  -- function num : 0_0
end

bs_207400.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_1 , upvalues : _ENV
  if (self.caster).attackRange == 1 then
    if data.audioId3 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3)
    end
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          local target = targetList[i]
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {((self.caster).recordTable).AttackDamage})
          skillResult:EndResult()
          if data.Imp == true then
            LuaSkillCtrl:PlayAuHit(self, target)
          end
        end
      end
      do
        do
          -- DECOMPILER ERROR at PC72: Confused about usage of register: R7 in 'UnsetPending'

          if ((self.caster).recordTable).completeFirstComatk == nil then
            ((self.caster).recordTable).completeFirstComatk = true
          end
          self:BreakSkill()
          if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
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
            -- DECOMPILER ERROR at PC153: Confused about usage of register: R7 in 'UnsetPending'

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

bs_207400.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_2 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_207400.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207400

