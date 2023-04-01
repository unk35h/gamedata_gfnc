-- params : ...
-- function num : 0 , upvalues : _ENV
local BattlePassNetworkCtrl = class("BattlePassNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
BattlePassNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.__sendBattlePassTake = {}
  self.__sendBattlePassBuy = {}
  self.__sendBattlePassBuyExp = {}
end

BattlePassNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Detail, self, proto_csmsg.SC_BATTLEPASS_Detail, self.SC_BATTLEPASS_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Take, self, proto_csmsg.SC_BATTLEPASS_Take, self.SC_BATTLEPASS_Take)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_SyncDiff, self, proto_csmsg.SC_BATTLEPASS_SyncDiff, self.SC_BATTLEPASS_SyncDiff)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Buy, self, proto_csmsg.SC_BATTLEPASS_Buy, self.SC_BATTLEPASS_Buy)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Buy_Exp, self, proto_csmsg.SC_BATTLEPASS_Buy_Exp, self.SC_BATTLEPASS_Buy_Exp)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Changed_Ntf, self, proto_csmsg.SC_BATTLEPASS_Changed_Ntf, self.SC_BATTLEPASS_Changed_Ntf)
end

BattlePassNetworkCtrl.CS_BATTLEPASS_Detail = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Detail, proto_csmsg.CS_BATTLEPASS_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartOrAddWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Detail, proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Detail)
end

BattlePassNetworkCtrl.SC_BATTLEPASS_Detail = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  if msg.data ~= nil then
    (PlayerDataCenter.battlepassData):InitAllBattlePass(msg.data)
  end
end

BattlePassNetworkCtrl.CS_BATTLEPASS_Take = function(self, id, level, takeway)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.__sendBattlePassTake).id = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendBattlePassTake).lv = level
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendBattlePassTake).way = takeway
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Take, proto_csmsg.CS_BATTLEPASS_Take, self.__sendBattlePassTake)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Take, proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Take)
end

BattlePassNetworkCtrl.SC_BATTLEPASS_Take = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse, CommonRewardData
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattlePassNetworkCtrl:SC_BATTLEPASS_Take error:" .. tostring(msg.ret)
    do
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Take)
    end
  else
    do
      local idTable = {}
      local numTable = {}
      for i,v in ipairs((msg.reward).data) do
        (table.insert)(idTable, v.id)
        ;
        (table.insert)(numTable, v.num)
      end
      if #idTable > 0 then
        local passInfo = (PlayerDataCenter.battlepassData):GetBattlePass((self.__sendBattlePassTake).id)
        if passInfo ~= nil and passInfo:IsBattleType() and not passInfo:GetBattlePassUnlockSenior() then
          local item_ids, item_nums = passInfo:GetPassLevelReward(1, passInfo.level, false, true)
          ;
          (CommonUtil.DefaultItemsSortList)(item_ids, item_nums)
          UIManager:ShowWindowAsync(UIWindowTypeID.BpSpReward, function(window)
    -- function num : 0_5_0 , upvalues : CommonRewardData, idTable, numTable, item_ids, item_nums, _ENV, passInfo
    if window == nil then
      return 
    end
    local CRData = (CommonRewardData.CreateCRDataUseList)(idTable, numTable)
    ;
    (CRData:SetBpSpRewardPreview(item_ids, item_nums)):SetCRShowOverBuyFunc(function()
      -- function num : 0_5_0_0 , upvalues : _ENV, passInfo
      UIManager:ShowWindowAsync(UIWindowTypeID.EventBattlePassPurchase, function(purchaseWindow)
        -- function num : 0_5_0_0_0 , upvalues : passInfo
        if purchaseWindow == nil then
          return 
        end
        purchaseWindow:InitBattlePassPurchaseUI(passInfo)
      end
)
    end
)
    window:AddAndTryShowReward(CRData)
  end
)
        else
          do
            do
              UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_5_1 , upvalues : CommonRewardData, idTable, numTable
    if window == nil then
      return 
    end
    local CRData = (CommonRewardData.CreateCRDataUseList)(idTable, numTable)
    window:AddAndTryShowReward(CRData)
  end
)
              idTable = NetworkManager
              idTable(idTable, msg.syncUpdateDiff)
            end
          end
        end
      end
    end
  end
end

BattlePassNetworkCtrl.CS_BATTLEPASS_Buy = function(self, payId, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.__sendBattlePassBuy).payId = payId
  self.__buyCallback = callback
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy, proto_csmsg.CS_BATTLEPASS_Buy, self.__sendBattlePassBuy)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy, proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Buy)
end

BattlePassNetworkCtrl.SC_BATTLEPASS_Buy = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV, cs_WaitNetworkResponse
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "BattlePassNetworkCtrl:SC_BATTLEPASS_Buy error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy)
  else
    do
      do
        local payCtr = ControllerManager:GetController(ControllerTypeId.Pay)
        payCtr:ReqPay((self.__sendBattlePassBuy).payId, 1, nil, nil, self.__buyCallback)
        NetworkManager:HandleDiff(msg.syncUpdateDiff)
        self.__buyCallback = nil
      end
    end
  end
end

BattlePassNetworkCtrl.CS_BATTLEPASS_Buy_Exp = function(self, id, num, callback)
  -- function num : 0_8 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.__sendBattlePassBuyExp).id = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.__sendBattlePassBuyExp).num = num
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy_Exp, proto_csmsg.CS_BATTLEPASS_Buy_Exp, self.__sendBattlePassBuyExp)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy_Exp, callback, proto_csmsg_MSG_ID.MSG_SC_BATTLEPASS_Buy_Exp)
end

BattlePassNetworkCtrl.SC_BATTLEPASS_Buy_Exp = function(self, msg)
  -- function num : 0_9 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "BattlePassNetworkCtrl:SC_BATTLEPASS_Buy_Exp error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_BATTLEPASS_Buy_Exp)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

BattlePassNetworkCtrl.SC_BATTLEPASS_Changed_Ntf = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV
  if msg ~= nil then
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
    MsgCenter:Broadcast(eMsgEventId.BattlePassBuy)
  end
end

BattlePassNetworkCtrl.SC_BATTLEPASS_SyncDiff = function(self, msg)
  -- function num : 0_11 , upvalues : _ENV
  (PlayerDataCenter.battlepassData):UpdateAllBattlePass(msg.update)
end

BattlePassNetworkCtrl.Reset = function(self)
  -- function num : 0_12
  self.__buyCallback = nil
end

return BattlePassNetworkCtrl

