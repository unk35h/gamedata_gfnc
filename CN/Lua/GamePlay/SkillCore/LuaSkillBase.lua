-- params : ...
-- function num : 0 , upvalues : _ENV
local csRoleState = CS.eBattleRoleState
local LuaSkillBase = class("LuaSkillBase")
LuaSkillBase.ctor = function(self)
  -- function num : 0_0
end

LuaSkillBase.__InitSkillInternal = function(self, cskill, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self.cskill = cskill
  self.isCommonAttack = cskill.isCommonAttack
  self.caster = cskill.maker
  self.level = cskill.level
  self.arglist = {}
  self.dataID = cskill.dataId
  self.timers = {}
  self.effects = {}
  self.luaTriggerDict = {}
  self.luaTriggerList = {}
  for i = 0, (cskill.skillFormulaArgs).Length - 1 do
    (table.insert)(self.arglist, (cskill.skillFormulaArgs)[i])
  end
  self._skillLogicType = cskill.skillType
  self:InitSkill(isMidwaySkill)
  local skillComp = (self.caster):GetSkillComponent()
  if skillComp ~= nil and skillComp.disableAutoTakeSkill and (self.caster).roleType ~= eBattleRoleType.skillCaster then
    skillComp.disableAutoTakeSkill = false
  end
end

LuaSkillBase.IsConsumeSkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  do return self._skillLogicType == eBattleSkillLogicType.ChipConsume end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillBase.IsSkillCasterUltSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  do return (self.caster).roleType == eBattleRoleType.skillCaster end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillBase.GetSelfBindingObj = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local binding = nil
  if self.caster == nil then
    return 
  end
  if ((self.caster).lsObject).gameObject ~= nil then
    binding = {}
    ;
    (UIUtil.LuaUIBindingTable)(((self.caster).lsObject).gameObject, binding)
  end
  return binding
end

LuaSkillBase.AddTimer = function(self, timer)
  -- function num : 0_5 , upvalues : _ENV
  if self.timers ~= nil and timer ~= nil then
    (table.insert)(self.timers, timer)
  end
end

LuaSkillBase.RemoveTimer = function(self, timer)
  -- function num : 0_6 , upvalues : _ENV
  if self.timers ~= nil and timer ~= nil then
    (table.removebyvalue)(self.timers, timer)
  end
end

LuaSkillBase.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_7 , upvalues : _ENV
  self:AddSelfTrigger(eSkillTriggerType.OnBreakSkill, "base_breakSkill", 1, self.OnBreakSkill)
end

LuaSkillBase.OnCasterBorn = function(self)
  -- function num : 0_8
end

LuaSkillBase.PlaySkill = function(self, data, selectTargetCoord, selectRoles, selectRolesType)
  -- function num : 0_9
  return true
end

LuaSkillBase.OnUltInternalPlaySkill = function(self, data, selectTargetCoord, selectRoles, selectRolesType)
  -- function num : 0_10 , upvalues : _ENV
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnUltSkillPlayed, self.caster)
  return self:PlaySkill(data, selectTargetCoord, selectRoles, selectRolesType)
end

LuaSkillBase.PlayMonsterUltSkill = function(self, triggerDelay, data)
  -- function num : 0_11 , upvalues : _ENV
  local targetRoles = self:HandleSelectTarget()
  if targetRoles == nil then
    return nil
  end
  self:CallCasterWait(triggerDelay)
  if data.buffId_Super ~= nil then
    LuaSkillCtrl:CallBuff(self, self.caster, data.buffId_Super, 1, 15, true)
  end
  if data.actionId_start ~= nil then
    LuaSkillCtrl:CallRoleAction(self.caster, data.actionId_start)
  end
  local invokeTimer = LuaSkillCtrl:StartTimer(nil, data.delayInvoke, BindCallback(self, self.InternalInvoke, data, targetRoles))
  return invokeTimer
end

LuaSkillBase.HandleSelectTarget = function(self)
  -- function num : 0_12
  local target = self:GetMoveSelectTarget()
  if target == nil then
    return nil
  end
  ;
  (self.caster):LookAtInstantly(target.targetRole)
  return target.targetRole
end

LuaSkillBase.InternalInvoke = function(self, data, role)
  -- function num : 0_13
end

LuaSkillBase.OnMonsterUltPlay = function(self, data, selectTargetCoord, selectRoles, containsMovie, funcPlaySkill)
  -- function num : 0_14 , upvalues : _ENV
  (LuaSkillCtrl.cUltSkillCtrl):SetCurrentUltSkill(self.cskill, containsMovie)
  ;
  (LuaSkillCtrl.battleCtrl):SetUltSkillFreeze(self.cskill)
  self:RemoveSkillTrigger(eSkillTriggerType.AfterSelfUltSpecTimeLineEnd)
  self:AddTrigger(eSkillTriggerType.AfterSelfUltSpecTimeLineEnd, "baseult_afterSpec", 1, self.AfterUltSpecView)
  self:RemoveSkillTrigger(eSkillTriggerType.AfterSelfUltEffectEnd)
  self:AddTrigger(eSkillTriggerType.AfterSelfUltEffectEnd, "baseult_after", 1, BindCallback(self, funcPlaySkill, data, selectTargetCoord, selectRoles))
  local isCancleTake = false
  self:RemoveSkillTrigger(eSkillTriggerType.StartSelfUltRoleAction)
  self:AddTrigger(eSkillTriggerType.StartSelfUltRoleAction, "baseult_startaction", 1, self.CkeckAndCallUltRoleAction)
  isCancleTake = self:PlayUltEffect(data, selectTargetCoord, selectRoles)
  if isCancleTake then
    return false
  end
  MsgCenter:Broadcast(eMsgEventId.OnUltSkillRoleActionStart, self.caster)
end

LuaSkillBase.TakeSkillPlay = function(self, data, isUltSkill, moveSelectTarget, selectTargetCoord, selectRoles)
  -- function num : 0_15 , upvalues : _ENV
  self.__isBrodcastDamageEnd = false
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R6 in 'UnsetPending'

  if isUltSkill then
    ((self.caster).recordTable).lastSkill = self.dataID
    self.ultHmp = LuaSkillCtrl:GetUltHMp()
    self:RemoveSkillTrigger(eSkillTriggerType.AfterSelfUltSpecTimeLineEnd)
    self:AddTrigger(eSkillTriggerType.AfterSelfUltSpecTimeLineEnd, "baseult_afterSpec", 1, self.AfterUltSpecView)
    self:RemoveSkillTrigger(eSkillTriggerType.AfterSelfUltEffectEnd)
    self:AddTrigger(eSkillTriggerType.AfterSelfUltEffectEnd, "baseult_after", 1, BindCallback(self, self.OnUltInternalPlaySkill, data, selectTargetCoord, selectRoles, SelectRolesType.CsBattleRoleList))
    local isCancleTake = false
    if self:IsSkillCasterUltSkill() then
      isCancleTake = self:PlayUltMovie(moveSelectTarget, selectTargetCoord, selectRoles)
      if isCancleTake then
        if (self.cskill).maker == nil then
          return true
        end
        local makerSkillMgr = ((self.cskill).maker):GetSkillComponent()
        if makerSkillMgr == nil then
          return true
        end
        makerSkillMgr:SetUltSkillNull()
        local playerCtrl = (LuaSkillCtrl.battleCtrl).PlayerController
        playerCtrl:OnUltSkillTakeComplete(self.cskill)
        -- DECOMPILER ERROR at PC78: Confused about usage of register: R9 in 'UnsetPending'

        ;
        (LuaSkillCtrl.cUltSkillCtrl).isStartUltEffect = false
        local curUltMp = ((LuaSkillCtrl.cUltSkillCtrl).ultSkillModel).UltMp
        -- DECOMPILER ERROR at PC90: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((LuaSkillCtrl.cUltSkillCtrl).ultSkillModel).ultMp = curUltMp - (ConfigData.game_config).ultMpCost
        return false
      end
    else
      do
        self:RemoveSkillTrigger(eSkillTriggerType.StartSelfUltRoleAction)
        self:AddTrigger(eSkillTriggerType.StartSelfUltRoleAction, "baseult_startaction", 1, self.CkeckAndCallUltRoleAction)
        isCancleTake = self:PlayUltEffect(data, selectTargetCoord, selectRoles)
        if isCancleTake then
          return false
        end
        local returnArg = 0
        do
          if self.caster ~= nil then
            local dynHero = (self.caster).character
            if dynHero ~= nil then
              returnArg = dynHero:GetRawAttr(eRawAttr.RawAttributionIdEnergyReturn)
            end
          end
          if returnArg > 0 then
            local curMp = ((LuaSkillCtrl.cUltSkillCtrl).ultSkillModel).ultMp
            local returnVal = (ConfigData.game_config).ultMpCost * returnArg // 1000
            -- DECOMPILER ERROR at PC143: Confused about usage of register: R10 in 'UnsetPending'

            ;
            ((LuaSkillCtrl.cUltSkillCtrl).ultSkillModel).ultMp = curMp + returnVal
          end
          do
            do
              do
                if not (string.IsNullOrEmpty)(((self.cskill).skillCfg).SkillMovie) then
                  MsgCenter:Broadcast(eMsgEventId.OnUltSkillRoleActionStart, self.caster)
                end
                do return true end
                self.moveSelectTarget = moveSelectTarget
                local result = self:PlaySkill(data, selectTargetCoord, selectRoles)
                -- DECOMPILER ERROR at PC170: Confused about usage of register: R7 in 'UnsetPending'

                ;
                ((self.caster).recordTable).lastSkill = self.dataID
                do return result end
              end
            end
          end
        end
      end
    end
  end
