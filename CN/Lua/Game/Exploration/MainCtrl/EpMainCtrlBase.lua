-- params : ...
-- function num : 0 , upvalues : _ENV
local EpMainCtrlBase = class("EpMainCtrlBase")
local ExplorationTreasureCtrl = require("Game.Exploration.Ctrl.ExplorationTreasureCtrl")
local ExplorationStoreCtrl = require("Game.Exploration.Ctrl.ExplorationStoreCtrl")
local ExplorationResidentStoreCtrl = require("Game.Exploration.Ctrl.ExplorationResidentStoreCtrl")
local ExplorationEventCtrl = require("Game.Exploration.Ctrl.ExplorationEventCtrl")
local ExplorationResetRoomCtrl = require("Game.Exploration.Ctrl.ExplorationResetRoomCtrl")
local ExplorationAutoCtrl = require("Game.Exploration.Ctrl.ExplorationAutoCtrl")
local ExplorationCampFetterCtrl = require("Game.Exploration.Ctrl.ExplorationCampFetterCtrl")
local ExplorationSupportCtrl = require("Game.Exploration.Ctrl.ExplorationSupportCtrl")
local ExplorationOverclockCtrl = require("Game.Exploration.Ctrl.ExplorationOverclockCtrl")
local ExplorationExRoomCtrl = require("Game.Exploration.Ctrl.ExplorationExRoomCtrl")
local cs_MessageCommon = CS.MessageCommon
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local ePlayerState = {InTheRoom = 1, OutsideTheRoom = 2, SelectingChip = 3, HalfOver = 4, DropChip = 5, BattleFailure = 6, ReplaceChip = 7, MonsterLvUpgrade = 8, EpTask = 9, EpBuffSelect = 10}
EpMainCtrlBase.ePlayerState = ePlayerState
EpMainCtrlBase.ctor = function(self, mapData, dynPlayer)
  -- function num : 0_0 , upvalues : _ENV
  self.ctrls = {}
  self.mapData = mapData
  self.dynPlayer = dynPlayer
  self:__RegisterRoomTypeLogic()
  self:InitEpMainSubCtrls()
  self.loadSceneComplete = false
  self.epNetwork = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  self.itemRoomNetwork = NetworkManager:GetNetwork(NetworkTypeID.ItemRoom)
  self.storeRoomNetwork = NetworkManager:GetNetwork(NetworkTypeID.StoreRoom)
  self.eventRoomNetwork = NetworkManager:GetNetwork(NetworkTypeID.EventRoom)
  self.resetRoomNetwork = NetworkManager:GetNetwork(NetworkTypeID.ResetRoom)
  self.__onUpdateNextRoomInfo = BindCallback(self, self.UpdateNextRoomInfo)
  MsgCenter:AddListener(eMsgEventId.OnEpGridDetailDiff, self.__onUpdateNextRoomInfo)
  self.__onEpResidentDiff = BindCallback(self, self.UpdateResidentDetail)
  MsgCenter:AddListener(eMsgEventId.OnEpResidentDiff, self.__onEpResidentDiff)
  self.__onEnterEpSceneCompleteAction = BindCallback(self, self.__OnEnterEpSceneComplete)
  self.__operationProcessBind = BindCallback(self, self.__OperationProcess)
end

EpMainCtrlBase.InitEpMainSubCtrls = function(self)
  -- function num : 0_1 , upvalues : ExplorationTreasureCtrl, ExplorationStoreCtrl, ExplorationEventCtrl, ExplorationResetRoomCtrl, ExplorationResidentStoreCtrl, ExplorationAutoCtrl, ExplorationCampFetterCtrl, ExplorationSupportCtrl, ExplorationOverclockCtrl, ExplorationExRoomCtrl
  self.treasureCtrl = (ExplorationTreasureCtrl.New)(self)
  self.storeCtrl = (ExplorationStoreCtrl.New)(self)
  self.eventCtrl = (ExplorationEventCtrl.New)(self)
  self.resetRoomCtrl = (ExplorationResetRoomCtrl.New)(self)
  self.residentStoreCtrl = (ExplorationResidentStoreCtrl.New)(self)
  self.autoCtrl = (ExplorationAutoCtrl.New)(self)
  self.campFetterCtrl = (ExplorationCampFetterCtrl.New)(self)
  self.epSupportCtrl = (ExplorationSupportCtrl.New)(self)
  self.overclockCtrl = (ExplorationOverclockCtrl.New)(self)
  self.exRoomCtrl = (ExplorationExRoomCtrl.New)(self)
end

EpMainCtrlBase.RecordLastSelectChoiceCtrl = function(self, roomCtrl)
  -- function num : 0_2
  self.__lastSelectChoiceCtrl = roomCtrl
end

EpMainCtrlBase.GetLastSelectChoiceCtrl = function(self)
  -- function num : 0_3
  return self.__lastSelectChoiceCtrl
end

EpMainCtrlBase.Start = function(self, isReconnect, isFirstEnter)
  -- function num : 0_4 , upvalues : _ENV, ExplorationEnum
  self.__isReconnect = isReconnect
  self.__isFirstEnter = isFirstEnter
  if self.__isReconnect then
    self.__isFirstFloor = false
  else
    self.__isFirstFloor = true
  end
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local opState = opDetail.state
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

  if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_Secleted or proto_object_ExplorationCurGridState.ExplorationCurGridStateBattleALGWaiting or proto_object_ExplorationCurGridState.ExplorationCurGridState_DropAlg or proto_object_ExplorationCurGridState.ExplorationCurGridStateReplaceChip then
    (self.dynPlayer).playerClientState = (ExplorationEnum.ePlayerClientState).InRoom
  else
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.dynPlayer).playerClientState = (ExplorationEnum.ePlayerClientState).OutSideRoom
  end
  ;
  (self.sceneCtrl):FirstEnterScene(BindCallback(self, self.OnSceneLoadComplete), BindCallback(self, self.OnStartTimelineComplete))
