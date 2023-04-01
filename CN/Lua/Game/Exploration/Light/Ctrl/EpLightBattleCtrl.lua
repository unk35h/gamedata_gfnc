-- params : ...
-- function num : 0 , upvalues : _ENV
local ExplorationBattleCtrl = require("Game.Exploration.Ctrl.ExplorationBattleCtrl")
local EpLightBattleCtrl = class("EpLightBattleCtrl", ExplorationBattleCtrl)
local util = require("XLua.Common.xlua_util")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
EpLightBattleCtrl.VictoryBattleEndCoroutine = function(self, battleEndState)
  -- function num : 0_0 , upvalues : _ENV, ExplorationEnum, util
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
    -- function num : 0_0_0 , upvalues : CS_CameraController_Ins, battleController, mvpGrade, self, _ENV, playerRoleList, enemyRoleList, battleEndState, ExplorationEnum
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
      -- function num : 0_0_0_0 , upvalues : playerRoleList, enemyRoleList, mvpGrade, self
      if window == nil then
        return 
      end
      window:InitBattleResultData(playerRoleList, enemyRoleList, mvpGrade)
      window:SetContinueCallback(function()
        -- function num : 0_0_0_0_0 , upvalues : self
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
    local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
    if win ~= nil then
      win:Show()
    end
    local waitAvtiveDropFunc = function()
      -- function num : 0_0_0_1 , upvalues : self
      self.__waitActiveChip = false
    end

    self.__waitActiveChip = true
    if not (self.epCtrl):CheckActiveChipDrop(waitAvtiveDropFunc) then
      self.__waitActiveChip = false
    end
    while self.__waitActiveChip do
      (coroutine.yield)()
    end
    local haveChipSelect = (self.epCtrl):CheckChipSelect(function()
      -- function num : 0_0_0_2 , upvalues : self
      self.__waitSelectChip = false
    end
, false)
    local dungeonStateInfo = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
    if dungeonStateInfo ~= nil then
      dungeonStateInfo:Show()
      dungeonStateInfo:SetMoneyActive(true)
    end
    while self.__waitSelectChip do
      (coroutine.yield)()
    end
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    avgPlayCtrl:TryPlayTaskAvg(1, function()
      -- function num : 0_0_0_3 , upvalues : battleEndState, _ENV, ExplorationEnum
      battleEndState:EndBattleAndClear(false)
      MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
      MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).BattleToEp)
      ;
      (ExplorationManager.epCtrl):ContinueExploration()
    end
)
  end

  return (util.cs_generator)(battleEndCoroutine)
end

return EpLightBattleCtrl

