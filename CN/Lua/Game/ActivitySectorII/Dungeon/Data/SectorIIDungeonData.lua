-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.DungeonCenter.Data.DungeonLevelBase")
local SectorIIDungeonData = class("SectorIIDungeonData", base)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
SectorIIDungeonData.ctor = function(self, stageId, actInfo, index)
  -- function num : 0_0
  self.__actId = actInfo:GetActId()
  self.__actInfo = actInfo
  self.__index = index
  self.__levelPos = nil
  self.__couldSkipTimeLine = true
end

SectorIIDungeonData.SetSectorIIDungeonExtraData = function(self, posCfg, extraCfg)
  -- function num : 0_1
  self.__posCfg = posCfg
  self.__ActivityWinterCfg = extraCfg
end

SectorIIDungeonData.GetDungeonLevelType = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).SectorII
end

SectorIIDungeonData.GetDungeonLevelName = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__dungeonStageCfg).name)
end

SectorIIDungeonData.GetDungeonInfoDesc = function(self)
  -- function num : 0_4 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__ActivityWinterCfg).level_des)
end

SectorIIDungeonData.GetDungeonLevelPic = function(self)
  -- function num : 0_5
  return (self.__ActivityWinterCfg).level_pic
end

SectorIIDungeonData.GetConsumeKeyNum = function(self)
  -- function num : 0_6
  local costNums = (self.__dungeonStageCfg).cost_itemNums
  return (costNums[1] or 0) * self:GetWADunRewardRate()
end

SectorIIDungeonData.GetEnterLevelCost = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local costIds = (self.__dungeonStageCfg).cost_itemIds
  if not costIds[1] then
    return ConstGlobalItem.SKey
  end
end

SectorIIDungeonData.GetEnterLevelCostItemName = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local itemId = self:GetEnterLevelCost()
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    return tostring(itemId)
  end
  return (LanguageUtil.GetLocaleText)(itemCfg.name)
end

SectorIIDungeonData.GetDungeonLevelActId = function(self)
  -- function num : 0_9
  return self.__actId
end

SectorIIDungeonData.GetDungeonActName = function(self)
  -- function num : 0_10
  if self.__actInfo == nil then
    return ""
  end
  return (self.__actInfo):GetActivityFrameName()
end

SectorIIDungeonData.GetDungeonLevelOrderName = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__ActivityWinterCfg).level_num)
end

SectorIIDungeonData.GetCommonActDropData = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local sectorIIData = self:GetSectorIIActivityData()
  local pointMultRateDic = sectorIIData:GetSectorII_PointMultRat()
  local rate = self:GetWADunRewardRate()
  local dropDic = {}
  for itemId,itemNumTable in pairs((self.__ActivityWinterCfg).drop_show) do
    dropDic[itemId] = {}
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (dropDic[itemId]).min = itemNumTable.minValue * rate
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R10 in 'UnsetPending'

    if itemNumTable.maxValue ~= nil then
      (dropDic[itemId]).max = itemNumTable.maxValue * rate
    end
    local pointRate = pointMultRateDic[itemId]
    if pointRate ~= nil then
      pointRate = pointRate / 1000
      for key,value in pairs(dropDic[itemId]) do
        -- DECOMPILER ERROR at PC39: Confused about usage of register: R16 in 'UnsetPending'

        (dropDic[itemId])[key] = (math.floor)(value * (pointRate + 1))
      end
    end
  end
  return dropDic
end

SectorIIDungeonData.GetWaveNum = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local battlePlayType = (self.__dungeonStageCfg).play_para
  local playTypeCfgList = (ConfigData.wave_battles)[battlePlayType]
  return #playTypeCfgList
end

SectorIIDungeonData.GetAWDungeonPos = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self.__levelPos ~= nil then
    return self.__levelPos
  end
  if self.__posCfg == nil then
    return Vector2.zero
  end
  self.__levelPos = (Vector2.New)(((self.__posCfg).level_pos)[1], ((self.__posCfg).level_pos)[2])
  return self.__levelPos
