-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityCarnivalData = class("ActivityCarnivalData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
local ActTechData = require("Game.ActivitySectorII.Tech.Data.ActTechData")
local GameWatermelonData = require("Game.ActivityCarnival.GameWatermelonData")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local cs_MessageCommon = CS.MessageCommon
local CurActType = (ActivityFrameEnum.eActivityType).Carnival
ActivityCarnivalData.InitActivityCarnival = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV, GameWatermelonData
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_carnival)[msg.actId]
  self._expCfg = (ConfigData.activity_carnival_exp)[(self._mainCfg).exp_logic]
  self._cycleExpNeed = ((self._expCfg)[#self._expCfg]).need_exp
  self._levelTypeCfg = (ConfigData.activity_carnival_level)[(self._mainCfg).hard_level_type]
  self._envCfg = {}
  for k,v in pairs((ConfigData.activity_carnival_env)[msg.actId]) do
    (table.insert)(self._envCfg, v)
  end
  ;
  (table.sort)(self._envCfg, function(a, b)
    -- function num : 0_0_0
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self._level = 0
  self._exp = 0
  self._maxLevel = #self._expCfg
  self._rewardMaskDic = {}
  self._techDataDic = {}
  self._unlockEnvDic = {}
  self._lockedConditionEnvDic = {}
  self._lockedLevelEnvDic = {}
  self._questDic = {}
  self._questCompleteDic = {}
  self._nextRefreshTm = 0
  self._curStage = 0
  self._curDifficuty = 0
  self._techRowDic = {}
  self._lockedStageList = {}
  self._lockedAvgList = {}
  self._unComplectStageDic = {}
  self._unlookAvgDic = {}
  self._newUnlockInfoList = {}
  self._gameWatermelon = (GameWatermelonData.New)(msg.tinyGameUid, (self._mainCfg).game_mash_up)
  self:__GenTech()
  self:UpdateCarnival(msg)
  ExplorationManager:AddEpNewEpBuffSelect((self._mainCfg).main_stage, (self._mainCfg).initial_protocol_all)
end

ActivityCarnivalData.UpdateCarnival = function(self, msg)
  -- function num : 0_1
  self._curStage = msg.stage
  self._curDifficuty = msg.difficulty
  self._dungeonFrame = msg.dungeonFrame
  self:__UpdateTech(msg.tech)
  self:__UpdateExpAndReward(msg)
  self:__UpdateTask(msg)
  if self._lastCalEnvLevel == nil then
    self:__InitUnlockEnv()
    self:__InitCarnivalStageAndAvgState()
  else
    self:__CalCarnivalEnvByLevel()
  end
end

ActivityCarnivalData.__GenTech = function(self)
  -- function num : 0_2 , upvalues : _ENV, ActTechData, CurActType
  local techType = self:GetCarnivalTechType()
  local techTypeCfg = ((ConfigData.activity_tech).actTechTypeList)[techType]
  if techTypeCfg == nil then
    error("activity tech type is NIL,type is " .. tostring(techType))
  end
  for _,techId in ipairs(techTypeCfg.techIds) do
    local techCfg = (ConfigData.activity_tech)[techId]
    local branchDic = (self._techDataDic)[techCfg.branch]
    if branchDic == nil then
      branchDic = {}
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self._techDataDic)[techCfg.branch] = branchDic
    end
    local tech = (ActTechData.CreatAWTechData)(techId, CurActType, self:GetActId())
    branchDic[techId] = tech
    if not tech:IsActTechAutoUnlock() then
      local rowId = techCfg.row
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self._techRowDic)[rowId] = true
    end
  end
  for branchId,branchDic in pairs(self._techDataDic) do
    for techId,techData in pairs(branchDic) do
      local previousTechId = techData:GetPreTechId()
      if previousTechId ~= nil then
        local previousTech = ((self._techDataDic)[branchId])[previousTechId]
        techData:SetPreTechData(previousTech)
      end
    end
  end
end

ActivityCarnivalData.__InitUnlockEnv = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._lastCalEnvLevel = self._level
  for _,singleEnv in pairs(self._envCfg) do
    local unlock = true
    if not (CheckCondition.CheckLua)(singleEnv.pre_condition, singleEnv.pre_para1, singleEnv.pre_para1) then
      unlock = false
      for _,condition in ipairs(singleEnv.pre_condition) do
        local conditionDic = (self._lockedConditionEnvDic)[condition]
        if conditionDic == nil then
          conditionDic = {}
          -- DECOMPILER ERROR at PC27: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (self._lockedConditionEnvDic)[condition] = conditionDic
        end
        conditionDic[singleEnv.id] = true
      end
    else
      do
        if self._level < singleEnv.exp_level then
          unlock = false
          local levelList = (self._lockedLevelEnvDic)[singleEnv.exp_level]
          if levelList == nil then
            levelList = {}
            -- DECOMPILER ERROR at PC47: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (self._lockedLevelEnvDic)[singleEnv.exp_level] = levelList
          end
          ;
          (table.insert)(levelList, singleEnv.id)
        end
        do
          do
            -- DECOMPILER ERROR at PC57: Confused about usage of register: R7 in 'UnsetPending'

            if unlock then
              (self._unlockEnvDic)[singleEnv.id] = true
            end
            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

ActivityCarnivalData.CalCarnivalEnvByCondition = function(self, precondition)
  -- function num : 0_4 , upvalues : ActivityCarnivalEnum, _ENV
  local conditionDic = (self._lockedConditionEnvDic)[precondition]
  if conditionDic == nil then
    return 
  end
  local reddot = self:GetActivityReddot()
  if reddot ~= nil then
    reddot = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockEnv)
  end
  local activityIsRuning = self:IsActivityRunning()
  local hasUnlockEnv = false
  for envId,_ in pairs(conditionDic) do
    local singleEnv = self:GetCarnivalEnvCfgById(envId)
    local unlock = (CheckCondition.CheckLua)(singleEnv.pre_condition, singleEnv.pre_para1, singleEnv.pre_para1)
    if unlock then
      for _,condition in ipairs(singleEnv.pre_condition) do
        local conditionDic = (self._lockedConditionEnvDic)[condition]
        if conditionDic ~= nil then
          conditionDic[envId] = nil
        end
      end
      if self._level < singleEnv.exp_level then
        local levelList = (self._lockedLevelEnvDic)[singleEnv.exp_level]
        if levelList == nil then
          levelList = {}
          -- DECOMPILER ERROR at PC56: Confused about usage of register: R14 in 'UnsetPending'

          ;
          (self._lockedLevelEnvDic)[singleEnv.exp_level] = levelList
        end
        ;
        (table.insert)(levelList, singleEnv.id)
      else
        do
          if activityIsRuning then
            self:__AddNewUnlockInfo((ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env, singleEnv.id)
            -- DECOMPILER ERROR at PC72: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self._unlockEnvDic)[singleEnv.id] = true
            do
              do
                if reddot ~= nil then
                  local childReddot = reddot:AddChild(tostring(singleEnv.id))
                  childReddot:SetRedDotCount(1)
                end
                hasUnlockEnv = true
                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
  if hasUnlockEnv then
    MsgCenter:Broadcast(eMsgEventId.ActivityCarnivalEnvUnlock)
  end
