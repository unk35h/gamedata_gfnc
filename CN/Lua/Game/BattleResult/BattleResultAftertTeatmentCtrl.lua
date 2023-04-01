-- params : ...
-- function num : 0 , upvalues : _ENV
local BattleResultAftertTeatmentCtrl = class("BattleResultAftertTeatmentCtrl", ControllerBase)
local base = ControllerBase
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
BattleResultAftertTeatmentCtrl.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__TryShowExtraReward = BindCallback(self, self._TryShowExtraReward)
  self.__TryShowDungeonAutoFightReward = BindCallback(self, self._TryShowDungeonAutoFightReward)
  self.__TryShowStOCareerRewar = BindCallback(self, self._TryShowStOCareerRewar)
  self.__TryShowInfinityJumpLevelReward = BindCallback(self, self._TryShowInfinityJumpLevelReward)
  self.__TryShowChallengeModeReward = BindCallback(self, self._TryShowChallengeModeReward)
  self.__TryShowNewHeroReward = BindCallback(self, self._TryShowNewHeroReward)
  self.processTable = {self.__TryShowNewHeroReward, self.__TryShowDungeonAutoFightReward, self.__TryShowInfinityJumpLevelReward, self.__TryShowExtraReward, self.__TryShowStOCareerRewar, self.__TryShowChallengeModeReward}
  self.__isStartReward = false
  self.__afterActions = {}
  self.___NextContinue = BindCallback(self, self._NextContinue)
end

BattleResultAftertTeatmentCtrl.AddShowReward = function(self, rewardDic)
  -- function num : 0_1 , upvalues : _ENV
  if rewardDic == nil or (table.count)(rewardDic) == 0 then
    return 
  end
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_FirstEnterHome) then
    return 
  end
  if not self.extraShowRwardDic then
    self.extraShowRwardDic = {}
    for id,count in pairs(rewardDic) do
      local oriCount = (self.extraShowRwardDic)[id] or 0
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.extraShowRwardDic)[id] = oriCount + count
    end
  end
end

BattleResultAftertTeatmentCtrl.AddNewHeroReward = function(self, newHeroIdDic)
  -- function num : 0_2 , upvalues : _ENV
  if not self.newHeroIdList then
    self.newHeroIdList = {}
    for heroId,_ in pairs(newHeroIdDic) do
      (table.insert)(self.newHeroIdList, heroId)
    end
  end
end

BattleResultAftertTeatmentCtrl.AddShowStOCareerReward = function(self, StOCareerRewardDic)
  -- function num : 0_3 , upvalues : _ENV
  if StOCareerRewardDic == nil or (table.count)(StOCareerRewardDic) == 0 then
    return 
  end
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SectorBuilding1) then
    return 
  end
  if not self.StOCareerRewardDic then
    self.StOCareerRewardDic = {}
    for id,count in pairs(StOCareerRewardDic) do
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.StOCareerRewardDic)[id] = ((self.StOCareerRewardDic)[id] or 0) + count
    end
  end
end

BattleResultAftertTeatmentCtrl.AddDungeonAutoFightReward = function(self, dInterfaceData, rewardDic, athRewardDic, battleCount)
  -- function num : 0_4 , upvalues : _ENV
  if not self.dungeonAutoFightTable then
    self.dungeonAutoFightTable = {dInterfaceData = dInterfaceData, count = battleCount, 
reward = {}
, 
ath = {}
}
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.dungeonAutoFightTable).count = battleCount
    if rewardDic ~= nil and (table.count)(rewardDic) > 0 then
      for id,count in pairs(rewardDic) do
        local oriCount = ((self.dungeonAutoFightTable).reward)[id] or 0
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((self.dungeonAutoFightTable).reward)[id] = oriCount + count
      end
    end
    do
      if athRewardDic ~= nil and (table.count)(athRewardDic) then
        for _,uid in pairs(athRewardDic) do
          -- DECOMPILER ERROR at PC51: Confused about usage of register: R10 in 'UnsetPending'

          ((self.dungeonAutoFightTable).ath)[uid] = uid
        end
      end
    end
  end
end

BattleResultAftertTeatmentCtrl.IsStartShowReward = function(self)
  -- function num : 0_5
  return self.__isStartReward
end

BattleResultAftertTeatmentCtrl.BindResultAfterAction = function(self, action)
  -- function num : 0_6 , upvalues : _ENV
  if action == nil or self.__afterActions == nil then
    return 
  end
  ;
  (table.insert)(self.__afterActions, action)
end

BattleResultAftertTeatmentCtrl.TeatmentBengin = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.__isStartReward then
    return 
  end
  self.__isStartReward = true
  if GuideManager.inGuide then
    self.__waitGuideTimer = TimerManager:StartTimer(1, function()
    -- function num : 0_7_0 , upvalues : self, _ENV
    if not self.__isStartReward then
      TimerManager:StopTimer(self.__waitGuideTimer)
      return 
    end
    if not GuideManager.inGuide then
      TimerManager:StopTimer(self.__waitGuideTimer)
      self:_NextContinue(true)
    end
  end
, nil, false, true)
    return 
  end
  self:_NextContinue(true)
end

BattleResultAftertTeatmentCtrl._TryShowExtraReward = function(self)
  -- function num : 0_8 , upvalues : _ENV, CommonRewardData
  if self.extraShowRwardDic == nil or (table.count)(self.extraShowRwardDic) == 0 then
    self:_NextContinue()
    return 
  end
  local ShowWinFunc = function(window)
    -- function num : 0_8_0 , upvalues : CommonRewardData, self
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(self.extraShowRwardDic)):SetCRShowOverFunc(self.___NextContinue)
    window:AddAndTryShowReward(CRData)
  end

  local rewardWin = UIManager:GetWindow(UIWindowTypeID.CommonReward)
  if rewardWin ~= nil then
    ShowWinFunc(rewardWin)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_8_1 , upvalues : ShowWinFunc
    if window == nil then
      return 
    end
    ShowWinFunc(window)
  end
)
  end
end

BattleResultAftertTeatmentCtrl._TryShowNewHeroReward = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.newHeroIdList == nil or (table.count)(self.newHeroIdList) == 0 then
    self:_NextContinue()
    return 
  end
  local allNewDic = {}
  for index,_ in ipairs(self.newHeroIdList) do
    allNewDic[index] = true
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GetHero, function(window)
    -- function num : 0_9_0 , upvalues : self, allNewDic, _ENV
    if window == nil then
      return 
    end
    window:InitGetHeroList(self.newHeroIdList, false, true, allNewDic, function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self
      AudioManager:PlayAudioById(1115)
      UIManager:DeleteWindow(UIWindowTypeID.GetHero)
      self:_NextContinue()
    end
)
    self.newHeroIdList = nil
  end
)
end

BattleResultAftertTeatmentCtrl.SetShowChallengeModeReward = function(self, rewardDic, fromNum, toNum, totalNum)
  -- function num : 0_10 , upvalues : CommonRewardData, _ENV
  if rewardDic == nil then
    return 
  end
  self.challengeModeCRData = ((((CommonRewardData.CreateCRDataUseDic)(rewardDic)):SetCRTitle(ConfigData:GetTipContent(962))):SetCRShowOverFunc(self.___NextContinue)):SetCRChallengeTask(fromNum, toNum, totalNum)
end

BattleResultAftertTeatmentCtrl._TryShowChallengeModeReward = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.challengeModeCRData == nil then
    self:_NextContinue()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_11_0 , upvalues : self
    if window == nil then
      return 
    end
    window:AddAndTryShowReward(self.challengeModeCRData)
  end
)
end

BattleResultAftertTeatmentCtrl._TryShowDungeonAutoFightReward = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.dungeonAutoFightTable == nil then
    self:_NextContinue()
    return 
  end
  UIManager:CreateWindowAsync(UIWindowTypeID.BattleAutoMode, function(window)
    -- function num : 0_12_0 , upvalues : self
    window:InitDungeonAutoRes((self.dungeonAutoFightTable).dInterfaceData, (self.dungeonAutoFightTable).count, (self.dungeonAutoFightTable).reward, (self.dungeonAutoFightTable).ath, function()
      -- function num : 0_12_0_0 , upvalues : self
      self:_NextContinue()
    end
)
  end
)
end

BattleResultAftertTeatmentCtrl._TryShowStOCareerRewar = function(self)
  -- function num : 0_13 , upvalues : _ENV
  self:_NextContinue()
  if self.StOCareerRewardDic == nil or (table.count)(self.StOCareerRewardDic) == 0 then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageSide, function(window)
    -- function num : 0_13_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    for itemId,num in pairs(self.StOCareerRewardDic) do
      window:ShowTips({itemId = itemId, num = num}, 2, eMessageSideType.ecParameter)
    end
  end
)
end

BattleResultAftertTeatmentCtrl.SaveSectorId = function(self, sectorId)
  -- function num : 0_14
  self.sectorId = sectorId
end

BattleResultAftertTeatmentCtrl._TryShowInfinityJumpLevelReward = function(self)
  -- function num : 0_15 , upvalues : _ENV, CommonRewardData
  if self.sectorId == nil then
    self:_NextContinue()
    return 
  end
  local items = (PlayerDataCenter.infinityData):GetJumpLevelReward(self.sectorId)
  ;
  (PlayerDataCenter.infinityData):CleanJumpLevelReward(self.sectorId)
  if items == nil then
    self:_NextContinue()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_15_0 , upvalues : CommonRewardData, items, self
    if window == nil then
      return 
    end
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(items)):SetCRShowOverFunc(self.___NextContinue)
    window:AddAndTryShowReward(CRData)
  end
)
end

BattleResultAftertTeatmentCtrl._NextContinue = function(self, isFirst)
  -- function num : 0_16 , upvalues : _ENV
  if isFirst then
    self.processIndex = 0
  end
  self.processIndex = self.processIndex + 1
  if #self.processTable < self.processIndex then
    self.__isStartReward = false
    for k,action in pairs(self.__afterActions) do
      action()
    end
    self:Delete()
    return 
  end
  ;
  ((self.processTable)[self.processIndex])()
end

BattleResultAftertTeatmentCtrl.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  self.__isStartReward = false
  TimerManager:StopTimer(self.__waitGuideTimer)
  self.__afterActions = nil
  ;
  (base.OnDelete)(self)
end

return BattleResultAftertTeatmentCtrl

