-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.Ctrl.ExplorationBattleCtrl")
local ExplorationTDBattleCtrl = class("ExplorationTDBattleCtrl", base)
local util = require("XLua.Common.xlua_util")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
ExplorationTDBattleCtrl.ReqBattleSettle = function(self, battleEndState, requestData)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.ReqBattleSettle)(self, battleEndState, requestData)
  local tdWindow = UIManager:GetWindow(UIWindowTypeID.TDBattle)
  if tdWindow ~= nil then
    tdWindow:OnBattleEnd()
  end
end

ExplorationTDBattleCtrl.VictoryBattleEndCoroutine = function(self, battleEndState, resultData)
  -- function num : 0_1 , upvalues : _ENV, ExplorationEnum, util
  local battleController = battleEndState.battleController
  local CS_CameraController_Ins = (CS.CameraController).Instance
  local playerRoleList = (battleController.PlayerTeamController).battleOriginRoleList
  local enemyRoleList = (battleController.EnemyTeamController).battleOriginRoleList
  local mvpGrade = (BattleUtil.GenMvp)(playerRoleList)
  if mvpGrade == nil then
    mvpGrade = {}
    mvpGrade.role = ((battleController.PlayerTeamController).dungeonRoleList)[0]
    mvpGrade.MVPNum = 1
    mvpGrade.MvpType = (BattleUtil.mvpType).default
  end
  local battleEndCoroutine = function()
    -- function num : 0_1_0 , upvalues : self, _ENV, battleEndState, ExplorationEnum
    while self.__waitSettleResult do
      (coroutine.yield)()
    end
    ;
    (GR.MsgBroadcast)(eCsMsgEventType.CallClearBattleEffect)
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    avgPlayCtrl:TryPlayTaskAvg(1, function()
      -- function num : 0_1_0_0 , upvalues : battleEndState, _ENV, ExplorationEnum
      battleEndState:EndBattleAndClear()
      local dungeonStateInfo = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
      if dungeonStateInfo ~= nil then
        dungeonStateInfo:Show()
        dungeonStateInfo:SetMoneyActive(true)
      end
      MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
      MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).BattleToEp)
      ;
      (ExplorationManager.epCtrl):ContinueExploration()
    end
)
  end

  return (util.cs_generator)(battleEndCoroutine)
end

return ExplorationTDBattleCtrl

