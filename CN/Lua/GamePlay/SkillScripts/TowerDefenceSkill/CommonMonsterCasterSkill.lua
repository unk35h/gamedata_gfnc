-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonMonsterCasterSkill = class("CommonMonsterCasterSkill", LuaSkillBase)
local Stack = require("Framework.Lib.Stack")
local base = LuaSkillBase
CommonMonsterCasterSkill.config = {effectId1 = 10263, startAnimId = 1002, buffId_196 = 196, buffId_1033 = 1033, buffId_175 = 175, buffId_286 = 286, buffId_88 = 88, buffId_1224 = 1224, skill_time = 18, buffId_1191 = 1191, buffId_513101 = 513101, abandonMoveBuff = 1196, casterWaveInterval = 375, countDownDuration = 75, BoomEffect = 12005, BoomEffectTime = 12007, BoomEffectTime2 = 12022, latestAtkEffect = 12006, monsterBornInterval = 38, routeMonsterId = 55555, route_monster_buff = 1201, callNextBtnRewardFormula = 10167, campNotBeSelectBuff = 50, commonMonsterAtkPassiveId = 540, hurtPerAtk = 1}
local MonsterBornState = {eWaitBorn = 0, eBornDelaying = 1, eCompleteDelay = 2}
CommonMonsterCasterSkill.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "CommonMonsterCasterSkill_start", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "CommonMonsterCasterSkill_roleDie", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.OnCallNextWaveTowerMonster, "CommonMonsterCasterSkill_nextWave", 1, self.OnNextWave)
  self:AddLuaTrigger(eSkillLuaTrigger.OnTDTakeGrid, self.OnGridTake)
  self.aliveMonsterList = {}
  self.curTakedGridTimers = {}
end

CommonMonsterCasterSkill.OnGridTake = function(self, x, y, role)
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

CommonMonsterCasterSkill.OnNextWave = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not self:IsAbleToCallNextWaveByManual() then
    return 
  end
  local nextReward = self:CalculateNextWaveReward()
  self:SetNextWaveCasterRemainTime(0)
  if nextReward > 0 then
    LuaSkillCtrl:AddPlayerTowerMp(nextReward)
  end
  MsgCenter:Broadcast(eMsgEventId.TDNextClickActive, false)
end

CommonMonsterCasterSkill.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_3 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum then
    self:CheckAndKillCountDownEfc(role)
    ;
    (table.removebyvalue)(self.aliveMonsterList, role)
    if killSkill.dataId ~= (self.config).commonMonsterAtkPassiveId then
      local reward = LuaSkillCtrl:GetTDMosterDieReward(role)
      if reward > 0 then
        LuaSkillCtrl:AddPlayerTowerMp(reward)
        if not LuaSkillCtrl.IsInVerify then
          local trans = (role.lsObject).transform
          local worldPos = nil
          if not IsNull(trans) then
            worldPos = trans.position
          end
          MsgCenter:Broadcast(eMsgEventId.EnemyIsDead, reward, worldPos)
        end
      end
    end
  end
  do
    if not self:IsAbleToCallNextWaveByManual() then
      return 
    end
    local nextReward = self:CalculateNextWaveReward()
    local curFrame = (LuaSkillCtrl.battleCtrl).frame
    MsgCenter:Broadcast(eMsgEventId.TDNextClickActive, true, nextReward, self.__calculateNextReward)
  end
end

CommonMonsterCasterSkill.CalculateNextWaveReward = function(self)
  -- function num : 0_4
  if self.loopCasterTimer == nil then
    return 0
  end
  local leftTime = (self.loopCasterTimer).left
  local nextReward = self.nextWaveRewardArg * leftTime // 1000
  if nextReward > 40 then
    nextReward = 40
  end
  return nextReward
end

CommonMonsterCasterSkill.IsAbleToCallNextWave = function(self, nextWave)
  -- function num : 0_5
  if not nextWave then
    nextWave = self.waveRound
  end
  if self.maxWave < nextWave or (self.maxIndexPerWave)[nextWave] == nil or (self.maxIndexPerWave)[nextWave] <= 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

