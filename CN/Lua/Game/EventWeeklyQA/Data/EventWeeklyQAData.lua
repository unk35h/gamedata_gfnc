-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityFrame.ActivityBase")
local EventWeeklyQAData = class("EventWeeklyQAData", base)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).EventWeeklyQA
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local EventWeeklyQAQuestionData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionData")
local EventWeeklyQAQuestionRewardData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionRewardData")
local redDotType = {redDotReward = 1, redDotNewQA = 2}
EventWeeklyQAData.InitEventWeeklyQADataByMsg = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV, EventWeeklyQAQuestionData, EventWeeklyQAQuestionRewardData
  local actId = msg.actId
  local order = msg.order
  self:SetActFrameDataByType(CurActType, actId)
  self._mainCfg = (ConfigData.activity_answer_main)[actId]
  self._problemCfg = ((ConfigData.activity_answer_problem)[actId])[order]
  self._rewardCfg = (ConfigData.activity_answer_reward)[actId]
  self.currentOrder = order
  self.startTm = (self._problemCfg).start_time
  self.endTm = (self._problemCfg).end_time
  local questions = {}
  local questionsIdIndexDic = {}
  for index,problemId in ipairs((self._problemCfg).problem_group) do
    local problemCfg = (ConfigData.activity_answer_library)[problemId]
    local questionData = (EventWeeklyQAQuestionData.New)(problemCfg, index, 2)
    ;
    (table.insert)(questions, questionData)
    questionsIdIndexDic[problemId] = index
  end
  self.questions = questions
  self.questionsIdIndexDic = questionsIdIndexDic
  for index,choiceElem in ipairs(msg.choice) do
    local problemId = choiceElem.problemId
    local choice = choiceElem.choice
    local questionIndex = (self.questionsIdIndexDic)[problemId]
    local questionData = nil
    if questionIndex ~= nil then
      questionData = (self.questions)[questionIndex]
      questionData:SetQuestionResultByChoice(choice)
    end
  end
  self.wrongCd = (self._mainCfg).wrong_cd
  self._net = NetworkManager:GetNetwork(NetworkTypeID.EventWeeklyQA)
  local rewardGotDic = {}
  for _,gottenRewardNeedScore in ipairs(msg.rewardGot) do
    rewardGotDic[gottenRewardNeedScore] = true
  end
  self.rewardGot = rewardGotDic
  local rewards = {}
  for needScore,rewardCfg in pairs(self._rewardCfg) do
    local rewardData = (EventWeeklyQAQuestionRewardData.New)(needScore, rewardCfg, (EventWeeklyQAQuestionRewardData.eRewardState).unComplete)
    ;
    (table.insert)(rewards, rewardData)
  end
  ;
  (table.sort)(rewards, function(a, b)
    -- function num : 0_0_0
    do return a.needScore < b.needScore end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self.rewards = rewards
  self:RefreshRewardState()
  self.lastAnsweredQuestionIndex = 0
  self:SetCurrentQuestionIndexByOpProblemId(msg.opProblemId)
  self:__UpdateWeeklyQA()
end

EventWeeklyQAData.__UpdateWeeklyQA = function(self)
  -- function num : 0_1
  self:RefreshWeeklyQARedDotReward()
  self:RefreshWeeklyQARedDotNewQA()
end

EventWeeklyQAData.RefreshWeeklyQARedDotReward = function(self)
  -- function num : 0_2 , upvalues : redDotType, _ENV, EventWeeklyQAQuestionRewardData
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local rewardRed = actRed:AddChild(redDotType.redDotReward)
  for _,rewardData in ipairs(self.rewards) do
    if rewardData.currentState == (EventWeeklyQAQuestionRewardData.eRewardState).CompleteNoPicked then
      rewardRed:SetRedDotCount(1)
      return 
    end
  end
  rewardRed:SetRedDotCount(0)
end

EventWeeklyQAData.RefreshWeeklyQARedDotNewQA = function(self)
  -- function num : 0_3 , upvalues : redDotType, _ENV
  local actRed = self:GetActivityReddot()
  if actRed == nil then
    return 
  end
  local newQARed = actRed:AddChild(redDotType.redDotNewQA)
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if not saveUserData:GetWeeklyQALooked(self:GetActId(), self.currentOrder) then
    newQARed:SetRedDotCount(1)
    return 
  end
  newQARed:SetRedDotCount(0)
end

EventWeeklyQAData.SetCurrentQuestionIndexByOpProblemId = function(self, opProblemId)
  -- function num : 0_4
  local realQuestionId = opProblemId >> 16
  local currentQuestionIndex = (self.questionsIdIndexDic)[realQuestionId]
  local lastAnsweredQuestionId = opProblemId & 65535
  local lastAnsweredQuestionIndex = (self.questionsIdIndexDic)[lastAnsweredQuestionId] or 0
  if currentQuestionIndex == nil or not currentQuestionIndex then
    currentQuestionIndex = 1
  end
  self:SetCurrentQuestionIndex(currentQuestionIndex, lastAnsweredQuestionIndex)
end

EventWeeklyQAData.SetCurrentQuestionIndex = function(self, newIndex, lastAnsweredQuestionIndex)
  -- function num : 0_5
  self.currentQuestionIndex = newIndex
  self.lastAnsweredQuestionIndex = lastAnsweredQuestionIndex
end

EventWeeklyQAData.SetWeeklyQARewardGotten = function(self, needScore)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.rewardGot)[needScore] = true
  self:RefreshRewardState()
