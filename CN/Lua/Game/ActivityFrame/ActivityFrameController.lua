-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameController = class("ActivityFrameController", ControllerBase)
local base = ControllerBase
local ActivityFrameData = require("Game.ActivityFrame.ActivityFrameData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityFrameOpenFunc = require("Game.ActivityFrame.ActivityFrameOpenFunc")
local ActivityFrameChangeFunc = require("Game.ActivityFrame.ActivityFrameChangeFunc")
local ActivityFrameRunningEndFunc = require("Game.ActivityFrame.ActivityFrameRunningEndFunc")
local ActivityFramePreviewFunc = require("Game.ActivityFrame.ActivityFramePreviewFunc")
local ActivityDailyFlushFunc = require("Game.ActivityFrame.ActivityDailyFlushFunc")
local HomeEnum = require("Game.Home.HomeEnum")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local ActivityTinyGameData = require("Game.ActivityFrame.ActivityTinyGameData")
local ActDailyTaskData = require("Game.ActivityFrame.ActDailyTaskData")
local CheckerTimeTypeTable = {CheckerTypeId.TimeRange}
local CheckerTimeEndTable = {-1}
ActivityFrameController.ctor = function(self)
  -- function num : 0_0 , upvalues : ConditionListener, _ENV, ActivityFrameEnum, ActivityFrameController
  self.AllActivityFrameDataDic = {}
  self.ActivityCatMapping = {}
  self._openEnteryDic = {}
  self._openCatDic = {}
  self._processDic = {}
  self._lockActDic = {}
  self._conditionListener = (ConditionListener.New)()
  self.__DealTimeListenAction = BindCallback(self, self.__DealTimeListen)
  for i = (ActivityFrameEnum.eActivityState).WaitState, (ActivityFrameEnum.eActivityState).DestroyState do
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

    (self._processDic)[i] = {}
  end
  self.__BC_Listern2PreConditona = BindCallback(self, self.__Listern2PreConditon)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__BC_Listern2PreConditona)
  self.wechatActivityElems = {}
  self.ActivityStateDelaFunc = {[(ActivityFrameEnum.eActivityState).WaitState] = BindCallback(self, ActivityFrameController.__WaitActivitys), [(ActivityFrameEnum.eActivityState).PreviewState] = BindCallback(self, ActivityFrameController.__PreviewActivitys), [(ActivityFrameEnum.eActivityState).OpenState] = BindCallback(self, ActivityFrameController.__OpenActivitys), [(ActivityFrameEnum.eActivityState).RewardState] = BindCallback(self, ActivityFrameController.__DealActivityRunningEnd), [(ActivityFrameEnum.eActivityState).DestroyState] = BindCallback(self, ActivityFrameController.__FinishActivitys)}
  self._tinyGameDic = {}
  self._tinyGameHighScore = {}
end

ActivityFrameController.UpdateActivity = function(self, activityElemDic)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameData, ActivityFrameEnum
  local wechatActivityIds = {}
  local activityStateCollect = {}
  for id,activityElem in pairs(activityElemDic) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    if actInfo ~= nil then
      actInfo:UpdateActivityFrameData(activityElem)
    else
      actInfo = (ActivityFrameData.CreateActivityFrameData)(activityElem)
      local actState, isUnlock = self:__CalculateActivityState(actInfo)
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R12 in 'UnsetPending'

      if (actState ~= (ActivityFrameEnum.eActivityState).DestroyState and actState ~= (ActivityFrameEnum.eActivityState).None) or actInfo:GetDurationTmForFrameCtrl() > 0 then
        (self.AllActivityFrameDataDic)[id] = actInfo
        local actCat = actInfo:GetActivityFrameCat()
        local actId = actInfo:GetActId()
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R14 in 'UnsetPending'

        if not (self.ActivityCatMapping)[actCat] then
          (self.ActivityCatMapping)[actCat] = {}
          -- DECOMPILER ERROR at PC48: Confused about usage of register: R14 in 'UnsetPending'

          ;
          ((self.ActivityCatMapping)[actCat])[actId] = id
          local enterTypeRedNode = self:__GetEnterReddot(actInfo.enterType, actInfo.actCat)
          do
            if enterTypeRedNode ~= nil then
              local node = enterTypeRedNode:AddChild(actInfo:GetActivityFrameId())
              actInfo:SetActivityReddotForFrameCtrl(node)
            end
            if actInfo.actCat == (ActivityFrameEnum.eActivityType).Tickets then
              wechatActivityIds[actInfo.actId] = true
            end
            -- DECOMPILER ERROR at PC80: Confused about usage of register: R15 in 'UnsetPending'

            if actInfo:GetDurationTmForFrameCtrl() <= 0 then
              if actState ~= (ActivityFrameEnum.eActivityState).WaitState and not isUnlock then
                (self._lockActDic)[id] = true
              else
                if actState == (ActivityFrameEnum.eActivityState).DestroyState or actState == (ActivityFrameEnum.eActivityState).None then
                  actInfo:SetActivityStateForFrameCtrl(actState)
                else
                  if not activityStateCollect[actState] then
                    do
                      activityStateCollect[actState] = {}
                      ;
                      (table.insert)(activityStateCollect[actState], id)
                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_THEN_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_THEN_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out DO_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_THEN_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_THEN_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                      -- DECOMPILER ERROR at PC104: LeaveBlock: unexpected jumping out IF_STMT

                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  self:__DealStateCollect(activityStateCollect, false)
  do
    if (table.count)(wechatActivityIds) then
      local actFrameCtr = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
      actFrameCtr:CS_ACTIVITY_Wechat_Detail(wechatActivityIds)
    end
    if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SignIn) then
      self:AddFakeSigninActivityData()
    end
    self:__DeleteExpireActUserData()
  end