end

EpMainCtrlBase.IsFirstEnterNewFloor = function(self)
  -- function num : 0_5
  return self.__isFirstFloor
end

EpMainCtrlBase.SetEpAfterEnterSceneExit = function(self)
  -- function num : 0_6
  self._afterEnterSceneExit = true
end

EpMainCtrlBase.GetEpAfterEnterSceneExit = function(self)
  -- function num : 0_7
  return self._afterEnterSceneExit
end

EpMainCtrlBase.OnSceneLoadComplete = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self.loadSceneComplete = true
  ExplorationManager:PlayEpAuBgm()
  ExplorationManager:PlayEpAuSelctNormalCombat()
  local epWindow = UIManager:ShowWindow(UIWindowTypeID.Exploration)
  epWindow:ShowExplorationFirst(self.dynPlayer)
  epWindow:Hide()
  local epWindow = UIManager:ShowWindow(UIWindowTypeID.DungeonStateInfo)
  epWindow:InitHeroAndChip(self.dynPlayer)
  epWindow:Hide()
  local unlockChipSuit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_TagSuit)
  do
    if unlockChipSuit then
      local epSuitWindow = UIManager:ShowWindow(UIWindowTypeID.EpChipSuit)
      epSuitWindow:InitEpChipSuit(self.dynPlayer)
      epSuitWindow:RefreshChipSuitSimpleUI()
      epSuitWindow:Hide()
      self.__onChipSuitUpdate = BindCallback(self, self.RefreshChipSuitItemPreview)
      MsgCenter:AddListener(eMsgEventId.OnEpChipSuitUpdate, self.__onChipSuitUpdate)
    end
    local curRoomData = self:GetCurrentRoomData()
    MsgCenter:Broadcast(eMsgEventId.OnEpPlayerMoveComplete, curRoomData)
    GuideManager:TryTriggerGuide(eGuideCondition.InExploration)
  end
end

EpMainCtrlBase.OnStartTimelineComplete = function(self)
  -- function num : 0_9
  (self.autoCtrl):OnExplorationStart()
  self:ContinueExploration()
end

EpMainCtrlBase.ContinueExploration = function(self, isRevive)
  -- function num : 0_10 , upvalues : _ENV, ePlayerState
  self.__isRevive = isRevive or false
  local currentRoom = self:GetCurrentRoomData()
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local opState = opDetail.state
  if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_Secleted then
    if self.inTheTempRoom then
      return 
    end
    if currentRoom:IsBattleRoom() then
      self:__EnterBattleScene(currentRoom, self.__isReconnect)
    else
      self:__EnterExplorationScene(ePlayerState.InTheRoom)
    end
  else
    if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_Over then
      self:__EnterExplorationScene(ePlayerState.OutsideTheRoom)
    else
      if opState == proto_object_ExplorationCurGridState.ExplorationCurGridStateBattleALGWaiting then
        self:__EnterExplorationScene(ePlayerState.SelectingChip)
      else
        if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_DropAlg then
          self:__EnterExplorationScene(ePlayerState.DropChip)
        else
          if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_MonsterLvUpgrade then
            self:__EnterExplorationScene(ePlayerState.MonsterLvUpgrade)
          else
            if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_HalfOver then
              self:__EnterExplorationScene(ePlayerState.HalfOver)
            else
              if opState == proto_object_ExplorationCurGridState.ExplorationCurGridStateBattleFailure then
                self:__EnterExplorationScene(ePlayerState.BattleFailure)
              else
                if opState == proto_object_ExplorationCurGridState.ExplorationCurGridStateReplaceChip then
                  self:__EnterExplorationScene(ePlayerState.ReplaceChip)
                else
                  if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_QuestSelect then
                    self:__EnterExplorationScene(ePlayerState.EpTask)
                  else
                    if opState == proto_object_ExplorationCurGridState.ExplorationCurGridState_OpeningBuffSelect then
                      self:__EnterExplorationScene(ePlayerState.EpBuffSelect)
                    else
                      error("Unsupported opState : " .. tostring(opState))
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
  ;
  (self.campFetterCtrl):__OnEpOpStateChanged(nil, opState)
  self.__isReconnect = false
  self.__isFirstEnter = false
end

EpMainCtrlBase.__EnterExplorationScene = function(self, state)
  -- function num : 0_11 , upvalues : _ENV, ExplorationEnum
  self.__playerState = state
  if (self.sceneCtrl):InBattleScene() then
    local window = UIManager:GetWindow(UIWindowTypeID.Exploration)
    if window ~= nil then
      window:RefreshPlayerData(self.dynPlayer)
    end
    ;
    (self.sceneCtrl):BattleToExplorationScene(self.__onEnterEpSceneCompleteAction)
  else
    do
      ;
      (self.sceneCtrl):ChangeEpSceneState((ExplorationEnum.eEpSceneState).InEpScene)
      self:__OnEnterEpSceneComplete()
    end
  end
end

EpMainCtrlBase.__OnEnterEpSceneComplete = function(self)
  -- function num : 0_12
end

EpMainCtrlBase.__TryShowOperationBeforeEpSceneComplete = function(self)
  -- function num : 0_13
  if not self.__isFirstEnter and not self:_TryShowFloorStartRandomBuff() then
    self:__OnEnterEpScene()
  end
  do return  end
  self:__TryShowEpBuffDescBeforeEpSceneComplete()
end

