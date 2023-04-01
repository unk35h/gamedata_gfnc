-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonPlotReviewLockCharpt = class("UINCommonPlotReviewLockCharpt", UIBaseNode)
local base = UIBaseNode
UINCommonPlotReviewLockCharpt.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCommonPlotReviewLockCharpt.InitLockedCPRCharpt = function(self, AvgGroupData)
  -- function num : 0_1
  local des = AvgGroupData:GetAvgGroupUnlockDes()
  ;
  ((self.ui).text):SetIndex(1, des)
end

return UINCommonPlotReviewLockCharpt

