-- params : ...
-- function num : 0 , upvalues : _ENV
local FlappyBirdNetWorkCtrl = class("FlappyBirdNetWorkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
FlappyBirdNetWorkCtrl.ctor = function(self)
  -- function num : 0_0
  self.__sendMsg = {}
end

FlappyBirdNetWorkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_FlappyBird_Settle, self, proto_csmsg.SC_FlappyBird_Settle, self.SC_FlappyBird_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_FlappyBird_ProgressDetail, self, proto_csmsg.SC_FlappyBird_ProgressDetail, self.SC_FlappyBird_ProgressDetail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_FlappyBird_SelfRankDetail, self, proto_csmsg.SC_FlappyBird_SelfRankDetail, self.SC_FlappyBird_SelfRankDetail)
end

FlappyBirdNetWorkCtrl.CS_FlappyBird_Settle = function(self, actGroupId, birdId, score, frameNum, checkParam, action)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  self.__sendMsg = {}
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__sendMsg).actLongId = actGroupId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__sendMsg).birdId = birdId
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__sendMsg).score = score
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__sendMsg).currentFrame = frameNum
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__sendMsg).checkParam = checkParam
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_Settle, proto_csmsg.CS_FlappyBird_Settle, self.__sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_Settle, action, proto_csmsg_MSG_ID.MSG_SC_FlappyBird_Settle)
end

FlappyBirdNetWorkCtrl.SC_FlappyBird_Settle = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_Settle)
    local err = "FlappyBirdNetWorkCtrl:SC_FlappyBird_Settle error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
  do
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_Settle, msg)
  end
end

FlappyBirdNetWorkCtrl.CS_FlappyBird_ProgressDetail = function(self, actLongId, birdId, action)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  self.__sendMsg = {}
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendMsg).actLongId = actLongId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendMsg).birdId = birdId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_ProgressDetail, proto_csmsg.CS_FlappyBird_ProgressDetail, self.__sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_ProgressDetail, action, proto_csmsg_MSG_ID.MSG_SC_FlappyBird_ProgressDetail)
end

FlappyBirdNetWorkCtrl.SC_FlappyBird_ProgressDetail = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_ProgressDetail)
    local err = "FlappyBirdNetWorkCtrl:SC_FlappyBird_ProgressDetail error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
  do
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_ProgressDetail, msg)
  end
end

FlappyBirdNetWorkCtrl.CS_FlappyBird_SelfRankDetail = function(self, actLongId, birdId, action)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  self.__sendMsg = {}
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendMsg).actLongId = actLongId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendMsg).birdId = birdId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_SelfRankDetail, proto_csmsg.CS_FlappyBird_SelfRankDetail, self.__sendMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_SelfRankDetail, action, proto_csmsg_MSG_ID.MSG_SC_FlappyBird_SelfRankDetail)
end

FlappyBirdNetWorkCtrl.SC_FlappyBird_SelfRankDetail = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_SelfRankDetail)
    local err = "FlappyBirdNetWorkCtrl:SC_FlappyBird_SelfRankDetail error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
  do
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_FlappyBird_SelfRankDetail, msg)
  end
end

return FlappyBirdNetWorkCtrl