EpMainCtrlBase.__TryShowEpBuffDescBeforeEpSceneComplete = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if (self.autoCtrl):IsAutoModeRunning() then
    self:__TryShowStoreBeforeEpSceneComplete()
    return 
  end
  local hasBuff = #(self.dynPlayer):GetEpBuffList() > 0
  if not hasBuff then
    self:__TryShowStoreBeforeEpSceneComplete()
    return 
  end
  local dynPlayer = ExplorationManager:GetDynPlayer()
  local oriBuffList = dynPlayer:GetEpBuffList()
  if oriBuffList == nil then
    self:__TryShowStoreBeforeEpSceneComplete()
    return 
  end
  local buffList = {}
  for index,epBuff in ipairs(oriBuffList) do
    if epBuff:IsBuffNeedShowOnBuffList() then
      (table.insert)(buffList, epBuff)
    end
  end
  if #buffList <= 0 then
    self:__TryShowStoreBeforeEpSceneComplete()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_14_0 , upvalues : buffList, self
    win:InitEpBuffDesc(buffList, function()
      -- function num : 0_14_0_0 , upvalues : self
      self:__TryShowStoreBeforeEpSceneComplete()
    end
)
  end
)
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

EpMainCtrlBase._TryShowFloorStartRandomBuff = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if not self.__isFirstFloor or self.__isFirstEnter then
    return false
  end
  if (self.autoCtrl):IsAutoModeRunning() then
    return false
  end
  local epBuff = (self.dynPlayer):GetFloorStartRandomBuff()
  if epBuff == nil then
    return false
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_15_0 , upvalues : epBuff, self
    win:InitEpFloorBuffShow(epBuff, function()
      -- function num : 0_15_0_0 , upvalues : self
      self:__OnEnterEpScene()
    end
)
  end
)
  return true
end

EpMainCtrlBase.TryShowBuffSelect = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local ok, epBuffList, unlockBuffIdDic = (self.dynPlayer):TryGetNewEpBuffSelect()
  if ok then
    UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_16_0 , upvalues : epBuffList, unlockBuffIdDic
    win:InitEpBuffSelect(epBuffList, unlockBuffIdDic)
  end
)
  end
end

EpMainCtrlBase.__TryShowStoreBeforeEpSceneComplete = function(self)
  -- function num : 0_17 , upvalues : _ENV
  if not (self.residentStoreCtrl):HasEpResidentStore() or ExplorationManager:IsInTDExp() then
    self:__OnEnterEpScene()
    return 
  end
  ;
  (self.residentStoreCtrl):CheckEpResidentStore(function()
    -- function num : 0_17_0 , upvalues : self
    self:__OnEnterEpScene()
  end
)
end

EpMainCtrlBase.__OnEnterEpScene = function(self)
  -- function num : 0_18
  if not self:CheckActiveChipDrop(self.__operationProcessBind) then
    (self.__operationProcessBind)()
  end
end

EpMainCtrlBase.__OperationProcess = function(self)
  -- function num : 0_19 , upvalues : ePlayerState, _ENV
  if self.__playerState == ePlayerState.InTheRoom then
    local currentRoom = self:GetCurrentRoomData()
    self:OnPlayerMoveComplete(currentRoom)
  else
    do
      if self.__playerState == ePlayerState.OutsideTheRoom then
        self:OutsideTheRoom()
        self.__isFirstEnter = false
        self.__isFirstFloor = false
      else
        if self.__playerState == ePlayerState.SelectingChip then
          if not self.__ContinueSelectChipCompleteFunc then
            self.__ContinueSelectChipCompleteFunc = BindCallback(self, self.__ContinueSelectChipComplete)
            self:CheckChipSelect(self.__ContinueSelectChipCompleteFunc)
            if self.__playerState == ePlayerState.DropChip then
              self:DiscardChip()
              self.__isFirstEnter = false
              self.__isFirstFloor = false
            else
              if self.__playerState == ePlayerState.BattleFailure then
                self:ExplorationFailSettle()
              else
                if self.__playerState == ePlayerState.HalfOver then
                  warn("未实现该功能：中场结束,自动选下一个房间")
                else
                  if self.__playerState == ePlayerState.ReplaceChip then
                    self:OpenChipReplace()
                  else
                    if self.__playerState == ePlayerState.MonsterLvUpgrade then
                      self:OpenSelectDebuffUI()
                    else
                      if self.__playerState == ePlayerState.EpTask then
                        self:OpenEpTask()
                      else
                        if self.__playerState == ePlayerState.EpBuffSelect then
                          self:TryShowBuffSelect()
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

EpMainCtrlBase.__ContinueSelectChipComplete = function(self)
  -- function num : 0_20 , upvalues : _ENV, ExplorationEnum
  local opState = (self.dynPlayer):GetOperatorDetailState()
  if opState ~= proto_object_ExplorationCurGridState.ExplorationCurGridState_DropAlg and opState ~= proto_object_ExplorationCurGridState.ExplorationCurGridState_Secleted then
    MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).OutsideSelectChip)
  end
end

