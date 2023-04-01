-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22ChallengeRank = class("UINCarnival22ChallengeRank", UIBaseNode)
local base = UINCarnival22ChallengeRank
local UINCarnival22ChallengeRankItem = require("Game.ActivityCarnival.UI.CarnivalChallenge.UINCarnival22ChallengeRankItem")
local BattleUtil = require("Game.Battle.BattleUtil")
UINCarnival22ChallengeRank.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.Hide)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).frame).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).frame).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).frame).onReturnItem = BindCallback(self, self.__OnReturnItem)
  ;
  (((self.ui).frame).onValueChanged):AddListener(BindCallback(self, self.__OnValueChange))
  self._rectHeight = ((((self.ui).frame).transform).rect).height
  self.itemDic = {}
end

UINCarnival22ChallengeRank.InitCarnivalChallengeRank = function(self, rankId, resloder)
  -- function num : 0_1 , upvalues : _ENV
  self._rankId = rankId
  self._resloder = resloder
  self._pageContentNum = (ConfigData.buildinConfig).CommonRankPageNum
  local rankCfg = (ConfigData.common_ranklist)[rankId]
  self._maxPage = (math.ceil)(rankCfg.precise_max / self._pageContentNum) - 1
end

UINCarnival22ChallengeRank.OpenCarnivalChallengeRank = function(self)
  -- function num : 0_2
  self._cannotNext = false
  self._isReqing = false
  self._curPage = nil
  self._firstItem = nil
  self._lastItem = nil
  self._pageDataDic = {}
  self:__ReqRankPage(0)
end

UINCarnival22ChallengeRank.__UpdateCarnivalChallengeRank = function(self, data, pageId)
  -- function num : 0_3 , upvalues : _ENV
  local lastPageId = self._curPage
  self.rankList = data.rank
  self._curPage = pageId
  local num = #self.rankList
  self._cannotNext = num < self._pageContentNum or self._maxPage <= self._curPage
  ;
  ((self.ui).frame):ClearCells()
  if num == 0 then
    ((self.ui).myRank):SetActive(false)
    ;
    ((self.ui).emptyState):SetActive(true)
    return 
  end
  ;
  ((self.ui).emptyState):SetActive(false)
  ;
  ((self.ui).myRank):SetActive(true)
  self._firstItem = nil
  self._lastItem = nil
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).frame).totalCount = num
  if lastPageId == nil or lastPageId <= self._curPage then
    ((self.ui).frame):RefillCells()
  else
    ((self.ui).frame):RefillCellsFromEnd()
  end
  ;
  ((self.ui).frame):StopMovement()
  local rankSelf = data.myRank
  if rankSelf == nil then
    ((self.ui).tex_MyRank):SetIndex(1)
    ;
    (((self.ui).tex_MyTime).gameObject):SetActive(false)
  else
    (((self.ui).tex_MyTime).gameObject):SetActive(true)
    local time = self:__CalRecordTime(rankSelf.score)
    local min = (math.floor)(time / 60)
    local sec = time % 60
    ;
    ((self.ui).tex_MyTime):SetIndex(0, (string.format)("%02d", min), (string.format)("%.03f", sec))
    if rankSelf.rankParam == 0 then
      ((self.ui).tex_MyRank):SetIndex(2)
    elseif rankSelf.inRank then
      ((self.ui).tex_MyRank):SetIndex(0, tostring(rankSelf.rankParam))
    else
      local rate = (math.floor)(rankSelf.rankParam / 100)
      ;
      ((self.ui).tex_MyRank):SetIndex(0, tostring(rate) .. "%")
    end
  end
  -- DECOMPILER ERROR: 9 unprocessed JMP targets
end

UINCarnival22ChallengeRank.__OnNewItem = function(self, go)
  -- function num : 0_4 , upvalues : UINCarnival22ChallengeRankItem
  local rankItem = (UINCarnival22ChallengeRankItem.New)()
  rankItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = rankItem
end

UINCarnival22ChallengeRank.__OnChangeItem = function(self, go, index)
  -- function num : 0_5
  local rankItem = (self.itemDic)[go]
  local data = (self.rankList)[index + 1]
  do
    if data.second == nil then
      local seconed = self:__CalRecordTime((data.entry).score1)
      data.second = seconed
    end
    rankItem:InitCarnivalChallengeRankItem(data, self._resloder)
    if index == 0 then
      self._firstItem = rankItem
    else
      if index == #self.rankList - 1 then
        self._lastItem = rankItem
      end
    end
  end
end

UINCarnival22ChallengeRank.__OnReturnItem = function(self, go)
  -- function num : 0_6
  local rankitem = (self.itemDic)[go]
  if rankitem == self._firstItem then
    self._firstItem = nil
  else
    if rankitem == self._lastItem then
      self._lastItem = nil
    end
  end
end

UINCarnival22ChallengeRank.__OnValueChange = function(self, pos)
  -- function num : 0_7 , upvalues : _ENV
  if self._isReqing or self._curPage == nil then
    return 
  end
  if self._curPage > 0 and self._firstItem ~= nil then
    local worldPos = ((self._firstItem).transform):TransformPoint(Vector3.zero)
    local frameLocalPos = (((self.ui).frame).transform):InverseTransformPoint(worldPos)
    local posY = frameLocalPos.y
    if posY < self._rectHeight / 2 - (self.ui).pageCheckDis then
      self:__ReqRankPage(self._curPage - 1)
    end
  end
  do
    if not self._cannotNext and self._lastItem ~= nil then
      local worldPos = ((self._lastItem).transform):TransformPoint(Vector3.zero)
      local frameLocalPos = (((self.ui).frame).transform):InverseTransformPoint(worldPos)
      local posY = frameLocalPos.y
      if -self._rectHeight / 2 + (self.ui).pageCheckDis < posY then
        self:__ReqRankPage(self._curPage + 1)
      end
    end
  end
end

UINCarnival22ChallengeRank.__CalRecordTime = function(self, score)
  -- function num : 0_8 , upvalues : BattleUtil
  local frame = 4294967295 - score
  local time = frame / BattleUtil.LogicFrameCount
  return time
end

UINCarnival22ChallengeRank.__ReqRankPage = function(self, pageId)
  -- function num : 0_9 , upvalues : _ENV
  if (self._pageDataDic)[pageId] ~= nil then
    self:__UpdateCarnivalChallengeRank((self._pageDataDic)[pageId], pageId)
    return 
  end
  self._isReqing = true
  local objNetwork = NetworkManager:GetNetwork(NetworkTypeID.Object)
  objNetwork:CS_Rank_Detail(self._rankId, pageId, function(objList)
    -- function num : 0_9_0 , upvalues : _ENV, self, pageId
    if IsNull(self.transform) or not self.active then
      return 
    end
    self._isReqing = false
    if objList.Count ~= 1 then
      return 
    end
    local msg = objList[0]
    if msg == nil then
      return 
    end
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self._pageDataDic)[pageId] = msg
    self:__UpdateCarnivalChallengeRank(msg, pageId)
  end
)
end

return UINCarnival22ChallengeRank

