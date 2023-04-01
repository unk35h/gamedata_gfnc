-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDaySubmitNode = class("UINWhiteDaySubmitNode", UIBaseNode)
local base = UIBaseNode
UINWhiteDaySubmitNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWhiteDaySubmitNode.InitWDSubmitNode = function(self, AWDCtrl, AWDLineData)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
end

UINWhiteDaySubmitNode.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDaySubmitNode

