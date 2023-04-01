-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventWeeklyQAQuestionResultItem = class("UINEventWeeklyQAQuestionResultItem", UIBaseNode)
local base = UIBaseNode
UINEventWeeklyQAQuestionResultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).obj_arrow):SetActive(false)
end

UINEventWeeklyQAQuestionResultItem.InitWeeklyQAQuestionResultItem = function(self, questionData, isShowFalse)
  -- function num : 0_1
  self.questionData = questionData
  self:SetResultImgItem(questionData.questionResult, isShowFalse)
end

UINEventWeeklyQAQuestionResultItem.SetCurrentQuestionCursorShow = function(self, isShow)
  -- function num : 0_2
  ((self.ui).obj_arrow):SetActive(isShow)
end

UINEventWeeklyQAQuestionResultItem.SetResultImgItem = function(self, result, isShowFalse)
  -- function num : 0_3
  local showResult = result
  showResult = isShowFalse or (result == 0 and 0) or 2
  ;
  ((self.ui).imgItem_result):SetIndex(showResult)
end

return UINEventWeeklyQAQuestionResultItem

