-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameNetworkCtrl = class("ActivityFrameNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
ActivityFrameNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.techRefreshMsg = {}
  self.techUpgradeMsg = {}
  self._singleConcreteInfo = {}
  self._techReset = {}
  self._tinyGame = {}
  self._actDungeonTable = {}
  self._techResetAll = {}
  self._singleTaskTable = {}
  self._tasklistTable = {}
  self._autoRefTask = {}
  self._manualRefTask = {}
  self._termRefTable = {}
end

ActivityFrameNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Detail, self, proto_csmsg.SC_ACTIVITY_Detail, self.SC_ACTIVITY_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Wechat_Follow_Take, self, proto_csmsg.SC_ACTIVITY_Wechat_Follow_Take, self.SC_ACTIVITY_Wechat_Follow_Take)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Wechat_Detail, self, proto_csmsg.SC_ACTIVITY_Wechat_Detail, self.SC_ACTIVITY_Wechat_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Wechat_Followed_NTF, self, proto_csmsg.SC_ACTIVITY_Wechat_Followed_NTF, self.SC_ACTIVITY_Wechat_Followed_NTF)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_ConcreteInfos, self, proto_csmsg.SC_ACTIVITY_ConcreteInfos, self.SC_ACTIVITY_ConcreteInfos)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SingleConcreteInfo, self, proto_csmsg.SC_ACTIVITY_SingleConcreteInfo, self.SC_ACTIVITY_SingleConcreteInfo)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityTech_Refresh, self, proto_csmsg.SC_ActivityTech_Refresh, self.SC_ActivityTech_Refresh)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityTech_Upgrade, self, proto_csmsg.SC_ActivityTech_Upgrade, self.SC_ActivityTech_Upgrade)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityQuest_Detail, self, proto_csmsg.SC_ActivityQuest_Detail, self.SC_ActivityQuest_Detail)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityTech_ResetBranch, self, proto_csmsg.SC_ActivityTech_ResetBranch, self.SC_ActivityTech_ResetBranch)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_TinyGame_Settle, self, proto_csmsg.SC_TinyGame_Settle, self.SC_TinyGame_Settle)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DUNGEON_GeneralEnter, self, proto_csmsg.SC_ACTIVITY_DUNGEON_GeneralEnter, self.SC_ACTIVITY_DUNGEON_GeneralEnter)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ActivityTech_ResetAll, self, proto_csmsg.SC_ActivityTech_ResetAll, self.SC_ActivityTech_ResetAll)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Quest_Select_Commit, self, proto_csmsg.SC_Activity_Quest_Select_Commit, self.SC_Activity_Quest_Select_Commit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_Activity_Quest_Commit, self, proto_csmsg.SC_Activity_Quest_Commit, self.SC_Activity_Quest_Commit)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_RefreshQuestDaily, self, proto_csmsg.SC_ACTIVITY_RefreshQuestDaily, self.SC_ACTIVITY_RefreshQuestDaily)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_RefreshSingleQuestByUser, self, proto_csmsg.SC_ACTIVITY_RefreshSingleQuestByUser, self.SC_ACTIVITY_RefreshSingleQuestByUser)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TermTask, self, proto_csmsg.SC_ACTIVITY_TermTask, self.SC_ACTIVITY_TermTask)
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_Detail = function(self, callback)
  -- function num : 0_2 , upvalues : _ENV
  self.__firstCallback = callback
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Detail, proto_csmsg.CS_ACTIVITY_Detail, table.emptytable)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_Detail = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  ;
  (ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)):UpdateActivity(msg.data)
  if self.__firstCallback ~= nil then
    (self.__firstCallback)()
    self.__firstCallback = nil
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_Wechat_Follow_Take = function(self, id, callback)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.id = id
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Wechat_Follow_Take, proto_csmsg.CS_ACTIVITY_Wechat_Follow_Take, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Wechat_Follow_Take, function()
    -- function num : 0_4_0 , upvalues : _ENV, id, callback
    local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
    actFrameCtr:UpdateWechatActivityRedeemed(id)
    callback()
  end
, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Wechat_Follow_Take)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_Wechat_Follow_Take = function(self, msg)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:ACTIVITY_Wechat_Follow_Take error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_SECTOR_Achievement)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_Wechat_Detail = function(self, ids, callback)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  local msg = {}
  msg.ids = ids
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Wechat_Detail, proto_csmsg.CS_ACTIVITY_Wechat_Detail, msg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_Wechat_Detail, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_Wechat_Detail)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_Wechat_Detail = function(self, msg)
  -- function num : 0_7 , upvalues : _ENV
  local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  actFrameCtr:UpdateWechatActivityElems(msg.data)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_Wechat_Followed_NTF = function(self, msg)
  -- function num : 0_8 , upvalues : _ENV
  local actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  actFrameCtr:UpdateWechatActivityFollowed(msg.id, true)
  MsgCenter:Broadcast(eMsgEventId.WechatUpdata)
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_ConcreteInfos = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_ConcreteInfos, proto_csmsg.CS_ACTIVITY_ConcreteInfos, table.emptytable)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_ConcreteInfos = function(self, msg)
  -- function num : 0_10 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.activityGeneralTasks ~= nil then
      local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
      actFrameCtrl:InitAllActDailyTaskData(msg.activityGeneralTasks)
    end
    do
      if msg.activtySectorHero ~= nil then
        local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
        heroGrowCtrl:UpdateHeroGrow(msg.activtySectorHero)
      end
      do
        if msg.activitySectorIIData ~= nil then
          local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
          if sectorIICtrl ~= nil then
            sectorIICtrl:UpdataSectorIIActivityByMsg(msg.activitySectorIIData)
          end
        end
        do
          if msg.activityValentine ~= nil then
            local whiteDayCtrl = ControllerManager:GetController(ControllerTypeId.WhiteDay, true)
            if whiteDayCtrl ~= nil then
              whiteDayCtrl:UpdateAllWhiteDayActivity(msg.activityValentine)
            end
          end
          do
            if msg.activityUserReturn ~= nil then
              local activityComebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback, true)
              if activityComebackCtrl ~= nil then
                activityComebackCtrl:AddComebackList(msg.activityUserReturn)
              end
            end
            do
              if msg.activityQuest ~= nil then
                local activityTaskCtrl = ControllerManager:GetController(ControllerTypeId.ActivityTask, true)
                if activityTaskCtrl ~= nil then
                  activityTaskCtrl:AddActivityTaskList(msg.activityQuest)
                end
              end
              do
                if msg.activityRound ~= nil then
                  local activityRoundCtrl = ControllerManager:GetController(ControllerTypeId.ActivityRound, true)
                  if activityRoundCtrl ~= nil then
                    activityRoundCtrl:AddRoundList(msg.activityRound)
                  end
                end
                do
                  if msg.activityRefreshDungeon ~= nil then
                    local refreshDunCtrl = ControllerManager:GetController(ControllerTypeId.ActRefreshDungeon)
                    if refreshDunCtrl ~= nil then
                      refreshDunCtrl:UpdateAllRefreshDunActivity(msg.activityRefreshDungeon)
                    end
                  end
                  do
                    if msg.activityCarnival ~= nil then
                      local carnivalCtrl = ControllerManager:GetController(ControllerTypeId.ActivityCarnival, true)
                      carnivalCtrl:InitAllCarnival(msg.activityCarnival)
                    end
                    do
                      if msg.tinyGameCenter ~= nil then
                        local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
                        activityFrameCtrl:UpdateAllTinyGame(msg.tinyGameCenter)
                      end
                      do
                        if msg.activityTinyGame ~= nil then
                          local historyTinyGameCtrl = ControllerManager:GetController(ControllerTypeId.HistoryTinyGameActivity, true)
                          historyTinyGameCtrl:UpdataSingleActivity(msg.activityTinyGame)
                        end
                        do
                          if msg.activityDailyChallenge ~= nil then
                            local adcCtrl = ControllerManager:GetController(ControllerTypeId.ActivityDailyChallenge, true)
                            adcCtrl:AddADC(msg.activityDailyChallenge)
                          end
                          do
                            if msg.activityAnnivSign ~= nil then
                              local signMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame, true)
                              signMiniGameCtrl:InitNetWrorkData(msg.activityAnnivSign)
                            end
                            do
                              if msg.activitySummer2022 ~= nil then
                                local sectorIIICtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII, true)
                                sectorIIICtrl:InitSectorIIIData(msg.activitySummer2022)
                              end
                              do
                                if msg.activityHalloween ~= nil then
                                  local hallowmasCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas, true)
                                  hallowmasCtrl:InitHallowmas(msg.activityHalloween)
                                end
                                do
                                  if msg.activitySpring ~= nil then
                                    local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring, true)
                                    springCtrl:AddSpring(msg.activitySpring)
                                  end
                                  do
                                    if msg.activityWinter23 ~= nil then
                                      local winter23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)
                                      winter23Ctrl:AddWinter23(msg.activityWinter23)
                                    end
                                    if msg.activityInvitation ~= nil then
                                      local invitationCtrl = ControllerManager:GetController(ControllerTypeId.ActivityInvitation, true)
                                      for i,v in ipairs(msg.activityInvitation) do
                                        invitationCtrl:AddInvitation(v)
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

