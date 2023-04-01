-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105302 = class("bs_105302", LuaSkillBase)
local base = LuaSkillBase
bs_105302.config = {buffId_speed = 105301, actionId = 1002, skill_speed = 1.5, start_time = 10, skill_time = 30, effectId_trail = 105312, HurtConfigID = 13}
bs_105302.ctor = function(self)
  -- function num : 0_0
end

bs_105302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105302.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = self:SetSkillTarget()
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data)
  if target ~= nil then
    (self.caster):LookAtTarget(target)
  end
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
end

bs_105302.SetSkillTarget = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    return target
  end
end

bs_105302.OnAttackTrigger = function(self, target, data)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1, (self.arglist)[4] * ((self.caster).recordTable).energy_num)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self, self.SkillEventFunc)
end

bs_105302.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[1] + ((self.caster).recordTable).energy_num * (self.arglist)[2]})
    skillResult:EndResult()
    self:OnSkillDamageEnd()
  end
end

bs_105302.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105302

