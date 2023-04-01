-- params : ...
-- function num : 0 , upvalues : _ENV
local PayGiftNetworkController = class("PayGiftNetworkController", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
PayGiftNetworkController.ctor = function(self)
  -- function num : 0_0
  self._sendBuy = {}
end

PayGiftNetworkController.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Gift_Buy, self, proto_csmsg.SC_Gift_Buy, self.SC_Gift_Buy)
end

PayGiftNetworkController.CS_Gift_Buy = function(self, id, params, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._sendBuy).giftId = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._sendBuy).params = params
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Gift_Buy, proto_csmsg.CS_Gift_Buy, self._sendBuy)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Gift_Buy, callback, proto_csmsg_MSG_ID.MSG_SC_Gift_Buy)
end

PayGiftNetworkController.SC_Gift_Buy = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse, CommonRewardData
  do
    if msg.ret ~= 0 then
      local err = "SC_Gift_Buy:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Gift_Buy)
    end
    if msg.rewards ~= nil and not (table.IsEmptyTable)(msg.rewards) then
      self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_3_0 , upvalues : _ENV, CommonRewardData, msg, self
    if window == nil then
      return 
    end
    local textMsg = ConfigData:GetTipContent(297)
    local CRData = (((CommonRewardData.CreateCRDataUseDic)(msg.rewards)):SetCRHeroSnapshoot(self._heroIdSnapShoot)):SetCRTitle(textMsg)
    window:AddAndTryShowReward(CRData)
  end
)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

return PayGiftNetworkController

