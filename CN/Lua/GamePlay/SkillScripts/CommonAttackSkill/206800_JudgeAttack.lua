-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_206800 = class("bs_206800", bs_1)
local base = bs_1
bs_206800.config = {action1 = 1001, action2 = 1001, effectId_1 = 2068001, effectId_2 = 2068001, audioId1 = 448, 
HurtConfig_crime = {hit_formula = 9991, def_formula = 9996, basehurt_formula = 9993, minhurt_formula = 9994, crit_formula = 9992, crithur_ratio = 9995, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = -1}
, 
HurtConfig_punish = {hit_formula = 9991, def_formula = 9996, basehurt_formula = 9993, minhurt_formula = 9994, crit_formula = 9992, crithur_ratio = 9995, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = 1}
}
bs_206800.config = setmetatable(bs_206800.config, {__index = base.config})
bs_206800.ctor = function(self)
  -- function num : 0_0
end

bs_206800.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206800.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV
  local HurtConfig = nil
  if ((self.caster).recordTable).mask == 1 then
    HurtConfig = (self.config).HurtConfig_crime
  end
  if ((self.caster).recordTable).mask == 2 then
    HurtConfig = (self.config).HurtConfig_punish
  end
  if (self.caster).attackRange == 1 then
    if data.audioId3 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3)
    end
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      if data.Imp == true then
        LuaSkillCtrl:PlayAuHit(self, target)
      end
      LuaSkillCtrl:HurtResult(self, skillResult, HurtConfig)
      skillResult:EndResult()
      -- DECOMPILER ERROR at PC65: Confused about usage of register: R8 in 'UnsetPending'

      if ((self.caster).recordTable).completeFirstComatk == nil then
        ((self.caster).recordTable).completeFirstComatk = true
      end
    else
      do
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
            self:ExecuteEffectAttack(data, atkActionId, extraTarget)
          end
          -- DECOMPILER ERROR at PC144: Confused about usage of register: R8 in 'UnsetPending'

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

bs_206800.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206800

