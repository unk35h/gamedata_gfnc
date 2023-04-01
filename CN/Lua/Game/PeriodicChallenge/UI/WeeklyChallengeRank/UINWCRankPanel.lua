-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCRankPanel = class("UINWCRankPanel", UIBaseNode)
local base = UIBaseNode
local UINWCRankPanelItem = require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankPanelItem")
local eType = (require("Game.PeriodicChallenge.UI.WeeklyChallengeRank.UINWCRankRewardPanelItem")).eType
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local WCEnum = require("Game.WeeklyChallenge.WCEnum")
UINWCRankPanel.eRankListType = {cur = 1, old = 2}
UINWCRankPanel.eDragWay = {down = 1, up = 2}
UINWCRankPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, WCEnum, UINWCRankPanel, UINUserHead
  self.rankListType = nil
  self.logicPageRankNum = (ConfigData.game_config).WeeklyChallengeRankPageNum
  self.totalRankNum = (ConfigData.game_config).WeeklyChallengeRankTotalNum
  self.maxPageNum = self:GetIndexPageNum(self.totalRankNum)
  self.curPageNum = 0
  self.sectorNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Sector)
  self.rankPlayerDataDic = {
[(WCEnum.eRankType).normal] = {
[(UINWCRankPanel.eRankListType).cur] = {}
, 
[(UINWCRankPanel.eRankListType).old] = {}
}
, 
[(WCEnum.eRankType).activity] = {
[(UINWCRankPanel.eRankListType).cur] = {}
, 
[(UINWCRankPanel.eRankListType).old] = {}
}
}
  self.itemDic = {}
  self.isHistoryInited = {}
  self.cannotDragDown = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onReturnItem = BindCallback(self, self.__OnReturnItem)
  ;
  (((self.ui).loop_scroll).onValueChanged):AddListener(BindCallback(self, self.__OnValueChange))
  self.myHead = (UINUserHead.New)()
  ;
  (self.myHead):Init((self.ui).my_uINBaseHead)
end

UINWCRankPanel.ShowRankPlayers = function(self, rankListType, challengeData, wc_cfg, resloader, rankType)
  -- function num : 0_1 , upvalues : UINWCRankPanel, _ENV
  if not rankListType then
    self.rankListType = (UINWCRankPanel.eRankListType).cur
    self.rankType = rankType
    self.wc_cfg = wc_cfg
    self.resloader = resloader
    local myInfoData = PlayerDataCenter.inforData
    ;
    (self.myHead):InitUserHeadUI(myInfoData:GetAvatarId(), myInfoData:GetAvatarFrameId(), resloader)
    if self.rankListType == (UINWCRankPanel.eRankListType).cur then
      self.curPageNum = 0
      self:TrySendGetPageData(0)
      self.dragWay = (UINWCRankPanel.eDragWay).down
    else
      if self.rankListType == (UINWCRankPanel.eRankListType).old then
        if self.isHistoryInited == nil or not (self.isHistoryInited)[self.rankType] then
          self:TrySendGetPageData(0)
          -- DECOMPILER ERROR at PC49: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.isHistoryInited)[self.rankType] = true
        else
          local num = #((self.rankPlayerDataDic)[self.rankType])[(UINWCRankPanel.eRankListType).old]
          -- DECOMPILER ERROR at PC60: Confused about usage of register: R8 in 'UnsetPending'

          ;
          ((self.ui).loop_scroll).totalCount = num
          ;
          ((self.ui).obj_emptyState):SetActive(num <= 0)
          self.__isHasFirstElement = false
          self.__isHasLastElement = false
          ;
          ((self.ui).loop_scroll):RefreshCells()
          self:RefreshSelfRank((self.oldSelfRange)[self.rankType])
        end
      end
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINWCRankPanel.__OnNewItem = function(self, go)
  -- function num : 0_2 , upvalues : UINWCRankPanelItem
  local rankItem = (UINWCRankPanelItem.New)()
  rankItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = rankItem
end

UINWCRankPanel.__OnChangeItem = function(self, go, index)
  -- function num : 0_3 , upvalues : _ENV, UINWCRankPanel
  local rankItem = (self.itemDic)[go]
  if rankItem == nil then
    error("Can\'t find goodItem by gameObject")
    return 
  end
  rankItem.o_index = index
  local rankData = nil
  if self.rankListType == (UINWCRankPanel.eRankListType).cur then
    rankData = (((self.rankPlayerDataDic)[self.rankType])[self.rankListType])[index + 1 + self.curPageNum * self.logicPageRankNum]
  else
    rankData = (((self.rankPlayerDataDic)[self.rankType])[self.rankListType])[index + 1]
  end
  if rankData == nil then
    rankItem:SetWCRItemWait4Data(index + 1)
  else
    rankItem:RefreshWCRItemInfo(rankData, self.resloader)
  end
  if index == 0 then
    self.__isHasFirstElement = true
    self.__firstElementGo = go
  else
    if index == ((self.ui).loop_scroll).totalCount - 1 then
      self.__isHasLastElement = true
      self.__lastElementGo = go
    end
  end
end

UINWCRankPanel.__OnReturnItem = function(self, go)
  -- function num : 0_4 , upvalues : _ENV
  local rankItem = (self.itemDic)[go]
  if rankItem == nil then
    error("Can\'t find levelItem by gameObject")
    return 
  end
  local index = rankItem.o_index
  if index == 0 then
    self.__isHasFirstElement = false
  else
    if index == ((self.ui).loop_scroll).totalCount - 1 then
      self.__isHasLastElement = false
    end
  end
end

UINWCRankPanel.__OnValueChange = function(self, pos)
  -- function num : 0_5 , upvalues : _ENV
  local isHasFirstElement = self.__isHasFirstElement
  local isHasLastElement = self.__isHasLastElement
  if isHasFirstElement or isHasLastElement then
    local overValue = (math.abs)((self.ui).float_overRate)
    if isHasFirstElement then
      local viewTopPos = (((self.ui).goTop_view).position).y
      local contentTopPos = (((self.__firstElementGo).transform).position).y
      if overValue < viewTopPos - contentTopPos then
        self:__OnDragOverTop()
      end
    end
    do
      if isHasLastElement then
        local viewDownPos = (((self.ui).goBotton_view).position).y
        local contentDownPos = (((self.__lastElementGo).transform).position).y
        if overValue < contentDownPos - viewDownPos then
          self:__OnDragOverBottle()
        end
      end
    end
  end
end

UINWCRankPanel.__OnDragOverTop = function(self)
  -- function num : 0_6 , upvalues : UINWCRankPanel
  if self.curPageNum == 0 then
    return 
  end
  if self.isDragOverFreshing then
    return 
  end
  if self.rankListType == (UINWCRankPanel.eRankListType).cur then
    self:TrySendGetPageData(self.curPageNum - 1)
    self.curPageNum = self.curPageNum - 1
    self.isDragOverFreshing = true
    self.dragWay = (UINWCRankPanel.eDragWay).up
  end
end

UINWCRankPanel.__OnDragOverBottle = function(self)
  -- function num : 0_7 , upvalues : UINWCRankPanel
  if self.curPageNum == self.maxPageNum then
    return 
  end
  if self.isDragOverFreshing then
    return 
  end
  if self.rankListType == (UINWCRankPanel.eRankListType).cur then
    if (self.cannotDragDown)[(UINWCRankPanel.eRankListType).cur] then
      return 
    end
    self:TrySendGetPageData(self.curPageNum + 1)
    self.curPageNum = self.curPageNum + 1
    self.isDragOverFreshing = true
    self.dragWay = (UINWCRankPanel.eDragWay).down
  else
    if self.rankListType == (UINWCRankPanel.eRankListType).old then
      if (self.cannotDragDown)[(UINWCRankPanel.eRankListType).old] then
        return 
      end
      self:TrySendGetPageData(self.curPageNum + 1)
      self.curPageNum = self.curPageNum + 1
      self.isDragOverFreshing = true
      self.dragWay = (UINWCRankPanel.eDragWay).down
    end
  end
end

UINWCRankPanel.GetIndexPageNum = function(self, index)
  -- function num : 0_8 , upvalues : _ENV
  return (math.ceil)(index / self.logicPageRankNum) - 1
end

