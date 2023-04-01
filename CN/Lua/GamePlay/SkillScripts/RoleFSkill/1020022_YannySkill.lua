-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1020022 = class("bs_1020022", LuaSkillBase)
local base = LuaSkillBase
bs_1020022.config = {action_start = 1008, action_loop = 1007, action_end = 1009, stun_buff = 300601, buffId_att = 301301, cant_action_buff = 6901, hookSpeed = 12, effectId = 102004, stopCdBuff = 3008, onSecondTakeAction = 1004, audioId1 = 102004, audioId2 = 102005}
bs_1020022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_1020022_1", 1, self.BeforeEndBattle)
  self:BindHookObj()
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1020022_2", 99, self.OnBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_1020022_3", 1, self.OnRoleDie)
end

bs_1020022.BindHookObj = function(self)
  -- function num : 0_1
  local bind = self:GetSelfBindingObj()
  if bind ~= nil then
    self.weaponChildren = bind.weaponChildren
    self.weaponRoot = bind.weaponRoot
    self.weaponChildParent = (bind.weaponChildren).parent
    self.casterRoot = bind.casterRoot
  end
end

bs_1020022.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:PlaySkill()
  LuaSkillCtrl:CallAfterSkillPlayTrigger(self, self.caster)
end

bs_1020022.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).stopCdBuff, 1, nil, true)
  local emptyGrid = LuaSkillCtrl:FindRoleLeftEmptyGrid(self.caster, 10)
  if emptyGrid ~= nil then
    self.canBackRole = false
    self.targetRole = LuaSkillCtrl:CallLeftMaxDirEnemy(self.caster)
    if self.targetRole ~= nil then
      local roleToEmpty = (math.abs)((self.caster).x - emptyGrid.x)
      local roleToTarget = (math.abs)((self.caster).x - (self.targetRole).x)
      local emptyToTarget = (math.abs)(emptyGrid.x - (self.targetRole).x)
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

      if emptyToTarget >= 1 and roleToEmpty < roleToTarget then
        ((self.caster).recordTable).completedFirstHook = true
        local distance = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, (self.targetRole).x, (self.targetRole).y)
        local flyTime = distance * 15 // (self.config).hookSpeed
        flyTime = (math.max)(3, flyTime)
        local position = nil
        if not LuaSkillCtrl.IsInVerify then
          position = (((self.targetRole).lsObject).localPosition):ToVector3() + (Vector3.New)(0, 0, 1)
        end
        local startFlyHookTime = 12 + flyTime
        local hookArriveTime = startFlyHookTime + flyTime
        local backHookTime = hookArriveTime + flyTime
        LuaSkillCtrl:CallBuff(self, self.targetRole, (self.config).cant_action_buff, 1, backHookTime)
        self.haveSetRolePos = true
        LuaSkillCtrl:PreSetRolePos(emptyGrid, self.targetRole)
        self:CallCasterWait(backHookTime + 2)
        LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
        ;
        (self.caster):LookAtTarget(self.targetRole)
        LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action_start)
  end
, self)
        if position ~= nil then
          LuaSkillCtrl:StartTimer(self, startFlyHookTime, BindCallback(self, self.OnFlyHook, position, flyTime / 15))
        end
        LuaSkillCtrl:StartTimer(self, hookArriveTime, BindCallback(self, self.OnHooKGetRole, self.targetRole, emptyGrid, flyTime))
        LuaSkillCtrl:StartTimer(nil, backHookTime, BindCallback(self, self.OnHookEnd, self.targetRole))
        return 
      end
    end
  end
end

bs_1020022.OnFlyHook = function(self, targetPos, time)
  -- function num : 0_4
  if self.weaponRoot ~= nil and self.weaponChildren ~= nil and self.casterRoot ~= nil then
    (self.weaponRoot):SetParent(self.casterRoot, false)
    ;
    (self.weaponChildren):SetParent(self.weaponRoot, false)
    ;
    ((self.caster).lsObject):SelectTransAndStartMove(self.weaponRoot, targetPos, time)
  end
