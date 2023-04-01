-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Dungeon.Dync.DungeonDyncElemDataBase")
local DungeonDyncElemDataWinterChallengeDg = class("DungeonDyncElemDataWinterChallengeDg", base)
local DungeonDyncEnum = require("Game.Dungeon.Dync.DungeonDyncEnum")
DungeonDyncElemDataWinterChallengeDg.ctor = function(self)
  -- function num : 0_0 , upvalues : DungeonDyncEnum
  self._dyncType = (DungeonDyncEnum.DgDyncType).WinterChallenge
end

DungeonDyncElemDataWinterChallengeDg._InitData = function(self, msg, isDailyDungeonNew, newModuleId)
  -- function num : 0_1 , upvalues : base
  (base._InitData)(self, msg, isDailyDungeonNew, newModuleId)
  self:_CheckLastChipGroup()
end

DungeonDyncElemDataWinterChallengeDg._CheckLastChipGroup = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  if sectorIICtrl == nil then
    error("Cant get sectorIICtrl")
    return 
  end
  local sectorIIData = sectorIICtrl:GetSectorIIFirstData()
  if sectorIIData == nil then
    error("Cant get sectorIIData")
    return 
  end
  local actWinClgData = sectorIIData:GetActvWinChallengeDgData()
  local maxSuiNumDic = actWinClgData:GetSctIIChallengeDgSuitNumDic()
  local waitRemoveSuitIdDic = {}
  for suitId,v in pairs(self.lastChipGroup) do
    local curNum = (self.selectedChipGroup)[suitId] or 0
    local maxNum = maxSuiNumDic[suitId]
    if maxNum <= curNum then
      waitRemoveSuitIdDic[suitId] = true
    end
  end
  for suitId,v in pairs(waitRemoveSuitIdDic) do
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R11 in 'UnsetPending'

    (self.lastChipGroup)[suitId] = nil
  end
end

DungeonDyncElemDataWinterChallengeDg.IsDgDyncComplete = function(self)
  -- function num : 0_3
end

return DungeonDyncElemDataWinterChallengeDg