ActivityFrameNetworkCtrl.CS_ACTIVITY_SingleConcreteInfo = function(self, actframeId, callback)
  -- function num : 0_11 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._singleConcreteInfo).id = actframeId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SingleConcreteInfo, proto_csmsg.CS_ACTIVITY_SingleConcreteInfo, self._singleConcreteInfo)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SingleConcreteInfo, function(args)
    -- function num : 0_11_0 , upvalues : _ENV, actframeId, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    do
      if msg.activityGeneralTask ~= nil then
        local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
        actFrameCtrl:AddActDailyTaskData(actframeId, msg.activityGeneralTask)
      end
      if callback ~= nil then
        callback(args)
      end
    end
  end
, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_SingleConcreteInfo)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_SingleConcreteInfo = function(self, msg)
  -- function num : 0_12 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_SingleConcreteInfo, msg)
end

ActivityFrameNetworkCtrl.CS_ActivityTech_Upgrade = function(self, actLongId, techId, callback)
  -- function num : 0_13 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.techUpgradeMsg).actLongId = actLongId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.techUpgradeMsg).techId = techId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Upgrade, proto_csmsg.CS_ActivityTech_Upgrade, self.techUpgradeMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Upgrade, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityTech_Upgrade)
end

ActivityFrameNetworkCtrl.SC_ActivityTech_Upgrade = function(self, msg)
  -- function num : 0_14 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= 0 then
      local err = "ActivityFrameNetworkCtrl:SC_ActivityTech_Upgrade error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Upgrade)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Upgrade, msg.techElem)
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityFrameNetworkCtrl.CS_ActivityTech_Refresh = function(self, actLongId, callback)
  -- function num : 0_15 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.techRefreshMsg).actLongId = actLongId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Refresh, proto_csmsg.CS_ActivityTech_Refresh, self.techRefreshMsg)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Refresh, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityTech_Refresh)
end

ActivityFrameNetworkCtrl.SC_ActivityTech_Refresh = function(self, msg)
  -- function num : 0_16 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= 0 then
    local err = "ActivityFrameNetworkCtrl:SC_ActivityTech_Refresh error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_Refresh)
    return 
  end
end

ActivityFrameNetworkCtrl.CS_ActivityTech_ResetBranch = function(self, actLongId, branchId, callback)
  -- function num : 0_17 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._techReset).actLongId = actLongId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._techReset).branchId = branchId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_ResetBranch, proto_csmsg.CS_ActivityTech_ResetBranch, self._techReset)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_ResetBranch, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityTech_ResetBranch)
end

ActivityFrameNetworkCtrl.SC_ActivityTech_ResetBranch = function(self, msg)
  -- function num : 0_18 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= 0 then
    local err = "ActivityFrameNetworkCtrl:SC_ActivityTech_ResetBranch error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
  end
end

ActivityFrameNetworkCtrl.CS_ActivityTech_ResetAll = function(self, actLongId, callback)
  -- function num : 0_19 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._techResetAll).actLongId = actLongId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_ResetAll, proto_csmsg.CS_ActivityTech_ResetAll, self._techResetAll)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityTech_ResetAll, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityTech_ResetAll)
end

ActivityFrameNetworkCtrl.SC_ActivityTech_ResetAll = function(self, msg)
  -- function num : 0_20 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= 0 then
    local err = "ActivityFrameNetworkCtrl:SC_ActivityTech_ResetAll error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
  end
end

ActivityFrameNetworkCtrl.ApplyActivityDiff = function(self, diffMsg)
  -- function num : 0_21
  -- DECOMPILER ERROR at PC8: Unhandled construct in 'MakeBoolean' P3

  if (diffMsg ~= nil and (diffMsg.update ~= nil)) then
  end
end

ActivityFrameNetworkCtrl.CS_ActivityQuest_Detail = function(self, callback)
  -- function num : 0_22 , upvalues : _ENV, cs_WaitNetworkResponse
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ActivityQuest_Detail, proto_csmsg.CS_ActivityQuest_Detail, table.emptytable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ActivityQuest_Detail, callback, proto_csmsg_MSG_ID.MSG_SC_ActivityQuest_Detail)
end

ActivityFrameNetworkCtrl.SC_ActivityQuest_Detail = function(self, msg)
  -- function num : 0_23 , upvalues : _ENV
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ActivityQuest_Detail error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

ActivityFrameNetworkCtrl.CS_TinyGame_Settle = function(self, uid, score, callback)
  -- function num : 0_24 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._tinyGame).uid = uid
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._tinyGame).score = score
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_TinyGame_Settle, proto_csmsg.CS_TinyGame_Settle, self._tinyGame)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_TinyGame_Settle, callback, proto_csmsg_MSG_ID.MSG_SC_TinyGame_Settle)
end

