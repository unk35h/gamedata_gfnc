-- params : ...
-- function num : 0 , upvalues : _ENV
local DailySignInData = class("DailySignInData")
local MONTH_CARD_ID = 1
DailySignInData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV, MONTH_CARD_ID
  self.__isHaveMonthCard = false
  self.__monthCardLeftCount = 0
  self.__monthCardCfg = (ConfigData.month_card)[MONTH_CARD_ID]
  self.expireAt = 0
  self._dailyBonusIdIdx = 1
end

DailySignInData.UpdDailySignInBonusId = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local dailyBonusId = nil
  for i = self._dailyBonusIdIdx, #(ConfigData.daily_bonus_time).startTimeIdList do
    local id = ((ConfigData.daily_bonus_time).startTimeIdList)[i]
    local cfg = (ConfigData.daily_bonus_time)[id]
    local startOk = cfg.start_time == -1 or cfg.start_time <= PlayerDataCenter.timestamp
    local endOk = cfg.end_time == -1 or PlayerDataCenter.timestamp <= cfg.end_time
    if startOk and endOk then
      dailyBonusId = id
      self._dailyBonusIdIdx = i
      break
    end
  end
  if dailyBonusId == nil then
    error("Cant get dailyBonusId")
    return 
  end
  self._dailyBonusId = dailyBonusId
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

DailySignInData.UpadteMonthCardData = function(self, diffMsgDic)
  -- function num : 0_2 , upvalues : _ENV, MONTH_CARD_ID
  if diffMsgDic == nil then
    self.__isHaveMonthCard = false
    self.__monthCardLeftCount = 0
    self.expireAt = 0
    return 
  end
  local firstCardMsg = nil
  for key,value in pairs(diffMsgDic) do
    firstCardMsg = value
    do break end
  end
  do
    if firstCardMsg == nil then
      self.__isHaveMonthCard = false
      self.__monthCardLeftCount = 0
      self.expireAt = 0
      return 
    end
    if firstCardMsg.id ~= MONTH_CARD_ID then
      error("MONTH_CARD_ID: server-" .. tostring(firstCardMsg.id) .. " client-" .. tostring(MONTH_CARD_ID))
    end
    self.expireAt = firstCardMsg.expireAt
    self.discountDuration = firstCardMsg.discountDuration
    local isCardDiscount = self:IsCardDiscount()
    local lastTime = self.expireAt - PlayerDataCenter.timestamp
    local leftDayNum = (math.ceil)(lastTime / 86400)
    if leftDayNum > 0 then
      self.__isHaveMonthCard = true
      self.__monthCardLeftCount = leftDayNum
    end
    ;
    (ControllerManager:GetController(ControllerTypeId.Shop, true)):AddMonthCardRedDot(isCardDiscount)
    MsgCenter:Broadcast(eMsgEventId.MonthCardRefresh)
  end
end

DailySignInData.IsCardDiscount = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.discountDuration == nil then
    return false
  end
  do return PlayerDataCenter.timestamp < self.discountDuration, self.discountDuration end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DailySignInData.IsHaveCard = function(self)
  -- function num : 0_4 , upvalues : _ENV
  do return (PlayerDataCenter.timestamp < self.expireAt and self.__isHaveMonthCard) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

DailySignInData.SingInNum = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local counterElem = (ControllerManager:GetController(ControllerTypeId.TimePass)):getCounterElemData(proto_object_CounterModule.CounterModuleMonthDailyBounsTimes, 0)
  if counterElem == nil then
    error("can\'t get counterElem for daily signIn return 1 as default")
    return 1
  end
  return counterElem.times
end

DailySignInData.GetMonthCardLeftCount = function(self)
  -- function num : 0_6 , upvalues : _ENV
  return PlayerDataCenter.timestamp < self.expireAt and self.__monthCardLeftCount or 0
end

DailySignInData.IsLimitMonthCardBuy = function(self)
  -- function num : 0_7
  if (self.__monthCardCfg).max_days < self.__monthCardLeftCount + (self.__monthCardCfg).duration_days then
    return true
  end
  return false
end

DailySignInData.GetRewardByDayNum = function(self, dayNum)
  -- function num : 0_8 , upvalues : _ENV
  local itemDic = {}
  local bonusCfg = ((ConfigData.daily_bonus)[self._dailyBonusId])[dayNum]
  for index,id in ipairs(bonusCfg.award_ids) do
    if itemDic[id] == nil then
      itemDic[id] = (bonusCfg.award_nums)[index]
    else
      itemDic[id] = itemDic[id] + (bonusCfg.award_nums)[index]
    end
  end
  for index,id in ipairs((self.__monthCardCfg).daily_award_ids) do
    if itemDic[id] == nil then
      itemDic[id] = ((self.__monthCardCfg).daily_award_nums)[index]
    else
      itemDic[id] = itemDic[id] + ((self.__monthCardCfg).daily_award_nums)[index]
    end
  end
  return itemDic
end

DailySignInData.GetSingInRewardByDayNum = function(self, dayNum)
  -- function num : 0_9 , upvalues : _ENV
  local bonusCfg = ((ConfigData.daily_bonus)[self._dailyBonusId])[dayNum]
  if bonusCfg == nil then
    return nil, nil
  end
  return bonusCfg.award_ids, bonusCfg.award_nums
end

DailySignInData.GetMonthCardRewardBm = function(self)
  -- function num : 0_10
  return (self.__monthCardCfg).daily_award_ids, (self.__monthCardCfg).daily_award_nums
end

return DailySignInData

