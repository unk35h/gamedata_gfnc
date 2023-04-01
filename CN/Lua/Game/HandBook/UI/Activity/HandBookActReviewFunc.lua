-- params : ...
-- function num : 0 , upvalues : _ENV
local eActivityType = (require("Game.ActivityFrame.ActivityFrameEnum")).eActivityType
local CommonPoltReviewData = require("Game.CommonUI.PlotReview.CommonPoltReviewData")
local CommonPoltReviewGroupData = require("Game.CommonUI.PlotReview.CommonPoltReviewGroupData")
local SectorEnum = require("Game.Sector.SectorEnum")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local _, _, CheckerExtra = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local __CreateAvgItem = function(CPRData, avgCfg, avgPlayCtrl, overrideAvgCheck)
  -- function num : 0_0 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData, CheckerExtra
  local avgId = avgCfg.id
  local groupENName = (string.format)((SectorEnum.SectorAvgItemDesc)[(SectorEnum.eSectorLevelItemType).Normal], tostring(avgCfg.number))
  local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
  local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
  local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, {avgId})
  if (overrideAvgCheck == nil or not overrideAvgCheck(avgId)) and not avgPlayCtrl:IsAvgUnlock(avgId) then
    local isUnlock = avgPlayCtrl:IsAvgPlayed(avgId)
  end
  if isUnlock then
    CPRGroupData:SetAvgGroupDataIsUnlock(true)
    CPRData:AddAvgGroup(CPRGroupData)
    return true
  end
  local unlockDes = nil
  if (CheckerExtra.IsHasActivityChecker)(avgCfg.pre_condition) then
    unlockDes = ConfigData:GetTipContent(8305)
  else
    local str1, str2 = nil, nil
    str1 = groupName
    str2 = groupENName
    local stageId = (ControllerManager:GetController(ControllerTypeId.AvgPlay)):GetPreUnlockSectorStage(avgId)
    if stageId ~= nil then
      local stageCfg = (ConfigData.sector_stage)[stageId]
      if stageCfg ~= nil then
        str2 = (string.format)((SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).OnlyNumber], tostring(stageCfg.num))
        local sectorCfg = (ConfigData.sector)[stageCfg.sector]
        str1 = (LanguageUtil.GetLocaleText)(sectorCfg.name)
      end
    end
    do
      do
        unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), str1, str2)
        CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
        CPRData:AddAvgGroup(CPRGroupData)
        return false
      end
    end
  end
end

local __CreateStageItem = function(CPRData, stageId, stageAvgList, overrideStageCheck)
  -- function num : 0_1 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  local groupENName = (string.format)((SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).OnlyNumber], tostring(stageCfg.num))
  local groupName = (LanguageUtil.GetLocaleText)(stageCfg.name)
  local groupDes = (LanguageUtil.GetLocaleText)(stageCfg.story_review_introduce)
  local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, stageAvgList)
  if overrideStageCheck == nil or not overrideStageCheck(stageId) then
    local isUnlock = (PlayerDataCenter.sectorStage):IsStageComplete(stageId)
  end
  if isUnlock then
    CPRGroupData:SetAvgGroupDataIsUnlock(true)
    CPRData:AddAvgGroup(CPRGroupData)
    return true
  end
  local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), sectorName, groupENName)
  CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
  CPRData:AddAvgGroup(CPRGroupData)
  return false
end

local SeekAvgGroupInSector = function(CPRData, sectorStageCfg, overrideAvgCheck, overrideStageCheck)
  -- function num : 0_2 , upvalues : _ENV, __CreateAvgItem, __CreateStageItem
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local totalCount = 0
  local unLockCount = 0
  for _,stageId in ipairs(sectorStageCfg) do
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(CPRData, avgCfg, avgPlayCtrl, overrideAvgCheck) then
          unLockCount = unLockCount + 1
        end
      end
    end
    local stageAvgList = ((ConfigData.story_avg).stageAvgDic)[stageId]
    if stageAvgList ~= nil then
      totalCount = totalCount + 1
      if __CreateStageItem(CPRData, stageId, stageAvgList, overrideStageCheck) then
        unLockCount = unLockCount + 1
      end
    end
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(CPRData, avgCfg, avgPlayCtrl, overrideAvgCheck) then
          unLockCount = unLockCount + 1
        end
      end
    end
  end
  return totalCount, unLockCount
