-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessSequenceCtrl = class("WarChessSequenceCtrl", base)
WarChessSequenceCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__playSequence = {}
  self.__tryPlayWCSLevelBuff = BindCallback(self, self.__TryPlayWCSLevelBuff)
  self.__tryPlayWCSLevelPressAdd = BindCallback(self, self.__TryPlayWCSLevelPressAdd)
  self.__playStartPlay = BindCallback(self, self.PlayStartPlay)
  self.__tryPlayWCSGetRewardWhenSettle = BindCallback(self, self.__TryPlayWCSGetRewardWhenSettle)
  self.__tryPlayWCSSelectLevelStage1 = BindCallback(self, self.__TryPlayWCSSelectLevelStage1)
  self.__tryPlayWCSSelectLevelStage2 = BindCallback(self, self.__TryPlayWCSSelectLevelStage2)
  self.__tryPalyCompleteFloorTip = BindCallback(self, self.__TryPalyCompleteFloorTip)
  self.__tryPalyGetRewradBagReward = BindCallback(self, self.__TryPalyGetRewradBagReward)
end

WarChessSequenceCtrl.AterEnterPlayState = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local sequence = {self.__tryPlayWCSLevelBuff, self.__tryPlayWCSLevelPressAdd, self.__playStartPlay}
  for _,callback in ipairs(sequence) do
    (table.insert)(self.__playSequence, callback)
  end
  self:__PlayNext()
end

WarChessSequenceCtrl.WhenWCSLevelSettle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local sequence = {self.__tryPlayWCSSelectLevelStage1, self.__tryPlayWCSGetRewardWhenSettle, self.__tryPalyCompleteFloorTip, self.__tryPlayWCSSelectLevelStage2}
  for _,callback in ipairs(sequence) do
    (table.insert)(self.__playSequence, callback)
  end
  self:__PlayNext()
end

WarChessSequenceCtrl.WhenBackPackUpdate = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local sequence = {self.__tryPalyGetRewradBagReward}
  for _,callback in ipairs(sequence) do
    (table.insert)(self.__playSequence, callback)
  end
  self:__PlayNext()
end

WarChessSequenceCtrl.__PlayNext = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if #self.__playSequence > 0 then
    local callback = (table.remove)(self.__playSequence, 1)
    callback()
  end
end

WarChessSequenceCtrl.SetWCStartPlayFunc = function(self, startPlayFunc)
  -- function num : 0_5
  self.__startPlayFunc = startPlayFunc
end

WarChessSequenceCtrl.PlayStartPlay = function(self)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(win)
    -- function num : 0_6_0 , upvalues : self
    win:OnWCStart(function()
      -- function num : 0_6_0_0 , upvalues : self
      if self.__startPlayFunc ~= nil then
        (self.__startPlayFunc)()
        self.__startPlayFunc = nil
      end
      self:__PlayNext()
    end
, 1.2)
  end
)
end

WarChessSequenceCtrl.SetWCSLevelBuff = function(self, envBuffData)
  -- function num : 0_7
  self.__wcsBuffData = envBuffData
end

WarChessSequenceCtrl.__TryPlayWCSLevelBuff = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.__wcsBuffData == nil then
    self:__PlayNext()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_8_0 , upvalues : self
    win:InitWCBuffDesc({self.__wcsBuffData}, function()
      -- function num : 0_8_0_0 , upvalues : self
      self.__wcsBuffData = nil
      self:__PlayNext()
    end
, 1.25)
    win:OpenBuffCloseFlyAni(1.25)
  end
)
end

WarChessSequenceCtrl.SetWCSLevelPressAdd = function(self, expAddNum)
  -- function num : 0_9
  self.__wcsExpAddNum = expAddNum
end

WarChessSequenceCtrl.__TryPlayWCSLevelPressAdd = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.__wcsExpAddNum == nil then
    self:__PlayNext()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(window)
    -- function num : 0_10_0 , upvalues : self
    if window ~= nil then
      window:OnWCStressUpgrade(nil, self.__wcsExpAddNum, function()
      -- function num : 0_10_0_0 , upvalues : self
      self.__wcsExpAddNum = nil
      self:__PlayNext()
    end
)
    end
  end
)
end

WarChessSequenceCtrl.SetWCSGetRewardWhenSettle = function(self, seasonSettleData)
  -- function num : 0_11
  self.__seasonSettleData = seasonSettleData
end