EpMainCtrlBase.CheckBossRoom = function(self, nextAction)
  -- function num : 0_21 , upvalues : _ENV, cs_MessageCommon
  local currentRoom = self:GetCurrentRoomData()
  if currentRoom:IsRealBossRoom() then
    if (self.mapData):HasWeeklyChallengeBigBossRoom() then
      local bossMonsterName = "?"
      local bigBossRoomData = (currentRoom:GetNextRoom())[1]
      if bigBossRoomData ~= nil and bigBossRoomData.mode == 5 then
        for _,dynMonster in pairs(bigBossRoomData.monsterList) do
          if dynMonster:GetBossBloodNum() > 0 then
            bossMonsterName = dynMonster:GetName()
            break
          end
        end
      end
      do
        do
          ;
          (cs_MessageCommon.ShowMessageBoxConfirm)((string.format)(ConfigData:GetTipContent(905), bossMonsterName), nextAction)
          -- DECOMPILER ERROR at PC62: Unhandled construct in 'MakeBoolean' P1

          if (self.mapData):HasOverBossRoom() and ((self.autoCtrl):IsAutoModeRunning() or self.__isRevive) and nextAction ~= nil then
            nextAction()
          end
          local stageId = (ExplorationManager:GetSectorStageCfg()).id
          do
            local curFloor = ExplorationManager:GetCurLevelIndex() + 1
            ;
            (ControllerManager:GetController(ControllerTypeId.AvgPlay, true)):TryPlayAvg(eAvgTriggerType.MainAvgEp, stageId, curFloor, 3, function()
    -- function num : 0_21_0 , upvalues : _ENV, nextAction, self
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageBox, function(win)
      -- function num : 0_21_0_0 , upvalues : _ENV, nextAction, self
      if win == nil then
        return 
      end
      win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(255), function()
        -- function num : 0_21_0_0_0 , upvalues : _ENV, nextAction
        AudioManager:PlayAudioById(1125)
        if nextAction ~= nil then
          nextAction()
        end
      end
, function()
        -- function num : 0_21_0_0_1 , upvalues : _ENV, self
        AudioManager:PlayAudioById(1125)
        self:StartCompleteExploration()
      end
)
    end
)
  end
)
            self:StartCompleteExploration()
            if currentRoom:IsEndColRoom() then
              self:StartCompleteExploration()
            else
              if nextAction ~= nil then
                nextAction()
              end
            end
          end
        end
      end
    end
  end
end

EpMainCtrlBase.IsCompleteExploration = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if ((self.dynPlayer):GetOperatorDetail()).canFloorOver and not ExplorationManager:HasNextLevel() then
    return true
  end
  return false
end

EpMainCtrlBase.StartCompleteExploration = function(self, endAction)
  -- function num : 0_23 , upvalues : _ENV
  if ExplorationManager:HasNextLevel() then
    self:__CompleteExplorationFloor(endAction)
  else
    self:__CompleteExploration(endAction)
  end
end

EpMainCtrlBase.__CompleteExplorationFloor = function(self, endAction)
  -- function num : 0_24 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ExplorationResult, function(window)
    -- function num : 0_24_0 , upvalues : _ENV, self, endAction
    if window ~= nil then
      window:CompleteExplorationFloor(data)
    end
    ;
    (self.autoCtrl):OnEpFloorSettle()
    if self.mapCtrl ~= nil then
      (self.mapCtrl):HideMapCavasWithoutBg()
    end
    UIManager:HideWindow(UIWindowTypeID.DungeonStateInfo)
    UIManager:HideWindow(UIWindowTypeID.Exploration)
    UIManager:HideWindow(UIWindowTypeID.EpChipSuit)
    if endAction ~= nil then
      endAction()
    end
  end
)
end

EpMainCtrlBase.ExplorationFailSettle = function(self, clearAction)
  -- function num : 0_25 , upvalues : _ENV
  (ExplorationManager.resultCtrl):EnterResultProcess(false, true, clearAction)
end

EpMainCtrlBase.__CompleteExploration = function(self, endAction)
  -- function num : 0_26 , upvalues : _ENV
  ((CS.BattleManager).Instance):ForceExitBattle()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (Time.unity_time).timeScale = 1
  ;
  (ExplorationManager.resultCtrl):EnterResultProcess(true, true, endAction)
end

EpMainCtrlBase.__EnterBattleScene = function(self, roomData, isReconnect)
  -- function num : 0_27 , upvalues : _ENV
  if isGameDev then
    print("[Dev]battleId:", roomData.battleId)
  end
  self:RollbackTempChipCurBattleRoom((self.dynPlayer):GetEpBuffChipDic())
  self:ExecuteTempChipCurBattleRoom((self.dynPlayer):GetEpBuffChipDic())
  if self.bloodGridMax == nil then
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local unitBlood, bossUnitBlood = saveUserData:GetUnitBlood()
    if unitBlood or 0 > 0 then
      self:SetBloodGrid(unitBlood, bossUnitBlood)
    else
      self:CalculateBloodGrid()
    end
  end
  do
    ;
    (roomData.battleMap):SetBloodGridParam(self.unitBlood, self.bossUnitBlood, self.bloodGridMax)
    ;
    (roomData.battleMap):SetPlayerRoleBattleMaxCount((self.dynPlayer):GetEnterFiledNum())
  end
end

EpMainCtrlBase.EnterDeployRoom = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local epState = (self.dynPlayer):GetOperatorDetailState()
  if epState ~= proto_object_ExplorationCurGridState.ExplorationCurGridState_Over then
    return 
  end
  local deployRoomData = (self.mapData):GetDeployRoom()
  self:__EnterBattleScene(deployRoomData)
end

EpMainCtrlBase.GenExplorationMap = function(self)
  -- function num : 0_29
end

EpMainCtrlBase.OnPlayerMoveStart = function(self, roomData)
  -- function num : 0_30
  self:OnPlayerMoveComplete(roomData)
end

EpMainCtrlBase.__RegisterRoomTypeLogic = function(self)
  -- function num : 0_31 , upvalues : ExplorationEnum
  self.__roomLogicFunc = {[(ExplorationEnum.eRoomLogicType).battle] = function(roomData)
    -- function num : 0_31_0 , upvalues : self
    self:__EnterBattleScene(roomData)
  end
, [(ExplorationEnum.eRoomLogicType).chip] = function(roomData)
    -- function num : 0_31_1 , upvalues : self
    (self.resetRoomCtrl):OnResetRoomOpen(roomData)
  end
, [(ExplorationEnum.eRoomLogicType).store] = function(roomData)
    -- function num : 0_31_2 , upvalues : self
    (self.storeCtrl):OnStoreRoomOpen(roomData, true)
  end
, [(ExplorationEnum.eRoomLogicType).treasure] = function(roomData)
    -- function num : 0_31_3 , upvalues : self
    (self.treasureCtrl):OnTreasureRoomOpen(roomData, true)
  end
, [(ExplorationEnum.eRoomLogicType).event] = function(roomData)
    -- function num : 0_31_4 , upvalues : self
    (self.eventCtrl):OnEventRoomOpen(roomData, true)
  end
, [(ExplorationEnum.eRoomLogicType).excustom] = function(roomData)
    -- function num : 0_31_5 , upvalues : self
    (self.exRoomCtrl):OnEpExRoomOpen(roomData, true)
  end
}
end