end

local SeekAvgGroupInSectorWithoutStage = function(CPRData, sectorId, overrideAvgCheck)
  -- function num : 0_3 , upvalues : _ENV, __CreateAvgItem
  local totalCount = 0
  local unLockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local avgIds = ((ConfigData.story_avg).sectorAvgDic)[sectorId]
  if avgIds ~= nil then
    for i,avgId in ipairs(avgIds) do
      local avgCfg = (ConfigData.story_avg)[avgId]
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(CPRData, avgCfg, avgPlayCtrl, overrideAvgCheck) then
          unLockCount = unLockCount + 1
        end
      end
    end
  end
  do
    return totalCount, unLockCount
  end
end

local GenCPRDataWithFirstAvgInAct = function(CPRData, avgId)
  -- function num : 0_4 , upvalues : _ENV, CommonPoltReviewGroupData
  local firstAvg = (ConfigData.story_avg)[avgId]
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local groupENName = (LanguageUtil.GetLocaleText)(firstAvg.name)
  local groupName = (LanguageUtil.GetLocaleText)(firstAvg.name)
  local groupDes = (LanguageUtil.GetLocaleText)(firstAvg.story_review_describe)
  local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, {firstAvg.id})
  local isFirstUnlock = avgPlayCtrl:IsAvgPlayed(firstAvg.id)
  local unlockDes = ConfigData:GetTipContent(8305)
  CPRGroupData:SetAvgGroupDataIsUnlock(isFirstUnlock, unlockDes)
  CPRData:AddAvgGroup(CPRGroupData)
  return 1, isFirstUnlock and 1 or 0
end

local HandBookActReviewFunc = {[eActivityType.SectorI] = function(actId)
  -- function num : 0_5 , upvalues : _ENV, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct, SectorLevelDetailEnum, SeekAvgGroupInSector
  local timeLimitCfg = (ConfigData.activity_time_limit)[actId]
  if timeLimitCfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  CPRData:SetCPRBgResAllScreen(true)
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, timeLimitCfg.first_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  local sectorId = timeLimitCfg.easy_stage
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSector(CPRData, sectorStageCfg)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.SectorII] = function(actId)
  -- function num : 0_6 , upvalues : _ENV, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct, SectorLevelDetailEnum, SeekAvgGroupInSector, CommonPoltReviewGroupData
  local winterCfg = (ConfigData.activity_winter)[actId]
  if winterCfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  CPRData:SetCPRBgResAllScreen(true)
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, winterCfg.first_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  local sectorId = winterCfg.main_sector
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSector(CPRData, sectorStageCfg)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  local storyExtrCfgDic = (ConfigData.activity_winter_sector_story_extra)[sectorId]
  if storyExtrCfgDic ~= nil then
    for story_id,cfg in pairs(storyExtrCfgDic) do
      if cfg.is_isolated then
        local avgCfg = (ConfigData.story_avg)[story_id]
        if avgCfg ~= nil then
          local avgTotal, avgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, story_id)
          totalCount = totalCount + avgTotal
          unlockCount = unlockCount + avgUnlock
        end
      end
    end
  end
  do
    local techTypeId = winterCfg.activity_tech_type
    local techRowIdDic = (((ConfigData.activity_tech).actTechTypeList)[techTypeId]).techRowIdDic
    local lineList = {}
    for lineId,_ in pairs(techRowIdDic) do
      (table.insert)(lineList, lineId)
    end
    ;
    (table.sort)(lineList)
    for _,lineId in ipairs(lineList) do
      local techAvgCfg = (ConfigData.activity_tech_line)[lineId]
      local avgCfg = (ConfigData.story_avg)[techAvgCfg.story_id]
      if avgCfg ~= nil then
        local groupENName = (LanguageUtil.GetLocaleText)(avgCfg.name)
        local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
        local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
        local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, {avgCfg.id})
        totalCount = totalCount + 1
        local isFirstUnlock = avgPlayCtrl:IsAvgUnlock(avgCfg.id)
        if not isFirstUnlock or not unlockCount + 1 then
          do
            local unlockDes = ConfigData:GetTipContent(8305)
            CPRGroupData:SetAvgGroupDataIsUnlock(isFirstUnlock, unlockDes)
            CPRData:AddAvgGroup(CPRGroupData)
            -- DECOMPILER ERROR at PC138: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC138: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC138: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC138: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    CPRData:SetCPRUnlockNum(totalCount, unlockCount)
    return CPRData
  end