CommonMonsterCasterSkill.IsAbleToCallNextWaveByManual = function(self, curWave)
  -- function num : 0_6
  if not curWave then
    curWave = self.waveRound
  end
  if #self.aliveMonsterList > 0 or self.maxWave <= curWave or (self.maxIndexPerWave)[curWave] == nil or (self.maxIndexPerWave)[curWave] > 0 or self.totalRoleCount <= 0 then
    return false
  end
  return true
end

CommonMonsterCasterSkill.OnAfterBattleStart = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self.__calculateNextReward = BindCallback(self, self.CalculateNextWaveReward)
  self.nextWaveRewardArg = LuaSkillCtrl:CallFormulaNumber((self.config).callNextBtnRewardFormula, self.caster, self.caster)
  self:SetUpPlayerTowerMp()
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

CommonMonsterCasterSkill.SetNextWaveCasterRemainTime = function(self, value, overideInterval)
  -- function num : 0_8
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

CommonMonsterCasterSkill.SetUpPlayerTowerMp = function(self)
  -- function num : 0_9 , upvalues : _ENV
  LuaSkillCtrl:AddPlayerTowerMp(0)
end

CommonMonsterCasterSkill.MakeUpWaitToCasterMonsters = function(self)
  -- function num : 0_10 , upvalues : _ENV, MonsterBornState, Stack
  local monsters = LuaSkillCtrl:GetAllWaitToCasteMonsters()
  local tempMonsters = {}
  self.waveIntervals = {}
  self.curMonsters = {}
  self.maxIndexPerWave = {}
  self.tagRoute = {}
  self.totalRoleCount = monsters.Count
  self.maxRoleCount = monsters.Count
  self.maxWave = 0
  self.bornPosList = {}
  for i = 0, monsters.Count - 1 do
    local wave, intervalPerWave, eachBornDelay, index = self:GetMonsterBornData((monsters[i]).roleWave)
    local roleTag = (monsters[i]).roleTag
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R12 in 'UnsetPending'

    if (self.tagRoute)[roleTag] == nil then
      (self.tagRoute)[roleTag] = {}
    end
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R12 in 'UnsetPending'

    if (self.curMonsters)[roleTag] == nil then
      (self.curMonsters)[roleTag] = {}
    end
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R12 in 'UnsetPending'

    if ((self.curMonsters)[roleTag])[wave] == nil then
      ((self.curMonsters)[roleTag])[wave] = {}
    end
    local bornPos = (BattleUtil.XYCoord2Pos)((monsters[i]).x, (monsters[i]).y)
    -- DECOMPILER ERROR at PC70: Confused about usage of register: R13 in 'UnsetPending'

    if (((self.curMonsters)[roleTag])[wave])[bornPos] == nil then
      (((self.curMonsters)[roleTag])[wave])[bornPos] = {}
    end
    if not (table.contain)(self.bornPosList, bornPos) then
      (table.insert)(self.bornPosList, bornPos)
    end
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R13 in 'UnsetPending'

    if (self.maxIndexPerWave)[wave] == nil then
      (self.maxIndexPerWave)[wave] = 0
      -- DECOMPILER ERROR at PC90: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (self.waveIntervals)[wave] = 0
    end
    -- DECOMPILER ERROR at PC96: Confused about usage of register: R13 in 'UnsetPending'

    if (self.maxIndexPerWave)[wave] < index then
      (self.maxIndexPerWave)[wave] = index
    end
    -- DECOMPILER ERROR at PC102: Confused about usage of register: R13 in 'UnsetPending'

    if (self.waveIntervals)[wave] < intervalPerWave then
      (self.waveIntervals)[wave] = intervalPerWave
    end
    if self.maxWave < wave then
      self.maxWave = wave
    end
    local roleModel = {role = monsters[i], index = index, wave = wave, bornDelay = eachBornDelay, bornState = MonsterBornState.eWaitBorn}
    ;
    (table.insert)((((self.curMonsters)[roleTag])[wave])[bornPos], roleModel)
  end
  for tempTag = 1, self.maxTag do
    local tagMonsters = (self.curMonsters)[tempTag]
    if tagMonsters ~= nil then
      for tempWave = 1, self.maxWave do
        local curGroupMonster = tagMonsters[tempWave]
        if curGroupMonster ~= nil then
          for _,tempPos in ipairs(self.bornPosList) do
            if curGroupMonster[tempPos] ~= nil then
              (table.sort)(curGroupMonster[tempPos], function(a, b)
    -- function num : 0_10_0
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
  end
  local characterData = (self.caster).character
  if characterData ~= nil then
    self.lastWaveBoomInterval = characterData.roleWave
  end
end

CommonMonsterCasterSkill.GetMonsterBornData = function(self, rawWave)
  -- function num : 0_11
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

CommonMonsterCasterSkill.MakeUpCampRole = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local campRoles = LuaSkillCtrl:GetAllPlayerDungeonRoles()
  self.allCampRoles = {}
  self.maxTag = 0
  for i = 0, campRoles.Count - 1 do
    LuaSkillCtrl:CallBuff(self, campRoles[i], (self.config).campNotBeSelectBuff, 1, nil, true)
    local roleTag = LuaSkillCtrl:GetRoleTag(campRoles[i])
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.allCampRoles)[roleTag] = campRoles[i]
    if self.maxTag < roleTag then
      self.maxTag = roleTag
    end
  end
