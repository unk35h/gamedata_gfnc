-- params : ...
-- function num : 0 , upvalues : _ENV
local GuardMonsterCasterSkill = class("GuardMonsterCasterSkill", LuaSkillBase)
local Stack = require("Framework.Lib.Stack")
local base = LuaSkillBase
GuardMonsterCasterSkill.config = {effectId1 = 10263, buffId_196 = 196, buffId_1033 = 1033, buffId_175 = 175, buffId_88 = 88, skill_time = 18, buffId_513101 = 513101, casterWaveInterval = 375, countDownDuration = 75, latestAtkEffect = 12006, monsterBornInterval = 38, campNotBeSelectBuff = 50, beforeBornEffectTime = 36, bornEffectId = 70000}
GuardMonsterCasterSkill.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "CommonMonsterCasterSkill_start", 0, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "CommonMonsterCasterSkill_roleDie", 1, self.OnRoleDie)
  self:AddLuaTrigger(eSkillLuaTrigger.OnTDTakeGrid, self.OnGridTake)
  self.aliveMonsterList = {}
  self.curTakedGridTimers = {}
end

GuardMonsterCasterSkill.OnGridTake = function(self, x, y, role)
  -- function num : 0_1 , upvalues : _ENV
  local grid = LuaSkillCtrl:GetGridWithPos(x, y)
  if grid == nil then
    return 
  end
  if grid.role ~= nil and grid.role ~= role then
    return 
  end
  local duration = (ConfigData.buildinConfig).CaptureGridDuration
  do
    if (self.curTakedGridTimers)[grid] ~= nil then
      local timer = (self.curTakedGridTimers)[grid]
      grid.role = ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity
      timer.left = duration
      return 
    end
    grid.role = ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.curTakedGridTimers)[grid] = LuaSkillCtrl:StartTimer(nil, duration, function(tempGrid)
    -- function num : 0_1_0 , upvalues : grid, _ENV, self
    if grid.role == ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity then
      grid.role = nil
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.curTakedGridTimers)[grid] = nil
  end
, grid)
  end
end

GuardMonsterCasterSkill.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum then
    (table.removebyvalue)(self.aliveMonsterList, role)
  end
  if not self:IsAbleToCallNextWaveByManual() then
    return 
  end
end

GuardMonsterCasterSkill.IsAbleToCallNextWave = function(self, nextWave)
  -- function num : 0_3
  if not nextWave then
    nextWave = self.waveRound
  end
  if self.maxWave < nextWave or (self.maxIndexPerWave)[nextWave] == nil or (self.maxIndexPerWave)[nextWave] <= 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

GuardMonsterCasterSkill.IsAbleToCallNextWaveByManual = function(self, curWave)
  -- function num : 0_4
  if not curWave then
    curWave = self.waveRound
  end
  if #self.aliveMonsterList > 0 or self.maxWave <= curWave or (self.maxIndexPerWave)[curWave] == nil or (self.maxIndexPerWave)[curWave] > 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

GuardMonsterCasterSkill.OnAfterBattleStart = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.roleTag = LuaSkillCtrl:GetRoleTag(self.caster)
  self:MakeUpCampRole()
  self:MakeUpWaitToCasterMonsters()
  self.delayTimerDictPerWave = {}
  self.waveRound = 0
  self.loopCasterTimer = LuaSkillCtrl:StartTimer(nil, (self.config).casterWaveInterval, self.LoopCaster, self, -1, (self.config).casterWaveInterval)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1033, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_88, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_175, 1, nil, true)
end

GuardMonsterCasterSkill.SetNextWaveCasterRemainTime = function(self, value, overideInterval)
  -- function num : 0_6 , upvalues : _ENV
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
  if (self.config).beforeBornEffectTime < value and overideInterval then
    local tempTime = value - (self.config).beforeBornEffectTime
    if self.loopCallBeforeBornEffectTimer ~= nil then
      (self.loopCallBeforeBornEffectTimer):Stop()
      self.loopCallBeforeBornEffectTimer = nil
    end
    self.loopCallBeforeBornEffectTimer = LuaSkillCtrl:StartTimer(nil, tempTime, self.CreateBeforeBornEffect, self)
  end
end

GuardMonsterCasterSkill.CreateBeforeBornEffect = function(self, skill)
  -- function num : 0_7 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).bornEffectId, self)
end