end

ActivityFrameController.GetIdByActTypeAndActId = function(self, actType, actId)
  -- function num : 0_2
  local catMapping = (self.ActivityCatMapping)[actType]
  return catMapping ~= nil and catMapping[actId] or nil
end

ActivityFrameController.GetActivityFrameDataDic = function(self)
  -- function num : 0_3
  return self.AllActivityFrameDataDic
end

ActivityFrameController.GetActivityFrameData = function(self, actFrmaId)
  -- function num : 0_4
  if actFrmaId == nil then
    return nil
  end
  return (self.AllActivityFrameDataDic)[actFrmaId]
end

ActivityFrameController.GetActivityFrameDataByTypeAndId = function(self, actType, actId)
  -- function num : 0_5
  local id = self:GetIdByActTypeAndActId(actType, actId)
  if id ~= nil then
    return self:GetActivityFrameData(id)
  end
  return nil
end

ActivityFrameController.HideActivityByExtraLogic = function(self, actType, actId)
  -- function num : 0_6
  local id = self:GetIdByActTypeAndActId(actType, actId)
  if id ~= nil then
    self:__FinishActivitys({id})
  end
end

ActivityFrameController.IsHaveShowByEnterType = function(self, enterType)
  -- function num : 0_7
  do return (self._openEnteryDic)[enterType] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameController.GetShowByEnterType = function(self, enterType)
  -- function num : 0_8 , upvalues : _ENV
  local openActIdDic = (self._openEnteryDic)[enterType]
  if openActIdDic == nil then
    return nil
  end
  local dic = {}
  for actId,_ in pairs(openActIdDic) do
    dic[actId] = (self.AllActivityFrameDataDic)[actId]
  end
  return dic
end

ActivityFrameController.GetIsHaveUnlockedActivity = function(self)
  -- function num : 0_9 , upvalues : _ENV, ActivityFrameEnum
  for index,enterType in ipairs(ActivityFrameEnum.eActivityEnterTypePriority) do
    if self:IsHaveShowByEnterType(enterType) then
      return enterType
    end
  end
  return nil
end

ActivityFrameController.GetAutoJumpTargetActivity = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivityFrameEnum
  local needEnterType = nil
  for index,enterType in ipairs(ActivityFrameEnum.eActivityEnterTypePriority) do
    if self:IsHaveShowByEnterType(enterType) then
      local enterTypeRedNode = self:__GetEnterReddot(enterType)
      if enterTypeRedNode ~= nil and enterTypeRedNode:GetRedDotCount() > 0 then
        return enterType
      end
    end
  end
  if needEnterType ~= nil or not enterType then
    return needEnterType
  end
end

ActivityFrameController.IsExistOpenActByActType = function(self, actType)
  -- function num : 0_11
  do return (self._openCatDic)[actType] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityFrameController.GetShowByActType = function(self, actType)
  -- function num : 0_12
  return (self._openCatDic)[actType]
end

