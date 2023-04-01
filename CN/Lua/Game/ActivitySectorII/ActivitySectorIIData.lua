-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local ActivitySectorIIData = class("ActivitySectorIIData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local ActTechRowData = require("Game.ActivitySectorII.Tech.Data.ActTechRowData")
local ActTechData = require("Game.ActivitySectorII.Tech.Data.ActTechData")
local SectorIIDungeonData = require("Game.ActivitySectorII.Dungeon.Data.SectorIIDungeonData")
local SectorIISectorLevelData = require("Game.ActivitySectorII.MainMap.Data.SectorIISectorLevelData")
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local SectorIIChallengeDgData = require("Game.ActivitySectorII.Dungeon.Data.SectorIIChallengeDgData")
local TaskEnum = require("Game.Task.TaskEnum")
local ActivitySectorIIEnum = require("Game.ActivitySectorII.ActivitySectorIIEnum")
local actType = (ActivityFrameEnum.eActivityType).SectorII
local conditonHeader = {techRow = 100000, tech = 200000}
ActivitySectorIIData.ctor = function(self)
  -- function num : 0_0 , upvalues : ConditionListener
  self.frameActId = nil
  self.actId = nil
  self.actTechType = nil
  self.sectorId = nil
  self.mapDataList = {}
  self.firstLevelData = nil
  self.ActTechDataDic = {}
  self.ActTechRowDataList = {}
  self.DunDataDic = nil
  self.DunOrderList = nil
  self.dunTicketId = nil
  self.actPointId = nil
  self.techId = nil
  self.birdMsg = nil
  self.dunLastSuitDic = nil
  self.dunLastFormatIdDic = nil
  self.sectorIIRedDotRootNode = nil
  self.__conditionListener = (ConditionListener.New)()
end

ActivitySectorIIData.InitActSectorIIData = function(self, actId)
  -- function num : 0_1 , upvalues : base, ActivityFrameEnum, _ENV
  self.actId = actId
  ;
  (base.SetActFrameDataByType)(self, (ActivityFrameEnum.eActivityType).SectorII, actId)
  local activityController = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameId = activityController:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).SectorII, self.actId)
  self.frameActId = frameId
  local sectorIICfg = (ConfigData.activity_winter)[actId]
  self.dunTicketId = sectorIICfg.cost_id
  self.actPointId = sectorIICfg.point
  self.techId = sectorIICfg.point_tech
  self._actWinterCfg = sectorIICfg
  self:InitSectorIIReddot()
  self:RefreshSectorIIReddot4Task()
  self:RefreshSectorIIShopReddot()
  self:GenAWSectorDatas(actId, sectorIICfg)
  self:GenAWTechDatas(actId, sectorIICfg)
  self:GenAWDunDatas(actId, sectorIICfg)
  self:_GenChallengeData()
end

ActivitySectorIIData.OnSectorIIMsgInitOver = function(self)
  -- function num : 0_2 , upvalues : _ENV, conditonHeader
  for actTechId,atcTechData in pairs(self.ActTechDataDic) do
    if not atcTechData:GetIsUnlock() then
      local unlockCfg = atcTechData:GetUnlockCfg()
      ;
      (self.__conditionListener):AddConditionChangeListener(conditonHeader.tech + actTechId, function()
    -- function num : 0_2_0 , upvalues : self
    self:RefreshSectorIIReddot4Tech()
  end
, unlockCfg.pre_condition, unlockCfg.pre_para1, unlockCfg.pre_para2)
    end
  end
end

ActivitySectorIIData.GenAWSectorDatas = function(self, actId, sectorIICfg)
  -- function num : 0_3 , upvalues : _ENV, SectorIISectorLevelData, ExplorationEnum
  self.sectorId = sectorIICfg.main_sector
  local Add2List = function(cfg, isStage)
    -- function num : 0_3_0 , upvalues : _ENV, self, SectorIISectorLevelData
    local mapData = nil
    if isStage then
      local stageExtra = ((ConfigData.activity_winter_sector_stage_extra)[self.sectorId])[cfg.id]
      mapData = (SectorIISectorLevelData.CreateSectorIIEpLevelData)(self.sectorId, cfg, stageExtra)
    else
      do
        do
          local avgExtrCfg = ((ConfigData.activity_winter_sector_story_extra)[self.sectorId])[cfg.id]
          mapData = (SectorIISectorLevelData.CreateSectorIIStoryLevelData)(self.sectorId, cfg, avgExtrCfg)
          ;
          (table.insert)(self.mapDataList, mapData)
          return mapData
        end
      end
    end
  end

  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[self.sectorId])[(ExplorationEnum.eDifficultType).Normal]
  local lastLevelData = nil
  local levelMapDic = {}
  for _,stageId in ipairs(sectorStageCfg) do
    local stage = (ConfigData.sector_stage)[stageId]
    local levelMapData = Add2List(stage, true)
    local isIsolated = (((ConfigData.activity_winter_sector_stage_extra)[self.sectorId])[stageId]).is_isolated
    if levelMapData ~= nil then
      levelMapDic[stageId] = levelMapData
      -- DECOMPILER ERROR at PC44: Unhandled construct in 'MakeBoolean' P1

      if not isIsolated and lastLevelData ~= nil then
        levelMapData:AddAParentSIILevel(lastLevelData)
        lastLevelData:AddAChildSIILevel(levelMapData)
      end
      lastLevelData = levelMapData
    end
  end
  self.firstLevelData = (self.mapDataList)[1]
  for _,stageId in ipairs(sectorStageCfg) do
    local levelMapData = levelMapDic[stageId]
    if levelMapData ~= nil then
      local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
      for i = 0, para2num - 1 do
        local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
        if avgCfg ~= nil then
          local preLevelMapData = Add2List(avgCfg, false)
          if preLevelMapData ~= nil then
            levelMapData:SwiftParent2SIILevel(preLevelMapData)
            levelMapData:AddAParentSIILevel(preLevelMapData)
            preLevelMapData:AddAChildSIILevel(levelMapData)
            if self.firstLevelData == levelMapData then
              self.firstLevelData = preLevelMapData
            end
          end
        end
      end
      local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
      for i = 0, para2num - 1 do
        local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
        if avgCfg ~= nil then
          local afterLevelMapData = Add2List(avgCfg, false)
          if afterLevelMapData ~= nil then
            local childList = levelMapData:GetSIILevelChildList()
            if childList ~= nil then
              for _,chidLevelData in pairs(levelMapData:GetSIILevelChildList()) do
                chidLevelData:ReplaceSIILevelParent(levelMapData, afterLevelMapData)
                afterLevelMapData:AddAChildSIILevel(chidLevelData)
              end
            end
            do
              do
                afterLevelMapData:AddAParentSIILevel(levelMapData)
                levelMapData:CleanSIILevelChildList()
                levelMapData:AddAChildSIILevel(afterLevelMapData)
                -- DECOMPILER ERROR at PC147: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC147: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC147: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC147: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC147: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
  local storyExtrCfgDic = (ConfigData.activity_winter_sector_story_extra)[self.sectorId]
  if storyExtrCfgDic ~= nil then
    for story_id,cfg in pairs(storyExtrCfgDic) do
      if cfg.is_isolated then
        local avgCfg = (ConfigData.story_avg)[story_id]
        if avgCfg ~= nil then
          local afterLevelMapData = Add2List(avgCfg, false)
        end
      end
    end
  end
  do
    self:RefreshSectorIIReddot4Avg()
  end
end

ActivitySectorIIData.RefreshAWSectorLevelState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for _,levelData in pairs(self.mapDataList) do
    levelData:RefreshSIILevelState()
  end
end

