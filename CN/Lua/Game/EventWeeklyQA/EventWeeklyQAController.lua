-- params : ...
-- function num : 0 , upvalues : _ENV
local EventWeeklyQAController = class("EventWeeklyQAController", ControllerBase)
local base = ControllerBase
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local EventWeeklyQAData = require("Game.EventWeeklyQA.Data.EventWeeklyQAData")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local EventWeeklyQAQuestionData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionData")
local CS_MessageCommon = CS.MessageCommon
EventWeeklyQAController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.activity_answer_main)
  ConfigData:LoadDynCfg(eDynConfigData.activity_answer_library)
  ConfigData:LoadDynCfg(eDynConfigData.activity_answer_problem)
  ConfigData:LoadDynCfg(eDynConfigData.activity_answer_reward)
  self._dataDic = {}
  self._net = NetworkManager:GetNetwork(NetworkTypeID.EventWeeklyQA)
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self._updateQuestionState = BindCallback(self, self.UpdateQuestionState)
  self._ReqWeeklyQAData = BindCallback(self, self.ReqWeeklyQAData)
end

EventWeeklyQAController.InitWeeklyQA = function(self, msg)
  -- function num : 0_1 , upvalues : EventWeeklyQAData
  local data = (EventWeeklyQAData.New)()
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitEventWeeklyQADataByMsg(msg)
  if data:HasQADataExpiredTm() then
    (self._frameCtrl):AddActivityDataUpdateTimeListen(data:GetActFrameId(), data:GetQADataExpiredTm() + 1, self._ReqWeeklyQAData)
  end
  return data
end

EventWeeklyQAController.GetTheLatestWeeklyQAData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local res = nil
  for k,v in pairs(self._dataDic) do
    if res == nil then
      res = v
    else
      if res:GetActivityBornTime() < v:GetActivityBornTime() then
        res = v
      end
    end
  end
  return res
end

EventWeeklyQAController.ReqWeeklyQAData = function(self, frameId)
  -- function num : 0_3 , upvalues : _ENV
  local actFrameNet = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actFrameNet:CS_ACTIVITY_SingleConcreteInfo(frameId, function(objList)
    -- function num : 0_3_0 , upvalues : self
    local msg = objList[0]
    if msg ~= nil and msg.activityAnswer ~= nil then
      self:InitWeeklyQA(msg.activityAnswer)
      self:ShowWindowByWeeklyQAData()
    end
  end
)
end

EventWeeklyQAController.ShowWindowByWeeklyQAData = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local qaData = self:GetTheLatestWeeklyQAData()
  local qaMainWindow = UIManager:GetWindow(UIWindowTypeID.EventWeeklyQA)
  if qaMainWindow == nil then
    return 
  end
  qaMainWindow:RefreshWeeklyQAByQAData(qaData)
end

EventWeeklyQAController.ReqSetQuestionState = function(self, qaData, questionId, choice)
  -- function num : 0_5 , upvalues : CS_MessageCommon, _ENV
  if qaData:GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  ;
  (self._net):CS_Activity_Answer_Choice(qaData:GetActId(), questionId, choice, function()
    -- function num : 0_5_0 , upvalues : self, qaData, questionId, _ENV
    self:RecordCurrentQuestionIndex(qaData, questionId, questionId)
    local qaMainWindow = UIManager:GetWindow(UIWindowTypeID.EventWeeklyQA)
    if qaMainWindow == nil then
      return 
    end
    qaData:RefreshRewardState()
    qaMainWindow:RefreshWeeklyQARewards(qaData)
  end
)
end

EventWeeklyQAController.UpdateQuestionState = function(self, actId, questionId, logicIndex)
  -- function num : 0_6 , upvalues : _ENV
  local currentQAData = self:GetTheLatestWeeklyQAData()
  if currentQAData == nil or (currentQAData.questionsIdIndexDic)[questionId] == nil then
    return 
  end
  local questionIndex = (currentQAData.questionsIdIndexDic)[questionId]
  local questionData = (currentQAData.questions)[questionIndex]
  local newQuestionResult = questionData:SetQuestionResultByChoice(logicIndex)
  local qaMainWindow = UIManager:GetWindow(UIWindowTypeID.EventWeeklyQA)
  if qaMainWindow == nil then
    return 
  end
  qaMainWindow:SetResultItemByIndex(questionIndex, newQuestionResult)
  qaMainWindow:SetCharacterTalkLabel()
end

EventWeeklyQAController.RecordCurrentQuestionIndex = function(self, qaData, questionId, lastAnsweredQuestionId)
  -- function num : 0_7 , upvalues : _ENV
  local _, recordDic = (PlayerDataCenter.gameSettingData):IsGSDataDirty()
  if not lastAnsweredQuestionId or not lastAnsweredQuestionId then
    lastAnsweredQuestionId = 0
  end
  local opQuestionId = questionId << 16 | lastAnsweredQuestionId
  recordDic.ActivityAnswerOpId = opQuestionId
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_Client_Record_Set(recordDic)
  qaData:SetCurrentQuestionIndexByOpProblemId(opQuestionId)
end

EventWeeklyQAController.ReqGetWeeklyQAReward = function(self, qaData, needScore, callback)
  -- function num : 0_8
  if qaData:GetQADataIsExpired() then
    return 
  end
  ;
  (self._net):CS_Activity_Answer_Reward(qaData:GetActId(), needScore, callback)
end

EventWeeklyQAController.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_answer_main)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_answer_library)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_answer_problem)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_answer_reward)
end

return EventWeeklyQAController