ActivityFrameController.__GetEnterReddot = function(self, enterType, actCat)
  -- function num : 0_13 , upvalues : ActivityFrameEnum, _ENV
  local enterTypeRedNode = nil
  if enterType == (ActivityFrameEnum.eActivityEnterType).Novice then
    _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameNovice)
  else
    -- DECOMPILER ERROR at PC30: Overwrote pending register: R3 in 'AssignReg'

    if enterType == (ActivityFrameEnum.eActivityEnterType).LimitTime then
      _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameLimitTime)
    else
      -- DECOMPILER ERROR at PC46: Overwrote pending register: R3 in 'AssignReg'

      if enterType == (ActivityFrameEnum.eActivityEnterType).Comeback then
        _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityComeback)
      else
        -- DECOMPILER ERROR at PC62: Overwrote pending register: R3 in 'AssignReg'

        if enterType == (ActivityFrameEnum.eActivityEnterType).KeyExertion then
          _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityKeyExertion)
        else
          -- DECOMPILER ERROR at PC76: Overwrote pending register: R3 in 'AssignReg'

          if actCat == (ActivityFrameEnum.eActivityType).SectorI then
            _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityFrameSectorI)
          else
            -- DECOMPILER ERROR at PC86: Overwrote pending register: R3 in 'AssignReg'

            _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle)
          end
        end
      end
    end
  end
  return enterTypeRedNode
end

ActivityFrameController.__CalculateActivityState = function(self, activityData)
  -- function num : 0_14 , upvalues : ActivityFrameEnum, _ENV
  local activityState = (ActivityFrameEnum.eActivityState).None
  if activityData:GetActivityDestroyTime() <= PlayerDataCenter.timestamp and activityData:GetActivityDestroyTime() ~= -1 then
    activityState = (ActivityFrameEnum.eActivityState).DestroyState
  else
    if activityData:GetActivityEndTime() <= PlayerDataCenter.timestamp and activityData:GetActivityEndTime() ~= -1 then
      activityState = (ActivityFrameEnum.eActivityState).RewardState
    else
      if activityData:GetActivityBornTime() <= PlayerDataCenter.timestamp then
        activityState = (ActivityFrameEnum.eActivityState).OpenState
      else
        if activityData:IsPreviewType() and activityData:GetActivityPreviewTime() <= PlayerDataCenter.timestamp then
          activityState = (ActivityFrameEnum.eActivityState).PreviewState
        else
          activityState = (ActivityFrameEnum.eActivityState).WaitState
        end
      end
    end
  end
  return activityState, activityData:GetIsActivityUnlockForFrameCtrl()
end

ActivityFrameController.__WaitActivitys = function(self, ids)
  -- function num : 0_15 , upvalues : _ENV, ActivityFrameEnum
  if ids == nil or #ids <= 0 then
    return 
  end
  for _,id in ipairs(ids) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    actInfo:SetActivityStateForFrameCtrl((ActivityFrameEnum.eActivityState).WaitState)
    if actInfo:IsPreviewType() then
      self:__AddTimeListen(id, actInfo:GetActivityPreviewTime(), (ActivityFrameEnum.eActivityState).PreviewState)
    else
      self:__AddTimeListen(id, actInfo:GetActivityBornTime(), (ActivityFrameEnum.eActivityState).OpenState)
    end
  end
end

ActivityFrameController.__PreviewActivitys = function(self, ids, needCallFunc)
  -- function num : 0_16 , upvalues : _ENV, ActivityFrameEnum, ActivityFramePreviewFunc
  if ids == nil or #ids <= 0 then
    return 
  end
  for _,id in ipairs(ids) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R9 in 'UnsetPending'

    if not actInfo:GetIsActivityUnlockForFrameCtrl() then
      (self._lockActDic)[id] = true
    else
      actInfo:SetIsActivityUnlockForFrameCtrl()
      actInfo:SetActivityStateForFrameCtrl((ActivityFrameEnum.eActivityState).PreviewState)
      self:__DealCouldShowInfo(actInfo)
      self:__AddTimeListen(id, actInfo:GetActivityBornTime(), (ActivityFrameEnum.eActivityState).OpenState)
      if needCallFunc and ActivityFramePreviewFunc[actInfo.actCat] ~= nil then
        (ActivityFramePreviewFunc[actInfo.actCat])(actInfo)
      end
    end
  end
  MsgCenter:Broadcast(eMsgEventId.ActivityPreview, ids)
end