end

SectorIIDungeonData.GetSectorIIDun_ChipSuitLimitNum = function(self)
  -- function num : 0_15
  local sectorIIData = self:GetSectorIIActivityData()
  local logicAdd = sectorIIData:GetSectorII_ChipSuitLimitNumAdd()
  local cfgNum = (self.__ActivityWinterCfg).chip_select_max
  return cfgNum + logicAdd
end

SectorIIDungeonData.GetSectorIIActivityData = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.__actId)
  return sectorIIData
end

SectorIIDungeonData.GetDunExtraBuffDic = function(self)
  -- function num : 0_17
  local sectorIIData = self:GetSectorIIActivityData()
  if sectorIIData == nil then
    return nil
  end
  local actBuffUnlockDic = sectorIIData:GetSectorII_UnlockedBuffList()
  return actBuffUnlockDic
end

SectorIIDungeonData.GetDunExtraDelectedBuffDic = function(self)
  -- function num : 0_18
  local sectorIIData = self:GetSectorIIActivityData()
  if sectorIIData == nil then
    return nil
  end
  local actBuffRemoveDic = sectorIIData:GetSectorII_DelectedBuffList()
  return actBuffRemoveDic
end

SectorIIDungeonData.GetCouldShowAutoPlay = function(self)
  -- function num : 0_19
  return true
end

SectorIIDungeonData.GetIsLevelComplete = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local isCompleted = (PlayerDataCenter.dungeonTotalBattleTimes)[self:GetDungeonLevelStageId()] or 0 > 0
  do return isCompleted end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

SectorIIDungeonData.GetIsLevelCompleteNoSup = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local isCompleted = (PlayerDataCenter.dungeonComplectedWhithoutSupport)[self:GetDungeonLevelStageId()] or false
  return isCompleted
end

SectorIIDungeonData.GetWADunRewardRate = function(self)
  -- function num : 0_22
  local sectorIIData = self:GetSectorIIActivityData()
  local isOpenRate = sectorIIData:GetSectorII_IsTurnOnMultEffi()
  if not isOpenRate then
    return 1
  end
  return sectorIIData:GetSectorII_EffiMultRate() + 1
end

SectorIIDungeonData.GetLastCompleteSelectedSuitDic = function(self)
  -- function num : 0_23
  local sectorIIData = self:GetSectorIIActivityData()
  local dunLastSuitDic = sectorIIData:GetLastCompleteDungeonSuitDic()
  local stageId = self:GetDungeonLevelStageId()
  if not dunLastSuitDic[stageId] then
    return {}
  end
end

SectorIIDungeonData.SaveLastCompleteSelectedSuitDic = function(self, suitDic)
  -- function num : 0_24
  local sectorIIData = self:GetSectorIIActivityData()
  local dunLastSuitDic = sectorIIData:GetLastCompleteDungeonSuitDic()
  local stageId = self:GetDungeonLevelStageId()
  dunLastSuitDic[stageId] = suitDic
end

SectorIIDungeonData.GetLastCompleteSelectedFormatId = function(self)
  -- function num : 0_25
  local sectorIIData = self:GetSectorIIActivityData()
  local dunLastFormatIdDic = sectorIIData:GetLastCompleteDungeonFormatIdDic()
  local stageId = self:GetDungeonLevelStageId()
  local formId = dunLastFormatIdDic[stageId] or 1
  if formId == 0 then
    formId = 1
  end
  return formId
end

SectorIIDungeonData.SaveLastCompleteSelectedFormatId = function(self, formatId)
  -- function num : 0_26
  local sectorIIData = self:GetSectorIIActivityData()
  local dunLastFormatIdDic = sectorIIData:GetLastCompleteDungeonFormatIdDic()
  local stageId = self:GetDungeonLevelStageId()
  dunLastFormatIdDic[stageId] = formatId
end

SectorIIDungeonData.GetWADunGropShowDic = function(self)
  -- function num : 0_27
  return (self.__ActivityWinterCfg).drop_show
end

return SectorIIDungeonData