end

ActivityCarnivalData.__CalCarnivalEnvByLevel = function(self)
  -- function num : 0_5 , upvalues : ActivityCarnivalEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot ~= nil then
    reddot = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockEnv)
  end
  local activityIsRuning = self:IsActivityRunning()
  local hasUnlockEnv = false
  if activityIsRuning then
    for i = self._lastCalEnvLevel + 1, self._level do
      local levelList = (self._lockedLevelEnvDic)[i]
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R9 in 'UnsetPending'

      if levelList ~= nil then
        (self._lockedLevelEnvDic)[i] = nil
        for _,envId in ipairs(levelList) do
          -- DECOMPILER ERROR at PC30: Confused about usage of register: R14 in 'UnsetPending'

          (self._unlockEnvDic)[envId] = true
          self:__AddNewUnlockInfo((ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env, envId)
          do
            do
              if reddot ~= nil then
                local childReddot = reddot:AddChild(tostring(envId))
                childReddot:SetRedDotCount(1)
              end
              hasUnlockEnv = ture
              -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out DO_STMT

            end
          end
        end
      end
    end
  end
  do
    self._lastCalEnvLevel = self._level
    if hasUnlockEnv then
      MsgCenter:Broadcast(eMsgEventId.ActivityCarnivalEnvUnlock)
    end
  end
end

ActivityCarnivalData.__InitCarnivalStageAndAvgState = function(self)
  -- function num : 0_6 , upvalues : _ENV, SectorLevelDetailEnum
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local Local_DealAvg = function(avgCfg)
    -- function num : 0_6_0 , upvalues : avgPlayCtrl, self, _ENV
    if avgCfg == nil then
      return 
    end
    if avgPlayCtrl:IsAvgPlayed(avgCfg.id) then
      return 
    end
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

    if avgPlayCtrl:IsAvgUnlock(avgCfg.id) then
      (self._unlookAvgDic)[avgCfg.id] = true
    else
      ;
      (table.insert)(self._lockedAvgList, avgCfg.id)
    end
  end

  local Local_DealStage = function(stageId)
    -- function num : 0_6_1 , upvalues : _ENV, self
    if (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
      return 
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    if (PlayerDataCenter.sectorStage):IsStageUnlock(stageId) then
      (self._unComplectStageDic)[stageId] = true
    else
      ;
      (table.insert)(self._lockedStageList, stageId)
    end
  end

  local sectorId = (self._mainCfg).story_stage
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[(SectorLevelDetailEnum.eDifficulty).normal]
  for _,stageId in ipairs(sectorStageCfg) do
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 1)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 1, i)
      Local_DealAvg(avgCfg)
    end
    Local_DealStage(stageId)
    local para2num = avgPlayCtrl:GetMainAvgPara2Num(stageId, 2)
    for i = 0, para2num - 1 do
      local avgCfg = avgPlayCtrl:TryGetAvgCfg(eAvgTriggerType.MainAvg, stageId, 2, i)
      Local_DealAvg(avgCfg)
    end
  end
  self:__UpdateReviewStageReddot()