EpMainCtrlBase.OnPlayerMoveComplete = function(self, roomData)
  -- function num : 0_32 , upvalues : _ENV, ExplorationEnum
  local roomLogicType = roomData:GetRoomLogicType()
  if roomLogicType == nil then
    error("Unsupported room logicType : " .. tostring(roomLogicType))
  else
    local roomLogicFunc = (self.__roomLogicFunc)[roomLogicType]
    if roomLogicFunc ~= nil then
      roomLogicFunc(roomData)
    else
      error("Unsupported room logicType : " .. tostring(roomLogicType))
    end
  end
  do
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.dynPlayer).playerClientState = (ExplorationEnum.ePlayerClientState).InRoom
    MsgCenter:Broadcast(eMsgEventId.OnEpPlayerMoveComplete, roomData)
    roomData:ResetJumpCat()
  end
end

EpMainCtrlBase.OutsideTheRoom = function(self)
  -- function num : 0_33
  if self.__isReconnect or self.__isFirstFloor then
    self:CheckAfterOutSide()
    return true
  end
  return false
end

EpMainCtrlBase.CheckAfterOutSide = function(self)
  -- function num : 0_34 , upvalues : _ENV, ExplorationEnum
  if self.chacheWillChangeRoleSync ~= nil then
    (self.epSupportCtrl):ChangeEpHero(self.chacheWillChangeRoleSync)
    self:ClearChacheWillChangeHero()
  end
  local actionList = ExplorationManager:GetEpGuideActionList((self:GetCurrentRoomData()).x, (ExplorationEnum.epGuideMomentType).InEpOutsideRoom)
  if actionList ~= nil and #actionList > 0 then
    local EpGuideUtil = require("Game.Exploration.Util.EpGuideUtil")
    ;
    (EpGuideUtil.ExecuteEpGuideActions)(actionList)
  end
end

EpMainCtrlBase.OnExitEpRoomBegin = function(self)
  -- function num : 0_35 , upvalues : ExplorationEnum
  local curRoomData = self:GetCurrentRoomData(true)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if curRoomData:IsEndColRoom() then
    (self.dynPlayer).playerClientState = (ExplorationEnum.ePlayerClientState).OutSideRoom
    return 
  end
  self:OnExitEpRoomEnd(curRoomData)
end

EpMainCtrlBase.OnExitEpRoomEnd = function(self, curRoomData)
  -- function num : 0_36 , upvalues : ExplorationEnum, _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  (self.dynPlayer).playerClientState = (ExplorationEnum.ePlayerClientState).OutSideRoom
  if curRoomData:IsCrossRoom() and not (self.autoCtrl):IsAutoModeRunning() then
    GuideManager:TryTriggerGuide(eGuideCondition.AfterEpCrossRoom)
  end
end

EpMainCtrlBase.UpdateNextRoomInfo = function(self, epGrid, epOp)
  -- function num : 0_37 , upvalues : _ENV, ExplorationEnum
  if epGrid.monster ~= nil then
    for k,v in pairs(epGrid.monster) do
      local roomData = (self.mapData):GetRoomByCoord(k)
      if roomData ~= nil and roomData:IsBattleRoom(epOp) then
        roomData:InitBattleData(v)
        roomData:ExecuteMonsterChip(self.dynPlayer)
        if roomData:IsGuardTDBattle() then
          roomData:ExecuteDungeonRoleChip(self.dynPlayer)
        end
        if self.mapCtrl ~= nil then
          (self.mapCtrl):ShowFightingPower(roomData, (self.dynPlayer):GetCacheFightPower())
        end
        roomData:SetAmbushAndSneakData(v.ambush, v.stealth)
      end
    end
  end
  do
    if epGrid.item ~= nil then
      for k,v in pairs(epGrid.item) do
        local roomData = (self.mapData):GetRoomByCoord(k)
        if roomData ~= nil then
          roomData:InitTreasureRoomData(v)
        end
      end
    end
    do
      if epGrid.store ~= nil then
        for k,v in pairs(epGrid.store) do
          local roomData = (self.mapData):GetRoomByCoord(k)
          if roomData ~= nil then
            roomData:InitStoreRoomData(v)
          end
        end
      end
      do
        if epGrid.evt ~= nil then
          for k,v in pairs(epGrid.evt) do
            local roomData = (self.mapData):GetRoomByCoord(k)
            if roomData ~= nil then
              roomData:InitEventAndRecoveryRoomData(v, jumpCat)
            end
          end
        end
        do
          for k,v in pairs(epGrid.exRoom) do
            local roomData = (self.mapData):GetRoomByCoord(k)
            if roomData ~= nil then
              roomData:InitEpExRoomData(v)
            end
          end
          if epGrid.reconstitution ~= nil then
            for k,v in pairs(epGrid.reconstitution) do
              local roomData = (self.mapData):GetRoomByCoord(k)
              if roomData ~= nil then
                roomData:InitResetRoomData(v)
              end
            end
          end
          do
            if epGrid.tmpStore ~= nil then
              local tmpStore = epGrid.tmpStore
              local curRoomData = self:GetCurrentRoomData()
              local curPos = curRoomData:GetRoomPosition()
              local x, y = (ExplorationManager.Coordination2Pos)(curPos)
              local DynEpRoomData = require("Game.Exploration.MapData.DynEpRoomData")
              local type = (ExplorationEnum.eRoomType).store
              local roomData = (DynEpRoomData.New)(x, y, type, curPos, false)
              roomData:InitStoreRoomData(tmpStore)
              ;
              (self.storeCtrl):OnStoreRoomOpen(roomData)
              self.inTheTempRoom = true
            end
            do
              do
                if epGrid.buffData ~= nil then
                  local curRoomData = self:GetCurrentRoomData()
                  if curRoomData ~= nil then
                    curRoomData:InitEpBuffEffective((epGrid.buffData).data)
                  end
                end
                if self.bloodGridMax == nil then
                  self:CalculateBloodGrid()
                end
              end
            end
          end
        end
      end
    end
  end
