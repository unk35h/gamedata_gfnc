-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.MainCtrl.EpMainCtrlBase")
local EpLightMainCtrl = class("EpLightMainCtrl", base)
local EpLightBattleCtrl = require("Game.Exploration.Light.Ctrl.EpLightBattleCtrl")
local ExplorationTDPlayerCtrl = require("Game.BattleTowerDefence.Ctrl.ExplorationTDPlayerCtrl")
local EpLightSceneCtrl = require("Game.Exploration.Light.Ctrl.EpLightSceneCtrl")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local util = require("XLua.Common.xlua_util")
EpLightMainCtrl.ctor = function(self, mapData, dynPlayer)
  -- function num : 0_0 , upvalues : _ENV
  print("todo是轻量级无地图显示探索")
  self.__enterBattleCount = 0
  self.__showLightProcessAndNext = BindCallback(self, self.ShowLightProcessAndNext)
  self._outsideTheRoomFunc = BindCallback(self, self.__OutsideTheRoom)
  self._afterOutSideNextFunc = BindCallback(self, self.__AfterOutSideNext)
  local unlockProcessView = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_SerialBattleUI)
  self.__unlockProcessView = unlockProcessView
end

EpLightMainCtrl.InitEpMainSubCtrls = function(self)
  -- function num : 0_1 , upvalues : base, EpLightBattleCtrl, ExplorationTDPlayerCtrl, EpLightSceneCtrl
  (base.InitEpMainSubCtrls)(self)
  self.battleCtrl = (EpLightBattleCtrl.New)(self)
  self.playerCtrl = (ExplorationTDPlayerCtrl.New)(self)
  self.sceneCtrl = (EpLightSceneCtrl.New)(self)
end

EpLightMainCtrl.__EnterExplorationScene = function(self, state)
  -- function num : 0_2
  (self.sceneCtrl):SetLightInBattleScene(false)
  self.__playerState = state
  self:__OnEnterEpSceneComplete()
end

EpLightMainCtrl.__OnEnterEpSceneComplete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.__OnEnterEpScene)(self)
end

EpLightMainCtrl.__EnterBattleScene = function(self, roomData, isReconnect)
  -- function num : 0_4 , upvalues : _ENV, util
  (self.sceneCtrl):SetLightInBattleScene(true)
  if (self.sceneCtrl):IsRoleChangingState() then
    self.__waitEnterBattleCo = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_4_0 , upvalues : self, _ENV, roomData, isReconnect
    while (self.sceneCtrl):IsRoleChangingState() do
      (coroutine.yield)()
    end
    self.__waitEnterBattleCo = nil
    self:__EnterBattleSceneLogic(roomData, isReconnect)
  end
))
  else
    self:__EnterBattleSceneLogic(roomData, isReconnect)
  end
end

EpLightMainCtrl.__EnterBattleSceneLogic = function(self, roomData, isReconnect)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.__EnterBattleScene)(self, roomData, isReconnect)
  ;
  ((CS.CameraController).Instance):OnBattleExit()
  local csbattleCtrl = (self.battleCtrl):StartNewEpBattle(roomData, self.dynPlayer)
  csbattleCtrl:PlayRecycleRoleEffect()
  if self.__enterBattleCount > 0 then
    (self.sceneCtrl):BattleToBattleSceneNormal(function()
    -- function num : 0_5_0 , upvalues : csbattleCtrl
    csbattleCtrl:StartEnterDeployState()
  end
)
  else
    csbattleCtrl:StartEnterDeployState()
  end
  self.__enterBattleCount = self.__enterBattleCount + 1
end

EpLightMainCtrl.OnStartTimelineComplete = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnStartTimelineComplete)(self)
  local dungeonWindow = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonWindow ~= nil then
    dungeonWindow:Show()
  end
end

EpLightMainCtrl.TryEnterNextLightRoom = function(self)
  -- function num : 0_7 , upvalues : _ENV, util
  local curRoomData = self:GetCurrentRoomData()
  local nextRoomList = curRoomData:GetNextRoom()
  local nextRoomData = nextRoomList[1]
  if (self.sceneCtrl):IsRoleChangingState() then
    self.__waitEnterNextRoomCo = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_7_0 , upvalues : self, _ENV, nextRoomData
    while (self.sceneCtrl):IsRoleChangingState() do
      (coroutine.yield)()
    end
    self.__waitEnterNextRoomCo = nil
    ;
    (self.playerCtrl):Move(nextRoomData)
  end
))
  else
    ;
    (self.playerCtrl):Move(nextRoomData)
  end
end

EpLightMainCtrl.__OutsideTheRoom = function(self)
  -- function num : 0_8
  self:TryEnterNextLightRoom()
end

EpLightMainCtrl.__AfterOutSideNext = function(self)
  -- function num : 0_9
  if not (self.residentStoreCtrl):CheckEpResidentStore(self._outsideTheRoomFunc) then
    (self._outsideTheRoomFunc)()
  end
end

EpLightMainCtrl.CheckAfterOutSide = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.CheckAfterOutSide)(self)
  local opDetail = (self.dynPlayer):GetOperatorDetail()
  local opState = opDetail.state
  if opState ~= proto_object_ExplorationCurGridState.ExplorationCurGridState_Over then
    return 
  end
  self:CheckBossRoom(self.__showLightProcessAndNext)
end

EpLightMainCtrl.ShowLightProcessAndNext = function(self)
  -- function num : 0_11
  if not self.__unlockProcessView or (self.autoCtrl):IsAutoModeRunning() then
    (self._afterOutSideNextFunc)()
    return 
  end
  self:__ShowLightProcessView(self._afterOutSideNextFunc)
end

EpLightMainCtrl.__ShowLightProcessView = function(self, continueFunc)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.TDProcessView, function(window)
    -- function num : 0_12_0 , upvalues : continueFunc, self, _ENV
    if window == nil then
      if continueFunc ~= nil then
        continueFunc()
      end
      return 
    end
    local opDetail = (self.dynPlayer):GetOperatorDetail()
    local x, y = (ExplorationManager.Coordination2Pos)(opDetail.curPostion)
    window:RefreshLightProcessView(self.mapData, x + 1, x, function()
      -- function num : 0_12_0_0 , upvalues : continueFunc
      if continueFunc ~= nil then
        continueFunc()
      end
    end
)
  end
)
end

EpLightMainCtrl.GetSupportAutoEpType = function(self)
  -- function num : 0_13 , upvalues : ExplorationEnum
  return (ExplorationEnum.eAutoEpSwitchType).Battle
end

EpLightMainCtrl.IsEpAutoSelectRoom = function(self)
  -- function num : 0_14
  return true
end

EpLightMainCtrl.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  if self.__waitEnterBattleCo ~= nil then
    (GR.StopCoroutine)(self.__waitEnterBattleCo)
    self.__waitEnterBattleCo = nil
  end
  if self.__waitEnterNextRoomCo ~= nil then
    (GR.StopCoroutine)(self.__waitEnterNextRoomCo)
    self.__waitEnterNextRoomCo = nil
  end
  ;
  (base.OnDelete)(self)
end

return EpLightMainCtrl

