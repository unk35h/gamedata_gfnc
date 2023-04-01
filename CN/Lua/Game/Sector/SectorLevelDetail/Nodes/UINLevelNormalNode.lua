-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelNormalNode = class("UINLevelNormalNode", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local UINLevelDetailRewardItem = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelDetailRewardItem")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local eDetailType = SectorLevelDetailEnum.eDetailType
local UINLNNInfinityLayerItem = require("Game.Sector.SectorLevelDetail.Nodes.UINLNNInfinityLayerItem")
local UINLevelNormalBuffItem = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelNormalBuffItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local PeridicChallengeEnum = require("Game.PeriodicChallenge.PeridicChallengeEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local SectorEnum = require("Game.Sector.SectorEnum")
local UINLevelChallengeTask = require("Game.Sector.SectorLevelDetail.Nodes.ChallengeTask.UINLevelChallengeTask")
UINLevelNormalNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelDetailRewardItem, UINBaseItemWithReceived, UINLevelChallengeTask
  self.sectorNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__ShowRewardDetail = BindCallback(self, self.ShowRewardDetail)
  self.rewardItemPool = (UIItemPool.New)(UINLevelDetailRewardItem, (self.ui).itemWithCount)
  self.wcRankRewardItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).itemWithCount)
  self.emptyItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).obj_EmptyItem)
  ;
  ((self.ui).itemWithCount):SetActive(false)
  self.challengeTaskNode = (UINLevelChallengeTask.New)()
  ;
  (self.challengeTaskNode):Init((self.ui).challenge)
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).Loop_InfinityLayerReardRect).onInstantiateItem = BindCallback(self, self.m_NewInfinityItem)
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).Loop_InfinityLayerReardRect).onChangeItem = BindCallback(self, self.m_ChangeInfinityItem)
  self._addActivityExRewardsFunc = BindCallback(self, self._AddActivityExRewards)
  self.linfinityLayerDataList = {}
  self.infinityLayerItemDic = {}
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).obj_LayerParent = ((((self.ui).tex_Layer).transform).parent).gameObject
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_periodic_ShowRank, self, self.ShowWeeklyChallengeRank)
end

