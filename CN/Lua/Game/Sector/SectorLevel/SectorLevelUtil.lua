-- params : ...
-- function num : 0 , upvalues : _ENV
local SectorLevelUtil = {}
SectorLevelUtil.GenSectorLevels = function(sectorDiffList)
  -- function num : 0_0
end

SectorLevelUtil.GenRoadLayout = function(cfg, arrangeCfg, stageId, isState, avgPlayCtrl, isMerge, splitPage, preStages, dynInteractArgs)
  -- function num : 0_1 , upvalues : _ENV
  local layoutId = (arrangeCfg[1]).typeId
  local layoutCapacity = #arrangeCfg
  if dynInteractArgs.finalPage == nil then
    dynInteractArgs.finalPage = 1
  end
  if dynInteractArgs.layourDic == nil then
    dynInteractArgs.layourDic = {}
  end
  if isMerge then
    dynInteractArgs.finalPage = dynInteractArgs.finalPage + 1
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R11 in 'UnsetPending'

    if (dynInteractArgs.layourDic)[layoutId] ~= nil then
      ((dynInteractArgs.layourDic)[layoutId]).curPage = dynInteractArgs.finalPage
    end
  end
  do
    if splitPage ~= nil then
      local curPage = splitPage + 1
      if dynInteractArgs.finalPage < curPage then
        dynInteractArgs.finalPage = curPage
      end
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R12 in 'UnsetPending'

      if (dynInteractArgs.layourDic)[layoutId] ~= nil then
        ((dynInteractArgs.layourDic)[layoutId]).curPage = curPage
      else
        -- DECOMPILER ERROR at PC47: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (dynInteractArgs.layourDic)[layoutId] = {curPage = curPage, 
data = {
[curPage] = {}
}
}
      end
    end
    local layoutContent = (dynInteractArgs.layourDic)[layoutId]
    if layoutContent == nil then
      layoutContent = {curPage = dynInteractArgs.finalPage, 
data = {
[dynInteractArgs.finalPage] = {}
}
}
      -- DECOMPILER ERROR at PC62: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (dynInteractArgs.layourDic)[layoutId] = layoutContent
    end
    if (layoutContent.data)[layoutContent.curPage] ~= nil and layoutCapacity <= #(layoutContent.data)[layoutContent.curPage] then
      layoutContent.curPage = layoutContent.curPage + 1
      -- DECOMPILER ERROR at PC80: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (layoutContent.data)[layoutContent.curPage] = {}
      if dynInteractArgs.finalPage < layoutContent.curPage then
        dynInteractArgs.finalPage = layoutContent.curPage
      end
    end
    local curPage = layoutContent.curPage
    local layoutContentData = (layoutContent.data)[curPage]
    if layoutContentData == nil then
      layoutContentData = {}
      -- DECOMPILER ERROR at PC95: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (layoutContent.data)[curPage] = layoutContentData
    end
    local tab = {}
    tab.connecId = stageId
    tab.preStages = preStages
    if isState then
      tab.stageCfg = cfg
      -- DECOMPILER ERROR at PC104: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (dynInteractArgs._sectorStageIdGroupMapping)[cfg.id] = curPage
    else
      tab.avgCfg = cfg
      -- DECOMPILER ERROR at PC109: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (dynInteractArgs._sectorAvgIdGroupMapping)[cfg.id] = curPage
    end
    ;
    (table.insert)(layoutContentData, tab)
    if ((ConfigData.sector_stage).afterMulDic)[stageId] ~= nil then
      if dynInteractArgs.splitPointPage == nil then
        dynInteractArgs.splitPointPage = {}
      end
      -- DECOMPILER ERROR at PC128: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (dynInteractArgs.splitPointPage)[stageId] = layoutContent.curPage
    end
    -- DECOMPILER ERROR at PC146: Confused about usage of register: R15 in 'UnsetPending'

    if (isState and (PlayerDataCenter.sectorStage):IsStageComplete(cfg.id)) or not isState and avgPlayCtrl:IsAvgPlayed(cfg.id) then
      (dynInteractArgs.lastCompletedStage).groupIndex = curPage
      -- DECOMPILER ERROR at PC149: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (dynInteractArgs.lastCompletedStage).id = cfg.id
      -- DECOMPILER ERROR at PC151: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (dynInteractArgs.lastCompletedStage).isState = isState
    end
  end
