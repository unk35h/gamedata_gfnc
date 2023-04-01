-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105402 = class("bs_105402", LuaSkillBase)
local base = LuaSkillBase
bs_105402.config = {skill_time = 48, start_time = 11, actionId = 1002, action_speed = 1, effectId_fly = 105404, effectId_hit = 105405, effectId_heal = 105418, audioId1 = 221, audioId2 = 222, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, crithur_ratio = 0}
, 
HealConfig2 = {baseheal_formula = 10188}
, buffId_stun = 105404}
bs_105402.ctor = function(self)
  -- function num : 0_0
end

bs_105402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105402.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = ((self.caster).recordTable).lastAttackRole
  do
    if target == nil or target.hp <= 0 or target.belongNum == eBattleRoleBelong.neutral then
      local tempTarget = self:GetMoveSelectTarget()
      if tempTarget == nil then
        return 
      end
      target = tempTarget.targetRole
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_fly, self)
    if target ~= nil and target.hp > 0 then
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
      ;
      (self.caster):LookAtTarget(target)
      self:CallCasterWait((self.config).skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
    end
  end
end

bs_105402.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
  skillResult:EndResult()
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_stun, 1, (self.arglist)[4])
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_heal, self)
  local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
  LuaSkillCtrl:HealResult(skillResult1, (self.config).HealConfig2)
  skillResult1:EndResult()
  self:OnSkillDamageEnd()
end

bs_105402.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105402

