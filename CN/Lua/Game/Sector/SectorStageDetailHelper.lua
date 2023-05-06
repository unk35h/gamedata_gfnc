-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorStageDetailHelper = class("SectorStageDetailHelper")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local cs_MessageCommon = CS.MessageCommon
local emptyString = ""
SectorStageDetailHelper.PlayMoudleType = {Ep = 1, Warchess = 2, WarchessSeason = 3, EpMixWarchess = 4, AVG = 5}
local GetChipPreviewByEpModuleIdFunc = {[proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration] = function(stageId, param)
  -- function num : 0_0 , upvalues : _ENV
  local chip_dic = {}
  local stageCfg = (ConfigData.sector_stage)[stageId]
  for k,v in pairs(stageCfg.function_extra) do
    chip_dic[v] = true
  end
  local chip_pool_dic = {}
  for _,epId in pairs(stageCfg.exploration_list) do
    local epCfg = (ConfigData.exploration)[epId]
    if epCfg ~= nil then
      for _,poolId in pairs(epCfg.chip_pool) do
        chip_pool_dic[poolId] = true
        local funcPoolCfg = (ConfigData.ep_function_pool)[poolId]
        if funcPoolCfg ~= nil then
          for _,chipId in pairs(funcPoolCfg.function_pool) do
            chip_dic[chipId] = true
          end
        end
      end
    end
  end
  return chip_dic
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_Endless] = function(stageId, param)
  -- function num : 0_1 , upvalues : _ENV
  local chip_dic = {}
  local levelDic = ((ConfigData.endless).levelDic)[stageId]
  local cfg = ((ConfigData.endless)[levelDic.sectorId])[levelDic.index]
  for k,v in pairs(cfg.chip) do
    chip_dic[v] = true
  end
  return chip_dic
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge] = function(stageId, param)
  -- function num : 0_2 , upvalues : _ENV
  local chip_dic = {}
  local chipList = (PlayerDataCenter.periodicChallengeData).dailyChipList
  if chipList ~= nil then
    for index,value in ipairs(chipList) do
      chip_dic[value] = true
    end
  end
  do
    return chip_dic
  end
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge] = function(stageId, param)
  -- function num : 0_3 , upvalues : _ENV
  local chip_dic = {}
  local weeklyData = ((PlayerDataCenter.allWeeklyChallengeData).dataDic)[stageId]
  if weeklyData ~= nil then
    chip_dic = weeklyData:GetWeeklyChanllengeChipDic()
  end
  return chip_dic
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess] = function(stageId, param)
  -- function num : 0_4 , upvalues : _ENV
  local chip_dic = {}
  local chipPoolList = nil
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local warchessLevelCfg = (ConfigData.warchess_level)[(stageCfg.exploration_list)[1]]
  if warchessLevelCfg ~= nil then
    for _,poolId in ipairs(warchessLevelCfg.chip_pool) do
      local funcPoolCfg = (ConfigData.ep_function_pool)[poolId]
      if funcPoolCfg ~= nil then
        for _,chipId in pairs(funcPoolCfg.function_pool) do
          chip_dic[chipId] = true
        end
      end
    end
  end
  do
    return chip_dic
  end