ActivityFrameController.__OpenActivitys = function(self, ids, needCallFunc)
  -- function num : 0_17 , upvalues : _ENV, ActivityFrameEnum, ActivityFrameOpenFunc, ActivityFrameChangeFunc
  if ids == nil or #ids <= 0 then
    return 
  end
  for _,id in ipairs(ids) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R9 in 'UnsetPending'

    if not actInfo:GetIsActivityUnlockForFrameCtrl() then
      (self._lockActDic)[id] = true
    else
      if actInfo:GetActivityDestroyTime() <= 0 or actInfo:GetActivityDestroyTime() >= PlayerDataCenter.timestamp then
        actInfo:SetIsActivityUnlockForFrameCtrl()
        local isCouldShow = actInfo:GetCouldShowActivity()
        actInfo:SetActivityStateForFrameCtrl((ActivityFrameEnum.eActivityState).OpenState)
        if not isCouldShow then
          self:__DealCouldShowInfo(actInfo)
        end
        if needCallFunc and ActivityFrameOpenFunc[actInfo.actCat] ~= nil then
          (ActivityFrameOpenFunc[actInfo.actCat])(actInfo)
        end
        if ActivityFrameChangeFunc[actInfo.actCat] ~= nil then
          (ActivityFrameChangeFunc[actInfo.actCat])(actInfo)
        end
        if actInfo:GetActivityEndTime() ~= -1 then
          self:__AddTimeListen(id, actInfo:GetActivityEndTime(), (ActivityFrameEnum.eActivityState).RewardState)
        end
      end
    end
  end
  MsgCenter:Broadcast(eMsgEventId.ActivityShowChange, ids, true)
end

ActivityFrameController.__DealActivityRunningEnd = function(self, ids, needCallFunc)
  -- function num : 0_18 , upvalues : _ENV, ActivityFrameEnum, ActivityFrameRunningEndFunc
  if ids == nil or #ids <= 0 then
    return 
  end
  local finishIds = nil
  for _,id in ipairs(ids) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    actInfo:SetActivityStateForFrameCtrl((ActivityFrameEnum.eActivityState).RewardState)
    if needCallFunc and ActivityFrameRunningEndFunc[actInfo.actCat] ~= nil then
      (ActivityFrameRunningEndFunc[actInfo.actCat])(actInfo)
    end
    if actInfo:GetActivityDestroyTime() ~= -1 then
      if actInfo:GetActivityDestroyTime() <= actInfo:GetActivityEndTime() then
        if not finishIds then
          finishIds = {}
        end
        ;
        (table.insert)(finishIds, id)
      else
        self:__AddTimeListen(id, actInfo:GetActivityDestroyTime(), (ActivityFrameEnum.eActivityState).DestroyState)
      end
    end
  end
  if finishIds ~= nil then
    self:__FinishActivitys(finishIds, true)
  end
end

ActivityFrameController.__FinishActivitys = function(self, ids, needCallFunc)
  -- function num : 0_19 , upvalues : _ENV, ActivityFrameEnum, ActivityFrameChangeFunc
  if ids == nil or #ids <= 0 then
    return 
  end
  for _,id in ipairs(ids) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R9 in 'UnsetPending'

    if actInfo ~= nil then
      (self.AllActivityFrameDataDic)[id] = nil
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.ActivityCatMapping)[actInfo:GetActivityFrameCat()])[actInfo:GetActId()] = nil
      actInfo:SetActivityStateForFrameCtrl((ActivityFrameEnum.eActivityState).DestroyState)
      self:__DealCouldHideInfo(actInfo)
      if ActivityFrameChangeFunc[actInfo.actCat] ~= nil then
        (ActivityFrameChangeFunc[actInfo.actCat])(actInfo)
      end
    end
  end
  MsgCenter:Broadcast(eMsgEventId.ActivityShowChange, ids, false)
end

ActivityFrameController.__AddTimeListen = function(self, id, time, state)
  -- function num : 0_20 , upvalues : _ENV, CheckerTimeTypeTable, CheckerTimeEndTable
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  if not ((self._processDic)[state])[time] then
    ((self._processDic)[state])[time] = {}
    ;
    (table.insert)(((self._processDic)[state])[time], id)
    if time < PlayerDataCenter.timestamp then
      self:__DealTimeListen(time)
      return 
    end
    if not (self._conditionListener):IsDuplicationKey(time) then
      (self._conditionListener):AddConditionChangeListener(time, self.__DealTimeListenAction, CheckerTimeTypeTable, {time}, CheckerTimeEndTable)
    end
  end