end

bs_1020022.OnHooKGetRole = function(self, role, backGrid, duration)
  -- function num : 0_5 , upvalues : _ENV
  self.canBackRole = true
  LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  if self.weaponRoot ~= nil then
    (self.weaponRoot).localRotation = (Quaternion.Euler)(0, 0, 0)
    ;
    (self.weaponRoot):SetParent((role.lsObject).transform)
  end
  LuaSkillCtrl:CanclePreSetPos(role)
  self.haveSetRolePos = false
  LuaSkillCtrl:CallPhaseMove(self, role, backGrid.x, backGrid.y, duration)
end

bs_1020022.OnHookEnd = function(self, targetRole)
  -- function num : 0_6 , upvalues : _ENV
  if not self.canBackRole then
    return 
  end
  self:ResetActionState()
  LuaSkillCtrl:PlayAuSource(targetRole, (self.config).audioId2)
  LuaSkillCtrl:DispelBuff(targetRole, (self.config).cant_action_buff, 0, true)
  local buffDuration = (self.arglist)[1]
  if buffDuration > 0 then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      if role ~= nil and role.hp > 0 then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_att, 1, buffDuration, nil, targetRole)
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R3 in 'UnsetPending'

    if (math.abs)(targetRole.x - (self.caster).x) <= 1 then
      ((self.caster).recordTable).lastAttackRole = targetRole
    end
  end
end

bs_1020022.ResetActionState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.weaponRoot ~= nil and self.weaponChildren ~= nil and (self.weaponRoot).parent ~= self.weaponChildren then
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action_end)
    if self.weaponChildParent ~= nil then
      (self.weaponChildren):SetParent(self.weaponChildParent, false)
    end
    ;
    (self.weaponRoot):SetParent(self.weaponChildren, false)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.weaponRoot).localRotation = (Quaternion.Euler)(0, 0, 0)
  end
end

bs_1020022.DisAbleToHook = function(self)
  -- function num : 0_8
  return ((self.caster).recordTable).completedFirstHook
end

bs_1020022.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  self.weaponChildren = nil
  self.weaponRoot = nil
  self.casterRoot = nil
  self:ResetActionState()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).completedFirstHook = false
  ;
  (base.OnCasterDie)(self)
end

bs_1020022.BeforeEndBattle = function(self)
  -- function num : 0_10
  self:ResetActionState()
end

bs_1020022.OnSkillRemove = function(self)
  -- function num : 0_11 , upvalues : base
  self.weaponChildren = nil
  self.weaponRoot = nil
  self.casterRoot = nil
  self:ResetActionState()
  ;
  (base.OnSkillRemove)(self)
end

bs_1020022.OnBreakSkill = function(self, role)
  -- function num : 0_12 , upvalues : _ENV, base
  self:ResetActionState()
  if self.targetRole ~= nil then
    if self.haveSetRolePos then
      LuaSkillCtrl:CanclePreSetPos(self.targetRole)
      self.haveSetRolePos = false
    end
    LuaSkillCtrl:DispelBuff(self.targetRole, (self.config).cant_action_buff, 0, true)
    self.targetRole = nil
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_1020022.OnRoleDie = function(self, killer, role)
  -- function num : 0_13 , upvalues : _ENV
  if self.targetRole ~= nil and self.targetRole == role and self.haveSetRolePos then
    LuaSkillCtrl:CanclePreSetPos(self.targetRole)
    self.haveSetRolePos = false
  end
end

bs_1020022.LuaDispose = function(self)
  -- function num : 0_14 , upvalues : base
  (base.LuaDispose)(self)
  self.targetRole = nil
  self.weaponChildren = nil
  self.weaponRoot = nil
  self.casterRoot = nil
end

return bs_1020022