ActivitySectorIIData.GenAWTechDatas = function(self, actId, sectorIICfg)
  -- function num : 0_5 , upvalues : _ENV, ActTechData, actType, ActTechRowData, conditonHeader
  local actTechType = sectorIICfg.activity_tech_type
  self.actTechType = actTechType
  local actTechTypeInfo = ((ConfigData.activity_tech).actTechTypeList)[actTechType]
  for index,actTechId in ipairs(actTechTypeInfo.techIds) do
    local atcTechData = (ActTechData.CreatAWTechData)(actTechId, actType, self.actId)
    do
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R11 in 'UnsetPending'

      (self.ActTechDataDic)[actTechId] = atcTechData
    end
  end
  for actTechId,atcTechData in pairs(self.ActTechDataDic) do
    local previousTech = atcTechData:GetPreTechId()
    if previousTech ~= nil then
      atcTechData:SetPreTechData((self.ActTechDataDic)[previousTech])
    end
  end
  for rowId,techIdList in pairs(actTechTypeInfo.techRowIdDic) do
    local techDataDic = {}
    for _,actTechId in pairs(techIdList) do
      techDataDic[actTechId] = (self.ActTechDataDic)[actTechId]
    end
    local lineData = (ActTechRowData.CreateTechRowData)(rowId, techDataDic)
    ;
    (table.insert)(self.ActTechRowDataList, lineData)
    if lineData:GetIsHaveTechAvg() and not lineData:GetIsTechAvgCompleted() then
      local avgCfg = lineData:GetIsTechAvgCfg()
      ;
      (self.__conditionListener):AddConditionChangeListener(conditonHeader.techRow + rowId, function()
    -- function num : 0_5_0 , upvalues : lineData, self
    lineData:RefreshTechAvgState()
    self:RefreshSectorIIReddot4TechAvg()
  end
, avgCfg.pre_condition, avgCfg.pre_para1, avgCfg.pre_para2)
    end
  end
  ;
  (table.sort)(self.ActTechRowDataList, function(a, b)
    -- function num : 0_5_1
    local aOrder = a:GetRowOrder()
    local bOrder = b:GetRowOrder()
    do return aOrder < bOrder end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self:RefreshSectorIIReddot4Tech()
  self:RefreshSectorIIReddot4TechAvg()
end

ActivitySectorIIData.GenAWDunDatas = function(self, actId, sectorIICfg)
  -- function num : 0_6 , upvalues : _ENV, SectorIIDungeonData
  self.DunDataDic = {}
  local actDungeonLevelType = sectorIICfg.level_type
  local levelTypeCfg = ((ConfigData.activity_winter_level_type)[actId])[actDungeonLevelType]
  local posType = levelTypeCfg.pos_id
  self.DunOrderList = levelTypeCfg.dungeon_levels
  for index,dunStageId in ipairs(self.DunOrderList) do
    local extraCfg = (ConfigData.activity_winter_dungeon_detail)[dunStageId]
    local posCfg = ((ConfigData.activity_winter_level_pos)[posType])[index]
    local dungeonData = (SectorIIDungeonData.New)(dunStageId, self.actInfo, index)
    dungeonData:SetSectorIIDungeonExtraData(posCfg, extraCfg)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (self.DunDataDic)[dunStageId] = dungeonData
  end
end

ActivitySectorIIData._GenChallengeData = function(self)
  -- function num : 0_7 , upvalues : _ENV, SectorIIChallengeDgData
  local sectorIICfg = self:GetActvWinterCfg()
  local lvTypeCfg = ((ConfigData.activity_winter_level_type)[sectorIICfg.id])[sectorIICfg.hard_level_type]
  if #lvTypeCfg.dungeon_levels == 0 then
    error("Cant gen ChallengeData")
    return 
  end
  local dungeonId = (lvTypeCfg.dungeon_levels)[1]
  self._challengeDnData = (SectorIIChallengeDgData.New)(dungeonId, self)
end

ActivitySectorIIData.UpdSctIIWinChallengeData = function(self, msgVerify)
  -- function num : 0_8
  (self._challengeDnData):UpdSctIIChallengeDgData(msgVerify)
end

ActivitySectorIIData.GetActvWinChallengeDgData = function(self)
  -- function num : 0_9
  return self._challengeDnData
end

ActivitySectorIIData.GetActvWinterCfg = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (ConfigData.activity_winter)[self.actId]
end

ActivitySectorIIData.RefreshAWTechDatas = function(self, techMsg)
  -- function num : 0_11 , upvalues : _ENV
  if techMsg ~= nil then
    for techId,activityTechElem in pairs(techMsg.techData) do
      local techData = (self.ActTechDataDic)[techId]
      techData:UpdateWATechByMsg(activityTechElem)
    end
  end
  do
    self:RefreshSectorIIReddot4Tech()
    return self.ActTechDataDic
  end
end

ActivitySectorIIData.RefreshAWTechData = function(self, activityTechElem)
  -- function num : 0_12
  local techId = activityTechElem.id
  local techData = self:GetTechById(techId)
  if techData ~= nil then
    techData:UpdateWATechByMsg(activityTechElem)
  end
  self:RefreshSectorIIReddot4Tech()
  return techData
end

ActivitySectorIIData.SetSectorIIBirdData = function(self, birdMsg)
  -- function num : 0_13
  self.birdMsg = birdMsg
end

ActivitySectorIIData.SetSectorIIDungeonSuitData = function(self, dungeonSuits)
  -- function num : 0_14 , upvalues : _ENV
  self.dunLastSuitDic = {}
  self.dunLastFormatIdDic = {}
  for _,dungeonSuitElem in ipairs(dungeonSuits) do
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

    (self.dunLastSuitDic)[dungeonSuitElem.dungoenId] = dungeonSuitElem.suit
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.dunLastFormatIdDic)[dungeonSuitElem.dungoenId] = dungeonSuitElem.formId
  end