end

LuaSkillBase.CheckSortTarget = function(self, targetA, targetB, finalCoordA, finalCoordB)
  -- function num : 0_16
  return 0
end

LuaSkillBase.GetMoveSelectTarget = function(self)
  -- function num : 0_17
  if self.moveSelectTarget == nil or (self.moveSelectTarget).targetRole == nil or ((self.moveSelectTarget).targetRole).hp <= 0 then
    return nil
  end
  return self.moveSelectTarget
end

LuaSkillBase.CkeckAndCallUltRoleAction = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if (LuaSkillCtrl.cUltSkillCtrl).currentSkill == nil then
    return 
  end
  self:OnUltRoleAction()
end

LuaSkillBase.OnUltRoleAction = function(self)
  -- function num : 0_19
end

LuaSkillBase.AfterUltSpecView = function(self, isFromBreak)
  -- function num : 0_20 , upvalues : _ENV
  if self:IsSkillCasterUltSkill() then
    LuaSkillCtrl:CallEndUltEffect(self.caster)
  else
    LuaSkillCtrl:CallBackViewTimeLine(self.caster, true)
  end
  self:OnAfterUltEffect(isFromBreak)
end

LuaSkillBase.GetSelectTargetAndExecute = function(self, selectRoles, executeFunc, selectRolesType)
  -- function num : 0_21 , upvalues : _ENV
  if executeFunc == nil then
    return true
  end
  if not selectRolesType then
    selectRolesType = SelectRolesType.CsBattleRoleList
  end
  local takeAvailable = false
  if selectRolesType == SelectRolesType.SingleRole then
    local curSkilltakeAvailable = self:CheckManualSkillTakeAvailable(selectRoles)
    if curSkilltakeAvailable then
      takeAvailable = curSkilltakeAvailable
      executeFunc(selectRoles)
    end
    return takeAvailable
  else
    do
      if selectRolesType == SelectRolesType.LuaRoleArray then
        if #selectRoles <= 0 then
          return false
        end
        for _,curRole in ipairs(selectRoles) do
          local curSkilltakeAvailable = self:CheckManualSkillTakeAvailable(curRole)
          if curSkilltakeAvailable then
            takeAvailable = curSkilltakeAvailable
            executeFunc(curRole)
          end
        end
        return takeAvailable
      end
      if selectRoles == nil or selectRoles.Count <= 0 then
        return false
      end
      for i = selectRoles.Count - 1, 0, -1 do
        if selectRoles == nil or selectRoles.Count <= i then
          return 
        end
        local curRole = selectRoles[i]
        if selectRolesType == SelectRolesType.CsBattleTargetList then
          curRole = curRole.targetRole
        end
        local curSkilltakeAvailable = self:CheckManualSkillTakeAvailable(curRole)
        if curSkilltakeAvailable then
          takeAvailable = curSkilltakeAvailable
          executeFunc(curRole)
        end
      end
      return takeAvailable
    end
  end
end

LuaSkillBase.CheckManualSkillTakeAvailable = function(self, role)
  -- function num : 0_22 , upvalues : _ENV
  if role == nil or role.hp <= 0 then
    return false
  end
  local manualCfg = (self.cskill):GetManualSkillCfg()
  local isIgnoreUnselectableSameBelong = (manualCfg ~= nil and manualCfg.IgnoreUnselectableSameBelong)
  if isIgnoreUnselectableSameBelong and role:IsUnSelect(self.caster) then
    return false
  end
  if self.AbandonTakeFeature == nil or #self.AbandonTakeFeature == nil then
    return true
  end
  for i = 1, #self.AbandonTakeFeature do
    if LuaSkillCtrl:RoleContainsBuffFeature(role, (self.AbandonTakeFeature)[i]) then
      return false
    end
  end
  do return true end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

LuaSkillBase.InjectActionTrigger = function(self, mainAction)
  -- function num : 0_23
  self.actionTrigger = mainAction
end

