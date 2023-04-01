-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209901 = class("bs_209901", LuaSkillBase)
local base = LuaSkillBase
bs_209901.config = {
realDamage = {basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, effectid_direction = 2007204, actionId = 1022, action_speed = 1, start_time = 15, buffId_196 = 196, buffId_caster = 209901, buffId_hurt = 209902, buffId_effect = 209903}
bs_209901.ctor = function(self)
  -- function num : 0_0
end

bs_209901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_209901.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local target, grid = self:GetTarget()
  if target ~= nil and grid ~= nil then
    LuaSkillCtrl:PreSetRolePos(grid, self.caster)
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, grid)
    self.effect = LuaSkillCtrl:CallEffect(target, (self.config).effectid_direction, self)
    LuaSkillCtrl:StartTimer(self, (self.config).start_time, function()
    -- function num : 0_2_0 , upvalues : self
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
  end
)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.config).start_time, true)
    ;
    (self.caster):LookAtTarget(target)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  end
end

bs_209901.GetTarget = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 72, 10)
  if targetList.Count == 0 then
    return nil
  end
  local grid, role = nil, nil
  for i = 0, targetList.Count - 1 do
    if ((targetList[i]).targetRole).roleType == 4 then
      grid = LuaSkillCtrl:FindEmptyGridAroundRole((targetList[i]).targetRole)
      if grid ~= nil then
        role = (targetList[i]).targetRole
        return role, grid
      end
    end
  end
  if role == nil then
    for i = 0, targetList.Count - 1 do
      role = (targetList[i]).targetRole
      grid = LuaSkillCtrl:FindEmptyGridAroundRole(role)
      if grid ~= nil then
        return role, grid
      end
    end
  end
  do
    return nil, nil
  end
end

bs_209901.OnAttackTrigger = function(self, target, grid)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CanclePreSetPos(self.caster)
  LuaSkillCtrl:SetRolePos(grid, self.caster)
  ;
  (self.caster):LookAtTarget(target)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.arglist)[1], true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_caster, 1, (self.arglist)[1])
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_hurt, 1, (self.arglist)[1])
  self.effectTimer = LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_4_0 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_effect, 1, (self.arglist)[1] - 15)
  end
)
  self.timer = LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_4_1 , upvalues : self, _ENV, target
    if self.caster == nil or (self.caster).hp <= 0 then
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId_hurt, 0)
      LuaSkillCtrl:DispelBuff(target, (self.config).buffId_effect, 0)
      return 
    end
    if target ~= nil and target.hp > 0 and target:GetBuffTier((self.config).buffId_hurt) > 0 then
      local hurt_num = target.maxHp * (self.arglist)[3] // 1000
      LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).realDamage, {hurt_num}, true)
    else
      do
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 1)
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_caster, 1)
        LuaSkillCtrl:CallRoleAction(self.caster, 1024)
      end
    end
  end
, self, -1)
end

bs_209901.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectTimer ~= nil then
    (self.effectTimer):Stop()
    self.effectTimer = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

bs_209901.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.effect = nil
  ;
  (base.LuaDispose)(self)
end

return bs_209901

