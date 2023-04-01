-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.DungeonCenter.Data.DungeonLevelBase")
local SectorIIChallengeDgData = class("SectorIIChallengeDgData", base)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
SectorIIChallengeDgData.ctor = function(self, stageId, activitySectorIIData)
  -- function num : 0_0 , upvalues : _ENV
  self._actvSectorIIData = activitySectorIIData
  self._winterCfg = activitySectorIIData:GetActvWinterCfg()
  self._lvTypeCfg = ((ConfigData.activity_winter_level_type)[(self._winterCfg).id])[(self._winterCfg).hard_level_type]
  self.__ActivityWinterCfg = (ConfigData.activity_winter_dungeon_detail)[stageId]
end

SectorIIChallengeDgData.GetDungeonLevelStageId = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local winChallengeDyncDgData = (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
  local curIdx = winChallengeDyncDgData.idx + 1
  local stageId = ((self._lvTypeCfg).dungeon_levels)[curIdx]
  if stageId == nil then
    error("Cant get stageId, curIdx = " .. tostring(curIdx))
  end
  return stageId
end

SectorIIChallengeDgData.GetDungeonLevelType = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).SectorIIChallenge
end

SectorIIChallengeDgData.GetDungeonInfoDesc = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__ActivityWinterCfg).level_des)
end

SectorIIChallengeDgData.GetDungeonLevelPic = function(self)
  -- function num : 0_4
  return (self.__ActivityWinterCfg).level_pic
end

SectorIIChallengeDgData.GetEnterLevelCost = function(self)
  -- function num : 0_5
  return (self._winterCfg).cost_id
end

SectorIIChallengeDgData.GetConsumeKeyNum = function(self)
  -- function num : 0_6
  return 0
end

SectorIIChallengeDgData.GetLevelUnlockConditionCfg = function(self)
  -- function num : 0_7
  local cfg = self._winterCfg
  return cfg.hard_pre_condition, cfg.pre_para1, cfg.pre_para2
end

SectorIIChallengeDgData.GetDungeonBuffListCfg = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.__chipTable == nil then
    self.__chipTable = {}
    local dic = {}
    for _,stageId in pairs((self._lvTypeCfg).dungeon_levels) do
      local stageCfg = (ConfigData.battle_dungeon)[stageId]
      if stageCfg ~= nil and stageCfg.protocol ~= nil then
        for _,buffID in pairs(stageCfg.protocol) do
          dic[buffID] = true
        end
      end
    end
    for buffID,_ in pairs(dic) do
      (table.insert)(self.__chipTable, buffID)
    end
  end
  do
    return self.__chipTable
  end
end

SectorIIChallengeDgData.GetIsLevelUnlock = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (CheckCondition.CheckLua)(self:GetLevelUnlockConditionCfg())
end

SectorIIChallengeDgData.GetSctIIChallengeDgLvNum = function(self)
  -- function num : 0_10
  local lvTypeCfg = self:GetActvWinChallengeLvTypeCfg()
  return #lvTypeCfg.dungeon_levels
end

SectorIIChallengeDgData.GetSectorIIActivityData = function(self)
  -- function num : 0_11
  return self._actvSectorIIData
end

SectorIIChallengeDgData.GetActvWinChallengeLvTypeCfg = function(self)
  -- function num : 0_12
  return self._lvTypeCfg
end

SectorIIChallengeDgData.GetSectorIIChallengeLvPos = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local lvTypeCfg = self:GetActvWinChallengeLvTypeCfg()
  local posConfig = ConfigData.activity_winter_level_pos
  do
    if posConfig[lvTypeCfg.pos_id] ~= nil and (posConfig[lvTypeCfg.pos_id])[1] ~= nil then
      local posCfg = (posConfig[lvTypeCfg.pos_id])[1]
      return (Vector2.New)((posCfg.level_pos)[1], (posCfg.level_pos)[2])
    end
    return Vector2.zero
  end
end

SectorIIChallengeDgData.GetSectorIIChallengeRewardListCfg = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local rewardCfg = (ConfigData.activity_winter_challenge_award)[(self._actvSectorIIData).actId]
  return rewardCfg
end

SectorIIChallengeDgData.UpdSctIIChallengeDgData = function(self, msgVerify)
  -- function num : 0_15
  if not msgVerify then
    self._msgVerify = {curScore = 0, lastDungeonId = 0, maxScore = 0, historyMaxScore = 0}
  end
end

SectorIIChallengeDgData.GetSctIIChallengeDgScore = function(self)
  -- function num : 0_16
  return (self._msgVerify).curScore
end

SectorIIChallengeDgData.GetSctIIChallengeDgMaxScore = function(self)
  -- function num : 0_17
  return (self._msgVerify).maxScore
end

SectorIIChallengeDgData.GetSctIIChallengeDgHisMaxScore = function(self)
  -- function num : 0_18
  return (self._msgVerify).historyMaxScore
end

SectorIIChallengeDgData.GetSctIIChallengeDgLastDungeonId = function(self)
  -- function num : 0_19
  return (self._msgVerify).lastDungeonId
end

SectorIIChallengeDgData.GetSctIIChallengeDgSuitNumDic = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local frameActId = (self._actvSectorIIData):GetSectorIIActFrameId()
  local logicAddDic = (PlayerDataCenter.playerBonus):Get_Activity_PowTestChipGroupLimitAdd(frameActId)
  local defaultNum = (self._winterCfg).hard_chip_num
  local chipSuitNumDic = setmetatable({}, {__index = function(tab, key)
    -- function num : 0_20_0 , upvalues : logicAddDic, defaultNum
    return (logicAddDic[key] or 0) + defaultNum
  end
})
  return chipSuitNumDic
end

SectorIIChallengeDgData.GetSectorIIDun_ChipSuitLimitNum = function(self)
  -- function num : 0_21
  local sectorIIData = self:GetSectorIIActivityData()
  local logicAdd = sectorIIData:GetSectorII_ChipSuitLimitNumAdd()
  local cfgNum = (self.__ActivityWinterCfg).chip_select_max
  return cfgNum + logicAdd
end

SectorIIChallengeDgData.GetSctIIChallengeDgRankId = function(self)
  -- function num : 0_22
  local lvTypeCfg = self:GetActvWinChallengeLvTypeCfg()
  return lvTypeCfg.ranklist_id
end

SectorIIChallengeDgData.GetSctIIChallengeDgStage = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local dungeonDyncElemData = (PlayerDataCenter.dungeonDyncData):GetWinterChallengeDgDyncData()
  if dungeonDyncElemData.isDailyDungeonNew then
    return false, false
  end
  local isFinish = #(self._lvTypeCfg).dungeon_levels <= dungeonDyncElemData.idx
  local inDungeon = not isFinish
  do return isFinish, inDungeon end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorIIChallengeDgData.IsSctIIChallengeDgLast = function(self, dungeonId)
  -- function num : 0_24
  local maxNum = #(self._lvTypeCfg).dungeon_levels
  if maxNum == 0 then
    return false
  end
  do return dungeonId == ((self._lvTypeCfg).dungeon_levels)[maxNum] end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorIIChallengeDgData.GetDunExtraBuffDic = function(self)
  -- function num : 0_25
  local sectorIIData = self:GetSectorIIActivityData()
  if sectorIIData == nil then
    return nil
  end
  local actBuffUnlockDic = sectorIIData:GetSectorII_UnlockedBuffList()
  return actBuffUnlockDic
end

SectorIIChallengeDgData.GetDunExtraDelectedBuffDic = function(self)
  -- function num : 0_26
  local sectorIIData = self:GetSectorIIActivityData()
  if sectorIIData == nil then
    return nil
  end
  local actBuffRemoveDic = sectorIIData:GetSectorII_DelectedBuffList()
  return actBuffRemoveDic
end

return SectorIIChallengeDgData

