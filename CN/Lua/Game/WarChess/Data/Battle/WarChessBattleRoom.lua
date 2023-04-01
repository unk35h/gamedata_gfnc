-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseBattleRoom = require("Game.Common.Data.BaseBattleRoom")
local WarChessBattleRoom = class("WarChessBattleRoom", BaseBattleRoom)
local DynEpBuffChip = require("Game.Exploration.Data.DynEpBuffChip")
local CS_BattleUtility = CS.BattleUtility
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WarChessBattleRoom.ctor = function(self)
  -- function num : 0_0
end

WarChessBattleRoom.CreateWCBattleRoom = function(bsd, dynPlayer, wcBattleCtrl)
  -- function num : 0_1 , upvalues : WarChessBattleRoom
  local batteRoom = (WarChessBattleRoom.New)()
  batteRoom._sceneId = bsd.sceneId
  batteRoom:InitBattleRoom(bsd, dynPlayer, wcBattleCtrl)
  return batteRoom
end

WarChessBattleRoom.InitBattleRoom = function(self, battleSystemData, dynPlayer, wcBattleCtrl)
  -- function num : 0_2 , upvalues : _ENV, CS_BattleUtility, DynEpBuffChip
  local battleRoomId = battleSystemData.roomId
  if battleRoomId ~= nil then
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleSystemData.roomId]
    if monsterGroupCfg ~= nil then
      self.battleId = monsterGroupCfg.team_id
      self.dungeonType = monsterGroupCfg.type
    else
      self.battleId = 0
      self.dungeonType = 1
      error("表怪物组不存在 battleRoomId:" .. tostring(battleSystemData.roomId))
    end
  else
    do
      self.battleId = 0
      self.dungeonType = 1
      self.crazyTime = battleSystemData.crazyTime
      self._wcBattleCtrl = wcBattleCtrl
      local size_row, size_col, deploy_rows, grid_scale_factor = (wcBattleCtrl.sceneCtrl):GetBattleFieldSizeBySceneId()
      local benchCount = (ConfigData.game_config).battleMap_bench_count
      if self:IsInTDBattle() then
        benchCount = 0
      end
      self.battleMap = (CS_BattleUtility.GenBattleMap)(size_row, size_col, deploy_rows, benchCount, grid_scale_factor)
      self:TryInitSpecailDeployGrid(battleSystemData.specialDeployId, battleSystemData.redeploy)
      local monsters = battleSystemData.monsters
      local tmpAlgs = battleSystemData.tmpAlg
      self:__InitMonsterOrNeutralData(battleSystemData.monsters)
      for _,buffChip in pairs(dynPlayer.epBuffChipDic) do
        if buffChip ~= nil then
          dynPlayer:__RollBackBuffChip(buffChip)
        end
      end
      dynPlayer:ClearAlg()
      if tmpAlgs ~= nil then
        for chipId,num in pairs(tmpAlgs) do
          local buffChip = (dynPlayer.epBuffChipDic)[chipId]
          if buffChip ~= nil then
            dynPlayer:__RollBackBuffChip(buffChip)
            buffChip:SetCount(num)
            dynPlayer:__ExecuteBuffChip(buffChip)
          else
            local buffChip = (DynEpBuffChip.New)(chipId, num)
            -- DECOMPILER ERROR at PC95: Confused about usage of register: R19 in 'UnsetPending'

            ;
            (dynPlayer.epBuffChipDic)[chipId] = buffChip
            dynPlayer:__ExecuteBuffChip(buffChip)
          end
        end
      end
      do
        self:ExecuteMonsterTempChip(dynPlayer:GetEpBuffChipDic())
        ;
        (self.battleMap):SetPlayerRoleBattleMaxCount(dynPlayer:GetEnterFiledNum())
        self:__InitBattleGrid(battleSystemData.monsterGrids)
        if self:IsGuardTDBattle() then
          self:ExecuteDungeonRoleChip(self.dynPlayer)
        end
      end
    end
  end
end

WarChessBattleRoom.GetSceneId = function(self)
  -- function num : 0_3
  return self._sceneId
end

WarChessBattleRoom.UpdateMonsterChip = function(self)
  -- function num : 0_4
end

WarChessBattleRoom.IsInTDBattle = function(self)
  -- function num : 0_5
  return false
end

WarChessBattleRoom.IsBrotatoBattle = function(self)
  -- function num : 0_6
  return false
end

WarChessBattleRoom.GetIsInBigBossRoom = function(self)
  -- function num : 0_7
  return false
end

WarChessBattleRoom.IsGuardTDBattle = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local entityData = (self._wcBattleCtrl):GetBattleEntity()
  if entityData == nil then
    error("can\'t get monster entity data")
    return false
  end
  local battleRoomId = entityData:GetBattleRoomID()
  local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
  if monsterGroupCfg == nil then
    error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
    return false
  end
  do return monsterGroupCfg.type == proto_csmsg_DungeonType.DungeonType_GuardianProfessor end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessBattleRoom.IsWcBossRoom = function(self)
  -- function num : 0_9 , upvalues : _ENV, eWarChessEnum
  local entityData = (self._wcBattleCtrl):GetBattleEntity()
  if entityData == nil then
    error("can\'t get monster entity data")
    return false
  end
  local battleRoomId = entityData:GetBattleRoomID()
  local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
  if monsterGroupCfg == nil then
    error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
    return false
  end
  local isBossRoom = monsterGroupCfg.type == eWarChessEnum.BattleRoomTypeBoss
  do return isBossRoom end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return WarChessBattleRoom