end

SectorLevelUtil.GetLevelGroupByNormalMulLine = function(arrangeCfg, levelList, sectorStageIdGroupMapping, sectorAvgIdGroupMapping)
  -- function num : 0_2 , upvalues : _ENV, SectorLevelUtil
  local levelGroupDataList = {}
  local lastLocalsDataList = {}
  local dynInteractArgs = {splitPointPage = nil, finalPage = nil, layourDic = nil, _sectorStageIdGroupMapping = sectorStageIdGroupMapping, _sectorAvgIdGroupMapping = sectorAvgIdGroupMapping, 
lastCompletedStage = {groupIndex = nil, id = nil, isState = nil}
}
  local realArrangeCfg = arrangeCfg
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local sectorStageCfg = levelList
  for k,stageId in ipairs(sectorStageCfg) do
    local stage = (ConfigData.sector_stage)[stageId]
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
    local preStageCount = stage.pre_stage ~= nil and #stage.pre_stage or 0
    local isMerge = preStageCount > 1
    local splitPage = dynInteractArgs.splitPointPage ~= nil and preStageCount == 1 and (dynInteractArgs.splitPointPage)[(stage.pre_stage)[1]] or nil
    if stage.special_arrange or 0 ~= 0 and stage.special_arrange ~= (realArrangeCfg[1]).typeId then
      realArrangeCfg = (ConfigData.level_arrange)[stage.special_arrange]
    end
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
      if avgCfg ~= nil then
        (SectorLevelUtil.GenRoadLayout)(avgCfg, realArrangeCfg, stageId, false, avgPlayCtrl, isMerge, splitPage, stage.pre_stage, dynInteractArgs)
        isMerge = false
        splitPage = nil
      end
    end
    ;
    (SectorLevelUtil.GenRoadLayout)(stage, realArrangeCfg, stageId, true, avgPlayCtrl, isMerge, splitPage, stage.pre_stage, dynInteractArgs)
    isMerge = false
    splitPage = nil
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
      if avgCfg ~= nil then
        (SectorLevelUtil.GenRoadLayout)(avgCfg, realArrangeCfg, stageId, false, avgPlayCtrl, isMerge, splitPage, {stageId}, dynInteractArgs)
        isMerge = false
        splitPage = nil
      end
    end
  end
  for index = 1, dynInteractArgs.finalPage or 0 do
    local levelLocals = {
locals = {}
, maxDistance = 0}
    local levelGroupData = {}
    local maxDistance = 0
    local tabCount = 0
    for layoutId,content in pairs(dynInteractArgs.layourDic) do
      local levelArrange = (ConfigData.level_arrange)[layoutId]
      local curTabs = (content.data)[index]
      if curTabs ~= nil then
        local count = #curTabs
        local arrange = levelArrange[count]
        ;
        (table.insert)(levelLocals.locals, {tab = curTabs[count], pos = arrange.pos})
        if dynInteractArgs.isVertical and (maxDistance >= (arrange.pos)[2] or not maxDistance) then
          do
            maxDistance = (arrange.pos)[2]
            if (arrange.pos)[1] >= maxDistance or not maxDistance then
              maxDistance = (arrange.pos)[1]
            end
            levelGroupData[layoutId] = curTabs
            tabCount = tabCount + 1
            -- DECOMPILER ERROR at PC203: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC203: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC203: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC203: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    levelLocals.maxDistance = maxDistance
    ;
    (table.insert)(levelGroupDataList, levelGroupData)
    ;
    (table.insert)(lastLocalsDataList, levelLocals)
  end
  do return levelGroupDataList, lastLocalsDataList, dynInteractArgs.lastCompletedStage, dynInteractArgs.finalPage, dynInteractArgs._sectorStageIdGroupMapping, dynInteractArgs._sectorAvgIdGroupMapping end
  -- DECOMPILER ERROR: 15 unprocessed JMP targets
end

SectorLevelUtil.GenRoadLayoutNoMerge = function(cfg, arrangeCfg, stageId, preStages, dynInteractArgs)
  -- function num : 0_3 , upvalues : _ENV
  local layoutId = (arrangeCfg[1]).typeId
  local layoutCapacity = #arrangeCfg
  if dynInteractArgs.finalPage == nil then
    dynInteractArgs.finalPage = 1
  end
  if dynInteractArgs.layourDic == nil then
    dynInteractArgs.layourDic = {}
  end
  local layoutContent = (dynInteractArgs.layourDic)[layoutId]
  if layoutContent == nil then
    layoutContent = {curPage = dynInteractArgs.finalPage, 
data = {
[dynInteractArgs.finalPage] = {}
}
}
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (dynInteractArgs.layourDic)[layoutId] = layoutContent
  end
  if (layoutContent.data)[layoutContent.curPage] ~= nil and layoutCapacity <= #(layoutContent.data)[layoutContent.curPage] then
    layoutContent.curPage = layoutContent.curPage + 1
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (layoutContent.data)[layoutContent.curPage] = {}
    if dynInteractArgs.finalPage < layoutContent.curPage then
      dynInteractArgs.finalPage = layoutContent.curPage
    end
  end
  local curPage = layoutContent.curPage
  local layoutContentData = (layoutContent.data)[curPage]
  if layoutContentData == nil then
    layoutContentData = {}
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (layoutContent.data)[curPage] = layoutContentData
  end
  local tab = {}
  tab.connecId = stageId
  tab.preStages = preStages
  tab.stageCfg = cfg
  -- DECOMPILER ERROR at PC66: Confused about usage of register: R11 in 'UnsetPending'

  ;
  (dynInteractArgs._sectorStageIdGroupMapping)[cfg.id] = curPage
  ;
  (table.insert)(layoutContentData, tab)
  -- DECOMPILER ERROR at PC80: Confused about usage of register: R11 in 'UnsetPending'

  if (PlayerDataCenter.sectorStage):IsStageComplete(cfg.id) then
    (dynInteractArgs.lastCompletedStage).groupIndex = curPage
    -- DECOMPILER ERROR at PC83: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (dynInteractArgs.lastCompletedStage).id = cfg.id
    -- DECOMPILER ERROR at PC85: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (dynInteractArgs.lastCompletedStage).isState = true
  end
end

SectorLevelUtil.GetLevelGroupByOneLineAndNoAvg = function(arrangeCfg, levelList, sectorStageIdGroupMapping)
  -- function num : 0_4 , upvalues : _ENV, SectorLevelUtil
  local levelGroupDataList = {}
  local lastLocalsDataList = {}
  local dynInteractArgs = {finalPage = nil, layourDic = nil, _sectorStageIdGroupMapping = sectorStageIdGroupMapping, 
lastCompletedStage = {groupIndex = nil, id = nil, isState = nil}
}
  local sectorStageCfg = levelList
  for k,stageId in ipairs(sectorStageCfg) do
    local stage = (ConfigData.sector_stage)[stageId]
    ;
    (SectorLevelUtil.GenRoadLayoutNoMerge)(stage, arrangeCfg, stageId, stage.pre_stage, dynInteractArgs)
  end
  do
    for index = 1, dynInteractArgs.finalPage or 0 do
      local levelLocals = {
locals = {}
, maxDistance = 0}
      local levelGroupData = {}
      local maxDistance = 0
      local tabCount = 0
      for layoutId,content in pairs(dynInteractArgs.layourDic) do
        local levelArrange = (ConfigData.level_arrange)[layoutId]
        local curTabs = (content.data)[index]
        if curTabs ~= nil then
          local count = #curTabs
          local arrange = levelArrange[count]
          ;
          (table.insert)(levelLocals.locals, {tab = curTabs[count], pos = arrange.pos})
          if dynInteractArgs.isVertical and (maxDistance >= (arrange.pos)[2] or not maxDistance) then
            do
              maxDistance = (arrange.pos)[2]
              if (arrange.pos)[1] >= maxDistance or not maxDistance then
                maxDistance = (arrange.pos)[1]
              end
              levelGroupData[layoutId] = curTabs
              tabCount = tabCount + 1
              -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
      levelLocals.maxDistance = maxDistance
      ;
      (table.insert)(levelGroupDataList, levelGroupData)
      ;
      (table.insert)(lastLocalsDataList, levelLocals)
    end
    return levelGroupDataList, lastLocalsDataList, dynInteractArgs.lastCompletedStage, dynInteractArgs.finalPage, dynInteractArgs._sectorStageIdGroupMapping
  end
end

return SectorLevelUtil

