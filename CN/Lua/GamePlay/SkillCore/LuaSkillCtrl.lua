-- params : ...
-- function num : 0 , upvalues : _ENV
local LuaSkillCtrl = class("LuaSkillCtrl")
local SkillLogicTimerCtrl = require("GamePlay.LogicTime.SkillLogicTimerCtrl")
local DynEffectGrid = require("Game.Exploration.Data.DynEffectGrid")
local SortedMessenger = require("Framework.Common.SortedMessenger")
local cs_RangFunc = (CS.RandomUtility).Range
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_TrueSync = CS.TrueSync
LuaSkillCtrl.ctor = function(self)
  -- function num : 0_0 , upvalues : SkillLogicTimerCtrl
  self.logicTimerCtrl = (SkillLogicTimerCtrl.New)()
  self.IsInVerify = false
end

LuaSkillCtrl.InitSkillCtrl = function(self, battleCtrl)
  -- function num : 0_1 , upvalues : SortedMessenger, _ENV
  self.battleCtrl = battleCtrl
  self.cluaSkillCtrl = battleCtrl.LuaSkillController
  self.cUltSkillCtrl = (battleCtrl.PlayerController).UltSkillHandle
  self.luaTrigger = (SortedMessenger.New)()
  self.IsInTDBattle = battleCtrl.IsInTDBattle
  if self.IsInVerify == false then
    self.originalUltHFactor = ((CS.CameraController).Instance).ultHFactor
    self.originalUltVFactor = ((CS.CameraController).Instance).ultVFactor
  end
end

LuaSkillCtrl.GetBattleRoomId = function(self)
  -- function num : 0_2
  return (self.cluaSkillCtrl):GetBattleRoomId()
end

LuaSkillCtrl.AddSkillTrigger = function(self, triggerType, triggerHandle, skillType, name, priority, eventFunc, isSelf, relativeRole)
  -- function num : 0_3
  if triggerHandle == nil then
    return 
  end
  ;
  (self.cluaSkillCtrl):AddTrigger(triggerType, triggerHandle, skillType, name, priority, eventFunc, isSelf, relativeRole)
end

LuaSkillCtrl.AddSkillTriggerWithBindArg = function(self, triggerType, triggerHandle, skillType, name, priority, eventFunc, isSelf, sender, target, senderBelongNum, targetBelongNum, senderRoleType, targetRoleType, verifyId, extraArg1, extraArg2)
  -- function num : 0_4
  if triggerHandle == nil then
    return 
  end
  ;
  (self.cluaSkillCtrl):AddTrigger(triggerType, triggerHandle, skillType, name, priority, eventFunc, isSelf, sender, target, senderBelongNum or -1, targetBelongNum or -1, senderRoleType or 0, targetRoleType or 0, verifyId or 0, extraArg1 or -1, extraArg2 or -1)
end

LuaSkillCtrl.RemoveTrigger = function(self, triggerHandle, eventType)
  -- function num : 0_5
  if triggerHandle == nil then
    return 
  end
  ;
  (self.cluaSkillCtrl):RemoveTrigger(triggerHandle, eventType)
end

LuaSkillCtrl.RemoveHandleAllTrigger = function(self, triggerHandle)
  -- function num : 0_6
  if triggerHandle == nil then
    return 
  end
  ;
  (self.cluaSkillCtrl):RemoveHandleAllTrigger(triggerHandle)
end

LuaSkillCtrl.GetSkillTrigger = function(self, luaSkill, eventType)
  -- function num : 0_7
  if luaSkill.cskill == nil then
    return 
  end
  ;
  (luaSkill.cskill):GetTrigger(eventType)
end

LuaSkillCtrl.GetGridTrigger = function(self, gridSkill, eventType)
  -- function num : 0_8
  (gridSkill.cEffectGrid):GetTrigger(eventType)
end

LuaSkillCtrl.CallAfterSkillPlayTrigger = function(self, luaSkill, role)
  -- function num : 0_9
  (self.cluaSkillCtrl):OnAfterPlaySkill(luaSkill.cskill, role)
end

LuaSkillCtrl.OnUpdateLogic = function(self)
  -- function num : 0_10
  (self.logicTimerCtrl):OnUpdateLogic()
end

LuaSkillCtrl.StartTimer = function(self, luaSkill, delay, func, obj, is_loop, start_time)
  -- function num : 0_11
  local timer = (self.logicTimerCtrl):GetTimer(delay, func, obj, is_loop, start_time, luaSkill)
  if luaSkill ~= nil then
    timer:InjectLuaSkill(luaSkill)
  end
  timer:Start()
  return timer
end

LuaSkillCtrl.GetTimer = function(self, delay, func, obj, is_loop, start_time)
  -- function num : 0_12
  return ((self.logicTimerCtrl):GetTimer(delay, func, obj, is_loop, start_time)):Start()
end

LuaSkillCtrl.CallRange = function(self, min, max)
  -- function num : 0_13 , upvalues : cs_RangFunc
  return cs_RangFunc(min, max)
end

LuaSkillCtrl.CallRoleAction = function(self, role, id, speed)
  -- function num : 0_14
  if id == nil or id <= 0 then
    return 
  end
  if speed ~= nil then
    (self.cluaSkillCtrl):CallRoleAction(role, id, speed)
  else
    ;
    (self.cluaSkillCtrl):CallRoleAction(role, id, 1)
  end
end

LuaSkillCtrl.BreakCurrentAction = function(self, role)
  -- function num : 0_15
  (self.cluaSkillCtrl):BreakCurrentAction(role)
end

LuaSkillCtrl.CallRoleActionWithTrigger = function(self, luaSkill, role, id, speed, triggerTime, onTrigger)
  -- function num : 0_16
  if speed == nil then
    speed = 1
  end
  local timer = nil
  if luaSkill.isDoubleAttack then
    triggerTime = triggerTime // 2
    speed = speed * 2
  end
  if triggerTime > 0 then
    if not luaSkill.isCommonAttack then
      self:StartShowSkillDurationTime(luaSkill, 0)
    end
    self:RecordSkillUncompleted(luaSkill)
    luaSkill:InjectActionTrigger(onTrigger)
    timer = self:StartTimer(luaSkill, triggerTime, luaSkill.TakeActionTrigger, luaSkill)
  else
    onTrigger()
  end
  if id ~= nil and id > 0 then
    (self.cluaSkillCtrl):CallRoleAction(role, id, speed)
  end
  return timer
end

LuaSkillCtrl.GetSkillBindBuffId = function(self, luaSkill)
  -- function num : 0_17
  return (luaSkill.cskill).parentBuffId
end

