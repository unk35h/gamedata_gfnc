-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum21Exchange = class("UIActSum21Exchange", UIBaseWindow)
local base = UIBaseWindow
local UINAct21SumExcgRewardList = require("Game.ActivitySummer.UI.ActSum21Exchange.UINAct21SumExcgRewardList")
local UINAct21SumExcgHardDisk = require("Game.ActivitySummer.UI.ActSum21Exchange.UINAct21SumExcgHardDisk")
UIActSum21Exchange.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAct21SumExcgRewardList, UINAct21SumExcgHardDisk
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self._OnClickAdd)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Max, self, self._OnClickAdd2Max)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Min, self, self._OnClickMin)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Least, self, self._OnClickMin2Least)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exchange, self, self._OnClickExchange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReSetHD, self, self._OnClickReset)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_resourceItem, self, self._OnClickRes)
  ;
  (((self.ui).btn_Add).onPress):AddListener(BindCallback(self, self._OnClickAddOnPress))
  ;
  (((self.ui).btn_Add).onPressUp):AddListener(BindCallback(self, self._OnPressUp))
  ;
  (((self.ui).btn_Min).onPress):AddListener(BindCallback(self, self._OnClickMinOnPress))
  ;
  (((self.ui).btn_Min).onPressUp):AddListener(BindCallback(self, self._OnPressUp))
  ;
  (((self.ui).inputField).onEndEdit):AddListener(BindCallback(self, self._OnInputFieldEndEdit))
  self.rewardListNode = (UINAct21SumExcgRewardList.New)(self)
  ;
  (self.rewardListNode):Init((self.ui).table)
  self.HDNode = (UINAct21SumExcgHardDisk.New)()
  ;
  (self.HDNode):Init((self.ui).HDNode)
  self._onPoolIdcallback = BindCallback(self, self._OnPoolIdcallback)
  self.netCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivitySectorI)
  ;
  (UIUtil.SetTopStatus)(self, self._OnClickClose)
  self._OnItemChangeFunc = BindCallback(self, self._OnItemChange)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  ;
  ((self.ui).obj_HDType):SetActive(false)
  ;
  ((self.ui).Fx_Complete):SetActive(false)
end

UIActSum21Exchange.InitActSum21Exchange = function(self, sectorIData, withAutoPopup)
  -- function num : 0_1 , upvalues : _ENV
  self.sectorIData = sectorIData
  self.pickedRewardPoolIdDic = (self.sectorIData):GenActSectorIRewardExchanged()
  local curPickedNum = 0
  for k,num in pairs(self.pickedRewardPoolIdDic) do
    curPickedNum = curPickedNum + num
  end
  self.curPickedNum = curPickedNum
  ;
  (self.HDNode):InitHDNode(sectorIData, self._onPoolIdcallback)
  ;
  (self.HDNode):RefreshHD(self.curPickedNum, (self.curPoolParaCfg).allRewardNum)
  local endTs = sectorIData:GetActivityDestroyTime()
  local date = TimeUtil:TimestampToDate(endTs, false, true)
  local timeStr = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  ;
  ((self.ui).tex_OverTime):SetIndex(0, timeStr)
  if withAutoPopup and (self.curPoolParaCfg).allRewardNum == self.curPickedNum then
    self:_Show2NextPool()
  end
end

UIActSum21Exchange._OnPoolIdcallback = function(self, poolId, poolIdx)
  -- function num : 0_2
  self:_SelectPool(poolId, poolIdx)
end

UIActSum21Exchange._SelectPool = function(self, poolId, poolIdx)
  -- function num : 0_3 , upvalues : _ENV
  local poolParaCfg = (ConfigData.activity_time_limit_pool_para)[poolId]
  if poolParaCfg == nil then
    error("Cant get activity_time_limit_pool_para,id = " .. tostring(poolId))
    return 
  end
  self.curPoolParaCfg = poolParaCfg
  self:_UpdResNum()
  local sprite = CRH:GetSpriteByItemId((self.curPoolParaCfg).costId)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ResIcon).sprite = sprite
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_BtnCostIcon).sprite = sprite
  self.curCostGroupNum = 0
  self:_RefreshCurCost()
  ;
  (self.rewardListNode):InitAct21SumExcgRewardList(poolId, poolIdx, self.pickedRewardPoolIdDic, (self.sectorIData).roundId)
  ;
  (self.rewardListNode):ShowRefreshUITween()
  local isCurPool = poolId == (self.sectorIData).roundId
  local isClearPoolIdx = poolId < (self.sectorIData).roundId and 1 or 0
  ;
  ((self.ui).obj_exchangeCount):SetActive(isCurPool)
  ;
  ((self.ui).obj_HDType):SetActive(not isCurPool)
  ;
  ((self.ui).tex_HDType):SetIndex(isClearPoolIdx)
  local showResetBtn = false
  if poolParaCfg.round == -1 then
    if poolParaCfg.allRewardNum ~= self.curPickedNum then
      showResetBtn = not isCurPool
      showResetBtn = true
      for k,rewardId in ipairs(poolParaCfg.reward_id) do
        local bigRewardCfg = (poolParaCfg.poolContent)[rewardId]
        if bigRewardCfg.num ~= (self.pickedRewardPoolIdDic)[rewardId] then
          showResetBtn = false
          break
        end
      end
      ;
      (((self.ui).btn_ReSetHD).gameObject):SetActive(showResetBtn)
      -- DECOMPILER ERROR: 7 unprocessed JMP targets
    end
  end