LuaSkillBase.TakeActionTrigger = function(self)
  -- function num : 0_24 , upvalues : _ENV
  self.isSkillUncompleted = false
  if self.actionTrigger ~= nil then
    if not self.isCommonAttack then
      LuaSkillCtrl:StopShowSkillDurationTime(self)
    end
    ;
    (self.actionTrigger)()
    self.actionTrigger = nil
  end
end

LuaSkillBase.OnBreakSkill = function(self, role)
  -- function num : 0_25 , upvalues : _ENV
  if role ~= self.caster then
    return 
  end
  if self.timers ~= nil then
    local leng = (table.length)(self.timers)
    if leng > 0 then
      for i = 1, leng do
        if (self.timers)[i] ~= nil then
          ((self.timers)[i]):Stop()
          -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.timers)[i] = nil
        end
      end
    end
    do
      do
        self.timers = {}
        self:RemoveAllBreakKillEffects()
        if not self.isCommonAttack and (self.caster).roleType ~= eBattleRoleType.skillCaster then
          local curShowDurationSkill = ((self.caster).recordTable).curStartShowDurationSkill
          local bIsCanStop = false
          -- DECOMPILER ERROR at PC49: Unhandled construct in 'MakeBoolean' P1

          if curShowDurationSkill ~= nil and curShowDurationSkill == self then
            bIsCanStop = true
          end
          bIsCanStop = true
          if bIsCanStop then
            LuaSkillCtrl:StopShowSkillDurationTime(self)
          end
        end
        do
          if self.isSkillUncompleted then
            (self.caster):RemoveSkillWaitBuff()
            ;
            (self.cskill):ReturnCDTimeFromBreak()
            self.isSkillUncompleted = false
          end
          if (self.cskill).isNormalSkill and self.dataID == ((self.caster).recordTable).lastSkill then
            self:OnSkillDamageEnd()
          end
        end
      end
    end
  end
end

LuaSkillBase.TryResetMoveState = function(self, role)
  -- function num : 0_26 , upvalues : csRoleState
  if role == nil or role.hp <= 0 then
    return 
  end
  if role.eState == csRoleState.Moving then
    role:SetRoleState(csRoleState.Normal)
  end
end

LuaSkillBase.OnCasterDie = function(self)
  -- function num : 0_27 , upvalues : _ENV
  self:KillEquipmentSummoner()
  LuaSkillCtrl:RemoveHandleAllTrigger(self.cskill)
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  self:RemoveAllLuaTrigger()
  self:RemoveAllHaleEmission()
  if ((self.caster).recordTable).lastSkill == self.dataID then
    self:OnSkillDamageEnd()
  end
end

LuaSkillBase.KillEquipmentSummoner = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local equipmentSummonerKey = (ConfigData.buildinConfig).EquipmentSummonerKey
  local equipmentSummoner = ((self.caster).recordTable)[equipmentSummonerKey]
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  if equipmentSummoner ~= nil then
    ((self.caster).recordTable)[equipmentSummonerKey] = nil
    LuaSkillCtrl:DispelBuff(equipmentSummoner, (ConfigData.buildinConfig).EquipmentSummonerInvinsibleBuffId, 1, true, true)
    equipmentSummoner:SubHp(equipmentSummoner.hp)
    if equipmentSummoner.isDead and equipmentSummoner.eState ~= (CS.eBattleRoleState).Deading then
      equipmentSummoner:OnDead(equipmentSummoner, nil)
    end
  end
end

LuaSkillBase.RemoveAllTimers = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.timers == nil then
    return 
  end
  local leng = (table.length)(self.timers)
  if leng > 0 then
    for i = 1, leng do
      if (self.timers)[i] ~= nil then
        ((self.timers)[i]):Stop()
        -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self.timers)[i] = nil
      end
    end
  end
  do
    self.timers = {}
  end
end

LuaSkillBase.RemoveAllBreakKillEffects = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if self.effects == nil then
    return 
  end
  local leng = (table.length)(self.effects)
  if leng > 0 then
    for i = 1, leng do
      if (self.effects)[i] ~= nil and not ((self.effects)[i]):IsDie() then
        local skillMaker = ((self.effects)[i]).skillMaker
        if skillMaker == nil or skillMaker == self.caster then
          ((self.effects)[i]):Die()
        end
      end
    end
  end
  do
    self.effects = {}
  end
end

LuaSkillBase.BreakSkill = function(self)
  -- function num : 0_31 , upvalues : _ENV
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  LuaSkillCtrl:CallResetComAtkCDRatioForRole(self.caster, 100)
  LuaSkillCtrl:BreakCurrentAction(self.caster)
  self:OnSkillDamageEnd()
