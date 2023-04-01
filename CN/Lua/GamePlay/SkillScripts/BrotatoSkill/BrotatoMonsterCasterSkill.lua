-- params : ...
-- function num : 0 , upvalues : _ENV
local BrotatoMonsterCasterSkill = class("BrotatoMonsterCasterSkill", LuaSkillBase)
local Stack = require("Framework.Lib.Stack")
local base = LuaSkillBase
BrotatoMonsterCasterSkill.config = {effectId1 = 10263, startAnimId = 1002, buffId_196 = 196, buffId_1033 = 1033, buffId_175 = 175, buffId_88 = 88, skill_time = 18, buffId_1191 = 1191, buffId_513101 = 513101, casterWaveInterval = 375, countDownDuration = 75, latestAtkEffect = 12006, monsterBornInterval = 38, callNextBtnRewardFormula = 10167, campNotBeSelectBuff = 50}
BrotatoMonsterCasterSkill.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "CommonMonsterCasterSkill_start", 0, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "CommonMonsterCasterSkill_roleDie", 1, self.OnRoleDie)
  self.aliveMonsterList = {}
  self.curTakedGridTimers = {}
end

BrotatoMonsterCasterSkill.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_1 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum then
    (table.removebyvalue)(self.aliveMonsterList, role)
  end
  if not self:IsAbleToCallNextWaveByManual() then
    return 
  end
end

BrotatoMonsterCasterSkill.IsAbleToCallNextWave = function(self, nextWave)
  -- function num : 0_2
  if not nextWave then
    nextWave = self.waveRound
  end
  if self.maxWave < nextWave or (self.maxIndexPerWave)[nextWave] == nil or (self.maxIndexPerWave)[nextWave] <= 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

BrotatoMonsterCasterSkill.IsAbleToCallNextWaveByManual = function(self, curWave)
  -- function num : 0_3
  if not curWave then
    curWave = self.waveRound
  end
  if #self.aliveMonsterList > 0 or self.maxWave <= curWave or (self.maxIndexPerWave)[curWave] == nil or (self.maxIndexPerWave)[curWave] > 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

BrotatoMonsterCasterSkill.OnAfterBattleStart = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.battleRoomId = LuaSkillCtrl:GetBattleRoomId()
  self:MakeUpWaitToCasterMonsters()
  self.delayTimerDictPerWave = {}
  self.waveRound = 0
  self.loopCasterTimer = LuaSkillCtrl:StartTimer(nil, (self.config).casterWaveInterval, self.LoopCaster, self, -1, (self.config).casterWaveInterval)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1033, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_88, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_175, 1, nil, true)
end

BrotatoMonsterCasterSkill.SetNextWaveCasterRemainTime = function(self, value, overideInterval)
  -- function num : 0_5
  if value == nil then
    return 
  end
  if self.loopCasterTimer == nil then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.loopCasterTimer).left = value
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  if overideInterval then
    (self.loopCasterTimer).delay = value
  end
end

BrotatoMonsterCasterSkill.MakeUpWaitToCasterMonsters = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local monsterTeamCfg = (ConfigData.brotato_monster_team)[self.battleRoomId]
  local waitTempleMonsters = LuaSkillCtrl:GetAllWaitToCasteMonsters()
  local tempMonsters = {}
  self.waveIntervals = {}
  self.curMonsters = {}
  self.maxIndexPerWave = {}
  self.maxRoleCount = 0
  self.maxWave = 0
  local index = 0
  for i,v in ipairs(monsterTeamCfg) do
    local wave = v.wave_Index
    local intervalPerWave = v.wave_interval
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R12 in 'UnsetPending'

    if (self.curMonsters)[wave] == nil then
      (self.curMonsters)[wave] = {}
    end
    local centerPos = v.create_center_pos
    local bornPos = (BattleUtil.XYCoord2Pos)(centerPos[1], centerPos[2])
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R14 in 'UnsetPending'

    if (self.maxIndexPerWave)[wave] == nil then
      (self.maxIndexPerWave)[wave] = 0
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self.waveIntervals)[wave] = 0
    end
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R14 in 'UnsetPending'

    if (self.waveIntervals)[wave] < intervalPerWave then
      (self.waveIntervals)[wave] = intervalPerWave
    end
    if self.maxWave < wave then
      self.maxWave = wave
    end
    local monsterData = nil
    for i = 0, waitTempleMonsters.Count - 1 do
      if (waitTempleMonsters[i]).dataId == v.monster_id then
        monsterData = waitTempleMonsters[i]
      end
    end
    if monsterData ~= nil then
      for i = 1, v.enemy_num do
        self.maxRoleCount = self.maxRoleCount + 1
        index = index + 1
        -- DECOMPILER ERROR at PC82: Confused about usage of register: R19 in 'UnsetPending'

        if (self.maxIndexPerWave)[wave] < index then
          (self.maxIndexPerWave)[wave] = index
        end
        local roleModel = {role = monsterData, index = index, wave = wave, bornDelay = 1, bornPos = bornPos}
        ;
        (table.insert)((self.curMonsters)[wave], roleModel)
      end
    end
  end
  self.totalRoleCount = self.maxRoleCount
