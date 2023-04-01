-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105602 = class("bs_105602", LuaSkillBase)
local base = LuaSkillBase
bs_105602.config = {effectId_skill = 105601, actionId = 1002, audioId1 = 101003, skill_time = 32, start_time = 9, selectRange = 10, selectId2 = 34, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, crithur_ratio = 0}
}
bs_105602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105602.PlaySkill = function(self, data)
  -- function num : 0_1 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, (self.cskill).SkillRange) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    if target == nil or target.hp <= 0 then
      return 
    end
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
    ;
    (self.caster):LookAtTarget(target)
    self:CallCasterWait((self.config).skill_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, 1, (self.config).start_time, attackTrigger)
  end
end

bs_105602.OnAttackTrigger = function(self, target, date)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill, self, self.OnEffectTrigger)
end

bs_105602.OnEffectTrigger = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, target
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 34, 10, target.targetRole)
    local skill_end = true
    if targetList.Count >= 1 then
      for i = 0, targetList.Count - 1 do
        if (targetList[i]).targetRole ~= nil and (targetList[i]).targetRole ~= target.targetRole then
          skill_end = false
          LuaSkillCtrl:CallEffectWithArgOverride((targetList[i]).targetRole, (self.config).effectId_skill, self, target.targetRole, false, false, self.OnEffectTrigger2)
          break
        end
      end
    end
    do
      if skill_end == true then
        self:OnSkillDamageEnd()
      end
    end
  end
)
  end
end

bs_105602.OnEffectTrigger2 = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_skill and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[2]})
    skillResult:EndResult()
    self:OnSkillDamageEnd()
  end
end

bs_105602.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105602