UINLevelNormalNode.InitInfoNode = function(self, LevelDtail)
  -- function num : 0_1 , upvalues : eDetailType, _ENV
  self.LevelDtail = LevelDtail
  ;
  ((self.ui).obj_EmptyItem):SetActive(false)
  ;
  ((self.ui).obj_infinity):SetActive(false)
  ;
  ((self.ui).obj_normal):SetActive(false)
  ;
  ((self.ui).obj_reward):SetActive(false)
  ;
  ((self.ui).tips_relation):SetActive(false)
  ;
  (self.challengeTaskNode):Hide()
  if LevelDtail.detailType == eDetailType.Stage then
    local stageCfg = LevelDtail.stageCfg
    ;
    ((self.ui).obj_normal):SetActive(true)
    ;
    ((self.ui).obj_reward):SetActive(true)
    ;
    ((self.ui).tex_LevelName):SetIndex(0, (LanguageUtil.GetLocaleText)(stageCfg.name))
    ;
    (((self.ui).tex_LevelInfo).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)(stageCfg.introduce)
    local sectorId = ConfigData:GetSectorIdShow(stageCfg.sector)
    if ((ConfigData.sector).onlyShowStageIdSectorDic)[stageCfg.sector] then
      ((self.ui).tex_IdName):SetIndex(3, tostring(stageCfg.num))
    else
      ;
      ((self.ui).tex_IdName):SetIndex(0, tostring(sectorId), tostring(stageCfg.num))
    end
    local isWeeklyChallengeSector = (table.contain)((ConfigData.game_config).weeklyChallengeSectorIds, stageCfg.sector)
    if isWeeklyChallengeSector then
      (((self.ui).tex_IdName).gameObject):SetActive(false)
    end
    local layerCount = #stageCfg.exploration_list or 1
    ;
    ((self.ui).obj_LayerParent):SetActive(true)
    ;
    (((self.ui).tex_Layer).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Layer):SetIndex(0, tostring(layerCount))
    ;
    ((self.ui).obj_periodic):SetActive(false)
    self:RefreshLevelReward(stageCfg)
  else
    do
      if LevelDtail:LvDetailIsChallengeMode() then
        if LevelDtail.detailType == eDetailType.Avg then
          ((self.ui).obj_normal):SetActive(true)
          ;
          ((self.ui).obj_reward):SetActive(true)
          local avgCfg = LevelDtail.avgCfg
          ;
          ((self.ui).tex_LevelName):SetIndex(0, (LanguageUtil.GetLocaleText)(avgCfg.name))
          ;
          (((self.ui).tex_LevelInfo).gameObject):SetActive(true)
          -- DECOMPILER ERROR at PC185: Confused about usage of register: R3 in 'UnsetPending'

          ;
          ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)(avgCfg.describe)
          ;
          ((self.ui).tex_IdName):SetIndex(1, tostring(avgCfg.number))
          ;
          ((self.ui).obj_LayerParent):SetActive(false)
          ;
          (((self.ui).tex_Layer).gameObject):SetActive(false)
          ;
          ((self.ui).obj_periodic):SetActive(false)
          self:RefreshAvgReward(avgCfg)
        else
          do
            if LevelDtail.detailType == eDetailType.Infinity then
              local infinityCfg = (LevelDtail.levelData).cfg
              local levelData = LevelDtail.levelData
              ;
              ((self.ui).obj_infinity):SetActive(true)
              ;
              ((self.ui).obj_reward):SetActive(true)
              ;
              ((self.ui).tex_LevelName):SetIndex(1, tostring(infinityCfg.index * 10))
              ;
              (((self.ui).tex_LevelInfo).gameObject):SetActive(false)
              ;
              ((self.ui).tex_IdName):SetIndex(2, "?", tostring(#infinityCfg.layer))
              ;
              ((self.ui).obj_periodic):SetActive(false)
              self:RefreshInfinityReward(levelData)
              self:RefreshInfinityLevelReward(levelData)
            else
              do
                if LevelDtail.detailType == eDetailType.PeriodicChallenge then
                  local eChallengeType = LevelDtail.eChallengeType
                  local challengeId = LevelDtail.challengeId
                  local challengeCfg = (ConfigData.daily_challenge)[challengeId]
                  if challengeCfg == nil then
                    error("can\'t read challengeCfg with id:" .. tostring(challengeId))
                  end
                  ;
                  ((self.ui).obj_normal):SetActive(true)
                  ;
                  ((self.ui).obj_reward):SetActive(true)
                  ;
                  ((self.ui).tex_LevelName):SetIndex(0, (LanguageUtil.GetLocaleText)(challengeCfg.name))
                  ;
                  (((self.ui).tex_LevelInfo).gameObject):SetActive(true)
                  -- DECOMPILER ERROR at PC317: Confused about usage of register: R5 in 'UnsetPending'

                  ;
                  ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)(challengeCfg.introduce)
                  ;
                  (((self.ui).tex_IdName).gameObject):SetActive(false)
                  local layerCount = "3"
                  ;
                  ((self.ui).obj_LayerParent):SetActive(true)
                  ;
                  (((self.ui).tex_Layer).gameObject):SetActive(true)
                  ;
                  ((self.ui).tex_Layer):SetIndex(0, tostring(layerCount))
                  ;
                  ((self.ui).obj_periodic):SetActive(false)
                  self:RefreshPeriodicChallengeReward(challengeCfg, eChallengeType)
                else
                  do
                    if LevelDtail.detailType == eDetailType.WeeklyChallenge then
                      local challengeId = LevelDtail.challengeId
                      local WCData = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeDataByDungeonId(challengeId)
                      local challengeCfg = WCData:GetWCConfig()
                      ;
                      ((self.ui).obj_normal):SetActive(true)
                      ;
                      ((self.ui).obj_reward):SetActive(false)
                      ;
                      ((self.ui).tex_LevelName):SetIndex(0, (LanguageUtil.GetLocaleText)(challengeCfg.name))
                      ;
                      (((self.ui).tex_LevelInfo).gameObject):SetActive(true)
                      -- DECOMPILER ERROR at PC397: Confused about usage of register: R5 in 'UnsetPending'

                      ;
                      ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)(challengeCfg.introduce)
                      ;
                      (((self.ui).tex_IdName).gameObject):SetActive(false)
                      local layerCount = "3"
                      ;
                      ((self.ui).obj_LayerParent):SetActive(true)
                      ;
                      (((self.ui).tex_Layer).gameObject):SetActive(true)
                      ;
                      ((self.ui).tex_Layer):SetIndex(0, tostring(layerCount))
                      ;
                      ((self.ui).obj_rankNode):SetActive(WCData:GetIsHaveRankList())
                      ;
                      ((self.ui).obj_periodic):SetActive(true)
                      self:RefreshWeeklyChallengeInfo(WCData)
                    else
                      do
                        if LevelDtail.detailType == eDetailType.Warchess then
                          local stageCfg = LevelDtail.stageCfg
                          ;
                          ((self.ui).obj_normal):SetActive(true)
                          ;
                          ((self.ui).obj_reward):SetActive(true)
                          ;
                          ((self.ui).tex_LevelName):SetIndex(0, (LanguageUtil.GetLocaleText)(stageCfg.name))
                          ;
                          (((self.ui).tex_LevelInfo).gameObject):SetActive(true)
                          -- DECOMPILER ERROR at PC475: Confused about usage of register: R3 in 'UnsetPending'

                          ;
                          ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)(stageCfg.introduce)
                          local sectorId = ConfigData:GetSectorIdShow(stageCfg.sector)
                          if ((ConfigData.sector).onlyShowStageIdSectorDic)[stageCfg.sector] then
                            ((self.ui).tex_IdName):SetIndex(3, tostring(stageCfg.num))
                          else
                            ;
                            ((self.ui).tex_IdName):SetIndex(0, tostring(sectorId), tostring(stageCfg.num))
                          end
                          local actSector3Ctrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
                          if actSector3Ctrl ~= nil then
                            local rankId = actSector3Ctrl:GetHardLevelRankId(LevelDtail.challengeId)
                            local rankCfg = (ConfigData.common_ranklist)[rankId]
                            -- DECOMPILER ERROR at PC528: Confused about usage of register: R7 in 'UnsetPending'

                            if rankCfg ~= nil then
                              ((self.ui).tex_periodic_name).text = (LanguageUtil.GetLocaleText)(rankCfg.option_name)
                              ;
                              ((self.ui).obj_periodic):SetActive(true)
                              local score = actSector3Ctrl:GetHardLevelScore(LevelDtail.challengeId)
                              -- DECOMPILER ERROR at PC546: Confused about usage of register: R8 in 'UnsetPending'

                              if rankCfg.option_show_type == 1 then
                                ((self.ui).tex_periodic_Scoure).text = (BattleUtil.FrameToTimeString)(score)
                              else
                                -- DECOMPILER ERROR at PC553: Confused about usage of register: R8 in 'UnsetPending'

                                ;
                                ((self.ui).tex_periodic_Scoure).text = tostring(score)
                              end
                            else
                              do
                                do
                                  do
                                    ;
                                    ((self.ui).obj_periodic):SetActive(false)
                                    ;
                                    ((self.ui).obj_periodic):SetActive(false)
                                    ;
                                    ((self.ui).obj_LayerParent):SetActive(false)
                                    self:RefreshWarchessDrop(stageCfg)
                                    self:ForceRefresh()
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

UINLevelNormalNode.ForceRefresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)((self.ui).normalList)
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)((self.ui).maybeList)
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)((self.ui).rect)
end

UINLevelNormalNode.RefreshLevelReward = function(self, stageCfg)
  -- function num : 0_3 , upvalues : _ENV, SectorEnum
  (((self.ui).normalList).gameObject):SetActive(true)
  ;
  (((self.ui).maybeList).gameObject):SetActive(true)
  ;
  ((self.ui).txtInfo_firsRewardList):SetIndex(0)
  ;
  ((self.ui).txt_maybeRewardList):SetIndex(0)
  ;
  (((self.ui).specialList).gameObject):SetActive(false)
  ;
  (self.rewardItemPool):HideAll()
  local isPicked = false
  local stageState = (PlayerDataCenter.sectorStage):GetStageState(stageCfg.id)
  if stageState ~= proto_object_DungeonStageState.DungeonStageStateNone or stageState == proto_object_DungeonStageState.DungeonStageStateCompleted then
    (self.sectorNetworkCtrl):Send_SECTOR_BattleFirstRewardPick(stageCfg.id)
    isPicked = true
  else
    if stageState == proto_object_DungeonStageState.DungeonStageStatePicked then
      isPicked = true
    end
  end
  local firstDropItemLimt = (self.ui).firstDropItemLimt or 4
  local rewardCount = 0
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  if sectorCfg == nil then
    error(" sectorCfg  is \tNIL")
    return 
  end
  if sectorCfg.reward_show_type == (SectorEnum.SectorRewardShowType).FixedReward then
    ((self.ui).txtInfo_firsRewardList):SetIndex(3)
    for i,rewardId in ipairs(stageCfg.reward_ids) do
      local rewardNum = (stageCfg.reward_nums)[i]
      rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum)
    end
  else
  end
  do
    if sectorCfg.reward_show_type == (SectorEnum.SectorRewardShowType).HideReward then
      for index,rewardId in ipairs(stageCfg.first_reward_ids) do
        local rewardNum = (stageCfg.first_reward_nums)[index]
        rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum, isPicked, false)
      end
      local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
      local extraIds, extraNums = activityFrameCtrl:GetExtraSectorStageFirstReward(stageCfg.id)
      if extraIds ~= nil then
        for index,rewardId in ipairs(extraIds) do
          local rewardNum = extraNums[index]
          rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum, isPicked, false)
        end
      end
      do
        do
          rewardCount = (self._addActivityExRewardsFunc)(rewardCount, stageCfg)
          ;
          (self.emptyItemPool):HideAll()
          if rewardCount < firstDropItemLimt then
            for i = 1, firstDropItemLimt - rewardCount do
              local emptyGo = (self.emptyItemPool):GetOne(true)
              ;
              (emptyGo.transform):SetParent((self.ui).normalList)
            end
          end
          do
            if rewardCount == 0 then
              ((self.ui).obj_reward):SetActive(false)
            end
            local normalCount = #stageCfg.normal_drop
            ;
            (((self.ui).maybeList).gameObject):SetActive(normalCount > 0)
            for k,itemId in ipairs(stageCfg.normal_drop) do
              if (self.ui).mayDropItemLimt or 3 >= k then
                local itemCfg = (ConfigData.item)[itemId]
                do
                  local rewardItem = (self.rewardItemPool):GetOne()
                  ;
                  (rewardItem.transform):SetParent((self.ui).maybeList)
                  rewardItem:InitItemWithCount(itemCfg, nil, self.__ShowRewardDetail)
                  -- DECOMPILER ERROR at PC221: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC221: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
            if isPicked then
              ((self.ui).normalList):SetAsLastSibling()
            else
              ((self.ui).maybeList):SetAsLastSibling()
            end
            -- DECOMPILER ERROR: 6 unprocessed JMP targets
          end
        end
      end
    end
  end
end

UINLevelNormalNode.RefreshAvgReward = function(self, avgCfg)
  -- function num : 0_4 , upvalues : _ENV
  (self.emptyItemPool):HideAll()
  ;
  ((self.ui).txtInfo_firsRewardList):SetIndex(1)
  ;
  (((self.ui).maybeList).gameObject):SetActive(false)
  ;
  (((self.ui).specialList).gameObject):SetActive(false)
  ;
  (self.rewardItemPool):HideAll()
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local played = avgPlayCtrl:IsAvgPlayed(avgCfg.id)
  local rewardDic = {}
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameData = actCtrl:GetActivityFrameData(avgCfg.activity_id)
  if actFrameData ~= nil and actFrameData:IsActivityOpen() and not actFrameData:IsActivityRunningTimeout() then
    for i,itemId in ipairs(avgCfg.activityRewardIds) do
      local count = rewardDic[itemId] or 0
      rewardDic[itemId] = count + (avgCfg.activityRewardNums)[i]
    end
  end
  do
    for k,itemId in ipairs(avgCfg.rewardIds) do
      local count = rewardDic[itemId] or 0
      rewardDic[itemId] = count + (avgCfg.rewardNums)[k]
    end
    local isShow = (table.count)(rewardDic) > 0
    ;
    ((self.ui).obj_reward):SetActive(isShow)
    if not isShow then
      return 
    end
    local rewardCount = 0
    local rewardCountMax = (self.ui).AvgDropItemLimt or 5
    for itemId,itemNum in pairs(rewardDic) do
      if rewardCountMax > rewardCount then
        do
          rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, itemId, itemNum, played, false)
          -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINLevelNormalNode.RefreshInfinityReward = function(self, levelData)
  -- function num : 0_5 , upvalues : _ENV
  local infinityCfg = levelData.cfg
  ;
  (self.emptyItemPool):HideAll()
  ;
  (self.rewardItemPool):HideAll()
  ;
  ((self.ui).txtInfo_firsRewardList):SetIndex(2)
  ;
  (((self.ui).specialList).gameObject):SetActive(false)
  ;
  (((self.ui).normalList).gameObject):SetActive(#infinityCfg.clear_reward_itemIds > 0)
  for index,rewardId in ipairs(infinityCfg.clear_reward_itemIds) do
    local rewardNum = (infinityCfg.clear_reward_itemNums)[index]
    local itemCfg = (ConfigData.item)[rewardId]
    local rewardItem = (self.rewardItemPool):GetOne()
    ;
    (rewardItem.transform):SetParent((self.ui).normalList)
    rewardItem:InitItemWithCount(itemCfg, rewardNum, self.__ShowRewardDetail, levelData.isComplete)
  end
  if levelData.isComplete then
    ((self.ui).txt_maybeRewardList):SetIndex(0)
    ;
    (((self.ui).maybeList).gameObject):SetActive(#infinityCfg.normal_drop > 0)
    for k,itemId in ipairs(infinityCfg.normal_drop) do
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        error("can\'t get itemCfg withId:" .. tostring(itemId))
      end
      local rewardItem = (self.rewardItemPool):GetOne()
      ;
      (rewardItem.transform):SetParent((self.ui).maybeList)
      rewardItem:InitItemWithCount(itemCfg, nil, self.__ShowRewardDetail)
    end
    ;
    ((self.ui).maybeList):SetAsFirstSibling()
  else
    (((self.ui).maybeList).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINLevelNormalNode.RefreshInfinityLevelReward = function(self, levelData)
  -- function num : 0_6 , upvalues : _ENV
  local infinityCfg = levelData.cfg
  self.linfinityLayerDataList = {}
  for index,layerId in ipairs(infinityCfg.layer) do
    local isPass = false
    if levelData.isComplete or index <= levelData.passNum then
      isPass = true
    end
    ;
    (table.insert)(self.linfinityLayerDataList, {id = layerId, index = index, isPass = isPass})
  end
  local num = #self.linfinityLayerDataList
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).Loop_InfinityLayerReardRect).totalCount = num
  ;
  ((self.ui).Loop_InfinityLayerReardRect):RefillCells()
end

UINLevelNormalNode.RefreshPeriodicChallengeReward = function(self, challengeCfg, eChallengeType)
  -- function num : 0_7 , upvalues : PeridicChallengeEnum, _ENV
  (((self.ui).maybeList).gameObject):SetActive(false)
  ;
  (((self.ui).specialList).gameObject):SetActive(false)
  ;
  (self.emptyItemPool):HideAll()
  ;
  (self.rewardItemPool):HideAll()
  if #challengeCfg.daily_dropIds <= 0 then
    (((self.ui).normalList).gameObject):SetActive(eChallengeType ~= (PeridicChallengeEnum.eChallengeType).daliy)
    for index,rewardId in ipairs(challengeCfg.daily_dropIds) do
      local rewardNum = (challengeCfg.daily_dropNums)[index]
      local itemCfg = (ConfigData.item)[rewardId]
      local rewardItem = (self.rewardItemPool):GetOne()
      ;
      (rewardItem.transform):SetParent((self.ui).normalList)
      rewardItem:InitItemWithCount(itemCfg, rewardNum, self.__ShowRewardDetail, (PlayerDataCenter.periodicChallengeData):GetIsDailyChallengeFished(), false)
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINLevelNormalNode.RefreshWarchessDrop = function(self, stageCfg)
  -- function num : 0_8 , upvalues : _ENV
  ((self.ui).txtInfo_firsRewardList):SetIndex(0)
  ;
  ((self.ui).txt_maybeRewardList):SetIndex(0)
  ;
  (self.rewardItemPool):HideAll()
  ;
  (self.emptyItemPool):HideAll()
  ;
  ((self.ui).obj_reward):SetActive(false)
  local func_showReward = function(recordDic, boxCfgs)
    -- function num : 0_8_0 , upvalues : _ENV, self, stageCfg
    if IsNull(self.transform) then
      return 
    end
    local rewardShowCount = 0
    local isFirstPicked = nil
    local stageState = (PlayerDataCenter.sectorStage):GetStageState(stageCfg.id)
    if stageState ~= proto_object_DungeonStageState.DungeonStageStateNone or stageState == proto_object_DungeonStageState.DungeonStageStateCompleted then
      (self.sectorNetworkCtrl):Send_SECTOR_BattleFirstRewardPick(stageCfg.id)
      isFirstPicked = true
    else
      if stageState == proto_object_DungeonStageState.DungeonStageStatePicked then
        isFirstPicked = true
      end
    end
    for index,rewardId in ipairs(stageCfg.first_reward_ids) do
      local rewardNum = (stageCfg.first_reward_nums)[index]
      rewardShowCount = self:__CreateDetailRewardItem(rewardShowCount, (self.ui).normalList, rewardId, rewardNum, isFirstPicked, false)
    end
    local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
    local extraIds, extraNums = activityFrameCtrl:GetExtraSectorStageFirstReward(stageCfg.id)
    if extraIds ~= nil then
      for index,rewardId in ipairs(extraIds) do
        local rewardNum = extraNums[index]
        rewardShowCount = self:__CreateDetailRewardItem(rewardShowCount, (self.ui).normalList, rewardId, rewardNum, isFirstPicked, false)
      end
    end
    do
      rewardShowCount = (self._addActivityExRewardsFunc)(rewardShowCount, stageCfg)
      ;
      (((self.ui).normalList).gameObject):SetActive(rewardShowCount > 0)
      local specialCount = 0
      if boxCfgs ~= nil then
        for boxId,boxCfg in pairs(boxCfgs) do
          local isPicked = recordDic ~= nil and recordDic[boxId] ~= nil
          for index,itemId in ipairs(boxCfg.reward_ids) do
            local itemNum = (boxCfg.reward_nums)[index]
            specialCount = self:__CreateDetailRewardItem(specialCount, (self.ui).specialList, itemId, itemNum, isPicked, false)
          end
        end
      end
      ;
      (((self.ui).specialList).gameObject):SetActive(specialCount > 0)
      local normalShowCount = #stageCfg.normal_drop
      if normalShowCount > 0 then
        for k,itemId in ipairs(stageCfg.normal_drop) do
          if (self.ui).mayDropItemLimt or 3 >= k then
            do
              self:__CreateDetailRewardItem(normalShowCount, (self.ui).maybeList, itemId, nil)
              -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC161: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
        if isFirstPicked then
          ((self.ui).maybeList):SetAsLastSibling()
          ;
          ((self.ui).specialList):SetAsLastSibling()
          ;
          ((self.ui).normalList):SetAsLastSibling()
        else
          ((self.ui).normalList):SetAsLastSibling()
          ;
          ((self.ui).maybeList):SetAsLastSibling()
          ;
          ((self.ui).specialList):SetAsLastSibling()
        end
      end
      ;
      (((self.ui).maybeList).gameObject):SetActive(normalShowCount > 0)
      if specialCount == 0 and rewardShowCount == 0 and normalShowCount == 0 then
        ((self.ui).obj_reward):SetActive(false)
        return 
      end
      ;
      ((self.ui).obj_reward):SetActive(true)
      self:ForceRefresh()
      -- DECOMPILER ERROR: 14 unprocessed JMP targets
    end
  end

  local warchessId = (stageCfg.exploration_list)[1]
  local boxCfgs = (ConfigData.warchess_level_real_rewards)[warchessId]
  if boxCfgs == nil then
    func_showReward(nil, nil)
    return 
  end
  local warchessNet = NetworkManager:GetNetwork(NetworkTypeID.WarChess)
  warchessNet:CS_WarChess_UniqueRewardBrief(warchessId, function(objList)
    -- function num : 0_8_1 , upvalues : _ENV, self, func_showReward, boxCfgs
    if IsNull(self.transform) then
      return 
    end
    if objList == nil or objList.Count == 0 then
      return 
    end
    local records = objList[0]
    func_showReward(records, boxCfgs)
  end
)
end

UINLevelNormalNode._AddActivityExRewards = function(self, rewardCount, stageCfg)
  -- function num : 0_9 , upvalues : _ENV, ActivityFrameEnum
  local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(stageCfg.sector)
  if actData and not actData:IsActivityRunningTimeout() then
    if actType == (ActivityFrameEnum.eActivityType).SectorI then
      local _, data, inRuning = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorIdRunning(stageCfg.sector)
      local relationCfg = data:GetRelationStage(stageCfg.id)
      if relationCfg ~= nil then
        ((self.ui).tips_relation):SetActive(true)
        local relationStageState = (PlayerDataCenter.sectorStage):GetStageState(relationCfg.id)
        local relationPick = relationStageState == proto_object_DungeonStageState.DungeonStageStatePicked
        for index,rewardId in ipairs(relationCfg.first_reward_ids) do
          local rewardNum = (relationCfg.first_reward_nums)[index]
          rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum, relationPick, true)
        end
      end
    elseif actType == (ActivityFrameEnum.eActivityType).Winter23 then
      local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
      local activityData = win23Ctrl:GetWinter23DataByActId(actId)
      local relationCfg = activityData:GetRelationStage(stageCfg.id)
      if relationCfg ~= nil then
        local relationStageState = (PlayerDataCenter.sectorStage):GetStageState(relationCfg.id)
        local relationPick = relationStageState == proto_object_DungeonStageState.DungeonStageStatePicked
        for index,rewardId in ipairs(relationCfg.first_reward_ids) do
          local rewardNum = (relationCfg.first_reward_nums)[index]
          rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum, relationPick, true)
        end
      end
    end
  end
  do return rewardCount end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINLevelNormalNode.m_NewInfinityItem = function(self, go)
  -- function num : 0_10 , upvalues : UINLNNInfinityLayerItem
  local layerItem = (UINLNNInfinityLayerItem.New)()
  layerItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.infinityLayerItemDic)[go] = layerItem
