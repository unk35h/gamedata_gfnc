-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Event.UINWarChessEventTypeNodeBase")
local UINWarChessEventFirstChoiceExitNode = class("UINWarChessEventFirstChoiceExitNode", base)
UINWarChessEventFirstChoiceExitNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINWarChessEventFirstChoiceExitNode.RefreshEntChoiceList = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local choicePool = (self.uiEvent):GetWCChoicePool()
  choicePool:HideAll()
  for index,choiceData in ipairs(self.choiceDatas) do
    if index ~= 1 then
      local choiceItem = choicePool:GetOne()
      ;
      (choiceItem.transform):SetParent((self.ui).rect)
      choiceItem:InitWCEventChoiceItem(choiceData, self.onChoiceClick)
    end
  end
end

return UINWarChessEventFirstChoiceExitNode