end
, [eActivityType.Carnival] = function(actId)
  -- function num : 0_7 , upvalues : _ENV, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct, SectorLevelDetailEnum, SeekAvgGroupInSector
  local carnivalCfg = (ConfigData.activity_carnival)[actId]
  if carnivalCfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  CPRData:SetCPRBgResAllScreen(true)
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, carnivalCfg.first_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  local sectorId = carnivalCfg.story_stage
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSector(CPRData, sectorStageCfg)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.RefreshDun] = function(actId)
  -- function num : 0_8 , upvalues : _ENV, eDynConfigData, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct, CommonPoltReviewGroupData
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon)
  local refreshDunCfg = (ConfigData.activity_refresh_dungeon)[actId]
  if refreshDunCfg == nil then
    ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon)
    return 
  end
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
  ConfigData:LoadDynCfg(eDynConfigData.activity_refresh_dungeon_dun)
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  CPRData:SetCPRBgResName(refreshDunCfg.pic, false)
  CPRData:SetCPRTitleName((LanguageUtil.GetLocaleText)(refreshDunCfg.avg_name))
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, refreshDunCfg.activity_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  for heroId,dunHeroCfg in pairs(ConfigData.activity_refresh_dungeon_hero) do
    totalCount = totalCount + 1
    local avgCfg = (ConfigData.story_avg)[dunHeroCfg.avg_id]
    local played = avgPlayCtrl:IsAvgPlayed(avgCfg.id)
    local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
    local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupName, groupName, groupDes, {avgCfg.id})
    if played then
      unlockCount = unlockCount + 1
      CPRGroupData:SetAvgGroupDataIsUnlock(played)
    else
      local heroCfg = (ConfigData.hero_data)[heroId]
      local heroName = (LanguageUtil.GetLocaleText)(heroCfg.name)
      local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7303)), heroName)
      CPRGroupData:SetAvgGroupDataIsUnlock(played, unlockDes)
    end
    do
      do
        CPRData:AddAvgGroup(CPRGroupData)
        -- DECOMPILER ERROR at PC108: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  local finishAvgTotal, finishAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, refreshDunCfg.finish_avg)
  totalCount = totalCount + finishAvgTotal
  unlockCount = unlockCount + finishAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon_hero)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_refresh_dungeon_dun)
  return CPRData