end

ActivityCarnivalData.CalCarnivalStageAndAvgState = function(self, precondition)
  -- function num : 0_7 , upvalues : CheckerTypeId, _ENV, ActivityCarnivalEnum
  if precondition ~= CheckerTypeId.CompleteStage and precondition ~= CheckerTypeId.ActivityLevel then
    return 
  end
  local hasChange = false
  while 1 do
    if #self._lockedStageList > 0 then
      local stageId = (self._lockedStageList)[1]
      if (PlayerDataCenter.sectorStage):IsStageUnlock(stageId) then
        do
          hasChange = true
          ;
          (table.remove)(self._lockedStageList, 1)
          -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

          ;
          (self._unComplectStageDic)[stageId] = true
          self:__AddNewUnlockInfo((ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Stage, stageId)
          -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  while 1 do
    if #self._lockedAvgList > 0 then
      local avgId = (self._lockedAvgList)[1]
      if avgPlayCtrl:IsAvgUnlock(avgId) then
        do
          hasChange = true
          ;
          (table.remove)(self._lockedAvgList, 1)
          -- DECOMPILER ERROR at PC58: Confused about usage of register: R5 in 'UnsetPending'

          ;
          (self._unlookAvgDic)[avgId] = true
          self:__AddNewUnlockInfo((ActivityCarnivalEnum.eActivityCarnivalUnlockNew).AVG, avgId)
          -- DECOMPILER ERROR at PC64: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC64: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC64: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC64: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  for stageId,_ in pairs(self._unComplectStageDic) do
    if (PlayerDataCenter.sectorStage):IsStageComplete(stageId) then
      hasChange = true
      -- DECOMPILER ERROR at PC78: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._unComplectStageDic)[stageId] = nil
    end
  end
  if hasChange then
    self:__UpdateReviewStageReddot()
  end
end

