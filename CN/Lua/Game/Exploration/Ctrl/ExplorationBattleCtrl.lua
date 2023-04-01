-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonBattleBaseCtrl = require("Game.Common.CommonGameCtrl.DungeonBattleBaseCtrl")
local ExplorationBattleCtrl = class("ExplorationBattleCtrl", DungeonBattleBaseCtrl)
local base = DungeonBattleBaseCtrl
local CS_BattleManager_Ins = (CS.BattleManager).Instance
local CS_eBattleState = CS.eBattleState
local cs_MessageCommon = CS.MessageCommon
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
local cs_BattleStatistics = (CS.BattleStatistics).Instance
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local util = require("XLua.Common.xlua_util")
local EpGuideUtil = require("Game.Exploration.Util.EpGuideUtil")
local BattleCustomMoveCtrl = require("Game.BattleCustomMove.BattleCustomMoveCtrl")
local startBattleType = {normal = 1, ambush = 2}
ExplorationBattleCtrl.ctor = function(self, epCtrl)
  -- function num : 0_0 , upvalues : _ENV, startBattleType, BattleCustomMoveCtrl
  self.epCtrl = epCtrl
  ;
  (table.insert)((self.epCtrl).ctrls, self)
  self.__OnTimelineNoticeOpenResultUI = BindCallback(self, self.OnTimelineNoticeOpenResultUI)
  MsgCenter:AddListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
  self.startBattleType = startBattleType.normal
  self.__curStateId = -1
  self.__battleCount = 0
  self.__closeReload = false
  self.__waitSelectChip = nil
  self.__waitSettleResult = nil
  self.__settleTimelinePause = nil
  self.__loadedBattleObj = false
  self.canShowNewEnemyDetail = true
  self._isInTd = ExplorationManager:IsInTDExp()
  if (BattleUtil.IsInBrotatBattle)() then
    self.CustomMoveCtrl = (BattleCustomMoveCtrl.CreateCustomMoveCtrl)(btlMgr)
  end
end

ExplorationBattleCtrl.IsBattleState = function(self, state)
  -- function num : 0_1
  do return self.__curStateId == state end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ExplorationBattleCtrl.IsBattleBeforeRunning = function(self)
  -- function num : 0_2 , upvalues : _ENV
  do return self.__curStateId <= eBattleState.Deploy end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ExplorationBattleCtrl.StartNewEpBattle = function(self, roomData, dynPlayer)
  -- function num : 0_3 , upvalues : _ENV, DeployTeamUtil, ExplorationEnum, EpGuideUtil, CS_BattleManager_Ins
  self.__roomData = roomData
  self:__OnEnterBattleScene(roomData)
  MsgCenter:Broadcast(eMsgEventId.BeforeNewEpBattle, roomData)
  if not self._isInTd then
    local autoRunning = ((self.epCtrl).autoCtrl):IsAutoModeRunning()
    local dynPlayer = ExplorationManager:GetDynPlayer()
    local size_row, size_col, deploy_rows = ExplorationManager:GetEpSceneBattleFieldSize()
    ;
    (DeployTeamUtil.AutoBattleDeploy)(roomData, dynPlayer.heroList, size_row, size_col, deploy_rows, autoRunning)
  end
  do
    local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).BeforeNewEpBattle)
    if actionList ~= nil and #actionList > 0 then
      (EpGuideUtil.ExecuteEpGuideActions)(actionList, 0)
    end
    self.__battleCount = 0
    local csbattleCtrl = CS_BattleManager_Ins:StartNewBattle(roomData, dynPlayer, self)
    return csbattleCtrl
  end
end

ExplorationBattleCtrl.__OnEnterBattleScene = function(self, roomData)
  -- function num : 0_4 , upvalues : _ENV
  self.needShowEpBuff = false
  if not roomData:IsDeployRoom() and not ExplorationManager:IsSectorNewbee() then
    self.needShowEpBuff = true
  end
end

ExplorationBattleCtrl.SetCanShowNewEnemyDetail = function(self, bool)
  -- function num : 0_5
  self.canShowNewEnemyDetail = bool
end

ExplorationBattleCtrl.AutoShowNewEnemyDetail = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if ExplorationManager:IsSectorNewbee() or self.battleCtrl == nil then
    return false
  end
  local haveNew = false
  if not self.isDeployRoom and self.canShowNewEnemyDetail then
    local isFirsh = true
    for i = 0, (((self.battleCtrl).EnemyTeamController).battleOriginRoleList).Count - 1 do
      local enemy = (((self.battleCtrl).EnemyTeamController).battleOriginRoleList)[i]
      if PlayerDataCenter:IsNewEnemy(enemy.roleDataId) then
        (enemy.battleRoleView):ShowNewArrow(true)
        PlayerDataCenter:AddOldEnemy(enemy.roleDataId)
        if isFirsh then
          (self.battleCtrl):BroadCaseSelectRole(enemy)
          isFirsh = false
          haveNew = true
        end
      end
    end
  end
  do
    return haveNew
  end
end

ExplorationBattleCtrl.__TryAutoShowNewEnemyDetail = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self:AutoShowNewEnemyDetail() then
    self.hasNewEnemyDetail = true
  end
  if GuideManager:TryTriggerGuide(eGuideCondition.InNewMonsterDetail) then
  end