end

ActivitySectorIIData.GetSectorIITechRowDataList = function(self)
  -- function num : 0_15
  return self.ActTechRowDataList
end

ActivitySectorIIData.GetSectorIIDungeonDataDic = function(self)
  -- function num : 0_16
  return self.DunDataDic, self.DunOrderList
end

ActivitySectorIIData.GetSectorIIActFrameId = function(self)
  -- function num : 0_17
  return self.frameActId
end

ActivitySectorIIData.GetSectorIIActId = function(self)
  -- function num : 0_18
  return self.actId
end

ActivitySectorIIData.GetSectorIISectorId = function(self)
  -- function num : 0_19
  return self.sectorId
end

ActivitySectorIIData.GetSectorIISectorMapDataList = function(self)
  -- function num : 0_20
  return self.mapDataList
end

ActivitySectorIIData.GetSectorIISectorMapNeedFocusData = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local firstLevelParentlist = (self.firstLevelData):GetSIILevelParentList()
  if firstLevelParentlist ~= nil and (table.count)(firstLevelParentlist) > 0 then
    error("not actually first level")
  end
  local FindFirstNotPlayLevel = function(levelData)
    -- function num : 0_21_0 , upvalues : _ENV, FindFirstNotPlayLevel
    if levelData:GetIsLevelUnlock() and not levelData:GetIsLevelClaer() then
      return levelData
    end
    local childList = levelData:GetSIILevelChildList()
    if childList ~= nil then
      for _,childLevelData in pairs(childList) do
        local answer = FindFirstNotPlayLevel(childLevelData)
        if answer ~= nil then
          return answer
        end
      end
    end
  end

  return FindFirstNotPlayLevel(self.firstLevelData)
end

ActivitySectorIIData.GetSectorIIDunTicketId = function(self)
  -- function num : 0_22
  return self.dunTicketId
end

ActivitySectorIIData.GetSectorIIDunPointId = function(self)
  -- function num : 0_23
  return self.actPointId
end

ActivitySectorIIData.GetTechId = function(self)
  -- function num : 0_24
  return self.techId
end

ActivitySectorIIData.GetSectorIITokenId = function(self)
  -- function num : 0_25
  return (self._actWinterCfg).token
end

ActivitySectorIIData.GetSectorIIIShopList = function(self)
  -- function num : 0_26
  return (self._actWinterCfg).shop_list
end

ActivitySectorIIData.GetSectorIIReprintShopId = function(self)
  -- function num : 0_27
  return (self._actWinterCfg).remaster_store_jump
end

ActivitySectorIIData.GetSectorIIReprintShopIcon = function(self)
  -- function num : 0_28
  return (self._actWinterCfg).remaster_store_jump_icon
end

ActivitySectorIIData.GetActivityFrameData = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local activityController = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityController:GetActivityFrameData(self.frameActId)
  return activityFrameData
end

ActivitySectorIIData.GetSectorIIActivityTaskList = function(self)
  -- function num : 0_30
  return (self._actWinterCfg).task_list
end

