-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206603 = class("bs_206603", LuaSkillBase)
local base = LuaSkillBase
bs_206603.config = {buffId_judge = 206801, buffId_Jianfang = 206603, effectId_start = 2066021, effectId_hit = 2066022, effectId_skillhit = 2066002, effectId_xuli = 2066023, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_206603.ctor = function(self)
  -- function num : 0_0
end

bs_206603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206603.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.isInSkill = true
  local SkillDuration = 25
  local SkillStart = 15
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
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_xuli, self)
      LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  end
)
      LuaSkillCtrl:CallRoleAction(self.caster, 1020, 1)
      LuaSkillCtrl:PlayAuSource(self.caster, 447)
      LuaSkillCtrl:StartTimer(self, SkillStart, function()
    -- function num : 0_2_2 , upvalues : _ENV, self
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
    if (skillResult.roleList).Count > 0 then
      LuaSkillCtrl:CallEffect((skillResult.roleList)[0], (self.config).effectId_skillhit, self)
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        if role:GetBuffTier((self.config).buffId_judge) > 0 then
          LuaSkillCtrl:DispelBuff(role, (self.config).buffId_judge, 1)
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_Jianfang, 1, (self.arglist)[2])
        end
      end
    end
    do
      skillResult:EndResult()
    end
  end
)
    end
  end
end

bs_206603.OnBreakSkill = function(self, role)
  -- function num : 0_3 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.isInSkill then
    self.isInSkill = false
    self:CancleCasterWait()
    self:CallNextBossSkill()
  end
end

return bs_206603

