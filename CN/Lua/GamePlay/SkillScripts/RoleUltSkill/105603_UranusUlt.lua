-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105603 = class("bs_105603", LuaSkillBase)
local base = LuaSkillBase
bs_105603.config = {end_time = 35, effectId_Trail = 105603, effectId_skillStart = 105605, effectId_self = 105606, effectId_turnFire = 105607, configId_trail = 3, audioIdStart = 105608, audioIdEnd = 105609, ultHFactor = 1.6}
bs_105603.ctor = function(self)
  -- function num : 0_0
end

bs_105603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_105603_1", 10, self.OnRoleDie)
  self:AddSelfTrigger(eSkillTriggerType.BeforePlaySkill, "bs_105603_2", 1, self.OnBeforePlaySkill)
end

bs_105603.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if role ~= self.caster or not (context.skill).isUltSkill then
    return 
  end
  local targetRoles = (context.skill).selectRoles
  if targetRoles ~= nil and targetRoles.Count > 0 then
    local target = targetRoles[0]
    if target:IsUnSelect(self.caster) then
      context.active = false
      LuaSkillCtrl:EndUltEffectAndUnFreeze()
    end
  end
end

bs_105603.PlaySkill = function(self, data, selectTargetCoord, selectRoles, SelectRolesType)
  -- function num : 0_3 , upvalues : _ENV
  local time = 60 + (self.arglist)[2]
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleAction(self.caster, 1010)
  do
    if selectTargetCoord ~= nil then
      local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
      ;
      (self.caster):LookAtTarget(inputTarget)
    end
    self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
  end
end

bs_105603.CallSelectExecute = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  self.target_skill = target
  self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skillStart, self, nil, nil, nil, true)
  self.skillLoop2 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_self, self, nil, nil, nil, true)
  local starttime = (self.arglist)[1] - 1
  self.beginTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_4_0 , upvalues : self, target
    self:beginAttack(target)
  end
, self, -1, starttime)
  self.time = LuaSkillCtrl:StartTimer(self, (self.arglist)[3], function()
    -- function num : 0_4_1 , upvalues : self, target
    if self.beginTimer ~= nil then
      (self.beginTimer):Stop()
      self.beginTimer = nil
    end
    self:endAttack(target)
  end
)
end

bs_105603.beginAttack = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  self.target_skill = target
  if target ~= nil and target.hp > 0 and not target:ContainFeature(eBuffFeatureType.Exiled) and not target:ContainFeature(eBuffFeatureType.NotBeSelectedExceptSameBlong) then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_Trail, self, self.SkillEventFunc)
  else
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
  end
end

bs_105603.endAttack = function(self, target)
  -- function num : 0_6 , upvalues : _ENV
  if target == nil or target.hp <= 0 or target:ContainFeature(eBuffFeatureType.Exiled) or target:ContainFeature(eBuffFeatureType.NotBeSelectedExceptSameBlong) then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    return 
  end
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.skillLoop2 ~= nil then
    (self.skillLoop2):Die()
    self.skillLoop2 = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  self.target_skill = nil
  LuaSkillCtrl:CallRoleAction(self.caster, 1006)
  LuaSkillCtrl:StartTimer(self, 20, function()
    -- function num : 0_6_0 , upvalues : self
    self:CancleCasterWait()
  end
)
end

bs_105603.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_Trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_trail, {(self.arglist)[2]})
    skillResult:EndResult()
  end
end

bs_105603.OnRoleDie = function(self, killer, role)
  -- function num : 0_8 , upvalues : _ENV
  if role == self.target_skill and role.hp == 0 and role ~= nil then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_turnFire, self)
    local role_new = nil
    do
      local targetList = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
      if targetList ~= 0 then
        for i = 0, targetList.Count - 1 do
          if (targetList[i]).targetRole ~= nil and ((targetList[i]).targetRole).belongNum ~= eBattleRoleBelong.neutral and not LuaSkillCtrl:RoleContainsBuffFeature((targetList[i]).targetRole, eBuffFeatureType.NotBeSelectedExceptSameBlong) then
            role_new = (targetList[i]).targetRole
            break
          end
        end
      end
      do
        if role_new ~= nil then
          local time = (self.time).left + (self.arglist)[4]
          if self.beginTimer ~= nil then
            (self.beginTimer):Stop()
            self.beginTimer = nil
          end
          if self.skillLoop ~= nil then
            (self.skillLoop):Die()
            self.skillLoop = nil
          end
          if self.skillLoop2 ~= nil then
            (self.skillLoop2):Die()
            self.skillLoop2 = nil
          end
          if self.time ~= nil then
            (self.time):Stop()
            self.time = nil
          end
          local dur = time + 20
          self:AddCasterWait(dur)
          ;
          (self.caster):LookAtTarget(role_new)
          LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_8_0 , upvalues : self, _ENV
    self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skillStart, self, nil, nil, nil, true)
  end
)
          self.beginTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_8_1 , upvalues : self, role_new
    self:beginAttack(role_new)
  end
, self, -1, (self.arglist)[1])
          self.time = LuaSkillCtrl:StartTimer(self, time, function()
    -- function num : 0_8_2 , upvalues : self, role_new
    if self.beginTimer ~= nil then
      (self.beginTimer):Stop()
      self.beginTimer = nil
    end
    self:endAttack(role_new)
  end
)
        else
          do
            self:endAttack(role_new)
          end
        end
      end
    end
  end
end

bs_105603.OnUltRoleAction = function(self)
  -- function num : 0_9 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_105603.PlayUltEffect = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105603.OnSkipUltView = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105603.OnMovieFadeOut = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105603.OnCasterDie = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnCasterDie)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.skillLoop2 ~= nil then
    (self.skillLoop2):Die()
    self.skillLoop2 = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
end

bs_105603.LuaDispose = function(self)
  -- function num : 0_14 , upvalues : base
  (base.LuaDispose)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.skillLoop2 ~= nil then
    (self.skillLoop2):Die()
    self.skillLoop2 = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
end

bs_105603.OnBreakSkill = function(self, role)
  -- function num : 0_15 , upvalues : _ENV, base
  if role == self.caster then
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, 1006)
  end
  ;
  (base.OnBreakSkill)(self, role)
end

return bs_105603

