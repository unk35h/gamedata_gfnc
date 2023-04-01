-- params : ...
-- function num : 0 , upvalues : _ENV
local UITDProcessView = class("UITDProcessView", UIBaseWindow)
local base = UIBaseWindow
local UINTDProcessViewItem = require("Game.BattleTowerDefence.UI.UINTDProcessViewItem")
UITDProcessView.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINTDProcessViewItem
  self.viewItemPool = (UIItemPool.New)(UINTDProcessViewItem, (self.ui).obj_processItem)
  ;
  ((self.ui).obj_processItem):SetActive(false)
  self.listLen = (((self.ui).tran_list).rect).width
  self.centerLen = self.listLen / 2
  ;
  ((self.ui).obj_cCNode):SetActive(false)
end

UITDProcessView.RefreshLightProcessView = function(self, mapData, curCount, beforeCount, closeFunc)
  -- function num : 0_1
  ((self.ui).tex_Title):SetIndex(1)
  self:__RefreshProcessView(mapData, curCount, beforeCount, closeFunc)
end

UITDProcessView.RefreshTDProcessView = function(self, mapData, curCount, beforeCount, closeFunc)
  -- function num : 0_2
  ((self.ui).tex_Title):SetIndex(0)
  self:__RefreshProcessView(mapData, curCount, beforeCount, closeFunc)
end

UITDProcessView.__RefreshProcessView = function(self, mapData, curCount, beforeCount, closeFunc)
  -- function num : 0_3 , upvalues : _ENV
  self.mapData = mapData
  local totalCount = mapData.maxMapColNumber
  if totalCount == nil or totalCount == 0 then
    error("UITDProcessView totalCount is nil or 0")
    return 
  end
  if curCount == nil or curCount == 0 then
    error("UITDProcessView curCount is nil or 0")
    return 
  end
  if closeFunc ~= nil then
    closeFunc()
  end
  self:_ClearAutoHideTimer()
  self._autoHideTiemrId = TimerManager:StartTimer(3, self.Hide, self, true)
  self.diff = curCount - beforeCount or 0
  self.curCount = curCount
  self.totalCount = totalCount
  self.maxLen = (totalCount - 1) * (self.ui).flo_unitLen
  self.isAdd = self.diff > 0
  self.isSingle = totalCount == 1
  self.notExceed = self.listLen >= (self.ui).flo_unitLen * totalCount
  -- DECOMPILER ERROR at PC66: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Bar).fillAmount = 0
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = tostring(self.curCount - self.diff) .. "/" .. tostring(totalCount)
  ;
  ((self.ui).obj_barNode):SetActive(totalCount > 1)
  self:_InitListRect(totalCount, beforeCount)
  self:_InitViewItem(totalCount, curCount)
  self:_InitTween(curCount)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UITDProcessView._ClearAutoHideTimer = function(self)
  -- function num : 0_4 , upvalues : _ENV
  TimerManager:StopTimer(self._autoHideTiemrId)
end

UITDProcessView.RefreshCC = function(self, hideInterest)
  -- function num : 0_5 , upvalues : _ENV
  if ((self.ui).obj_cCNode).activeSelf then
    ((self.ui).obj_cCNode):SetActive(false)
  end
  if ExplorationManager == nil then
    return 
  end
  local dynplayer = ExplorationManager:GetDynPlayer()
  if dynplayer == nil then
    return 
  end
  local epTypeCfg = ExplorationManager:GetEpTypeCfg()
  if epTypeCfg == nil then
    return 
  end
  if not ((self.ui).obj_cCNode).activeSelf then
    ((self.ui).obj_cCNode):SetActive(true)
  end
  local theMoney = dynplayer:GetMoneyCount()
  if (ConfigData.game_config).towerMoneyMax <= theMoney then
    hideInterest = true
  end
  if epTypeCfg.interest_open then
    local isInterestOpen = not hideInterest
  end
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).tex_CCAdd).text).enabled = isInterestOpen
  if isInterestOpen then
    local y = 1 + (epTypeCfg.interest)[1] / 1000
    local x = (math.ceil)(theMoney / y)
    local add = (math.floor)(x * (epTypeCfg.interest)[1] / 1000)
    if (epTypeCfg.interest)[2] <= add then
      add = (epTypeCfg.interest)[2]
      theMoney = theMoney - add
    else
      theMoney = x
    end
    ;
    ((self.ui).tex_CCAdd):SetIndex(0, tostring(add))
  end
  do
    -- DECOMPILER ERROR at PC91: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_CC).text = tostring(theMoney)
  end