end

UIActSum21Exchange._OnInputFieldEndEdit = function(self, value)
  -- function num : 0_4 , upvalues : _ENV
  local val = 0
  if not (string.IsNullOrEmpty)(value) then
    val = tonumber(value)
  end
  self:_TryChangeNum(val)
end

UIActSum21Exchange._OnClickAddOnPress = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self:_TryChangeNum(self.curCostGroupNum + 1) then
    AudioManager:PlayAudioById(1064)
  end
end

UIActSum21Exchange._OnClickMinOnPress = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self:_TryChangeNum(self.curCostGroupNum - 1) then
    AudioManager:PlayAudioById(1065)
  end
end

UIActSum21Exchange._OnPressUp = function(self)
  -- function num : 0_7
end

UIActSum21Exchange._OnClickAdd = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self:_TryChangeNum(self.curCostGroupNum + 1) then
    AudioManager:PlayAudioById(1064)
  else
    ;
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7011))
  end
end

UIActSum21Exchange._OnClickAdd2Max = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local maxGroupNum = self:_GetMaxAddableNum()
  self:_TryChangeNum(maxGroupNum)
  AudioManager:PlayAudioById(1064)
end

UIActSum21Exchange._OnClickMin = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self:_TryChangeNum(self.curCostGroupNum - 1) then
    AudioManager:PlayAudioById(1065)
  end
end

UIActSum21Exchange._OnClickMin2Least = function(self)
  -- function num : 0_11 , upvalues : _ENV
  self:_TryChangeNum(0)
  AudioManager:PlayAudioById(1065)
end

UIActSum21Exchange._TryChangeNum = function(self, num)
  -- function num : 0_12 , upvalues : _ENV
  local maxGroupNum = self:_GetMaxAddableNum()
  local newNum = (math.clamp)(num, 0, maxGroupNum)
  local change = false
  if newNum ~= self.curCostGroupNum then
    self.curCostGroupNum = newNum
    change = true
  end
  self:_RefreshCurCost()
  return change
end

UIActSum21Exchange._GetMaxAddableNum = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local resItemNum = PlayerDataCenter:GetItemCount((self.curPoolParaCfg).costId)
  local maxGroupNum = resItemNum // (self.curPoolParaCfg).costNum
  local totalNum = (self.curPoolParaCfg).allRewardNum - self.curPickedNum
  maxGroupNum = (math.min)(maxGroupNum, totalNum)
  return maxGroupNum
end

UIActSum21Exchange._RefreshCurCost = function(self)
  -- function num : 0_14 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).inputField).text = tostring(self.curCostGroupNum)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if self.curCostGroupNum == 0 then
    ((self.ui).btn_Exchange).interactable = false
    ;
    ((self.ui).tex_Count):SetIndex(0, tostring((self.curPoolParaCfg).costNum))
    return 
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_Exchange).interactable = true
  local totalCostNum = self.curCostGroupNum * (self.curPoolParaCfg).costNum
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(totalCostNum))
end

UIActSum21Exchange._OnClickExchange = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.curCostGroupNum <= 0 then
    return 
  end
  self._lastStartExIdx = (self.sectorIData).roundIndex
  self._lastExNum = self.curCostGroupNum
  if not self._OnExchangeCompleteFunc then
    self._OnExchangeCompleteFunc = BindCallback(self, self._OnExchangeComplete)
    ;
    (self.netCtrl):CS_ACTIVITYSECTORI_ExecLottery((self.sectorIData).actId, self.curCostGroupNum, self._OnExchangeCompleteFunc)
  end
end

UIActSum21Exchange._OnExchangeComplete = function(self, objList)
  -- function num : 0_16 , upvalues : _ENV
  if objList.Count == 0 then
    error("objList.Count == 0")
    return 
  end
  local msg = objList[0]
  if isGameDev then
    (self.sectorIData):CheckShuffleResult(self._lastStartExIdx, self._lastExNum, msg.rewards)
  end
  local rewardList = {}
  local rewardIdDic = {}
  for k,v in ipairs(msg.rewards) do
    if rewardIdDic[v.elemNumber] == nil then
      local rewardCfg = ((self.curPoolParaCfg).poolContent)[v.elemNumber]
      if rewardCfg == nil then
        error("Cant get activity_time_limit_pool,id = " .. tostring(v.elemNumber))
      else
        local rewardData = {rewardId = v.elemNumber, itemId = rewardCfg.rewardId, itemNum = rewardCfg.rewardNum, groupNum = 1, rewardCfg = rewardCfg}
        ;
        (table.insert)(rewardList, rewardData)
        rewardIdDic[v.elemNumber] = rewardData
      end
    else
      do
        do
          local rewardData = rewardIdDic[v.elemNumber]
          rewardData.groupNum = rewardData.groupNum + 1
          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  ;
  (table.sort)(rewardList, function(a, b)
    -- function num : 0_16_0 , upvalues : self
    return (self.ActSum21ExchangeRewardSortFunc)(a.rewardCfg, b.rewardCfg)
  end
)
  self:InitActSum21Exchange(self.sectorIData)
  self._lastRewardList = rewardList
  self:PlayCompleteFx()