end

CommonMonsterCasterSkill.GetWaveRoles = function(self, wave)
  -- function num : 0_13
  local roles = (self.allWaveMonsters)[wave]
  return roles
end

CommonMonsterCasterSkill.GetCampRole = function(self, camp)
  -- function num : 0_14
  local role = (self.allCampRoles)[camp]
  return role
end

CommonMonsterCasterSkill.LoopCaster = function(self)
  -- function num : 0_15 , upvalues : _ENV
  self:ClearLastWaveCaster()
  self.waveRound = self.waveRound + 1
  do
    if self:IsAbleToCallNextWave() then
      local nextWaveInterval = (self.waveIntervals)[self.waveRound]
      if nextWaveInterval ~= nil and nextWaveInterval > 0 then
        self:SetNextWaveCasterRemainTime(nextWaveInterval, true)
      end
      if self.waveRound < self.maxWave then
        MsgCenter:Broadcast(eMsgEventId.TDNextCountDown, (self.loopCasterTimer).left)
      end
    end
    MsgCenter:Broadcast(eMsgEventId.TDNextClickActive, false)
    local callRealCaster = BindCallback(self, self.CallRealCaster)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).startAnimId, 1)
    LuaSkillCtrl:StartTimer(self, (self.config).skill_time, callRealCaster)
    MsgCenter:Broadcast(eMsgEventId.TDNextWava, self.waveRound, self.maxWave, (self.maxIndexPerWave)[self.waveRound])
  end
end

CommonMonsterCasterSkill.ClearLastWaveCaster = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if self.casteForEachTagTimer ~= nil then
    (self.casteForEachTagTimer):Stop()
    self.casteForEachTagTimer = nil
  end
  self:StopCurWaveDeloyBornTimer(self.waveRound)
  if self.waveRound <= 0 then
    return 
  end
  for i = 1, self.maxTag do
    local curTagMonsters = (self.curMonsters)[i]
    if curTagMonsters ~= nil then
      local curTagWaveMonsters = curTagMonsters[self.waveRound]
      if curTagWaveMonsters ~= nil then
        for _,tempPos in ipairs(self.bornPosList) do
          if curTagWaveMonsters[tempPos] ~= nil then
            local count = (curTagWaveMonsters[tempPos]):Count()
            if count > 0 then
              (curTagWaveMonsters[tempPos]):Clear()
            end
            self.totalRoleCount = self.totalRoleCount - count
          end
        end
      end
    end
  end
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = 0
end