end

LuaSkillBase.OnSkillRemove = function(self)
  -- function num : 0_32 , upvalues : _ENV
  if self.ultCv ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.ultCv)
    self.ultCv = nil
  end
  LuaSkillCtrl:RemoveHandleAllTrigger(self.cskill)
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  self:RemoveAllLuaTrigger()
  if ((self.caster).recordTable).curStartShowDurationSkill == self then
    LuaSkillCtrl:StopShowSkillDurationTime(self)
  end
end

LuaSkillBase.OnSkillDamageEnd = function(self)
  -- function num : 0_33 , upvalues : _ENV
  if self.__isBrodcastDamageEnd == false and (self.cskill).isNormalSkill then
    self.__isBrodcastDamageEnd = true
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnDamageEnd, self)
  end
end

LuaSkillBase.AddTrigger = function(self, triggerType, name, priority, eventFunc)
  -- function num : 0_34 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTrigger(triggerType, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false)
end

LuaSkillBase.AddSelfTrigger = function(self, triggerType, name, priority, eventFunc)
  -- function num : 0_35 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTrigger(triggerType, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, true, self.caster)
end

LuaSkillBase.RemoveSkillTrigger = function(self, triggerType)
  -- function num : 0_36 , upvalues : _ENV
  LuaSkillCtrl:RemoveTrigger(self.cskill, triggerType)
end

LuaSkillBase.AddSetHurtTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_37 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.SetHurt, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddSetDeadHurtTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_38 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.SetDeadHurt, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddAfterHurtTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_39 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, self.__BaseOnAfterHurt, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterHurt, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.__BaseOnAfterHurt = function(self, eventFunc, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet, extraArg)
  -- function num : 0_40 , upvalues : _ENV
  if extraArg ~= nil and extraArg == (ConfigData.buildinConfig).HurtIgnoreKey then
    return 
  end
  if eventFunc ~= nil then
    eventFunc(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet, extraArg)
  end
end

LuaSkillBase.AddSetHealTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_41 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.SetHeal, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddAfterHealTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_42 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterHeal, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddAfterAddBuffTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_43 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterAddBuff, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddAfterAddBuffHitMaxTierTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_44 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterBuffAddHitMaxTier, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddBeforeAddBuffTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_45 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.BeforeAddBuff, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddBeforeBuffDispelTrigger = function(self, name, priority, eventFunc, target, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_46 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.BeforeBuffDispel, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, nil, target, -1, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddBuffDieTrigger = function(self, name, priority, eventFunc, target, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_47 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.BuffDie, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, nil, target, -1, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddAfterBuffRemoveTrigger = function(self, name, priority, eventFunc, target, targetBelongNum, buffId, buffType, buffFeature)
  -- function num : 0_48 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterBuffRemove, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, nil, target, -1, targetBelongNum, 0, 0, buffId, buffType, buffFeature)
end

LuaSkillBase.AddOnRoleDieTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId)
  -- function num : 0_49 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.RoleDie, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId)
end

LuaSkillBase.AddOnPlayerMpCostedTrigger = function(self, name, priority, eventFunc, costTargetValue)
  -- function num : 0_50 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.OnPlayerMpCostToTargetValue, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, nil, nil, nil, nil, 0, 0, costTargetValue)
end

LuaSkillBase.AddHurtResultStartTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_51 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.HurtResultStart, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddHurtResultEndTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_52 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.HurtResultEnd, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddHealResultStartTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_53 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.HealResultStart, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddHealResultEndTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
  -- function num : 0_54 , upvalues : _ENV
  if isTriggerSet == true then
    isTriggerSet = 1
  else
    if isTriggerSet == false then
      isTriggerSet = 0
    else
      isTriggerSet = -1
    end
  end
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.HealResultEnd, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag, isTriggerSet)
end

LuaSkillBase.AddAfterPlaySkillTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag)
  -- function num : 0_55 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.AfterPlaySkill, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag)
end

LuaSkillBase.AddBeforePlaySkillTrigger = function(self, name, priority, eventFunc, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag)
  -- function num : 0_56 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.BeforePlaySkill, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, skillId, skillTag)
end

LuaSkillBase.AddAfterResurrectionCharacterTrigger = function(self, name, priority, eventFunc, resurrectionRole, resurrectionRoleBelongNum, resurrectionRoleRoleType)
  -- function num : 0_57 , upvalues : _ENV
  local bindFunc = BindCallback(self, eventFunc)
  LuaSkillCtrl:AddSkillTriggerWithBindArg(eSkillTriggerType.OnAfterResurrectionCharacter, self.cskill, eTriggerSkillType.RoleSkill, name, priority, bindFunc, false, resurrectionRole, nil, resurrectionRoleBelongNum, nil, resurrectionRoleRoleType)
