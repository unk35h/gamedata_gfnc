-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106003 = class("bs_106003", LuaSkillBase)
local base = LuaSkillBase
bs_106003.config = {effectId_new = 106015, effectId_attack = 106016, effectId_hit = 106013, effectId_hit2 = 106013, effectId_nil = 104110, hurtConfigId = 3, HurtConfigID = 19, heal_resultId = 6, buffId_1 = 106005, buffId_2 = 106003, buffId_3 = 106004, buffId_dodge = 3023, buffId_3024 = 3024, skill_time = 38, start_time = 8, actionId = 1043, action_speed = 1, audioIdStart = 106008, audioIdMovie = 106009, audioIdEnd = 106010}
bs_106003.ctor = function(self)
  -- function num : 0_0
end

bs_106003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106003.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait(20)
  if selectRoles.Count ~= 0 and selectRoles[0] ~= nil and (selectRoles[0]).hp > 0 then
    LuaSkillCtrl:CallBuff(self, selectRoles[0], (self.config).buffId_1, 1, (self.arglist)[1])
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_2, 1, (self.arglist)[1])
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_dodge, 1, (self.arglist)[1])
  local allFriendRoles = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  local count = allFriendRoles.Count
  if count <= 0 then
    return 
  end
  for i = 0, count - 1 do
    if allFriendRoles[i] ~= self.caster then
      LuaSkillCtrl:CallBuff(self, allFriendRoles[i], (self.config).buffId_2, 1, (self.arglist)[1])
      LuaSkillCtrl:CallBuff(self, allFriendRoles[i], (self.config).buffId_dodge, 1, (self.arglist)[1])
    end
  end
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : self, selectRoles, _ENV
    if self.caster ~= nil and (self.caster).hp > 0 and selectRoles.Count ~= 0 and selectRoles[0] ~= nil and (selectRoles[0]).hp > 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, (self.config).start_time, true)
      self:CallCasterWait((self.config).skill_time)
      ;
      (self.caster):LookAtTarget(selectRoles[0])
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, selectRoles[0])
      LuaSkillCtrl:StartTimer(nil, (self.config).start_time, attackTrigger, self)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_3024, 1, (self.config).start_time, true)
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
      if LuaSkillCtrl:GetRoleGridsDistance(self.caster, selectRoles[0]) == 1 then
        LuaSkillCtrl:CallEffect(selectRoles[0], (self.config).effectId_attack, self)
      end
    end
  end
)
end

bs_106003.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl:GetRoleGridsDistance(self.caster, target) == 1 then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
    self:realHurt(target)
  else
    local cusEffect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_nil, self)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (cusEffect.lsObject).localPosition = ((self.caster).lsObject).localPosition
    local collisionTrigger = BindCallback(self, self.OnCollision, target)
    LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, target, 15, 7, eColliderInfluenceType.Enemy, collisionTrigger, nil, nil, nil, true, true)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_new, self)
  end
end

bs_106003.OnCollision = function(self, target, collider, index, entity)
  -- function num : 0_4
  if entity == target then
    self:realHurt(target)
  end
end

bs_106003.realHurt = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    local hurt = (self.arglist)[2]
    if (self.caster):GetBuffTier((self.config).buffId_3) > 0 then
      hurt = hurt + (self.arglist)[3] * (self.caster):GetBuffTier((self.config).buffId_3)
    end
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_3, 0)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit2, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {hurt})
    skillResult:EndResult()
  end
end

bs_106003.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1.5)
end

bs_106003.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_106003.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_106003.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_106003.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Remove ~= nil then
    (self.Remove):Stop()
    self.Remove = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_106003.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
  if self.Remove ~= nil then
    (self.Remove):Stop()
    self.Remove = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_106003

