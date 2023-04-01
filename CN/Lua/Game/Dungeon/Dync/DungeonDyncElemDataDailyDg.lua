-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Dungeon.Dync.DungeonDyncElemDataBase")
local DungeonDyncElemDataDailyDg = class("DungeonDyncElemDataDailyDg", base)
local DungeonDyncEnum = require("Game.Dungeon.Dync.DungeonDyncEnum")
DungeonDyncElemDataDailyDg.ctor = function(self)
  -- function num : 0_0 , upvalues : DungeonDyncEnum
  self._dyncType = (DungeonDyncEnum.DgDyncType).DailyDungeon
end

DungeonDyncElemDataDailyDg._InitData = function(self, msg, isDailyDungeonNew, newModuleId)
  -- function num : 0_1 , upvalues : base, _ENV
  (base._InitData)(self, msg, isDailyDungeonNew, newModuleId)
  local matDungeonCfg = (ConfigData.material_dungeon)[self.moduleId]
  if matDungeonCfg == nil then
    error("Cant get ConfigData.material_dungeon, id = " .. tostring(self.moduleId))
  end
  self.matDungeonCfg = matDungeonCfg
  self:_CheckLastChipGroup()
  if not isDailyDungeonNew then
    NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).DailyDungeon)
  end
end

DungeonDyncElemDataDailyDg._CheckLastChipGroup = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local waitRemoveSuitIdDic = {}
  for suitId,v in pairs(self.lastChipGroup) do
    local curNum = (self.selectedChipGroup)[suitId] or 0
    local maxNum = ((self.matDungeonCfg).chipSuitNumMaxDic)[suitId]
    if maxNum == nil then
      error("Cant find chip suit, id:" .. tostring(suitId))
      waitRemoveSuitIdDic[suitId] = true
    else
      if maxNum <= curNum then
        waitRemoveSuitIdDic[suitId] = true
      end
    end
  end
  for suitId,v in pairs(waitRemoveSuitIdDic) do
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R7 in 'UnsetPending'

    (self.lastChipGroup)[suitId] = nil
  end
end

DungeonDyncElemDataDailyDg.IsDgDyncComplete = function(self)
  -- function num : 0_3
  local allNum = #(self.matDungeonCfg).stage_id
  local completeAll = allNum == self.idx
  do return completeAll end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonDyncElemDataDailyDg.GetDgDyncElemName = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local name = (LanguageUtil.GetLocaleText)((self.matDungeonCfg).name)
  return name
end

DungeonDyncElemDataDailyDg.GetDailyDgNextLvDungeonId = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local nextLvDungeonId = ((self.matDungeonCfg).stage_id)[self.idx + 1]
  if nextLvDungeonId == nil then
    error("nextLvDungeonId is nil")
  end
  return nextLvDungeonId
end

DungeonDyncElemDataDailyDg.DgDyncIsHaveMultReward = function(self)
  -- function num : 0_6 , upvalues : _ENV
  return (PlayerDataCenter.playerBonus):IsDungeonHasMultReward(proto_csmsg_DungeonType.DungeonType_Daily)
end

DungeonDyncElemDataDailyDg.IsDailyModuleCanQuick = function(self, moduleId)
  -- function num : 0_7 , upvalues : _ENV
  if not PlayerDataCenter:IsDungeonModuleOpenQuick(moduleId) then
    return false
  end
  if self:IsDgDyncComplete() then
    return false
  end
  do return self.isDailyDungeonNew or self.moduleId == moduleId end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

return DungeonDyncElemDataDailyDg