end

ActivityFrameController.__DealTimeListen = function(self, listenId)
  -- function num : 0_21 , upvalues : ActivityFrameEnum, _ENV
  for i = (ActivityFrameEnum.eActivityState).WaitState, (ActivityFrameEnum.eActivityState).DestroyState do
    for listenId,dealList in pairs((self._processDic)[i]) do
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R11 in 'UnsetPending'

      if listenId <= PlayerDataCenter.timestamp then
        ((self._processDic)[i])[listenId] = nil
        local func = (self.ActivityStateDelaFunc)[i]
        if func ~= nil then
          func(dealList, true)
        else
          error("actStateFunction is NIL state is " .. tostring(i))
        end
      end
    end
  end
end

ActivityFrameController.__Listern2PreConditon = function(self, conditionId)
  -- function num : 0_22 , upvalues : _ENV, ActivityFrameEnum
  local activityStateCollect = nil
  for id,_ in pairs(self._lockActDic) do
    local actInfo = (self.AllActivityFrameDataDic)[id]
    if actInfo ~= nil and actInfo:IsHaveThisConditionForFrameCtrl(conditionId) then
      local actState, isUnlock = self:__CalculateActivityState(actInfo)
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R11 in 'UnsetPending'

      if (ActivityFrameEnum.eActivityState).DestroyState <= actState then
        (self._lockActDic)[id] = nil
      else
        -- DECOMPILER ERROR at PC27: Confused about usage of register: R11 in 'UnsetPending'

        if isUnlock then
          (self._lockActDic)[id] = nil
          if not activityStateCollect then
            activityStateCollect = {}
          end
          if not activityStateCollect[actState] then
            do
              activityStateCollect[actState] = {}
              ;
              (table.insert)(activityStateCollect[actState], id)
              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  if activityStateCollect ~= nil then
    self:__DealStateCollect(activityStateCollect, true)
  end
end

ActivityFrameController.__DealStateCollect = function(self, activityStateCollect, needCallFunc)
  -- function num : 0_23 , upvalues : _ENV, ActivityFrameEnum
  for actState,ids in pairs(activityStateCollect) do
    do
      if actState == (ActivityFrameEnum.eActivityState).RewardState then
        local preFunc = (self.ActivityStateDelaFunc)[(ActivityFrameEnum.eActivityState).OpenState]
        if preFunc ~= nil then
          preFunc(ids, needCallFunc)
        else
          error("actStateFunction is NIL state is " .. tostring(actState))
        end
      end
      do
        local func = (self.ActivityStateDelaFunc)[actState]
        if func ~= nil then
          func(ids, needCallFunc)
        else
          error("actStateFunction is NIL state is " .. tostring(actState))
        end
        -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

ActivityFrameController.__DealCouldShowInfo = function(self, actInfo, isAdd)
  -- function num : 0_24
  local isCouldShow = actInfo:GetCouldShowActivity()
  if not isCouldShow then
    return 
  end
  if actInfo:GetActivityReddotNode() == nil then
    local enterTypeRedNode = self:__GetEnterReddot(actInfo.enterType, actInfo.actCat)
    if enterTypeRedNode ~= nil then
      local node = enterTypeRedNode:AddChild(actInfo:GetActivityFrameId())
      actInfo:SetActivityReddotForFrameCtrl(node)
    end
  end
  do
    local frameId = actInfo:GetActivityFrameId()
    local entryType = actInfo:GetEnterType()
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R6 in 'UnsetPending'

    if not (self._openEnteryDic)[entryType] then
      (self._openEnteryDic)[entryType] = {}
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._openEnteryDic)[entryType])[frameId] = true
      local actCat = actInfo:GetActivityFrameCat()
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R7 in 'UnsetPending'

      if not (self._openCatDic)[actCat] then
        (self._openCatDic)[actCat] = {}
        -- DECOMPILER ERROR at PC47: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self._openCatDic)[actCat])[frameId] = true
      end
    end
  end
end