end
}
local TryGetUncompletedSectorStateCfgFunc = {[proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration] = function(dungeonId)
  -- function num : 0_5 , upvalues : _ENV
  local sectorStateCfg = (ConfigData.sector_stage)[dungeonId]
  if sectorStateCfg == nil then
    error("Can\'t find sectorStateCfg, id = " .. tostring(dungeonId))
    return 
  end
  return sectorStateCfg
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_Endless] = function(dungeonId)
  -- function num : 0_6 , upvalues : _ENV, SectorLevelDetailEnum
  local levelDic = ((ConfigData.endless).levelDic)[dungeonId]
  local cfg = ((ConfigData.endless)[levelDic.sectorId])[levelDic.index]
  if cfg == nil then
    error("endlessCfg is null,endlessId:" .. tostring(dungeonId))
    return 
  end
  local stageCfg = {endlessCfg = cfg, name = cfg.name, sector = levelDic.sectorId, cost_strength_num = (cfg.cost_strength_itemNums)[1], difficulty = (SectorLevelDetailEnum.eDifficulty).infinity, dungeonId = dungeonId}
  return stageCfg
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge] = function(dungeonId)
  -- function num : 0_7 , upvalues : _ENV, SectorLevelDetailEnum
  local challengeCfg = (ConfigData.daily_challenge)[dungeonId]
  local stageCfg = {challengeCfg = challengeCfg, name = (LanguageUtil.GetLocaleText)(challengeCfg.name), sector = nil, cost_strength_num = 0, difficulty = (SectorLevelDetailEnum.eDifficulty).daily_challenge, dungeonId = dungeonId}
  return stageCfg
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge] = function(dungeonId)
  -- function num : 0_8 , upvalues : _ENV, SectorLevelDetailEnum
  local challengeCfg = (ConfigData.weekly_challenge)[dungeonId]
  local stageCfg = {challengeCfg = challengeCfg, name = (LanguageUtil.GetLocaleText)(challengeCfg.name), sector = nil, cost_strength_num = 0, difficulty = (SectorLevelDetailEnum.eDifficulty).weekly_challenge, dungeonId = dungeonId, combat = 5000}
  return stageCfg
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess] = function(dungeonId)
  -- function num : 0_9 , upvalues : _ENV
  local sectorStateCfg = (ConfigData.sector_stage)[dungeonId]
  if sectorStateCfg == nil then
    error("Can\'t find sectorStateCfg, id = " .. tostring(dungeonId))
    return 
  end
  return sectorStateCfg
end
}
local TryToShowCurrentLevelTipsFunc = {[proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration] = function(stageCfg, playModeType)
  -- function num : 0_10 , upvalues : _ENV, SectorStageDetailHelper, ExplorationEnum, emptyString
  local msg = nil
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  local strName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  local courseDes = (LanguageUtil.GetLocaleText)(sectorCfg.course_des)
  if ((ConfigData.sector).onlyShowStageIdSectorDic)[stageCfg.sector] then
    if playModeType == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
      local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
      if win23Ctrl then
        local actName, mainName = win23Ctrl:GetActWin23NameAndMode()
        msg = (string.format)(ConfigData:GetTipContent(7133), strName, stageCfg.num, actName, mainName)
      end
    else
      do
        msg = (string.format)(ConfigData:GetTipContent(7009), strName, stageCfg.num)
        local strDiff = nil
        local sectorShowId, isConvert = ConfigData:GetSectorIdShow(stageCfg.sector)
        if isConvert then
          strDiff = ConfigData:GetTipContent(13008)
        else
          local difficult = stageCfg.difficulty
          if difficult == (ExplorationEnum.eDifficultType).Normal then
            strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_1)
          else
            if difficult == (ExplorationEnum.eDifficultType).Hard then
              strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_2)
            else
              strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_3)
            end
          end
        end
        do
          local strLv = tostring(sectorShowId) .. "-" .. tostring(stageCfg.num)
          if playModeType == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
            local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
            if win23Ctrl then
              local actName, mainName = win23Ctrl:GetActWin23NameAndMode()
              msg = (string.format)(ConfigData:GetTipContent(7131), strName, strLv, strDiff, actName, mainName)
            end
          else
            do
              do
                if courseDes ~= nil and courseDes ~= emptyString then
                  msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2normal), strName, emptyString, strDiff)
                else
                  msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2normal), strName, strLv, strDiff)
                end
                ExplorationManager:TryGiveUpLastExploration(msg, stageCfg)
              end
            end
          end
        end
      end
    end
  end
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_Endless] = function(stageCfg, playModeType)
  -- function num : 0_11 , upvalues : _ENV, SectorStageDetailHelper
  local strName = (LanguageUtil.GetLocaleText)((stageCfg.endlessCfg).name)
  local strNum = tostring((stageCfg.endlessCfg).index * 10) .. "m"
  local msg = nil
  if playModeType == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
    local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
    if win23Ctrl then
      local actName, mainName = win23Ctrl:GetActWin23NameAndMode()
      msg = (string.format)(ConfigData:GetTipContent(7132), strName, strNum, actName, mainName)
    end
  else
    do
      msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2endless), strName, strNum)
      ExplorationManager:TryGiveUpLastExploration(msg, stageCfg)
    end
  end
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge] = function(stageCfg)
  -- function num : 0_12 , upvalues : _ENV
  local msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2DailyAndWeekly), stageCfg.name)
  ExplorationManager:TryGiveUpLastExploration(msg, stageCfg)
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge] = function(stageCfg)
  -- function num : 0_13 , upvalues : _ENV
  local msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2DailyAndWeekly), stageCfg.name)
  ExplorationManager:TryGiveUpLastExploration(msg, stageCfg)
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess] = function(stageCfg, playModeType)
  -- function num : 0_14 , upvalues : _ENV, SectorStageDetailHelper, ExplorationEnum, cs_MessageCommon
  local msg = nil
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  local strName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  if ((ConfigData.sector).onlyShowStageIdSectorDic)[stageCfg.sector] then
    if playModeType == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
      local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
      if win23Ctrl then
        local actName, mainName = win23Ctrl:GetActWin23NameAndMode()
        msg = (string.format)(ConfigData:GetTipContent(7134), strName, stageCfg.num, actName, mainName)
      end
    else
      do
        msg = (string.format)(ConfigData:GetTipContent(7009), strName, stageCfg.num)
        local strDiff = nil
        local sectorShowId, isConvert = ConfigData:GetSectorIdShow(stageCfg.sector)
        if isConvert then
          strDiff = ConfigData:GetTipContent(13008)
        else
          local difficult = stageCfg.difficulty
          if difficult == (ExplorationEnum.eDifficultType).Normal then
            strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_1)
          else
            if difficult == (ExplorationEnum.eDifficultType).Hard then
              strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_2)
            else
              strDiff = ConfigData:GetTipContent(TipContent.DifficultyName_3)
            end
          end
        end
        do
          do
            local strLv = tostring(sectorShowId) .. "-" .. tostring(stageCfg.num)
            msg = (string.format)(ConfigData:GetTipContent(TipContent.Sector_IsExploringOtherSector2normal), strName, strLv, strDiff)
            ;
            (cs_MessageCommon.ShowMessageBox)(msg)
          end
        end
      end
    end
  end
