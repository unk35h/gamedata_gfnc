-- params : ...
-- function num : 0 , upvalues : _ENV
local EventWeeklyQAQuestionOption = class("EventWeeklyQAQuestionOption")
EventWeeklyQAQuestionOption.eOptionState = {trueAnswer = 0, falseAnswer = 1, notAnswer = 2}
EventWeeklyQAQuestionOption.ctor = function(self, des, logicIndex, isRight)
  -- function num : 0_0
  self.des = des
  self.logicIndex = logicIndex
  self.isRight = isRight == true
  do return self end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EventWeeklyQAQuestionOption.SetShowIndex = function(self, showIndex)
  -- function num : 0_1
  self.showIndex = showIndex
end

return EventWeeklyQAQuestionOption