end

EpMainCtrlBase.CalculateBloodGrid = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local roomList = {}
  local curRoom = self:GetCurrentRoomData(true)
  local nextRoomList = curRoom:GetNextRoom()
  ;
  (table.insert)(roomList, curRoom)
  ;
  (table.insertto)(roomList, nextRoomList)
  local heroDic = (self.dynPlayer).heroDic
  local maxHp, minHp = nil, nil
  for id,dyHero in pairs(heroDic) do
    local hp = dyHero:GetRealAttr(eHeroAttr.maxHp)
    if maxHp ~= nil or not hp then
      maxHp = (math.max)(maxHp, hp)
    end
    if minHp ~= nil or not hp then
      minHp = (math.min)(minHp, hp)
    end
  end
  for _,epRoom in ipairs(roomList) do
    if epRoom ~= nil and epRoom:IsBattleRoom() then
      local monsterList = epRoom:GetMonsterList()
      for _,monster in ipairs(monsterList) do
        if monster:GetBossBloodNum() == 0 then
          local hp = monster:GetRealAttr(eHeroAttr.maxHp)
          if maxHp ~= nil or not hp then
            maxHp = (math.max)(maxHp, hp)
          end
          if minHp ~= nil or not hp then
            minHp = (math.min)(minHp, hp)
          end
        end
      end
    end
  end
  self.unitBlood = (BattleUtil.CalculateBloodGrid)(maxHp, minHp)
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetUnitBlood(self.unitBlood, self.bossUnitBlood)
end

EpMainCtrlBase.SetBloodGrid = function(self, unitBlood, bossUnitBlood)
  -- function num : 0_39 , upvalues : _ENV
  self.unitBlood = unitBlood
  self.bossUnitBlood = bossUnitBlood
  self.bloodGridMax = (ConfigData.game_config).bloodGridMax
end

EpMainCtrlBase.UpdateResidentDetail = function(self, epResident)
  -- function num : 0_40
  (self.residentStoreCtrl):UpdateResidentStore(epResident)
end

EpMainCtrlBase.OpenResidentStore = function(self, closeCallback)
  -- function num : 0_41
  (self.residentStoreCtrl):OnResidentStoreRoomOpen(closeCallback)
end

EpMainCtrlBase.IsMapLogic = function(self, mapLogic)
  -- function num : 0_42
  do return (self.mapData).epMapLogic == mapLogic end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

EpMainCtrlBase.CheckActiveChipDrop = function(self, continueFunc)
  -- function num : 0_43 , upvalues : _ENV
  if self.__isReconnect or self.__isFirstEnter then
    return false
  end
  local tempActiveAlg = (self.dynPlayer):GetDropActiveAlg()
  if tempActiveAlg == nil then
    return false
  end
  ;
  (self.dynPlayer):ClearDropActiveAlg()
  local chipData = ((self.dynPlayer):GetNormalChipDic())[tempActiveAlg >> 4]
  if chipData == nil then
    return false
  end
  local chipDataList = {}
  ;
  (table.insert)(chipDataList, chipData)
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonInfoDetail, function(window)
    -- function num : 0_43_0 , upvalues : chipDataList, continueFunc, self
    window:ShowChipDetail(chipDataList, 1, function()
      -- function num : 0_43_0_0 , upvalues : continueFunc
      continueFunc()
    end
, nil, true)
    ;
    (self.autoCtrl):OnEnterActiveChipDrop(function()
      -- function num : 0_43_0_1 , upvalues : window
      window:OnClickRetreat()
    end
)
    window:SetSwitchBtnActive(false)
  end
)
  return true
end

EpMainCtrlBase.CheckChipSelect = function(self, noSelectEvent, toFakeCamera)
  -- function num : 0_44 , upvalues : _ENV
  if noSelectEvent ~= nil then
    self.__noChipSelectEvent = noSelectEvent
  end
  if (self.dynPlayer):GetOperatorDetailState() ~= proto_object_ExplorationCurGridState.ExplorationCurGridStateBattleALGWaiting then
    if self.__noChipSelectEvent ~= nil then
      (self.__noChipSelectEvent)()
      self.__noChipSelectEvent = nil
    end
    return false
  end
  local chipList = (self:GetCurrentRoomData()):GetRewardChipList()
  if #chipList == 0 then
    error("rewardChipList.count == 0")
    return false
  end
  self.selectChipWindow = nil
  if toFakeCamera then
    self.selectChipWindow = UIManager:ShowWindow(UIWindowTypeID.SelectChip, UIWindowTypeID.ThreeDSelectChip)
  else
    self.selectChipWindow = UIManager:ShowWindow(UIWindowTypeID.SelectChip)
  end
  if self.selectChipWindow ~= nil then
    (self.selectChipWindow):InitSelectChip(true, chipList, self.dynPlayer, BindCallback(self, self.__SelectChipComplete), BindCallback(self, self.__GiveSelectChipComplect), toFakeCamera, BindCallback(self, self.__ReqReFreshSelectChipAfterBtl))
    ;
    (self.autoCtrl):OnEpBattleSelectChip(chipList)
  end
  ;
  (self.campFetterCtrl):OnEpSelectChip()
  return true
end

