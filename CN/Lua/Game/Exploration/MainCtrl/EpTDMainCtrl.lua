-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.MainCtrl.EpMainCtrlBase")
local EpTDMainCtrl = class("EpTDMainCtrl", base)
local ExplorationTDBattleCtrl = require("Game.BattleTowerDefence.Ctrl.ExplorationTDBattleCtrl")
local ExplorationTDPlayerCtrl = require("Game.BattleTowerDefence.Ctrl.ExplorationTDPlayerCtrl")
local ExplorationTDSceneCtrl = require("Game.Exploration.TowerDefense.Ctrl.ExplorationTDSceneCtrl")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local cs_MessageCommon = CS.MessageCommon
EpTDMainCtrl.ctor = function(self)
  -- function num : 0_0
end

EpTDMainCtrl.InitEpMainSubCtrls = function(self)
  -- function num : 0_1 , upvalues : base, ExplorationTDBattleCtrl, ExplorationTDPlayerCtrl, ExplorationTDSceneCtrl
  (base.InitEpMainSubCtrls)(self)
  self.battleCtrl = (ExplorationTDBattleCtrl.New)(self)
  self.playerCtrl = (ExplorationTDPlayerCtrl.New)(self)
  self.sceneCtrl = (ExplorationTDSceneCtrl.New)(self)
end

EpTDMainCtrl.__OnEnterEpSceneComplete = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  if not self.__isFirstEnter then
    (base.__TryShowOperationBeforeEpSceneComplete)(self)
    return 
  end
  if (BattleUtil.IsSpecialTDMode)() then
    (base.__TryShowOperationBeforeEpSceneComplete)(self)
    return 
  end
  self:__ShowTDProcessView(true, function()
    -- function num : 0_2_0 , upvalues : base, self
    (base.__TryShowOperationBeforeEpSceneComplete)(self)
  end
)
end

EpTDMainCtrl.__EnterBattleScene = function(self, roomData, isReconnect)
  -- function num : 0_3 , upvalues : base
  (base.__EnterBattleScene)(self, roomData, isReconnect)
  ;
  (self.sceneCtrl):SetTDInBattleScene(true)
  local csbattleCtrl = (self.battleCtrl):StartNewEpBattle(roomData, self.dynPlayer)
  csbattleCtrl:StartEnterDeployState()
  self.__isStartInTheFloor = nil
end

EpTDMainCtrl.OnStartTimelineComplete = function(self)
  -- function num : 0_4 , upvalues : base
  self.__isStartInTheFloor = true
  ;
  (base.OnStartTimelineComplete)(self)
end

EpTDMainCtrl.OutsideTheRoom = function(self)
  -- function num : 0_5 , upvalues : base
  if not (base.OutsideTheRoom)(self) and self.__isStartInTheFloor then
    self:ApplyAutoSelectRoom()
  end
end

EpTDMainCtrl.__OperationProcess = function(self)
  -- function num : 0_6 , upvalues : base
  (base.__OperationProcess)(self)
  self.__isStartInTheFloor = nil
end

EpTDMainCtrl.CheckAfterOutSide = function(self)
  -- function num : 0_7 , upvalues : base
  (base.CheckAfterOutSide)(self)
  self:ApplyAutoSelectRoom()
end

EpTDMainCtrl.ContinueExploration = function(self, isRevive)
  -- function num : 0_8 , upvalues : base
  (self.sceneCtrl):SetTDInBattleScene(false)
  ;
  (base.ContinueExploration)(self, isRevive)
end