UINWCRankPanel.TrySendGetPageData = function(self, pageNum)
  -- function num : 0_9 , upvalues : UINWCRankPanel
  (self.sectorNetworkCtrl):CS_WEEKLYCHALLENGE_RankPage(self.rankListType == (UINWCRankPanel.eRankListType).old, pageNum, self.rankType)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINWCRankPanel.GetRankPageMsg = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV
  local isOld = msg.history
  local rankType = msg.rankCat
  if rankType ~= self.rankType then
    return 
  end
  local rankKeyDic = {}
  for index,rankElem in ipairs(msg.rank) do
    rankKeyDic[rankElem.rank] = rankElem
  end
  self:Refresh2NewPage(isOld, rankType, rankKeyDic)
  self:RefreshSelfRank(msg.selfRange)
  if isOld then
    if self.oldSelfRange == nil then
      self.oldSelfRange = {}
    end
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.oldSelfRange)[self.rankType] = msg.selfRange
  end
end

UINWCRankPanel.Refresh2NewPage = function(self, isOld, rankType, rankKeyDic)
  -- function num : 0_11 , upvalues : _ENV, UINWCRankPanel
  ((self.ui).obj_emptyState):SetActive((table.count)(rankKeyDic) <= 0)
  if isOld then
    (table.merge)(((self.rankPlayerDataDic)[rankType])[(UINWCRankPanel.eRankListType).old], rankKeyDic)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

    if self.rankListType == (UINWCRankPanel.eRankListType).old then
      ((self.ui).loop_scroll).totalCount = #((self.rankPlayerDataDic)[rankType])[(UINWCRankPanel.eRankListType).old]
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.cannotDragDown)[(UINWCRankPanel.eRankListType).old] = (table.count)(rankKeyDic) < self.logicPageRankNum
      self.__isHasFirstElement = false
      self.__isHasLastElement = false
      ;
      ((self.ui).loop_scroll):RefreshCells()
    end
  else
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R4 in 'UnsetPending'

    if not isOld and self.rankListType == (UINWCRankPanel.eRankListType).cur then
      ((self.rankPlayerDataDic)[rankType])[(UINWCRankPanel.eRankListType).cur] = rankKeyDic
      local num = (table.count)(rankKeyDic)
      ;
      ((self.ui).loop_scroll):ClearCells()
      -- DECOMPILER ERROR at PC79: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).loop_scroll).totalCount = num
      -- DECOMPILER ERROR at PC88: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.cannotDragDown)[(UINWCRankPanel.eRankListType).cur] = num < self.logicPageRankNum
      self.__isHasFirstElement = false
      self.__isHasLastElement = false
      if self.dragWay == (UINWCRankPanel.eDragWay).down then
        ((self.ui).loop_scroll):RefillCells()
      elseif self.dragWay == (UINWCRankPanel.eDragWay).up then
        ((self.ui).loop_scroll):RefillCellsFromEnd()
      else
        ((self.ui).loop_scroll):RefillCells()
      end
      ;
      ((self.ui).loop_scroll):StopMovement()
    end
  end
  self.isDragOverFreshing = false
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UINWCRankPanel.RefreshSelfRank = function(self, selfRankData)
  -- function num : 0_12 , upvalues : _ENV, eType
  local lastRegion = nil
  if self.wc_cfg ~= nil then
    local rankCfgs = (ConfigData.weekly_challenge_rank_reward)[(self.wc_cfg).rank_id]
    local lastRankCfg = rankCfgs[#rankCfgs - 1]
    if lastRankCfg ~= nil and lastRankCfg.type == eType.percentRank then
      lastRegion = lastRankCfg.score / 1000
    end
  end
  do
    if selfRankData.inRank then
      ((self.ui).tex_MyRank):SetIndex(0, tostring(selfRankData.curRank))
    else
      if selfRankData.score <= 0 or selfRankData.total == 0 then
        ((self.ui).tex_MyRank):SetIndex(2)
      else
        if lastRegion ~= nil and lastRegion < selfRankData.curRank / selfRankData.total then
          ((self.ui).tex_MyRank):SetIndex(3)
        else
          ;
          ((self.ui).tex_MyRank):SetIndex(1, tostring(GetPreciseDecimalStr(selfRankData.curRank / selfRankData.total * 100, 1)))
        end
      end
    end
    -- DECOMPILER ERROR at PC75: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_MyName).text = PlayerDataCenter.playerName
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_MyScore).text = tostring(selfRankData.score)
  end
end

UINWCRankPanel.OnDelete = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnDelete)(self)
end

return UINWCRankPanel

