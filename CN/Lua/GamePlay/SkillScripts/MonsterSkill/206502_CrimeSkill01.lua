-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206502 = class("bs_206502", LuaSkillBase)
local base = LuaSkillBase
bs_206502.config = {buffId_judge = 206801, buffId_fly = 502101, effectId_start = 2065012, effectId_hit = 2065011, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_206502.ctor = function(self)
  -- function num : 0_0
end

bs_206502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206502.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.isInSkill = true
  local SkillDuration = 37
  local SkillStart = 8
  self:CallCasterWait(SkillDuration)
  LuaSkillCtrl:StartShowSkillDurationTime(self, SkillDuration)
  self:AbandonSkillCdAutoReset(true)
  LuaSkillCtrl:StartTimer(self, SkillDuration, function()
    -- function num : 0_2_0 , upvalues : self
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
)
  local last_target = ((self.caster).recordTable).lastAttackRole
  local targetRole = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    targetRole = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    targetRole = tempTarget.targetRole
  end
  do
    if targetRole ~= nil then
      (self.caster):LookAtTarget(targetRole)
      LuaSkillCtrl:StartTimer(self, SkillStart, function()
    -- function num : 0_2_1 , upvalues : self
    self:OnAttackTrigger()
  end
)
      LuaSkillCtrl:CallRoleAction(self.caster, 1002, 1)
      LuaSkillCtrl:PlayAuSource(self.caster, 442)
    end
  end
end

bs_206502.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
  for i = 0, (skillResult.roleList).Count - 1 do
    if LuaSkillCtrl:IsObstacle((skillResult.roleList)[i]) then
      return 
    end
    if not LuaSkillCtrl:GetRoleBuffById((skillResult.roleList)[i], (self.config).buffId_fly) then
      LuaSkillCtrl:CallEffect((skillResult.roleList)[i], (self.config).effectId_hit, self)
      LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buffId_judge, 1, (self.arglist)[2])
    end
  end
  skillResult:EndResult()
end

bs_206502.OnBreakSkill = function(self, role)
  -- function num : 0_4 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.isInSkill then
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
end

return bs_206502

