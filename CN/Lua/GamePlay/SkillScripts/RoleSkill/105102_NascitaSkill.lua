-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105102 = class("bs_105102", LuaSkillBase)
local base = LuaSkillBase
bs_105102.config = {effectId_nomal = 105106, effectId_breaksheild = 105108, effectId_hit_normal = 105107, effectId_hit_breaksheild = 105109, actionId_normal = 1002, skill_time_normal = 20, start_time_normal = 7, actionId_breaksheild = 1020, skill_time_breaksheild = 22, start_time_breaksheild = 8, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
, buffId_ult = 1051031}
bs_105102.ctor = function(self)
  -- function num : 0_0
end

bs_105102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105102.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target = self:SetSkillTarget()
  if target ~= nil then
    (self.caster):LookAtTarget(target)
    local TargetSheild = self:TargetSheild(target)
    local action = (self.config).actionId_normal
    local skill_time = (self.config).skill_time_normal
    local start_time = (self.config).start_time_normal
    local effect_start = (self.config).effectId_nomal
    local effect_hit = (self.config).effectId_hit_normal
    local skillRatio = (self.arglist)[1]
    if TargetSheild > 0 then
      action = (self.config).actionId_breaksheild
      skill_time = (self.config).skill_time_breaksheild
      start_time = (self.config).start_time_breaksheild
      effect_start = (self.config).effectId_breaksheild
      effect_hit = (self.config).effectId_hit_breaksheild
      skillRatio = (self.arglist)[1] * (1000 + (self.arglist)[2]) // 1000
    end
    self:CallCasterWait(skill_time)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, effect_hit, skillRatio)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, action, (self.config).action_speed, start_time, attackTrigger)
    LuaSkillCtrl:CallEffect(target, effect_start, self, nil, nil, nil, true)
  end
end

bs_105102.SetSkillTarget = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
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

bs_105102.OnAttackTrigger = function(self, target, effect_hit, skillRatio)
  -- function num : 0_4 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {skillRatio})
  skillResult:EndResult()
  self:OnSkillDamageEnd()
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  if ((self.caster).recordTable).ult_skill == true then
    ((self.caster).recordTable).ult_skill = false
    LuaSkillCtrl:CallResetCDForSingleSkill(self.cskill, ((self.caster).recordTable).ultSkill * (self.cskill).totalCDTime // 1000)
  end
  LuaSkillCtrl:CallEffect(target, effect_hit, self)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, target, self.caster, self.cskill)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, target, self.caster, self.cskill)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, target, self.caster, self.cskill)
end

bs_105102.TargetSheild = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  local totalShieldNum = 4
  local sheildValueSum = 0
  for i = 0, totalShieldNum - 1 do
    sheildValueSum = sheildValueSum + LuaSkillCtrl:GetShield(target, i)
  end
  return sheildValueSum
end

bs_105102.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105102

