-- params : ...
-- function num : 0 , upvalues : _ENV
local LotteryPoolData = class("LotteryPoolData")
local LotteryEnum = require("Game.Lottery.LotteryEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
LotteryPoolData.ctor = function(self, poolId)
  -- function num : 0_0 , upvalues : _ENV
  self.poolId = poolId
  local ltrCfg = (ConfigData.lottery_para)[poolId]
  if ltrCfg == nil then
    error("Cant get lottery_para, poolId = " .. tostring(poolId))
    return 
  end
  self.ltrCfg = ltrCfg
end

_IsCountValid = function(count)
  -- function num : 0_1 , upvalues : _ENV
  do return count ~= nil and PlayerDataCenter.timestamp < count.tm end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolData.UpdLtrPoolData = function(self, LotteryStatistic)
  -- function num : 0_2
  self.total = LotteryStatistic.total
  self.pt = LotteryStatistic.pt
  self.dayNumTab = LotteryStatistic.dayNum
  self.specialDiscountPick = LotteryStatistic.specialDiscountPick
  self.singleFreePick = LotteryStatistic.singleFreePick
  self.pickBig = LotteryStatistic.pickBig
  self._noUpNum = LotteryStatistic.norUp
end

LotteryPoolData.IsLtrPoolOpen = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityFrameEnum
  local activityFrame = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actInfo = activityFrame:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Lotter, (self.ltrCfg).lottery_id)
  local open = (actInfo ~= nil and actInfo:GetCouldShowActivity())
  local limitNum = (self.ltrCfg).count_limit
  local countLimit = limitNum ~= 0 and limitNum <= self:GetLtrPoolTotalNum()
  if open then
    open = not countLimit
  end
  do return open end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

LotteryPoolData.IsLtrExecTypeOpen = function(self, execType)
  -- function num : 0_4
  return ((self.ltrCfg).drawTypeDic)[execType]
end

LotteryPoolData.IsGuaranteeOpen = function(self)
  -- function num : 0_5
  if (self.ltrCfg).guaranteeType ~= nil and (self.ltrCfg).guaranteeType ~= 0 then
    return true
  else
    return false
  end
end

LotteryPoolData.IsHeroInfoBtnOpen = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for k,v in pairs((self.ltrCfg).heroUpAllDic) do
    do return {true, k} end
  end
  return {false, 0}
end

LotteryPoolData.GetLtrPoolTotalNum = function(self)
  -- function num : 0_7
  return self.total or 0
end

LotteryPoolData.GetLtrPoolDayNum = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if not _IsCountValid(self.dayNumTab) then
    return 0
  end
  return (self.dayNumTab).times
end

LotteryPoolData.GetLtrPoolDayNumUpdateTimestamp = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if not _IsCountValid(self.dayNumTab) then
    return 0
  end
  return (self.dayNumTab).tm
end

LotteryPoolData.GetLtrPoolRemainNum = function(self)
  -- function num : 0_10
  local limitNum = (self.ltrCfg).count_limit
  if limitNum == 0 then
    return 0
  else
    return limitNum - self:GetLtrPoolTotalNum()
  end
end

LotteryPoolData.GetLtrPoolLimitNum = function(self)
  -- function num : 0_11
  return (self.ltrCfg).count_limit
end

LotteryPoolData.IsLtrExecOneceFree = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if (self.ltrCfg).cd == 0 then
    return 
  end
  if self.singleFreePick == nil or (self.singleFreePick).times == 0 or (self.singleFreePick).tm < PlayerDataCenter.timestamp then
    return true
  end
end

LotteryPoolData.IsLtrExecSpecialOneceTimeOk = function(self)
  -- function num : 0_13 , upvalues : LotteryEnum, _ENV
  if not self:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).SpecialOnce) then
    return 
  end
  if self.specialDiscountPick == nil or (self.specialDiscountPick).times == 0 or (self.specialDiscountPick).tm < PlayerDataCenter.timestamp then
    return true
  end
end

LotteryPoolData.GetLtrExecSpecialOneceRemainingTs = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self.specialDiscountPick == nil then
    return -1
  end
  local remainingTs = (self.specialDiscountPick).tm - PlayerDataCenter.timestamp
  return remainingTs
end

LotteryPoolData.GetStartAndEndTime = function(self)
  -- function num : 0_15 , upvalues : _ENV, ActivityFrameEnum
  local activityFrame = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actUid = activityFrame:GetIdByActTypeAndActId((ActivityFrameEnum.eActivityType).Lotter, (self.ltrCfg).lottery_id)
  local actInfo = activityFrame:GetActivityFrameData(actUid)
  if actInfo == nil then
    return -1, -1
  else
    return actInfo.startTime, actInfo.endTime
  end
end

LotteryPoolData.IsLtrPoolLimitTime = function(self)
  -- function num : 0_16
  local _, endTime = self:GetStartAndEndTime()
  do return endTime ~= -1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolData.HasLtrPt = function(self)
  -- function num : 0_17
  return (self.ltrCfg).is_pt
