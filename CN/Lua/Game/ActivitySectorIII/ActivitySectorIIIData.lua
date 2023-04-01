-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivitySectorIIIData = class("ActivitySectorIIIData", ActivityBase)
local SectorIIISectorLevelData = require("Game.ActivitySectorIII.SectorIIISectorLevelData")
local ActivitySectorIIIDungeonData = require("Game.ActivitySectorIII.ActivitySectorIIIDungeonData")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ActivitySectorIIIEnum = require("Game.ActivitySectorIII.ActivitySectorIIIEnum")
local GameSnakeData = require("Game.TinyGames.Snake.GameSnakeData")
local ActTechData = require("Game.ActivitySectorII.Tech.Data.ActTechData")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).SectorIII
local TinyGameEnum = require("Game.TinyGames.TinyGameEnum")
ActivitySectorIIIData.InitSectorIIIData = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV, GameSnakeData, TinyGameEnum
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_summer_main)[msg.actId]
  self._refreshTimes = 0
  self._expireTime = 0
  self._techRefTimes = 0
  self._techDataDic = {}
  self._taskIdList = {}
  self._farmDouble = false
  self._hardDungeonScore = {}
  self._dunTicketId = (self._mainCfg).ticket_item
  self._actPointId = (self._mainCfg).tech_item
  self._gameSnake = (GameSnakeData.New)(msg.gameUid, (self._mainCfg).game_snake, (TinyGameEnum.eType).snake)
  self:__GenSectorDatas()
  self:__GenDungeonData()
  self:InitSect3TechData()
  self:UpdateSectorIIIData(msg)
end

ActivitySectorIIIData.UpdateSectorIIIData = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  (table.removeall)(self._taskIdList)
  ;
  (table.insertto)(self._taskIdList, (msg.quest).ids)
  self._expireTime = (msg.quest).expiredTm
  self._refreshTimes = (msg.quest).refreshCnt
  self._farmDouble = msg.farmDouble
  self._hardDungeonScore = msg.hardDungeonScore
  self:_UpdateTech(msg.tech)
  self:_SetSum22TechNextRefreshTime((msg.tech).nextRefreshTime)
  self:RefreshSectorIIITaskReddot()
  self:RefreshSectorIIIMapReddot()
end

ActivitySectorIIIData.__GenSectorDatas = function(self)
  -- function num : 0_2 , upvalues : _ENV, SectorIIISectorLevelData, ExplorationEnum
  local sectorId = (self._mainCfg).main_sector
  self._mapDataList = {}
  local isolatedDataList = {}
  local firstLevel = nil
  local Add2List = function(cfg, isStage)
    -- function num : 0_2_0 , upvalues : _ENV, sectorId, SectorIIISectorLevelData, firstLevel
    local mapData = nil
    if isStage then
      local stageExtra = ((ConfigData.activity_summer_warchess_pos)[sectorId])[cfg.id]
      mapData = (SectorIIISectorLevelData.CreateSectorIIIEPLevelData)(sectorId, cfg, stageExtra)
    else
      do
        do
          local avgExtra = ((ConfigData.activity_summer_warchess_story_pos)[sectorId])[cfg.id]
          mapData = (SectorIIISectorLevelData.CreateSectorIIIStoryLevelData)(sectorId, cfg, avgExtra)
          if firstLevel == nil then
            firstLevel = mapData
          end
          return mapData
        end
      end
    end
  end

  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(ExplorationEnum.eDifficultType).Normal]
  local lastLevelData = nil
  local levelMapDic = {}
  for _,stageId in ipairs(sectorStageCfg) do
    local stage = (ConfigData.sector_stage)[stageId]
    local levelMapData = Add2List(stage, true)
    local isIsolated = (((ConfigData.activity_summer_warchess_pos)[sectorId])[stageId]).is_isolated
    if levelMapData ~= nil then
      levelMapDic[stageId] = levelMapData
      if lastLevelData ~= nil then
        levelMapData:AddAParentSIILevel(lastLevelData)
        lastLevelData:AddAChildSIILevel(levelMapData)
      end
      lastLevelData = levelMapData
    end
  end
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
            if self._firstLevelData == levelMapData then
              self._firstLevelData = preLevelMapData
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
                -- DECOMPILER ERROR at PC144: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC144: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC144: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC144: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC144: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
  ;
  (table.insert)(self._mapDataList, firstLevel)
  local curLevelData = firstLevel
  do
    while curLevelData ~= nil do
      local preList = curLevelData:GetSIILevelParentList()
      curLevelData = preList ~= nil and preList[1] or nil
      if curLevelData ~= nil then
        (table.insert)(self._mapDataList, 1, curLevelData)
      end
    end
    curLevelData = firstLevel
    do
      while curLevelData ~= nil do
        local lastList = curLevelData:GetSIILevelChildList()
        curLevelData = lastList ~= nil and lastList[1] or nil
        if curLevelData ~= nil then
          (table.insert)(self._mapDataList, curLevelData)
        end
      end
      ;
      (table.insertto)(self._mapDataList, isolatedDataList)
    end
  end
end

ActivitySectorIIIData.__GenDungeonData = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivitySectorIIIDungeonData
  self._dungeonDataDic = {}
  self._dungeonIdList = (ConfigData.activity_summer_level_detail).level_list
  for index,dunStageId in pairs(self._dungeonIdList) do
    local extraCfg = (ConfigData.activity_summer_level_detail)[dunStageId]
    local dungeonData = (ActivitySectorIIIDungeonData.New)(dunStageId, self.actInfo, index)
    dungeonData:SetSectorIIDungeonExtraData(nil, extraCfg)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self._dungeonDataDic)[dunStageId] = dungeonData
  end
end

ActivitySectorIIIData.ReqCommitSectorIIITask = function(self, taskData, callback)
  -- function num : 0_4 , upvalues : _ENV
  local actNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actNetwork:CS_Activity_Quest_Commit(self:GetActFrameId(), taskData.id, callback)
end

ActivitySectorIIIData.ReqChangeSectorIIITask = function(self, taskId, callback)
  -- function num : 0_5 , upvalues : _ENV
  local sectorIIINetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivitySectorIII)
  sectorIIINetwork:CS_ACTIVITY_Summer2022_RefreshQuest(self:GetActId(), taskId, callback)
end

ActivitySectorIIIData.RefreshSectorIIITaskReddot = function(self)
  -- function num : 0_6 , upvalues : ActivitySectorIIIEnum, _ENV
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    return 
  end
  local taskRed = actRedDotNode:AddChild((ActivitySectorIIIEnum.eActRedDotTypeId).task)
  if self:IsActivityRunning() then
    for _,taskId in ipairs(self._taskIdList) do
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        taskRed:SetRedDotCount(1)
        return 
      end
    end
  end
  do
    taskRed:SetRedDotCount(0)
  end
end

ActivitySectorIIIData.RefreshSectorIIIMapReddot = function(self)
  -- function num : 0_7 , upvalues : ActivitySectorIIIEnum, _ENV
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    return 
  end
  local mapRed = actRedDotNode:AddChild((ActivitySectorIIIEnum.eActRedDotTypeId).map)
  if self:IsActivityRunning() then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    for i,data in ipairs(self._mapDataList) do
      if not data:GetIsBattle() and avgPlayCtrl:IsAvgUnlock(data.avgId) and not avgPlayCtrl:IsAvgPlayed(data.avgId) then
        mapRed:SetRedDotCount(1)
        return 
      end
    end
  end
  do
    mapRed:SetRedDotCount(0)
  end
end

ActivityBase.GetActivityReddotNum = function(self)
  -- function num : 0_8 , upvalues : _ENV, ActivitySectorIIIEnum
  local actRedDotNode = self:GetActivityReddot()
  if actRedDotNode == nil then
    error("can\'t get activity reddot node")
    return true, 0
  end
  for reddotType,_ in pairs(ActivitySectorIIIEnum.eActRedDotIsRedType) do
    local childNode = actRedDotNode:GetChild(reddotType)
    if childNode ~= nil and childNode:GetRedDotCount() > 0 then
      return false, actRedDotNode:GetRedDotCount()
    end
  end
  return true, actRedDotNode:GetRedDotCount()
end

ActivitySectorIIIData.GetSectorIIIMainCfg = function(self)
  -- function num : 0_9
  return self._mainCfg
end

ActivitySectorIIIData.GetActSectorIIIExpireTime = function(self)
  -- function num : 0_10
  return self._expireTime
end

ActivitySectorIIIData.GetActSectorIIIHardDungeonScore = function(self)
  -- function num : 0_11
  return self._hardDungeonScore
end

ActivitySectorIIIData._SetSum22TechNextRefreshTime = function(self, ts)
  -- function num : 0_12
  self._techNextRefreshTime = ts
  self:UpdActSum22TechRedDot()
end

ActivitySectorIIIData.GetSum22TechNextRefreshTime = function(self)
  -- function num : 0_13
  return self._techNextRefreshTime
end

ActivitySectorIIIData.SetActSum22TechSelectEntered = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local userdata = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local lastTs = userdata:SetSum22SelectTechLastEnterRefreshTs(self:GetActId(), self._techNextRefreshTime)
  self:UpdActSum22TechRedDot()
end

ActivitySectorIIIData.UpdActSum22TechRedDot = function(self)
  -- function num : 0_15 , upvalues : ActivitySectorIIIEnum, _ENV
  local actReddot = self:GetActivityReddot()
  if actReddot == nil then
    return 
  end
  local techSelectNode = actReddot:AddChild((ActivitySectorIIIEnum.eActRedDotTypeId).tech)
  if not self:IsActivityRunning() then
    techSelectNode:SetRedDotCount(0)
    return 
  end
  local userdata = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local lastTs = userdata:GetSum22SelectTechLastEnterRefreshTs(self:GetActId())
  local showRedDot = self._techNextRefreshTime ~= lastTs
  local showDotNum = (self._mainCfg).point_tech_number
  showRedDot = showRedDot or showDotNum < PlayerDataCenter:GetItemCount(self._actPointId)
  if #self:GetActSum22TechSelectIdList() == 0 then
    showRedDot = false
  end
  techSelectNode:SetRedDotCount(showRedDot and 1 or 0)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

ActivitySectorIIIData.GetActSct3TechType = function(self)
  -- function num : 0_16
  return (self._mainCfg).tech_id
end

ActivitySectorIIIData.GetSum22TechDesSrotList = function(self)
  -- function num : 0_17
  return (self._mainCfg).tech_des_sort
end

ActivitySectorIIIData.InitSect3TechData = function(self)
  -- function num : 0_18 , upvalues : _ENV, ActTechData, CurActType
  local techType = self:GetActSct3TechType()
  local techTypeCfg = ((ConfigData.activity_tech).actTechTypeList)[techType]
  if techTypeCfg == nil then
    error("activity tech type is NIL,type is " .. tostring(techType))
  end
  local genTechFunc = function(techId)
    -- function num : 0_18_0 , upvalues : self, ActTechData, CurActType
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    if not (self._techDataDic)[techId] then
      (self._techDataDic)[techId] = (ActTechData.CreatAWTechData)(techId, CurActType, self:GetActId())
      return (self._techDataDic)[techId]
    end
  end

  for _,techId in ipairs(techTypeCfg.techIds) do
    local techData = genTechFunc(techId)
    local previousTechId = techData:GetPreTechId()
    if previousTechId ~= nil then
      local previousTech = genTechFunc(previousTechId)
      techData:SetPreTechData(previousTech)
    end
  end
end

ActivitySectorIIIData._UpdateTech = function(self, techMsg)
  -- function num : 0_19 , upvalues : _ENV
  if techMsg == nil then
    return 
  end
  for techId,singleMsg in pairs(techMsg.techData) do
    local techData = (self._techDataDic)[techId]
    if techData == nil then
      error("techData == nil, techId:" .. tostring(techId))
    else
      local oldLevel = techData:GetCurLevel()
      techData:UpdateWATechByMsg(singleMsg)
      local curLevel = techData:GetCurLevel()
      if oldLevel ~= curLevel then
        self:Sum22TechLevelUpInstallBonus(techData, oldLevel, curLevel)
      end
    end
  end
  self._refreshTechIdList = techMsg.refreshTechId
  self._refreshTechNum = techMsg.refreshNum
end

