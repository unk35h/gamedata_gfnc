-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunLevelNormalNode = class("UINLevelNormalNode", UIBaseNode)
local base = UIBaseNode
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local UINLevelDetailRewardItem = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelDetailRewardItem")
local CS_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UINDunLevelNormalNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelDetailRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowRank, self, self._OnClickShowRank)
  self.rewardItemPool = (UIItemPool.New)(UINLevelDetailRewardItem, (self.ui).itemWithCount)
  ;
  ((self.ui).itemWithCount):SetActive(false)
end

UINDunLevelNormalNode.BindDunLevelResloader = function(self, resloader)
  -- function num : 0_1
  self.__resloader = resloader
end

UINDunLevelNormalNode.InitDungeonInfoNode = function(self, dLevelDetail)
  -- function num : 0_2
  self.__dLevelDetail = dLevelDetail
  local dunLevelData = dLevelDetail:GetDungeonLevelData()
  ;
  ((self.ui).tex_LevelName):SetIndex(0, dunLevelData:GetDungeonLevelName())
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelInfo).text = dunLevelData:GetDungeonInfoDesc()
  self:RefreshDLevelReward()
  self:RefreshDLevelWave()
  self:_UpdRanking()
end

UINDunLevelNormalNode.RefreshDLevelReward = function(self)
  -- function num : 0_3 , upvalues : DungeonLevelEnum, _ENV, CS_LayoutRebuilder
  local dunLevelData = (self.__dLevelDetail):GetDungeonLevelData()
  local dungeonType = dunLevelData:GetDungeonLevelType()
  if dungeonType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge or dungeonType == (DungeonLevelEnum.DunLevelType).ADC then
    ((self.ui).obj_reward):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_reward):SetActive(true)
  ;
  (((self.ui).normalList).gameObject):SetActive(true)
  ;
  (((self.ui).maybeList).gameObject):SetActive(false)
  ;
  (self.rewardItemPool):HideAll()
  local rewardCount = 0
  local dunLevelData = (self.__dLevelDetail):GetDungeonLevelData()
  local isPicked = false
  if dungeonType == (DungeonLevelEnum.DunLevelType).Tower then
    local levelNum = dunLevelData:GetDunTowerLevelNum()
    local towerId = dunLevelData:GetDungeonTowerType()
    isPicked = levelNum <= (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
  else
    isPicked = PlayerDataCenter:GetTotalBattleTimes(dunLevelData:GetDungeonLevelStageId()) > 0
  end
  local dunLevelType = dunLevelData:GetDungeonLevelType()
  if dunLevelType == (DungeonLevelEnum.DunLevelType).Tower or dunLevelType == (DungeonLevelEnum.DunLevelType).Carnival or dungeonType == (DungeonLevelEnum.DunLevelType).Spring then
    local first_reward_ids, first_reward_nums = dunLevelData:GetDungeonFirstReward()
    ;
    ((self.ui).txtInfo_firsRewardList):SetIndex(0)
    for index,rewardId in ipairs(first_reward_ids) do
      local rewardNum = first_reward_nums[index]
      rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, rewardId, rewardNum, isPicked, false)
    end
  elseif dunLevelType == (DungeonLevelEnum.DunLevelType).SectorII or dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIII then
    local dropDic = dunLevelData:GetCommonActDropData()
    ;
    ((self.ui).txtInfo_firsRewardList):SetIndex(3)
    for itemId,numTable in pairs(dropDic) do
      local num = nil
      if numTable.max == nil then
        num = numTable.min
      elseif numTable.max >= 1000 then
        num = tostring(numTable.min) .. "+"
      else
        num = tostring(numTable.min) .. "-" .. tostring(numTable.max)
      end
      rewardCount = self:__CreateDetailRewardItem(rewardCount, (self.ui).normalList, R18_PC160, num, false, false)
    end
  elseif dunLevelType == (DungeonLevelEnum.DunLevelType).HeroGrow or dungeonType == (DungeonLevelEnum.DunLevelType).Season then
    (((self.ui).maybeList).gameObject):SetActive(true)
    local first_reward_ids, first_reward_nums = dunLevelData:GetDungeonFirstReward()
    ;
    ((self.ui).txtInfo_firsRewardList):SetIndex(0)
    for index,rewardId in ipairs(first_reward_ids) do
      local rewardNum = first_reward_nums[index]
      -- DECOMPILER ERROR at PC194: Overwrote pending register: R18 in 'AssignReg'

      rewardCount = self:__CreateDetailRewardItem(rewardCount, R18_PC160, rewardId, rewardNum, isPicked, false)
    end
    local dropDic = dunLevelData:GetCommonActDropData()
    for itemId,numTable in pairs(dropDic) do
      local num = nil
      if numTable.max == nil then
        num = numTable.min
      elseif numTable.max >= 1000 then
        num = tostring(numTable.min) .. "+"
      else
        -- DECOMPILER ERROR at PC228: Overwrote pending register: R18 in 'AssignReg'

        num = tostring(numTable.min) .. "-" .. R18_PC160
      end
      -- DECOMPILER ERROR at PC233: Overwrote pending register: R18 in 'AssignReg'

      rewardCount = self:__CreateDetailRewardItem(R18_PC160, (self.ui).maybeList, itemId, num, false, false)
    end
    ;
    (CS_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).obj_reward).transform)
  end
  -- DECOMPILER ERROR: 20 unprocessed JMP targets