ActivityFrameController.__DealCouldHideInfo = function(self, actInfo)
  -- function num : 0_25 , upvalues : _ENV
  local isCouldShow = actInfo:GetCouldShowActivity()
  if isCouldShow then
    return 
  end
  local curNode = actInfo:GetActivityReddotNode()
  if curNode ~= nil then
    curNode:RemoveFromParent()
    actInfo:SetActivityReddotForFrameCtrl(nil)
  end
  local frameId = actInfo:GetActivityFrameId()
  local entryType = actInfo:GetEnterType()
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  if (self._openEnteryDic)[entryType] ~= nil then
    ((self._openEnteryDic)[entryType])[frameId] = nil
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

    if (table.count)((self._openEnteryDic)[entryType]) == 0 then
      (self._openEnteryDic)[entryType] = nil
    end
  end
  local actCat = actInfo:GetActivityFrameCat()
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

  if (self._openCatDic)[actCat] ~= nil then
    ((self._openCatDic)[actCat])[frameId] = nil
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R7 in 'UnsetPending'

    if (table.count)((self._openCatDic)[actCat]) == 0 then
      (self._openCatDic)[actCat] = nil
    end
  end
end

ActivityFrameController.UpdateActivityDailyFlush = function(self)
  -- function num : 0_26 , upvalues : _ENV, ActivityDailyFlushFunc
  (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ActivityQuest_Detail(function()
    -- function num : 0_26_0 , upvalues : _ENV
    MsgCenter:Broadcast(eMsgEventId.ActivityTaskUpdate)
  end
)
  for cat,idDic in pairs(self._openCatDic) do
    if ActivityDailyFlushFunc[cat] ~= nil then
      (ActivityDailyFlushFunc[cat])(idDic, self)
    end
  end
end

ActivityFrameController.UpdateWechatActivityElems = function(self, datas, flag)
  -- function num : 0_27 , upvalues : _ENV, ActivityFrameEnum
  self.wechatActivityElems = datas
  for actId,elem in pairs(self.wechatActivityElems) do
    if elem.redeemed or (CS.ClientConsts).IsAudit then
      self:HideActivityByExtraLogic((ActivityFrameEnum.eActivityType).Tickets, actId)
    end
  end
end

ActivityFrameController.UpdateWechatActivityFollowed = function(self, actId, flag)
  -- function num : 0_28
  local elem = (self.wechatActivityElems)[actId]
  if elem ~= nil then
    elem.followed = flag
  end
end

ActivityFrameController.UpdateWechatActivityRedeemed = function(self, actId)
  -- function num : 0_29 , upvalues : ActivityFrameEnum
  local elem = (self.wechatActivityElems)[actId]
  if elem ~= nil then
    elem.redeemed = true
    self:HideActivityByExtraLogic((ActivityFrameEnum.eActivityType).Tickets, actId)
  end
end

ActivityFrameController.AddFakeSigninActivityData = function(self)
  -- function num : 0_30 , upvalues : ActivityFrameEnum, ActivityFrameData
  local fackId = (ActivityFrameEnum.eActiveityFakeId).dailySignIn
  if (self.AllActivityFrameDataDic)[fackId] == nil then
    local actData = (ActivityFrameData.CreateActivityFrameDataFromFakeData)({id = fackId, actCat = (ActivityFrameEnum.eActivityType).dailySignIn, actId = fackId, enterType = (ActivityFrameEnum.eActivityEnterType).LimitTime, order = 999})
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.AllActivityFrameDataDic)[fackId] = actData
    local actCat = actData:GetActivityFrameCat()
    local actId = actData:GetActId()
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

    if not (self.ActivityCatMapping)[actCat] then
      (self.ActivityCatMapping)[actCat] = {}
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ActivityCatMapping)[actCat])[actId] = fackId
      self:__OpenActivitys({fackId})
    end
  end
end

ActivityFrameController.GetExtraSectorStageFirstReward = function(self, sectorStageId)
  -- function num : 0_31 , upvalues : _ENV
  local actId = ((ConfigData.activity_reward).stageToActivityIdDic)[sectorStageId]
  if actId == nil then
    return nil, nil
  end
  local actInfo = self:GetActivityFrameData(actId)
  if actInfo == nil or actInfo:IsActivityRunningTimeout() then
    return nil, nil
  end
  local stageToActivityIdCfg = ((ConfigData.activity_reward)[actId])[sectorStageId]
  if stageToActivityIdCfg == nil then
    error(" activity_reward is Error  sectorId and activityId is" .. tostring(sectorStageId) .. "," .. tostring(actId))
    return nil, nil
  end
  return stageToActivityIdCfg.stage_first_reward_ids, stageToActivityIdCfg.stage_first_reward_nums
end

ActivityFrameController.TryResetActivityFinishTimeByType = function(self, actType, actId, startTm)
  -- function num : 0_32
  local activityFrameId = self:GetIdByActTypeAndActId(actType, actId)
  if activityFrameId == nil then
    return 
  end
  self:TryResetActivityFinishTimeByFrameId(activityFrameId, startTm)
end

ActivityFrameController.TryResetActivityFinishTimeByFrameId = function(self, actFrameId, startTm)
  -- function num : 0_33 , upvalues : _ENV
  local activityData = self:GetActivityFrameData(actFrameId)
  if activityData == nil then
    return 
  end
  local durationTm = activityData:GetDurationTmForFrameCtrl()
  if durationTm <= 0 then
    return 
  end
  local finishTm = startTm + durationTm
  activityData:ResetFinishTmForFrameCtrl(startTm, finishTm)
  local oldActState = activityData:GetActivityFrameState()
  local process = (self._processDic)[oldActState]
  if process ~= nil then
    for time,list in pairs(process) do
      if (table.contain)(list, actFrameId) then
        (table.removebyvalue)(list, actFrameId)
        break
      end
    end
    do
      self:__DealCouldHideInfo(activityData)
      activityData:SetForceOpenForFrameCtrl(true)
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self._lockActDic)[actFrameId] = nil
      local actState, isUnlock = self:__CalculateActivityState(activityData)
      local activityStateCollect = {}
      activityStateCollect[actState] = {}
      ;
      (table.insert)(activityStateCollect[actState], actFrameId)
      self:__DealStateCollect(activityStateCollect, false)
    end
  end
end

ActivityFrameController.UpdateAllTinyGame = function(self, msg)
  -- function num : 0_34 , upvalues : _ENV
  for _,singleMsg in pairs(msg.games) do
    self:UpdateSingleTinyGame(singleMsg)
  end
  for gameType,score in pairs(msg.cat2HighScore) do
    gameType = gameType - 1
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._tinyGameHighScore)[gameType] = score
  end
end

ActivityFrameController.UpdateSingleTinyGame = function(self, singleMsg)
  -- function num : 0_35 , upvalues : ActivityTinyGameData
  local uid = singleMsg.uid
  local data = (self._tinyGameDic)[uid]
  if data == nil then
    data = (ActivityTinyGameData.New)()
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._tinyGameDic)[uid] = data
  end
  data:UpdateTinyGameData(singleMsg)
end

ActivityFrameController.GetTinyGameData = function(self, tinyGameUid)
  -- function num : 0_36
  return (self._tinyGameDic)[tinyGameUid]
end

ActivityFrameController.GetTinyGameHistoryHighScore = function(self, gameType)
  -- function num : 0_37
  return (self._tinyGameHighScore)[gameType]
end

ActivityFrameController.GetTinyGameDataListByActFrameId = function(self, actFrameId)
  -- function num : 0_38 , upvalues : _ENV
  local tinyGameDataList = {}
  for tinyGameUid,data in pairs(self._tinyGameDic) do
    if data:GetTinyGameActFrameId() == actFrameId then
      (table.insert)(tinyGameDataList, data)
    end
  end
  return tinyGameDataList
end

ActivityFrameController.InitAllActDailyTaskData = function(self, msg)
  -- function num : 0_39 , upvalues : _ENV
  for k,v in pairs(msg.task) do
    self:AddActDailyTaskData(k, v)
  end
end

ActivityFrameController.AddActDailyTaskData = function(self, actFrameId, msg)
  -- function num : 0_40 , upvalues : ActDailyTaskData
  if self._actDailyTaskDataDic == nil then
    self._actDailyTaskDataDic = {}
  end
  if (self._actDailyTaskDataDic)[actFrameId] ~= nil then
    return 
  end
  local data = (ActDailyTaskData.New)()
  data:InitActDailyTask(actFrameId)
  data:SetActDailyTaskIds(msg.receiveDailyTask)
  data:SetActDailyExpireTime(msg.nextRefreshTime)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._actDailyTaskDataDic)[actFrameId] = data
end

ActivityFrameController.GetActDailyTaskData = function(self, actFrameId)
  -- function num : 0_41
  if self._actDailyTaskDataDic == nil then
    return nil
  end
  local taskData = (self._actDailyTaskDataDic)[actFrameId]
  return taskData
end

ActivityFrameController.AddActivityTech = function(self, techTreeData)
  -- function num : 0_42
  if self._actTreeDic == nil then
    self._actTreeDic = {}
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._actTreeDic)[techTreeData:GetTreeId()] = techTreeData
end