end

UIActSum21Exchange._OnClickReset = function(self)
  -- function num : 0_17 , upvalues : _ENV
  AudioManager:PlayAudioById(1138)
  self:_Show2NextPool()
end

UIActSum21Exchange._Show2NextPool = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local msg = nil
  if (self.curPoolParaCfg).allRewardNum == self.curPickedNum then
    msg = ConfigData:GetTipContent(7003)
  else
    msg = ConfigData:GetTipContent(7002)
  end
  local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
  window:ShowTextBoxWithYesAndNo(msg, function()
    -- function num : 0_18_0 , upvalues : self
    (self.netCtrl):CS_ACTIVITYSECTORI_NextLotteryRound((self.sectorIData).actId, function()
      -- function num : 0_18_0_0 , upvalues : self
      self:InitActSum21Exchange(self.sectorIData)
    end
)
  end
)
end

UIActSum21Exchange._OnItemChange = function(self, itemUpdate)
  -- function num : 0_19
  if itemUpdate[(self.curPoolParaCfg).costId] == nil then
    return 
  end
  self:_UpdResNum()
  self:_TryChangeNum(self.curCostGroupNum)
end

UIActSum21Exchange._UpdResNum = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local resItemNum = PlayerDataCenter:GetItemCount((self.curPoolParaCfg).costId)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ResCount).text = tostring(resItemNum)
end

UIActSum21Exchange.ActSum21ExchangeRewardSortFunc = function(rewardCfgA, rewardCfgB)
  -- function num : 0_21 , upvalues : _ENV
  if rewardCfgA.reward_type >= rewardCfgB.reward_type then
    do return rewardCfgA.reward_type == rewardCfgB.reward_type end
    if rewardCfgB.priority >= rewardCfgA.priority then
      do return rewardCfgA.priority == rewardCfgB.priority end
      local qualityA = ((ConfigData.item)[rewardCfgA.rewardId]).quality
      local qualityB = ((ConfigData.item)[rewardCfgB.rewardId]).quality
      if qualityB >= qualityA then
        do return qualityA == qualityB end
        do return rewardCfgA.id < rewardCfgB.id end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end

UIActSum21Exchange._OnClickRes = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local window = UIManager:ShowWindow(UIWindowTypeID.GlobalItemDetail)
  local itemCfg = (ConfigData.item)[(self.curPoolParaCfg).costId]
  window:InitCommonItemDetail(itemCfg)
end

UIActSum21Exchange.PlayCompleteFx = function(self, rewardList)
  -- function num : 0_23 , upvalues : _ENV
  ((self.ui).Fx_Complete):SetActive(true)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).blocksRaycasts = false
  AudioManager:PlayAudioById(1137)
  if self._timerID ~= nil then
    TimerManager:StopTimer(self._timerID)
    self._timerID = nil
  end
  local fxTime = (self.ui).flo_FxTime or 3.5
  self._timerID = TimerManager:StartTimer(fxTime, function()
    -- function num : 0_23_0 , upvalues : self
    self._timerID = nil
    ;
    ((self.ui).Fx_Complete):SetActive(false)
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup).blocksRaycasts = true
    self:ShowExchangeReward(self._lastRewardList)
  end
, self, true, false, false)
end

UIActSum21Exchange.ShowExchangeReward = function(self, rewardList)
  -- function num : 0_24 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum21ExchangeResult, function(win)
    -- function num : 0_24_0 , upvalues : rewardList, self, _ENV
    if win == nil then
      return 
    end
    win:InitActSum21ExchangeResult(rewardList, function()
      -- function num : 0_24_0_0 , upvalues : self, _ENV
      if (self.curPoolParaCfg).allRewardNum == self.curPickedNum and not IsNull(self.gameObject) then
        self:_Show2NextPool()
      end
    end
)
  end
)
end

UIActSum21Exchange._OnClickClose = function(self)
  -- function num : 0_25
  if self._timerID ~= nil then
    self:ShowExchangeReward(self._lastRewardList)
  end
  self:Delete()
end

UIActSum21Exchange.OnDelete = function(self)
  -- function num : 0_26 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._OnItemChangeFunc)
  ;
  (self.rewardListNode):Delete()
  ;
  (self.HDNode):Delete()
  if self._timerID ~= nil then
    TimerManager:StopTimer(self._timerID)
    self._timerID = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIActSum21Exchange