end
, [proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason] = function(stageCfg)
  -- function num : 0_15 , upvalues : _ENV, cs_MessageCommon
  local _, _, actFrameData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(stageCfg.seasonId)
  local actName = actFrameData ~= nil and actFrameData:GetActivityFrameName() or nil
  local tip = ConfigData:GetTipContent(8705, actName, tostring(stageCfg.floorId))
  ;
  (cs_MessageCommon.ShowMessageBox)(tip)
end
}
SectorStageDetailHelper.GetChipPreviewByEpModuleId = function(moduleId, stageId, param)
  -- function num : 0_16 , upvalues : GetChipPreviewByEpModuleIdFunc
  local func = GetChipPreviewByEpModuleIdFunc[moduleId]
  if func ~= nil then
    return func(stageId, param)
  end
  return {}
end

SectorStageDetailHelper.IsSectorNoCollide = function(sectorId, isShowTip)
  -- function num : 0_17 , upvalues : _ENV, SectorStageDetailHelper
  if ((ConfigData.sector_stage).sectorIdList)[sectorId] == nil then
    return true
  end
  local moudleType = (SectorStageDetailHelper.SectorPlayMoudle)(sectorId)
  local cfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)(moudleType)
  if cfg == nil then
    return true
  end
  if cfg.sector == sectorId then
    return true
  end
  if isShowTip then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)(moudleType)
  end
  return false
end

SectorStageDetailHelper.IsWarchessSeasonNoCollide = function(seasonId, isShowTip)
  -- function num : 0_18 , upvalues : SectorStageDetailHelper, _ENV
  local unComleteEp, towerId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).WarchessSeason)
  if not unComleteEp then
    return true
  end
  local unCompleteWCS, data = WarChessSeasonManager:GetUncompleteWCSData()
  if seasonId == data.seasonId then
    return true
  end
  if isShowTip then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)((SectorStageDetailHelper.PlayMoudleType).WarchessSeason)
  end
  return false