end

UINLevelNormalNode.m_ChangeInfinityItem = function(self, go, index)
  -- function num : 0_11 , upvalues : _ENV
  local layerItem = (self.infinityLayerItemDic)[go]
  if layerItem == nil then
    error("Can\'t find layerItem by gameObject")
    return 
  end
  local LayerData = (self.linfinityLayerDataList)[index + 1]
  if LayerData == nil then
    error("Can\'t find LayerData by index, index = " .. tonumber(index))
  end
  layerItem:InitNodeInfinityLevel(LayerData)
end

UINLevelNormalNode.ShowRewardDetail = function(self, itemCfg)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_12_0 , upvalues : itemCfg
    if win ~= nil then
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
end

UINLevelNormalNode.RefreshWeeklyChallengeInfo = function(self, WCData)
  -- function num : 0_13 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_periodic_Scoure).text = tostring(WCData:GetCurrentMaxScore())
end

UINLevelNormalNode.ShowWeeklyChallengeRank = function(self)
  -- function num : 0_14 , upvalues : eDetailType, _ENV
  if (self.LevelDtail).detailType == eDetailType.Warchess then
    local actSector3Ctrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
    do
      do
        if actSector3Ctrl ~= nil then
          local rankId = actSector3Ctrl:GetHardLevelRankId((self.LevelDtail).challengeId)
          do
            if rankId ~= nil then
              (UIUtil.OnClickBack)()
              UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_14_0 , upvalues : rankId
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank(rankId)
  end
)
            end
          end
        end
        local challengeId = (self.LevelDtail).challengeId
        ;
        (UIUtil.OnClickBack)()
        UIManager:ShowWindowAsync(UIWindowTypeID.WeeklyChallengeRank, function(win)
    -- function num : 0_14_1 , upvalues : challengeId
    if win ~= nil then
      win:GenWCRPageTogs(challengeId)
    end
  end
)
      end
    end
  end
end

UINLevelNormalNode.__CreateDetailRewardItem = function(self, oriCount, parentTr, itemId, itemNum, isPick, showTag)
  -- function num : 0_15 , upvalues : _ENV
  local rewardItem = (self.rewardItemPool):GetOne()
  ;
  (rewardItem.transform):SetParent(parentTr)
  local itemCfg = (ConfigData.item)[itemId]
  rewardItem:InitItemWithCount(itemCfg, itemNum, self.__ShowRewardDetail, isPick, showTag)
  return (oriCount or 0) + 1
end

UINLevelNormalNode.ShowLvNormalChallengeTask = function(self, show, stageCfg)
  -- function num : 0_16
  if show then
    (self.challengeTaskNode):Hide()
  end
end

UINLevelNormalNode.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (self.challengeTaskNode):Delete()
  ;
  (base.OnDelete)(self)
end

return UINLevelNormalNode

