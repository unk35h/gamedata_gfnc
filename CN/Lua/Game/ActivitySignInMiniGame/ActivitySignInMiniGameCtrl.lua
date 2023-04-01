-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ControllerBase
local ActivitySignInMiniGameCtrl = class("ActivitySignInMiniGameCtrl", base)
local ActivitySignInMiniGameData = require("Game.ActivitySignInMiniGame.Data.ActivitySignInMiniGameData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActivityFrameOpenFunc = require("Game.ActivityFrame.ActivityFrameOpenFunc")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
ActivitySignInMiniGameCtrl.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.sign_minigame_award)
  ConfigData:LoadDynCfg(eDynConfigData.sign_minigame_emoji)
  ConfigData:LoadDynCfg(eDynConfigData.sign_minigame_range)
  ConfigData:LoadDynCfg(eDynConfigData.sign_minigame_sign)
  ConfigData:LoadDynCfg(eDynConfigData.sign_minigame_text)
end

ActivitySignInMiniGameCtrl.InitCtrl = function(self, activityFrameData)
  -- function num : 0_1 , upvalues : _ENV, ActivitySignInMiniGameData
  if self._actSignInMiniGameData ~= nil then
    error("Cant support more limit signInMiniGame activity")
    return 
  end
  self._actSignInMiniGameData = (ActivitySignInMiniGameData.New)()
  ;
  (self._actSignInMiniGameData):InitActivityFrameData(activityFrameData)
  self.networkCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivitySignInMiniGame)
  self._isOpen = true
end

ActivitySignInMiniGameCtrl.InitNetWrorkData = function(self, msgData)
  -- function num : 0_2 , upvalues : _ENV
  if self._isOpen ~= true then
    return 
  end
  if msgData == nil then
    error("CS_ACTIVITY_SingleConcreteInfo 返回数据字段activityAnnivSign为空")
    return 
  end
  if msgData ~= nil then
    self._isOpen = true
  else
    self._isOpen = false
    return 
  end
  ;
  (self._actSignInMiniGameData):InitNetWrorkData(msgData)
  self:UpdActSignInMiniGameRedDot()
end

ActivitySignInMiniGameCtrl.GetCurData = function(self)
  -- function num : 0_3
  return self._actSignInMiniGameData
end

ActivitySignInMiniGameCtrl.IsOpen = function(self)
  -- function num : 0_4
  do return self._isOpen == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivitySignInMiniGameCtrl.SetLoginIsFirstOpen = function(self)
  -- function num : 0_5
  self._isFirstOpen = true
end

ActivitySignInMiniGameCtrl.GetLoginIsFirstOpen = function(self)
  -- function num : 0_6
  return self._isFirstOpen
end

ActivitySignInMiniGameCtrl.GetActId = function(self)
  -- function num : 0_7
  return (self._actSignInMiniGameData):GetActID()
end

ActivitySignInMiniGameCtrl.IsCanSignToDay = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local nextTime = (self._actSignInMiniGameData):GetNextSignTime()
  if nextTime == nil then
    return false
  end
  if nextTime == 0 then
    return true
  else
    if self:GetTotalSignDay() <= self:GetHasSignDayCount() then
      return false
    end
    return nextTime <= PlayerDataCenter.timestamp
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

ActivitySignInMiniGameCtrl.GetTotalSignDay = function(self, actId)
  -- function num : 0_9 , upvalues : _ENV
  if actId == nil then
    actId = self:GetActId()
  end
  local cfg = (ConfigData.sign_minigame_sign)[actId]
  if cfg == nil then
    return 0
  end
  return cfg.total_sign_times
end

ActivitySignInMiniGameCtrl.GetHasSignDayCount = function(self)
  -- function num : 0_10
  return (self._actSignInMiniGameData):GetHasSignDayCount()
end

ActivitySignInMiniGameCtrl.GetLeftDayWithOpenTime = function(self, timeStamp)
  -- function num : 0_11 , upvalues : _ENV
  local openTime = (self._actSignInMiniGameData):GetActOpenTime()
  if openTime ~= nil then
    local leftTime = timeStamp - openTime
    local leftDay = TimeUtil:TimestampToTimeInter((math.floor)(leftTime), false, true)
    return leftDay
  end
  do
    return nil
  end
end

ActivitySignInMiniGameCtrl.GetLeftDayWithCurTime = function(self, timeStamp)
  -- function num : 0_12 , upvalues : _ENV
  local leftDay1 = self:GetLeftDayWithOpenTime(PlayerDataCenter.timestamp)
  local leftDay2 = self:GetLeftDayWithOpenTime(timeStamp)
  return leftDay1 - leftDay2
