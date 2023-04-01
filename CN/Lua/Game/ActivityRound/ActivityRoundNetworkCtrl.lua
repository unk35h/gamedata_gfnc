-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityRoundNetworkCtrl = class("ActivityRoundNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityRoundNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._lotteryTable = {}
  self._changePoolTable = {}
end

ActivityRoundNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityRound_ExecLottery, self, proto_csmsg.SC_ActivityRound_ExecLottery, self.SC_ActivityRound_ExecLottery)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityRound_NextLotteryRound, self, proto_csmsg.SC_ActivityRound_NextLotteryRound, self.SC_ActivityRound_NextLotteryRound)
end

ActivityRoundNetworkCtrl.CS_ActivityRound_ExecLottery = function(self, actId, num, roundId, callback)
  -- function num : 0_2 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self._lotteryTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lotteryTable).num = num
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._lotteryTable).roundId = roundId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityRound_ExecLottery, proto_csmsg.CS_ActivityRound_ExecLottery, self._lotteryTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityRound_ExecLottery, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityRound_ExecLottery)
end

ActivityRoundNetworkCtrl.SC_ActivityRound_ExecLottery = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= 0 then
    local err = "ActivityRoundNetworkCtrl:ActivityRound_ExecLottery error:" .. tostring(msg.ret)
    do
      self:ShowSCErrorMsg(err)
    end
  else
    do
      local rewardElem = msg.rewards
      local rewardDic = {}
      for _,elem in ipairs(rewardElem) do
        local tempCount = rewardDic[elem.id] or 0
        rewardDic[elem.id] = tempCount + elem.num
      end
      local rewardIds = {}
      local rewardNums = {}
      for itemId,itemCount in pairs(rewardDic) do
        (table.insert)(rewardIds, itemId)
        ;
        (table.insert)(rewardNums, itemCount)
      end
      self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_3_0 , upvalues : _ENV, rewardIds, rewardNums, self
    if window == nil then
      return 
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = ((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot, false)):SetCRNotHandledGreat(true)):SetCRShowOverFunc(function()
      -- function num : 0_3_0_0 , upvalues : _ENV
      local achievementSystemWin = UIManager:GetWindow(UIWindowTypeID.AchievementSystem)
      if achievementSystemWin ~= nil then
        ((achievementSystemWin.achievementLevelNode).__NeedRefreshPlayerLevel)()
      end
    end
)
    window:AddAndTryShowReward(CRData)
  end
)
    end
  end
end

ActivityRoundNetworkCtrl.CS_ActivityRound_NextLotteryRound = function(self, actId, roundId, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._changePoolTable).actId = actId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._changePoolTable).roundId = roundId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityRound_NextLotteryRound, proto_csmsg.CS_ActivityRound_NextLotteryRound, self._changePoolTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityRound_NextLotteryRound, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityRound_NextLotteryRound)
end

ActivityRoundNetworkCtrl.SC_ActivityRound_NextLotteryRound = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= 0 then
    local err = "ActivityRoundNetworkCtrl:ActivityRound_NextLotteryRound error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
  end
end

return ActivityRoundNetworkCtrl