end

BrotatoMonsterCasterSkill.GetWaveRoles = function(self, wave)
  -- function num : 0_7
  local roles = (self.allWaveMonsters)[wave]
  return roles
end

BrotatoMonsterCasterSkill.GetCampRole = function(self)
  -- function num : 0_8
  return self.campRole
end

BrotatoMonsterCasterSkill.ClearLastWaveCaster = function(self)
  -- function num : 0_9
  if self.casteForEachTagTimer ~= nil then
    (self.casteForEachTagTimer):Stop()
    self.casteForEachTagTimer = nil
  end
  self:StopCurWaveDeloyBornTimer(self.waveRound)
  if self.waveRound <= 0 then
    return 
  end
  local curTagWaveMonsters = (self.curMonsters)[self.waveRound]
  if curTagWaveMonsters == nil then
    return 
  end
  self.totalRoleCount = self.totalRoleCount - #curTagWaveMonsters
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = 0
end

BrotatoMonsterCasterSkill.StopCurWaveDeloyBornTimer = function(self, curWave)
  -- function num : 0_10 , upvalues : _ENV
  if self.delayTimerDictPerWave == nil or (self.delayTimerDictPerWave)[curWave] == nil then
    return 
  end
  local curTimers = (self.delayTimerDictPerWave)[curWave]
  for k,v in pairs(curTimers) do
    local timerPerPos = v
    if timerPerPos ~= nil then
      timerPerPos:Stop()
    end
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.delayTimerDictPerWave)[curWave] = nil
end

BrotatoMonsterCasterSkill.StopAllBornTimer = function(self)
  -- function num : 0_11
  for i = 0, self.maxWave do
    self:StopCurWaveDeloyBornTimer(i)
  end
end

BrotatoMonsterCasterSkill.LoopCaster = function(self)
  -- function num : 0_12 , upvalues : _ENV
  self:ClearLastWaveCaster()
  self.waveRound = self.waveRound + 1
  do
    if self:IsAbleToCallNextWave() then
      local nextWaveInterval = (self.waveIntervals)[self.waveRound]
      if nextWaveInterval ~= nil and nextWaveInterval > 0 then
        self:SetNextWaveCasterRemainTime(nextWaveInterval, true)
      end
    end
    local callRealCaster = BindCallback(self, self.CallRealCaster)
    LuaSkillCtrl:StartTimer(self, (self.config).skill_time, callRealCaster)
  end
end

BrotatoMonsterCasterSkill.CallRealCaster = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local noMonsterCasted = false
  local loopCasterCount = (self.maxIndexPerWave)[self.waveRound]
  if loopCasterCount ~= nil and loopCasterCount > 0 and self.totalRoleCount > 0 then
    self.casteForEachTagTimer = LuaSkillCtrl:StartTimer(nil, (self.config).monsterBornInterval, (BindCallback(self, self.CasteMonsterForeach)), nil, -1, (self.config).monsterBornInterval)
  else
    noMonsterCasted = true
  end
  if self.maxWave <= self.waveRound then
    if self.loopCasterTimer ~= nil then
      (self.loopCasterTimer):Stop()
      self.loopCasterTimer = nil
    end
    if noMonsterCasted then
      self:KillSelf()
    end
  end
end

BrotatoMonsterCasterSkill.CasteMonsterForeach = function(self)
  -- function num : 0_14
  local curMaxIndex = (self.maxIndexPerWave)[self.waveRound]
  if curMaxIndex == nil or curMaxIndex <= 0 then
    if self.casteForEachTagTimer ~= nil then
      (self.casteForEachTagTimer):Stop()
      self.casteForEachTagTimer = nil
    end
    self:StopCurWaveDeloyBornTimer(self.waveRound)
    return 
  end
  local tempMonsterBornList = (self.curMonsters)[self.waveRound]
  if tempMonsterBornList == nil then
    return 
  end
  local delayTimers = (self.delayTimerDictPerWave)[self.waveRound]
  if delayTimers == nil then
    delayTimers = {}
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.delayTimerDictPerWave)[self.waveRound] = delayTimers
  end
  self:RealCallBrotatoMonster(tempMonsterBornList, delayTimers, 1)
end

BrotatoMonsterCasterSkill.RealCallBrotatoMonster = function(self, tempMonsterList, delayTimers, index)
  -- function num : 0_15 , upvalues : _ENV
  if tempMonsterList == nil or #tempMonsterList < index then
    return 
  end
  local tempMonsterData = tempMonsterList[index]
  index = index + 1
  local coord = (BattleUtil.XYCoord2Pos)((tempMonsterData.role).x, (tempMonsterData.role).y)
  local delayTime = tempMonsterData.bornDelay
  if delayTime <= 0 then
    self:CreateBrotatoMonster(tempMonsterStack, tempMonsterData)
  else
    local timer = LuaSkillCtrl:StartTimer(nil, delayTime, (BindCallback(self, self.CreateBrotatoMonster, tempMonsterData)), nil)
    ;
    (table.insert)(delayTimers, timer)
  end
  do
    self:RealCallBrotatoMonster(tempMonsterList, delayTimers, index)
  end
end

BrotatoMonsterCasterSkill.CreateBrotatoMonster = function(self, tempMonsterData)
  -- function num : 0_16 , upvalues : _ENV
  local role = LuaSkillCtrl:CreateMonster(tempMonsterData.role, self, nil)
  if role == nil then
    return 
  end
  local bloodNum = (tempMonsterData.role):GetBossBloodNum()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  if bloodNum > 0 then
    (role.recordTable).isTowerBoss = true
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = (self.maxIndexPerWave)[self.waveRound] - 1
  self.totalRoleCount = self.totalRoleCount - 1
  self:OnMonsterCastered(role)
  ;
  (table.insert)(self.aliveMonsterList, role)
end

BrotatoMonsterCasterSkill.KillSelf = function(self)
  -- function num : 0_17 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_88, 0)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, false, nil, true, true)
end

BrotatoMonsterCasterSkill.OnMonsterCastered = function(self, role)
  -- function num : 0_18
  local skillMgrComp = role:GetSkillComponent()
  if skillMgrComp ~= nil then
    skillMgrComp:BroadCastRoleAfterBattleStartTrigger(true)
  end
  if self.totalRoleCount <= 0 then
    self:KillSelf()
  end
end

BrotatoMonsterCasterSkill.OnCasterDie = function(self)
  -- function num : 0_19
end

BrotatoMonsterCasterSkill.LuaDispose = function(self)
  -- function num : 0_20 , upvalues : base
  (base.LuaDispose)(self)
  self.maxIndexPerWave = nil
  self.aliveMonsterList = nil
  self.allCampRoles = nil
  self.curMonsters = nil
  self.waveIntervals = nil
  self.curTakedGridTimers = nil
  self:StopAllBornTimer()
  self.delayTimerDictPerWave = nil
  if self.lastBoomTimer ~= nil then
    (self.lastBoomTimer):Stop()
    self.lastBoomTimer = nil
  end
  if self.loopCasterTimer ~= nil then
    (self.loopCasterTimer):Stop()
    self.loopCasterTimer = nil
  end
  if self.casteForEachTagTimer ~= nil then
    (self.casteForEachTagTimer):Stop()
    self.casteForEachTagTimer = nil
  end
end

return BrotatoMonsterCasterSkill

