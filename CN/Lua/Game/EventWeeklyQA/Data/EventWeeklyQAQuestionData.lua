-- params : ...
-- function num : 0 , upvalues : _ENV
local EventWeeklyQAQuestionData = class("EventWeeklyQAQuestionData")
local EventWeeklyQAQuestionOption = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionOption")
EventWeeklyQAQuestionData.eQuestionResult = {trueAnswer = 0, falseAnswer = 1, notAnswer = 2}
local Swap = function(targetList, index1, index2)
  -- function num : 0_0
  local tempValue = targetList[index1]
  targetList[index1] = targetList[index2]
  targetList[index2] = tempValue
end

local Shuffle = function(targetList)
  -- function num : 0_1 , upvalues : _ENV, Swap
  for currentIndex = 1, #targetList - 1 do
    local randomTargetIndex = (math.random)(currentIndex, #targetList)
    Swap(targetList, currentIndex, randomTargetIndex)
  end
end

EventWeeklyQAQuestionData.ctor = function(self, problemCfg, questionIndex, questionResult)
  -- function num : 0_2 , upvalues : _ENV, EventWeeklyQAQuestionOption
  self.questionId = problemCfg.title_id
  self.questionIndex = questionIndex
  self.playerRecommend = problemCfg.player_recommend
  self.title = problemCfg.title
  self.questionResult = questionResult
  local options = {}
  ;
  (table.insert)(options, (EventWeeklyQAQuestionOption.New)(problemCfg.answer_1right, 1, true))
  ;
  (table.insert)(options, (EventWeeklyQAQuestionOption.New)(problemCfg.answer_2, 2))
  ;
  (table.insert)(options, (EventWeeklyQAQuestionOption.New)(problemCfg.answer_3, 3))
  ;
  (table.insert)(options, (EventWeeklyQAQuestionOption.New)(problemCfg.answer_4, 4))
  self.options = options
  self:FlushWeeklyQAOptions()
end

EventWeeklyQAQuestionData.FlushWeeklyQAOptions = function(self)
  -- function num : 0_3 , upvalues : Shuffle, _ENV
  local optionIndexs = {1, 2, 3, 4}
  Shuffle(optionIndexs)
  self.optionIndexs = optionIndexs
  for showIndex,logicIndex in ipairs(optionIndexs) do
    ((self.options)[logicIndex]):SetShowIndex(showIndex)
  end
end

EventWeeklyQAQuestionData.SetQuestionResultByChoice = function(self, logicIndex)
  -- function num : 0_4 , upvalues : EventWeeklyQAQuestionData
  self.lastlogicIndex = logicIndex
  if not ((self.options)[logicIndex]).isRight or not (EventWeeklyQAQuestionData.eQuestionResult).trueAnswer then
    self.questionResult = (EventWeeklyQAQuestionData.eQuestionResult).falseAnswer
    return self.questionResult
  end
end

EventWeeklyQAQuestionData.GetIsRightAnswer = function(self, logicIndex)
  -- function num : 0_5
  return ((self.options)[logicIndex]).isRight
end

EventWeeklyQAQuestionData.GetRightAnswerLogicIndex = function(self)
  -- function num : 0_6
  return 1
end

return EventWeeklyQAQuestionData

