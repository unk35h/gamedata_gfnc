-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local BattlePassData = class("BattlePassData", ActivityBase)
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
BattlePassData.ctor = function(self, cfg)
  -- function num : 0_0
  self.passCfg = cfg
  self.id = cfg.id
end

BattlePassData.CreateBattlePass = function(battlepass, cfg)
  -- function num : 0_1 , upvalues : BattlePassData, ActivityFrameEnum, _ENV
  local passData = (BattlePassData.New)(cfg)
  passData:SetActFrameDataByType((ActivityFrameEnum.eActivityType).BattlePass, passData.id)
  local activityFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  passData.__activityData = activityFrameCtr:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).BattlePass, passData.id)
  passData:__UpdateBattlePass(battlepass)
  passData:UpdateActFrameDataSingleMsg(battlepass)
  return passData
end

BattlePassData.__UpdateBattlePass = function(self, battlepass)
  -- function num : 0_2 , upvalues : BattlePassEnum, _ENV, ActivityFrameEnum
  if (self.passCfg).condition ~= (BattlePassEnum.ConditionType).AchievementLevel or not (PlayerDataCenter.playerLevel).level then
    self.level = battlepass.lv + battlepass.extraLevel
    self.exp = battlepass.exp
    self.unlockSenior = battlepass.unlockSenior
    self.taken = battlepass.taken
    self.extraPickLevel = battlepass.extraPickLevel
    self.weeklyExp = battlepass.weeklyExp
    self.unlockUltimate = battlepass.unlockUltimate
    self.weeklyNextExpiredTm = battlepass.weeklyNextExpiredTm
    self.maxlevel = ((ConfigData.battlepass).max_level)[self.id]
    self:__UpdateHaveRewardTake()
    if (self.passCfg).condition == (BattlePassEnum.ConditionType).AchievementLevel and self.maxlevel <= self.level and self.unlockSenior and not self.__haveRewardTake then
      local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
      activityCtrl:HideActivityByExtraLogic((ActivityFrameEnum.eActivityType).BattlePass, self.id)
    end
  end
end

BattlePassData.UpdateBattlePass = function(self, battlepass)
  -- function num : 0_3
  self:__UpdateBattlePass(battlepass)
end

BattlePassData.GetBattlePassEndTime = function(self)
  -- function num : 0_4
  if self.__activityData == nil then
    return -1
  end
  return (self.__activityData).endTime
end

BattlePassData.IsBattlePassValid = function(self)
  -- function num : 0_5
  if self.__activityData == nil then
    return false
  end
  return (self.__activityData):IsActivityOpen()
end

BattlePassData.GetBattlePassActivityId = function(self)
  -- function num : 0_6
  if self.__activityData == nil then
    return 0
  end
  return (self.__activityData).id
end

BattlePassData.GetBattlepassReddot = function(self)
  -- function num : 0_7
  if self.__activityData == nil then
    return nil
  end
  return (self.__activityData):GetActivityReddotNode()
end

BattlePassData.IsBattleType = function(self)
  -- function num : 0_8 , upvalues : BattlePassEnum
  do return (self.passCfg).condition == (BattlePassEnum.ConditionType).BattlePassLevel end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattlePassData.IsBattlepassStanding = function(self)
  -- function num : 0_9
  do return (self.passCfg).purpose_type == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattlePassData.IsPassFullLevel = function(self)
  -- function num : 0_10
  do return self.maxlevel <= self.level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattlePassData.HasBpOverLimitReward = function(self)
  -- function num : 0_11
  do return (self.passCfg).limit_reward_id > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattlePassData.GetWeeklyExpLimit = function(self)
  -- function num : 0_12
  return (self.passCfg).weekly_exp
end

BattlePassData.GetPassCfg = function(self)
  -- function num : 0_13
  return self.passCfg
end

BattlePassData.GetBattlePassMaxLevel = function(self)
  -- function num : 0_14
  return self.maxlevel
end

BattlePassData.GetPassLevel = function(self)
  -- function num : 0_15
  return self.level
end

BattlePassData.GetBattlePassUnlockSenior = function(self)
  -- function num : 0_16
  return self.unlockSenior
end

BattlePassData.GetBPSkinShopId = function(self)
  -- function num : 0_17
  return (self.passCfg).skin_coin_shop
end

BattlePassData.GetBPSkinCoinId = function(self)
  -- function num : 0_18
  return (self.passCfg).skin_coin_id
end

BattlePassData.GetBpBannerSkinId = function(self)
  -- function num : 0_19
  return (self.passCfg).banner_skin
end

BattlePassData.GetBpSkinCoinGift = function(self)
  -- function num : 0_20
  return (self.passCfg).skin_coin_pay
end

BattlePassData.GetBattlePassTotalExp = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local totalExp = 0
  local passCfg = (ConfigData.battlepass)[self.id]
  for i = 1, self.level - 1 do
    local passLevelCfg = passCfg[i]
    if passLevelCfg ~= nil then
      totalExp = totalExp + passLevelCfg.exp
    end
  end
  return self.exp + (totalExp)
end

BattlePassData.GetPassCurLevelExp = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local level = (math.min)(self.level, self.maxlevel)
  local passLevelCfg = ((ConfigData.battlepass)[self.id])[level]
  if passLevelCfg == nil then
    error("battle pass cfg is null,id:" .. tostring(self.id) .. " level:" .. tostring(self.level))
    return 0
  end
  return passLevelCfg.exp
end

BattlePassData.TryGetExpUpgradeLevel = function(self, exp, enableOverlimit)
  -- function num : 0_23 , upvalues : _ENV
  if not enableOverlimit then
    enableOverlimit = false
  end
  local tmp_exp = exp
  local curExp = self.exp
  local levelup = 0
  local tmpLevel = self.level
  while 1 do
    if tmp_exp > 0 then
      local levelexp = 0
      if self.maxlevel <= tmpLevel and enableOverlimit then
        levelexp = (((ConfigData.battlepass)[self.id])[self.maxlevel]).exp
        levelexp = (((ConfigData.battlepass)[self.id])[tmpLevel]).exp
        do
          local needExp = levelexp - curExp
          if tmp_exp < needExp then
            curExp = curExp + tmp_exp
            break
          end
          curExp = 0
          levelup = levelup + 1
          tmpLevel = tmpLevel + 1
          tmp_exp = tmp_exp - needExp
          -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return levelup, curExp
end

BattlePassData.GetPassLevelReward = function(self, startlevel, endlevel, containBase, containSenior)
  -- function num : 0_24 , upvalues : _ENV
  local rewardDic = {}
  for level = startlevel, endlevel do
    if self.maxlevel >= level or not containBase then
      local passLevelCfg = ((ConfigData.battlepass)[self.id])[level]
      if passLevelCfg ~= nil then
        if containBase then
          for index,itemId in pairs(passLevelCfg.base_item_ids) do
            local count = (passLevelCfg.base_item_nums)[index]
            rewardDic[itemId] = (rewardDic[itemId] or 0) + count
          end
        end
        do
          if containSenior then
            for index,itemId in pairs(passLevelCfg.senior_item_ids) do
              local count = (passLevelCfg.senior_item_nums)[index]
              rewardDic[itemId] = (rewardDic[itemId] or 0) + count
            end
          end
          do
            -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local item_ids = {}
  local item_nums = {}
  for itemId,_ in pairs(rewardDic) do
    (table.insert)(item_ids, itemId)
  end
  ;
  (table.sort)(item_ids)
  for _,itemId in pairs(item_ids) do
    local itemCount = rewardDic[itemId]
    ;
    (table.insert)(item_nums, itemCount)
  end
  return item_ids, item_nums
end

BattlePassData.GetNoTakenLimitRewardCount = function(self)
  -- function num : 0_25 , upvalues : BattlePassEnum
  if (self.passCfg).condition == (BattlePassEnum.ConditionType).AchievementLevel then
    return 0
  end
  local count = 0
  if self.maxlevel < self.level then
    count = self.level - self.maxlevel - self.extraPickLevel
  end
  return count
end

BattlePassData.GetPassDefaultShowLevel = function(self)
  -- function num : 0_26
  if self:IsPassFullLevel() then
    return self.maxlevel
  end
  for level = 1, self.level - 1 do
    local reward = (self.taken)[level]
    if reward == nil or not reward.base then
      return level
    end
    if self.unlockSenior and not reward.senior then
      return level
    end
  end
  return self.level
end

BattlePassData.__UpdateHaveRewardTake = function(self)
  -- function num : 0_27 , upvalues : _ENV
  local havaReward = false
  if self:GetNoTakenLimitRewardCount() <= 0 then
    havaReward = not self:IsBattlePassValid()
    local passLevelsCfg = (ConfigData.battlepass)[self.id]
    local maxLevel = (math.min)(self.level, self.maxlevel)
    if not havaReward then
      for level = 1, maxLevel do
        local passLevelCfg = passLevelsCfg[level]
        if passLevelCfg ~= nil then
          local reward = (self.taken)[level]
          if (reward == nil or not reward.base) and #passLevelCfg.base_item_ids > 0 then
            havaReward = true
            break
          end
          if self.unlockSenior and (reward == nil or not reward.senior) and #passLevelCfg.senior_item_ids > 0 then
            havaReward = true
            break
          end
        end
      end
    end
    self.__haveRewardTake = havaReward
    local reddot = self:GetBattlepassReddot()
    if not havaReward or not 1 then
      reddot:SetRedDotCount(reddot == nil or 0)
      -- DECOMPILER ERROR: 9 unprocessed JMP targets
    end
  end
end

BattlePassData.PassHaveRewardTake = function(self)
  -- function num : 0_28
  return self.__haveRewardTake
end

BattlePassData.GetIsThisLeveHaveNewReward = function(self, level)
  -- function num : 0_29 , upvalues : _ENV
  local passLevelCfg = (ConfigData.battlepass)[self.id]
  do
    if passLevelCfg[level] ~= nil then
      local reward = (self.taken)[level]
      if reward == nil then
        return true
      end
      if not reward.base or level <= self.maxlevel and self.unlockSenior and not reward.senior then
        return true
      end
    end
    return false
  end
end

return BattlePassData