ActivityCarnivalData.CalCarnivalAvgState = function(self, playedAvgId)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  if (self._unlookAvgDic)[playedAvgId] ~= nil then
    (self._unlookAvgDic)[playedAvgId] = nil
    self:__UpdateReviewStageReddot()
  end
end

ActivityCarnivalData.UpgradLevelTech = function(self, techData, callback)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon
  local flag, noEnoughItemId = techData:IsLeveUpResEnough()
  if not flag then
    local tip = nil
    if noEnoughItemId == (self._mainCfg).norTechItem then
      tip = ConfigData:GetTipContent(7114)
    else
      if noEnoughItemId == (self._mainCfg).speTechItem then
        tip = ConfigData:GetTipContent(7115)
      end
    end
    do
      do
        if tip ~= nil then
          local itemName = ConfigData:GetItemName(noEnoughItemId)
          tip = (string.format)(tip, itemName, itemName)
          ;
          (cs_MessageCommon.ShowMessageTipsWithErrorSound)(tip)
        end
        do return  end
        if not techData:IsCouldLevelUp() then
          return 
        end
        local activityFrameNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
        activityFrameNetwork:CS_ActivityTech_Upgrade(self:GetActFrameId(), techData:GetTechId(), function(args)
    -- function num : 0_9_0 , upvalues : _ENV, self, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local upgradedTechElement = args[0]
    for i,elemt in ipairs(upgradedTechElement) do
      local techId = elemt.id
      local techCfg = (ConfigData.activity_tech)[techId]
      local techDataElemt = ((self._techDataDic)[techCfg.branch])[techId]
      if techDataElemt ~= nil then
        if techDataElemt:IsActTechAutoUnlock() then
          self:__UpdateAutoTechReddot(techDataElemt, techDataElemt:GetCurLevel(), elemt.level)
        end
        techDataElemt:UpdateWATechByMsg(elemt)
      end
    end
    self:__UpdateTechReddot()
    if callback ~= nil then
      callback()
    end
  end
)
      end
    end
  end
end

ActivityCarnivalData.ResetLevelTech = function(self, branchId, callback)
  -- function num : 0_10 , upvalues : _ENV, cs_MessageCommon
  local branchTypeCfg = (ConfigData.activity_tech_branch)[(self._mainCfg).tech_id]
  if branchTypeCfg == nil then
    error("techType is NIL ")
    return 
  end
  local branchCfg = branchTypeCfg[branchId]
  if branchCfg == nil then
    error("techBranchId is NIL ")
    return 
  end
  for i,itemId in ipairs(branchCfg.revertCostIds) do
    if PlayerDataCenter:GetItemCount(itemId) < (branchCfg.revertCostNums)[i] then
      local itemName = ConfigData:GetItemName(itemId)
      local tip = ConfigData:GetTipContent(7116)
      tip = (string.format)(tip, itemName, itemName)
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(tip)
      return 
    end
  end
  local activityFrameNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  activityFrameNetwork:CS_ActivityTech_ResetBranch(self:GetActFrameId(), branchId, function()
    -- function num : 0_10_0 , upvalues : self, branchId, _ENV, callback
    local techDataDic = (self._techDataDic)[branchId]
    local levelMsg = {level = 0}
    for _,techData in pairs(techDataDic) do
      if techData:IsActTechAutoUnlock() then
        self:__UpdateAutoTechReddot(techData, techData:GetCurLevel(), levelMsg.level)
      end
      techData:UpdateWATechByMsg(levelMsg)
    end
    self:__UpdateTechReddot()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityCarnivalData.__UpdateTech = function(self, techMsg)
  -- function num : 0_11 , upvalues : _ENV
  if techMsg == nil then
    return 
  end
  for techId,singleMsg in pairs(techMsg.techData) do
    local techCfg = (ConfigData.activity_tech)[techId]
    local techData = ((self._techDataDic)[techCfg.branch])[techId]
    techData:UpdateWATechByMsg(singleMsg)
  end
  self:__UpdateTechReddot()
end

ActivityCarnivalData.__UpdateTask = function(self, msg)
  -- function num : 0_12 , upvalues : _ENV
  self._questDic = msg.quests
  self._questCompleteDic = msg.completedQuests
  self._questNextRefreshTm = msg.nextExpiredTm
  local questList = {}
  for taskId,_ in pairs(self._questDic) do
    (table.insert)(questList, taskId)
  end
  ;
  (table.sort)(questList, function(a, b)
    -- function num : 0_12_0 , upvalues : self
    local qualityA = self:GetCarnivalTaskQuality(a)
    local qualityB = self:GetCarnivalTaskQuality(b)
    if qualityA >= qualityB then
      do return qualityA == qualityB end
      do return a < b end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  for i,taskId in ipairs(questList) do
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R8 in 'UnsetPending'

    (self._questDic)[taskId] = i
  end
  self:UpdateCarnivalTaskReddot()
end

ActivityCarnivalData.__UpdateTasksFronServer = function(self, newTaskId, oriQuestId)
  -- function num : 0_13
  local oriPos = (self._questDic)[oriQuestId]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._questDic)[oriQuestId] = nil
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._questDic)[newTaskId] = oriPos
  self:UpdateCarnivalTaskReddot()
