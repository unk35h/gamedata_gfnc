-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1018022 = class("bs_1018022", LuaSkillBase)
local base = LuaSkillBase
bs_1018022.config = {buffId_nurse = 10180301, effectId_skill = 101807, skill_time = 34, start_time = 12, actionId = 1002, action_speed = 1, skill_select = 14, 
heal_config = {baseheal_formula = 3021}
}
bs_1018022.ctor = function(self)
  -- function num : 0_0
end

bs_1018022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1018022.PlaySkill = function(self, data)
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

bs_1018022.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.hp > 0 then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill, self, self.SkillEventFunc)
  end
  if target.hp <= 0 then
    local target_new = LuaSkillCtrl:CallTargetSelect(self, (self.config).skill_select, 0)
    if target_new.Count > 0 then
      LuaSkillCtrl:CallEffect((target_new[0]).targetRole, (self.config).effectId_skill, self, self.SkillEventFunc)
    end
  end
end

bs_1018022.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger then
    local num = ((target.targetRole).maxHp - (target.targetRole).hp) * 1000 // (target.targetRole).maxHp // (self.arglist)[2] * (self.arglist)[3]
    local num2 = (self.arglist)[1] * (1000 + num) // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {num2})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_nurse, (self.arglist)[5], nil)
  end
end

bs_1018022.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1018022