LuaSkillCtrl.CallBuff = function(self, luaSkill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
  -- function num : 0_18 , upvalues : _ENV
  if buffId == nil or buffId <= 0 then
    return nil
  end
  local towerAbandomBuffIdConfig = (ConfigData.buildinConfig).TowerAbandomBuffId
  if self.IsInTDBattle and towerAbandomBuffIdConfig ~= nil and (table.contain)(towerAbandomBuffIdConfig, buffId) then
    return 
  end
  if role == nil or role.hp <= 0 and role.roleType ~= eBattleRoleType.skillCaster then
    return 
  end
  if luaSkill == nil or luaSkill.cskill == nil then
    if isGameDev then
      error("error to add buff id:" .. tostring(buffId))
    end
    return 
  end
  if isIgnoreTrigger == nil then
    isIgnoreTrigger = false
  end
  local battleBuff = nil
  if duration == nil then
    battleBuff = (self.cluaSkillCtrl):CallBuff(luaSkill.cskill, role, buffId, buffTier, isIgnoreTrigger, overridSender)
  else
    battleBuff = (self.cluaSkillCtrl):CallTimeBuff(luaSkill.cskill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
  end
  local sender = luaSkill.caster
  if overridSender ~= nil then
    sender = overridSender
  end
  self:OnCallBuff(sender, role, buffId, battleBuff ~= nil)
  do return battleBuff end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.CallBuffWithOriginSkill = function(self, cSkill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
  -- function num : 0_19
  if isIgnoreTrigger == nil then
    isIgnoreTrigger = false
  end
  local battleBuff = nil
  if duration == nil then
    battleBuff = (self.cluaSkillCtrl):CallBuff(cSkill, role, buffId, buffTier, isIgnoreTrigger, overridSender)
  else
    battleBuff = (self.cluaSkillCtrl):CallTimeBuff(cSkill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
  end
  local sender = cSkill.caster
  if overridSender ~= nil then
    sender = overridSender
  end
  self:OnCallBuff(sender, role, buffId, battleBuff ~= nil)
  do return battleBuff end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.CallBuffWithOriginSkillAfterReplaceChecked = function(self, cSkill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
  -- function num : 0_20 , upvalues : _ENV
  if (ConfigData.battle_buff_replace)[buffId] ~= nil then
    buffId = ((ConfigData.battle_buff_replace)[buffId]).id
  end
  return self:CallBuffWithOriginSkill(cSkill, role, buffId, buffTier, duration, isIgnoreTrigger, overridSender)
end

LuaSkillCtrl.CallBuffRepeated = function(self, luaSkill, role, buffId, buffTier, duration, isIgnoreTrigger, onRepeated, ...)
  -- function num : 0_21 , upvalues : _ENV
  if role == nil or role.hp <= 0 and role.roleType ~= eBattleRoleType.skillCaster then
    return 
  end
  local repeatedFun = nil
  if onRepeated ~= nil then
    repeatedFun = BindCallback(luaSkill, onRepeated, ...)
  end
  local battleBuff = nil
  if not isIgnoreTrigger then
    battleBuff = (self.cluaSkillCtrl):CallBuffRepeated(luaSkill.cskill, role, buffId, buffTier, repeatedFun, duration ~= nil or false)
    battleBuff = (self.cluaSkillCtrl):CallTimeBuffRepeated(luaSkill.cskill, role, buffId, buffTier, duration, repeatedFun, isIgnoreTrigger or false)
    self:OnCallBuff(luaSkill.caster, role, buffId, battleBuff ~= nil)
    do return battleBuff end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

LuaSkillCtrl.CallBuffLifeEvent = function(self, luaSkill, role, buffId, buffTier, duration, lifeEvent, isIgnoreTrigger)
  -- function num : 0_22 , upvalues : _ENV
  if role == nil or role.hp <= 0 and role.roleType ~= eBattleRoleType.skillCaster then
    return 
  end
  local battleBuff = nil
  if duration == nil then
    battleBuff = (self.cluaSkillCtrl):GenBuff(luaSkill.cskill, role, buffId, buffTier)
  else
    battleBuff = (self.cluaSkillCtrl):GenTimeBuff(luaSkill.cskill, role, buffId, buffTier, duration)
  end
  if battleBuff == nil then
    return nil
  end
  battleBuff:BindBuffLifeEvent(lifeEvent)
  ;
  (self.cluaSkillCtrl):AddBattleBuff(role, battleBuff, isIgnoreTrigger or false)
  return battleBuff
end

LuaSkillCtrl.OnCallBuff = function(self, sender, target, buffId, bResult)
  -- function num : 0_23 , upvalues : _ENV
  self:BroadcastLuaTrigger(eSkillLuaTrigger.OnCallBuff, sender, target, buffId, bResult)
end

LuaSkillCtrl.DispelBuff = function(self, role, buffId, buffTier, isIgnoreTrigger, isIgnoreAudio)
  -- function num : 0_24
  ;
  (self.cluaSkillCtrl):DispelBuff(role, buffId, buffTier, isIgnoreTrigger or false, isIgnoreAudio or false)
end

LuaSkillCtrl.DispelBuffByMaker = function(self, buffMaker, role, buffId, buffTier, isIgnoreTrigger, isIgnoreAudio)
  -- function num : 0_25
  ;
  (self.cluaSkillCtrl):DispelBuffByMaker(buffMaker, role, buffId, buffTier, isIgnoreTrigger or false, isIgnoreAudio or false)
end

LuaSkillCtrl.GetRoleBuffs = function(self, role)
  -- function num : 0_26
  if role == nil or role.hp <= 0 then
    return nil
  end
  return (self.cluaSkillCtrl):GetRoleBuffs(role)
end

LuaSkillCtrl.GetRoleShowBuffsNeedShow = function(self, role)
  -- function num : 0_27
  if role == nil or role.hp <= 0 then
    return nil
  end
  return (self.cluaSkillCtrl):GetRoleShowBuffsNeedShow(role)
end

LuaSkillCtrl.GetRoleBuffById = function(self, role, buffId)
  -- function num : 0_28
  return role:GetRoleBuffById(buffId)
end

LuaSkillCtrl.GetRoleAllBuffsByFeature = function(self, role, buffFeature)
  -- function num : 0_29
  return role:GetAllBuffsByFeature(buffFeature)
end

LuaSkillCtrl.RoleContainsBuffFeature = function(self, role, buffFeature)
  -- function num : 0_30
  return (self.cluaSkillCtrl):RoleContainsBuffFeature(role, buffFeature)
end

LuaSkillCtrl.RoleContainsCtrlBuff = function(self, role)
  -- function num : 0_31 , upvalues : _ENV
  local buffMgr = role:GetBuffComponent()
  if buffMgr == nil then
    return false
  end
  local buffs = buffMgr._buffs
  if buffs == nil or buffs.Count <= 0 then
    return false
  end
  for k,v in pairs(buffs) do
    if (v.buffCfg).IsControl then
      return true
    end
  end
  return false
end

LuaSkillCtrl.CallTargetSelect = function(self, luaSkill, targetSelectId, rangeOffset, overrideSelf, CareerConditionLag)
  -- function num : 0_32 , upvalues : _ENV
  if overrideSelf == nill then
    overrideSelf = luaSkill.caster
  end
  return (self.cluaSkillCtrl):CallTargetSelect(luaSkill.cskill, overrideSelf, targetSelectId, rangeOffset or 0, CareerConditionLag or false)
end

LuaSkillCtrl.CallTargetSelectWithRange = function(self, luaSkill, targetSelectId, range, overrideSelf, CareerConditionLag)
  -- function num : 0_33 , upvalues : _ENV
  if overrideSelf == nill then
    overrideSelf = luaSkill.caster
  end
  return (self.cluaSkillCtrl):CallTargetSelectWithRange(luaSkill.cskill, overrideSelf, targetSelectId, range or 0, CareerConditionLag or false)
end

LuaSkillCtrl.CallTargetSelectWithCskill = function(self, cskill, targetSelectId, rangeOffset, caster)
  -- function num : 0_34
  return (self.cluaSkillCtrl):CallTargetSelect(cskill, caster, targetSelectId, rangeOffset or 0)
end

LuaSkillCtrl.CallRightMaxDirEnemy = function(self, role, ignoreNeutral, ignoreCrtlImmunity)
  -- function num : 0_35
  if ignoreNeutral == nil then
    ignoreNeutral = true
  end
  if ignoreCrtlImmunity == nil then
    ignoreCrtlImmunity = true
  end
  return (self.cluaSkillCtrl):CallRightMaxDirEnemy(role, ignoreNeutral, ignoreCrtlImmunity)
end

LuaSkillCtrl.CallLeftMaxDirEnemy = function(self, role, ignoreNeutral, ignoreCrtlImmunity)
  -- function num : 0_36 , upvalues : _ENV
  if ignoreNeutral == nil then
    ignoreNeutral = true
  end
  if ignoreCrtlImmunity == nil then
    ignoreCrtlImmunity = true
  end
  local tempTargetGridList = {}
  local rowArg = (role.curCoord).y & 1
  local maxXCount = ((self.battleCtrl).battleFieldData).mapSizeXCount - 1
  local coord = (CS.Vector2Point)(maxXCount - rowArg, (role.curCoord).y)
  local ofsCoord = (CS.Vector2Point)(-1, 0)
  for i = 0, maxXCount do
    coord = coord + ofsCoord
    if coord ~= role.curCoord then
      local battleGridData = (self.battleCtrl):TryGetGridData(coord)
      if (battleGridData == nil or battleGridData.role == nil or (battleGridData.role).belong ~= ((CS.BattleUtility).GetInverseBelong)(role.belong, (CS.Belong).enemy) or (ignoreNeutral and (battleGridData.role).belong == (CS.Belong).neutral) or (battleGridData.role):IsUnSelect(role) or (ignoreCrtlImmunity and self:RoleContainsBuffFeature(battleGridData.role, eBuffFeatureType.CtrlImmunity)) or battleGridData ~= (battleGridData.role).lastPreSetGrid) then
        (table.insert)(tempTargetGridList, battleGridData)
      end
    end
  end
  if #tempTargetGridList <= 0 then
    return nil
  end
  ;
  (table.sort)(tempTargetGridList, function(g1, g2)
    -- function num : 0_36_0 , upvalues : _ENV, role
    do return (math.abs)(g2.x - role.x) < (math.abs)(g1.x - role.x) end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local result = (tempTargetGridList[1]).role
  return result
end

LuaSkillCtrl.GetSelectTeamRoles = function(self, belongNum)
  -- function num : 0_37 , upvalues : _ENV
  if belongNum == eBattleRoleBelong.player then
    return ((self.battleCtrl).PlayerTeamController).battleRoleList
  else
    if belongNum == eBattleRoleBelong.enemy then
      return ((self.battleCtrl).EnemyTeamController).battleRoleList
    else
      if belongNum == eBattleRoleBelong.neutral then
        return ((self.battleCtrl).NeutralTeamController).battleRoleList
      end
    end
  end
  return nil
end

LuaSkillCtrl.GetAllFriendRolesRelative = function(self, selfBelongNum)
  -- function num : 0_38 , upvalues : _ENV
  if selfBelongNum == eBattleRoleBelong.player then
    return ((self.battleCtrl).PlayerTeamController).battleRoleList
  else
    if selfBelongNum == eBattleRoleBelong.enemy then
      return ((self.battleCtrl).EnemyTeamController).battleRoleList
    else
      if selfBelongNum == eBattleRoleBelong.neutral then
        return ((self.battleCtrl).NeutralTeamController).battleRoleList
      end
    end
  end
  return nil
end

LuaSkillCtrl.GetAllFriendRoles = function(self)
  -- function num : 0_39 , upvalues : _ENV
  local tempTargetList = {}
  local playerList = ((self.battleCtrl).PlayerTeamController).battleRoleList
  local neturalList = ((self.battleCtrl).NeutralTeamController).battleRoleList
  if playerList ~= nil then
    for i = 0, playerList.Count - 1 do
      (table.insert)(tempTargetList, playerList[i])
    end
  end
  do
    if neturalList ~= nil then
      for i = 0, neturalList.Count - 1 do
        (table.insert)(tempTargetList, neturalList[i])
      end
    end
    do
      return tempTargetList
    end
  end
end

LuaSkillCtrl.GetAllEnmyRoles = function(self)
  -- function num : 0_40 , upvalues : _ENV
  local tempTargetList = {}
  local enmyList = ((self.battleCtrl).EnemyTeamController).battleRoleList
  local neturalList = ((self.battleCtrl).NeutralTeamController).battleRoleList
  if enmyList ~= nil then
    for i = 0, enmyList.Count - 1 do
      (table.insert)(tempTargetList, enmyList[i])
    end
  end
  do
    if neturalList ~= nil then
      for i = 0, neturalList.Count - 1 do
        (table.insert)(tempTargetList, neturalList[i])
      end
    end
    do
      return tempTargetList
    end
  end
end

LuaSkillCtrl.GetAllEnmyRoles = function(self)
  -- function num : 0_41 , upvalues : _ENV
  local tempTargetList = {}
  local enmyList = ((self.battleCtrl).EnemyTeamController).battleRoleList
  local neturalList = ((self.battleCtrl).NeutralTeamController).battleRoleList
  if enmyList ~= nil then
    for i = 0, enmyList.Count - 1 do
      (table.insert)(tempTargetList, enmyList[i])
    end
  end
  do
    if neturalList ~= nil then
      for i = 0, neturalList.Count - 1 do
        (table.insert)(tempTargetList, neturalList[i])
      end
    end
    do
      return tempTargetList
    end
  end
end

LuaSkillCtrl.GetGuardProfession = function(self)
  -- function num : 0_42
  if self.guardProEntity ~= nil then
    return self.guardProEntity
  end
  local pDugeonList = (self.cluaSkillCtrl):CallGetAllPlayerDungeonRoles()
  if pDugeonList ~= nil then
    for i = 0, pDugeonList.Count - 1 do
      if ((pDugeonList[i]).recordTable).IsGuardPro then
        self.guardProEntity = pDugeonList[i]
        return self.guardProEntity
      end
    end
  end
  do
    return nil
  end
end

LuaSkillCtrl.CallEffect = function(self, target, effectId, luaSkill, func, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  -- function num : 0_43 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  if func ~= nil then
    return self:CallEffectInCs(target, luaSkill, effectId, BindCallback(luaSkill, func), overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  else
    return self:CallEffectInCs(target, luaSkill, effectId, nil, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  end
end

LuaSkillCtrl.CallEffectWithEmission = function(self, emission, effectId, luaSkill, func, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  -- function num : 0_44 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  if func ~= nil then
    return self:CallEffectWithEmissionInCs(emission, luaSkill, effectId, BindCallback(luaSkill, func), overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  else
    return self:CallEffectWithEmissionInCs(emission, luaSkill, effectId, nil, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  end
end

LuaSkillCtrl.CallEffectWithArg = function(self, target, effectId, luaSkill, isBreakKill, isIgnoreHideInUlt, func, ...)
  -- function num : 0_45 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  return self:CallEffectInCs(target, luaSkill, effectId, (BindCallback(luaSkill, func, ...)), nil, 1, isBreakKill, isIgnoreHideInUlt)
end

LuaSkillCtrl.CallEffectWithArgAndSpeed = function(self, target, effectId, luaSkill, speed, isBreakKill, isIgnoreHideInUlt, func, ...)
  -- function num : 0_46 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  return self:CallEffectInCs(target, luaSkill, effectId, (BindCallback(luaSkill, func, ...)), nil, speed, isBreakKill, isIgnoreHideInUlt)
end

LuaSkillCtrl.CallEffectWithArgOverride = function(self, target, effectId, luaSkill, overrideSelf, isBreakKill, isIgnoreHideInUlt, func, ...)
  -- function num : 0_47 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  return self:CallEffectInCs(target, luaSkill, effectId, BindCallback(luaSkill, func, ...), overrideSelf, nil, isBreakKill, isIgnoreHideInUlt)
end

LuaSkillCtrl.CallEffectWithArgAndSpeedOverride = function(self, target, effectId, luaSkill, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt, func, ...)
  -- function num : 0_48 , upvalues : _ENV
  if isBreakKill == nil then
    isBreakKill = false
  end
  if isIgnoreHideInUlt == nil then
    isIgnoreHideInUlt = false
  end
  return self:CallEffectInCs(target, luaSkill, effectId, BindCallback(luaSkill, func, ...), overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
end

LuaSkillCtrl.CallEffectInCs = function(self, target, luaSkill, effectId, bindCallBack, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  -- function num : 0_49 , upvalues : _ENV
  if target == nil then
    return nil
  end
  if speed == nil then
    speed = 1
  end
  if luaSkill.cskill == nil then
    return nil
  end
  local effect = (self.cluaSkillCtrl):CallEffect(target, luaSkill.cskill, effectId, bindCallBack, overrideSelf, speed, isIgnoreHideInUlt)
  if luaSkill.effects ~= nil and effect ~= nil and isBreakKill then
    (table.insert)(luaSkill.effects, effect)
  end
  return effect
end

LuaSkillCtrl.CallSelectTargetEffect = function(self, luaSkill, targetRole)
  -- function num : 0_50
  return (self.cluaSkillCtrl):CallSelectTargetEffect((luaSkill.cskill).maker, targetRole)
end

LuaSkillCtrl.CallEffectDoScale = function(self, effect, scaleValue, duration)
  -- function num : 0_51 , upvalues : _ENV, cs_DoTween
  if self.IsInVerify then
    return 
  end
  if not duration then
    duration = 0
  end
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  if duration == 0 then
    ((effect.lsObejct).transform).localScale = Vector3.one * scaleValue
  else
    ;
    (((cs_DoTween.To)(function()
    -- function num : 0_51_0 , upvalues : effect
    return ((effect.lsObejct).transform).localScale
  end
, function(x)
    -- function num : 0_51_1 , upvalues : effect
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

    ((effect.lsObejct).transform).localScale = x
  end
, Vector3.one * scaleValue, duration)):SetLink((effect.lsObejct).gameObject)):SetAutoKill(true)
  end
end

LuaSkillCtrl.ResizeEffectScale = function(self, effect)
  -- function num : 0_52 , upvalues : _ENV
  if self.IsInVerify then
    return 
  end
  ;
  ((effect.lsObejct).transform):DOKill()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((effect.lsObejct).transform).localScale = Vector3.one
end

LuaSkillCtrl.CallEffectWithEmissionInCs = function(self, emission, luaSkill, effectId, bindCallBack, overrideSelf, speed, isBreakKill, isIgnoreHideInUlt)
  -- function num : 0_53 , upvalues : _ENV
  if emission == nil then
    return nil
  end
  if speed == nil then
    speed = 1
  end
  local effect = (self.cluaSkillCtrl):CallEffectWithEmission(emission, luaSkill.cskill, effectId, bindCallBack, overrideSelf, speed, isIgnoreHideInUlt)
  if isBreakKill then
    (table.insert)(luaSkill.effects, effect)
  end
  return effect
end

LuaSkillCtrl.CallAddCircleColliderForEffect = function(self, effect, radius, influenceType, onCollisionStay, onCollisionEnter, onCollisionExit)
  -- function num : 0_54
  return (self.cluaSkillCtrl):CallAddCircleColliderForEffect(effect, radius, influenceType, onCollisionStay, onCollisionEnter, onCollisionExit)
end

LuaSkillCtrl.SetCircleColliderAndEffectRadius = function(self, circleCollider, radius, effect)
  -- function num : 0_55
  (self.cluaSkillCtrl):SetCircleColliderAndEffectRadius(circleCollider, radius, effect)
end

LuaSkillCtrl.GetTargetWithGrid = function(self, gridX, gridY)
  -- function num : 0_56
  return (self.cluaSkillCtrl):GetTargetWithGrid(gridX, gridY)
end

LuaSkillCtrl.GetGridWithRole = function(self, role)
  -- function num : 0_57 , upvalues : _ENV
  if role == nil then
    error("GetGridWithRole::传入的角色为空，请检查")
    return 
  end
  return (self.cluaSkillCtrl):GetGridWithRole(role)
end

LuaSkillCtrl.GetGridWithPos = function(self, x, y)
  -- function num : 0_58
  return (self.cluaSkillCtrl):GetGridWithPos(x, y)
end

LuaSkillCtrl.GetRoleWithPos = function(self, x, y)
  -- function num : 0_59
  return (self.cluaSkillCtrl):GetRoleWithPos(x, y)
end

LuaSkillCtrl.ClearColliderOrEmission = function(self, collider)
  -- function num : 0_60
  (self.cluaSkillCtrl):ClearColliderOrEmission(collider)
end

LuaSkillCtrl.CallRealDamage = function(self, luaSkill, target, effect, config, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_61 , upvalues : _ENV
  local skillResult = nil
  if effect ~= nil then
    skillResult = self:CallSkillResult(effect, target)
  else
    skillResult = self:CallSkillResultNoEffect(luaSkill, target)
  end
  if skillResult == nil then
    return 
  end
  if config == nil then
    config = realDamageConfig
  end
  if config ~= realDamageConfig then
    setmetatable(config, metaRealDamageConfig)
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  skillResult:HurtResult(config, configArg, isIgnoreTrigger or false)
  skillResult:EndResult()
end

LuaSkillCtrl.CallRepeatedHurtWithFormula = function(self, isEndOnRoleDie, luaSkill, targetRole, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield, duration, hurtInterval, formulaId, ...)
  -- function num : 0_62 , upvalues : _ENV
  local hurt = self:CallFormulaNumber(formulaId, luaSkill.caster, targetRole, ...)
  if hurt <= 0 then
    return nil
  end
  local skillId = (luaSkill.cskill).dataId
  local skillTag = (luaSkill.cskill).skillTag
  local skillRange = (luaSkill.cskill).SkillRange
  local bindObj = isEndOnRoleDie and luaSkill or nil
  local times = duration
  if duration > -1 then
    times = duration // hurtInterval - 1
  end
  local timer = self:StartTimer(bindObj, hurtInterval, BindCallback(self, function()
    -- function num : 0_62_0 , upvalues : self, hurt, luaSkill, skillId, skillTag, skillRange, targetRole, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield
    self:RemoveLifePure(hurt, luaSkill, skillId, skillTag, skillRange, targetRole, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield)
  end
), self, times, hurtInterval)
  return timer
end

LuaSkillCtrl.RemoveLife = function(self, hurt, luaSkill, target, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield)
  -- function num : 0_63
  if isShowText == nil then
    isShowText = true
  end
  if hurtType == nil then
    hurtType = ((luaSkill.cskill).skillCfg).HurtType
  end
  return (self.battleCtrl):SetRoleHurt(hurt, luaSkill.cskill, hurtType, luaSkill.caster, target, false, false, isTriggerSet or false, buff, isShowText, isIgnoreTrigger or false, -1, ignoreShield or false)
end

LuaSkillCtrl.RemoveLifePure = function(self, hurt, luaSkill, skillDataId, skillTag, skillRange, target, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield)
  -- function num : 0_64
  if isShowText == nil then
    isShowText = true
  end
  if hurtType == nil and luaSkill.cskill ~= nil then
    hurtType = ((luaSkill.cskill).skillCfg).HurtType
  end
  return (self.battleCtrl):SetRoleHurtPure(hurt, luaSkill.cskill, skillTag, skillRange, skillDataId, hurtType, luaSkill.caster, target, false, false, isTriggerSet or false, buff, isShowText, isIgnoreTrigger or false, -1, ignoreShield or false)
end

LuaSkillCtrl.RemoveLifeWithCSkill = function(self, hurt, cskill, target, isTriggerSet, buff, isShowText, isIgnoreTrigger, hurtType, ignoreShield)
  -- function num : 0_65
  if isShowText == nil then
    isShowText = true
  end
  if hurtType == nil then
    hurtType = (cskill.skillCfg).HurtType
  end
  return (self.battleCtrl):SetRoleHurt(hurt, cskill, hurtType, cskill.maker, target, false, false, isTriggerSet or false, buff, isShowText, isIgnoreTrigger or false, nil, nil, ignoreShield or false)
end

LuaSkillCtrl.CallHeal = function(self, heal, luaSkill, target, isIgnoreTrigger)
  -- function num : 0_66
  return (self.battleCtrl):SetRoleHeal(heal, luaSkill.cskill, luaSkill.caster, target, false, nil, false, isIgnoreTrigger or false)
end

LuaSkillCtrl.CallHealWithCSkill = function(self, heal, cskill, target, isIgnoreTrigger)
  -- function num : 0_67
  return (self.battleCtrl):SetRoleHeal(heal, cskill, cskill.maker, target, false, nil, false, isIgnoreTrigger or false)
end

LuaSkillCtrl.CallFloatText = function(self, role, floatTextId, damage, skillHurtType)
  -- function num : 0_68 , upvalues : _ENV
  if not skillHurtType then
    skillHurtType = eHurtType.None
  end
  if damage == nil then
    (self.cluaSkillCtrl):CallFloatText(role, floatTextId, skillHurtType)
  else
    ;
    (self.cluaSkillCtrl):CallFloatText(role, floatTextId, skillHurtType, damage)
  end
end

LuaSkillCtrl.AddRoleShield = function(self, role, shieldType, shieldValue, formulaId, isIgnoreTrigger)
  -- function num : 0_69
  role:AddShield(shieldValue, shieldType, formulaId)
end

LuaSkillCtrl.GetShield = function(self, role, shieldType)
  -- function num : 0_70
  return role:GetShield(shieldType)
end

LuaSkillCtrl.GetRoleAllShield = function(self, role)
  -- function num : 0_71 , upvalues : _ENV
  local sum = 0
  for i = 0, eShieldType.MaxShieldCount do
    sum = sum + role:GetShield(i)
  end
  return sum
end

LuaSkillCtrl.ClearShield = function(self, role, shieldType)
  -- function num : 0_72
  role:ClearShield(shieldType)
end

LuaSkillCtrl.ClearAllShield = function(self, role)
  -- function num : 0_73
  role:ClearAllShield()
end

LuaSkillCtrl.CallSkillResult = function(self, effect, target, config)
  -- function num : 0_74 , upvalues : _ENV
  if config ~= nil and config.effect_shape ~= nil and config.effect_shape == eSkillResultShapeType.CellDist then
    config.effect_shape = eSkillResultShapeType.Block
  end
  return (self.cluaSkillCtrl):GetSkillResult(effect, target, config)
end

LuaSkillCtrl.CallSkillResultNoEffect = function(self, luaSkill, target, config)
  -- function num : 0_75 , upvalues : _ENV
  if config ~= nil and config.effect_shape ~= nil and config.effect_shape == eSkillResultShapeType.CellDist then
    config.effect_shape = eSkillResultShapeType.Block
  end
  return (self.cluaSkillCtrl):GetSkillResultNoEffect(luaSkill.cskill, target, config)
end

LuaSkillCtrl.CallSkillResultNoEffectWithCSkill = function(self, cskill, target, config)
  -- function num : 0_76 , upvalues : _ENV
  if config ~= nil and config.effect_shape ~= nil and config.effect_shape == eSkillResultShapeType.CellDist then
    config.effect_shape = eSkillResultShapeType.Block
  end
  return (self.cluaSkillCtrl):GetSkillResultNoEffect(cskill, target, config)
end

LuaSkillCtrl.HurtResult = function(self, luaSkill, skillResult, config, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_77 , upvalues : _ENV
  if isIgnoreTrigger == nil then
    isIgnoreTrigger = false
  end
  if (luaSkill.caster).isRealDmgForAtack and (luaSkill.cskill).isCommonAttack then
    if config == nil then
      config = realDamageConfig
    end
    if config ~= realDamageConfig then
      config = self:ModifyRealDmgConfig(config)
    end
  else
    if config == nil then
      config = generalHurtConfig
    end
    if config ~= generalHurtConfig then
      setmetatable(config, metaGeneralHurtConfig)
    end
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  local isInSpecialTdDungeon = false
  local dungeonId = 0
  if not self.IsInVerify then
    dungeonId = ExplorationManager.dungeonId
  end
  if (ConfigData.buildinConfig).SpecialDungeon ~= nil and dungeonId ~= nil and dungeonId > 0 and (table.contain)((ConfigData.buildinConfig).SpecialDungeon, ExplorationManager.dungeonId) then
    isInSpecialTdDungeon = true
  end
  if self.IsInTDBattle and not isInSpecialTdDungeon then
    local targetRoles = skillResult.roleList
    if targetRoles ~= nil and targetRoles.Count > 0 then
      for i = targetRoles.Count - 1, 0, -1 do
        local tempRole = targetRoles[i]
        if tempRole.roleType == eBattleRoleType.DungeonRole then
          targetRoles:RemoveAt(i)
        end
      end
    end
  end
  do
    skillResult:HurtResult(config, configArg, isIgnoreTrigger)
    config.isTriggerSet = false
    setmetatable(config, nil)
  end
end

LuaSkillCtrl.HurtResultWithConfig = function(self, luaSkill, skillResult, configId, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_78
  if luaSkill == nil or configId == nil then
    return 
  end
  if isIgnoreTrigger == nil then
    isIgnoreTrigger = false
  end
  local config = luaSkill:GetHurtResultConfig(configId)
  if config == nil then
    return 
  end
  if (luaSkill.caster).isRealDmgForAtack and (luaSkill.cskill).isCommonAttack then
    config = self:ModifyRealDmgConfig(config)
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  skillResult:HurtResult(config, configArg, isIgnoreTrigger)
  config.isTriggerSet = false
end

LuaSkillCtrl.HurtResultWithConfigOverrideCSkill = function(self, luaSkill, overrideCSkill, skillResult, configId, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_79
  if luaSkill == nil or configId == nil then
    return 
  end
  if isIgnoreTrigger == nil then
    isIgnoreTrigger = false
  end
  local config = luaSkill:GetHurtResultConfig(configId)
  if config == nil then
    return 
  end
  if (overrideCSkill.maker).isRealDmgForAtack and overrideCSkill.isCommonAttack then
    config = self:ModifyRealDmgConfig(config)
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  skillResult:HurtResult(config, configArg, isIgnoreTrigger)
  config.isTriggerSet = false
end

LuaSkillCtrl.ModifyRealDmgConfig = function(self, config)
  -- function num : 0_80 , upvalues : _ENV
  if ((((config.basehurt_formula or not config.minhurt_formula) and config.correct_formula) or not config.lifesteal_formula) and config.spell_lifesteal_formula) or not config.returndamage_formula then
    local realDmgConfig = {hit_formula = 0, def_formula = 0, basehurt_formula = realDamageConfig.basehurt_formula, minhurt_formula = realDamageConfig.minhurt_formula, crit_formula = 0, crithur_ratio = 0, correct_formula = realDamageConfig.correct_formula, lifesteal_formula = realDamageConfig.lifesteal_formula, spell_lifesteal_formula = realDamageConfig.spell_lifesteal_formula, returndamage_formula = realDamageConfig.returndamage_formula, hurt_type = eHurtType.RealDmg}
    return realDmgConfig
  end
end

LuaSkillCtrl.HealResult = function(self, skillResult, config, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_81 , upvalues : _ENV
  if config == nil then
    config = generalHealConfig
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  if config ~= generalHealConfig then
    setmetatable(config, {__index = generalHealConfig})
  end
  skillResult:HealResult(config, configArg, isIgnoreTrigger or false)
  config.isTriggerSet = false
  setmetatable(config, nil)
end

LuaSkillCtrl.HealResultWithConfig = function(self, luaSkill, skillResult, configId, configArg, isTriggerSet, isIgnoreTrigger)
  -- function num : 0_82
  if luaSkill == nil or configId == nil then
    return 
  end
  local config = luaSkill:GetHealResultConfig(configId)
  if config == nil then
    return 
  end
  if isTriggerSet then
    config.isTriggerSet = true
  end
  skillResult:HealResult(config, configArg, isIgnoreTrigger or false)
  config.isTriggerSet = false
end

LuaSkillCtrl.CallNewSkill = function(self, skillId, skillLevel, skillType, itemId)
  -- function num : 0_83
  return (self.cluaSkillCtrl):CallNewSkill(skillId, skillLevel or 1, skillType or 0, itemId or 0)
end

LuaSkillCtrl.CallFormulaNumber = function(self, formual, role, targetRole, ...)
  -- function num : 0_84 , upvalues : _ENV
  return (self.cluaSkillCtrl):CallFormulaNumber(formual, role, targetRole, (table.unpack)({...}))
end

LuaSkillCtrl.CallFormulaBool = function(self, formual, role, target, ...)
  -- function num : 0_85 , upvalues : _ENV
  return (self.cluaSkillCtrl):CallFormulaBool(formual, role, target, (table.unpack)({...}))
end

LuaSkillCtrl.CallFormulaNumberWithSkill = function(self, formual, role, target, luaSkill, ...)
  -- function num : 0_86 , upvalues : _ENV
  return (self.cluaSkillCtrl):CallFormulaNumberWithSkill(formual, role, target, luaSkill.cskill, (table.unpack)({...}))
end

LuaSkillCtrl.CallFormulaBoolWithSkill = function(self, formual, role, target, luaSkill, ...)
  -- function num : 0_87 , upvalues : _ENV
  return (self.cluaSkillCtrl):CallFormulaBoolWithSkill(formual, role, target, luaSkill.cskill, (table.unpack)({...}))
end

LuaSkillCtrl.CallReFillSkillCd = function(self, cskill)
  -- function num : 0_88
  (self.cluaSkillCtrl):CallReFillSkillCd(cskill)
end

LuaSkillCtrl.CallReFillMainSkillCdForRole = function(self, role)
  -- function num : 0_89
  (self.cluaSkillCtrl):CallReFillMainSkillCdForRole(role)
end

LuaSkillCtrl.CallResetCDForSingleSkill = function(self, battleSkill, offset)
  -- function num : 0_90
  battleSkill:ResetCDTimeOffsetNum(offset)
end

LuaSkillCtrl.CallResetCDRatioForRole = function(self, role, ofsPercent)
  -- function num : 0_91
  (self.cluaSkillCtrl):CallResetCDRatioForRole(role, ofsPercent)
end

LuaSkillCtrl.CallResetCDNumForRole = function(self, role, offset)
  -- function num : 0_92
  (self.cluaSkillCtrl):CallResetCDNumForRole(role, offset)
end

LuaSkillCtrl.CallResetComAtkCDRatioForRole = function(self, role, ratio)
  -- function num : 0_93
  (self.cluaSkillCtrl):CallResetComAtkCDRatioForRole(role, ratio)
end

LuaSkillCtrl.CallResetCDForTeam = function(self, belongNum, ofsPercent)
  -- function num : 0_94
  (self.cluaSkillCtrl):CallResetCDForTeam(belongNum, ofsPercent)
end

LuaSkillCtrl.CallResetCDForTeamSingleSkill = function(self, belongNum, luaSkill, ofsPercent)
  -- function num : 0_95
  (self.cluaSkillCtrl):CallResetCDForTeamSingleSkill(belongNum, (luaSkill.cskill).dataId, ofsPercent)
end

LuaSkillCtrl.CallResetMainSkillCDRatioForTeam = function(self, belongNum, ofsPercent)
  -- function num : 0_96
  (self.cluaSkillCtrl):CallResetMainSkillCDForTeam(belongNum, ofsPercent)
end

LuaSkillCtrl.CallResetMainSkillCDNumForTeam = function(self, belongNum, offset)
  -- function num : 0_97
  (self.cluaSkillCtrl):CallResetMainSkillCDNumForTeam(belongNum, offset)
end

LuaSkillCtrl.SetResetCdByReturnConfigOnce = function(self, luaSkill)
  -- function num : 0_98
  (luaSkill.cskill):SetResetCdByReturnConfigOnce()
end

LuaSkillCtrl.CallBreakAllSkill = function(self, role, resetState)
  -- function num : 0_99
  (self.cluaSkillCtrl):CallBreakAllLuaSkill(role)
  if resetState then
    role:ResetRoleState()
  end
end

LuaSkillCtrl.RecordSkillCompleted = function(self, luaSkill)
  -- function num : 0_100
  luaSkill.isSkillUncompleted = false
end

LuaSkillCtrl.RecordSkillUncompleted = function(self, luaSkill)
  -- function num : 0_101
  luaSkill.isSkillUncompleted = true
end

LuaSkillCtrl.GetRoleCommonAttack = function(self, role)
  -- function num : 0_102
  return role:GetCommonAttack()
end

LuaSkillCtrl.GetRoleComAtkSkillMoveSelectTarget = function(self, role)
  -- function num : 0_103
  local csAtkSkill = role:GetCommonAttack()
  if csAtkSkill == nil then
    return nil
  end
  return csAtkSkill.moveSelectTarget
end

LuaSkillCtrl.IsAbleAttackTarget = function(self, role, target, attack_range, isNeedCheckRemote)
  -- function num : 0_104
  if isNeedCheckRemote == nil then
    isNeedCheckRemote = false
  end
  return (self.cluaSkillCtrl):IsAbleAttackTarget(role, target, attack_range, isNeedCheckRemote)
end

LuaSkillCtrl.IsAbleAttackTargetWithDir = function(self, role, targetRole, atk_range, dir_range, isNeedCheckRemote)
  -- function num : 0_105
  if isNeedCheckRemote == nil then
    isNeedCheckRemote = false
  end
  return (self.cluaSkillCtrl):IsAbleAttackTargetWithDir(role, targetRole, atk_range, dir_range, isNeedCheckRemote)
end

LuaSkillCtrl.IsAbleAttackCheckExcludedDir = function(self, role, targetRole, dir_range, isNeedCheckRemote)
  -- function num : 0_106
  if isNeedCheckRemote == nil then
    isNeedCheckRemote = false
  end
  return (self.cluaSkillCtrl):IsAbleAttackCheckExcludedDir(role, targetRole, dir_range, isNeedCheckRemote)
end

LuaSkillCtrl.IsWorthAttacking = function(self, luaSkill, role)
  -- function num : 0_107 , upvalues : _ENV
  local onFireRole = (luaSkill.caster):TryToGetFocusFiringRole()
  if onFireRole == role then
    return true
  end
  if role:ContainBuffFeature(eBuffFeatureType.Bewitch) then
    if (self.battleCtrl):IsAllMemberBewitched(role.belong) then
      return true
    else
      return false
    end
  end
  return true
end

LuaSkillCtrl.CreateSummoner = function(self, luaSkill, monsterId, coordx, coordy, belongNum)
  -- function num : 0_108
  return (self.cluaSkillCtrl):CreateSummoner(luaSkill.cskill, monsterId, coordx, coordy, belongNum or -1)
end

LuaSkillCtrl.CreateSummonerWithCSkill = function(self, cskill, monsterId, coordx, coordy, belongNum)
  -- function num : 0_109
  return (self.cluaSkillCtrl):CreateSummoner(cskill, monsterId, coordx, coordy, belongNum or -1)
end

local summonerAdapterList = {}
LuaSkillCtrl.CreateSummonerWithChip = function(self, luaSkill, monsterId, coordx, coordy, belongNum)
  -- function num : 0_110 , upvalues : _ENV, summonerAdapterList
  local csDynmonner = (self.cluaSkillCtrl):CreateSummoner(luaSkill.cskill, monsterId, coordx, coordy, belongNum or -1)
  local player = ((self.battleCtrl).PlayerController).playerData
  if player == nil then
    return csDynmonner
  end
  if not self.IsInVerify then
    if self.DynSummonerAdapter == nil then
      self.DynSummonerAdapter = require("Game.Exploration.Data.DynSummonerAdapter")
    end
    ;
    (table.removeall)(summonerAdapterList)
    local dynSummoner = ((self.DynSummonerAdapter).New)()
    dynSummoner:InitSummonerAdapter(csDynmonner.career, csDynmonner.camp, csDynmonner.attackRange)
    ;
    (table.insert)(summonerAdapterList, dynSummoner)
    player:ExecuteAllChip2NewHeroList(summonerAdapterList)
    ;
    (table.removeall)(summonerAdapterList)
    local skillList = dynSummoner:GetItemSkillList()
    for _,skill in pairs(skillList) do
      (csDynmonner.equipSkillIDList):Add(skill)
    end
    for attrId,value in pairs(dynSummoner.baseAttr) do
      if value ~= 0 then
        csDynmonner:SetBaseAttr(attrId, value)
      end
    end
    for attrId,value in pairs(dynSummoner.ratioAttr) do
      if value ~= 0 then
        csDynmonner:SetRatioAttr(attrId, value)
      end
    end
    for attrId,value in pairs(dynSummoner.extraAttr) do
      if value ~= 0 then
        csDynmonner:SetExtraAttr(attrId, value)
      end
    end
  else
    do
      player:AdapterAllChipDynSummoner(csDynmonner)
      return csDynmonner
    end
  end
end

LuaSkillCtrl.AddSummonerRole = function(self, summoner)
  -- function num : 0_111 , upvalues : _ENV
  local summonerEntity = (self.cluaSkillCtrl):AddSummonerRole(summoner)
  if summoner.ableMove and summonerEntity ~= nil then
    self:BroadcastLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, summonerEntity)
  end
  return summonerEntity
end

LuaSkillCtrl.GetSummonerCamp = function(self, summonerEntity)
  -- function num : 0_112
  return ((summonerEntity.summoner).summonerCfg).Camp
end

LuaSkillCtrl.CallFocusTimeLine = function(self, role)
  -- function num : 0_113
  (self.cUltSkillCtrl):PlayFocusTimeLine(role)
end

LuaSkillCtrl.CallBackViewTimeLine = function(self, role, isEndUltEffect)
  -- function num : 0_114
  (self.cUltSkillCtrl):PlayBackViewTimeLine(role, isEndUltEffect)
end

LuaSkillCtrl.CallSpecViewTimeLine = function(self, role)
  -- function num : 0_115
  (self.cUltSkillCtrl):PlaySpecViewTimeLine(role)
end

LuaSkillCtrl.CallEndUltEffect = function(self, role)
  -- function num : 0_116
  (self.cUltSkillCtrl):EndUltEffect(role)
end

LuaSkillCtrl.EndUltEffectAndUnFreeze = function(self)
  -- function num : 0_117
  (self.battleCtrl):SetUltSkillUnFreeze()
end

LuaSkillCtrl.CallPlayUltMovie = function(self)
  -- function num : 0_118
  if self.cUltSkillCtrl ~= nil then
    (self.cUltSkillCtrl):PlayUltMovie()
  end
end

LuaSkillCtrl.ResetUltFactor = function(self)
  -- function num : 0_119 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self.IsInVerify == false then
    ((CS.CameraController).Instance).ultHFactor = self.originalUltHFactor
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((CS.CameraController).Instance).ultVFactor = self.originalUltVFactor
  end
end

LuaSkillCtrl.SetUltHFactor = function(self, hFactor)
  -- function num : 0_120 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if self.IsInVerify == false then
    ((CS.CameraController).Instance).ultHFactor = hFactor
  end
end

LuaSkillCtrl.SetUltVFactor = function(self, vFactor)
  -- function num : 0_121 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if self.IsInVerify == false then
    ((CS.CameraController).Instance).ultVFactor = vFactor
  end
end

LuaSkillCtrl.CallUltSkillScreenEffect = function(self, role)
  -- function num : 0_122
  if self.cUltSkillCtrl ~= nil then
    (self.cUltSkillCtrl):ScreenEffect(role)
  end
end

LuaSkillCtrl.CallBattleCamShake = function(self, level)
  -- function num : 0_123
end

LuaSkillCtrl.CallBattleCamShakeByParam = function(self, level, during, sterngth, vibrato)
  -- function num : 0_124 , upvalues : _ENV
  if level == eCamShakeLevel.Light then
    (self.cluaSkillCtrl):CallBattleVcamShakeLightByParam(during, sterngth, vibrato)
  else
    if level == eCamShakeLevel.Strong then
      (self.cluaSkillCtrl):CallBattleVcamShakeStrongByParam(during, sterngth, vibrato)
    else
      if level == eCamShakeLevel.None then
        (self.cluaSkillCtrl):CallBattleVcamShakeByParam(during, sterngth, vibrato)
      end
    end
  end
end

LuaSkillCtrl.StartTimerInUlt = function(self, luaSkill, delay, func, obj)
  -- function num : 0_125 , upvalues : _ENV
  local onDelayAction = BindCallback(luaSkill, func, obj)
  if self.IsInVerify then
    return 
  end
  ;
  (self.cUltSkillCtrl):StartTimer(delay, onDelayAction)
end

LuaSkillCtrl.GetUltHMp = function(self)
  -- function num : 0_126
  if self.cUltSkillCtrl ~= nil then
    return (self.cUltSkillCtrl):GetCurUltMp()
  end
end

LuaSkillCtrl.CallAddPlayerHmp = function(self, value)
  -- function num : 0_127
  if self.cUltSkillCtrl ~= nil then
    (self.cUltSkillCtrl):AddUltMp(value)
  end
end

LuaSkillCtrl.GetPlayerSkillCostMp = function(self, luaSkill)
  -- function num : 0_128
  return ((luaSkill.cskill).skillCfg).PlayerMpCost
end

LuaSkillCtrl.GetPlayerRoleEntity = function(self)
  -- function num : 0_129
  return ((self.battleCtrl).PlayerController).SkillCasterEntity
end

LuaSkillCtrl.GetPlayerRealAttribute = function(self, attrId)
  -- function num : 0_130 , upvalues : _ENV
  if attrId <= 0 or eHeroAttr.max_property_count < attrId then
    return 0
  end
  local skillCasterEntity = self:GetPlayerRoleEntity()
  if skillCasterEntity == nil then
    return 0
  end
  return skillCasterEntity:GetRealProperty(attrId)
end

LuaSkillCtrl.CallAddPlayerMp = function(self, value)
  -- function num : 0_131
  return (self.cluaSkillCtrl):CallAddPlayerMp(value)
end

LuaSkillCtrl.CallAddPlayerMpWithSkillCost = function(self, luaSkill)
  -- function num : 0_132
  local value = ((luaSkill.cskill).skillCfg).PlayerMpCost
  return self:CallAddPlayerMp(value)
end

LuaSkillCtrl.RegisterRoleHpCostEvent = function(self, luaSkill, realRoleEntity, config, action, isOnce)
  -- function num : 0_133 , upvalues : _ENV
  if action == nil then
    return 
  end
  local cb = BindCallback(luaSkill, action)
  ;
  (self.cluaSkillCtrl):RegisterRoleHpCostEvent(realRoleEntity, config, cb, isOnce)
end

LuaSkillCtrl.CallCircledEmissionStraightly = function(self, luaSkill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, isDir, isArriveKill, onArrive, bindRole)
  -- function num : 0_134 , upvalues : _ENV
  do
    if effect ~= nil and effect.startPoint ~= nil then
      local point = effect.startPoint
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R16 in 'UnsetPending'

      if point.pointType == ((CS.EffectPoint).EffectPointType).Transform then
        (effect.lsObject).localPosition = (caster.lsObject).localPosition
      end
    end
    return (self.cluaSkillCtrl):CallCircledEmissionStraightly(luaSkill.cskill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isArriveKill, onArrive)
  end
end

LuaSkillCtrl.CallCircledEmissionStraightlyWithBornTarget = function(self, luaSkill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, isDir, isArriveKill, onArrive, bindRole, overrideBornTarget)
  -- function num : 0_135 , upvalues : _ENV
  do
    if effect ~= nil and effect.startPoint ~= nil then
      local point = effect.startPoint
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R17 in 'UnsetPending'

      if point.pointType == ((CS.EffectPoint).EffectPointType).Transform then
        (effect.lsObject).localPosition = overrideBornTarget:GetLogicPos()
      end
    end
    return (self.cluaSkillCtrl):CallCircledEmissionStraightly(luaSkill.cskill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isArriveKill, onArrive, overrideBornTarget)
  end
end

LuaSkillCtrl.CallCircledEmissionStraightlyWithThreeExtraChild = function(self, luaSkill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, subAngle, isDir, isArriveKill, onArrive, bindRole)
  -- function num : 0_136 , upvalues : _ENV
  do
    if effect ~= nil and effect.startPoint ~= nil then
      local point = effect.startPoint
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R17 in 'UnsetPending'

      if point.pointType == ((CS.EffectPoint).EffectPointType).Transform then
        (effect.lsObject).localPosition = (caster.lsObject).localPosition
      end
    end
    ;
    (self.cluaSkillCtrl):CallCircledEmissionStraightlyWithThreeExtraChild(luaSkill.cskill, caster, target, radius, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, subAngle, isDir, isArriveKill, onArrive)
  end
end

LuaSkillCtrl.CallSectorEmissionStraightly = function(self, luaSkill, caster, target, radius, arcAngle, arcAngleRange, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, isDir, isArriveKill, onArrive, bindRole)
  -- function num : 0_137 , upvalues : _ENV
  do
    if effect ~= nil and effect.startPoint ~= nil then
      local point = effect.startPoint
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R18 in 'UnsetPending'

      if point.pointType == ((CS.EffectPoint).EffectPointType).Transform then
        (effect.lsObject).localPosition = (caster.lsObject).localPosition
      end
    end
    return (self.cluaSkillCtrl):CallSectorEmissionStraightly(luaSkill.cskill, caster, target, radius, arcAngle, arcAngleRange, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isArriveKill, onArrive)
  end
end

LuaSkillCtrl.CallSectorEmissionStraightlyWithDir = function(self, luaSkill, caster, target, radius, arcAngleRange, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, isDir, isArriveKill, onArrive, bindRole)
  -- function num : 0_138 , upvalues : _ENV
  do
    if effect ~= nil and effect.startPoint ~= nil then
      local point = effect.startPoint
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R17 in 'UnsetPending'

      if point.pointType == ((CS.EffectPoint).EffectPointType).Transform then
        (effect.lsObject).localPosition = (caster.lsObject).localPosition
      end
    end
    return (self.cluaSkillCtrl):CallSectorEmissionStraightlyWithDir(luaSkill.cskill, caster, target, radius, arcAngleRange, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isArriveKill, onArrive)
  end
end

LuaSkillCtrl.CallRectEmissionStraightly = function(self, luaSkill, caster, halfWidth, halfHeight, dirTarget, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isAriveKill, onArrive, overrideBornTarget, isFixedFromBornTarget)
  -- function num : 0_139
  return (self.cluaSkillCtrl):CallRectEmissionStraightly(luaSkill.cskill, caster, halfWidth, halfHeight, dirTarget, spdPerFrame, influenceType, onColiEnter, onColiStay, onColiExit, effect, bindRole, isDir, isAriveKill, onArrive, overrideBornTarget, isFixedFromBornTarget)
end

LuaSkillCtrl.CallRestartEmit = function(self, luaSkill, skillEmission, speed, target, isToBorder, isArriveKill, onArrive)
  -- function num : 0_140
  if isToBorder then
    return skillEmission:ReStartEmitToBorder(self.battleCtrl, speed, skillEmission.skill, target, isArriveKill, onArrive)
  else
    return skillEmission:ReStartEmit(speed, luaSkill.skill, target, isArriveKill, onArrive)
  end
end

LuaSkillCtrl.CallGetCircleSkillCollider = function(self, luaSkill, radius, influenceType, onEnter, onStay, onExit)
  -- function num : 0_141
  return (self.cluaSkillCtrl):CallGetCircleSkillCollider(luaSkill.caster, radius, influenceType, onEnter, onStay, onExit)
end

LuaSkillCtrl.CallGetCircleSkillColliderByGrid = function(self, luaSkill, grid, radius, influenceType, onEnter, onStay, onExit)
  -- function num : 0_142
  return (self.cluaSkillCtrl):CallGetCircleSkillCollider(luaSkill.caster, grid, radius, influenceType, false, onEnter, onStay, onExit)
end

LuaSkillCtrl.CallGetSectorSkillCollider = function(self, luaSkill, startGrid, radius, arcAngleRange, endTarget, influenceType, isManulMode, onEnter, onStay, onExit)
  -- function num : 0_143
  return (self.cluaSkillCtrl):CallGetSectorSkillCollider(luaSkill.caster, startGrid, radius, arcAngleRange, endTarget, influenceType, isManulMode, onEnter, onStay, onExit)
end

LuaSkillCtrl.CallGetRectSkillCollider = function(self, luaSkill, startTarget, halfWidth, halfHeight, dstTarget, influenceType, onEnter, onStay, onExit)
  -- function num : 0_144
  return (self.cluaSkillCtrl):CallGetRectSkillCollider(luaSkill.caster, startTarget, halfWidth, halfHeight, dstTarget, influenceType, onEnter, onStay, onExit)
end

LuaSkillCtrl.GetOnCollisionRole = function(self, collider)
  -- function num : 0_145
  return (self.cluaSkillCtrl):GetOnCollisionRole(collider)
end

LuaSkillCtrl.CallGetRoleCurDir = function(self, role)
  -- function num : 0_146
  return role:GetRoleForwardAngle()
end

LuaSkillCtrl.CallStartLocalScale = function(self, role, scale, duration)
  -- function num : 0_147
  if (role.lsObject).gameObject ~= nil then
    (role.lsObject):StartLocalScale(scale, duration)
  end
end

LuaSkillCtrl.CallAddRoleProperty = function(self, role, attrName, value, attrType)
  -- function num : 0_148
  role:AddRoleProperty(attrName, value, attrType)
end

LuaSkillCtrl.FindEmptyGrid = function(self, ruleFunc)
  -- function num : 0_149
  return (self.cluaSkillCtrl):CallFindEmptyGrid(ruleFunc)
end

LuaSkillCtrl.FindEmptyGridWithinRange = function(self, role, range)
  -- function num : 0_150
  return (self.cluaSkillCtrl):CallFindEmptyGridWithinRange(role, range)
end

LuaSkillCtrl.FindEmptyGridsWithinRange = function(self, x, y, range, isFurthest)
  -- function num : 0_151
  return (self.cluaSkillCtrl):CallFindEmptyGridsWithinRange(x, y, range, isFurthest)
end

LuaSkillCtrl.FindAllRolesWithinRange = function(self, target, range, isIncludeSelf)
  -- function num : 0_152
  return (self.cluaSkillCtrl):FindAllRolesWithinRange(target, range, isIncludeSelf)
end

LuaSkillCtrl.FindAllGridsWithinRange = function(self, target, range, isIncludeSelf)
  -- function num : 0_153
  return (self.cluaSkillCtrl):FindAllGridsWithinRange(target, range, isIncludeSelf)
end

LuaSkillCtrl.FindEmptyGridAroundRole = function(self, role)
  -- function num : 0_154
  return (self.cluaSkillCtrl):CallFindEmptyGridAroundRole(role)
end

LuaSkillCtrl.FindEmptyGridWithoutEfcGridAroundRole = function(self, role)
  -- function num : 0_155
  return (self.cluaSkillCtrl):CallFindEmptyGridWithoutEfcGridAroundRole(role)
end

LuaSkillCtrl.FindEmptyGridWithoutEfcGridOfTypeAroundRole = function(self, role, abandonGridType)
  -- function num : 0_156
  return (self.cluaSkillCtrl):CallFindEmptyGridWithoutEfcGridAroundRole(role, abandonGridType)
end

LuaSkillCtrl.FindEmptyGridWithoutEfcGridAroundGrid = function(self, x, y)
  -- function num : 0_157
  return (self.cluaSkillCtrl):CallFindEmptyGridWithoutEfcGridAroundGrid(x, y)
end

LuaSkillCtrl.FindGridsWithoutEfcGridAroundGrid = function(self, x, y)
  -- function num : 0_158
  return (self.cluaSkillCtrl):CallFindGridsWithoutEfcGridAroundGrid(x, y)
end

LuaSkillCtrl.FindRoleRightEmptyGrid = function(self, role, range)
  -- function num : 0_159
  return (self.cluaSkillCtrl):CallFindRoleRightEmptyGrid(role, range or 1)
end

LuaSkillCtrl.FindRoleLeftEmptyGrid = function(self, role, range)
  -- function num : 0_160 , upvalues : _ENV
  local coord = role.curCoord
  local ofsCoord = (CS.Vector2Point)(-1, 0)
  for i = 0, range - 1 do
    coord = coord + ofsCoord
    if coord.x < 0 then
      return nil
    end
    local battleGridData = (self.battleCtrl):TryGetGridData(coord)
    if battleGridData ~= nil and battleGridData:IsGridEmpty() then
      return battleGridData
    end
  end
  return nil
end

LuaSkillCtrl.FindRolesAroundRole = function(self, role)
  -- function num : 0_161
  return (self.cluaSkillCtrl):FindRolesAroundRole(role)
end

LuaSkillCtrl.FindRolesAroundGrid = function(self, grid, belongNum)
  -- function num : 0_162
  return (self.cluaSkillCtrl):FindRolesAroundGrid(grid, belongNum)
end

LuaSkillCtrl.CallFindEmptyGridNearest = function(self, role)
  -- function num : 0_163
  return (self.cluaSkillCtrl):CallFindEmptyGridNearest(role)
end

LuaSkillCtrl.CallFindGridMostRolesArounded = function(self, belongNum)
  -- function num : 0_164
  return (self.cluaSkillCtrl):CallFindGridMostRolesArounded(belongNum, false)
end

LuaSkillCtrl.SetRolePos = function(self, grid, role)
  -- function num : 0_165 , upvalues : _ENV
  if self.IsInTDBattle then
    return 
  end
  ;
  (self.cluaSkillCtrl):SetPosForce(grid, role)
  self:BroadcastLuaTrigger(eSkillLuaTrigger.OnRoleSplash, role, grid)
end

LuaSkillCtrl.PreSetRolePos = function(self, grid, role)
  -- function num : 0_166
  (self.cluaSkillCtrl):PreSetPosForce(grid, role)
end

LuaSkillCtrl.PreSetRolePosWithCoord = function(self, x, y, role)
  -- function num : 0_167
  return (self.cluaSkillCtrl):PreSetPosForceWithCoord(x, y, role)
end

LuaSkillCtrl.CanclePreSetPos = function(self, role)
  -- function num : 0_168
  (self.cluaSkillCtrl):CanclePreSetPos(role)
end

LuaSkillCtrl.MoveRoleToTarget = function(self, luaSkill, grid, role, isOneStep, onfinish)
  -- function num : 0_169 , upvalues : _ENV
  local onFinish = nil
  if onfinish ~= nil then
    onFinish = BindCallback(luaSkill, onfinish, grid, role)
  end
  if self.IsInTDBattle then
    onFinish(role.x, role.y)
    return 
  end
  ;
  (self.cluaSkillCtrl):MoveToTarget(grid, role, isOneStep, onFinish)
end

LuaSkillCtrl.CallPhaseMove = function(self, luaSkill, role, gridX, gridY, moveDuration, notBeSelectBuffId, buffTier)
  -- function num : 0_170 , upvalues : _ENV
  if not notBeSelectBuffId then
    notBeSelectBuffId = 0
  end
  if not buffTier then
    buffTier = 1
  end
  if self.IsInTDBattle and (notBeSelectBuffId > 0 or self:RoleContainsBuffFeature(role, eBuffFeatureType.BeatBack)) then
    self:CallBuff(luaSkill, role, notBeSelectBuffId, buffTier, moveDuration, true)
  end
  do return  end
  ;
  (self.cluaSkillCtrl):CallPhaseMove(luaSkill.cskill, gridX, gridY, role, moveDuration, notBeSelectBuffId, buffTier)
end

LuaSkillCtrl.InInPhaseMove = function(self, role)
  -- function num : 0_171
  if role == nil or role.lsObject == nil then
    return false
  end
  return (role.lsObject).IsStartPhaseMove
end

LuaSkillCtrl.CallPhaseMoveWithoutTurn = function(self, luaSkill, role, gridX, gridY, moveDuration, notBeSelectBuffId, buffTier)
  -- function num : 0_172 , upvalues : _ENV
  if not notBeSelectBuffId then
    notBeSelectBuffId = 0
  end
  if not buffTier then
    buffTier = 1
  end
  -- DECOMPILER ERROR at PC25: Unhandled construct in 'MakeBoolean' P1

  if (self.IsInTDBattle or self:RoleContainsBuffFeature(role, eBuffFeatureType.BeatBack)) and notBeSelectBuffId > 0 then
    self:CallBuff(luaSkill, role, notBeSelectBuffId, buffTier, moveDuration, true)
  end
  do return  end
  ;
  (self.cluaSkillCtrl):CallPhaseMoveWithoutTurn(luaSkill.cskill, gridX, gridY, role, moveDuration, notBeSelectBuffId, buffTier)
end

LuaSkillCtrl.CallPhaseMoveWithoutTurnAndAllowCcd = function(self, luaSkill, role, gridX, gridY, moveDuration, notBeSelectBuffId, buffTier)
  -- function num : 0_173 , upvalues : _ENV
  if not notBeSelectBuffId then
    notBeSelectBuffId = 0
  end
  if not buffTier then
    buffTier = 1
  end
  -- DECOMPILER ERROR at PC25: Unhandled construct in 'MakeBoolean' P1

  if (self.IsInTDBattle or self:RoleContainsBuffFeature(role, eBuffFeatureType.BeatBack)) and notBeSelectBuffId > 0 then
    self:CallBuff(luaSkill, role, notBeSelectBuffId, buffTier, moveDuration, true)
  end
  do return  end
  ;
  (self.cluaSkillCtrl):CallPhaseMoveWithoutTurnAndAllowCcd(luaSkill.cskill, gridX, gridY, role, moveDuration, notBeSelectBuffId, buffTier)
end

LuaSkillCtrl.IsRoleAdjacent = function(self, roleA, roleB)
  -- function num : 0_174
  return (self.cluaSkillCtrl):IsRoleAdjacent(roleA, roleB)
end

LuaSkillCtrl.GetGridsDistance = function(self, x1, y1, x2, y2)
  -- function num : 0_175
  return (self.cluaSkillCtrl):GetGridsDistance(x1, y1, x2, y2)
end

LuaSkillCtrl.GetRoleGridsDistance = function(self, role1, role2)
  -- function num : 0_176
  return (self.cluaSkillCtrl):GetGridsDistance(role1, role2)
end

LuaSkillCtrl.CallFindEmptyGridWithinRangeAndMostClosed = function(self, x, y, range, role)
  -- function num : 0_177
  return (self.cluaSkillCtrl):CallFindEmptyGridClosedToTarget(x, y, role)
end

LuaSkillCtrl.CallFindEmptyGridClosedToTargetInRange = function(self, x, y, role)
  -- function num : 0_178
  return (self.cluaSkillCtrl):CallFindEmptyGridClosedToTargetInRange(x, y, role)
end

LuaSkillCtrl.GetMapBorder = function(self)
  -- function num : 0_179
  return (self.cluaSkillCtrl):GetMapBorder()
end

LuaSkillCtrl.GetMapCenterPos = function(self)
  -- function num : 0_180 , upvalues : _ENV
  local vector2 = (self.cluaSkillCtrl):GetMapBorder()
  local posX = (math.ceil)((vector2.x - 1) * 0.5)
  local posY = (math.ceil)((vector2.y - 1) * 0.5)
  local gridData = (self.battleCtrl):TryGetGridData(posX, posY)
  return gridData
end

LuaSkillCtrl.GetFurthestRightEmptyGrid = function(self, x, y)
  -- function num : 0_181
  return (self.cluaSkillCtrl):GetFurthestRightEmptyGrid(x, y)
end

LuaSkillCtrl.CallFindEmptyGridMostRolesArounded = function(self, belongNum)
  -- function num : 0_182
  return (self.cluaSkillCtrl):CallFindGridMostRolesArounded(belongNum, true)
end

LuaSkillCtrl.CallFindXLineGrid = function(self, grid, range)
  -- function num : 0_183
  return (self.cluaSkillCtrl):CallFindXLineGrid(grid, range)
end

LuaSkillCtrl.CallFindGridsInDirSectorRange = function(self, role, targetRole)
  -- function num : 0_184 , upvalues : _ENV
  if not self:IsRoleAdjacent(role, targetRole) then
    return nil
  end
  local grids = {}
  local arg = role.y & 1
  local neighborGrids = HexagonNeighbor[arg]
  local deltaX = targetRole.x - role.x
  local deltaY = targetRole.y - role.y
  for i = 1, 6 do
    local coordData = neighborGrids[i]
    if coordData.x == deltaX and coordData.y == deltaY then
      local csGrid = self:GetGridWithRole(targetRole)
      ;
      (table.insert)(grids, csGrid)
      local preIndex = i - 1
      if preIndex < 1 then
        preIndex = 6
      end
      coordData = neighborGrids[preIndex]
      csGrid = self:GetGridWithPos(role.x + coordData.x, role.y + coordData.y)
      if csGrid ~= nil then
        (table.insert)(grids, csGrid)
      end
      local nextIndex = i + 1
      if nextIndex > 6 then
        nextIndex = 1
      end
      coordData = neighborGrids[nextIndex]
      csGrid = self:GetGridWithPos(role.x + coordData.x, role.y + coordData.y)
      if csGrid ~= nil then
        (table.insert)(grids, csGrid)
      end
      return grids
    end
  end
  return grids
end

LuaSkillCtrl.FindAllGridsWithUnityRange = function(self, pos, range)
  -- function num : 0_185 , upvalues : _ENV
  local grids = {}
  local borderX = ((self.battleCtrl).battleFieldData).mapSizeXCount - 1
  local borderY = ((self.battleCtrl).battleFieldData).mapSizeYCount - 1
  for y = 0, borderY do
    local arg = y & 1
    local curRow = borderX - arg
    for x = 0, curRow do
      local gridData = (self.battleCtrl):TryGetGridData(x, y)
      local titlePos = gridData.fixLogicPosition
      local titleRadius = 0.5
      local sumRadius = range + titleRadius
      local sqrRadius = sumRadius * sumRadius
      local sqrDistance = (pos.x - titlePos.x) * (pos.x - titlePos.x) + (pos.y - titlePos.z) * (pos.y - titlePos.z)
      if sqrDistance:AsFloat() < sqrRadius then
        (table.insert)(grids, gridData)
      end
    end
  end
  return grids
end

LuaSkillCtrl.GetRandomGrid = function(self)
  -- function num : 0_186
  local mapBoardX = (self:GetMapBorder()).x - 1
  local mapBoardY = (self:GetMapBorder()).y - 1
  local curX = self:CallRange(0, mapBoardX)
  local curY = self:CallRange(0, mapBoardY)
  local tempBool = curY & 1
  if tempBool == 1 and curX == mapBoardX then
    curX = curX - 1
  end
  local gridData = self:GetGridWithPos(curX, curY)
  return gridData
end

LuaSkillCtrl.CallFindFurthestGridInDirRangeWithoutObstacle = function(self, startX, startY, targetX, targetY, range)
  -- function num : 0_187 , upvalues : _ENV
  local dist = self:GetGridsDistance(startX, startY, targetX, targetY)
  if dist > 1 or dist <= 0 then
    return nil
  end
  local deltaX = targetX - startX
  local deltaY = targetY - startY
  local arg = startY & 1
  local dirIndex = self:GetHexagonNeighborIndexForCoord(deltaX, deltaY, arg)
  local mapBoardX = (self:GetMapBorder()).x - 1
  local mapBoardY = (self:GetMapBorder()).y - 1
  local curY = targetY
  local curX = targetX
  if not range then
    range = -1
  end
  local rangeStep = range
  if range == -1 then
    rangeStep = 1
  end
  local grid = self:GetGridWithPos(curX, curY)
  local lastGrid = grid
  while curX <= mapBoardX and curX >= 0 and curY <= mapBoardY and curY >= 0 and rangeStep > 0 do
    lastGrid = grid
    local arg = curY & 1
    local _deltaDta = (HexagonNeighbor[arg])[dirIndex + 1]
    curY = curY + _deltaDta.y
    curX = curX + _deltaDta.x
    grid = self:GetGridWithPos(curX, curY)
    if range > -1 then
      rangeStep = rangeStep - 1
    end
    if grid == nil or grid.role == nil or self:IsObstacle(grid.role) then
      grid = lastGrid
    end
  end
  do
    return grid
  end
end

LuaSkillCtrl.GetHexagonNeighborIndexForCoord = function(self, ofsX, ofsY, colArg)
  -- function num : 0_188 , upvalues : _ENV
  local pos = ofsX + 1 << 16 | ofsY + 1
  return (CoordNeighbor[colArg])[pos]
end

LuaSkillCtrl.CallFindMaxPowOrSkillIntensityRole = function(self)
  -- function num : 0_189
  local role = (self.cluaSkillCtrl):CallFindMaxPowOrSkillIntensityRole()
  if role == nil then
    return nil, nil
  end
  if role.pow < role.skill_intensity then
    return role, role.skill_intensity
  else
    return role, role.pow
  end
end

LuaSkillCtrl.PlaySkillCv = function(self, roleId)
  -- function num : 0_190 , upvalues : _ENV
  if ControllerManager == nil then
    return nil
  end
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  local voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.ultSkill, nil, roleId)
  return cvCtr:PlayCv(roleId, voiceId)
end

LuaSkillCtrl.PlayAuSource = function(self, role, audioId, completeAction)
  -- function num : 0_191
  if role.auSource ~= nil then
    return (role.auSource):PlayAudioById(audioId, completeAction)
  end
end

LuaSkillCtrl.PlayAuHit = function(self, luaSkill, target)
  -- function num : 0_192 , upvalues : _ENV
  if self.IsInVerify or target.auSource == nil or luaSkill.cskill == nil then
    return nil
  end
  local skillId = (luaSkill.cskill).dataId
  local skillCfg = (ConfigData.battle_skill)[skillId]
  if skillCfg == nil then
    error("cant get the skill cfg,id" .. tostring(skillId))
    return nil
  end
  if skillCfg.hit_skill_type <= 0 then
    return nil
  end
  local hitType = nil
  if target.recordTable ~= nil then
    hitType = (target.recordTable)[eHitAuRecordHint]
  end
  if hitType == nil then
    local resId = target.resSrcId
    local resCfg = (ConfigData.resource_model)[resId]
    if resCfg == nil then
      error("cant get the resource_model cfg,id" .. tostring(resId))
      return nil
    end
    hitType = resCfg.hit_target_type
  end
  do
    if hitType == nil or hitType <= 0 then
      return nil
    end
    return AudioManager:PlayHitSelectorAudio(target.auSource, skillCfg.hit_skill_type, hitType)
  end
end

LuaSkillCtrl.SetRoleHitAudioHint = function(self, role, eHitAuRoleType)
  -- function num : 0_193 , upvalues : _ENV
  if role == nil or role.recordTable == nil then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (role.recordTable)[eHitAuRecordHint] = eHitAuRoleType
end

LuaSkillCtrl.StopAudioByBack = function(self, audio)
  -- function num : 0_194 , upvalues : _ENV
  if AudioManager == nil or audio == nil then
    return 
  end
  AudioManager:StopAudioByBack(audio)
end

LuaSkillCtrl.GetEfcGridWithPos = function(self, x, y)
  -- function num : 0_195
  return ((self.battleCtrl).EfcGridController):GetEffectGrid(x, y)
end

LuaSkillCtrl.GetRoleEfcGrid = function(self, role)
  -- function num : 0_196
  return (self.cluaSkillCtrl):GetRoleEfcGrid(role)
end

LuaSkillCtrl.GetNearestEfcGrid = function(self, role, gridId)
  -- function num : 0_197
  return (self.cluaSkillCtrl):GetNearestEfcGrid(role, gridId)
end

LuaSkillCtrl.GetNearestEmptyEfcGrid = function(self, role, gridId)
  -- function num : 0_198
  return (self.cluaSkillCtrl):GetNearestEfcEmptyGrid(role, gridId)
end

LuaSkillCtrl.FindEmptyEfcGrid = function(self)
  -- function num : 0_199
  return (self.cluaSkillCtrl):FindEmptyEfcGrid()
end

LuaSkillCtrl.CallCreateEfcGrid = function(self, x, y, gridId)
  -- function num : 0_200 , upvalues : _ENV, DynEffectGrid
  local coord = ((BattleUtil.XYCoord2Pos)(x, y))
  local effectGrid = nil
  if not self.IsInVerify then
    effectGrid = (DynEffectGrid.New)(coord, gridId)
  else
    effectGrid = (self.cluaSkillCtrl):CreateDynEfcGridDataInVerify(coord, x, y, gridId)
  end
  return ((self.battleCtrl).EfcGridController):AddEffectGridInBattle(effectGrid)
end

LuaSkillCtrl.CallGetTotalEfcGridCount = function(self)
  -- function num : 0_201
  return ((self.battleCtrl).EfcGridController):GetAllActiveGridCount()
end

LuaSkillCtrl.CallGetTotalEfcGrid = function(self)
  -- function num : 0_202
  return ((self.battleCtrl).EfcGridController):GetGridList()
end

LuaSkillCtrl.CallLoseAllGridEffect = function(self)
  -- function num : 0_203
  local grids = ((self.battleCtrl).EfcGridController):GetGridList()
  if grids ~= nil and grids.Count > 0 then
    for i = grids.Count - 1, 0, -1 do
      (grids[i]):GridLoseEffect()
    end
  end
end

LuaSkillCtrl.GetRoleInBattle = function(self, isHero, index)
  -- function num : 0_204
  local role = nil
  if isHero then
    role = (((self.battleCtrl).PlayerTeamController).battleOriginRoleList)[index]
  else
    role = (((self.battleCtrl).EnemyTeamController).battleOriginRoleList)[index]
  end
  if role.isDead then
    role = nil
  end
  return role
end

LuaSkillCtrl.CallDoodad = function(self, sender, targetRole)
  -- function num : 0_205 , upvalues : _ENV
  self:BroadcastLuaTrigger(eSkillLuaTrigger.OnDoodad, sender, targetRole)
end

LuaSkillCtrl.CallChipSuitInvoke = function(self, sender, targetRole)
  -- function num : 0_206 , upvalues : _ENV
  self:BroadcastLuaTrigger(eSkillLuaTrigger.OnChipSuitInvoke, sender, targetRole)
end

LuaSkillCtrl.RegisterLuaTrigger = function(self, luaTriggerId, action)
  -- function num : 0_207
  if self.luaTrigger == nil or action == nil or luaTriggerId == nil then
    return 
  end
  ;
  (self.luaTrigger):AddListener(luaTriggerId, action)
end

LuaSkillCtrl.UnRegisterLuaTrigger = function(self, luaTriggerId, action)
  -- function num : 0_208
  if self.luaTrigger == nil or action == nil or luaTriggerId == nil then
    return 
  end
  ;
  (self.luaTrigger):RemoveListener(luaTriggerId, action)
end

LuaSkillCtrl.UnRegisterLuaTriggerById = function(self, luaTriggerId)
  -- function num : 0_209
  if self.luaTrigger == nil then
    return 
  end
  if luaTriggerId ~= nil then
    (self.luaTrigger):RemoveListenerByType(luaTriggerId)
  end
end

LuaSkillCtrl.RemoveAllLuaTrigger = function(self)
  -- function num : 0_210
  if self.luaTrigger ~= nil then
    (self.luaTrigger):Clear()
    self.luaTrigger = nil
  end
end

LuaSkillCtrl.BroadcastLuaTrigger = function(self, luaTriggerId, ...)
  -- function num : 0_211
  if self.luaTrigger == nil or luaTriggerId == nil then
    return 
  end
  ;
  (self.luaTrigger):Broadcast(luaTriggerId, ...)
end

LuaSkillCtrl.StartShowSkillDurationTime = function(self, luaSkill, time)
  -- function num : 0_212
  if self.IsInVerify then
    return 
  end
  ;
  (self.cluaSkillCtrl):StartShowSkillDurationTime(luaSkill.caster, luaSkill.cskill, time)
end

LuaSkillCtrl.StopShowSkillDurationTime = function(self, luaSkill)
  -- function num : 0_213
  if self.IsInVerify then
    return 
  end
  ;
  (self.cluaSkillCtrl):StopShowSkillDurationTime(luaSkill.caster)
end

LuaSkillCtrl.SetGameScoreAcitve = function(self, typeId, active)
  -- function num : 0_214 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.ChangeBattleScoreActive, typeId, active)
end

LuaSkillCtrl.SetGameScoreValue = function(self, typeId, value)
  -- function num : 0_215 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.ChangeBattleScoreValue, typeId, value)
end

LuaSkillCtrl.SetFinalScoreValue = function(self, id, value)
  -- function num : 0_216
  (self.cluaSkillCtrl):SetFinalGamePlayScore(id, value)
end

LuaSkillCtrl.ForceEndBattle = function(self, isWin)
  -- function num : 0_217
  (self.cluaSkillCtrl):ForceEndBattle(isWin)
end

LuaSkillCtrl.BattlegroundDrop = function(self, Vector2Point, num, fxName)
  -- function num : 0_218
  if self.IsInVerify then
    return 
  end
  ;
  ((self.battleCtrl).PropDropController):RandomDrop(Vector2Point, num, fxName)
end

LuaSkillCtrl.RecordLimitTime = function(self, limitTime)
  -- function num : 0_219
  limitTime = limitTime + (self.battleCtrl).frame
  ;
  (self.cluaSkillCtrl):RecordLimitTime(limitTime)
end

LuaSkillCtrl.IsFixedObstacle = function(self, role)
  -- function num : 0_220 , upvalues : _ENV
  do return role.belongNum == eBattleRoleBelong.neutral and role.career == 1 and role.intensity == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.IsObstacle = function(self, role)
  -- function num : 0_221 , upvalues : _ENV
  do return role.belongNum == eBattleRoleBelong.neutral and role.intensity == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.CallRedisplayInSkillInputCtrl = function(self, role)
  -- function num : 0_222 , upvalues : _ENV
  if role.hp <= 0 or role.unableSelect or role:IsUnselectAbleExceptSameBelong(eBattleRoleBelong.player) then
    return 
  end
  local playerCtrl = (self.battleCtrl).PlayerController
  if playerCtrl == nil then
    return 
  end
  local skillInputCtrl = playerCtrl.battleSkillInputController
  if skillInputCtrl == nil or not skillInputCtrl:IsActive() or skillInputCtrl.selectfirstType ~= ((CS.BattleSkillSelectHandle).SkillSelectType).eSingleAndSelectRole then
    return 
  end
  skillInputCtrl:CancleWaitSelectRoleTiles()
  skillInputCtrl:CancleLastSelectTiles()
  skillInputCtrl:CheckAndSetSelectRolesTiles()
end

LuaSkillCtrl.ShowCounting = function(self, role, count, maxCount)
  -- function num : 0_223
  role:ShowCounting(count, maxCount)
end

LuaSkillCtrl.UpdateCounting = function(self, role, count)
  -- function num : 0_224
  role:UpdateCounting(count)
end

LuaSkillCtrl.HideCounting = function(self, role)
  -- function num : 0_225
  role:HideCounting()
end

LuaSkillCtrl.SetCountingColor = function(self, role, r, g, b, a)
  -- function num : 0_226
  role:SetCountingColor(r, g, b, a)
end

LuaSkillCtrl.CreateTDMonster = function(self, luaDynMonster, luaSkill, followTarget)
  -- function num : 0_227
  return (self.cluaSkillCtrl):CreateTDMonster(luaDynMonster, luaSkill.cskill, followTarget)
end

LuaSkillCtrl.CallSetPlayerTowerMpIncreasedSpeed = function(self, value)
  -- function num : 0_228
  (self.cluaSkillCtrl):CallSetPlayerTowerMpIncreasedSpeed(value)
end

LuaSkillCtrl.GetPlayerTowerMpIncreasedSpeed = function(self)
  -- function num : 0_229
  return (self.cluaSkillCtrl):GetPlayerTowerMpIncreasedSpeed()
end

LuaSkillCtrl.AddPlayerTowerMp = function(self, value)
  -- function num : 0_230
  return (self.cluaSkillCtrl):AddPlayerTowerMp(value)
end

LuaSkillCtrl.GetPlayerTowerMp = function(self)
  -- function num : 0_231
  return (self.cluaSkillCtrl):GetPlayerTowerMp()
end

LuaSkillCtrl.GetAllWaitToCasteMonsters = function(self)
  -- function num : 0_232
  return ((self.battleCtrl).CurBattleMapCfg).waitToCasterMonsterList
end

LuaSkillCtrl.GetAllPlayerDungeonRoles = function(self)
  -- function num : 0_233
  return (self.cluaSkillCtrl):CallGetAllPlayerDungeonRoles()
end

LuaSkillCtrl.GetRoleTag = function(self, role)
  -- function num : 0_234
  return role:GetRoleTag()
end

LuaSkillCtrl.GetTDMosterDieReward = function(self, role)
  -- function num : 0_235
  return role:GetTDRoleDieReward()
end

LuaSkillCtrl.GetTowerCastCost = function(self, role)
  -- function num : 0_236
  return role:GetTDRoleCastCost()
end

LuaSkillCtrl.ResetTowerCastCd = function(self, role, value)
  -- function num : 0_237 , upvalues : _ENV
  local tdCharaComp = role:GetTowerCharaComponent()
  if tdCharaComp == nil then
    warn("不是防御塔！！！")
    return nil
  end
  tdCharaComp.towerCastCd = value
end

LuaSkillCtrl.GetTowerCastCd = function(self, role)
  -- function num : 0_238
  return role:GetTDRoleCastCd()
end

LuaSkillCtrl.LoadOffTowerCharacter = function(self, role, needReturnCost)
  -- function num : 0_239 , upvalues : _ENV
  local tdCharaComp = role:GetTowerCharaComponent()
  if tdCharaComp == nil then
    warn("不是防御塔，不能进行下塔操作")
    return 
  end
  if not tdCharaComp.isOnStage then
    return 
  end
  ;
  (self.cluaSkillCtrl):CallLoadOffTowerInBattle(role)
  tdCharaComp:OnTowerLoadOff()
  tdCharaComp:SetTowerCharacterOnStage(false)
  local cost = needReturnCost and tdCharaComp.towerCastCost or 0
  MsgCenter:Broadcast(eMsgEventId.TDUpdateTowerList, role, false, cost)
  role:RefreshFromLuaData()
end

LuaSkillCtrl.MakeUpSceneData = function(self)
  -- function num : 0_240 , upvalues : _ENV
  if self.hasCheckSceneRoot then
    return 
  end
  self.hasCheckSceneRoot = true
  if self.IsInVerify then
    return 
  end
  if self.battleCtrl == nil then
    self.battleCtrl = ((CS.BattleManager).Instance).CurBattleController
  end
  local borderX = ((self.battleCtrl).battleFieldData).mapSizeXCount - 1
  local borderY = ((self.battleCtrl).battleFieldData).mapSizeYCount - 1
  self.sceneRoot = (((CS.UnityEngine).GameObject).Find)((ConfigData.buildinConfig).DynamicSceneRoot)
  if IsNull(self.sceneRoot) then
    return 
  end
  self.sceneDummyExist = true
  self.sceneDummyDict = {}
  local rowCount = borderX + 1
  for y = 0, borderY do
    local arg = y & 1
    local curRow = borderX - arg
    for x = 0, curRow do
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R14 in 'UnsetPending'

      if (self.sceneDummyDict)[x] == nil then
        (self.sceneDummyDict)[x] = {}
      end
      local index = y * rowCount - y // 2 - arg + borderX - x
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R15 in 'UnsetPending'

      ;
      ((self.sceneDummyDict)[x])[y] = index
    end
  end
end

LuaSkillCtrl.ChangeSceneMap = function(self, x, y)
  -- function num : 0_241 , upvalues : cs_DoTween, _ENV
  if self.IsInVerify then
    return 
  end
  if not self.sceneDummyExist then
    return 
  end
  local tempYs = (self.sceneDummyDict)[x]
  if tempYs == nil then
    return 
  end
  local index = tempYs[y]
  if index == nil then
    return 
  end
  local tempTrans = ((self.sceneRoot).transform):GetChild(index)
  if self.sceneTween ~= nil then
    (self.sceneTween):Kill(true)
    self.sceneTween = nil
  end
  self.sceneTween = (cs_DoTween.To)(function()
    -- function num : 0_241_0 , upvalues : tempTrans
    return tempTrans
  end
, function(x)
    -- function num : 0_241_1 , upvalues : tempTrans
    tempTrans:SetLocalZ(x)
  end
, (ConfigData.buildinConfig).DynamicSceneMapHeight, (ConfigData.buildinConfig).DynamicSceneMapDuration)
end

LuaSkillCtrl.RecoverSceneMap = function(self, x, y)
  -- function num : 0_242
  if self.IsInVerify then
    return 
  end
  if not self.sceneDummyExist then
    return 
  end
  local tempYs = (self.sceneDummyDict)[x]
  if tempYs == nil then
    return 
  end
  local index = tempYs[y]
  if index == nil then
    return 
  end
  local tempTrans = ((self.sceneRoot).transform):GetChild(index)
  tempTrans:SetLocalZ(0)
end

LuaSkillCtrl.ClearSpecialSceneData = function(self)
  -- function num : 0_243
  self.sceneRoot = nil
  self.sceneDummyDict = nil
  self.hasCheckSceneRoot = false
  self.sceneDummyExist = false
  if self.sceneTween ~= nil then
    (self.sceneTween):Kill(true)
    self.sceneTween = nil
  end
end

LuaSkillCtrl.GetEquipmentSummonerOrHostEntity = function(self, role)
  -- function num : 0_244 , upvalues : _ENV
  local key = (ConfigData.buildinConfig).EquipmentSummonerKey
  if role == nil or role.recordTable == nil then
    return nil
  end
  return (role.recordTable)[key]
end

LuaSkillCtrl.CheckReletionWithRoleBelong = function(self, roleA, roleB, reletionArg)
  -- function num : 0_245 , upvalues : _ENV
  local curReletion = (eBelongReletionSetting[roleA.belongNum])[roleB.belongNum]
  do return curReletion & reletionArg > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.GetRelationBelong = function(self, srcBelong, belongNumTag)
  -- function num : 0_246 , upvalues : _ENV
  return (eBelongNumRelation[srcBelong])[belongNumTag]
end

LuaSkillCtrl.GetDynPlayerChipCountAndLevelSum = function(self)
  -- function num : 0_247
  local player = ((self.battleCtrl).PlayerController).playerData
  if player == nil then
    return 0, 0
  end
  if not self.IsInVerify then
    return player:GetChipCountAndLevelSum()
  else
    return player.chipDataCount, player.chipLevelSum
  end
end

LuaSkillCtrl.GetEquipmentSummonerOrHostEntity = function(self, role)
  -- function num : 0_248 , upvalues : _ENV
  local key = (ConfigData.buildinConfig).EquipmentSummonerKey
  if role == nil or role.recordTable == nil then
    return nil
  end
  return (role.recordTable)[key]
end

LuaSkillCtrl.PreCreatSummoner = function(self, luaSkill, monsterId)
  -- function num : 0_249
  return (self.cluaSkillCtrl):PreCreatSummoner(luaSkill.cskill, monsterId)
end

LuaSkillCtrl.GetCasterSkinId = function(self, role)
  -- function num : 0_250 , upvalues : _ENV
  if role == nil then
    return -1
  end
  if self.IsInVerify then
    return (self.cluaSkillCtrl):GetHeroRoleSkinID(role.roleDataId)
  else
    local dynPlayer = (BattleUtil.GetCurDynPlayer)(true)
    if dynPlayer == nil then
      return nil
    end
    return dynPlayer:GetRoleSkinId(role.roleDataId)
  end
end

LuaSkillCtrl.CallTSVec2Angle = function(self, vec2A, vec2B)
  -- function num : 0_251
  local angel = (self.cluaSkillCtrl):CallTSVec2Angle(vec2A, vec2B)
  return angel
end

LuaSkillCtrl.IsOriginalSkill = function(self, luaSkill)
  -- function num : 0_252 , upvalues : _ENV
  if luaSkill == nil or luaSkill.cskill == nil then
    return false
  end
  do return (luaSkill.cskill).skillType == eBattleSkillLogicType.Original end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LuaSkillCtrl.EffectSetCountValue = function(self, effect, value)
  -- function num : 0_253
  if self.IsInVerify or effect == nil then
    return 
  end
  effect:SetCountValue(value)
end

LuaSkillCtrl.EffectSetCountActive = function(self, effect, index, active)
  -- function num : 0_254
  if self.IsInVerify then
    return 
  end
  effect:SetCountActive(index, active)
end

LuaSkillCtrl.EffectSetCountAllActive = function(self, effect, active)
  -- function num : 0_255
  if self.IsInVerify then
    return 
  end
  effect:SetCountAllActive(active)
end

LuaSkillCtrl.SetGameObjectActive = function(self, lsObject, active)
  -- function num : 0_256 , upvalues : _ENV
  if self.IsInVerify then
    return 
  end
  local trans = lsObject.transform
  if trans ~= nil then
    if active then
      trans.localScale = Vector3.one
    else
      trans.localScale = Vector3.zero
    end
  end
end

LuaSkillCtrl.StartAvgWithPauseGame = function(self, chapterName, avgId, completeFunc)
  -- function num : 0_257 , upvalues : _ENV
  if self.IsInVerify then
    return 
  end
  if (string.IsNullOrEmpty)(chapterName) and avgId == nil then
    error("Avg chapterName IsNullOrEmpty:" .. tostring(chapterName) .. " " .. tostring(avgId))
    return 
  end
  if ControllerManager == nil then
    return 
  end
  local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
  battleCtrl:TrySetBattlePause(true)
  ;
  (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(chapterName, avgId, function()
    -- function num : 0_257_0 , upvalues : battleCtrl, _ENV, completeFunc
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R0 in 'UnsetPending'

    if (battleCtrl.fsm):IsCurrentState((CS.eBattleState).End) then
      (Time.unity_time).timeScale = 1
    else
      battleCtrl:TrySetBattlePause(false)
    end
    if completeFunc ~= nil then
      completeFunc()
    end
  end
)
end

LuaSkillCtrl.ChangeRoleBody = function(self, role, resName, moveSpeed, resID)
  -- function num : 0_258
  (self.cluaSkillCtrl):ChangeRoleBody(role, resName, moveSpeed, resID)
end

LuaSkillCtrl.RecoverRoleBody = function(self, role)
  -- function num : 0_259
  (self.cluaSkillCtrl):RecoverRoleBody(role)
end

LuaSkillCtrl.DisactiveCharacter = function(self, role, killer, battleSkill, isNeedBroadcast, deadTime)
  -- function num : 0_260
  if deadTime == nil then
    deadTime = 0
  end
  ;
  (self.cluaSkillCtrl):DisactiveCharacter(role, killer, battleSkill, isNeedBroadcast, deadTime)
end

LuaSkillCtrl.ResurrectionCharacter = function(self, role, Vector2Point, hpPer, skillCD, isNeedCapture)
  -- function num : 0_261
  if isNeedCapture == nil then
    isNeedCapture = false
  end
  ;
  (self.cluaSkillCtrl):ResurrectionCharacter(role, Vector2Point, hpPer, skillCD, isNeedCapture)
end

LuaSkillCtrl.ChangeRoleHeadInfoWorldOffest = function(self, role, worldOffestY)
  -- function num : 0_262
  if not self.IsInVerify then
    (self.cluaSkillCtrl):ChangeRoleHeadInfoWorldOffest(role, worldOffestY)
  end
end

LuaSkillCtrl.CreateMonster = function(self, luaDynMonster, luaSkill, followTarget)
  -- function num : 0_263
  return (self.cluaSkillCtrl):CreateMonster(luaDynMonster, luaSkill.cskill, followTarget)
end

LuaSkillCtrl.GetCacheGold = function(self)
  -- function num : 0_264 , upvalues : _ENV
  if self.IsInVerify then
    return (self.cluaSkillCtrl):GetCacheGoldNumForVertiy()
  else
    if ExplorationManager:IsInExploration() then
      return (ExplorationManager:GetDynPlayer()):GetMoneyCount()
    else
      if BattleDungeonManager:InBattleDungeon() then
        return (BattleDungeonManager:GetDungeonDynPlayer()):GetMoneyCount()
      else
        if WarChessManager:GetIsInWarChess() then
          return WarChessManager:GetWCCoinNum()
        end
      end
    end
  end
  return 0
end

LuaSkillCtrl.SetCacheGold = function(self, goldCount)
  -- function num : 0_265 , upvalues : _ENV
  if not self.IsInVerify then
    if ExplorationManager:IsInExploration() then
      (ExplorationManager:GetDynPlayer()):SetCacheMoneyCount(goldCount)
    else
      if BattleDungeonManager:InBattleDungeon() then
        (BattleDungeonManager:GetDungeonDynPlayer()):SetCacheMoneyCount(goldCount)
      else
        if WarChessManager:GetIsInWarChess() then
          WarChessManager:SetWCCacheCoinNum(goldCount)
        end
      end
    end
  end
  self:SetFinalScoreValue(eScoreType.cacheGoldNum, goldCount)
end

LuaSkillCtrl.AddChipChipConsumeSkill = function(self, skillId, skillLevel)
  -- function num : 0_266 , upvalues : _ENV
  if not self.IsInVerify then
    if self.DynBattleSkill == nil then
      self.DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
    end
    local skillData = ((self.DynBattleSkill).New)(skillId, skillLevel, eBattleSkillLogicType.ChipConsume)
    local dynPlayer = (BattleUtil.GetCurDynPlayer)(true)
    if dynPlayer ~= nil then
      dynPlayer:AddItemSkill(skillData)
    end
  else
    do
      ;
      (self.cluaSkillCtrl):AddChipChipConsumeSkill(skillId, skillLevel)
    end
  end
end

LuaSkillCtrl.OnDelete = function(self)
  -- function num : 0_267 , upvalues : _ENV
  if file ~= nil then
    file:write("战斗结束，持续帧数： " .. tostring((self.battleCtrl).frame) .. "\n\n\n\n\n\n")
    file:close()
  end
  self:RemoveAllLuaTrigger()
  self:ClearSpecialSceneData()
  self.DynSummonerAdapter = nil
  self.IsInTDBattle = false
  self.cUltSkillCtrl = nil
  self.battleCtrl = nil
  self.cluaSkillCtrl = nil
  self.guardProEntity = nil
  ;
  (self.logicTimerCtrl):StopAllTimer()
  self.DynBattleSkill = nil
end

return LuaSkillCtrl

