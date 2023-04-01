-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseBattleRoom = class("BaseBattleRoom")
local DynMonster = require("Game.Exploration.Data.DynMonster")
local DynDungeonRole = require("Game.Exploration.Data.DynDungeonRole")
local DynEffectGrid = require("Game.Exploration.Data.DynEffectGrid")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
BaseBattleRoom.__InitMonsterOrNeutralData = function(self, groupData)
  -- function num : 0_0 , upvalues : _ENV, ExplorationEnum, DynMonster, DynDungeonRole
  if self.battleMap == nil then
    error("battle map not initialization")
    return 
  end
  self.occupyCoords = {}
  ;
  ((self.battleMap).monsterList):Clear()
  self.monsterList = {}
  self.pdungeonList = nil
  ;
  ((self.battleMap).stageMonsterDic):Clear()
  self.stageMonsterDic = {}
  local stageMonRootUidList = {}
  local normalMonsterDic = {}
  ;
  ((self.battleMap).waitToCasterMonsterList):Clear()
  local waitToCasterMonsterList = {}
  ;
  ((self.battleMap).neutralList):Clear()
  local neutralList = {}
  ;
  ((self.battleMap).pdungeonRoleList):Clear()
  local pdungeonRoleList = {}
  for k,v in pairs(groupData) do
    if (v.stc).cat ~= nil then
      if (v.stc).cat == (ExplorationEnum.EnemyRoleType).monster then
        local monster = (DynMonster.New)(v)
        if monster:IsStageMonster() then
          local stageMonsterList = (self.stageMonsterDic)[monster.parentUid]
          -- DECOMPILER ERROR at PC68: Confused about usage of register: R14 in 'UnsetPending'

          if stageMonsterList == nil then
            (self.stageMonsterDic)[monster.parentUid] = {}
            stageMonsterList = (self.stageMonsterDic)[monster.parentUid]
            ;
            (table.insert)(stageMonRootUidList, monster.parentUid)
          end
          ;
          (table.insert)(stageMonsterList, monster)
        else
          do
            do
              ;
              (table.insert)(self.monsterList, monster)
              normalMonsterDic[monster.uid] = monster
              -- DECOMPILER ERROR at PC92: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (self.occupyCoords)[monster.coordination] = true
              if (v.stc).cat == (ExplorationEnum.EnemyRoleType).neutral then
                local neutral = (DynDungeonRole.New)(v)
                ;
                (table.insert)(neutralList, neutral)
                -- DECOMPILER ERROR at PC110: Confused about usage of register: R13 in 'UnsetPending'

                ;
                (self.occupyCoords)[neutral.coordination] = true
              else
                do
                  if (v.stc).cat == (ExplorationEnum.EnemyRoleType).player then
                    local summoenr = (DynDungeonRole.New)(v)
                    summoenr:SetSummonerBelong(eBattleRoleBelong.player)
                    ;
                    (table.insert)(pdungeonRoleList, summoenr)
                    -- DECOMPILER ERROR at PC132: Confused about usage of register: R13 in 'UnsetPending'

                    ;
                    (self.occupyCoords)[summoenr.coordination] = true
                  else
                    do
                      if (v.stc).cat == (ExplorationEnum.EnemyRoleType).towerSumMonster then
                        local monsterSummoner = (DynMonster.New)(v)
                        ;
                        (table.insert)(waitToCasterMonsterList, monsterSummoner)
                      else
                        do
                          do
                            if (v.stc).cat == (ExplorationEnum.EnemyRoleType).templateMonster then
                              local monsterSummoner = (DynMonster.New)(v)
                              ;
                              (table.insert)(waitToCasterMonsterList, monsterSummoner)
                            end
                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out DO_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out DO_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out DO_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out DO_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out DO_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_THEN_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_THEN_STMT

                            -- DECOMPILER ERROR at PC163: LeaveBlock: unexpected jumping out IF_STMT

                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if #self.monsterList > 0 then
    (table.sort)(self.monsterList, function(a, b)
    -- function num : 0_0_0
    do return a.coordination < b.coordination end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    for i = 1, #self.monsterList do
      local monster = (self.monsterList)[i]
      local bloodNum = monster:GetBossBloodNum()
      if bloodNum > 0 then
        (self.battleMap):SetBossBlood(i - 1, bloodNum)
      end
      self:TrySetMonsterSpecailDeployTarget(monster)
      ;
      ((self.battleMap).monsterList):Add(monster)
    end
  end
  do
    if #neutralList > 0 then
      (table.sort)(neutralList, function(a, b)
    -- function num : 0_0_1
    do return a.coordination < b.coordination end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
      for i = 1, #neutralList do
        ((self.battleMap).neutralList):Add(neutralList[i])
      end
    end
    do
      if #pdungeonRoleList > 0 then
        (table.sort)(pdungeonRoleList, function(a, b)
    -- function num : 0_0_2
    do return a.coordination < b.coordination end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
        for i = 1, #pdungeonRoleList do
          ((self.battleMap).pdungeonRoleList):Add(pdungeonRoleList[i])
        end
      end
      do
        if #waitToCasterMonsterList > 0 then
          (table.sort)(waitToCasterMonsterList, function(a, b)
    -- function num : 0_0_3
    do return a.uid < b.uid end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
          for i = 1, #waitToCasterMonsterList do
            local waitToCasterMonster = waitToCasterMonsterList[i]
            ;
            ((self.battleMap).waitToCasterMonsterList):Add(waitToCasterMonster)
            ;
            (table.insert)(self.monsterList, waitToCasterMonsterList[i])
          end
        end
        do
          ;
          (table.sort)(stageMonRootUidList)
          for k,uid in ipairs(stageMonRootUidList) do
            local stageMonsterList = (self.stageMonsterDic)[uid]
            ;
            (table.sort)(stageMonsterList, function(a, b)
    -- function num : 0_0_4
    do return a.stage < b.stage end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
            local maxStage = #stageMonsterList + 1
            local sourceMon = normalMonsterDic[uid]
            sourceMon:SetMonsterHasMoreStage(maxStage)
            ;
            (self.battleMap):AddStageMonster(sourceMon)
            for k,v in ipairs(stageMonsterList) do
              (self.battleMap):AddStageMonster(v)
              v:SetMonsterHasMoreStage(maxStage)
              ;
              (table.insert)(self.monsterList, v)
            end
          end
        end
      end
    end
  end
end

BaseBattleRoom.__InitBattleGrid = function(self, grids)
  -- function num : 0_1 , upvalues : _ENV, DynEffectGrid
  self.effectGridList = {}
  if grids ~= nil then
    for k,v in pairs(grids) do
      local effectGrid = (DynEffectGrid.New)(k, v)
      ;
      (table.insert)(self.effectGridList, effectGrid)
    end
  end
  do
    ;
    (table.sort)(self.effectGridList, function(a, b)
    -- function num : 0_1_0
    local p1 = a:GetGridPriority()
    local p2 = b:GetGridPriority()
    if p1 >= p2 then
      do return p1 == p2 end
      do return a.coord < b.coord end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  end
end

BaseBattleRoom.ExecuteMonsterChip = function(self, dynPlayer)
  -- function num : 0_2 , upvalues : _ENV
  local chipList = self.monsterChipList
  if chipList ~= nil then
    for k,chipData in pairs(chipList) do
      self:__ExecuteMonsterChip(chipData, true)
    end
  end
  do
    self:ExecutePlayerChipForMonster(dynPlayer)
  end
end

BaseBattleRoom.ExecuteDungeonRoleChip = function(self, dynPlayer)
  -- function num : 0_3 , upvalues : _ENV
  if self.battleMap == nil then
    return 
  end
  if self.pdungeonList == nil then
    self.pdungeonList = {}
    for i = 0, ((self.battleMap).pdungeonRoleList).Count - 1 do
      (table.insert)(self.pdungeonList, ((self.battleMap).pdungeonRoleList)[i])
    end
  end
  do
    local chipList = dynPlayer:GetChipList()
    for k,chipData in pairs(chipList) do
      if chipData:IsForHeroIDChipBattle() then
        local validRoleList = chipData:GetValidRoleList(self.pdungeonList, eBattleRoleBelong.player)
        for k,v in pairs(validRoleList) do
          chipData:ExecuteChipData(v)
        end
      end
    end
    local epBuffChipList = dynPlayer:GetEpBuffChipDic()
    for k,buffChip in pairs(epBuffChipList) do
      if buffChip:IsForHeroIDChipBattle() then
        local validRoleList = buffChip:GetValidRoleList(self.pdungeonList, eBattleRoleBelong.player)
        for k,v in pairs(validRoleList) do
          buffChip:ExecuteBuffChip(v)
        end
      end
    end
  end
end

BaseBattleRoom.ExecutePlayerChipForMonster = function(self, dynPlayer)
  -- function num : 0_4 , upvalues : _ENV
  local chipList = dynPlayer:GetChipList()
  for k,chipData in pairs(chipList) do
    if chipData:IsForEnemyChip() then
      self:__ExecuteMonsterChip(chipData)
    end
  end
end

BaseBattleRoom.RollbackPlayerChipForMonster = function(self, dynPlayer)
  -- function num : 0_5 , upvalues : _ENV
  local chipList = dynPlayer:GetChipList()
  for k,chipData in pairs(chipList) do
    if chipData:IsForEnemyChip() then
      self:__RollbackMonsterChip(chipData)
    end
  end
end

BaseBattleRoom.__ExecuteMonsterChip = function(self, chipData, isRelative)
  -- function num : 0_6 , upvalues : _ENV
  local belong = eBattleRoleBelong.enemy
  if isRelative then
    belong = eBattleRoleBelong.player
  end
  local validRoleList = chipData:GetValidRoleList(self.monsterList, belong)
  for k,role in pairs(validRoleList) do
    chipData:ExecuteChipData(role)
  end
end

BaseBattleRoom.__RollbackMonsterChip = function(self, chipData)
  -- function num : 0_7 , upvalues : _ENV
  for k,role in pairs(self.monsterList) do
    chipData:RollbackChipData(role)
  end
end

BaseBattleRoom.__ExecuteMonsterBuffChip = function(self, buffChip)
  -- function num : 0_8 , upvalues : _ENV
  local validRoleList = buffChip:GetValidRoleList(self.monsterList, eBattleRoleBelong.enemy)
  for k,role in pairs(validRoleList) do
    buffChip:ExecuteBuffChip(role)
  end
end

BaseBattleRoom.__RollbackMonsterBuffChip = function(self, buffChip)
  -- function num : 0_9 , upvalues : _ENV
  for k,role in pairs(self.monsterList) do
    buffChip:RollbackBuffChip(role)
  end
end

BaseBattleRoom.ExecuteMonsterTempChip = function(self, chipTemporaryDic)
  -- function num : 0_10 , upvalues : _ENV
  for k,buffData in pairs(chipTemporaryDic) do
    self:__ExecuteMonsterBuffChip(buffData)
  end
end

BaseBattleRoom.RollbackMonsterTempChip = function(self, chipTemporaryDic)
  -- function num : 0_11 , upvalues : _ENV
  for k,buffData in pairs(chipTemporaryDic) do
    self:__RollbackMonsterBuffChip(buffData)
  end
end

BaseBattleRoom.GetSceneId = function(self)
  -- function num : 0_12
end

BaseBattleRoom.GetIsInWeeklyChallenge = function(self)
  -- function num : 0_13
  return false
end

BaseBattleRoom.GetIsInBigBossRoom = function(self)
  -- function num : 0_14
  return false
end

BaseBattleRoom.IsInTDBattle = function(self)
  -- function num : 0_15
  return false
end

BaseBattleRoom.IsBrotatoBattle = function(self)
  -- function num : 0_16
  return false
end

BaseBattleRoom.IsGuardTDBattle = function(self)
  -- function num : 0_17
  return false
end

BaseBattleRoom.IsDailyDungeon = function(self)
  -- function num : 0_18 , upvalues : _ENV
  do return self.dungeonType == proto_csmsg_DungeonType.DungeonType_Daily or self.dungeonType == proto_csmsg_DungeonType.DungeonType_WinterHard end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BaseBattleRoom.TryInitSpecailDeployGrid = function(self, specailDeployId, redeploy)
  -- function num : 0_19 , upvalues : _ENV
  self.reSpecialDeploy = redeploy
  if specailDeployId == nil or specailDeployId <= 0 then
    return 
  end
  local deployCfg = (ConfigData.room_special_deploy)[specailDeployId]
  if deployCfg == nil then
    error("cant get room_special_deploy, id:" .. tostring(specailDeployId))
    return 
  end
  self.roomSpecialDeployCfg = deployCfg
  ;
  (self.battleMap):SetSpecialDeployId(specailDeployId)
  for k,v in pairs((self.battleMap).tiles) do
    local ableDeploy = (deployCfg.deployGridDic)[k.x] ~= nil and ((deployCfg.deployGridDic)[k.x])[k.y] ~= nil
    v.ableDeploy = ableDeploy
    if ableDeploy then
      (self.battleMap):AddSpecialDeployGrid(k.x, k.y)
    end
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

BaseBattleRoom.TrySetMonsterSpecailDeployTarget = function(self, dynMonster)
  -- function num : 0_20 , upvalues : _ENV
  if self.roomSpecialDeployCfg == nil then
    return 
  end
  local minDistance = math.maxinteger
  local tarX, tarY = 0, 0
  for x,tab in pairs((self.roomSpecialDeployCfg).deployGridDic) do
    for y,_ in pairs(tab) do
      local distance = (BattleUtil.BattleHexDistance)(dynMonster.x, dynMonster.y, x, y)
      if distance < minDistance then
        minDistance = distance
        tarX = x
        tarY = y
      end
    end
  end
  dynMonster:SetDynMonTargetDeployPos(tarX, tarY)
end

return BaseBattleRoom

