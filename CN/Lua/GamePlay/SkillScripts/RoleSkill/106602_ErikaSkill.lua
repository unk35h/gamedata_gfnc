-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106602 = class("bs_106602", LuaSkillBase)
local base = LuaSkillBase
bs_106602.config = {HurtConfigId = 2, HurtConfigId2 = 2, buffId_Back = 3007, buffId_1 = 106601, buffId_ding = 106603, effectId_boom = 106608, effectId_shan = 106611, effectId_skill = 106616, skill_time = 41, start_time = 7, actionId = 1002, action_speed = 1, 
Aoe = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, radius = 300, arcAngleRange = 30}
bs_106602.ctor = function(self)
  -- function num : 0_0
end

bs_106602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnCallBuff, self.OnCallBuff, self)
end

bs_106602.blackBuffIdDic = {[2065] = true, [2066] = true, [5002001] = true, [151] = true, [259] = true, [3007] = true, [300701] = true, [15101] = true, [25901] = true, [106508] = true, [106602] = true}
bs_106602.PlaySkill = function(self, data)
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
    end
  end
end

bs_106602.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_boom, self)
  LuaSkillCtrl:StartTimer(nil, 5, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, target
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).Aoe)
    local num = (skillResult.roleList).Count
    for i = (skillResult.roleList).Count - 1, 0, -1 do
      local role = (skillResult.roleList)[i]
      if LuaSkillCtrl:IsFixedObstacle(role) ~= true then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_1, 1, (self.arglist)[2])
        local skillResult2 = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult2, (self.config).HurtConfigId, {(self.arglist)[1]})
        skillResult2:EndResult()
      end
    end
    skillResult:EndResult()
  end
)
  LuaSkillCtrl:StartTimer(self, 6, function()
    -- function num : 0_3_1 , upvalues : _ENV, self, target
    local curGrid = LuaSkillCtrl:GetGridWithRole(self.caster)
    local ColliderEnter = BindCallback(self, self.OnColliderEnter)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_shan, self)
    local endTarget = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
    local fireCollider = LuaSkillCtrl:CallGetSectorSkillCollider(self, curGrid, (self.config).radius, (self.config).arcAngleRange, endTarget, eColliderInfluenceType.Enemy, false, ColliderEnter)
    fireCollider.bindRole = self.caster
    LuaSkillCtrl:StartTimer(nil, 1, function()
      -- function num : 0_3_1_0 , upvalues : _ENV, fireCollider, self
      LuaSkillCtrl:ClearColliderOrEmission(fireCollider)
      self:OnSkillDamageEnd()
    end
)
  end
)
end

bs_106602.OnColliderEnter = function(self, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId2, {(self.arglist)[3]})
  skillResult:EndResult()
  if entity.intensity > 0 and entity.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_Back, 1, 3)
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_ding, 1, 20)
  end
end

bs_106602.OnCallBuff = function(self, sender, target, buffId, bResult)
  -- function num : 0_5 , upvalues : bs_106602, _ENV
  if (bs_106602.blackBuffIdDic)[buffId] == true and target.belongNum ~= (self.caster).belongNum and target:GetBuffTier((self.config).buffId_1) > 0 then
    local x = target.x
    do
      local y = target.y
      LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_5_0 , upvalues : self, target, x, y, _ENV
    if self.caster == nil or (self.caster).hp <= 0 then
      return 
    end
    if target.x == x and target.y == y then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {(self.arglist)[4]})
      skillResult:EndResult()
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill, self)
    end
  end
)
    end
  end
end

bs_106602.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106602

