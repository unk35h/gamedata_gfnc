-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1042022 = class("bs_1042022", LuaSkillBase)
local base = LuaSkillBase
bs_1042022.config = {buffId_tig = 10420401, actionId = 1020, actionId_speed = 1, skill_time = 40, start_time = 4, start_time2 = 6, start_time3 = 10, effectId_start = 104206, effectId_hit1 = 104207, effectId_hit2 = 104208, effectId_hit3 = 104209, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0}
, audioId_hit = 104208}
bs_1042022.ctor = function(self)
  -- function num : 0_0
end

bs_1042022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1042022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
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
    if target ~= nil then
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
      ;
      (self.caster):LookAtTarget(target)
      self:CallCasterWait((self.config).skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_start, self, nil, nil, nil, true)
    end
  end
end

bs_1042022.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  if target.intensity ~= 0 then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tig, 1, (self.arglist)[2])
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit1, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
  skillResult:EndResult()
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
  LuaSkillCtrl:StartTimer(self, (self.config).start_time2, function()
    -- function num : 0_3_0 , upvalues : target, _ENV, self
    if target == nil or target.hp <= 0 then
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).Aoe)
    for i = 0, (skillResult.roleList).Count - 1 do
      local role = (skillResult.roleList)[i]
      LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit2, self)
      if role ~= target then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]}, true)
        skillResult:EndResult()
      else
        do
          do
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
            LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
            skillResult:EndResult()
            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    skillResult:EndResult()
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
    if target.intensity ~= 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tig, 1, (self.arglist)[2])
    end
    LuaSkillCtrl:StartTimer(self, (self.config).start_time3, function()
      -- function num : 0_3_0_0 , upvalues : target, _ENV, self
      if target == nil or target.hp <= 0 then
        return 
      end
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit3, self)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[4]})
      skillResult:EndResult()
      if target.intensity ~= 0 then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tig, 1, (self.arglist)[2])
      end
      LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
    end
)
  end
)
end

bs_1042022.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetList.Count <= 0 then
    return 
  end
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:DispelBuffByMaker(self.caster, (targetList[i]).targetRole, (self.config).buffId_tig, 1)
  end
end

return bs_1042022