ActivityFrameNetworkCtrl.SC_TinyGame_Settle = function(self, msg)
  -- function num : 0_25 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_TinyGame_Settle error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
    activityFrameCtrl:UpdateSingleTinyGame(msg.game)
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_TinyGame_Settle, msg.game)
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_DUNGEON_GeneralEnter = function(self, dungeonId, formationData, buffDic, callback, isDouble)
  -- function num : 0_26 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R6 in 'UnsetPending'

  (self._actDungeonTable).dungeonId = dungeonId
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  if (self._actDungeonTable).formInfo == nil then
    (self._actDungeonTable).formInfo = {}
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._actDungeonTable).formInfo).formationId = formationData.id
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._actDungeonTable).formInfo).support = formationData:GetSupportHeroData()
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._actDungeonTable).buffGroup = buffDic
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._actDungeonTable).summerDouble = isDouble or false
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DUNGEON_GeneralEnter, proto_csmsg.CS_ACTIVITY_DUNGEON_GeneralEnter, self._actDungeonTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_DUNGEON_GeneralEnter, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_DUNGEON_GeneralEnter, proto_csmsg_MSG_ID.MSG_SC_BATTLE_NtfEnter)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_DUNGEON_GeneralEnter = function(self, msg)
  -- function num : 0_27 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_DUNGEON_GeneralEnter error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    return 
  end
end

ActivityFrameNetworkCtrl.CS_Activity_Quest_Commit = function(self, id, questId, callback)
  -- function num : 0_28 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._singleTaskTable).id = id
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._singleTaskTable).questId = questId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Commit, proto_csmsg.CS_Activity_Quest_Commit, self._singleTaskTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Commit, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Quest_Commit)
end

ActivityFrameNetworkCtrl.SC_Activity_Quest_Commit = function(self, msg)
  -- function num : 0_29 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_Activity_Quest_Commit error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Commit)
    return 
  end
end

ActivityFrameNetworkCtrl.CS_Activity_Quest_Select_Commit = function(self, actLongId, taskids, callback)
  -- function num : 0_30 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._tasklistTable).actLongId = actLongId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._tasklistTable).questIds = taskids
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Select_Commit, proto_csmsg.CS_Activity_Quest_Select_Commit, self._tasklistTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Select_Commit, callback, proto_csmsg_MSG_ID.MSG_SC_Activity_Quest_Select_Commit)
end

ActivityFrameNetworkCtrl.SC_Activity_Quest_Select_Commit = function(self, msg)
  -- function num : 0_31 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_Activity_Quest_Select_Commit error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_Activity_Quest_Select_Commit)
      return 
    end
    ;
    (UIUtil.ShowCommonReward)(msg.rewards)
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_RefreshQuestDaily = function(self, actLongId, callback)
  -- function num : 0_32 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._autoRefTask).actLongId = actLongId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshQuestDaily, proto_csmsg.CS_ACTIVITY_RefreshQuestDaily, self._autoRefTask)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshQuestDaily, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_RefreshQuestDaily)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_RefreshQuestDaily = function(self, msg)
  -- function num : 0_33 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_RefreshQuestDaily error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshQuestDaily)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshQuestDaily, msg)
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_RefreshSingleQuestByUser = function(self, actLongId, taskId, callback)
  -- function num : 0_34 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self._manualRefTask).actLongId = actLongId
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self._manualRefTask).taskId = taskId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshSingleQuestByUser, proto_csmsg.CS_ACTIVITY_RefreshSingleQuestByUser, self._manualRefTask)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshSingleQuestByUser, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_RefreshSingleQuestByUser)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_RefreshSingleQuestByUser = function(self, msg)
  -- function num : 0_35 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_ACTIVITY_RefreshSingleQuestByUser error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshSingleQuestByUser)
      return 
    end
    cs_WaitNetworkResponse:AddWaitData(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_RefreshSingleQuestByUser, msg.newTaskId)
  end
end

ActivityFrameNetworkCtrl.CS_ACTIVITY_TermTask = function(self, actLongId, callback)
  -- function num : 0_36 , upvalues : _ENV, cs_WaitNetworkResponse
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self._termRefTable).actLongId = actLongId
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TermTask, proto_csmsg.CS_ACTIVITY_TermTask, self._termRefTable)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TermTask, callback, proto_csmsg_MSG_ID.MSG_SC_ACTIVITY_TermTask)
end

ActivityFrameNetworkCtrl.SC_ACTIVITY_TermTask = function(self, msg)
  -- function num : 0_37 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "SC_ACTIVITY_TermTask error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
    cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_ACTIVITY_TermTask)
    return 
  end
end

ActivityFrameNetworkCtrl.Reset = function(self)
  -- function num : 0_38
end

return ActivityFrameNetworkCtrl