end

ActivitySignInMiniGameCtrl.GetAllSignInDay = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local allSignDay = {}
  local sings = (self._actSignInMiniGameData):GetActSign()
  if sings ~= nil then
    for k,v in pairs(sings) do
      local leftDay = self:GetLeftDayWithOpenTime(v.signTime)
      allSignDay[leftDay] = true
    end
  end
  do
    return allSignDay
  end
end

ActivitySignInMiniGameCtrl.GetNewSignInDay = function(self)
  -- function num : 0_14
  local sings = (self._actSignInMiniGameData):GetActSign()
  do
    if sings ~= nil then
      local count = #sings
      return count, sings[count]
    end
    return nil, nil
  end
end

ActivitySignInMiniGameCtrl.GetAllSignData = function(self)
  -- function num : 0_15
  return (self._actSignInMiniGameData):GetActSign()
end

ActivitySignInMiniGameCtrl.GetIsPlayedCartoon = function(self)
  -- function num : 0_16
  return (self._actSignInMiniGameData):GetActivityIscartoonPlayed()
end

ActivitySignInMiniGameCtrl.GetSignDataRange = function(self, signDataIndex)
  -- function num : 0_17 , upvalues : _ENV
  local actID = self:GetActId()
  local awardGroup = (self._actSignInMiniGameData):GetActAwardGroup()
  if awardGroup ~= nil and (ConfigData.sign_minigame_award)[actID] ~= nil and ((ConfigData.sign_minigame_award)[actID])[awardGroup] ~= nil and (((ConfigData.sign_minigame_award)[actID])[awardGroup])[signDataIndex] ~= nil then
    return ((((ConfigData.sign_minigame_award)[actID])[awardGroup])[signDataIndex]).range
  end
  return nil
end

ActivitySignInMiniGameCtrl.UpdActSignInMiniGameRedDot = function(self)
  -- function num : 0_18
  local reddotNode = (self._actSignInMiniGameData):GetActivityReddotNode()
  if reddotNode == nil then
    return 
  end
  local showReddot = self:IsCanSignToDay()
  reddotNode:SetRedDotCount(showReddot and 1 or 0)
end

ActivitySignInMiniGameCtrl.CS_ACTIVITY_SignMiniGame_Sign = function(self, emojiId, callback)
  -- function num : 0_19
  (self.networkCtrl):CS_ACTIVITY_SignMiniGame_Sign(self:GetActId(), emojiId, function(args)
    -- function num : 0_19_0 , upvalues : self, callback
    do
      if args ~= nil and args.Count > 0 then
        local msgData = args[0]
        self:InitNetWrorkData(msgData.data)
        self.cacheAward = msgData.award
      end
      if callback ~= nil then
        callback()
      end
    end
  end
)
end

ActivitySignInMiniGameCtrl.CS_ACTIVITY_SignMiniGame_PlayCartoon = function(self)
  -- function num : 0_20
  (self.networkCtrl):CS_ACTIVITY_SignMiniGame_PlayCartoon(self:GetActId(), function(args)
    -- function num : 0_20_0 , upvalues : self
    if args ~= nil and args.Count > 0 then
      self:SetActivityIscartoonPlayed()
    end
  end
)
end

ActivitySignInMiniGameCtrl.ShowAward = function(self)
  -- function num : 0_21 , upvalues : _ENV, CommonRewardData
  local rewardDic = self.cacheAward
  local rewardIdList = {}
  local rewardNumList = {}
  for k,v in pairs(rewardDic) do
    (table.insert)(rewardIdList, k)
    ;
    (table.insert)(rewardNumList, v)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_21_0 , upvalues : CommonRewardData, rewardIdList, rewardNumList
    if window ~= nil then
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIdList, rewardNumList)
      window:AddAndTryShowReward(CRData)
    end
  end
)
end

ActivitySignInMiniGameCtrl.CloseActLimitTaskCtrl = function(self, activityFrameData)
  -- function num : 0_22 , upvalues : _ENV
  if UIManager:GetWindow(UIWindowTypeID.SignInMiniGame) ~= nil then
    (UIUtil.ReturnHome)()
  end
  self:Delete()
end

ActivitySignInMiniGameCtrl.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.sign_minigame_award)
  ConfigData:ReleaseDynCfg(eDynConfigData.sign_minigame_emoji)
  ConfigData:ReleaseDynCfg(eDynConfigData.sign_minigame_range)
  ConfigData:ReleaseDynCfg(eDynConfigData.sign_minigame_sign)
  ConfigData:ReleaseDynCfg(eDynConfigData.sign_minigame_text)
end

return ActivitySignInMiniGameCtrl