end

UINDunLevelNormalNode.RefreshDLevelWave = function(self)
  -- function num : 0_4 , upvalues : DungeonLevelEnum, _ENV
  local dunLevelData = (self.__dLevelDetail):GetDungeonLevelData()
  local dunLevelType = dunLevelData:GetDungeonLevelType()
  if dunLevelType == (DungeonLevelEnum.DunLevelType).Tower then
    ((self.ui).obj_levelName):SetActive(false)
  else
    if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorII or dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIII then
      ((self.ui).obj_levelName):SetActive(true)
      ;
      ((self.ui).tex_Layer):SetIndex(1, tostring(dunLevelData:GetWaveNum()))
    else
      if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
        ((self.ui).obj_levelName):SetActive(true)
        ;
        ((self.ui).tex_Layer):SetIndex(2, tostring(dunLevelData:GetSctIIChallengeDgLvNum()))
      else
        ;
        ((self.ui).obj_levelName):SetActive(false)
      end
    end
  end
end

UINDunLevelNormalNode.__CreateDetailRewardItem = function(self, oriCount, parentTr, itemId, itemNum, isPick, showTag)
  -- function num : 0_5 , upvalues : _ENV
  local rewardItem = (self.rewardItemPool):GetOne()
  ;
  (rewardItem.transform):SetParent(parentTr)
  local itemCfg = (ConfigData.item)[itemId]
  rewardItem:InitItemWithCount(itemCfg, itemNum, self.__ShowRewardDetail, isPick, showTag)
  return (oriCount or 0) + 1
end

UINDunLevelNormalNode._UpdRanking = function(self)
  -- function num : 0_6 , upvalues : DungeonLevelEnum, _ENV
  local dunLevelData = (self.__dLevelDetail):GetDungeonLevelData()
  local dunLevelType = dunLevelData:GetDungeonLevelType()
  ;
  ((self.ui).ranking):SetActive(false)
  ;
  (((self.ui).btn_ShowRank).gameObject):SetActive(true)
  if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    ((self.ui).ranking):SetActive(true)
    local maxScore = dunLevelData:GetSctIIChallengeDgMaxScore()
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_MaxRankScoure).text = tostring(maxScore)
    ;
    (((self.ui).btn_ShowRank).gameObject):SetActive(false)
  else
    do
      if dunLevelType == (DungeonLevelEnum.DunLevelType).ADC then
        ((self.ui).ranking):SetActive(true)
        local maxScore = dunLevelData:GetDungeonADCScore()
        -- DECOMPILER ERROR at PC56: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).tex_MaxRankScoure).text = tostring(maxScore)
      end
    end
  end
end

UINDunLevelNormalNode._OnClickShowRank = function(self)
  -- function num : 0_7 , upvalues : DungeonLevelEnum, _ENV
  local rankId = nil
  local dunLevelData = (self.__dLevelDetail):GetDungeonLevelData()
  local dunLevelType = dunLevelData:GetDungeonLevelType()
  if dunLevelType == (DungeonLevelEnum.DunLevelType).SectorIIChallenge then
    rankId = dunLevelData:GetSctIIChallengeDgRankId()
  else
    if dunLevelType == (DungeonLevelEnum.DunLevelType).ADC then
      rankId = dunLevelData:GetDungeonADCRankId()
    end
  end
  if rankId == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_7_0 , upvalues : rankId
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank(rankId)
  end
)
end

return UINDunLevelNormalNode