end
, [eActivityType.HistoryTinyGame] = function(actId)
  -- function num : 0_9 , upvalues : _ENV, CommonPoltReviewData, CommonPoltReviewGroupData
  local cfg = (ConfigData.activity_tiny_game_main)[actId]
  if cfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local group = {}
  local avgPreCondMapping = {}
  local avgPreGroup = ((ConfigData.activity_tiny_game_avg_pre_condition).groupDic)[actId]
  for groupId,avgPreList in ipairs(avgPreGroup) do
    group[groupId] = {}
    for _,preId in ipairs(avgPreList) do
      local avgId = (cfg.activity_avg)[preId]
      ;
      (table.insert)(group[groupId], avgId)
      avgPreCondMapping[avgId] = ((ConfigData.activity_tiny_game_avg_pre_condition)[actId])[preId]
    end
  end
  for _,avglist in ipairs(group) do
    totalCount = totalCount + 1
    local avgCfg = (ConfigData.story_avg)[avglist[1]]
    local groupEnName = "Stage " .. tostring(totalCount)
    local groupName = (LanguageUtil.GetLocaleText)(avgCfg.describe)
    local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupEnName, groupName, groupDes, avglist)
    local played = avgPlayCtrl:IsAvgPlayed(avgCfg.id)
    if played then
      CPRGroupData:SetAvgGroupDataIsUnlock(true)
      unlockCount = unlockCount + 1
    else
      local lockedDes = (LanguageUtil.GetLocaleText)((avgPreCondMapping[avgCfg.id]).describe_condition)
      if (string.IsNullOrEmpty)(lockedDes) then
        lockedDes = ConfigData:GetTipContent(8305)
      end
      CPRGroupData:SetAvgGroupDataIsUnlock(false, lockedDes)
    end
    do
      do
        CPRData:AddAvgGroup(CPRGroupData)
        -- DECOMPILER ERROR at PC109: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.HeroGrow] = function(actId)
  -- function num : 0_10 , upvalues : _ENV, CommonPoltReviewData
  local heroGrowCfg = (ConfigData.activity_hero)[actId]
  return (CommonPoltReviewData.Create4CharAct)(heroGrowCfg)
end
, [eActivityType.DailyChallenge] = function(actId)
  -- function num : 0_11 , upvalues : _ENV, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct
  local cfg = (ConfigData.activity_dailychallenge)[actId]
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, cfg.first_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  local endAvgTotal, endAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, cfg.last_avg)
  totalCount = totalCount + endAvgTotal
  unlockCount = unlockCount + endAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.SectorIII] = function(actId)
  -- function num : 0_12 , upvalues : _ENV, CommonPoltReviewData, GenCPRDataWithFirstAvgInAct, SectorLevelDetailEnum, SeekAvgGroupInSector
  local summer22Cfg = (ConfigData.activity_summer_main)[actId]
  if summer22Cfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  CPRData:SetCPRBgResAllScreen(true)
  local firstAvgTotal, firstAvgUnlock = GenCPRDataWithFirstAvgInAct(CPRData, summer22Cfg.first_avg)
  totalCount = totalCount + firstAvgTotal
  unlockCount = unlockCount + firstAvgUnlock
  local sectorId = summer22Cfg.main_sector
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSector(CPRData, sectorStageCfg)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.Hallowmas] = function(actId)
  -- function num : 0_13 , upvalues : _ENV, CommonPoltReviewData, SeekAvgGroupInSectorWithoutStage
  local hallowmasCfg = (ConfigData.activity_hallowmas_main)[actId]
  if hallowmasCfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  CPRData:SetCPRBgResAllScreen(true)
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSectorWithoutStage(CPRData, hallowmasCfg.story_stage)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  return CPRData
end
, [eActivityType.Winter23] = function(actId)
  -- function num : 0_14 , upvalues : _ENV, eDynConfigData, CommonPoltReviewData, SectorLevelDetailEnum, SeekAvgGroupInSector
  ConfigData:LoadDynCfg(eDynConfigData.activity_winter23_main)
  local cfg = (ConfigData.activity_winter23_main)[actId]
  if cfg == nil then
    return 
  end
  local CPRData = (CommonPoltReviewData.New)()
  local totalCount = 0
  local unlockCount = 0
  local sectorId = cfg.normal_sector
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local sectorAvgTotal, sectorAvgUnlock = SeekAvgGroupInSector(CPRData, sectorStageCfg)
  totalCount = totalCount + sectorAvgTotal
  unlockCount = unlockCount + sectorAvgUnlock
  CPRData:SetCPRUnlockNum(totalCount, unlockCount)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_winter23_main)
  return CPRData
end
}
return HandBookActReviewFunc

