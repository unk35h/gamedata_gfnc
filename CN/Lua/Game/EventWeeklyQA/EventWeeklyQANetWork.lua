-- params : ...
-- function num : 0 , upvalues : _ENV
local EventWeeklyQANetWork = class("EventWeeklyQANetWork", NetworkCtrlBase)
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
EventWeeklyQANetWork.ctor = function(self)
  -- function num : 0_0
  self._answerChoiceTable = {}
  self._answerRewardTable = {}
end

EventWeeklyQANetWork.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Answer_Choice, self, proto_csmsg.SC_Activity_Answer_Choice, self.SC_Activity_Answer_Choice)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Answer_Reward, self, proto_csmsg.SC_Activity_Answer_Reward, self.SC_Activity_Answer_Reward)
end

EventWeeklyQANetWork.CS_Activity_Answer_Choice = function(self, actId, questionId, choice, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self._answerChoiceTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._answerChoiceTable).questionId = questionId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._answerChoiceTable).choice = choice
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Choice, proto_csmsg.CS_Activity_Answer_Choice, self._answerChoiceTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Choice, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Answer_Choice)
end

EventWeeklyQANetWork.SC_Activity_Answer_Choice = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Answer_Choice error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Choice)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

EventWeeklyQANetWork.CS_Activity_Answer_Reward = function(self, actId, needScore, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._answerRewardTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._answerRewardTable).needScore = needScore
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Reward, proto_csmsg.CS_Activity_Answer_Reward, self._answerRewardTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Reward, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Answer_Reward)
end

EventWeeklyQANetWork.SC_Activity_Answer_Reward = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse, CommonRewardData
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Answer_Choice error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Answer_Reward)
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_5_0 , upvalues : CommonRewardData, msg
    if window == nil then
      return 
    end
    local CRData = (CommonRewardData.CreateCRDataUseDic)(msg.rewards)
    window:AddAndTryShowReward(CRData)
  end
)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

return EventWeeklyQANetWork

