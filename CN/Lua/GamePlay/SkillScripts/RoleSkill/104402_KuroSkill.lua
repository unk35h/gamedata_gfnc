-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104402 = class("bs_104402", LuaSkillBase)
local base = LuaSkillBase
bs_104402.config = {start_time = 8, end_time = 35, buffId_170 = 170, actionId = 1008, actionId_end = 1009, actionId_speed = 1, effectId_Trail = 104406, effectId_Trail_Big = 104408, effectId_skillStart = 104414, effectId_Big_open = 104417, effectId_Big_open2 = 104424, effectId_loop = 104423, configId_trail = 3}
bs_104402.ctor = function(self)
  -- function num : 0_0
end

bs_104402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104402.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, (self.cskill).SkillRange) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      return 
    end
    target = tempTarget.targetRole
  end
  do
    if target == nil then
      LuaSkillCtrl:SetResetCdByReturnConfigOnce(self)
      return 
    end
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
    ;
    (self.caster):LookAtTarget(target)
    local time = (self.config).start_time + (self.arglist)[3] + (self.config).end_time
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
    self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skillStart, self, nil, nil, nil, true)
    if LuaSkillCtrl:GetCasterSkinId(self.caster) == 304406 then
      self.skillLoop2 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self, nil, nil, nil, true)
    end
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.config).start_time + (self.arglist)[3], true)
  end
end

bs_104402.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[3])
    local starttime = 1 - (self.arglist)[1]
    do
      local beginTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_3_0 , upvalues : self, target
    self:beginAttack(target)
  end
, self, -1, starttime)
      LuaSkillCtrl:StartTimer(self, (self.arglist)[3], function()
    -- function num : 0_3_1 , upvalues : beginTimer, self, target
    if beginTimer ~= nil then
      beginTimer:Stop()
      beginTimer = nil
    end
    self:endAttack(target)
  end
)
    end
  else
    do
      LuaSkillCtrl:SetResetCdByReturnConfigOnce(self)
      LuaSkillCtrl:CallBreakAllSkill(self.caster)
    end
  end
end

bs_104402.beginAttack = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  if target ~= nil and target.hp > 0 and not target:ContainFeature(eBuffFeatureType.Exiled) and not target:ContainFeature(eBuffFeatureType.NotBeSelectedExceptSameBlong) then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_Trail, self, self.SkillEventFunc)
  else
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
  end
end

bs_104402.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  do
    if effect.dataId == (self.config).effectId_Trail and eventId == eBattleEffectEvent.Trigger then
      local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_trail, {(self.arglist)[2]})
      skillResult:EndResult()
    end
    if effect.dataId == (self.config).effectId_Trail_Big and eventId == eBattleEffectEvent.Trigger then
      local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_trail, {(self.arglist)[4]})
      skillResult:EndResult()
      self:OnSkillDamageEnd()
    end
  end
end

bs_104402.endAttack = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  if target == nil or target.hp <= 0 or target:ContainFeature(eBuffFeatureType.Exiled) or target:ContainFeature(eBuffFeatureType.NotBeSelectedExceptSameBlong) then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    return 
  end
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  LuaSkillCtrl:StartTimer(self, 18, function()
    -- function num : 0_6_0 , upvalues : target, _ENV, self
    if target ~= nil and target.hp > 0 and not target:ContainFeature(eBuffFeatureType.Exiled) and not target:ContainFeature(eBuffFeatureType.NotBeSelectedExceptSameBlong) then
      if LuaSkillCtrl:GetCasterSkinId(self.caster) == 304406 then
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_Big_open2, self)
      else
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_Big_open, self)
      end
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_Trail_Big, self, self.SkillEventFunc)
    end
  end
)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.skillLoop2 ~= nil then
    (self.skillLoop2):Die()
    self.skillLoop2 = nil
  end
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  LuaSkillCtrl:StartTimer(nil, (self.config).end_time, function()
    -- function num : 0_6_1 , upvalues : self
    self:CancleCasterWait()
  end
)
end

bs_104402.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnBreakSkill)(self, role)
  if role == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
    LuaSkillCtrl:StopShowSkillDurationTime(self)
    self:CancleCasterWait()
    if self.skillLoop ~= nil then
      (self.skillLoop):Die()
      self.skillLoop = nil
    end
    if self.skillLoop2 ~= nil then
      (self.skillLoop2):Die()
      self.skillLoop2 = nil
    end
  end
end

bs_104402.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.skillLoop2 ~= nil then
    (self.skillLoop2):Die()
    self.skillLoop2 = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_104402