end

ExplorationBattleCtrl.IsCloseReloadSupport = function(self)
  -- function num : 0_8
  return self.__closeReload
end

ExplorationBattleCtrl.SetCloseReloadSupport = function(self, value)
  -- function num : 0_9
  self.__closeReload = value
end

ExplorationBattleCtrl.OnBattleStateChange = function(self, battleCtrl, stateId, isDeployRoom)
  -- function num : 0_10 , upvalues : _ENV, ExplorationEnum, EpGuideUtil
  self.battleCtrl = battleCtrl
  self.__curStateId = stateId
  self.isDeployRoom = isDeployRoom
  if stateId == eBattleState.Init then
    if ((self.epCtrl).autoCtrl):IsAutoModeRunning() and not isDeployRoom then
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetIsAutoBattle(true)
      ;
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetBattleSpeed(2)
    end
    self.__battleCount = self.__battleCount + 1
    do
      if self.__battleCount > 1 and ((self.epCtrl).overclockCtrl):IsLevelHasOverclock() then
        local battleWindow = UIManager:GetWindow(UIWindowTypeID.Battle)
        if battleWindow ~= nil then
          battleWindow:SetOverclockHighlight(not ((self.epCtrl).overclockCtrl):IsUseClockLimit())
        end
      end
      local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).BattleUltFull)
      if actionList ~= nil then
        self.__ultFullActions = actionList
        self.__ultFullCount = 0
        self.__OnEpBattleUpdateUltSkill = BindCallback(self, self.OnEpBattleUpdateUltSkill)
        MsgCenter:AddListener(eMsgEventId.OnBattleUpdateUltSkill, self.__OnEpBattleUpdateUltSkill)
        self.__OnBattleAfterUltSkilPlay = BindCallback(self, self.OnBattleAfterUltSkilPlay)
        MsgCenter:AddListener(eMsgEventId.OnBattleAfterUltSkilPlay, self.__OnBattleAfterUltSkilPlay)
      end
      do
        local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).AfterRoleDead)
        if actionList ~= nil then
          self.__OnEpAfterRoleDead = BindCallback(self, self.OnEpAfterRoleDead)
          battleCtrl:onCharacterDead("+", self.__OnEpAfterRoleDead)
        end
        if stateId == eBattleState.Deploy then
          self:ShowRandomBeforeRandomUI(isDeployRoom)
          if not ((self.epCtrl).autoCtrl):IsAutoModeRunning() and GuideManager:TryTriggerGuide(eGuideCondition.InBattleDeploy) then
            GuideManager:SetEndAction(function()
    -- function num : 0_10_0 , upvalues : self
    self:__TryAutoShowNewEnemyDetail()
  end
)
          else
            self:__TryAutoShowNewEnemyDetail()
          end
          if not isDeployRoom then
            ((self.epCtrl).campFetterCtrl):OnEpBattleDeploy()
          end
          if self.__loadedBattleObj then
            self:__OnEpBattleLoadReady()
          end
          local win = UIManager:GetWindow(UIWindowTypeID.EpChipSuit)
          if win ~= nil and not win.active then
            win:Show()
          end
          local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).BattleDeployState)
          if actionList ~= nil and #actionList > 0 then
            (EpGuideUtil.ExecuteEpGuideActions)(actionList, self:GetEpBattleCount() - 1)
          end
        else
        end
        do
          if (stateId == eBattleState.Running and stateId ~= eBattleState.End) or stateId == eBattleState.Delete then
            self.__loadedBattleObj = false
            self.__curStateId = -1
            self.hasNewEnemyDetail = false
            self.__closeReload = false
            self.battleCtrl = nil
            self.__ultFullCount = 0
            if self.__OnEpBattleUpdateUltSkill ~= nil then
              self.__ultFullActions = nil
              MsgCenter:RemoveListener(eMsgEventId.OnBattleUpdateUltSkill, self.__OnEpBattleUpdateUltSkill)
              MsgCenter:RemoveListener(eMsgEventId.OnBattleAfterUltSkilPlay, self.__OnBattleAfterUltSkilPlay)
            end
            if self.__OnEpAfterRoleDead ~= nil then
              battleCtrl:onCharacterDead("-", self.__OnEpAfterRoleDead)
              self.__OnEpAfterRoleDead = nil
            end
          end
        end
      end
    end
  end
end

ExplorationBattleCtrl.OnBattleObjectLoadComplete = function(self, battleController)
  -- function num : 0_11 , upvalues : _ENV
  self.__loadedBattleObj = true
  if self.__curStateId == eBattleState.Deploy then
    self:__OnEpBattleLoadReady()
  end
end

ExplorationBattleCtrl.__OnEpBattleLoadReady = function(self)
  -- function num : 0_12 , upvalues : _ENV, ExplorationEnum, EpGuideUtil
  local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).ReayBattle)
  if actionList ~= nil and #actionList > 0 then
    (EpGuideUtil.ExecuteEpGuideActions)(actionList, self:GetEpBattleCount() - 1)
  end
  MsgCenter:Broadcast(eMsgEventId.OnBattleReady)
end

