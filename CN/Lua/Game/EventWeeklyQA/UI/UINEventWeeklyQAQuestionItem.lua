-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventWeeklyQAQuestionItem = class("UINEventWeeklyQAQuestionItem", UIBaseNode)
local base = UINEventWeeklyQAQuestionItem
local UINEventWeeklyQAQuestionOptionItem = require("Game.EventWeeklyQA.UI.UINEventWeeklyQAQuestionOptionItem")
local EventWeeklyQAQuestionData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionData")
local EventWeeklyQAQuestionOption = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionOption")
UINEventWeeklyQAQuestionItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventWeeklyQAQuestionOptionItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.questionOptionPool = (UIItemPool.New)(UINEventWeeklyQAQuestionOptionItem, (self.ui).obj_questionOption)
  ;
  ((self.ui).obj_questionOption):SetActive(false)
  self.__onClickOption = BindCallback(self, self.OnClickOption)
end

UINEventWeeklyQAQuestionItem.InitWeeklyQAQuestionItem = function(self, clickOptionCallback)
  -- function num : 0_1
  self.clickOptionCallback = clickOptionCallback
end

UINEventWeeklyQAQuestionItem.RefreshWeeklyQAQestionByQuestionData = function(self, questionData, lastAnsweredQuestionIndex)
  -- function num : 0_2 , upvalues : _ENV, EventWeeklyQAQuestionData, EventWeeklyQAQuestionOption
  self.questionData = questionData
  self.allowClickOption = true
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_question).text = (LanguageUtil.GetLocaleText)(questionData.title)
  ;
  (self.questionOptionPool):HideAll()
  self.optionItems = {}
  for _,optionIndex in ipairs(questionData.optionIndexs) do
    local optionData = (questionData.options)[optionIndex]
    local optionItem = (self.questionOptionPool):GetOne()
    optionItem:InitWeeklyQAQuestionOptionItem(optionData, self.__onClickOption)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.optionItems)[optionData.logicIndex] = optionItem
  end
  if questionData.questionResult == (EventWeeklyQAQuestionData.eQuestionResult).trueAnswer then
    self.allowClickOption = false
    local rightIndex = (self.questionData):GetRightAnswerLogicIndex()
    ;
    ((self.optionItems)[rightIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).trueAnswer)
    if self.clickOptionCallback ~= nil then
      (self.clickOptionCallback)(true, 1, false)
    end
  else
    do
      if (self.questionData).lastlogicIndex ~= nil and (self.questionData).questionIndex == lastAnsweredQuestionIndex then
        self.allowClickOption = false
        local rightIndex = (self.questionData):GetRightAnswerLogicIndex()
        ;
        ((self.optionItems)[rightIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).trueAnswer)
        ;
        ((self.optionItems)[(self.questionData).lastlogicIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).falseAnswer)
        if self.clickOptionCallback ~= nil then
          (self.clickOptionCallback)(true, (self.questionData).lastlogicIndex, false)
        end
      end
    end
  end
end

UINEventWeeklyQAQuestionItem.OnClickOption = function(self, logicIndex)
  -- function num : 0_3 , upvalues : EventWeeklyQAQuestionOption
  if not self.allowClickOption then
    return 
  end
  local isRight = (self.questionData):GetIsRightAnswer(logicIndex)
  if isRight then
    ((self.optionItems)[logicIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).trueAnswer)
  else
    ;
    ((self.optionItems)[logicIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).falseAnswer)
    local rightIndex = (self.questionData):GetRightAnswerLogicIndex()
    ;
    ((self.optionItems)[rightIndex]):SetOptionImgItem((EventWeeklyQAQuestionOption.eOptionState).trueAnswer)
  end
  do
    self.allowClickOption = false
    if self.clickOptionCallback ~= nil then
      (self.clickOptionCallback)(isRight, logicIndex, true)
    end
  end
end

UINEventWeeklyQAQuestionItem.OnDelete = function(self)
  -- function num : 0_4
  if self.questionOptionPool ~= nil then
    (self.questionOptionPool):DeleteAll()
    self.questionOptionPool = nil
  end
end

return UINEventWeeklyQAQuestionItem

