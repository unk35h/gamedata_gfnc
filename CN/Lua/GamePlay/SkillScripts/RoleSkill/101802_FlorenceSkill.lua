-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101802 = class("bs_101802", LuaSkillBase)
local base = LuaSkillBase
bs_101802.config = {buffId_nurse = 101803, effectId_skill = 101807, effectId_skill2 = 101814, skill_time = 34, start_time = 12, actionId = 1002, action_speed = 1, skill_select = 14, 
heal_config = {baseheal_formula = 3021}
, weaponLv = 0}
bs_101802.ctor = function(self)
  -- function num : 0_0
end

bs_101802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101802.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = self:GetMoveSelectTarget()
  if target ~= nil then
    target = target.targetRole
  end
  if target ~= nil then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    ;
    (self.caster):LookAtTarget(target)
    self:CallCasterWait((self.config).skill_time)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  end
end

bs_101802.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.hp > 0 then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill, self, self.SkillEventFunc)
  end
  if target.hp <= 0 then
    local target_new = LuaSkillCtrl:CallTargetSelect(self, 28, 0)
    if target_new.Count > 0 then
      for i = 0, target_new.Count - 1 do
        if target_new[i] ~= nil and (((target_new[i]).targetRole).recordTable).WillowPic ~= true then
          LuaSkillCtrl:CallEffect((target_new[i]).targetRole, (self.config).effectId_skill, self, self.SkillEventFunc)
          break
        end
      end
    end
  end
end

bs_101802.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger then
    local num = ((target.targetRole).maxHp - (target.targetRole).hp) * 1000 // (target.targetRole).maxHp // (self.arglist)[2] * (self.arglist)[3]
    local num2 = (self.arglist)[1] * (1000 + num) // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {num2})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_nurse, (self.arglist)[5], nil)
    if (self.config).weaponLv >= 2 then
      local target_new2 = LuaSkillCtrl:CallTargetSelect(self, 28, 10)
      for i = 0, target_new2.Count - 1 do
        if target_new2[i] ~= nil and (((target_new2[i]).targetRole).recordTable).WillowPic ~= true then
          LuaSkillCtrl:CallEffectWithArgOverride((target_new2[i]).targetRole, (self.config).effectId_skill2, self, target.targetRole, false, false, self.OnEffectTrigger2)
          break
        end
      end
    end
  end
end

bs_101802.OnEffectTrigger2 = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill2 and eventId == eBattleEffectEvent.Trigger then
    local num = ((target.targetRole).maxHp - (target.targetRole).hp) * 1000 // (target.targetRole).maxHp // (self.arglist)[2] * (self.arglist)[3]
    local num2 = (self.arglist)[1] * ((self.arglist)[6] / 1000) * (1000 + num) // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {num2})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_nurse, (self.arglist)[7], nil)
  end
end

bs_101802.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101802