EpMainCtrlBase.__ReqReFreshSelectChipAfterBtl = function(self, currencyId, remainRefreshTime, refreshPrice, lockChipIdx)
  -- function num : 0_45 , upvalues : _ENV, cs_MessageCommon
  if remainRefreshTime > 0 or remainRefreshTime == -1 then
    if refreshPrice <= (self.dynPlayer):GetItemCount(currencyId) or refreshPrice <= 0 then
      if lockChipIdx == nil then
        lockChipIdx = table.emptytable
      end
      ;
      (self.epNetwork):CS_EXPLORATION_BATTLE_RefreshAlg(lockChipIdx, BindCallback(self, self.__UpdaterRefreshChipCountAfterBtlUI))
    else
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.exploration_Treasure_MoneyInsufficient))
    end
  else
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.exploration_Treasure_RefreshNumInsufficient))
  end
end

EpMainCtrlBase.__UpdaterRefreshChipCountAfterBtlUI = function(self)
  -- function num : 0_46 , upvalues : _ENV
  if self.selectChipWindow == nil then
    return 
  end
  local chipList = (self:GetCurrentRoomData()):GetRewardChipList()
  if #chipList == 0 then
    error("rewardChipList.count == 0")
    return false
  end
  ;
  (self.selectChipWindow):RefreshChipList(chipList, true)
  ;
  (self.selectChipWindow):OnUpdateRemainRefreshInfo()
end

EpMainCtrlBase.__SelectChipComplete = function(self, index, selectComplete)
  -- function num : 0_47
  index = index - 1
  local position = (self:GetCurrentRoomData()):GetRoomPosition()
  ;
  (self.epNetwork):CS_EXPLORATION_BATTLE_ALGSelect(position, index, function(dataList)
    -- function num : 0_47_0 , upvalues : selectComplete, self
    if selectComplete ~= nil then
      selectComplete()
    end
    self:CheckChipSelect()
  end
)
end

EpMainCtrlBase.__GiveSelectChipComplect = function(self, selectComplete)
  -- function num : 0_48
  (self.epNetwork):CS_EXPLORATION_BATTLE_GiveUpAlg(function()
    -- function num : 0_48_0 , upvalues : selectComplete, self
    if selectComplete ~= nil then
      selectComplete(function()
      -- function num : 0_48_0_0 , upvalues : self
      self:CheckChipSelect()
    end
)
    end
  end
)
end

EpMainCtrlBase.DiscardChip = function(self)
  -- function num : 0_49 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.EpChipDiscard)
  if win ~= nil and win.active then
    return 
  end
  self._isInDiscardChip = true
  UIManager:ShowWindowAsync(UIWindowTypeID.EpChipDiscard, function(win)
    -- function num : 0_49_0 , upvalues : _ENV, self
    if win == nil then
      error("can\'t open EpChipDiscard UI")
      return 
    end
    win:InitEpChipDiscard(self.dynPlayer, function()
      -- function num : 0_49_0_0 , upvalues : self
      self._isInDiscardChip = false
      if self._nextDiscardChipFunc ~= nil then
        (self._nextDiscardChipFunc)()
        self._nextDiscardChipFunc = nil
      end
    end
)
  end
)
end

EpMainCtrlBase.IsInDiscardChip = function(self)
  -- function num : 0_50
  return self._isInDiscardChip
end

EpMainCtrlBase.SetNextDiscardChipFunc = function(self, func)
  -- function num : 0_51
  self._nextDiscardChipFunc = func
end

EpMainCtrlBase.OpenSelectDebuffUI = function(self)
  -- function num : 0_52 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.EpSelectDebuff)
  if win ~= nil and win.active then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpSelectDebuff, function(win)
    -- function num : 0_52_0 , upvalues : _ENV, self
    if win == nil then
      error("can\'t open EpSelectDebuff UI")
      return 
    end
    win:InitEpSelectDebuff(self.dynPlayer)
  end
)
end

EpMainCtrlBase.GetCurrentRoomData = function(self, withoutSpecialRoom)
  -- function num : 0_53
  local currentRoom = (self.playerCtrl):GetCurrentRoomData(withoutSpecialRoom)
  return currentRoom
end

EpMainCtrlBase.GetCurrentRoomTitle = function(self)
  -- function num : 0_54 , upvalues : _ENV
  local currentRoom = (self.playerCtrl):GetCurrentRoomData()
  local roomType = currentRoom:GetRoomType()
  local roomTypeCfg = (ConfigData.exploration_roomtype)[roomType]
  if roomTypeCfg == nil then
    error("exploration room type is null,id:" .. tostring(roomType))
    return ""
  end
  return (LanguageUtil.GetLocaleText)(roomTypeCfg.title)
end

EpMainCtrlBase.ExecuteNormalChipBattleRoom = function(self)
  -- function num : 0_55 , upvalues : _ENV
  local nextRooms = (self:GetCurrentRoomData(true)):GetNextRoom()
  for k,roomData in pairs(nextRooms) do
    if roomData:IsBattleRoom() then
      roomData:ExecutePlayerChipForMonster(self.dynPlayer)
    end
  end
  local curRoomData = self:GetCurrentRoomData(true)
  if curRoomData:IsBattleRoom() then
    curRoomData:ExecutePlayerChipForMonster(self.dynPlayer)
  end
end

EpMainCtrlBase.RollbackNormalChipBattleRoom = function(self)
  -- function num : 0_56 , upvalues : _ENV
  local nextRooms = (self:GetCurrentRoomData(true)):GetNextRoom()
  for k,roomData in pairs(nextRooms) do
    if roomData:IsBattleRoom() then
      roomData:RollbackPlayerChipForMonster(self.dynPlayer)
    end
  end
  local curRoomData = self:GetCurrentRoomData(true)
  if curRoomData:IsBattleRoom() then
    curRoomData:RollbackPlayerChipForMonster(self.dynPlayer)
  end
end