ActivitySectorIIData.GetTechById = function(self, techId)
  -- function num : 0_31
  return (self.ActTechDataDic)[techId]
end

ActivitySectorIIData.GetSectorIIFlappyBirdId = function(self)
  -- function num : 0_32 , upvalues : _ENV
  if self.birdMsg == nil then
    error("not get birdMsg")
  end
  return (self.birdMsg).birdId
end

ActivitySectorIIData.GetSectorIIFlappyBirdMineMaxScore = function(self)
  -- function num : 0_33 , upvalues : _ENV
  if self.birdMsg == nil then
    error("not get birdMsg")
  end
  return (self.birdMsg).highestScore
end

ActivitySectorIIData.SetSectorIIFlappyBirdMineMaxScore = function(self, score)
  -- function num : 0_34 , upvalues : _ENV
  if self.birdMsg == nil then
    error("not get birdMsg")
  end
  if score or 0 < (self.birdMsg).highestScore then
    warn("highest score not above current highest score")
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.birdMsg).highestScore = score
end

ActivitySectorIIData.GetSectorIIFlappyBirdIsJoinRewards = function(self)
  -- function num : 0_35 , upvalues : _ENV
  if self.birdMsg == nil then
    error("not get birdMsg")
  end
  return (self.birdMsg).joinRewards
end

ActivitySectorIIData.SetSectorIIFlappyBirdIsJoinRewards = function(self, bool)
  -- function num : 0_36 , upvalues : _ENV
  if self.birdMsg == nil then
    error("not get birdMsg")
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.birdMsg).joinRewards = bool
end

ActivitySectorIIData.GetLastCompleteDungeonSuitDic = function(self)
  -- function num : 0_37
  return self.dunLastSuitDic
end

ActivitySectorIIData.GetLastCompleteDungeonFormatIdDic = function(self)
  -- function num : 0_38
  return self.dunLastFormatIdDic
end

ActivitySectorIIData.GetBeDefeatJumpList = function(self)
  -- function num : 0_39
  return (self._actWinterCfg).defeat_jump
end

ActivitySectorIIData.GetSectorIIFirstEnterAvgId = function(self)
  -- function num : 0_40
  return (self._actWinterCfg).first_avg
end

ActivitySectorIIData.GetSectorIIStoreInfo = function(self)
  -- function num : 0_41
  return (self._actWinterCfg).remaster_store_info
end

ActivitySectorIIData.GetSectorIIActivityIsRemaster = function(self)
  -- function num : 0_42
  do return (self._actWinterCfg).remaster_id ~= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySectorIIData.GetSectorII_ChipSuitLimitNumAdd = function(self)
  -- function num : 0_43 , upvalues : _ENV
  local logicAdd = (PlayerDataCenter.playerBonus):Get_Activity_ChipGroupCarryLimitAdd(self.frameActId)
  return logicAdd
end

ActivitySectorIIData.GetSectorII_ChipSuitPool = function(self)
  -- function num : 0_44 , upvalues : _ENV
  local chipPoolQualityDic = (PlayerDataCenter.playerBonus):Get_Activity_ChipGroupLevel(self.frameActId)
  local chipPoolList = {}
  for chipPoolId,quality in pairs(chipPoolQualityDic) do
    (table.insert)(chipPoolList, chipPoolId)
  end
  return chipPoolList, chipPoolQualityDic
end

ActivitySectorIIData.GetSectorII_Wait4UnlockChipSuit = function(self)
  -- function num : 0_45 , upvalues : _ENV
  local chipPoolQualityDic = (PlayerDataCenter.playerBonus):Get_Activity_ChipGroupLevel(self.frameActId)
  local thisActCouldUseChipSuitDic = ((ConfigData.activity_tech).couldUnlockChipSuitDic)[self.frameActId]
  local wait4UnlockChipSuitList = {}
  local wait4UnlockChipSuitUnlockInfoList = {}
  for chipSuitId,techId in pairs(thisActCouldUseChipSuitDic) do
    if chipPoolQualityDic[chipSuitId] == nil then
      (table.insert)(wait4UnlockChipSuitList, chipSuitId)
      local techData = (self.ActTechDataDic)[techId]
      ;
      (table.insert)(wait4UnlockChipSuitUnlockInfoList, {index = 0, str = techData:GetAWTechName()})
    end
  end
  return wait4UnlockChipSuitList, wait4UnlockChipSuitUnlockInfoList