end

LotteryPoolData.GetLtrPtNum = function(self)
  -- function num : 0_18
  if not self:HasLtrPt() then
    return 0
  end
  return self.pt or 0
end

LotteryPoolData.GetLotteryDataNavTag = function(self)
  -- function num : 0_19
  return (self.ltrCfg).nav_tag
end

LotteryPoolData.GetLtrPoolDataCfg = function(self)
  -- function num : 0_20
  return self.ltrCfg
end

LotteryPoolData.GetTagNameAndIconIndex = function(self)
  -- function num : 0_21 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.ltrCfg).nav_tagName), (self.ltrCfg).nav_tagIcon
end

LotteryPoolData.GetLtrFreeChoiceHeroIdList = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local ltrSelectionCfg = (ConfigData.lottery_selection)[self.poolId]
  if ltrSelectionCfg == nil then
    error("Cant get lottery_selection, poolId = " .. tostring(self.poolId))
    return table.emptytable
  end
  local heroId2ItemIdMapDic = {}
  local heroIdList = {}
  for k,itemId in ipairs(ltrSelectionCfg.item_rewardIds) do
    local itemCfg = (ConfigData.item)[itemId]
    if itemCfg.action_type == eItemActionType.HeroCard then
      local heroId = (itemCfg.arg)[1]
      ;
      (table.insert)(heroIdList, heroId)
      heroId2ItemIdMapDic[heroId] = itemId
    else
      do
        do
          error("item is not hero, item id = " .. tostring(itemId))
          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return heroIdList, heroId2ItemIdMapDic
end

LotteryPoolData.IsLtrFreeChoicePrompt = function(self)
  -- function num : 0_23
  return (self.ltrCfg).is_prompt
end

LotteryPoolData.TryGetLtrCustomDrawNum = function(self)
  -- function num : 0_24 , upvalues : LotteryEnum, _ENV
  if not self:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).CustomNum) then
    return false
  end
  local itemCount = PlayerDataCenter:GetItemCount((self.ltrCfg).costId1)
  local drawNum = itemCount // (self.ltrCfg).costNum1
  return true, drawNum
end

LotteryPoolData.IsLtrSpecialUp = function(self)
  -- function num : 0_25
  do return (self.ltrCfg).special_up > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolData.GetLtrNoUpNum = function(self)
  -- function num : 0_26
  return self._noUpNum or 0
end

LotteryPoolData.GetLtrSpecialUpNum = function(self)
  -- function num : 0_27
  return (self.ltrCfg).special_up
end

LotteryPoolData.ShowLtrUpIntro = function(self)
  -- function num : 0_28
  return false
end

LotteryPoolData.IsLtrHeroConvertFrag = function(self)
  -- function num : 0_29
  do return (self.ltrCfg).repeat_type == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolData.GetLtrUpHeroFragDic = function(self)
  -- function num : 0_30 , upvalues : _ENV
  do
    if self:IsLtrHeroConvertFrag() then
      local upHeroFragDic = {}
      for heroId,_ in pairs((self.ltrCfg).heroUpAllDic) do
        upHeroFragDic[heroId] = (self.ltrCfg).big_prize_extra_num
      end
      return upHeroFragDic
    end
    return nil
  end
end

LotteryPoolData.IsShowLtrNewRuleReddot = function(self)
  -- function num : 0_31 , upvalues : _ENV
  if (self.ltrCfg).new_rule_reddot == 0 then
    return false
  end
  local isRead = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):IsReadLtrNewRuleReddot((self.ltrCfg).new_rule_reddot)
  return not isRead
end

LotteryPoolData.IsLtrHasTenPrior = function(self)
  -- function num : 0_32
  do return (self.ltrCfg).costIdTenPrior ~= nil and (self.ltrCfg).costIdTenPrior ~= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

LotteryPoolData.LtrCurTenIsPrior = function(self)
  -- function num : 0_33 , upvalues : _ENV
  do return not self:IsLtrHasTenPrior() or (self.ltrCfg).costNumTenPrior <= PlayerDataCenter:GetItemCount((self.ltrCfg).costIdTenPrior) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

LotteryPoolData.TryGetLtrIntoAvgNotPlayed = function(self)
  -- function num : 0_34 , upvalues : _ENV
  local avgId = (self.ltrCfg).intro_avg
  if avgId ~= 0 and not (ControllerManager:GetController(ControllerTypeId.AvgPlay, true)):IsAvgPlayed(avgId) then
    return avgId
  end
  return nil
end

LotteryPoolData.GetBuyableGiftIdList = function(self)
  -- function num : 0_35 , upvalues : _ENV
  if #(self.ltrCfg).gift_id == 0 then
    return false
  end
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  for k,giftId in ipairs((self.ltrCfg).gift_id) do
    local giftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    if giftInfo and giftInfo:IsUnlock() and not giftInfo:IsSoldOut() then
      return true, (self.ltrCfg).gift_id
    end
  end
  return false
end

return LotteryPoolData