EpMainCtrlBase.ExecuteTempChipCurBattleRoom = function(self, chipTemporaryDic)
  -- function num : 0_57
  local curRoomData = self:GetCurrentRoomData()
  if curRoomData:IsBattleRoom() then
    curRoomData:ExecuteMonsterTempChip(chipTemporaryDic)
  end
end

EpMainCtrlBase.RollbackTempChipCurBattleRoom = function(self, chipTemporaryDic)
  -- function num : 0_58
  local curRoomData = self:GetCurrentRoomData()
  if curRoomData:IsBattleRoom() then
    curRoomData:RollbackMonsterTempChip(chipTemporaryDic)
  end
end

EpMainCtrlBase.OpenChipReplace = function(self)
  -- function num : 0_59 , upvalues : _ENV
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local roomData = (self.mapData):GetRoomByCoord(opDetail.curPostion)
  UIManager:ShowWindowAsync(UIWindowTypeID.ChipDisplace, function(window)
    -- function num : 0_59_0 , upvalues : roomData, self
    local remainCount = ((roomData.eventData).replaceChip).remainingReplaceChipTimes
    local isAllDisplace = ((roomData.eventData).replaceChip).replaceNum == 0
    window:InitChipDisplace(remainCount, isAllDisplace, self)
    ;
    (self.autoCtrl):OnEnterChipReplace(true)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

EpMainCtrlBase.SendChipReplace = function(self, id)
  -- function num : 0_60
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local roomData = (self.mapData):GetRoomByCoord(opDetail.curPostion)
  ;
  (self.epNetwork):CS_EXPLORATION_EVENT_ReplaceAlg(opDetail.curPostion, id, function()
    -- function num : 0_60_0 , upvalues : self
    self:ChipReplaceSuccess()
  end
)
end

EpMainCtrlBase.ChipReplaceSuccess = function(self)
  -- function num : 0_61 , upvalues : _ENV
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local roomData = (self.mapData):GetRoomByCoord(opDetail.curPostion)
  local window = UIManager:GetWindow(UIWindowTypeID.ChipDisplace)
  if window ~= nil then
    window:UpdateDiff()
    ;
    (self.autoCtrl):OnEnterChipReplace(false)
  end
end

EpMainCtrlBase.SendExitChipReplace = function(self)
  -- function num : 0_62
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  ;
  (self.epNetwork):CS_EXPLORATION_EVENT_ReplaceExit(opDetail.curPostion, function()
    -- function num : 0_62_0 , upvalues : self
    self:ExitChipReplaceSuccess()
  end
)
end

EpMainCtrlBase.ExitChipReplaceSuccess = function(self)
  -- function num : 0_63 , upvalues : _ENV, ExplorationEnum
  UIManager:DeleteWindow(UIWindowTypeID.ChipDisplace)
  MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).EventRoom)
end

EpMainCtrlBase.ChacheWillChangeHero = function(self, roleSync)
  -- function num : 0_64
  self.chacheWillChangeRoleSync = roleSync
end

EpMainCtrlBase.ClearChacheWillChangeHero = function(self)
  -- function num : 0_65
  self.chacheWillChangeRoleSync = nil
end

EpMainCtrlBase.OpenEpTask = function(self)
  -- function num : 0_66 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EpTask, function(win)
    -- function num : 0_66_0 , upvalues : self
    win:InitEpTask(self, (self.dynPlayer):GetQuestChioceDic())
    ;
    (self.autoCtrl):OnEnterTaskSelect(true)
  end
)
end

EpMainCtrlBase.SendGetTask = function(self, id)
  -- function num : 0_67
  (self.epNetwork):CS_EXPLORATION_QuestSelect(id, function()
    -- function num : 0_67_0 , upvalues : self
    self:ExitTaskSuccess()
  end
)
end

EpMainCtrlBase.SendGiveUpTask = function(self)
  -- function num : 0_68 , upvalues : _ENV
  (self.epNetwork):CS_EXPLORATION_QuestExit(function()
    -- function num : 0_68_0 , upvalues : self, _ENV
    self:ExitTaskSuccess()
    for id,count in pairs((ConfigData.game_config).epTaskGiveUpReward) do
      local itemCfg = (ConfigData.item)[id]
      if itemCfg ~= nil then
        ((CS.MessageCommon).ShowMessageTips)((string.format)(ConfigData:GetTipContent(119), (LanguageUtil.GetLocaleText)(itemCfg.name), tostring(count)))
      end
      do break end
    end
  end
)
end

EpMainCtrlBase.ExitTaskSuccess = function(self)
  -- function num : 0_69 , upvalues : _ENV, ExplorationEnum
  UIManager:DeleteWindow(UIWindowTypeID.EpTask)
  MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).TaskSelect)
end

EpMainCtrlBase.RefreshChipSuitItemPreview = function(self)
  -- function num : 0_70 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.EpChipSuit)
  win:RefreshChipSuitSimpleUI()
end

EpMainCtrlBase.GetSupportAutoEpType = function(self)
  -- function num : 0_71 , upvalues : ExplorationEnum
  return (ExplorationEnum.eAutoEpSwitchType).None
end

EpMainCtrlBase.IsEpAutoSelectRoom = function(self)
  -- function num : 0_72
  return false
end

EpMainCtrlBase.OnDelete = function(self)
  -- function num : 0_73 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.OnEpGridDetailDiff, self.__onUpdateNextRoomInfo)
  MsgCenter:RemoveListener(eMsgEventId.OnEpResidentDiff, self.__onEpResidentDiff)
  for k,v in pairs(self.ctrls) do
    v:OnDelete()
  end
  self.ctrls = nil
  self.loadSceneComplete = false
  if self.__onChipSuitUpdate ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.OnEpChipSuitUpdate, self.__onChipSuitUpdate)
    self.__onChipSuitUpdate = nil
  end
end

return EpMainCtrlBase