EpTDMainCtrl.TryEnterNextTDRoom = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon
  local curRoomData = self:GetCurrentRoomData()
  local enterNextFunc = function()
    -- function num : 0_9_0 , upvalues : curRoomData, self
    local nextRoomList = curRoomData:GetNextRoom()
    local nextRoomData = nextRoomList[1]
    ;
    (self.playerCtrl):Move(nextRoomData)
  end

  if curRoomData:IsEndColRoom() then
    self:StartCompleteExploration()
  else
    if curRoomData:IsRealBossRoom() then
      if (self.mapData):HasWeeklyChallengeBigBossRoom() then
        local bossMonsterName = "?"
        local bigBossRoomData = (curRoomData:GetNextRoom())[1]
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
            (cs_MessageCommon.ShowMessageBoxConfirm)((string.format)(ConfigData:GetTipContent(905), bossMonsterName), enterNextFunc)
            if (self.mapData):HasOverBossRoom() then
              local stageId = (ExplorationManager:GetSectorStageCfg()).id
              local curFloor = ExplorationManager:GetCurLevelIndex() + 1
              ;
              (ControllerManager:GetController(ControllerTypeId.AvgPlay, true)):TryPlayAvg(eAvgTriggerType.MainAvgEp, stageId, curFloor, 3, function()
    -- function num : 0_9_1 , upvalues : _ENV, enterNextFunc, self
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageBox, function(win)
      -- function num : 0_9_1_0 , upvalues : _ENV, enterNextFunc, self
      if win == nil then
        return 
      end
      win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(255), function()
        -- function num : 0_9_1_0_0 , upvalues : _ENV, enterNextFunc
        AudioManager:PlayAudioById(1125)
        enterNextFunc()
      end
, function()
        -- function num : 0_9_1_0_1 , upvalues : _ENV, self
        AudioManager:PlayAudioById(1125)
        self:StartCompleteExploration()
      end
)
    end
)
  end
)
            else
              do
                self:StartCompleteExploration()
                enterNextFunc()
              end
            end
          end
        end
      end
    end
  end
end

EpTDMainCtrl.ApplyAutoSelectRoom = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not self._outsideTheRoomFunc then
    self._outsideTheRoomFunc = function()
    -- function num : 0_10_0 , upvalues : self
    self:TryEnterNextTDRoom()
  end

    local opDetail = (self.dynPlayer):GetOperatorDetail()
    local opState = opDetail.state
    if opState ~= proto_object_ExplorationCurGridState.ExplorationCurGridState_Over then
      return 
    end
    local curRoomData = self:GetCurrentRoomData()
    if self:IsFirstEnterNewFloor() or curRoomData:IsEndColRoom() or self.__isFirstEnter or self.__isReconnect then
      (self._outsideTheRoomFunc)()
      return 
    end
    if self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
    if (BattleUtil.IsSpecialTDMode)() then
      (self._outsideTheRoomFunc)()
    else
      self.timerId = TimerManager:StartTimer(0.5, function()
    -- function num : 0_10_1 , upvalues : self
    self.timerId = nil
    self:__ShowTDProcessView(false, function()
      -- function num : 0_10_1_0 , upvalues : self
      if not (self.residentStoreCtrl):CheckEpResidentStore(self._outsideTheRoomFunc) then
        (self._outsideTheRoomFunc)()
      end
    end
)
  end
, self, true)
    end
  end
end

EpTDMainCtrl.__ShowTDProcessView = function(self, isFirst, continueFunc)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.TDProcessView, function(window)
    -- function num : 0_11_0 , upvalues : continueFunc, self, _ENV, isFirst
    if window == nil then
      if continueFunc ~= nil then
        continueFunc()
      end
      return 
    end
    local opDetail = (self.dynPlayer):GetOperatorDetail()
    local x, y = (ExplorationManager.Coordination2Pos)(opDetail.curPostion)
    window:RefreshTDProcessView(self.mapData, x + 1, x, function()
      -- function num : 0_11_0_0 , upvalues : continueFunc
      if continueFunc ~= nil then
        continueFunc()
      end
    end
)
    window:RefreshCC(isFirst)
  end
)
end

EpTDMainCtrl.IsEpAutoSelectRoom = function(self)
  -- function num : 0_12
  return true
end

EpTDMainCtrl.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return EpTDMainCtrl

