-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101907 = class("bs_101907", LuaSkillBase)
local base = LuaSkillBase
bs_101907.config = {effectId_start = 101907, effectId_trail = 101908, skill_speed = 1, actionId = 1002, skill_time = 26, start_time = 13, hurt_configId = 3}
bs_101907.ctor = function(self)
  -- function num : 0_0
end

bs_101907.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101907.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local moveTarget = self:GetMoveSelectTarget()
  if moveTarget == nil then
    return 
  end
  local target = moveTarget.targetRole
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data)
  ;
  (self.caster):LookAtTarget(target)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_start, self)
end

bs_101907.OnAttackTrigger = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self, self.SkillEventFunc)
end

bs_101907.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurt_configId, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.FernDragonHurt, target, true)
  end
end

bs_101907.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101907