ExplorationBattleCtrl.OnEpBattleUpdateUltSkill = function(self, useEnable, curRatio, factor)
  -- function num : 0_13 , upvalues : EpGuideUtil
  if self.__ultSkillUseEnable == useEnable then
    return 
  end
  self.__ultSkillUseEnable = useEnable
  if useEnable and self.__ultFullActions then
    (EpGuideUtil.ExecuteEpGuideActions)(self.__ultFullActions, self:GetEpBattleCount() - 1)
  end
end

ExplorationBattleCtrl.OnBattleAfterUltSkilPlay = function(self, currentSkill, curHeroEntity)
  -- function num : 0_14 , upvalues : EpGuideUtil
  self.__ultFullCount = self.__ultFullCount + 1
  if self.__ultSkillUseEnable and self.__ultFullActions then
    (EpGuideUtil.ExecuteEpGuideActions)(self.__ultFullActions, self:GetEpBattleCount() - 1)
  end
end

ExplorationBattleCtrl.OnEpAfterRoleDead = function(self, role)
  -- function num : 0_15 , upvalues : _ENV, ExplorationEnum, EpGuideUtil
  local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).AfterRoleDead)
  if actionList ~= nil then
    for _,guideAction in pairs(actionList) do
      if guideAction.action_delay == role.roleDataId then
        (EpGuideUtil.ExecuteEpGuideActionOne)(guideAction, self:GetEpBattleCount() - 1)
      end
    end
  end
end

ExplorationBattleCtrl.GetEpBattleUltFullCount = function(self)
  -- function num : 0_16
  return self.__ultFullCount or 0
end

ExplorationBattleCtrl.GetEpBattleCount = function(self)
  -- function num : 0_17
  return self.__battleCount or 0
end

ExplorationBattleCtrl.OnBattleStart = function(self, battleCtrl)
  -- function num : 0_18 , upvalues : _ENV, ExplorationEnum, EpGuideUtil, DungeonBattleBaseCtrl
  local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).StartBattleDelay)
  if actionList ~= nil and #actionList > 0 then
    for _,guideAction in pairs(actionList) do
      do
        if guideAction.action_delay > 0 then
          LuaSkillCtrl:GetTimer(guideAction.action_delay, function()
    -- function num : 0_18_0 , upvalues : EpGuideUtil, guideAction, self
    (EpGuideUtil.ExecuteEpGuideActionOne)(guideAction, self:GetEpBattleCount() - 1)
  end
)
        else
          ;
          (EpGuideUtil.ExecuteEpGuideActionOne)(guideAction, self:GetEpBattleCount() - 1)
        end
      end
    end
  end
  do
    if self.CustomMoveCtrl ~= nil then
      (self.CustomMoveCtrl):BeginCustomControl(battleCtrl)
    end
    ;
    (DungeonBattleBaseCtrl.OnBattleStart)(self, battleCtrl)
  end
end

ExplorationBattleCtrl.ReadyEnterBattleRunning = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if not self.__loadedBattleObj or self.__curStateId ~= eBattleState.Deploy or self.battleCtrl == nil then
    return false
  end
  return true
end

ExplorationBattleCtrl.EnterEpBattleRunning = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if not self:ReadyEnterBattleRunning() then
    return 
  end
  local battleWindow = UIManager:GetWindow(UIWindowTypeID.Battle)
  if battleWindow ~= nil then
    battleWindow:RealStartBattle()
    return 
  end
  ;
  (((self.battleCtrl).fsm).currentState):StartBattle()
end

ExplorationBattleCtrl.ShowRandomBeforeRandomUI = function(self, isDeployRoom)
  -- function num : 0_21
  return 
end

ExplorationBattleCtrl.GetEffectPoolCtrl = function(self)
  -- function num : 0_22
  return ((self.epCtrl).sceneCtrl).effectPoolCtrl
end

ExplorationBattleCtrl.GetRoleAppearEffect = function(self)
  -- function num : 0_23
  return ((self.epCtrl).sceneCtrl):GetRoleAppearEffect()
end

ExplorationBattleCtrl.GetRoleDisappearEffect = function(self)
  -- function num : 0_24
  return ((self.epCtrl).sceneCtrl):GetRoleDisappearEffect()
end

ExplorationBattleCtrl.SetAmbush = function(self, bool)
  -- function num : 0_25 , upvalues : _ENV, startBattleType
  if bool then
    local win = UIManager:GetWindow(UIWindowTypeID.Battle)
    win:ChangeStartBattleBtnText(1)
    self.startBattleType = startBattleType.ambush
  else
    do
      local win = UIManager:GetWindow(UIWindowTypeID.Battle)
      win:ChangeStartBattleBtnText(0)
      self.startBattleType = startBattleType.normal
    end
  end
end

ExplorationBattleCtrl.SetSneak = function(self)
  -- function num : 0_26 , upvalues : CS_eBattleState, CS_BattleManager_Ins, _ENV
  ((self.battleCtrl).fsm):ChangeState(CS_eBattleState.End)
  CS_BattleManager_Ins:ForceExitBattle()
  ;
  (ExplorationManager.epCtrl):__EnterExplorationScene(2)
end

ExplorationBattleCtrl.GetHeroObjectDic = function(self)
  -- function num : 0_27
  return ((self.epCtrl).sceneCtrl).heroObjectDic
end

ExplorationBattleCtrl.BattleLoadReady = function(self, battleController)
  -- function num : 0_28
  if self.needShowEpBuff then
    self:__ShowEpBuff(battleController.BattleRoomData)
    self.needShowEpBuff = false
  end
end

ExplorationBattleCtrl.__ShowEpBuff = function(self, roomData)
  -- function num : 0_29 , upvalues : _ENV
  local epBuffCfgList = roomData:GetEpBuffEffective((self.epCtrl).dynPlayer)
  if epBuffCfgList ~= nil and #epBuffCfgList > 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffShow, function(window)
    -- function num : 0_29_0 , upvalues : epBuffCfgList
    if window == nil then
      return 
    end
    window:InitEpBuffShow(epBuffCfgList)
  end
)
  end
end

ExplorationBattleCtrl._ShowWeeklyBossResult = function(self, battleEndState, evenId, dealBattleEndEventFunc)
  -- function num : 0_30 , upvalues : cs_BattleStatistics, _ENV, DungeonBattleBaseCtrl
  local combatStatStaticData = cs_BattleStatistics.combatStatStaticData
  local ok, unlimitedBossHp = (combatStatStaticData.TotalRecord):TryGetValue(proto_object_CombatStatKey.CombatStatUnlimitedBoss)
  if not ok then
    unlimitedBossHp = 0
  end
  local tdHpPerDic = nil
  if (BattleUtil.IsInTDBattle)() then
    tdHpPerDic = ((self.epCtrl).dynPlayer).dungeonRoleHpPerDic
  end
  local resultTab = {}
  local csBtCtrl = battleEndState.battleController
  local bossCharaEntity = nil
  if (BattleUtil.IsInTDBattle)() then
    local dynMon = ((csBtCtrl.CurBattleMapCfg).waitToCasterMonsterList)[(csBtCtrl.CurBattleMapCfg).BossIndex]
    local bossUid = (dynMon ~= nil and dynMon.uid)
    if bossUid ~= nil then
      for i = 0, ((csBtCtrl.EnemyTeamController).battleRoleList).Count - 1 do
        local entity = ((csBtCtrl.EnemyTeamController).battleRoleList)[i]
        if entity.uid == bossUid then
          bossCharaEntity = entity
          break
        end
      end
      if bossCharaEntity == nil then
        for i = 0, ((csBtCtrl.EnemyTeamController).deadbattleCharacterList).Count - 1 do
          local entity = ((csBtCtrl.EnemyTeamController).deadbattleCharacterList)[i]
          if entity.uid == bossUid then
            bossCharaEntity = entity
            break
          end
        end
      end
    end
  else
    bossCharaEntity = ((csBtCtrl.EnemyTeamController).battleOriginRoleList)[(csBtCtrl.CurBattleMapCfg).BossIndex]
  end
  if bossCharaEntity ~= nil then
    resultTab.bossName = bossCharaEntity.name
    resultTab.bossCurHp = bossCharaEntity.hp
    resultTab.bossMaxHp = bossCharaEntity.maxHp
  end
  local battleFrame = csBtCtrl.frame
  resultTab.battleCurSecond = (BattleUtil.FrameToTime)(battleFrame)
  resultTab.battleAllSecond = (BattleUtil.FrameToTime)(cs_BattleStatistics.battleLimitFrame)
  UIManager:ShowWindowAsync(UIWindowTypeID.PeriodicBattleBossResult, function(win)
    -- function num : 0_30_0
    if win == nil then
      return 
    end
    win:Hide()
  end
)
  local score = {}
  for k,v in pairs(csBtCtrl.gameScore) do
    score[k] = v
  end
  local isWin = evenId == (DungeonBattleBaseCtrl.eBattleEndType).Victory
  cs_BattleStatistics:RecordBattleTime(battleFrame, csBtCtrl.CrazyTime, isWin)
  local combatStatDic = {}
  for k,v in pairs(combatStatStaticData.TotalRecord) do
    combatStatDic[k] = v
  end
  local valid = {}
  valid.score = score
  valid.combatStat = combatStatDic
  valid.activeAlgConsume = self:GetBattleConsumeSkillChipUseTimeDic(csBtCtrl.PlayerController)
  ;
  ((self.epCtrl).epNetwork):CS_WEEKLYCHALLENGE_ScorePreview(valid, tdHpPerDic, function(objList)
    -- function num : 0_30_1 , upvalues : _ENV, resultTab, dealBattleEndEventFunc, battleEndState, csBtCtrl
    if objList.Count ~= 1 then
      error("objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    resultTab.score = msg.score
    UIManager:ShowWindowAsync(UIWindowTypeID.PeriodicBattleBossResult, function(win)
      -- function num : 0_30_1_0 , upvalues : resultTab, dealBattleEndEventFunc, battleEndState, _ENV, csBtCtrl
      if win == nil then
        return 
      end
      win:InitPeriodicBattleBossResult(resultTab, dealBattleEndEventFunc, function()
        -- function num : 0_30_1_0_0 , upvalues : battleEndState
        battleEndState:RestartBattle()
      end
, function()
        -- function num : 0_30_1_0_1 , upvalues : win, _ENV, csBtCtrl
        win:Hide()
        ;
        (BattleUtil.ShowBattleResultSkada)(csBtCtrl, function()
          -- function num : 0_30_1_0_1_0 , upvalues : win
          win:Show()
        end
)
      end
)
    end
)
  end
)
  -- DECOMPILER ERROR: 11 unprocessed JMP targets
end

ExplorationBattleCtrl.OnBattleEnd = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_31 , upvalues : _ENV, DungeonBattleBaseCtrl, ExplorationEnum, EpGuideUtil, cs_MessageCommon
  if self.CustomMoveCtrl ~= nil then
    (self.CustomMoveCtrl):EndCustomControl(battleEndState.battleController)
  end
  if ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge and (evenId == (DungeonBattleBaseCtrl.eBattleEndType).Victory or evenId == (DungeonBattleBaseCtrl.eBattleEndType).Failure) and ((self.epCtrl):GetCurrentRoomData()):GetIsInBigBossRoom() then
    self:_ShowWeeklyBossResult(battleEndState, evenId, function()
    -- function num : 0_31_0 , upvalues : dealBattleEndEvent, evenId
    dealBattleEndEvent(evenId)
  end
)
    return 
  end
  if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Failure then
    ((self.epCtrl).autoCtrl):BreakAutoModeForce()
    ;
    ((self.epCtrl).autoCtrl):DisableEpAutoMode()
    local actionList = ExplorationManager:GetEpGuideActionList((self.__roomData).x, (ExplorationEnum.epGuideMomentType).FailBattleRestart)
    if actionList ~= nil and #actionList > 0 then
      battleEndState:RestartBattle()
      ;
      (EpGuideUtil.ExecuteEpGuideActions)(actionList, self:GetEpBattleCount() - 1)
      return 
    end
    if ExplorationManager:GetEpModuleId() == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge then
      local contentNum = 286
      ;
      (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(contentNum), function()
    -- function num : 0_31_1 , upvalues : battleEndState
    battleEndState:RestartBattle()
  end
, function()
    -- function num : 0_31_2 , upvalues : dealBattleEndEvent, evenId
    dealBattleEndEvent(evenId)
  end
)
    else
      do
        do
          local lastTime = self:GetEpBattleLastCount()
          if lastTime > 0 then
            UIManager:ShowWindowAsync(UIWindowTypeID.BattleFail, function(win)
    -- function num : 0_31_3 , upvalues : dealBattleEndEvent, evenId, self, battleEndState, _ENV
    win:InitBattleFail(function()
      -- function num : 0_31_3_0 , upvalues : dealBattleEndEvent, evenId
      dealBattleEndEvent(evenId)
    end
, function()
      -- function num : 0_31_3_1 , upvalues : self, battleEndState
      ((self.epCtrl).epNetwork):CS_EXPLORATION_BATTLE_Restart(function(dataList)
        -- function num : 0_31_3_1_0 , upvalues : battleEndState
        battleEndState:RestartBattle()
      end
)
    end
, function()
      -- function num : 0_31_3_2 , upvalues : win, _ENV, battleEndState
      win:Hide()
      ;
      (BattleUtil.ShowBattleResultSkada)(battleEndState.battleController, function()
        -- function num : 0_31_3_2_0 , upvalues : win
        win:SetIgnoreDelayFlagOnce(true)
        win:Show()
      end
)
    end
)
  end
)
          else
            dealBattleEndEvent(evenId)
          end
          if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Restart then
            ((self.epCtrl).autoCtrl):BreakAutoModeForce()
            ;
            ((self.epCtrl).autoCtrl):DisableEpAutoMode()
          end
          if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Victory and ((self.epCtrl).autoCtrl):IsAutoModeRunning() then
            local battleCtrl = battleEndState.battleController
            local roomData = battleCtrl.BattleRoomData
            if not roomData:IsBossRoom() then
              local count = 0
              local deadCount = 0
              local totalHpRatio = 0
              local roleList = (battleCtrl.PlayerTeamController).battleOriginRoleList
              local len = roleList.Count
              for i = 0, len - 1 do
                local role = roleList[i]
                if not role.roleOnBench then
                  if role.isDead then
                    deadCount = deadCount + 1
                  end
                  count = count + 1
                  local hpPer = role.hp / role.maxHp * 100
                  totalHpRatio = totalHpRatio + hpPer
                end
              end
              local avgHpRatio = 0
              if count > 0 then
                avgHpRatio = (totalHpRatio) / (count)
              end
              if ((ConfigData.game_config).epAutoBattleJudge)[1] <= deadCount or avgHpRatio <= ((ConfigData.game_config).epAutoBattleJudge)[2] then
                (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(1201), function()
    -- function num : 0_31_4 , upvalues : self, battleEndState
    ((self.epCtrl).autoCtrl):BreakAutoModeForce()
    ;
    ((self.epCtrl).autoCtrl):DisableEpAutoMode()
    battleEndState:RestartBattle()
  end
, function()
    -- function num : 0_31_5 , upvalues : dealBattleEndEvent, evenId
    dealBattleEndEvent(evenId)
  end
)
                return 
              end
            end
          end
          do
            dealBattleEndEvent(evenId)
          end
        end
      end
    end
  end
end

ExplorationBattleCtrl.ReqStartBattle = function(self, battleRoomData, originRoleList, battleAction)
  -- function num : 0_32 , upvalues : _ENV, startBattleType, base
  battleRoomData:InitEpBuffEffective(nil)
  local position = battleRoomData.position
  local roleCount = originRoleList.Count
  local sendMsg = {}
  sendMsg.position = position
  sendMsg.data = {}
  for i = 0, roleCount - 1 do
    local role = originRoleList[i]
    local heroId = (((self.epCtrl).dynPlayer):GetDynHeroByDataId(role.roleDataId)).uid
    local pos = (BattleUtil.XYCoord2Pos)(role.x, role.y)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (sendMsg.data)[heroId] = pos
  end
  if self.startBattleType == startBattleType.normal then
    ((self.epCtrl).epNetwork):CS_EXPLORATION_BATTLE_Start(sendMsg, function(dataList)
    -- function num : 0_32_0 , upvalues : battleAction, self, base, battleRoomData, originRoleList, _ENV
    if battleAction ~= nil then
      local randomSeed = 0
      do
        do
          if dataList ~= nil and dataList.Count > 0 then
            local msg = dataList[0]
            randomSeed = msg.seed
            self.__restartCount = msg.times
          end
          battleAction(randomSeed)
          ;
          (base.ReqStartBattle)(self, battleRoomData, originRoleList, battleAction)
          MsgCenter:Broadcast(eMsgEventId.OnEnterBattle)
        end
      end
    end
  end
)
  else
    if self.startBattleType == startBattleType.ambush then
      ((self.epCtrl).epNetwork):CS_EXPLORATION_BATTLE_Ambush(sendMsg, function(dataList)
    -- function num : 0_32_1 , upvalues : battleAction, base, self, battleRoomData, originRoleList, startBattleType
    do
      if battleAction ~= nil then
        local randomSeed = 0
        if dataList ~= nil and dataList.Count > 0 then
          randomSeed = dataList[0]
        end
        battleAction(randomSeed)
        ;
        (base.ReqStartBattle)(self, battleRoomData, originRoleList, battleAction)
      end
      self.startBattleType = startBattleType.normal
    end
  end
)
    end
  end
end

ExplorationBattleCtrl.ReqBattleSettle = function(self, battleEndState, requestData)
  -- function num : 0_33 , upvalues : _ENV, cs_BattleStatistics
  ((self.epCtrl).autoCtrl):OnAutoStageOver()
  local playerRoleSettle = requestData.playerRoleSettle
  local monsterRoleSettle = requestData.monsterRoleSettle
  local battleCtrl = battleEndState.battleController
  local battlePlayerController = battleCtrl.PlayerController
  local position = (battleCtrl.BattleRoomData).position
  local dynPlayer = battleCtrl.PlayerData
  local sendMsg = {}
  local win = battleEndState.win
  local isWCLastBoss = (battleCtrl.BattleRoomData):GetIsInBigBossRoom()
  sendMsg.position = position
  sendMsg.mp = dynPlayer.playerSkillMp
  sendMsg.hmp = dynPlayer.playerUltSkillMp
  sendMsg.tdmp = dynPlayer.playerTDMp or 0
  sendMsg.win = win or isWCLastBoss
  sendMsg.charHpPer = {}
  sendMsg.monsterHpPer = {}
  sendMsg.misc = self:CreateBattleSettleMisc(battleCtrl)
  sendMsg.valid = self:CreateBattleSettleValid(battleCtrl, requestData)
  sendMsg.eplGoldNum = dynPlayer:GetCacheMoneyCount()
  self.__waitSettleResult = true
  local isBossRoom = ((self.epCtrl):GetCurrentRoomData()):IsRealBossRoom()
  ;
  (ExplorationManager.epMvpData):AddBattleStatisticsData(isBossRoom)
  local isInTdMode = (BattleUtil.IsInTDBattle)()
  local isInGuardMode = (BattleUtil.IsInGuardBattle)()
  if isInTdMode or isInGuardMode then
    sendMsg.tdHeroCoord = {}
    sendMsg.tdHpPer = dynPlayer.dungeonRoleHpPerDic
  end
  for k,v in pairs(playerRoleSettle) do
    local elem = {per = v.hpPer, dead = v.dead}
    local role = v.role
    elem.injury = cs_BattleStatistics:GetHeroInjury(role)
    elem.damage = cs_BattleStatistics:GetHeroDamage(role)
    elem.record = (ExplorationManager.epMvpData):GetSaveData(role.roleDataId, isBossRoom)
    -- DECOMPILER ERROR at PC99: Confused about usage of register: R22 in 'UnsetPending'

    ;
    (sendMsg.charHpPer)[k] = elem
    if isInTdMode then
      local coord = self:__UpdatePlayerPosOnTDSettle(role.roleDataId, role.x, role.y)
      -- DECOMPILER ERROR at PC110: Confused about usage of register: R23 in 'UnsetPending'

      if coord ~= nil then
        (sendMsg.tdHeroCoord)[k] = coord
      end
    end
  end
  for i,v in ipairs(dynPlayer.heroList) do
    -- DECOMPILER ERROR at PC139: Confused about usage of register: R20 in 'UnsetPending'

    if (sendMsg.charHpPer)[v.uid] == nil then
      (sendMsg.charHpPer)[v.uid] = {per = v.hpPer, dead = v:IsDead(), injury = 0, damage = 0, record = (ExplorationManager.epMvpData):GetSaveData(v.dataId, isBossRoom)}
    end
  end
  for k,v in pairs(monsterRoleSettle) do
    local elem = {per = v.hpPer, dead = v.dead}
    -- DECOMPILER ERROR at PC152: Confused about usage of register: R21 in 'UnsetPending'

    ;
    (sendMsg.monsterHpPer)[k] = elem
  end
  local combatStatStaticData = ((CS.BattleStatistics).Instance).combatStatStaticData
  -- DECOMPILER ERROR at PC161: Confused about usage of register: R16 in 'UnsetPending'

  ;
  (sendMsg.valid).combatStat = {}
  if combatStatStaticData.TotalRecord ~= nil then
    for k,v in pairs(combatStatStaticData.TotalRecord) do
      -- DECOMPILER ERROR at PC171: Confused about usage of register: R21 in 'UnsetPending'

      ((sendMsg.valid).combatStat)[k] = v
    end
  end
  do
    ;
    ((self.epCtrl).epNetwork):CS_EXPLORATION_BATTLE_Settle(sendMsg, function(dataList)
    -- function num : 0_33_0 , upvalues : _ENV, win, self, isWCLastBoss, battleEndState
    if dataList.Count == 0 then
      return 
    end
    local recvSettle = dataList[0]
    PlayerDataCenter:CleanTempOldEnemy()
    if win then
      self.__waitSettleResult = false
      local curRoomData = (ExplorationManager.epCtrl):GetCurrentRoomData()
      if curRoomData ~= nil then
        curRoomData:InitRoomRewardGroup(recvSettle.showRewards)
      end
      return 
    end
    do
      if recvSettle.over or isWCLastBoss then
        if win == false and (((self.epCtrl).dynPlayer):GetOperatorDetail()).canFloorOver then
          (self.epCtrl):StartCompleteExploration(function()
      -- function num : 0_33_0_0 , upvalues : battleEndState, _ENV
      battleEndState:ResetPlayerCharacter(true)
      battleEndState:EndBattleAndClear()
      MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
    end
)
        else
          ;
          (self.epCtrl):ExplorationFailSettle(function()
      -- function num : 0_33_0_1 , upvalues : battleEndState
      battleEndState:EndBattleAndClear()
    end
)
        end
      else
        ;
        ((CS.MessageCommon).ShowMessageBoxConfirm)(ConfigData:GetTipContent(1009), function()
      -- function num : 0_33_0_2 , upvalues : battleEndState, _ENV
      battleEndState:ResetPlayerCharacter(true)
      battleEndState:EndBattleAndClear()
      ;
      (ExplorationManager.epCtrl):ContinueExploration(true)
      AudioManager:PlayAudioById(1026)
    end
)
      end
      MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
    end
  end
)
  end
end

ExplorationBattleCtrl.VictoryBattleEndCoroutine = function(self, battleEndState)
  -- function num : 0_34 , upvalues : _ENV, util
  local battleController = battleEndState.battleController
  local CS_CameraController_Ins = (CS.CameraController).Instance
  self.__waitSelectChip = true
  self.__settleTimelinePause = false
  self.__startSelectChip = false
  self.__showResultUI = false
  local playerRoleList = (battleController.PlayerTeamController).battleOriginRoleList
  local enemyRoleList = (battleController.EnemyTeamController).battleOriginRoleList
  local mvpGrade = (BattleUtil.GenMvp)(playerRoleList)
  local battleEndCoroutine = function()
    -- function num : 0_34_0 , upvalues : CS_CameraController_Ins, battleController, mvpGrade, self, _ENV, playerRoleList, enemyRoleList, battleEndState
    CS_CameraController_Ins:PlaySettlementCut(battleController, mvpGrade.role, self:GetRoleMvpCameraOffset(mvpGrade.role))
    while self.__waitSettleResult do
      (coroutine.yield)()
    end
    ;
    (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
    if self.__settleTimelinePause then
      CS_CameraController_Ins:PauseSettlementCut(false)
    end
    while not self.__showResultUI do
      (coroutine.yield)()
    end
    ExplorationManager:PlayMVPVoice((mvpGrade.role).roleDataId)
    local dungeonRoleList = (battleController.PlayerTeamController).battleRoleList
    self:PlayRoleWinActionAndEffect(dungeonRoleList, mvpGrade.role)
    UIManager:ShowWindowAsync(UIWindowTypeID.BattleResult, function(window)
      -- function num : 0_34_0_0 , upvalues : playerRoleList, enemyRoleList, mvpGrade, self
      if window == nil then
        return 
      end
      window:InitBattleResultData(playerRoleList, enemyRoleList, mvpGrade)
      window:SetContinueCallback(function()
        -- function num : 0_34_0_0_0 , upvalues : self
        self.__startSelectChip = true
      end
)
    end
)
    while 1 do
      if not CS_CameraController_Ins.settleTimlinePlayEnd or UIManager:GetWindow(UIWindowTypeID.BattleResult) == nil then
        (coroutine.yield)()
        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    ;
    ((self.epCtrl).autoCtrl):OnEpBattleResultShow()
    while not self.__startSelectChip do
      (coroutine.yield)()
    end
    ;
    ((self.epCtrl).autoCtrl):OnAutoStageOver()
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    avgPlayCtrl:TryPlayTaskAvg(1, function()
      -- function num : 0_34_0_1 , upvalues : _ENV
      (ExplorationManager.epCtrl):ContinueExploration()
    end
)
    ;
    (coroutine.yield)(((CS.UnityEngine).WaitForSeconds)(0.7))
    battleEndState:EndBattleAndClear()
    MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
  end

  return (util.cs_generator)(battleEndCoroutine)
end

ExplorationBattleCtrl.OnTimelineNoticeOpenResultUI = function(self)
  -- function num : 0_35 , upvalues : _ENV
  self.__showResultUI = true
  if self.__waitSettleResult then
    ((CS.CameraController).Instance):PauseSettlementCut(true)
    self.__settleTimelinePause = true
  end
end

ExplorationBattleCtrl.ReqBattleFreshFormation = function(self, battleController)
  -- function num : 0_36 , upvalues : _ENV
  local originRoleList = (battleController.PlayerTeamController).battleOriginRoleList
  local roleCount = originRoleList.Count
  local posDic = {}
  for i = 0, roleCount - 1 do
    local role = originRoleList[i]
    local heroId = (((self.epCtrl).dynPlayer):GetDynHeroByDataId(role.roleDataId)).uid
    local pos = (BattleUtil.XYCoord2Pos)(role.x, role.y)
    posDic[heroId] = pos
  end
  ;
  ((self.epCtrl).epNetwork):CS_EXPLORATION_FreshFromation(posDic)
  ;
  ((self.epCtrl).dynPlayer):RefreshCacheFightPower()
end

ExplorationBattleCtrl.ReqGiveUpBattle = function(self, battleController)
  -- function num : 0_37 , upvalues : _ENV
  if self:IsBattleBeforeRunning() then
    ((ExplorationManager.epCtrl).autoCtrl):DisableEpAutoMode()
  end
  if (self.epCtrl):IsCompleteExploration() then
    self:__BeforeExitEp(battleController)
    ;
    (self.epCtrl):StartCompleteExploration()
    return 
  end
  if ExplorationManager:HasEpRewardBag() then
    local hasReward = ((((self.epCtrl).dynPlayer).dynRewardBag):HasEpRewardBagData())
    do
      -- DECOMPILER ERROR at PC31: Overwrote pending register: R3 in 'AssignReg'

      local msg = .end
      if hasReward then
        msg = ConfigData:GetTipContent(753)
      else
        msg = ConfigData:GetTipContent(752)
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.MessageBox, function(win)
    -- function num : 0_37_0 , upvalues : msg, self, battleController
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(msg, function()
      -- function num : 0_37_0_0 , upvalues : self, battleController
      self:__BeforeExitEp(battleController)
      ;
      (self.epCtrl):ExplorationFailSettle()
    end
)
  end
)
      return 
    end
  end
  do
    local returnStamina = (ExplorationManager:GetReturnStamina())
    -- DECOMPILER ERROR at PC56: Overwrote pending register: R3 in 'AssignReg'

    local msg = .end
    if returnStamina == 0 then
      msg = ConfigData:GetTipContent(TipContent.exploration_Player_ExitExpo)
    else
      msg = (string.format)(ConfigData:GetTipContent(TipContent.exploration_Player_ExitExpoWithStaminaBack), tostring(returnStamina))
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageBox, function(win)
    -- function num : 0_37_1 , upvalues : msg, self, battleController, _ENV
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(msg, function()
      -- function num : 0_37_1_0 , upvalues : self, battleController, _ENV
      self:__BeforeExitEp(battleController)
      ;
      (ExplorationManager.resultCtrl):EnterResultProcess(false, true)
    end
)
  end
)
  end