GuardMonsterCasterSkill.MakeUpWaitToCasterMonsters = function(self)
  -- function num : 0_8 , upvalues : _ENV, Stack
  local monsters = LuaSkillCtrl:GetAllWaitToCasteMonsters()
  local tempMonsters = {}
  self.waveIntervals = {}
  self.curMonsters = {}
  self.maxIndexPerWave = {}
  self.maxRoleCount = 0
  self.maxWave = 0
  self.bornPosList = {}
  for i = 0, monsters.Count - 1 do
    local roleTag = (monsters[i]).roleTag
    if roleTag == self.roleTag then
      self.maxRoleCount = self.maxRoleCount + 1
      local wave, intervalPerWave, eachBornDelay, index = self:GetMonsterBornData((monsters[i]).roleWave)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R12 in 'UnsetPending'

      if (self.curMonsters)[wave] == nil then
        (self.curMonsters)[wave] = {}
      end
      local bornPos = (BattleUtil.XYCoord2Pos)((monsters[i]).x, (monsters[i]).y)
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R13 in 'UnsetPending'

      if ((self.curMonsters)[wave])[bornPos] == nil then
        ((self.curMonsters)[wave])[bornPos] = {}
      end
      if not (table.contain)(self.bornPosList, bornPos) then
        (table.insert)(self.bornPosList, bornPos)
      end
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R13 in 'UnsetPending'

      if (self.maxIndexPerWave)[wave] == nil then
        (self.maxIndexPerWave)[wave] = 0
        -- DECOMPILER ERROR at PC73: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (self.waveIntervals)[wave] = 0
      end
      -- DECOMPILER ERROR at PC79: Confused about usage of register: R13 in 'UnsetPending'

      if (self.maxIndexPerWave)[wave] < index then
        (self.maxIndexPerWave)[wave] = index
      end
      -- DECOMPILER ERROR at PC85: Confused about usage of register: R13 in 'UnsetPending'

      if (self.waveIntervals)[wave] < intervalPerWave then
        (self.waveIntervals)[wave] = intervalPerWave
      end
      if self.maxWave < wave then
        self.maxWave = wave
      end
      local roleModel = {role = monsters[i], index = index, wave = wave, bornDelay = eachBornDelay}
      ;
      (table.insert)(((self.curMonsters)[wave])[bornPos], roleModel)
    end
  end
  self.totalRoleCount = self.maxRoleCount
  for tempWave = 1, self.maxWave do
    local curGroupMonster = (self.curMonsters)[tempWave]
    if curGroupMonster ~= nil then
      for _,tempPos in ipairs(self.bornPosList) do
        if curGroupMonster[tempPos] ~= nil then
          (table.sort)(curGroupMonster[tempPos], function(a, b)
    -- function num : 0_8_0
    do return b.index < a.index end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
          local tempRoles = curGroupMonster[tempPos]
          curGroupMonster[tempPos] = (Stack.New)()
          for _,v in ipairs(tempRoles) do
            (curGroupMonster[tempPos]):Push(v)
          end
        end
      end
    end
  end
end

GuardMonsterCasterSkill.GetMonsterBornData = function(self, rawWave)
  -- function num : 0_9
  local tempWave = rawWave // 10
  local eachBornDelay = 0
  local arg = 1
  local intervalPerWave = 0
  if rawWave > 99 then
    tempWave = rawWave // 10000000
    eachBornDelay = rawWave % 1000
    intervalPerWave = rawWave % 1000000 // 1000
    arg = 1000000
  else
    tempWave = rawWave // 10
  end
  local index = rawWave // arg % 10
  return tempWave, intervalPerWave, eachBornDelay, index
end

GuardMonsterCasterSkill.MakeUpCampRole = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local campRoles = LuaSkillCtrl:GetAllPlayerDungeonRoles()
  self.campRole = nil
  if campRoles.Count > 0 then
    self.campRole = campRoles[0]
  end
end

GuardMonsterCasterSkill.GetWaveRoles = function(self, wave)
  -- function num : 0_11
  local roles = (self.allWaveMonsters)[wave]
  return roles
end

GuardMonsterCasterSkill.GetCampRole = function(self)
  -- function num : 0_12
  return self.campRole
end

GuardMonsterCasterSkill.LoopCaster = function(self)
  -- function num : 0_13 , upvalues : _ENV
  self:ClearLastWaveCaster()
  self.waveRound = self.waveRound + 1
  do
    if self:IsAbleToCallNextWave() then
      local nextWaveInterval = (self.waveIntervals)[self.waveRound]
      if nextWaveInterval ~= nil and nextWaveInterval > 0 then
        self:SetNextWaveCasterRemainTime(nextWaveInterval, true)
      end
    end
    local beforeTime = (self.config).skill_time
    if self.waveRound == 1 then
      beforeTime = 12
    end
    local callRealCaster = BindCallback(self, self.CallRealCaster)
    LuaSkillCtrl:StartTimer(self, beforeTime, callRealCaster)
  end
end

GuardMonsterCasterSkill.ClearLastWaveCaster = function(self)
  -- function num : 0_14 , upvalues : _ENV
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
  for _,tempPos in ipairs(self.bornPosList) do
    if curTagWaveMonsters[tempPos] ~= nil then
      local count = (curTagWaveMonsters[tempPos]):Count()
      if count > 0 then
        (curTagWaveMonsters[tempPos]):Clear()
      end
      self.totalRoleCount = self.totalRoleCount - count
    end
  end
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = 0
end

GuardMonsterCasterSkill.CallRealCaster = function(self)
  -- function num : 0_15 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
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

GuardMonsterCasterSkill.StopCurWaveDeloyBornTimer = function(self, curWave)
  -- function num : 0_16 , upvalues : _ENV
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

GuardMonsterCasterSkill.StopAllBornTimer = function(self)
  -- function num : 0_17
  for i = 0, self.maxWave do
    self:StopCurWaveDeloyBornTimer(i)
  end
end

GuardMonsterCasterSkill.CasteMonsterForeach = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local curMaxIndex = (self.maxIndexPerWave)[self.waveRound]
  if curMaxIndex == nil or curMaxIndex <= 0 then
    if self.casteForEachTagTimer ~= nil then
      (self.casteForEachTagTimer):Stop()
      self.casteForEachTagTimer = nil
    end
    self:StopCurWaveDeloyBornTimer(self.waveRound)
    return 
  end
  local tempMonsterBorntable = (self.curMonsters)[self.waveRound]
  if tempMonsterBorntable == nil then
    return 
  end
  local delayTimers = (self.delayTimerDictPerWave)[self.waveRound]
  if delayTimers == nil then
    delayTimers = {}
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.delayTimerDictPerWave)[self.waveRound] = delayTimers
  end
  for _,tempPos in ipairs(self.bornPosList) do
    local tempMonsterStack = tempMonsterBorntable[tempPos]
    self:RealCallGuardMonster(tempMonsterStack, tempPos, delayTimers)
  end
