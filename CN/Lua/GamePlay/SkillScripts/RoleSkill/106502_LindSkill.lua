-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106502 = class("bs_106502", LuaSkillBase)
local base = LuaSkillBase
bs_106502.config = {start_time = 15, start_time2 = 4, start_time3 = 5, start_time4 = 6, skill_time = 58, actionId = 1105, action_speed = 1, effectId_1 = 106503, effectId_2 = 106504, effectId_3 = 106505, effectId_4 = 106506, effectId_5 = 106508, effectId_6 = 106509, effectId_self_1 = 106508, effectId_self_2 = 106509, HurtConfigId = 2, buffId_stun = 106507, buffId_196 = 196, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_106502.ctor = function(self)
  -- function num : 0_0
end

bs_106502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106502.PlaySkill = function(self, data)
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
      local effectTarget = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, effectTarget, (self.caster).x, (self.caster).y)
      ;
      (self.caster):LookAtTarget(target)
      self:CallCasterWait((self.config).skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.config).skill_time)
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_5, self)
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_6, self)
    end
  end
end

bs_106502.OnAttackTrigger = function(self, target, x, y)
  -- function num : 0_3 , upvalues : _ENV
  local skillEnd = self:OnMoveEs(x, y)
  if skillEnd == false then
    return 
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_1, self)
  self:OnHurt(target, 1)
  LuaSkillCtrl:StartTimer(self, (self.config).start_time2, function()
    -- function num : 0_3_0 , upvalues : self, x, y, _ENV, target
    local skillEnd = self:OnMoveEs(x, y)
    if skillEnd == false then
      return 
    end
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_2, self)
    self:OnHurt(target, 2)
    LuaSkillCtrl:StartTimer(self, (self.config).start_time3, function()
      -- function num : 0_3_0_0 , upvalues : self, x, y, _ENV, target
      local skillEnd = self:OnMoveEs(x, y)
      if skillEnd == false then
        return 
      end
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_3, self)
      self:OnHurt(target, 3)
      LuaSkillCtrl:StartTimer(self, (self.config).start_time4, function()
        -- function num : 0_3_0_0_0 , upvalues : self, x, y, _ENV, target
        local skillEnd = self:OnMoveEs(x, y)
        if skillEnd == false then
          return 
        end
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_4, self)
        self:OnHurt(target, 4)
      end
)
    end
)
  end
)
end

bs_106502.OnMoveEs = function(self, x, y)
  -- function num : 0_4 , upvalues : _ENV
  if (self.caster).x ~= x or (self.caster).y ~= y then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    return false
  else
    return true
  end
end

bs_106502.OnHurt = function(self, target, time)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
  local num = (skillResult.roleList).Count
  for i = 0, (skillResult.roleList).Count - 1 do
    local role = (skillResult.roleList)[i]
    if LuaSkillCtrl:IsFixedObstacle(role) then
      num = num - 1
    end
  end
  for i = 0, (skillResult.roleList).Count - 1 do
    local role = (skillResult.roleList)[i]
    if LuaSkillCtrl:IsFixedObstacle(role) ~= true then
      if time ~= 4 and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_stun, 1, (self.arglist)[3])
      end
      if time == 4 then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_stun, 1, (self.arglist)[4])
      end
      local hurt = (self.arglist)[1] // (num)
      local onCtrl = LuaSkillCtrl:RoleContainsCtrlBuff(role)
      if onCtrl == true then
        hurt = hurt * (1000 + (self.arglist)[5]) // 1000
        LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnLindHurt, 2, role)
      end
      local skillResult2 = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult2, (self.config).HurtConfigId, {hurt})
      skillResult2:EndResult()
    end
  end
  skillResult:EndResult()
  if time == 4 then
    self:OnSkillDamageEnd()
  end
end

bs_106502.OnBreakSkill = function(self, role)
  -- function num : 0_6 , upvalues : _ENV, base
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 0)
  self:CancleCasterWait()
  ;
  (base.OnBreakSkill)(self, role)
end

bs_106502.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106502