end

LuaSkillBase.AddLuaTrigger = function(self, luaTriggerId, action)
  -- function num : 0_58 , upvalues : _ENV
  if action ~= nil then
    local cb = BindCallback(self, action)
    if (self.luaTriggerDict)[luaTriggerId] ~= nil then
      error((string.format)("%s已经包含了%s的特殊Lua触发器，请检查%s", (self.cskill).name, luaTriggerId, (self.cskill).dataId))
      return 
    end
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.luaTriggerDict)[luaTriggerId] = cb
    ;
    (table.insert)(self.luaTriggerList, luaTriggerId)
    LuaSkillCtrl:RegisterLuaTrigger(luaTriggerId, cb)
  end
end

LuaSkillBase.UnRegisterLuaTrigger = function(self, luaTriggerId)
  -- function num : 0_59 , upvalues : _ENV
  if luaTriggerId == nil then
    return 
  end
  local cb = nil
  if (self.luaTriggerDict)[luaTriggerId] ~= nil then
    cb = (self.luaTriggerDict)[luaTriggerId]
  end
  if cb == nil then
    return 
  end
  LuaSkillCtrl:UnRegisterLuaTrigger(luaTriggerId, cb)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.luaTriggerDict)[luaTriggerId] = nil
  ;
  (table.removebyvalue)(self.luaTriggerList, luaTriggerId)
end

LuaSkillBase.RemoveAllLuaTrigger = function(self)
  -- function num : 0_60 , upvalues : _ENV
  if self.luaTriggerDict == nil or self.luaTriggerList == nil then
    return 
  end
  for i = #self.luaTriggerList, 1, -1 do
    local triggerId = (self.luaTriggerList)[i]
    if (self.luaTriggerDict)[triggerId] ~= nil then
      local cb = (self.luaTriggerDict)[triggerId]
      LuaSkillCtrl:UnRegisterLuaTrigger(triggerId, cb)
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.luaTriggerDict)[triggerId] = nil
    end
  end
  self.luaTriggerList = {}
  self.luaTriggerDict = {}
end

LuaSkillBase.CallCaterAtion = function(self, id)
  -- function num : 0_61 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, id)
end

LuaSkillBase.CallCasterWait = function(self, duration, isWaiteToCallNextSkillUnFreeze)
  -- function num : 0_62
  ;
  (self.caster):AddSkillWaitBuff(duration, isWaiteToCallNextSkillUnFreeze or false)
end

LuaSkillBase.AddCasterWait = function(self, duration)
  -- function num : 0_63 , upvalues : _ENV
  if duration ~= nil and duration > 0 and (self.caster).eState == (CS.eBattleRoleState).Casting then
    (self.caster):SetRoleState((CS.eBattleRoleState).Casting, duration)
  end
end

LuaSkillBase.AbandonSkillCdAutoReset = function(self, isAbandon)
  -- function num : 0_64
  (self.cskill):SetSkillAbandonAutoResetCd(isAbandon)
end

LuaSkillBase.CancleCasterWait = function(self)
  -- function num : 0_65
  (self.caster):RemoveSkillWaitBuff()
end

LuaSkillBase.CallNextBossSkill = function(self)
  -- function num : 0_66
  self:OnSkillTake()
  ;
  (self.caster):CallUnFreezeNextSkill()
end

LuaSkillBase.CallCasterLookAt = function(self, targetList)
  -- function num : 0_67
  if targetList.Count > 0 then
    (self.caster):LookAtTarget(targetList[0])
  end
end

LuaSkillBase.IsReadyToTake = function(self)
  -- function num : 0_68
  return (self.cskill):IsReadyToTake()
end

LuaSkillBase.OnSkillTake = function(self)
  -- function num : 0_69
  (self.cskill):OnSkillTake()
end

LuaSkillBase.PlayChipEffect = function(self)
  -- function num : 0_70
end

LuaSkillBase.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_71 , upvalues : _ENV
  LuaSkillCtrl:ResetUltFactor()
  if (self.config).ultHFactor ~= nil then
    LuaSkillCtrl:SetUltHFactor((self.config).ultHFactor)
  end
  if (self.config).ultVFactor ~= nil then
    LuaSkillCtrl:SetUltVFactor((self.config).ultVFactor)
  end
  self.ultCv = LuaSkillCtrl:PlaySkillCv((self.caster).roleDataId)
  if (self.config).audioIdStart == nil then
    return 
  end
  self.startAudio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioIdStart, function(auback)
    -- function num : 0_71_0 , upvalues : self
    if auback == self.startAudio then
      self.startAudio = nil
    end
  end
)
end