ActivitySectorIIIData.Sum22TechLevelUpInstallBonus = function(self, techData, oldLevel, curLevel)
  -- function num : 0_20 , upvalues : _ENV
  local techId = techData:GetTechId()
  if oldLevel > 0 then
    local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(oldLevel)
    for index,logic in ipairs(logicArray) do
      local para1 = para1Array[index]
      local para2 = para2Array[index]
      local para3 = para3Array[index]
      ;
      (PlayerDataCenter.playerBonus):UninstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, techId, logic, para1, para2, para3)
    end
  end
  do
    local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(curLevel)
    for index,logic in ipairs(logicArray) do
      local para1 = para1Array[index]
      local para2 = para2Array[index]
      local para3 = para3Array[index]
      ;
      (PlayerDataCenter.playerBonus):InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_ActivityWinter, techId, logic, para1, para2, para3)
    end
  end
end

ActivitySectorIIIData.GetActSum22TechRefreshNum = function(self)
  -- function num : 0_21
  return self._refreshTechNum or 0
end

ActivitySectorIIIData.GetActSum22TechSelectIdList = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if not self._refreshTechIdList then
    return table.emptytable
  end
end

ActivitySectorIIIData.GetSectorIIITechDic = function(self)
  -- function num : 0_23
  return self._techDataDic
end

ActivitySectorIIIData.GetSum22TechDataById = function(self, techId)
  -- function num : 0_24
  return (self._techDataDic)[techId]
end

ActivitySectorIIIData.GenSectorIIITechList = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local list = {}
  for k,v in pairs(self._techDataDic) do
    (table.insert)(list, v)
  end
  return list
end

ActivitySectorIIIData.GetSectorIIITaskIds = function(self)
  -- function num : 0_26
  return self._taskIdList
end

ActivitySectorIIIData.GetSectorIIITaskRefTimes = function(self)
  -- function num : 0_27
  return self._refreshTimes, (self._mainCfg).daily_task_refresh_max
end

ActivitySectorIIIData.GetSectorIIIDungeonInfo = function(self)
  -- function num : 0_28
  return self._dungeonDataDic, self._dungeonIdList
end

ActivitySectorIIIData.GetSectorIIISectorMain = function(self)
  -- function num : 0_29
  return self._mapDataList
end

ActivitySectorIIIData.GetSectorIIIHardOpenTime = function(self)
  -- function num : 0_30 , upvalues : _ENV, CheckerTypeId
  if self._hardOpenTime ~= nil then
    return self._hardOpenTime
  end
  for i,preId in ipairs((self._mainCfg).hard_pre_condition) do
    if preId == CheckerTypeId.TimeRange then
      self._countdownTime = ((self._mainCfg).hard_pre_para1)[i]
      break
    end
  end
  do
    self._countdownTime = self._countdownTime or 0
    return self._countdownTime
  end
end

ActivitySectorIIIData.GetSectorIIIMainNextOpenTime = function(self)
  -- function num : 0_31
  return (self._mainCfg).main2nd_start
end

ActivitySectorIIIData.GetSectorIII_EffiMultRate = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local rate = (PlayerDataCenter.playerBonus):Get_Activity_EffiMultRate(self:GetActFrameId())
  return rate
end

ActivitySectorIIIData.SectorIII_IsFarmDouble = function(self)
  -- function num : 0_33
  return self._farmDouble
end

ActivitySectorIIIData.SectorIII_SetFarmDouble = function(self, active)
  -- function num : 0_34
  self._farmDouble = active
end

ActivitySectorIIIData.GetSectorIII_PointMultRat = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local itemRateDic = (PlayerDataCenter.playerBonus):Get_Activity_PointMultRate(self:GetActFrameId())
  return itemRateDic
end

ActivitySectorIIIData.GetSectorIIIDunTicketId = function(self)
  -- function num : 0_36
  return self._dunTicketId
end

ActivitySectorIIIData.GetSectorIIIDunPointId = function(self)
  -- function num : 0_37
  return self._actPointId
end

ActivitySectorIIIData.GetCommonActUnlockedBuffList = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local actBuffUnlockDic = (PlayerDataCenter.playerBonus):Get_Activity_UnlockBuff(self:GetActFrameId())
  return actBuffUnlockDic
end

ActivitySectorIIIData.GetCommonActDelectedBuffList = function(self)
  -- function num : 0_39 , upvalues : _ENV
  local actBuffDelectDic = (PlayerDataCenter.playerBonus):Get_Activity_DeleteBuff(self:GetActFrameId())
  return actBuffDelectDic
end

ActivitySectorIIIData.GetActTinyGameData = function(self)
  -- function num : 0_40
  return self._gameSnake
end

return ActivitySectorIIIData

