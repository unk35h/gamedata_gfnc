-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonPoltReviewData = class("CommonPoltReviewData")
local SectorEnum = require("Game.Sector.SectorEnum")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local CommonPoltReviewGroupData = require("Game.CommonUI.PlotReview.CommonPoltReviewGroupData")
CommonPoltReviewData.Create4CharAct = function(heroGrowCfg)
  -- function num : 0_0 , upvalues : CommonPoltReviewData, _ENV, SectorEnum, CommonPoltReviewGroupData, SectorLevelDetailEnum
  local CPRData = (CommonPoltReviewData.New)()
  CPRData:SetCPRBgResName(heroGrowCfg.story_review_bg, true)
  local __CreateAvgItem = function(avgCfg, avgPlayCtrl)
    -- function num : 0_0_0 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData, heroGrowCfg, CPRData
    local avgId = avgCfg.id
    local avgCfg = (ConfigData.story_avg)[avgId]
    local groupENName = (string.format)((SectorEnum.SectorAvgItemDesc)[(SectorEnum.eSectorLevelItemType).Normal], tostring(avgCfg.number))
    local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
    local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, {avgId})
    if avgPlayCtrl:IsAvgUnlock(avgId) then
      CPRGroupData:SetAvgGroupDataIsUnlock(true)
      CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
      -- function num : 0_0_0_0 , upvalues : _ENV, heroGrowCfg, avgId
      return not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetHeroGrowAvgReview(heroGrowCfg.id, avgId)
    end
)
      CPRGroupData:SetAvgGroupDataOperateData(function()
      -- function num : 0_0_0_1 , upvalues : _ENV, heroGrowCfg, avgId
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetHeroGrowAvgReview(heroGrowCfg.id, avgId)
    end
)
      CPRData:AddAvgGroup(CPRGroupData)
      return true
    end
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
      local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), str1, str2)
      CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
      CPRData:AddAvgGroup(CPRGroupData)
      return false
    end
  end

  local __CreateStageItem = function(stageId, stageAvgList)
    -- function num : 0_0_1 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData, heroGrowCfg, CPRData
    local stageCfg = (ConfigData.sector_stage)[stageId]
    local sectorCfg = (ConfigData.sector)[stageCfg.sector]
    local groupENName = (string.format)((SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).OnlyNumber], tostring(stageCfg.num))
    local groupName = (LanguageUtil.GetLocaleText)(stageCfg.name)
    local groupDes = (LanguageUtil.GetLocaleText)(stageCfg.story_review_introduce)
    local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, stageAvgList)
    if (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
      CPRGroupData:SetAvgGroupDataIsUnlock(true)
      CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
      -- function num : 0_0_1_0 , upvalues : _ENV, heroGrowCfg, stageId
      return not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetHeroGrowAvgReview(heroGrowCfg.id, stageId)
    end
)
      CPRGroupData:SetAvgGroupDataOperateData(function()
      -- function num : 0_0_1_1 , upvalues : _ENV, heroGrowCfg, stageId
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetHeroGrowAvgReview(heroGrowCfg.id, stageId)
    end
)
      CPRData:AddAvgGroup(CPRGroupData)
      return true
    end
    local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), sectorName, groupENName)
    CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
    CPRData:AddAvgGroup(CPRGroupData)
    return false
  end

  local mainSectorId = heroGrowCfg.main_stage
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[mainSectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local totalCount = 0
  local unLockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  for _,stageId in ipairs(sectorStageCfg) do
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(avgCfg, avgPlayCtrl) then
          unLockCount = unLockCount + 1
        end
      end
    end
    local stageAvgList = ((ConfigData.story_avg).stageAvgDic)[stageId]
    if stageAvgList ~= nil then
      totalCount = totalCount + 1
      if __CreateStageItem(stageId, stageAvgList) then
        unLockCount = unLockCount + 1
      end
    end
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(avgCfg, avgPlayCtrl) then
          unLockCount = unLockCount + 1
        end
      end
    end
  end
  CPRData:SetCPRUnlockNum(totalCount, unLockCount)
  return CPRData
end

CommonPoltReviewData.Create4CarnivalACt = function(carnivalCfg)
  -- function num : 0_1 , upvalues : CommonPoltReviewData, _ENV, SectorEnum, CommonPoltReviewGroupData, SectorLevelDetailEnum
  local CPRData = (CommonPoltReviewData.New)()
  local mainSectorId = carnivalCfg.main_stage
  local sectorCfg = (ConfigData.sector)[mainSectorId]
  local bgRes = sectorCfg.pic_big
  bgRes = PathConsts:GetSectorBackgroundPath(bgRes)
  CPRData:SetCPRBgResName(bgRes, false)
  CPRData:SetCPRBgResAllScreen(true)
  local __CreateAvgItem = function(avgCfg, avgPlayCtrl)
    -- function num : 0_1_0 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData, carnivalCfg, CPRData
    local avgId = avgCfg.id
    local avgCfg = (ConfigData.story_avg)[avgId]
    local groupENName = (string.format)((SectorEnum.SectorAvgItemDesc)[(SectorEnum.eSectorLevelItemType).Normal], tostring(avgCfg.number))
    local groupName = (LanguageUtil.GetLocaleText)(avgCfg.name)
    local groupDes = (LanguageUtil.GetLocaleText)(avgCfg.story_review_describe)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, {avgId})
    if avgPlayCtrl:IsAvgUnlock(avgId) then
      CPRGroupData:SetAvgGroupDataIsUnlock(true)
      CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
      -- function num : 0_1_0_0 , upvalues : _ENV, carnivalCfg, avgId
      return not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetCarnivalAvg(carnivalCfg.id, avgId)
    end
)
      CPRGroupData:SetAvgGroupDataOperateData(function()
      -- function num : 0_1_0_1 , upvalues : _ENV, carnivalCfg, avgId
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetCarnivalAvg(carnivalCfg.id, avgId)
    end
)
      CPRData:AddAvgGroup(CPRGroupData)
      return true
    end
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
      local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), str1, str2)
      CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
      CPRData:AddAvgGroup(CPRGroupData)
      return false
    end
  end

  local __CreateStageItem = function(stageId, stageAvgList)
    -- function num : 0_1_1 , upvalues : _ENV, SectorEnum, CommonPoltReviewGroupData, carnivalCfg, CPRData
    local stageCfg = (ConfigData.sector_stage)[stageId]
    local sectorCfg = (ConfigData.sector)[stageCfg.sector]
    local groupENName = (string.format)((SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).OnlyNumber], tostring(stageCfg.num))
    local groupName = (LanguageUtil.GetLocaleText)(stageCfg.name)
    local groupDes = (LanguageUtil.GetLocaleText)(stageCfg.story_review_introduce)
    local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
    local CPRGroupData = (CommonPoltReviewGroupData.New)(groupENName, groupName, groupDes, stageAvgList)
    if (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
      CPRGroupData:SetAvgGroupDataIsUnlock(true)
      CPRGroupData:SetAvgGroupDataBlueDotFunc(function()
      -- function num : 0_1_1_0 , upvalues : _ENV, carnivalCfg, stageId
      return not (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetCarnivalAvg(carnivalCfg.id, stageId)
    end
)
      CPRGroupData:SetAvgGroupDataOperateData(function()
      -- function num : 0_1_1_1 , upvalues : _ENV, carnivalCfg, stageId
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetCarnivalAvg(carnivalCfg.id, stageId)
    end
)
      CPRData:AddAvgGroup(CPRGroupData)
      return true
    end
    local unlockDes = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7304)), sectorName, groupENName)
    CPRGroupData:SetAvgGroupDataIsUnlock(false, unlockDes)
    CPRData:AddAvgGroup(CPRGroupData)
    return false
  end

  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[mainSectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  local totalCount = 0
  local unLockCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  for _,stageId in ipairs(sectorStageCfg) do
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(avgCfg, avgPlayCtrl) then
          unLockCount = unLockCount + 1
        end
      end
    end
    local stageAvgList = ((ConfigData.story_avg).stageAvgDic)[stageId]
    if stageAvgList ~= nil then
      totalCount = totalCount + 1
      if __CreateStageItem(stageId, stageAvgList) then
        unLockCount = unLockCount + 1
      end
    end
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
      if avgCfg ~= nil then
        totalCount = totalCount + 1
        if __CreateAvgItem(avgCfg, avgPlayCtrl) then
          unLockCount = unLockCount + 1
        end
      end
    end
  end
  CPRData:SetCPRUnlockNum(totalCount, unLockCount)
  return CPRData
end

CommonPoltReviewData.ctor = function(self)
  -- function num : 0_2
  self.bgResName = nil
  self.isCharBg = false
  self.totalNum4Show = nil
  self.totalUnlockedNum4Show = nil
  self.avgGroupList = nil
end

CommonPoltReviewData.SetCPRBgResName = function(self, bgResName, isCharBg)
  -- function num : 0_3
  self.bgResName = bgResName
  self.isCharBg = isCharBg
end

CommonPoltReviewData.SetCPRBgResAllScreen = function(self, isAllScreen)
  -- function num : 0_4
  self.isAllScreen = isAllScreen
end

CommonPoltReviewData.SetCPRTitleName = function(self, titleName)
  -- function num : 0_5
  self.titleName = titleName
end

CommonPoltReviewData.SetCPRUnlockNum = function(self, totalNum4Show, totalUnlockedNum4Show)
  -- function num : 0_6
  self.totalNum4Show = totalNum4Show
  self.totalUnlockedNum4Show = totalUnlockedNum4Show
end

CommonPoltReviewData.AddAvgGroup = function(self, CPRGroupData)
  -- function num : 0_7 , upvalues : _ENV
  if self.avgGroupList == nil then
    self.avgGroupList = {}
  end
  ;
  (table.insert)(self.avgGroupList, CPRGroupData)
end

CommonPoltReviewData.GetCPRBgResName = function(self)
  -- function num : 0_8
  return self.bgResName, self.isCharBg
end

CommonPoltReviewData.GetCPRTitleName = function(self)
  -- function num : 0_9
  return self.titleName
end

CommonPoltReviewData.GetCPRBgIsAllScreen = function(self)
  -- function num : 0_10
  return self.isAllScreen
end

CommonPoltReviewData.GetCPRAvgGroupList = function(self)
  -- function num : 0_11
  if self.avgGroupList == nil then
    self.avgGroupList = {}
  end
  return self.avgGroupList
end

CommonPoltReviewData.GetCPRAvgGroupUnlockNum = function(self)
  -- function num : 0_12
  return self.totalNum4Show, self.totalUnlockedNum4Show
end

return CommonPoltReviewData