ActivityFrameController.GetActivityTech = function(self, techType)
  -- function num : 0_43
  if self._actTreeDic == nil then
    return nil
  end
  return (self._actTreeDic)[techType]
end

ActivityFrameController.__DeleteExpireActUserData = function(self)
  -- function num : 0_44 , upvalues : _ENV, ActivityFrameEnum
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local funcTable = {[(ActivityFrameEnum.eActivityType).Carnival] = userDataCache.TryDeleteCarnival, [(ActivityFrameEnum.eActivityType).DailyChallenge] = userDataCache.TryDeleteADCEnterTime, [(ActivityFrameEnum.eActivityType).SectorIII] = userDataCache.TryDeleteSum22Activity, [(ActivityFrameEnum.eActivityType).HeroGrow] = userDataCache.TryClearActivityHeroData, [(ActivityFrameEnum.eActivityType).Hallowmas] = userDataCache.TryClearHallowmas, [(ActivityFrameEnum.eActivityType).Comeback] = userDataCache.TryClearComebackPopLooked, [(ActivityFrameEnum.eActivityType).Spring] = userDataCache.TryClearSpring, [(ActivityFrameEnum.eActivityType).Winter23] = userDataCache.TryClearWinter23, [(ActivityFrameEnum.eActivityType).Invitation] = userDataCache.TryClearInvitationLooked, [(ActivityFrameEnum.eActivityType).EventWeeklyQA] = userDataCache.TryClearWeeklyQALooked, [(ActivityFrameEnum.eActivityType).EventAngelaGift] = userDataCache.TryClearAngelaGiftLooked}
  for type,func in pairs(funcTable) do
    if (self.ActivityCatMapping)[type] ~= nil then
      (funcTable[type])(userDataCache, (self.ActivityCatMapping)[type])
    end
  end
end

ActivityFrameController.AddActivityDataUpdateTimeListen = function(self, activityFrameId, time, callback)
  -- function num : 0_45 , upvalues : _ENV, CheckerTimeTypeTable, CheckerTimeEndTable
  if activityFrameId == nil or callback == nil then
    error(" activityFrameId or  callback is error")
    return 
  end
  if time <= PlayerDataCenter.timestamp then
    error(" time is error , frameId is:" .. tostring(activityFrameId))
    return 
  end
  if self._activityDataUpdateTimeListenDic == nil then
    self._activityDataUpdateTimeListenDic = {}
  end
  local timeFuncs = (self._activityDataUpdateTimeListenDic)[time]
  local activityDataUpdateTimeListenInfo = {activityFrameId = activityFrameId, callback = callback}
  if timeFuncs ~= nil then
    (table.insert)(timeFuncs, activityDataUpdateTimeListenInfo)
    return 
  end
  timeFuncs = {}
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._activityDataUpdateTimeListenDic)[time] = timeFuncs
  ;
  (table.insert)(timeFuncs, activityDataUpdateTimeListenInfo)
  if timeFuncs[100] ~= nil and isGameDev then
    error(" activity time func too many ")
  end
  ;
  (self._conditionListener):AddConditionChangeListener(-time, function()
    -- function num : 0_45_0 , upvalues : self, time
    self:__ApplyActivityDataUpdateTimeListen(time)
  end
, CheckerTimeTypeTable, {time}, CheckerTimeEndTable)
end

ActivityFrameController.__ApplyActivityDataUpdateTimeListen = function(self, time)
  -- function num : 0_46 , upvalues : _ENV
  (self._conditionListener):RemoveConditionChangeListener(-time)
  local timeFuncs = (self._activityDataUpdateTimeListenDic)[time]
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._activityDataUpdateTimeListenDic)[time] = nil
  for i,v in ipairs(timeFuncs) do
    local callback = v.callback
    local activityFrameId = v.activityFrameId
    local activityFrameData = (self.AllActivityFrameDataDic)[activityFrameId]
    if activityFrameData == nil or activityFrameData:IsActivityRunningTimeout() then
      return 
    end
    local endTime = activityFrameData:GetActivityEndTime()
    if endTime > -1 and endTime <= PlayerDataCenter.timestamp then
      return 
    end
    callback(activityFrameId)
  end
end

ActivityFrameController.OnDelete = function(self)
  -- function num : 0_47 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__BC_Listern2PreConditona)
  ;
  (self._conditionListener):Delete()
  self.AllActivityFrameDataDic = nil
  ;
  (base.OnDelete)(self)
end

return ActivityFrameController

