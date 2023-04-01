-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackTaskTitle = class("UINEventComebackTaskTitle", UIBaseNode)
local base = UIBaseNode
UINEventComebackTaskTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINEventComebackTaskTitle.InitCombackTaskTitle = function(self, txtIndex)
  -- function num : 0_1 , upvalues : _ENV
  self._totalCount = totalCount
  ;
  ((self.ui).tex_Title):SetIndex(txtIndex)
  ;
  (((self.ui).tex_Progress).gameObject):SetActive(false)
end

UINEventComebackTaskTitle.RefreshCombackTaskProgress = function(self, count, totalCount)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).tex_Progress).gameObject):SetActive(true)
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(count), tostring(totalCount))
end

return UINEventComebackTaskTitle

