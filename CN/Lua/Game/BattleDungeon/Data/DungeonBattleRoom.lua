-- params : ...
-- function num : 0 , upvalues : _ENV
local BaseBattleRoom = require("Game.Common.Data.BaseBattleRoom")
local DungeonBattleRoom = class("DungeonBattleRoom", BaseBattleRoom)
local CS_BattleUtility = CS.BattleUtility
local ItemData = require("Game.PlayerData.Item.ItemData")
DungeonBattleRoom.ctor = function(self)
  -- function num : 0_0
end

DungeonBattleRoom.CreateBattleDungeonRoom = function(bdCtrl, monsterGroup, dungeonCfg, dynPlayer)
  -- function num : 0_1 , upvalues : DungeonBattleRoom
  local batteRoom = (DungeonBattleRoom.New)()
  batteRoom:InitBattleRoom(bdCtrl, monsterGroup, dungeonCfg, dynPlayer)
  return batteRoom
end

DungeonBattleRoom.InitBattleRoom = function(self, bdCtrl, monsterGroup, dungeonCfg, dynPlayer)
  -- function num : 0_2 , upvalues : _ENV, ItemData, CS_BattleUtility
  self.bdCtrl = bdCtrl
  self.battleId = monsterGroup.battleId
  self.dungeonType = dungeonCfg.dungeon_type
  if self.dungeonType == proto_csmsg_DungeonType.DungeonType_WinterHard then
    self.dungeonType = proto_csmsg_DungeonType.DungeonType_Daily
  end
  self.formation = monsterGroup.form
  self.dynPlayer = dynPlayer
  self.rewardList = {}
  if monsterGroup.reward ~= nil then
    for k1,elem in ipairs((monsterGroup.reward).data) do
      for i = 1, elem.stacking do
        local itemData = (ItemData.New)(elem.id, elem.num)
        local pos = (math.random)(1, #self.rewardList + 1)
        ;
        (table.insert)(self.rewardList, pos, itemData)
      end
    end
    self.rewardExtraDic = (monsterGroup.reward).extra
  end
  self.crazyTime = ((self.bdCtrl).sceneCtrl):GetDungeonCrazyTime()
  local size_row, size_col, deploy_rows, grid_scale_factor = ((self.bdCtrl).sceneCtrl):GetBattleFieldSizeBySceneId()
  local benchCount = (ConfigData.game_config).battleMap_bench_count
  if self:IsInTDBattle() then
    benchCount = 0
  end
  self.battleMap = (CS_BattleUtility.GenBattleMap)(size_row, size_col, deploy_rows, benchCount, grid_scale_factor)
  self:TryInitSpecailDeployGrid(monsterGroup.specialDeployId, monsterGroup.redeploy)
  self:__InitMonsterOrNeutralData(monsterGroup.data)
  if (self.bdCtrl).bloodGridMax == nil then
    (self.bdCtrl):CalculateBloodGrid(self.monsterList)
  end
  ;
  (self.battleMap):SetBloodGridParam((self.bdCtrl).unitBlood, (self.bdCtrl).bossUnitBlood, (self.bdCtrl).bloodGridMax)
  ;
  (self.battleMap):SetPlayerRoleBattleMaxCount((self.dynPlayer):GetEnterFiledNum())
  self:__InitBattleGrid(monsterGroup.grids)
  self:UpdateMonsterChip()
end

DungeonBattleRoom.GetSceneId = function(self)
  -- function num : 0_3
  return ((self.bdCtrl).sceneCtrl).curSceneId
end

DungeonBattleRoom.RollbackMonsterChipForEditor = function(self, chipMsg)
  -- function num : 0_4 , upvalues : _ENV
  local chipDic = (self.dynPlayer):GetNormalChipDic()
  if chipMsg.delete ~= nil then
    for chipId,v in pairs(chipMsg.delete) do
      local chipData = chipDic[chipId]
      if chipData ~= nil then
        self:__RollbackMonsterChip(chipData)
      end
    end
  end
  do
    if chipMsg.update ~= nil then
      for chipId,num in pairs(chipMsg.update) do
        local chipData = chipDic[chipId]
        if chipData ~= nil then
          self:__RollbackMonsterChip(chipData)
        end
      end
    end
  end
end

DungeonBattleRoom.UpdateMonsterChip = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local chipList = (self.dynPlayer):GetChipList()
  for k,chipData in pairs(chipList) do
    self:__ExecuteMonsterChip(chipData)
  end
  local epBuffChipDic = (self.dynPlayer):GetEpBuffChipDic()
  for k,buffChip in pairs(epBuffChipDic) do
    self:__ExecuteMonsterBuffChip(buffChip)
  end
end

DungeonBattleRoom.IsInTDBattle = function(self)
  -- function num : 0_6 , upvalues : _ENV
  do return self.dungeonType == proto_csmsg_DungeonType.DungeonType_TD end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonBattleRoom.IsBrotatoBattle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  do return self.dungeonType == proto_csmsg_DungeonType.DungeonType_Brotato end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonBattleRoom.IsGuardTDBattle = function(self)
  -- function num : 0_8 , upvalues : _ENV
  do return self.dungeonType == proto_csmsg_DungeonType.DungeonType_GuardianProfessor end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonBattleRoom.GetIsInBigBossRoom = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (BattleUtil.IsInWinterChallengeDungeon)() then
    return true
  end
  return false
end

return DungeonBattleRoom

