-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100202 = class("bs_100202", LuaSkillBase)
local base = LuaSkillBase
bs_100202.config = {effectId_trail = 100208, effectId_line = 100207, selectId_skill = 9, select_range = 10, weaponLv = 0, skill_speed = 1, actionId = 1002, skill_time = 30, start_time = 16, buffId_cockhourse2 = 100203, 
hurt_config = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
, 
hurt_config_extra = {hit_formula = 0, def_formula = 0, basehurt_formula = 100201, crit_formula = 0, returndamage_formula = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
}
bs_100202.ctor = function(self)
  -- function num : 0_0
end

bs_100202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.cando = false
end

bs_100202.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local moveTarget = self:GetMoveSelectTarget()
  if moveTarget == nil then
    return 
  end
  local target = moveTarget.targetRole
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data)
  ;
  (self.caster):LookAtTarget(target)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
end

bs_100202.OnAttackTrigger = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
  if (self.config).weaponLv >= 2 then
    self.targetlist = {}
    self.cando = true
    if self.timer ~= nil then
      (self.timer):Stop()
      self.timer = nil
    end
    self.timer = LuaSkillCtrl:StartTimer(self, (self.arglist)[4], function()
    -- function num : 0_3_0 , upvalues : self
    self.cando = false
    self.targetlist = {}
  end
)
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_line, self)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self, self.SkillEventFunc)
end

bs_100202.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:PlayAuHit(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]}, false, false)
    skillResult:EndResult()
    local transferList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, (self.config).select_range)
    if transferList == 0 then
      self:OnSkillDamageEnd()
      return 
    end
    self.num = 0
    for i = 0, transferList.Count - 1 do
      local role = (transferList[i]).targetRole
      if role ~= target.targetRole and role.intensity ~= 0 then
        LuaSkillCtrl:CallEffect(role, (self.config).effectId_line, self, nil, target.targetRole)
        LuaSkillCtrl:CallEffect(role, (self.config).effectId_trail, self, self.SkillEventFunc_extra, target.targetRole)
        self.num = self.num + 1
      end
    end
  end
end

bs_100202.SkillEventFunc_extra = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config_extra, nil, true)
    skillResult:EndResult()
    self.num = self.num - 1
    if self.num == 0 then
      self:OnSkillDamageEnd()
    end
  end
end

bs_100202.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_100202.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  self.targetlist = nil
end

return bs_100202