WarChessSequenceCtrl.__TryPlayWCSGetRewardWhenSettle = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.__seasonSettleData == nil then
    self:__PlayNext()
    return 
  end
  local rewardDic = {}
  local rewardCount = 0
  local addtionData = (WarChessSeasonManager:GetSeasonAddtionData())
  local scoreTokenId = nil
  if addtionData ~= nil then
    scoreTokenId = addtionData:GetSeasonScoreToken()
  end
  for itemId,addNum in pairs((self.__seasonSettleData).rewardItems) do
    if itemId ~= scoreTokenId then
      rewardDic[itemId] = addNum
      rewardCount = rewardCount + 1
    end
  end
  local itemId, totalNum, addNum = nil, nil, nil
  if rewardCount < 1 then
    self:__PlayNext()
    return 
  end
  if rewardCount > 1 then
    warn("not suppor mult rewards:" .. (serpent.block)(rewardDic))
  end
  for key,value in pairs(rewardDic) do
    itemId = key
    addNum = value
    do break end
  end
  do
    if addNum == 0 then
      self:__PlayNext()
      return 
    end
    local isLimitFull = false
    local addtionData = WarChessSeasonManager:GetSeasonAddtionData()
    do
      if addtionData ~= nil and addtionData:GetSeasonScoreToken() == itemId then
        local count, fullCount = addtionData:GetSeasonScore()
        isLimitFull = fullCount > 0 and fullCount <= count
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(window)
    -- function num : 0_12_0 , upvalues : itemId, totalNum, addNum, isLimitFull, self
    window:WCShowGetReward(itemId, totalNum, addNum, isLimitFull, function()
      -- function num : 0_12_0_0 , upvalues : self
      self.__seasonSettleData = nil
      self:__PlayNext()
    end
, 1.25)
  end
)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

WarChessSequenceCtrl.SetWCSSelectLevel = function(self, nextWarChessLobby, nextRooms)
  -- function num : 0_13
  self.__nextWarChessLobby = nextWarChessLobby
  self.__nextRooms = nextRooms
end

WarChessSequenceCtrl.__TryPlayWCSSelectLevelStage1 = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSeasonSelectLevel, function(win)
    -- function num : 0_14_0 , upvalues : self
    if win == nil then
      self:__PlayNext()
      return 
    end
    win:InitWCSLevelInfo()
    win:WCSPlayAniCompleteCurLevel(function()
      -- function num : 0_14_0_0 , upvalues : self
      self:__PlayNext()
    end
, 1.25)
  end
)
end

WarChessSequenceCtrl.__TryPlayWCSSelectLevelStage2 = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.__nextWarChessLobby then
    WarChessSeasonManager:WarChessSeasonEnterLobby()
  else
    if self.__nextRooms ~= nil and #self.__nextRooms > 0 then
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSeasonSelectLevel, function(win)
    -- function num : 0_15_0 , upvalues : self
    if win == nil then
      self:__PlayNext()
      return 
    end
    win:InitWCSSelectLevel(self.__nextRooms)
    win:WCSPlayAniSelectLevel(true, nil, 1.25)
  end
)
    end
  end
end

WarChessSequenceCtrl.SetCompleteFloorTipCallCoroutine = function(self, callback, one_shoot)
  -- function num : 0_16 , upvalues : _ENV
  self.__tipCoroutine = (coroutine.create)(function(call)
    -- function num : 0_16_0 , upvalues : _ENV, self
    call()
    ;
    (coroutine.yield)()
    self:__PlayNext()
    if self.__floorTipCallbackOneShoot then
      self.__completeFloorTipCallback = nil
      self.__floorTipCallbackOneShoot = false
    end
  end
)
  self.__completeFloorTipCallback = callback
  self.__floorTipCallbackOneShoot = one_shoot
end

WarChessSequenceCtrl.ResumeFloorTipCallCoroutine = function(self)
  -- function num : 0_17 , upvalues : _ENV
  if self.__tipCoroutine then
    (coroutine.resume)(self.__tipCoroutine)
  end
end

WarChessSequenceCtrl.__TryPalyCompleteFloorTip = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.__completeFloorTipCallback and (coroutine.status)(self.__tipCoroutine) == "suspended" then
    (coroutine.resume)(self.__tipCoroutine, self.__completeFloorTipCallback)
  else
    self:__PlayNext()
  end
end

WarChessSequenceCtrl.SetIsHaveNewRewradBagReward = function(self, bool)
  -- function num : 0_19
  self.__isHaveNewRewradBagReward = bool
end

WarChessSequenceCtrl.SetWhereNewRewradBagFrom = function(self, entityData)
  -- function num : 0_20 , upvalues : _ENV
  local logicPos = entityData:GetEntityLogicPos()
  self.__newRewradBagFromWorldPos = (Vector3.New)(logicPos.x, 0, logicPos.y)
end

WarChessSequenceCtrl.__TryPalyGetRewradBagReward = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if self.__isHaveNewRewradBagReward and self.__newRewradBagFromWorldPos ~= nil then
    (UIManager:GetWindow(UIWindowTypeID.WarChessMain))
    local wcMain = nil
    local playNode = nil
    if wcMain ~= nil then
      playNode = wcMain:GetWCPlayNode()
    end
    if playNode ~= nil then
      playNode:StartFlyWCRewardBag(self.__newRewradBagFromWorldPos, function()
    -- function num : 0_21_0 , upvalues : self
    self:__PlayNext()
  end
)
    end
    self.__isHaveNewRewradBagReward = nil
    self.__newRewradBagFromWorldPos = nil
  end
  do
    self:__PlayNext()
  end
end

return WarChessSequenceCtrl