end

UITDProcessView._InitListRect = function(self, totalCount, beforeCount)
  -- function num : 0_6
  local Inner = function(total)
    -- function num : 0_6_0 , upvalues : self
    local max = (total - 1) * (self.ui).flo_unitLen
    return self.centerLen - max * 0.5
  end

  local OutSide = function(cur, total)
    -- function num : 0_6_1 , upvalues : self
    local v = (cur - 1) * (self.ui).flo_unitLen
    return self:_GetMoveRectX(v)
  end

  local pos = ((self.ui).tran_rect).anchoredPosition
  if not self.isSingle and (not self.notExceed or not Inner(totalCount)) then
    pos.x = OutSide(beforeCount, totalCount)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tran_rect).anchoredPosition = pos
  end
end

UITDProcessView._InitViewItem = function(self, totalCount, curCount)
  -- function num : 0_7
  (self.viewItemPool):HideAll()
  for roomX = 1, totalCount do
    local item = (self.viewItemPool):GetOne()
    item:InitTDProcessViewItem(roomX, self.mapData, roomX < curCount)
  end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UITDProcessView._InitTween = function(self, curCount)
  -- function num : 0_8 , upvalues : _ENV
  if self.selItem ~= nil then
    (self.selItem):DOTweenKill()
  end
  ;
  ((self.ui).img_Bar):DOKill(true)
  ;
  ((self.ui).tran_rect):DOKill()
  local selItem = ((self.viewItemPool).listItem)[curCount]
  if selItem ~= nil then
    self.selItem = selItem
  end
  local fillAmount = 0
  if curCount - 1 > 0 then
    fillAmount = (curCount - 1) / (self.totalCount - 1)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Bar).fillAmount = (curCount - self.diff - 1) / (self.totalCount - 1)
  end
  local duraction = fillAmount > 0 and self.isAdd and 1 or 0
  ;
  (((self.ui).img_Bar):DOFillAmount(fillAmount, duraction)):OnComplete(function()
    -- function num : 0_8_0 , upvalues : self, fillAmount, _ENV, curCount
    -- DECOMPILER ERROR at PC3: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).img_Bar).fillAmount = fillAmount
    ;
    (self.selItem):PlayScaleTween()
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).tex_Progress).text = tostring(curCount) .. "/" .. tostring(self.totalCount)
  end
)
  if self.isSingle or self.notExceed then
    return 
  end
  local v = (curCount - 1) * (self.ui).flo_unitLen
  local moveX = self:_GetMoveRectX(v)
  ;
  ((self.ui).tran_rect):DOAnchorPosX(moveX, duraction)
end

UITDProcessView._GetMoveRectX = function(self, value)
  -- function num : 0_9
  if value <= self.centerLen then
    return 0
  end
  if value <= self.maxLen - self.centerLen then
    return self.centerLen - value
  end
  return self.listLen - self.maxLen
end

UITDProcessView.OnHide = function(self)
  -- function num : 0_10 , upvalues : base
  self:_ClearAutoHideTimer()
  ;
  (base.OnHide)(self)
end

UITDProcessView.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (self.viewItemPool):DeleteAll()
  ;
  ((self.ui).img_Bar):DOKill()
  ;
  (base.OnDelete)(self)
end

return UITDProcessView