end

ActivitySectorIIData.GetSectorII_PointMultRat = function(self)
  -- function num : 0_46 , upvalues : _ENV
  local itemRateDic = (PlayerDataCenter.playerBonus):Get_Activity_PointMultRate(self.frameActId)
  return itemRateDic
end

ActivitySectorIIData.GetSectorII_EffiMultRate = function(self)
  -- function num : 0_47 , upvalues : _ENV
  local rate = (PlayerDataCenter.playerBonus):Get_Activity_EffiMultRate(self.frameActId)
  return rate
end

ActivitySectorIIData.GetSectorII_IsTurnOnMultEffi = function(self)
  -- function num : 0_48 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  return saveUserData:GetSectorIIIsTurnOnMultEfficient(self.actId)
end

ActivitySectorIIData.SetSectorII_IsTurnOnMultEffi = function(self, bool)
  -- function num : 0_49 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetSectorIIIsTurnOnMultEfficient(self.actId, bool)
end

ActivitySectorIIData.GetSectorII_UnlockedBuffList = function(self)
  -- function num : 0_50 , upvalues : _ENV
  local actBuffUnlockDic = (PlayerDataCenter.playerBonus):Get_Activity_UnlockBuff(self.frameActId)
  return actBuffUnlockDic
end

ActivitySectorIIData.GetSectorII_DelectedBuffList = function(self)
  -- function num : 0_51 , upvalues : _ENV
  local actBuffDelectDic = (PlayerDataCenter.playerBonus):Get_Activity_DeleteBuff(self.frameActId)
  return actBuffDelectDic
end

ActivitySectorIIData.InitSectorIIReddot = function(self)
  -- function num : 0_52 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, actSingleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle)
  if isOk then
    self.sectorIIRedDotRootNode = actSingleNode:AddChild(self.frameActId)
    ;
    (self.sectorIIRedDotRootNode):AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIIavg)
    ;
    (self.sectorIIRedDotRootNode):AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIITask)
    ;
    (self.sectorIIRedDotRootNode):AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).dungeon)
    local techRootNode = (self.sectorIIRedDotRootNode):AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techRoot)
    techRootNode:AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).tech)
    techRootNode:AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techAvg)
    ;
    (self.sectorIIRedDotRootNode):AddChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).recommendShop)
  else
    do
      error("can\'t get ActivitySingle node")
    end
  end
end

ActivitySectorIIData.RefreshSectorIIReddotWhenActEnd = function(self)
  -- function num : 0_53
  self:RefreshSectorIIReddot4Avg()
  self:RefreshSectorIIReddot4Dundeon()
  self:RefreshSectorIIReddot4Tech()
  self:RefreshSectorIIReddot4TechAvg()
end

ActivitySectorIIData.RefreshSectorIIReddot4Avg = function(self)
  -- function num : 0_54 , upvalues : _ENV, ActivitySectorIIEnum
  local notClearAvgNum = 0
  if self:IsActivityRunning() then
    for _,levelData in pairs(self.mapDataList) do
      if not levelData:GetIsBattle() and levelData:GetIsLevelUnlock() and not levelData:GetIsLevelClaer() then
        notClearAvgNum = notClearAvgNum + 1
        break
      end
    end
  end
  do
    self:SetSectorIIReddot((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIIavg, notClearAvgNum)
  end
end

ActivitySectorIIData.RefreshSectorIIReddot4Dundeon = function(self)
  -- function num : 0_55 , upvalues : _ENV, ActivitySectorIIEnum
  local num = 0
  if self:IsActivityRunning() then
    for dunStageId,sectorIIDungeonData in pairs(self.DunDataDic) do
      if sectorIIDungeonData:GetIsLevelUnlock() and not sectorIIDungeonData:GetIsLevelComplete() then
        num = num + 1
        break
      end
    end
  end
  do
    self:SetSectorIIReddot((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).dungeon, num)
  end
end

ActivitySectorIIData.RefreshSectorIIReddot4Task = function(self)
  -- function num : 0_56 , upvalues : _ENV, ActivitySectorIIEnum
  local num = 0
  local taskList = self:GetSectorIIActivityTaskList()
  for _,taskId in pairs(taskList) do
    local taskData = ((PlayerDataCenter.allTaskData).taskDatas)[taskId]
    if taskData ~= nil and taskData:CheckComplete() then
      num = num + 1
      break
    end
  end
  do
    self:SetSectorIIReddot((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIITask, num)
  end
end

ActivitySectorIIData.RefreshSectorIIReddot4Tech = function(self)
  -- function num : 0_57 , upvalues : _ENV, ActivitySectorIIEnum
  local num = 0
  if self:IsActivityRunning() then
    for techId,techData in pairs(self.ActTechDataDic) do
      if techData:IsCouldLevelUp() then
        num = num + 1
        break
      end
    end
  end
  do
    local reddotNode = (self.sectorIIRedDotRootNode):GetChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techRoot)
    local techNode = reddotNode:GetChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).tech)
    techNode:SetRedDotCount(num)
  end