CommonMonsterCasterSkill.CallRealCaster = function(self)
  -- function num : 0_17 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  self:SetStateForLastWaveAliveMonster()
  if self.maxTag <= 0 then
    return 
  end
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

CommonMonsterCasterSkill.SetStateForLastWaveAliveMonster = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.aliveMonsterList ~= nil then
    local aliveRoleCount = #self.aliveMonsterList
    if aliveRoleCount > 0 then
      for i = 1, aliveRoleCount do
        local role = (self.aliveMonsterList)[i]
        if role ~= nil and role.hp > 0 then
          LuaSkillCtrl:CallBuff(self, role, (self.config).abandonMoveBuff, 1, (self.config).countDownDuration, true)
          local second = (self.config).countDownDuration // 15
          -- DECOMPILER ERROR at PC33: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (role.recordTable).boomLeftTime = second
          if not LuaSkillCtrl.IsInVerify then
            LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CallCountDownEffect, role, second)), nil, second - 1, 14)
          end
        end
      end
      LuaSkillCtrl:StartTimer(nil, (self.config).countDownDuration, BindCallback(self, self.KillAllMonsterAndDamageToCamp, self.aliveMonsterList))
      self.aliveMonsterList = {}
    end
  end
end

CommonMonsterCasterSkill.SetStateForTheFinalWaveAliveMonster = function(self)
  -- function num : 0_19
  self:ClearLastWaveCaster()
  self:SetStateForLastWaveAliveMonster()
  self:KillSelf()
  if self.lastBoomTimer ~= nil then
    (self.lastBoomTimer):Stop()
    self.lastBoomTimer = nil
  end
end

CommonMonsterCasterSkill.CallCountDownEffect = function(self, role, second)
  -- function num : 0_20 , upvalues : _ENV
  if role == nil or role.hp <= 0 then
    return 
  end
  local leftTime = (role.recordTable).boomLeftTime or second
  if second - leftTime == 0 then
    local countDownEffect = LuaSkillCtrl:CallEffect(role, (self.config).BoomEffectTime, self)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (role.recordTable).countDownEffect = countDownEffect
  else
    do
      do
        local countDownEffect = LuaSkillCtrl:CallEffect(role, (self.config).BoomEffectTime2, self)
        -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

        ;
        (role.recordTable).countDownEffect = countDownEffect
        countDownEffect:SetCountValue(second - leftTime)
        -- DECOMPILER ERROR at PC38: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (role.recordTable).boomLeftTime = leftTime - 1
      end
    end
  end
end

CommonMonsterCasterSkill.CheckAndKillCountDownEfc = function(self, role)
  -- function num : 0_21
  local countDownEffect = (role.recordTable).countDownEffect
  if countDownEffect ~= nil and not countDownEffect:IsDie() then
    countDownEffect:Die()
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (role.recordTable).countDownEffect = nil
end

CommonMonsterCasterSkill.StopCurWaveDeloyBornTimer = function(self, curWave)
  -- function num : 0_22 , upvalues : _ENV
  if self.delayTimerDictPerWave == nil or (self.delayTimerDictPerWave)[curWave] == nil then
    return 
  end
  local curTimers = (self.delayTimerDictPerWave)[curWave]
  for _,tempPos in ipairs(self.bornPosList) do
    local timerPerPos = curTimers[tempPos]
    if timerPerPos ~= nil then
      timerPerPos:Stop()
    end
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.delayTimerDictPerWave)[curWave] = nil
end

CommonMonsterCasterSkill.StopAllBornTimer = function(self)
  -- function num : 0_23
  for i = 0, self.maxWave do
    self:StopCurWaveDeloyBornTimer(i)
  end
end