end

ActivityCarnivalData.__UpdateExpAndReward = function(self, msg)
  -- function num : 0_14 , upvalues : _ENV, CheckerTypeId, ActivityCarnivalEnum
  if self._level ~= msg.level or self._exp ~= msg.exp then
    self._level = msg.level
    self._exp = msg.exp
    MsgCenter:Broadcast(eMsgEventId.ActivityCarnivalExpLevelChange)
    MsgCenter:Broadcast(eMsgEventId.PreCondition, CheckerTypeId.ActivityLevel)
  end
  for level = 1, self._level do
    if not (self._rewardMaskDic)[level] then
      local index = (math.floor)(level / 32)
      local mask = (msg.rewardsMask)[index + 1]
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R8 in 'UnsetPending'

      if mask & 1 << level % 32 == 0 then
        do
          (self._rewardMaskDic)[level] = mask == nil
          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC49: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local canReceive = false
  for level = 1, self._level do
    if not (self._rewardMaskDic)[level] then
      canReceive = true
      break
    end
  end
  local reddotChild = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).Reward)
  reddotChild:SetRedDotCount(canReceive and 1 or 0)
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

ActivityCarnivalData.UpdateCarnivalTaskReddot = function(self)
  -- function num : 0_15 , upvalues : _ENV, ActivityCarnivalEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local canComplete = false
  if self:IsActivityRunning() then
    for taskId,_ in pairs(self._questDic) do
      local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId)
      if taskData ~= nil and taskData:CheckComplete() then
        canComplete = true
        break
      end
    end
  end
  do
    local reddotChild = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).Task)
    reddotChild:SetRedDotCount(canComplete and 1 or 0)
  end
end

ActivityCarnivalData.__UpdateTechReddot = function(self)
  -- function num : 0_16 , upvalues : ActivityCarnivalEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local reddotChild = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).Tech)
  if not self:IsActivityRunning() then
    reddotChild:ClearChild()
    return 
  end
  for branchId,branchDic in pairs(self._techDataDic) do
    local hasLeveUpTech = false
    for k,techData in pairs(branchDic) do
      if techData:IsCouldLevelUp() then
        hasLeveUpTech = true
        break
      end
    end
    do
      do
        local reddotChildPage = reddotChild:AddChild(branchId)
        reddotChildPage:SetRedDotCount(hasLeveUpTech and 1 or 0)
        -- DECOMPILER ERROR at PC44: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

ActivityCarnivalData.__UpdateAutoTechReddot = function(self, actTech, lastLevel, curLevel)
  -- function num : 0_17 , upvalues : ActivityCarnivalEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local branchId = (actTech:GetActTechCfg()).branch
  local reddotChild = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).AutoTech)
  reddotChild = reddotChild:AddChild(branchId)
  if curLevel < lastLevel then
    reddotChild:RemoveChild(actTech:GetTechId())
  else
    if lastLevel < curLevel then
      (reddotChild:AddChild(actTech:GetTechId())):SetRedDotCount(1)
    end
  end