end

ExplorationBattleCtrl.__BeforeExitEp = function(self, battleController)
  -- function num : 0_38 , upvalues : _ENV
  GuideManager:BreakSkipGuide()
  UIManager:HideWindow(UIWindowTypeID.BattlePause)
  ;
  (battleController.fsm):ChangeState((CS.eBattleState).End)
  ;
  ((battleController.fsm).currentState):EndBattleAndClear()
end

ExplorationBattleCtrl.ReqRestartBattle = function(self, battleController)
  -- function num : 0_39 , upvalues : DungeonBattleBaseCtrl
  ((self.epCtrl).epNetwork):CS_EXPLORATION_BATTLE_Restart(function(dataList)
    -- function num : 0_39_0 , upvalues : DungeonBattleBaseCtrl, self, battleController
    (DungeonBattleBaseCtrl.ReqRestartBattle)(self, battleController)
  end
)
end

ExplorationBattleCtrl.GetEpBattleLastCount = function(self)
  -- function num : 0_40 , upvalues : _ENV
  return (ConfigData.game_config).epBattleRestartLimit - (math.max)(0, (self.__restartCount or 0) - 1)
end

ExplorationBattleCtrl.OnDelete = function(self)
  -- function num : 0_41 , upvalues : _ENV, DungeonBattleBaseCtrl
  MsgCenter:RemoveListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
  ;
  (DungeonBattleBaseCtrl.OnDelete)(self)
  if self.CustomMoveCtrl ~= nil then
    (self.CustomMoveCtrl):OnDelete()
    self.CustomMoveCtrl = nil
  end
end

return ExplorationBattleCtrl

