-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventWeeklyQAQuestionNode = class("UINEventWeeklyQAQuestionNode", UIBaseNode)
local base = UIBaseNode
local EventWeeklyQAQuestionData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionData")
local UINEventWeeklyQAQuestionResultItem = require("Game.EventWeeklyQA.UI.UINEventWeeklyQAQuestionResultItem")
local UINEventWeeklyQAQuestionItem = require("Game.EventWeeklyQA.UI.UINEventWeeklyQAQuestionItem")
local CS_MessageCommon = CS.MessageCommon
UINEventWeeklyQAQuestionNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventWeeklyQAQuestionResultItem, UINEventWeeklyQAQuestionItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self:SetRecommandTagShow(false)
  self.questionResultPool = (UIItemPool.New)(UINEventWeeklyQAQuestionResultItem, (self.ui).obj_questionResult)
  ;
  ((self.ui).obj_questionResult):SetActive(false)
  self.questionItem = (UINEventWeeklyQAQuestionItem.New)()
  ;
  (self.questionItem):Init((self.ui).obj_questionItem)
  ;
  (self.questionItem):InitWeeklyQAQuestionItem(BindCallback(self, self.ClickOptionCallback))
  self.questionResultItems = {}
  ;
  (((self.ui).btn_finish).gameObject):SetActive(false)
  ;
  (((self.ui).btn_lock).gameObject):SetActive(false)
  ;
  (((self.ui).btn_nextQuestion).gameObject):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_finish, self, self.OnClickBtnFinish)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_nextQuestion, self, self.OnClickBtnNextQuestion)
  self.qaController = ControllerManager:GetController(ControllerTypeId.EventWeeklyQA, false)
end

UINEventWeeklyQAQuestionNode.InitWeeklyQAQuestionNodeByQAData = function(self, QAData)
  -- function num : 0_1 , upvalues : _ENV
  self.qaData = QAData
  ;
  (self.questionResultPool):HideAll()
  self.questionResultItems = {}
  local currentQuestion, lastAnsweredQuestionIndex = QAData:GetCurrentQuestion()
  local isFromMiddle = currentQuestion.questionIndex ~= 1 or (currentQuestion.questionIndex == 1 and lastAnsweredQuestionIndex == 1)
  for index,question in ipairs(QAData.questions) do
    local resultItem = (self.questionResultPool):GetOne()
    resultItem:InitWeeklyQAQuestionResultItem(question, index <= lastAnsweredQuestionIndex)
    ;
    (table.insert)(self.questionResultItems, resultItem)
  end
  if self._cdTimer ~= nil then
    TimerManager:StopTimer(self._cdTimer)
    self._cdTimer = nil
  end
  self:SetToNewQuestion(currentQuestion)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINEventWeeklyQAQuestionNode.SetToNewQuestion = function(self, newQuestion)
  -- function num : 0_2 , upvalues : _ENV
  do
    if self.currentQuestion ~= nil then
      local resultItem = (self.questionResultItems)[(self.currentQuestion).questionIndex]
      if resultItem ~= nil then
        resultItem:SetCurrentQuestionCursorShow(false)
      end
    end
    ;
    (((self.ui).btn_finish).gameObject):SetActive((self.qaData):CheckIsAnsweredAllQuestions())
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_finish).interactable = (self.qaData):CheckIsAllRight()
    ;
    (((self.ui).btn_lock).gameObject):SetActive(false)
    ;
    (((self.ui).btn_nextQuestion).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_nextQuestion).interactable = false
    local lastAnsweredQuestion = ((self.qaData).questions)[(self.qaData).lastAnsweredQuestionIndex]
    local lastAnsweredQuestionId = lastAnsweredQuestion and lastAnsweredQuestion.questionId or 0
    ;
    (self.qaController):RecordCurrentQuestionIndex(self.qaData, newQuestion.questionId, lastAnsweredQuestionId)
    self.currentQuestion = newQuestion
    ;
    ((self.ui).texItem_questionIndex):SetIndex(0, tostring(newQuestion.questionIndex), tostring(#(self.qaData).questions))
    self:SetRecommandTagShow(newQuestion.playerRecommend)
    ;
    (self.questionItem):RefreshWeeklyQAQestionByQuestionData(newQuestion, (self.qaData).lastAnsweredQuestionIndex)
    local resultItem = (self.questionResultItems)[newQuestion.questionIndex]
    if resultItem ~= nil then
      resultItem:SetCurrentQuestionCursorShow(true)
    end
  end
end

UINEventWeeklyQAQuestionNode.SetRecommandTagShow = function(self, isShow)
  -- function num : 0_3
  ((self.ui).obj_playerRecommend):SetActive(isShow)
end

UINEventWeeklyQAQuestionNode.ClickOptionCallback = function(self, isShowNextBtn, logicIndex, isReqNetSet)
  -- function num : 0_4
  if isReqNetSet then
    self:ReqSetResultItem(self.qaData, (self.currentQuestion).questionId, logicIndex)
  end
  ;
  (self.qaController):UpdateQuestionState((self.qaData):GetActId(), (self.currentQuestion).questionId, logicIndex)
  if isShowNextBtn then
    self:ShowNextBtn()
  else
    self:OnAnswerFalse()
  end
end

UINEventWeeklyQAQuestionNode.ReqSetResultItem = function(self, qaData, questionId, logicIndex)
  -- function num : 0_5
  if self.qaController == nil then
    return 
  end
  ;
  (self.qaController):ReqSetQuestionState(qaData, questionId, logicIndex)
end

UINEventWeeklyQAQuestionNode.OnClickBtnFinish = function(self)
  -- function num : 0_6 , upvalues : CS_MessageCommon, _ENV
  if (self.qaData):GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  local qaMainWindow = UIManager:GetWindow(UIWindowTypeID.EventWeeklyQA)
  if qaMainWindow == nil then
    return 
  end
  self:Hide()
  if (self.qaData):CheckIsAllRight() then
    qaMainWindow:ShowAllRightNode()
  else
    qaMainWindow:ShowFinishNode()
  end
end

UINEventWeeklyQAQuestionNode.OnClickBtnNextQuestion = function(self)
  -- function num : 0_7 , upvalues : CS_MessageCommon, _ENV
  if (self.qaData):GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  local nextQuestionIndex = (self.currentQuestion).questionIndex + 1
  if #(self.qaData).questions < nextQuestionIndex then
    self:OnClickBtnFinish()
  else
    self:SetToNewQuestion(((self.qaData).questions)[nextQuestionIndex])
  end
end

UINEventWeeklyQAQuestionNode.ShowNextBtn = function(self)
  -- function num : 0_8
  local nextQuestionIndex = (self.currentQuestion).questionIndex + 1
  if #(self.qaData).questions < nextQuestionIndex then
    (((self.ui).btn_nextQuestion).gameObject):SetActive(false)
    ;
    (((self.ui).btn_finish).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_finish).interactable = true
  else
    if (self.qaData):CheckIsAllRight() then
      (((self.ui).btn_nextQuestion).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).btn_nextQuestion).interactable = true
      ;
      (((self.ui).btn_finish).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).btn_finish).interactable = true
    else
      ;
      (((self.ui).btn_nextQuestion).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).btn_nextQuestion).interactable = true
    end
  end