end

ActivityCarnivalData.__UpdateReviewStageReddot = function(self)
  -- function num : 0_18 , upvalues : ActivityCarnivalEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local reddotChild = reddot:AddChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockStage)
  if (table.count)(self._unlookAvgDic) > 0 or (table.count)(self._unComplectStageDic) > 0 then
    reddotChild:SetRedDotCount(1)
  else
    reddotChild:SetRedDotCount(0)
  end
end

ActivityCarnivalData.__AddNewUnlockInfo = function(self, unlockType, unlockId)
  -- function num : 0_19 , upvalues : _ENV
  local data = {unlockType = unlockType, unlockId = unlockId}
  ;
  (table.insert)(self._newUnlockInfoList, data)
end

ActivityCarnivalData.ClearNewUnlockInfo = function(self)
  -- function num : 0_20 , upvalues : _ENV
  (table.removeall)(self._newUnlockInfoList)
end

ActivityCarnivalData.DealCarnivalWhenEnd = function(self)
  -- function num : 0_21 , upvalues : ActivityCarnivalEnum, _ENV
  local reddot = self:GetActivityReddot()
  if reddot ~= nil then
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).Task)
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockEnv)
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).TaskPeriod)
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).Tech)
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockHardDun)
    reddot:RemoveChild((ActivityCarnivalEnum.eActivityCarnivalReddot).AutoTech)
  end
  local count = #self._newUnlockInfoList
  for i = count, 1, -1 do
    local item = (self._newUnlockInfoList)[i]
    if item.unlockType == (ActivityCarnivalEnum.eActivityCarnivalUnlockNew).Env then
      (table.remove)(self._newUnlockInfoList, i)
    end
  end
  ExplorationManager:RemoveEpNewEpBuffSelect((self._mainCfg).main_stage)
end

ActivityCarnivalData.ReqCarnivalSingleTaskRefresh = function(self, taskId, callback)
  -- function num : 0_22 , upvalues : _ENV
  local activityCarnivalNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityCarnival)
  activityCarnivalNetwork:CS_ACTIVITY_Carnival_RefreshQuestSingle(self:GetActId(), taskId, function(args)
    -- function num : 0_22_0 , upvalues : _ENV, self, taskId, callback
    if (args == nil or args.Count == 0) and isGameDev then
      error("args.Count == 0")
    end
    local msg = args[0]
    local newTaskId = nil
    for k,v in pairs(msg.quests) do
      if (self._questDic)[k] == nil then
        newTaskId = k
        break
      end
    end
    do
      if newTaskId == nil then
        if isGameDev then
          error(" change task not found ")
        end
        return 
      end
      self:__UpdateTasksFronServer(newTaskId, taskId)
      if callback ~= nil then
        callback(newTaskId, taskId)
      end
    end
  end
)
end