LuaSkillBase.PlayUltMovie = function(self, moveSelectTarget, selectTargetCoord, selectRoles)
  -- function num : 0_72 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.OnUltSkillVideoStart)
  if (string.IsNullOrEmpty)((LuaSkillCtrl.cUltSkillCtrl).curUltMovieFileName) then
    self:OnMovieFadeOut()
    return 
  end
  if not (CommonUtil.GetIsNeedPlayUltrSkillAnimi)((self.cskill).dataId, true) then
    self:OnMovieFadeOut()
    return 
  end
  self:RemoveSkillTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut)
  self:AddTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut, "OnMovieFadeOut", 1, self.OnMovieFadeOut)
  LuaSkillCtrl:CallPlayUltMovie()
  if (self.config).audioIdMovie == nil then
    return 
  end
  self.actionAudio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioIdMovie, function(auback)
    -- function num : 0_72_0 , upvalues : self
    if auback == self.actionAudio then
      self.actionAudio = nil
    end
  end
)
end

LuaSkillBase.OnMovieFadeOut = function(self)
  -- function num : 0_73 , upvalues : _ENV
  self:RemoveSkillTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut)
  if self:IsSkillCasterUltSkill() then
    LuaSkillCtrl:CallEndUltEffect(self.caster)
  else
    if (self.config).movieEndRoleActionId ~= nil then
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).movieEndRoleActionId)
    end
    LuaSkillCtrl:CallBackViewTimeLine(self.caster, true)
  end
  self:OnAfterUltEffect()
end

LuaSkillBase.OnAfterUltEffect = function(self, isFromBreak)
  -- function num : 0_74 , upvalues : _ENV
  if isFromBreak and self.actionAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.actionAudio)
    self.actionAudio = nil
  end
  if self.startAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.startAudio)
    self.startAudio = nil
  end
  if (self.config).audioIdEnd ~= nil then
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioIdEnd)
  end
  MsgCenter:Broadcast(eMsgEventId.OnUltSkillViewEnd)
end

LuaSkillBase.GetRoleMoveSpeed = function(self)
  -- function num : 0_75
  return (self.caster).moveSpeed
end

LuaSkillBase.GetRoleAttackSpeed = function(self)
  -- function num : 0_76
  return (self.caster).speed
end

LuaSkillBase.CalcAtkActionSpeed = function(self, atkInterval, atkId)
  -- function num : 0_77
  local atkTotalFrames = self:GetTotalAtkActionFrames(atkId)
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

LuaSkillBase.GetTotalAtkActionFrames = function(self, atkId)
  -- function num : 0_78 , upvalues : _ENV
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  if atkId == 1 then
    return ((ConfigData.resource_model)[srcId]).atk1_frames
  else
    if atkId == 2 then
      return ((ConfigData.resource_model)[srcId]).atk2_frames
    else
      return 0
    end
  end
end

LuaSkillBase.GetAtkTriggerFrame = function(self, atkId, atkInterval)
  -- function num : 0_79 , upvalues : _ENV
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  local atkTotalFrames = self:GetTotalAtkActionFrames(atkId)
  local triggerFrameCfg = 0
  if atkId == 1 then
    triggerFrameCfg = ((ConfigData.resource_model)[srcId]).atk1_trigger_frames
  else
    if atkId == 2 then
      triggerFrameCfg = ((ConfigData.resource_model)[srcId]).atk2_trigger_frames
    end
  end
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

LuaSkillBase.GetBehindTargetsPos = function(self, count, selectX, selectY, targetX, targetY)
  -- function num : 0_80 , upvalues : _ENV
  local coordSX, coordSY = self:__ChessBoardToCoord(selectX, selectY)
  local coordTX, coordTY = self:__ChessBoardToCoord(targetX, targetY)
  local disX = coordTX - coordSX
  local disY = coordTY - coordSY
  local targets = {}
  for i = 1, count do
    local curChkBoardX, curChkBoardY = self:__CoordToChessBoard(disX * i + coordSX, disY * i + coordSY)
    local role = (LuaSkillCtrl.battleCtrl):GetBattleRole(curChkBoardX, curChkBoardY)
    if role ~= nil and not role.isDead then
      targets[i] = role
    end
  end
  return targets
end

LuaSkillBase.__ChessBoardToCoord = function(self, x, y)
  -- function num : 0_81
  return x * 2 + y % 2, y
end

LuaSkillBase.__CoordToChessBoard = function(self, x, y)
  -- function num : 0_82
  return (x - y % 2) // 2, y
end

LuaSkillBase.CallHalo = function(self, haloBuffId, caster, target, radius, influenceType, onColiEnter, onColiStay, onColiExit, bindRole)
  -- function num : 0_83 , upvalues : _ENV
  local collisionEnter = BindCallback(self, self.__Halo_OnCollisionEnter, onColiEnter, haloBuffId)
  local collisionExit = BindCallback(self, self.__Halo_OnCollisionExit, onColiExit, haloBuffId)
  local emission = LuaSkillCtrl:CallCircledEmissionStraightly(self, caster, target, radius, 0, influenceType, collisionEnter, onColiStay, collisionExit, nil, false, false, nil, bindRole)
  if not self._haloEmissionList then
    self._haloEmissionList = {}
    ;
    (table.insert)(self._haloEmissionList, emission)
    return emission
  end
end

LuaSkillBase.__Halo_OnCollisionEnter = function(self, onColiEnter, haloBuffId, collider, index, entity)
  -- function num : 0_84 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, entity, haloBuffId, 1, nil, true)
  if onColiEnter ~= nil then
    onColiEnter(collider, index, entity)
  end
end

LuaSkillBase.__Halo_OnCollisionExit = function(self, onColiExit, haloBuffId, collider, entity)
  -- function num : 0_85 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(entity, haloBuffId, 0, true)
  if onColiExit ~= nil then
    onColiExit(collider, entity)
  end
end

LuaSkillBase.RemoveAllHaleEmission = function(self)
  -- function num : 0_86 , upvalues : _ENV
  if self._haloEmissionList == nil then
    return 
  end
  for k,emission in ipairs(self._haloEmissionList) do
    emission:EndAndDisposeEmission()
  end
  self._haloEmissionList = nil
end

LuaSkillBase.OnSkipUltView = function(self)
  -- function num : 0_87 , upvalues : _ENV
  self:RemoveSkillTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut)
end

LuaSkillBase.GetHurtResultConfig = function(self, configId)
  -- function num : 0_88 , upvalues : _ENV
  if self.hurtResultConfig == nil then
    self.hurtResultConfig = {}
  end
  do
    if (self.hurtResultConfig)[configId] == nil then
      local config = (ConfigData.battle_skill_hurt_result_config)[configId]
      if config == nil then
        warn("找不到对应的技能伤害配置:" .. tostring(configId))
        config = generalHurtConfig
      end
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.hurtResultConfig)[configId] = self:__GetTempHurtConfig(config)
    end
    return (self.hurtResultConfig)[configId]
  end
end

LuaSkillBase.GetHealResultConfig = function(self, configId)
  -- function num : 0_89 , upvalues : _ENV
  if self.healResultConfig == nil then
    self.healResultConfig = {}
  end
  do
    if (self.healResultConfig)[configId] == nil then
      local config = (ConfigData.battle_skill_heal_result_config)[configId]
      if config == nil then
        warn("找不到对应的技能治疗配置:" .. tostring(configId))
        config = generalHealConfig
      end
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.healResultConfig)[configId] = self:__GetTempHealConfig(config)
    end
    return (self.healResultConfig)[configId]
  end
end

LuaSkillBase.__GetTempHealConfig = function(self, config)
  -- function num : 0_90 , upvalues : _ENV
  local tempConfig = {}
  for _,v in ipairs((ConfigData.battle_skill_heal_result_config).formulaTypes) do
    tempConfig[v] = config[v]
  end
  return tempConfig
end

LuaSkillBase.__GetTempHurtConfig = function(self, config)
  -- function num : 0_91 , upvalues : _ENV
  local tempConfig = {}
  for _,v in ipairs((ConfigData.battle_skill_hurt_result_config).formulaTypes) do
    tempConfig[v] = config[v]
  end
  return tempConfig
end

LuaSkillBase.LuaDispose = function(self)
  -- function num : 0_92 , upvalues : _ENV
  if self.ultCv ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.ultCv)
    self.ultCv = nil
  end
  self:RemoveAllBreakKillEffects()
  self:RemoveAllTimers()
  self.cskill = nil
  self.caster = nil
  self.moveSelectTarget = nil
  self.actionTrigger = nil
  self.actionAudio = nil
  self.startAudio = nil
  self.hurtResultConfig = nil
  self.healResultConfig = nil
end

return LuaSkillBase