end

UINEventWeeklyQAQuestionNode.OnAnswerFalse = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (((self.ui).btn_nextQuestion).gameObject):SetActive(false)
  ;
  (((self.ui).btn_lock).gameObject):SetActive(true)
  self.timeCount = (self.qaData).wrongCd
  ;
  ((self.ui).tex_lockTime):SetIndex(0, tostring(self.timeCount))
  if self._cdTimer ~= nil then
    TimerManager:StopTimer(self._cdTimer)
    self._cdTimer = nil
  end
  self._cdTimer = TimerManager:StartTimer(1, function()
    -- function num : 0_9_0 , upvalues : self, _ENV
    self.timeCount = self.timeCount - 1
    ;
    ((self.ui).tex_lockTime):SetIndex(0, tostring(self.timeCount))
    if self.timeCount <= 0 then
      (((self.ui).btn_lock).gameObject):SetActive(false)
      TimerManager:StopTimer(self._cdTimer)
      self._cdTimer = nil
      self:ShowNextBtn()
    end
  end
, self, false)
end

UINEventWeeklyQAQuestionNode.SetResultItemByIndex = function(self, index, newState)
  -- function num : 0_10
  local resultItem = (self.questionResultItems)[index]
  if resultItem ~= nil then
    resultItem:SetResultImgItem(newState, true)
  end
end

UINEventWeeklyQAQuestionNode.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.questionItem ~= nil then
    (self.questionItem):Delete()
    self.questionItem = nil
  end
  if self._cdTimer ~= nil then
    TimerManager:StopTimer(self._cdTimer)
    self._cdTimer = nil
  end
  if self.questionResultPool ~= nil then
    (self.questionResultPool):DeleteAll()
    self.questionResultPool = nil
  end
end

return UINEventWeeklyQAQuestionNode

