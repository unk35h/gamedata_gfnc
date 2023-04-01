-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessTimeRewindItem = class("UINWarChessTimeRewindItem", base)
UINWarChessTimeRewindItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_normal, self, self.__OnClickTurnItem)
end

UINWarChessTimeRewindItem.InitWCTRTurnItem = function(self, turnNum, isCur, onSelectTurnItem)
  -- function num : 0_1 , upvalues : _ENV
  self.turnNum = turnNum
  self.onSelectTurnItem = onSelectTurnItem
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TurnNumber_n).text = tostring(turnNum)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TurnNumber_s).text = tostring(turnNum)
  ;
  ((self.ui).obj_Current_n):SetActive(isCur)
  ;
  ((self.ui).obj_Current_s):SetActive(isCur)
end

UINWarChessTimeRewindItem.__OnClickTurnItem = function(self)
  -- function num : 0_2
  if self.onSelectTurnItem ~= nil then
    (self.onSelectTurnItem)(self)
  end
end

UINWarChessTimeRewindItem.SetIsSelected = function(self, bool)
  -- function num : 0_3
  ((self.ui).obj_normal):SetActive(not bool)
  ;
  ((self.ui).obj_selectedTurn):SetActive(bool)
end

UINWarChessTimeRewindItem.OnDelete = function(self)
  -- function num : 0_4
end

return UINWarChessTimeRewindItem

