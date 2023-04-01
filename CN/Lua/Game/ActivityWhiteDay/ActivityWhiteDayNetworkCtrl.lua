-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityWhiteDayNetworkCtrl = class("ActivityWhiteDayNetworkCtrl", NetworkCtrlBase)
local cs_MessageCommon = CS.MessageCommon
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityWhiteDayNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.productMsg = {}
  self.collectMsg = {}
  self.accMsg = {}
  self._skinBuyTable = {}
  self._historyTable = {}
end

ActivityWhiteDayNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Product, self, proto_csmsg.SC_Activity_Factory_Product, self.SC_Activity_Factory_Product)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Order_Speed, self, proto_csmsg.SC_Activity_Factory_Order_Speed, self.SC_Activity_Factory_Order_Speed)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Collect, self, proto_csmsg.SC_Activity_Factory_Collect, self.SC_Activity_Factory_Collect)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_Lottery, self, proto_csmsg.SC_Activity_Polariod_Lottery, self.SC_Activity_Polariod_Lottery)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_SelfSelect, self, proto_csmsg.SC_Activity_Polariod_SelfSelect, self.SC_Activity_Polariod_SelfSelect)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_History, self, proto_csmsg.SC_Activity_Polariod_History, self.SC_Activity_Polariod_History)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_Buy_Skin, self, proto_csmsg.SC_Activity_Polariod_Buy_Skin, self.SC_Activity_Polariod_Buy_Skin)
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Factory_Product = function(self, actFrameId, lineId, orderId, heroId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R6 in 'UnsetPending'

  (self.productMsg).actId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.productMsg).lineId = lineId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.productMsg).orderId = orderId
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.productMsg).heroId = heroId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Product, proto_csmsg.CS_Activity_Factory_Product, self.productMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Product, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Product)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Factory_Product = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Factory_Product error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Product)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Factory_Collect = function(self, actFrameId, lineId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.collectMsg).actId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.collectMsg).id = lineId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Collect, proto_csmsg.CS_Activity_Factory_Collect, self.collectMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Collect, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Collect)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Factory_Collect = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Factory_Collect error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Collect)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Collect, msg.rewards)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Factory_Order_Speed = function(self, actFrameId, lineId, itemId, itemNum, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R6 in 'UnsetPending'

  (self.accMsg).actId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.accMsg).lineId = lineId
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.accMsg).itemId = itemId
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.accMsg).itemNum = itemNum
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Order_Speed, proto_csmsg.CS_Activity_Factory_Order_Speed, self.accMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Order_Speed, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Factory_Order_Speed)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Factory_Order_Speed = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    if msg.ret == proto_csmsg_ErrorCode.ACTIVITY_ORDER_SPEED_ITEM_TO_MUCH then
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7204))
    else
      local err = "SC_Activity_Factory_Order_Speed error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
    end
    do
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Factory_Order_Speed)
      NetworkManager:HandleDiff(msg.syncUpdateDiff)
    end
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Polariod_Lottery = function(self, actFrameId, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.actId = actFrameId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Lottery, proto_csmsg.CS_Activity_Polariod_Lottery, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Lottery, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_Lottery)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Polariod_Lottery = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Polariod_Lottery error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Lottery)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Lottery, msg.photoId)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Polariod_SelfSelect = function(self, actFrameId, selectPhotoId, callback)
  -- function num : 0_10 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.actId = actFrameId
  msg.selectId = selectPhotoId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_SelfSelect, proto_csmsg.CS_Activity_Polariod_SelfSelect, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_SelfSelect, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_SelfSelect)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Polariod_SelfSelect = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Polariod_SelfSelect error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_SelfSelect)
      return 
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Polariod_History = function(self, actId, callback)
  -- function num : 0_12 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._historyTable).actId = actId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_History, proto_csmsg.CS_Activity_Polariod_History, self._historyTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_History, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_History)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Polariod_History = function(self, msg)
  -- function num : 0_13 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Polariod_History error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_History)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_History, msg.data)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.CS_Activity_Polariod_Buy_Skin = function(self, actFrameId, photoId, callback)
  -- function num : 0_14 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._skinBuyTable).actLongId = actFrameId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._skinBuyTable).photoId = photoId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Buy_Skin, proto_csmsg.CS_Activity_Polariod_Buy_Skin, self._skinBuyTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Buy_Skin, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Polariod_Buy_Skin)
end

ActivityWhiteDayNetworkCtrl.SC_Activity_Polariod_Buy_Skin = function(self, msg)
  -- function num : 0_15 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Polariod_Buy_Skin error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Buy_Skin)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_Activity_Polariod_Buy_Skin, msg.data)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityWhiteDayNetworkCtrl.Reset = function(self)
  -- function num : 0_16
end

return ActivityWhiteDayNetworkCtrl

