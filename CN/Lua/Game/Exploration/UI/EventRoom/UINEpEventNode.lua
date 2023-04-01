-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.EventRoom.UINEventRoomPageBase")
local UINEpEventNode = class("UINEpEventNode", base)
UINEpEventNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
end

UINEpEventNode.InitBranchPage = function(self, uiEvent, onChoiceClick)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitBranchPage)(self, uiEvent, onChoiceClick)
  if GuideManager:TryTriggerGuide(eGuideCondition.InEpEventRoom) then
  end
end

UINEpEventNode.RefreshBranchPage = function(self)
  -- function num : 0_2 , upvalues : base
  (base.RefreshBranchPage)(self)
end

UINEpEventNode.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINEpEventNode

