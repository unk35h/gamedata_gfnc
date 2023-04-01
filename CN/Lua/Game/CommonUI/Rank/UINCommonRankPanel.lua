-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonRankPanel = class("UINCommonRankPanel", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local UINCommonRankPanelItem = require("Game.CommonUI.Rank.UINCommonRankPanelItem")
local BattleUtil = require("Game.Battle.BattleUtil")
UINCommonRankPanel.eRankDragWay = {Down = 1, Up = 2}
UINCommonRankPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__resloader = ((CS.ResLoader).Create)()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).onReturnItem = BindCallback(self, self.__OnReturnItem)
  ;
  (((self.ui).loop_scroll).onValueChanged):AddListener(BindCallback(self, self.__OnValueChange))
  self.itemDic = {}
  self.myHeadNode = (UINUserHead.New)()
  ;
  (self.myHeadNode):Init((self.ui).my_uINBaseHead)
  self.__rankPageNum = (ConfigData.buildinConfig).CommonRankPageNum
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).tex_MyRank).text).text = ""
end

UINCommonRankPanel.InitCommonRankPanel = function(self, rankCfg)
  -- function num : 0_1 , upvalues : _ENV, UINCommonRankPanel
  self.__rankCfg = rankCfg
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ScoureTitle).text = (LanguageUtil.GetLocaleText)(rankCfg.option_name)
  local myInfoData = PlayerDataCenter.inforData
  ;
  (self.myHeadNode):InitUserHeadUI(myInfoData:GetAvatarId(), myInfoData:GetAvatarFrameId(), self.__resloader)
  ;
  ((self.ui).loop_scroll):ClearCells()
  local totalRankNum = rankCfg.precise_max
  self.__maxPageNum = (math.ceil)(totalRankNum / self.__rankPageNum) - 1
  self.__curRankPage = 0
  self.__rankDragWay = (UINCommonRankPanel.eRankDragWay).Down
  self.__cannotDragDown = false
  self:ReqGetRankPageData(0)
end

UINCommonRankPanel.__OnNewItem = function(self, go)
  -- function num : 0_2 , upvalues : UINCommonRankPanelItem
  local rankItem = (UINCommonRankPanelItem.New)()
  rankItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = rankItem
end

UINCommonRankPanel.__OnChangeItem = function(self, go, index)
  -- function num : 0_3 , upvalues : _ENV
  local rankItem = (self.itemDic)[go]
  if rankItem == nil then
    error("Can\'t find goodItem by gameObject")
    return 
  end
  local rankElemData = (self.__rankDataDic)[index + 1 + self.__curRankPage * self.__rankPageNum]
  if rankElemData ~= nil then
    rankItem:RefeshCommonRankItem(self.__rankCfg, rankElemData, self.__resloader, self.hasTimer, self.showHeroNum)
    rankItem:SetDownTransform(((self.ui).tex_MyHeroCount).transform)
    rankItem.o_index = index
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

UINCommonRankPanel.__OnReturnItem = function(self, go)
  -- function num : 0_4 , upvalues : _ENV
  local rankItem = (self.itemDic)[go]
  if rankItem == nil then
    error("Can\'t find item by gameObject")
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

UINCommonRankPanel.__OnValueChange = function(self, pos)
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

UINCommonRankPanel.__OnDragOverTop = function(self)
  -- function num : 0_6 , upvalues : UINCommonRankPanel
  if self.__curRankPage == 0 then
    return 
  end
  if self.__isDragOverFreshing then
    return 
  end
  self.__curRankPage = self.__curRankPage - 1
  self.__rankDragWay = (UINCommonRankPanel.eRankDragWay).Up
  self:ReqGetRankPageData(self.__curRankPage)
end

UINCommonRankPanel.__OnDragOverBottle = function(self)
  -- function num : 0_7 , upvalues : UINCommonRankPanel
  if self.__curRankPage == self.__maxPageNum then
    return 
  end
  if self.__isDragOverFreshing then
    return 
  end
  if self.__cannotDragDown then
    return 
  end
  self.__curRankPage = self.__curRankPage + 1
  self.__rankDragWay = (UINCommonRankPanel.eRankDragWay).Down
  self:ReqGetRankPageData(self.__curRankPage)
end

UINCommonRankPanel.ReqGetRankPageData = function(self, pageNum)
  -- function num : 0_8 , upvalues : _ENV
  local objNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  objNetwork:CS_Rank_Detail((self.__rankCfg).id, pageNum)
  self.__isDragOverFreshing = true
end