end

GuardMonsterCasterSkill.RealCallGuardMonster = function(self, tempMonsterStack, tempPos, delayTimers)
  -- function num : 0_19 , upvalues : _ENV
  if tempMonsterStack == nil or tempMonsterStack:Count() <= 0 then
    return 
  end
  local tempMonsterData = tempMonsterStack:Pop()
  local coord = (BattleUtil.XYCoord2Pos)((tempMonsterData.role).x, (tempMonsterData.role).y)
  local delayTime = tempMonsterData.bornDelay
  if delayTime <= 0 then
    self:CreateGuardMonster(tempMonsterStack, tempMonsterData)
  else
    local timer = LuaSkillCtrl:StartTimer(nil, delayTime, (BindCallback(self, self.CreateGuardMonster, tempMonsterStack, tempMonsterData)), nil)
    ;
    (table.insert)(delayTimers, timer)
  end
  do
    self:RealCallGuardMonster(tempMonsterStack, tempPos, delayTimers)
  end
end

GuardMonsterCasterSkill.CreateGuardMonster = function(self, tempMonsterStack, tempMonsterData)
  -- function num : 0_20 , upvalues : _ENV
  local role = LuaSkillCtrl:CreateMonster(tempMonsterData.role, self, nil)
  if role == nil then
    return 
  end
  local bloodNum = (tempMonsterData.role):GetBossBloodNum()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  if bloodNum > 0 then
    (role.recordTable).isTowerBoss = true
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = (self.maxIndexPerWave)[self.waveRound] - 1
  self.totalRoleCount = self.totalRoleCount - 1
  self:OnMonsterCastered(role)
  ;
  (table.insert)(self.aliveMonsterList, role)
end

GuardMonsterCasterSkill.KillSelf = function(self)
  -- function num : 0_21 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_88, 0)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, false, nil, true, true)
end

GuardMonsterCasterSkill.OnMonsterCastered = function(self, role)
  -- function num : 0_22
  local skillMgrComp = role:GetSkillComponent()
  if skillMgrComp ~= nil then
    skillMgrComp:BroadCastRoleAfterBattleStartTrigger(true)
  end
  if self.totalRoleCount <= 0 then
    self:KillSelf()
  end
end

GuardMonsterCasterSkill.OnCasterDie = function(self)
  -- function num : 0_23
end

GuardMonsterCasterSkill.LuaDispose = function(self)
  -- function num : 0_24 , upvalues : base
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
  if self.loopCallBeforeBornEffectTimer ~= nil then
    (self.loopCallBeforeBornEffectTimer):Stop()
    self.loopCallBeforeBornEffectTimer = nil
  end
  if self.casteForEachTagTimer ~= nil then
    (self.casteForEachTagTimer):Stop()
    self.casteForEachTagTimer = nil
  end
end

return GuardMonsterCasterSkill