CommonMonsterCasterSkill.CasteMonsterForeach = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local curMaxIndex = (self.maxIndexPerWave)[self.waveRound]
  if curMaxIndex == nil or curMaxIndex <= 0 then
    if self.casteForEachTagTimer ~= nil then
      (self.casteForEachTagTimer):Stop()
      self.casteForEachTagTimer = nil
    end
    self:StopCurWaveDeloyBornTimer(self.waveRound)
    return 
  end
  for curTag = 1, self.maxTag do
    local campRole = self:GetCampRole(curTag)
    if campRole ~= nil then
      local curTagMonsters = (self.curMonsters)[curTag]
      if curTagMonsters ~= nil then
        local tempMonsterBorntable = curTagMonsters[self.waveRound]
        if tempMonsterBorntable ~= nil then
          local delayTimers = (self.delayTimerDictPerWave)[self.waveRound]
          if delayTimers == nil then
            delayTimers = {}
            -- DECOMPILER ERROR at PC44: Confused about usage of register: R10 in 'UnsetPending'

            ;
            (self.delayTimerDictPerWave)[self.waveRound] = delayTimers
          end
          for _,tempPos in ipairs(self.bornPosList) do
            local tempMonsterStack = tempMonsterBorntable[tempPos]
            self:RealCallTDMonster(tempMonsterStack, curTag, campRole, tempPos, delayTimers)
          end
        end
      end
    end
  end
end

CommonMonsterCasterSkill.RealCallTDMonster = function(self, tempMonsterStack, curTag, campRole, tempPos, delayTimers)
  -- function num : 0_25 , upvalues : _ENV, MonsterBornState
  if tempMonsterStack == nil or tempMonsterStack:Count() <= 0 then
    return 
  end
  local tempMonsterData = tempMonsterStack:Peek()
  local coord = (BattleUtil.XYCoord2Pos)((tempMonsterData.role).x, (tempMonsterData.role).y)
  if self:CheckAndMarkRouteMonster(curTag, coord) then
    local routeSummoner = LuaSkillCtrl:CreateSummoner(self, (self.config).routeMonsterId, (tempMonsterData.role).x, (tempMonsterData.role).y)
    routeSummoner:SetAttr(eHeroAttr.maxHp, 100)
    routeSummoner:SetAsRealEntity(7)
    local routeSummonerEntity = LuaSkillCtrl:AddSummonerRole(routeSummoner)
    routeSummonerEntity:SetRoleMoveFollowTarget(campRole, true, true)
    LuaSkillCtrl:CallBuff(self, routeSummonerEntity, (self.config).route_monster_buff, 1, 99, true)
    return 
  end
  do
    if tempMonsterData.bornState == MonsterBornState.eBornDelaying then
      return 
    else
      if tempMonsterData.bornState == MonsterBornState.eCompleteDelay then
        self:CreateTDMonster(tempMonsterStack, tempMonsterData, campRole)
        return 
      end
    end
    local delayTime = tempMonsterData.bornDelay
    if delayTime <= 0 then
      self:CreateTDMonster(tempMonsterStack, tempMonsterData, campRole)
      return 
    end
    local delayTimerPerPos = delayTimers[tempPos]
    if delayTimerPerPos == nil or delayTimerPerPos:IsOver() then
      delayTimerPerPos = LuaSkillCtrl:StartTimer(nil, delayTime, (BindCallback(self, self.CreateTDMonster, tempMonsterStack, tempMonsterData, campRole)), nil)
      tempMonsterData.bornState = MonsterBornState.eBornDelaying
      delayTimers[tempPos] = delayTimerPerPos
    end
  end
end

CommonMonsterCasterSkill.CreateTDMonster = function(self, tempMonsterStack, tempMonsterData, campRole)
  -- function num : 0_26 , upvalues : MonsterBornState, _ENV
  tempMonsterData.bornState = MonsterBornState.eCompleteDelay
  local role = LuaSkillCtrl:CreateTDMonster(tempMonsterData.role, self, campRole)
  if role == nil then
    return 
  end
  local bloodNum = (tempMonsterData.role):GetBossBloodNum()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  if bloodNum > 0 then
    (role.recordTable).isTowerBoss = true
  end
  tempMonsterStack:Pop()
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.maxIndexPerWave)[self.waveRound] = (self.maxIndexPerWave)[self.waveRound] - 1
  self.totalRoleCount = self.totalRoleCount - 1
  self:OnMonsterCastered(role)
  ;
  (table.insert)(self.aliveMonsterList, role)