UINCommonRankPanel.GetCommonRankPageMsg = function(self, msg, hasTime, isShowNum)
  -- function num : 0_9 , upvalues : _ENV
  local rankKeyDic = {}
  local num = #msg.rank
  for index,rankElem in ipairs(msg.rank) do
    local score, frame = self:_CalculateScoreAndFrame((rankElem.entry).score1)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (rankElem.entry).score1 = score
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (rankElem.entry).frame = frame
    rankKeyDic[rankElem.rankIdx] = rankElem
  end
  do
    if msg.myRank ~= nil then
      local score, frame = self:_CalculateScoreAndFrame((msg.myRank).score)
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (msg.myRank).score = score
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (msg.myRank).frame = frame
    end
    self:SetHasTime(hasTime)
    self:SetHeroShow(isShowNum)
    self:RefeshCommonRankPage(rankKeyDic, num)
    self:RefreshCommonMyRank(msg.myRank, hasTime, isShowNum)
  end
end

UINCommonRankPanel.SetHasTime = function(self, has)
  -- function num : 0_10
  self.hasTimer = has
  ;
  (((self.ui).tex_Time).gameObject):SetActive(has)
end

UINCommonRankPanel.SetHeroShow = function(self, isShowNum)
  -- function num : 0_11
  self.showHeroNum = isShowNum
  ;
  ((self.ui).obj_heroNum):SetActive(isShowNum)
  ;
  ((self.ui).obj_heroList):SetActive(not isShowNum)
end

UINCommonRankPanel.RefeshCommonRankPage = function(self, rankKeyDic, num)
  -- function num : 0_12 , upvalues : UINCommonRankPanel
  self.__rankDataDic = rankKeyDic
  ;
  ((self.ui).loop_scroll):ClearCells()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).loop_scroll).totalCount = num
  self.__cannotDragDown = num < self.__rankPageNum
  self.__isHasFirstElement = false
  self.__isHasLastElement = false
  if self.__rankDragWay == (UINCommonRankPanel.eRankDragWay).Up then
    ((self.ui).loop_scroll):RefillCellsFromEnd()
  else
    ((self.ui).loop_scroll):RefillCells()
  end
  ;
  ((self.ui).loop_scroll):StopMovement()
  self.__isDragOverFreshing = false
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINCommonRankPanel.RefreshCommonMyRank = function(self, myRank, hasTime, isShowNum)
  -- function num : 0_13 , upvalues : _ENV, BattleUtil
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_MyName).text = PlayerDataCenter.playerName
  ;
  (((self.ui).tex_MyTime).gameObject):SetActive(hasTime)
  if myRank == nil then
    ((self.ui).tex_MyRank):SetIndex(2)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

    if (self.__rankCfg).option_show_type == 1 then
      ((self.ui).tex_MyScore).text = ""
    else
      -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_MyScore).text = "0"
    end
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_MyTime).text = ""
    if isShowNum then
      (((self.ui).tex_MyHeroCount).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_MyHeroCount).text = "0"
    else
      ;
      (((self.ui).tex_MyHeroCount).gameObject):SetActive(false)
    end
    return 
  end
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R4 in 'UnsetPending'

  if (self.__rankCfg).option_show_type == 1 then
    ((self.ui).tex_MyScore).text = (BattleUtil.FrameToTimeString)(myRank.score, true)
  else
    local score = myRank.score
    local scoreMsg = nil
    if BattleUtil.CheatFrame <= score then
      scoreMsg = ConfigData:GetTipContent(1020)
    else
      scoreMsg = tostring(score)
    end
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_MyScore).text = scoreMsg
  end
  do
    -- DECOMPILER ERROR at PC89: Confused about usage of register: R4 in 'UnsetPending'

    if hasTime then
      ((self.ui).tex_MyTime).text = (BattleUtil.FrameToTimeString)(myRank.frame, true)
    end
    if myRank.inRank then
      ((self.ui).tex_MyRank):SetIndex(0, tostring(myRank.rankParam))
    else
      if (self.__rankCfg).percent_show > 0 and myRank.rankParam <= (self.__rankCfg).percent_show then
        ((self.ui).tex_MyRank):SetIndex(1, GetPreciseDecimalStr(myRank.rankParam / 100, 1))
      else
        ;
        ((self.ui).tex_MyRank):SetIndex(3)
      end
    end
    if isShowNum then
      (((self.ui).tex_MyHeroCount).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC139: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_MyHeroCount).text = (myRank.params)[1]
    else
      ;
      (((self.ui).tex_MyHeroCount).gameObject):SetActive(false)
    end
  end
end

UINCommonRankPanel._CalculateScoreAndFrame = function(self, score1)
  -- function num : 0_14
  if score1 == nil then
    return 
  end
  local score, frame = nil, nil
  if (self.__rankCfg).option_show_type == 1 then
    score = 4294967295 - score1
  else
    if (self.__rankCfg).time_switch then
      score = score1 >> 32
      local f = 4294967295
      frame = f - (score1 & f)
    else
      do
        score = score1
        return score, frame
      end
    end
  end
end

UINCommonRankPanel.OnDelete = function(self)
  -- function num : 0_15 , upvalues : base
  if self.__resloader ~= nil then
    (self.__resloader):Put2Pool()
    self.__resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINCommonRankPanel

