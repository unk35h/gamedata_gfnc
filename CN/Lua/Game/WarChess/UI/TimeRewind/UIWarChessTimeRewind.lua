-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessTimeRewind = class("UIWarChessTimeRewind", base)
local UINWarChessTimeRewindItem = require("Game.WarChess.UI.TimeRewind.UINWarChessTimeRewindItem")
UIWarChessTimeRewind.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessTimeRewindItem
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.__OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.__OnClickCancel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rewind, self, self.__OnClickReturnBattleBefore)
  self.turnItemPool = (UIItemPool.New)(UINWarChessTimeRewindItem, (self.ui).obj_turn)
  ;
  ((self.ui).obj_turn):SetActive(false)
  self.__onSelectTurnItem = BindCallback(self, self.__OnSelectTurnItem)
  self.__selectedTurnItem = nil
  ;
  (((self.ui).scrollRect).onValueChanged):AddListener(BindCallback(self, self.__OnValueChange))
end

UIWarChessTimeRewind.InitWCTimeRewind = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self._returnBattleBeforeFunc = nil
  self._turnBackFunc = nil
  ;
  ((self.ui).rewind):SetActive(false)
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local curTurnNum = (wcCtrl.turnCtrl):GetWCTurnNum()
  self.__eSize = 1 / (curTurnNum - 1)
  ;
  (self.turnItemPool):HideAll()
  for turnNum = 1, curTurnNum do
    local turnItem = (self.turnItemPool):GetOne(true)
    local isCur = curTurnNum == turnNum
    turnItem:InitWCTRTurnItem(turnNum, isCur, self.__onSelectTurnItem)
    if isCur then
      self:__OnSelectTurnItem(turnItem)
    end
  end
  local rewindTotalTime, rewindLeftTime = (wcCtrl.turnCtrl):GetWCRewindTimes()
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Turn).text = tostring(rewindLeftTime) .. "/" .. tostring(rewindTotalTime)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessTimeRewind.InitWCTimeRewindInBattle = function(self, turnBackFunc, returnBattleBeforeFunc)
  -- function num : 0_2
  self:InitWCTimeRewind()
  self._returnBattleBeforeFunc = returnBattleBeforeFunc
  self._turnBackFunc = turnBackFunc
  ;
  ((self.ui).rewind):SetActive(true)
  local rightOffset = (((self.ui).turnGroup).padding).right
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).turnGroup).padding).right = rightOffset - 320
end

UIWarChessTimeRewind.__OnSelectTurnItem = function(self, turnItem)
  -- function num : 0_3
  if self.__selectedTurnItem ~= nil then
    (self.__selectedTurnItem):SetIsSelected(false)
  end
  self.__selectedTurnItem = turnItem
  ;
  (self.__selectedTurnItem):SetIsSelected(true)
  local rewindTurnNum = (self.__selectedTurnItem).turnNum
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).horizontalNormalizedPosition = self.__eSize * (rewindTurnNum - 1)
end

UIWarChessTimeRewind.__OnValueChange = function(self)
  -- function num : 0_4
  local rate = ((self.ui).scrollRect).horizontalNormalizedPosition
end

UIWarChessTimeRewind.__OnClickConfirm = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.__selectedTurnItem == nil then
    return 
  end
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local wid = wcCtrl:GetWCId()
  local rewindTurnNum = (self.__selectedTurnItem).turnNum
  if self._turnBackFunc ~= nil then
    (self._turnBackFunc)(wid, rewindTurnNum)
  else
    ;
    (wcCtrl.wcNetworkCtrl):CS_WarChess_ResetTheRound(wid, rewindTurnNum, function()
    -- function num : 0_5_0 , upvalues : self
    self:Delete()
  end
)
  end
end

UIWarChessTimeRewind.__OnClickCancel = function(self)
  -- function num : 0_6
  self:Delete()
end

UIWarChessTimeRewind.__OnClickReturnBattleBefore = function(self)
  -- function num : 0_7
  self:Delete()
  if self._returnBattleBeforeFunc ~= nil then
    (self._returnBattleBeforeFunc)()
  end
end

UIWarChessTimeRewind.OnDelete = function(self)
  -- function num : 0_8
end

return UIWarChessTimeRewind