end

SectorStageDetailHelper.IsWeeklyChallengeNoCollide = function(isShowTip)
  -- function num : 0_19 , upvalues : SectorStageDetailHelper, _ENV
  local unComleteEp, _, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)((SectorStageDetailHelper.PlayMoudleType).Ep)
  if not unComleteEp then
    return true
  end
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge then
    return true
  end
  local lastSelectSector = (PlayerDataCenter.sectorStage):GetSelectSectorId()
  local isWeeklyChallengeSector = (table.contain)((ConfigData.game_config).weeklyChallengeSectorIds, lastSelectSector)
  if isWeeklyChallengeSector then
    return true
  end
  if isShowTip then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)((SectorStageDetailHelper.PlayMoudleType).Ep)
  end
  return false
end

SectorStageDetailHelper.HasUnCompleteStage = function(PlayMoudleType)
  -- function num : 0_20 , upvalues : SectorStageDetailHelper, _ENV
  do
    if PlayMoudleType == (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess then
      local unComplete, dungeonId, moduleId, canFloorOver = ExplorationManager:HasUncompletedEp()
      if unComplete then
        return unComplete, dungeonId, moduleId, canFloorOver
      end
      unComplete = WarChessManager:GetIsHaveUncompletedWarChess()
      return unComplete, dungeonId, moduleId, canFloorOver
    end
    -- DECOMPILER ERROR at PC31: Overwrote pending register: R2 in 'AssignReg'

    do
      if PlayMoudleType == (SectorStageDetailHelper.PlayMoudleType).Ep then
        local unComplete, dungeonId, moduleId, canFloorOver = ExplorationManager:HasUncompletedEp(), moduleId, canFloorOver
        return unComplete, dungeonId, moduleId, canFloorOver
      end
      do
        if PlayMoudleType == (SectorStageDetailHelper.PlayMoudleType).Warchess then
          local unComplete, dungeonId, moduleId, canFloorOver = WarChessManager:GetIsHaveUncompletedWarChess()
          return unComplete, dungeonId, moduleId, canFloorOver
        end
        do
          if PlayMoudleType == (SectorStageDetailHelper.PlayMoudleType).WarchessSeason then
            local unComplete, data = WarChessSeasonManager:GetUncompleteWCSData()
            if unComplete then
              return unComplete, data.towerId, proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason, false
            end
            return false
          end
          if PlayMoudleType == (SectorStageDetailHelper.PlayMoudleType).AVG then
            return false
          end
          if isGameDev then
            error("PlayMoudleType Error")
          end
          return false
        end
      end
    end
  end
end

SectorStageDetailHelper.TryGetUncompletedStateCfg = function(PlayMoudleType)
  -- function num : 0_21 , upvalues : SectorStageDetailHelper, _ENV, TryGetUncompletedSectorStateCfgFunc
  do
    if PlayMoudleType == SectorStageDetailHelper.WarchessSeason then
      local unComplete, data = WarChessSeasonManager:GetUncompleteWCSData()
      if unComplete then
        return data, proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason
      end
      return nil
    end
    local unComplete, dungeonId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)(PlayMoudleType)
    if not unComplete then
      return nil
    end
    local func = TryGetUncompletedSectorStateCfgFunc[moduleId]
    if func ~= nil then
      return func(dungeonId), moduleId
    end
    if isGameDev then
      error("没有配置获取方法 " .. tostring(moduleId))
    end
    return nil
  end
end

SectorStageDetailHelper.TryToShowCurrentLevelTips = function(PlayMoudleType)
  -- function num : 0_22 , upvalues : SectorStageDetailHelper, TryToShowCurrentLevelTipsFunc, _ENV
  local stageCfg, moduleId = (SectorStageDetailHelper.TryGetUncompletedStateCfg)(PlayMoudleType)
  if stageCfg == nil then
    return 
  end
  local func = TryToShowCurrentLevelTipsFunc[moduleId]
  if func ~= nil then
    func(stageCfg, PlayMoudleType)
  else
    if isGameDev then
      error("没有提示方法" .. tostring(moduleId))
    end
  end