ActivityCarnivalData.ReqCarnivalCycleReward = function(self, callback)
  -- function num : 0_23 , upvalues : _ENV
  if not self:IsCanCarnivalCycleReward() then
    return 
  end
  local rewardIds = {}
  local rewardNums = {}
  local mul = self._exp // self._cycleExpNeed
  for id,count in pairs((self._mainCfg).cir_reward) do
    (table.insert)(rewardIds, id)
    ;
    (table.insert)(rewardNums, count * mul)
  end
  local crtransdIC = PlayerDataCenter:CalCrItemTransDic(rewardIds, rewardNums)
  local activityCarnivalNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityCarnival)
  activityCarnivalNetwork:CS_ACTIVITY_Carnival_PickCirCleReward(self:GetActId(), function(args)
    -- function num : 0_23_0 , upvalues : _ENV, crtransdIC, self, callback
    if args == nil or args.Count == 0 then
      if isGameDev then
        error("args.Count == 0")
      end
      return 
    end
    local msg = args[0]
    local rewards = msg.rewards
    ;
    (UIUtil.ShowCommonReward)(rewards, crtransdIC)
    self._exp = self._exp % self._cycleExpNeed
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityCarnivalData.ReqCarnivalAllReward = function(self, callback)
  -- function num : 0_24 , upvalues : _ENV
  local rewardIds = {}
  local rewardNums = {}
  local mul = self._exp // self._cycleExpNeed
  for id,count in pairs((self._mainCfg).cir_reward) do
    (table.insert)(rewardIds, id)
    ;
    (table.insert)(rewardNums, count * mul)
  end
  for level = 1, self._level do
    if not self:IsReceivedLevelReward(level) then
      local cfg = (self._expCfg)[level]
      for i,itemId in ipairs(cfg.rewardIds) do
        local itemCount = (cfg.rewardNums)[i]
        local index = (table.indexof)(rewardIds, itemId)
        if index then
          rewardNums[index] = rewardNums[index] + itemCount
        else
          ;
          (table.insert)(rewardIds, itemId)
          ;
          (table.insert)(rewardNums, itemCount)
        end
      end
    end
  end
  local crtransdIC = PlayerDataCenter:CalCrItemTransDic(rewardIds, rewardNums)
  local activityCarnivalNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityCarnival)
  activityCarnivalNetwork:CS_ACTIVITY_Carnival_PickAllLevelReward(self:GetActId(), function(args)
    -- function num : 0_24_0 , upvalues : _ENV, crtransdIC, callback
    if args == nil or args.Count == 0 then
      if isGameDev then
        error("args.Count == 0")
      end
      return 
    end
    local msg = args[0]
    local rewards = msg.rewards
    ;
    (UIUtil.ShowCommonReward)(rewards, crtransdIC)
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityCarnivalData.ReqCarnivalLevelReward = function(self, level, callback)
  -- function num : 0_25 , upvalues : _ENV
  if self:IsReceivedLevelReward(level) or self._level < level then
    return 
  end
  local cfg = (self._expCfg)[level]
  local crtransdIC = PlayerDataCenter:CalCrItemTransDic(cfg.rewardIds, cfg.rewardNums)
  local activityCarnivalNetwork = NetworkManager:GetNetwork(NetworkTypeID.ActivityCarnival)
  activityCarnivalNetwork:CS_ACTIVITY_Carnival_PickLevelReward(self:GetActId(), level, function(args)
    -- function num : 0_25_0 , upvalues : _ENV, crtransdIC, callback
    if args == nil or args.Count == 0 then
      if isGameDev then
        error("args.Count == 0")
      end
      return 
    end
    local msg = args[0]
    local rewards = msg.rewards
    ;
    (UIUtil.ShowCommonReward)(rewards, crtransdIC)
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityCarnivalData.GetCarnivalExpCfg = function(self)
  -- function num : 0_26
  return self._expCfg
end

ActivityCarnivalData.IsCanCarnivalCycleReward = function(self)
  -- function num : 0_27
  do return self._cycleExpNeed < self._exp end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityCarnivalData.GetCarnivalMainCfg = function(self)
  -- function num : 0_28
  return self._mainCfg
end

ActivityCarnivalData.GetCarnivalEpStageCfg = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local envId, diffculty = saveUserData:GetCarnivalDiffEnv((self._mainCfg).id)
  local envCfg = nil
  if envId == nil then
    envCfg = (self._envCfg)[1]
    diffculty = 1
  else
    envCfg = self:GetCarnivalEnvCfgById(envId)
  end
  local stageId = (envCfg.stage_id)[diffculty]
  local stageCfg = (ConfigData.sector_stage)[stageId]
  return stageCfg
end

ActivityCarnivalData.GetCarnivalLevelExp = function(self)
  -- function num : 0_30
  return self._level, self._exp
end

ActivityCarnivalData.GetCarnivalMaxLevel = function(self)
  -- function num : 0_31
  return self._maxLevel
end

ActivityCarnivalData.GetCarnivalExpProcess = function(self)
  -- function num : 0_32
  return ((self._expCfg)[self._level]).totalExp, ((self._expCfg)[self._maxLevel]).totalExp
end

ActivityCarnivalData.IsReceivedLevelReward = function(self, level)
  -- function num : 0_33
  return (self._rewardMaskDic)[level]
end

ActivityCarnivalData.GetCarnivalTask = function(self)
  -- function num : 0_34
  return self._questDic
end

ActivityCarnivalData.GetCarnivalTaskQuality = function(self, taskId)
  -- function num : 0_35
  local quality = ((self._mainCfg).pool_quality)[taskId]
  if quality == nil then
    quality = 0
  end
  return quality
end

ActivityCarnivalData.GetCarnivalTaskNextTm = function(self)
  -- function num : 0_36
  return self._questNextRefreshTm
end

ActivityCarnivalData.GetCarnivalTech = function(self)
  -- function num : 0_37
  return self._techDataDic
end

ActivityCarnivalData.GetCarnivalHardLevelCfg = function(self)
  -- function num : 0_38
  return self._levelTypeCfg
end

ActivityCarnivalData.GetCarnivalTechType = function(self)
  -- function num : 0_39
  return (self._mainCfg).tech_id
end

ActivityCarnivalData.GetCarnivalStage = function(self)
  -- function num : 0_40
  return self._curStage
end

ActivityCarnivalData.GetCarnivalUnlockEnv = function(self)
  -- function num : 0_41
  return self._unlockEnvDic
end

ActivityCarnivalData.IsCarnivalUnlockEnv = function(self, envId)
  -- function num : 0_42
  return (self._unlockEnvDic)[envId]
end

ActivityCarnivalData.GetCarnivalTechBranchLevel = function(self, branchId)
  -- function num : 0_43 , upvalues : _ENV
  local curLevel = 0
  local techDic = (self._techDataDic)[branchId]
  for k,techData in pairs(techDic) do
    if not techData:IsActTechAutoUnlock() then
      curLevel = curLevel + techData:GetCurLevel()
    end
  end
  return curLevel
end

ActivityCarnivalData.GetCarnivalRowsDic = function(self)
  -- function num : 0_44
  return self._techRowDic
end

ActivityCarnivalData.GetCarnivalTechRow = function(self, rowIndex)
  -- function num : 0_45 , upvalues : _ENV
  local rowCfg = (ConfigData.activity_tech_line)[rowIndex]
  if rowCfg == nil then
    return 0
  end
  return rowCfg.num
end

ActivityCarnivalData.GetCarnivalTinyGame = function(self)
  -- function num : 0_46
  return self._gameWatermelon
end

ActivityCarnivalData.GetNewunlockInfo = function(self)
  -- function num : 0_47
  return self._newUnlockInfoList
end

ActivityCarnivalData.IsExistCarnivalNewunlock = function(self)
  -- function num : 0_48
  do return #self._newUnlockInfoList > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityCarnivalData.GetCarnivalChallengeRecord = function(self, dungeonId)
  -- function num : 0_49 , upvalues : _ENV
  if dungeonId == nil or self._dungeonFrame == nil then
    error("dungeonFrame NIL or param error")
    return nil
  end
  return (self._dungeonFrame)[dungeonId]
end

ActivityCarnivalData.GetCarnivalEnvCfg = function(self)
  -- function num : 0_50
  return self._envCfg
end

ActivityCarnivalData.GetCarnivalEnvCfgById = function(self, envId)
  -- function num : 0_51 , upvalues : _ENV
  return ((ConfigData.activity_carnival_env)[self:GetActId()])[envId]
end

ActivityCarnivalData.GetActivityReddotNum = function(self)
  -- function num : 0_52 , upvalues : _ENV, ActivityCarnivalEnum
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return false, 0
  end
  if reddot:GetRedDotCount() == 0 then
    return false, 0
  end
  local isBule = true
  for _,nodeId in ipairs(ActivityCarnivalEnum.eReddotShowRedTypes) do
    local childReddot = reddot:GetChild(nodeId)
    if childReddot ~= nil and childReddot:GetRedDotCount() > 0 then
      isBule = false
      break
    end
  end
  do
    return isBule, reddot:GetRedDotCount()
  end
end

return ActivityCarnivalData

