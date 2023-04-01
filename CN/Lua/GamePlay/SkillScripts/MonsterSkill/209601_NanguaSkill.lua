-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209601 = class("bs_209601", LuaSkillBase)
local base = LuaSkillBase
bs_209601.config = {selectTargetId = 70, select_range = 20, select_target_buff_stun = 2007201, select_target_buff_super = 198, effectId = 2007203, damageFormular = 1047, action_start = 1105, action_end = 1020, start_time = 5, pre_action_start_time = 10, phase_move_duration = 4, audioId1 = 51, audioId2 = 52, buffId_196 = 196, audioId_hit = 209803, audioId_pass = 209802, effectId1 = 10084, effectId2 = 2007202, effectId3 = 2007202, effectid_direction = 2007204, effectId4 = 2007206, phaseMoveBuffId_69 = 2007202, configId = 3, 
realDamage = {basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, correct_formula = 0}
}
bs_209601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.isPlay = flase
  self.isUnStop = flase
  self.shape = 1
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_209601_start", 1, self.OnAfterBattleStart)
  self:AddBeforeAddBuffTrigger("bs_209601_7", 2, self.OnBeforeAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Exiled)
end

bs_209601.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_1
  if target == self.caster and self.isUnStop == true then
    context.active = false
  end
end

bs_209601.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.effect1 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId4, self)
  self.passive = LuaSkillCtrl:StartTimer(self, 5, self.Callback, self, -1, 1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, 99999)
end

bs_209601.Callback = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local per = (self.cskill).CurCDTime / (self.cskill).totalCDTime
  local shape = 0.7 * per * per + 1
  if per <= 1 and self.shape <= shape then
    self.shape = shape
  end
  LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(self.shape, self.shape, self.shape), 0.34)
end

bs_209601.PlaySkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.NotMove) or self.isPlay == true then
    return 
  end
  self.isPlay = true
  LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.7, 1.7, 1.7), 5)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 20)
  local attack_int = 0
  local pass_target1 = nil
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      if role.belongNum ~= (self.caster).belongNum and role.belongNum ~= eBattleRoleBelong.neutral and (attack_int < role.pow or attack_int < role.skill_intensity) then
        pass_target1 = role
        if role.skill_intensity <= role.pow then
          attack_int = role.pow
        else
          attack_int = role.skill_intensity
        end
      end
    end
  end
  do
    local role = pass_target1
    if role ~= nil then
      local emptyGrid = LuaSkillCtrl:GetGridWithRole(role)
      local moveAttackTrigger = BindCallback(self, self.PhaseMoveHandle, role, emptyGrid)
      local waitSecond = (self.config).pre_action_start_time + 10 + (self.config).start_time
      LuaSkillCtrl:CallBreakAllSkill(role)
      LuaSkillCtrl:CallBuff(self, role, (self.config).select_target_buff_stun, 1, waitSecond + 1, true)
      LuaSkillCtrl:CallEffect(role, (self.config).effectid_direction, self)
      self.effect0 = LuaSkillCtrl:CallEffect(role, (self.config).effectId3, self)
      LuaSkillCtrl:StartTimer(nil, 40, function()
    -- function num : 0_4_0 , upvalues : self
    if self.effect0 ~= nil then
      (self.effect0):Die()
      self.effect0 = nil
    end
    if self.effect1 ~= nil then
      (self.effect1):Die()
      self.effect1 = nil
    end
  end
)
      self:CallCasterWait(waitSecond)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).action_start, 1, 19, moveAttackTrigger)
      LuaSkillCtrl:StartTimer(self, 11, BindCallback(self, self.PlayActionAndDamage, role))
    else
      do
        self.isPlay = flase
      end
    end
  end
end

bs_209601.PhaseMoveHandle = function(self, targetRole, emptyGrid)
  -- function num : 0_5 , upvalues : _ENV
  self.isUnStop = true
  local grid_now = LuaSkillCtrl:GetGridWithRole(self.caster)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_pass)
  ;
  ((self.caster).lsObject):StartPhaseMove(4, emptyGrid, false)
end

bs_209601.PlayActionAndDamage = function(self, targetRole)
  -- function num : 0_6 , upvalues : _ENV
  self.effect2 = LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId, self, self.SkillEventFunc)
  ;
  (self.caster):LookAtTarget(targetRole)
  local attackEndTrigger = BindCallback(self, self.DamageAndEffect, targetRole)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action_end, 1)
  self.passive2 = LuaSkillCtrl:StartTimer(self, 12, attackEndTrigger, self)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
  LuaSkillCtrl:StartTimer(nil, 17, function()
    -- function num : 0_6_0 , upvalues : self
    if self.effect0 ~= nil then
      (self.effect0):Die()
      self.effect0 = nil
    end
    if self.effect1 ~= nil then
      (self.effect1):Die()
      self.effect1 = nil
    end
  end
)
end

bs_209601.DamageAndEffect = function(self, targetRole)
  -- function num : 0_7 , upvalues : _ENV
  local realHurt1 = targetRole.maxHp * (self.arglist)[1] // 1000
  local realHurt2 = LuaSkillCtrl:GetRoleAllShield(targetRole)
  local realHurt = realHurt1 + realHurt2
  if realHurt <= 0 then
    realHurt = 1
  end
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
  LuaSkillCtrl:CallRealDamage(self, targetRole, nil, (self.config).realDamage, {realHurt}, true)
  LuaSkillCtrl:RemoveLife((self.caster).maxHp * 10, self, self.caster, false, nil, false, true, 1, true)
end

bs_209601.OnBreakSkill = function(self, role)
  -- function num : 0_8 , upvalues : _ENV, base
  if role == self.caster then
    if self.passive2 ~= nil then
      (self.passive2):Stop()
      self.passive2 = nil
    end
    if self.effect2 ~= nil then
      (self.effect2):Die()
      self.effect2 = nil
    end
    self.isPlay = flase
    self.isUnStop = flase
    ;
    (base.OnBreakSkill)(self, role)
  end
end

bs_209601.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  LuaSkillCtrl:SetGameObjectActive((self.caster).lsObject, false)
  if not LuaSkillCtrl.IsInVerify then
    ((self.caster).battleRoleView):ShowUICharacterInfo(false)
  end
  ;
  (base.OnCasterDie)(self)
  if self.effect0 ~= nil then
    (self.effect0):Die()
    self.effect0 = nil
  end
  if self.effect1 ~= nil then
    (self.effect1):Die()
    self.effect1 = nil
  end
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  if self.passive2 ~= nil then
    (self.passive2):Stop()
    self.passive2 = nil
  end
end

bs_209601.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  if self.effect0 ~= nil then
    (self.effect0):Die()
    self.effect0 = nil
  end
  if self.effect1 ~= nil then
    (self.effect1):Die()
    self.effect1 = nil
  end
  if self.effect2 ~= nil then
    (self.effect2):Die()
    self.effect2 = nil
  end
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  if self.passive2 ~= nil then
    (self.passive2):Stop()
    self.passive2 = nil
  end
  if self.SetTargetActionTimer ~= nil then
    (self.SetTargetActionTimer):Stop()
    self.SetTargetActionTimer = nil
  end
end

return bs_209601