end

CommonMonsterCasterSkill.KillSelf = function(self)
  -- function num : 0_27 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_88, 0)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, false, nil, true, true)
end

CommonMonsterCasterSkill.CheckAndMarkRouteMonster = function(self, curTag, curCoord)
  -- function num : 0_28
  local routeTag = (self.tagRoute)[curTag]
  if routeTag == nil then
    return false
  end
  local canCallRoute = routeTag[curCoord]
  if not canCallRoute then
    routeTag[curCoord] = true
    return true
  end
  return false
end

CommonMonsterCasterSkill.OnMonsterCastered = function(self, role)
  -- function num : 0_29 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_286, 1, nil, true)
  local skillMgrComp = role:GetSkillComponent()
  if skillMgrComp ~= nil then
    skillMgrComp:BroadCastRoleAfterBattleStartTrigger(true)
  end
  if self.totalRoleCount <= 0 then
    self:KillSelf()
  end
  if self.maxWave <= self.waveRound and self.lastWaveBoomInterval ~= nil and self.lastWaveBoomInterval > 0 and self.lastBoomTimer == nil then
    self.lastBoomTimer = LuaSkillCtrl:StartTimer(nil, self.lastWaveBoomInterval, self.SetStateForTheFinalWaveAliveMonster, self)
    MsgCenter:Broadcast(eMsgEventId.TDNextCountDown, self.lastWaveBoomInterval)
  end
  MsgCenter:Broadcast(eMsgEventId.TDMonsterBorn, (self.maxIndexPerWave)[self.waveRound])
end

CommonMonsterCasterSkill.KillAllMonsterAndDamageToCamp = function(self, monsters)
  -- function num : 0_30 , upvalues : _ENV
  for i = 1, #monsters do
    local monster = monsters[i]
    if monster ~= nil and monster.hp > 0 then
      local campRole = self:GetCampRole(monster:GetRoleTag())
      if campRole ~= nil then
        self:CheckAndKillCountDownEfc(monster)
        LuaSkillCtrl:CallEffect(monster, (self.config).BoomEffect, self)
        LuaSkillCtrl:CallEffectWithArgAndSpeedOverride(campRole, (self.config).latestAtkEffect, self, monster, 1, false, false, self.EffectEventTrigger, monster)
      end
    end
  end
end

CommonMonsterCasterSkill.EffectEventTrigger = function(self, monster, effect, eventId, target)
  -- function num : 0_31 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local playerEntity = ((LuaSkillCtrl.battleCtrl).PlayerController).SkillCasterEntity
    local atkOffset = 1
    if playerEntity ~= nil and playerEntity.hp_regen >= 1 then
      atkOffset = playerEntity.hp_regen
    end
    local hurt = (self.config).hurtPerAtk * atkOffset
    local targetRole = target.targetRole
    if targetRole ~= nil and targetRole.hp > 0 then
      LuaSkillCtrl:RemoveLife(hurt, self, target, true, nil, true)
    end
    if monster.hp > 0 then
      LuaSkillCtrl:RemoveLife(monster.hp + 1, self, monster, true, nil)
    end
  end
end

CommonMonsterCasterSkill.OnCasterDie = function(self)
  -- function num : 0_32
end

CommonMonsterCasterSkill.LuaDispose = function(self)
  -- function num : 0_33 , upvalues : base
  (base.LuaDispose)(self)
  self.maxIndexPerWave = nil
  self.aliveMonsterList = nil
  self.allCampRoles = nil
  self.curMonsters = nil
  self.tagRoute = nil
  self.waveIntervals = nil
  self.lastWaveBoomInterval = nil
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

return CommonMonsterCasterSkill