end

SectorStageDetailHelper.GiveupStageLevel = function(PlayMoudleType)
  -- function num : 0_23 , upvalues : SectorStageDetailHelper, _ENV, cs_MessageCommon
  local unComplete, dungeonId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)(PlayMoudleType)
  if not unComplete then
    return 
  end
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess then
    local msg = ConfigData:GetTipContent(8511)
    ;
    (cs_MessageCommon.ShowMessageBox)(msg, function()
    -- function num : 0_23_0 , upvalues : _ENV
    WarChessManager:GiveUpLastWarchess()
  end
, nil)
  else
    do
      if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason then
        WarChessSeasonManager:GiveUpLastWarchessSeason()
      else
        ExplorationManager:TryGiveUpLastExploration()
      end
    end
  end
end

SectorStageDetailHelper.ContinueUncompleteStage = function(PlayMoudleType)
  -- function num : 0_24 , upvalues : SectorStageDetailHelper, _ENV
  local hasHasUncompletedEp, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)(PlayMoudleType)
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChess then
    WarChessManager:ContinueLastWarchess()
  else
    if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WarChessSeason then
      self:__ContinueUncompleteWarchessSeason()
    else
      ExplorationManager:ContinueLastExploration()
    end
  end
end

SectorStageDetailHelper.IsSectorHasUnComplete = function(sectorId)
  -- function num : 0_25 , upvalues : SectorStageDetailHelper, _ENV
  local playerModuleId = (SectorStageDetailHelper.SectorPlayMoudle)(sectorId)
  local unComplete, stageId, moduleId = (SectorStageDetailHelper.HasUnCompleteStage)(playerModuleId)
  if not unComplete then
    return false
  end
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge then
    return false
  end
  do
    if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Endless then
      local endlessCfg = ((ConfigData.endless).levelDic)[stageId]
      return endlessCfg.sectorId == sectorId, stageId
    end
    local stageCfg = (ConfigData.sector_stage)[stageId]
    do return stageCfg.sector == sectorId, stageId end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

SectorStageDetailHelper.SectorPlayMoudle = function(sectorId)
  -- function num : 0_26 , upvalues : _ENV, SectorStageDetailHelper, SectorLevelDetailEnum
  local sectorCfg = (ConfigData.sector)[sectorId]
  if sectorCfg == nil then
    return 0
  end
  if ((ConfigData.sector_stage).sectorIdList)[sectorId] == nil then
    return (SectorStageDetailHelper.PlayMoudleType).AVG
  end
  local isWarchessSector = sectorCfg.sector_type == (SectorLevelDetailEnum.eSectorType).WarChess
  local isMixSector = sectorCfg.sector_type == (SectorLevelDetailEnum.eSectorType).ActWin23
  if (not isWarchessSector or not (SectorStageDetailHelper.PlayMoudleType).Warchess) and (not isMixSector or not (SectorStageDetailHelper.PlayMoudleType).EpMixWarchess) then
    do return (SectorStageDetailHelper.PlayMoudleType).Ep end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

SectorStageDetailHelper.GetIsSectorHaveWarChessStage = function(sectorId)
  -- function num : 0_27 , upvalues : _ENV, SectorLevelDetailEnum
  local sectorCfg = (ConfigData.sector)[sectorId]
  if sectorCfg.sector_type == (SectorLevelDetailEnum.eSectorType).WarChess then
    return true
  end
  return ((ConfigData.sector_stage).sectorIsHaveWCStageDic)[sectorId]
end

SectorStageDetailHelper.__ContinueUncompleteWarchessSeason = function()
  -- function num : 0_28 , upvalues : _ENV, ActivityFrameEnum
  local unComplete, data = WarChessSeasonManager:GetUncompleteWCSData()
  if not unComplete then
    return 
  end
  local actType = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(data.seasonId)
  if actType == nil then
    return 
  end
  if actType == (ActivityFrameEnum.eActivityType).Hallowmas then
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
    ctrl:ContinuehallowmasSeason()
  end
end

return SectorStageDetailHelper

