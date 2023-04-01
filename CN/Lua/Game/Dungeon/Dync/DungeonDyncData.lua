-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonDyncData = class("DungeonDyncData")
local DungeonTypeData = require("Game.Dungeon.DungeonTypeData")
local DungeonDyncElemDataDailyDg = require("Game.Dungeon.Dync.DungeonDyncElemDataDailyDg")
local DungeonDyncElemDataWinterChallengeDg = require("Game.Dungeon.Dync.DungeonDyncElemDataWinterChallengeDg")
local DgDyncElemDataDic = {[proto_csmsg_DungeonType.DungeonType_Daily] = DungeonDyncElemDataDailyDg, [proto_csmsg_DungeonType.DungeonType_WinterHard] = DungeonDyncElemDataWinterChallengeDg}
local _GetDgDyncElemData = function(moduleId)
  -- function num : 0_0 , upvalues : _ENV, DgDyncElemDataDic
  local dungeonType = ((ConfigData.battle_dungeon).moduleId2DungeonTypeDic)[moduleId]
  if dungeonType == nil then
    error("Cant get dungeonType, moduleId = " .. tostring(moduleId))
    return 
  end
  local DgDyncElemData = DgDyncElemDataDic[dungeonType]
  if DgDyncElemData == nil then
    error("Cant get DgDyncElemData, dungeonType = " .. tostring(dungeonType))
  end
  return DgDyncElemData
end

local eDungeonEnum = require("Game.Dungeon.eDungeonEnum")
local FormationUtil = require("Game.Formation.FormationUtil")
DungeonDyncData.ctor = function(self)
  -- function num : 0_1
  self.dungeonDyncDataDic = {}
  self._defaultDungeonDyncDataDic = {}
end

DungeonDyncData.InitDungeonDyncData = function(self, dungeonDync)
  -- function num : 0_2 , upvalues : _ENV
  for k,v in pairs(self.dungeonDyncDataDic) do
    v:ClearDungeonDyncElemFmtExclude()
  end
  self.dungeonDyncDataDic = {}
  self:UpdDungeonDyncData(dungeonDync, nil)
end

DungeonDyncData.UpdDungeonDyncData = function(self, dungeonDync, deleteDic)
  -- function num : 0_3 , upvalues : _ENV, _GetDgDyncElemData
  if deleteDic ~= nil then
    for k,v in pairs(deleteDic) do
      local dyncData = (self.dungeonDyncDataDic)[k]
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self.dungeonDyncDataDic)[k] = nil
      if dyncData ~= nil then
        dyncData:ClearDungeonDyncElemFmtExclude()
      end
    end
  end
  do
    for k,v in pairs(dungeonDync) do
      local elem = (self.dungeonDyncDataDic)[k]
      if elem == nil then
        local DgDyncElemData = _GetDgDyncElemData(k)
        if DgDyncElemData ~= nil then
          do
            do
              elem = (DgDyncElemData.New)()
              -- DECOMPILER ERROR at PC33: Confused about usage of register: R10 in 'UnsetPending'

              ;
              (self.dungeonDyncDataDic)[k] = elem
              elem:UpdDungeonDyncElemData(v)
              -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
end

DungeonDyncData.GetDailyDungeonDyncData = function(self)
  -- function num : 0_4 , upvalues : _ENV, eDungeonEnum, DungeonDyncElemDataDailyDg
  local dungeonUITypeDic = (ConfigData.material_dungeon).dungeonUITypeDic
  local moduleIdList = dungeonUITypeDic[(eDungeonEnum.eDungeonType).DailyDungeon]
  if moduleIdList == nil then
    error("Cant get dungeonUITypeDic, eDungeonEnum.eDungeonType.DailyDungeon")
    return 
  end
  for k,moduleId in ipairs(moduleIdList) do
    if (self.dungeonDyncDataDic)[moduleId] ~= nil then
      return (self.dungeonDyncDataDic)[moduleId]
    end
  end
  local moduleId = moduleIdList[1]
  if not (self._defaultDungeonDyncDataDic)[moduleId] then
    local dungeonDyncElemData = (DungeonDyncElemDataDailyDg.CreateDefaultDungeonDyncElemData)(DungeonDyncElemDataDailyDg, moduleId)
  end
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._defaultDungeonDyncDataDic)[moduleId] = dungeonDyncElemData
  return dungeonDyncElemData
end

DungeonDyncData.GetWinterChallengeDgDyncData = function(self)
  -- function num : 0_5 , upvalues : _ENV
  return self:GetDungeonDyncData(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinterChallenge)
end

DungeonDyncData.GetDungeonDyncData = function(self, moduleId)
  -- function num : 0_6 , upvalues : _GetDgDyncElemData
  if (self.dungeonDyncDataDic)[moduleId] ~= nil then
    return (self.dungeonDyncDataDic)[moduleId]
  end
  local DgDyncElemData = _GetDgDyncElemData(moduleId)
  if not (self._defaultDungeonDyncDataDic)[moduleId] then
    local dungeonDyncElemData = (DgDyncElemData.CreateDefaultDungeonDyncElemData)(DgDyncElemData, moduleId)
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._defaultDungeonDyncDataDic)[moduleId] = dungeonDyncElemData
  return dungeonDyncElemData
end

DungeonDyncData.GetDailyDungeonState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local dungeonDyncElemData = self:GetDailyDungeonDyncData()
  if dungeonDyncElemData.isDailyDungeonNew then
    return false, false
  end
  local matDungeonCfg = (ConfigData.material_dungeon)[dungeonDyncElemData.moduleId]
  if matDungeonCfg == nil then
    error("Cant get ConfigData.material_dungeon, id : " .. tostring(dungeonDyncElemData.moduleId))
    return false, false
  end
  local isFinish = #matDungeonCfg.stage_id <= dungeonDyncElemData.idx
  local inDungeon = not isFinish
  do return isFinish, inDungeon end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonDyncData.GetWinterChallengeDgStage = function(self)
  -- function num : 0_8
  local dungeonDyncElemData = self:GetWinterChallengeDgDyncData()
  if dungeonDyncElemData.isDailyDungeonNew then
    return false, false
  end
end

DungeonDyncData.CacheDgFmtFriendSupportHeroData = function(self, supportHeroData)
  -- function num : 0_9
  self._dgFmtFriendSupportHeroData = supportHeroData
end

DungeonDyncData.GetDgFmtFriendSupportHeroDataCache = function(self)
  -- function num : 0_10
  return self._dgFmtFriendSupportHeroData
end

DungeonDyncData._ClearDgFmtFriendSupportHeroDataCache = function(self)
  -- function num : 0_11
  self._dgFmtFriendSupportHeroData = nil
end

return DungeonDyncData