end

EventWeeklyQAData.SetWeeklyQADataLooked = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetWeeklyQALooked(self:GetActId(), self.currentOrder)
  self:__UpdateWeeklyQA()
end

EventWeeklyQAData.RefreshRewardState = function(self)
  -- function num : 0_8 , upvalues : _ENV, EventWeeklyQAQuestionRewardData
  local currentScore = self:GetQADataScore()
  for _,rewardData in ipairs(self.rewards) do
    if (self.rewardGot)[rewardData.needScore] then
      rewardData.currentState = (EventWeeklyQAQuestionRewardData.eRewardState).Picked
    else
      if rewardData.needScore <= currentScore then
        rewardData.currentState = (EventWeeklyQAQuestionRewardData.eRewardState).CompleteNoPicked
      end
    end
  end
  self:__UpdateWeeklyQA()
end

EventWeeklyQAData.ReFlushAllQuestionOptions = function(self)
  -- function num : 0_9 , upvalues : _ENV
  for _,questionData in ipairs(self.questions) do
    questionData:FlushWeeklyQAOptions()
  end
end

EventWeeklyQAData.GetWeeklyQAMainCfg = function(self)
  -- function num : 0_10
  return self._mainCfg
end

EventWeeklyQAData.GetWeeklyQARewardCfg = function(self)
  -- function num : 0_11
  return self._rewardCfg
end

EventWeeklyQAData.CheckIsAllRight = function(self)
  -- function num : 0_12 , upvalues : _ENV, EventWeeklyQAQuestionData
  for _,question in ipairs(self.questions) do
    if question.questionResult ~= (EventWeeklyQAQuestionData.eQuestionResult).trueAnswer then
      return false
    end
  end
  return true
end

EventWeeklyQAData.CheckIsAnsweredAllQuestions = function(self)
  -- function num : 0_13 , upvalues : _ENV, EventWeeklyQAQuestionData
  for _,question in ipairs(self.questions) do
    if question.questionResult == (EventWeeklyQAQuestionData.eQuestionResult).notAnswer then
      return false
    end
  end
  return true
end

EventWeeklyQAData.GetCurrentQuestion = function(self)
  -- function num : 0_14
  return (self.questions)[self.currentQuestionIndex], self.lastAnsweredQuestionIndex
end

EventWeeklyQAData.HasQADataExpiredTm = function(self)
  -- function num : 0_15
  do return self.endTm > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EventWeeklyQAData.GetQADataExpiredTm = function(self)
  -- function num : 0_16
  return self.endTm
end

EventWeeklyQAData.GetQADataIsExpired = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameData = actFrameCtr:GetActivityFrameData(self:GetActFrameId())
  if actFrameData == nil or not actFrameData:IsActivityOpen() then
    return true
  end
  return false
end

EventWeeklyQAData.GetQADataScore = function(self)
  -- function num : 0_18 , upvalues : _ENV, EventWeeklyQAQuestionData
  local currentScore = 0
  for _,question in ipairs(self.questions) do
    if question.questionResult == (EventWeeklyQAQuestionData.eQuestionResult).trueAnswer then
      currentScore = currentScore + 1
    end
  end
  return currentScore
end

return EventWeeklyQAData