end

ActivitySectorIIData.RefreshSectorIIReddot4TechAvg = function(self)
  -- function num : 0_58 , upvalues : _ENV, ActivitySectorIIEnum
  local num = 0
  if self:IsActivityRunning() then
    for techId,techRowData in pairs(self.ActTechRowDataList) do
      if techRowData:GetIsTechAvgUnlock() and not techRowData:GetIsTechAvgCompleted() then
        num = num + 1
        break
      end
    end
  end
  do
    local reddotNode = (self.sectorIIRedDotRootNode):GetChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techRoot)
    local avgNode = reddotNode:GetChild((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).techAvg)
    avgNode:SetRedDotCount(num)
  end
end

ActivitySectorIIData.RefreshSectorIIShopReddot = function(self)
  -- function num : 0_59 , upvalues : _ENV, ActivitySectorIIEnum
  local num = 0
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local shopList = self:GetSectorIIIShopList()
  for _,shopId in pairs(shopList) do
    local isLooked = saveUserData:GetSectorIIRecommendShopIsLooked(shopId)
    do
      if not isLooked then
        local shopCfg = (ConfigData.shop)[shopId]
        local isRecommend = shopCfg.is_recommended
        local isHaveRecommendGood = nil
        do
          if not isRecommend then
            local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
            shopCtrl:GetShopData(shopId, function(shopData)
    -- function num : 0_59_0 , upvalues : _ENV, isHaveRecommendGood
    for shelfId,goodData in pairs(shopData.shopGoodsDic) do
      if goodData.isRecommendGood and not goodData.isSoldOut then
        isHaveRecommendGood = true
        break
      end
    end
  end
, true)
          end
          if isRecommend or isHaveRecommendGood then
            num = num + 1
            break
          end
        end
      end
      do
        -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  self:SetSectorIIReddot((ActivitySectorIIEnum.eActSectorIIRedDotTypeId).recommendShop, num)
end

ActivitySectorIIData.SetSectorIIReddot = function(self, typeId, num)
  -- function num : 0_60
  local reddotNode = (self.sectorIIRedDotRootNode):GetChild(typeId)
  reddotNode:SetRedDotCount(num)
end

ActivitySectorIIData.OffsetSectorIIReddot = function(self, typeId, offsetNum)
  -- function num : 0_61
  local reddotNode = (self.sectorIIRedDotRootNode):GetChild(typeId)
  reddotNode:OffsetRedDotCount(offsetNum)
end

ActivitySectorIIData.__IsHaveReadDot = function(self)
  -- function num : 0_62 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, taskReddotNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.frameActId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).sectorIITask)
  if taskReddotNode:GetRedDotCount() <= 0 then
    do return not isOk end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

ActivitySectorIIData.GetActivityReddotNum = function(self)
  -- function num : 0_63
  local isBlue, num = nil, nil
  isBlue = not self:__IsHaveReadDot()
  num = (self.sectorIIRedDotRootNode):GetRedDotCount()
  return isBlue, num
end

ActivitySectorIIData.Delete = function(self)
  -- function num : 0_64
  (self.__conditionListener):Delete()
end

return ActivitySectorIIData

