-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonBattleBaseCtrl = require("Game.Common.CommonGameCtrl.DungeonBattleBaseCtrl")
local base = DungeonBattleBaseCtrl
local WarChessBattleCtrl = class("WarChessBattleCtrl", base)
local util = require("XLua.Common.xlua_util")
local CS_BattleManager_Ins = (CS.BattleManager).Instance
local WarChessBattleSceneCtrl = require("Game.WarChess.Ctrl.SubSystemCtrl.WarChessBattleSceneCtrl")
local WarChessBattleRoom = require("Game.WarChess.Data.Battle.WarChessBattleRoom")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local ChipData = require("Game.PlayerData.Item.ChipData")
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
WarChessBattleCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : WarChessBattleSceneCtrl, _ENV, eWarChessEnum
  self.wcCtrl = wcCtrl
  self.sceneCtrl = (WarChessBattleSceneCtrl.New)(wcCtrl, self)
  ;
  (table.insert)((self.wcCtrl).ctrls, self)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.wcCtrl).cat2SubCtrlDic)[(eWarChessEnum.eSystemCat).battle] = self
  self.bind = nil
  self.heroPrefabs = nil
  self.heroObjectDic = nil
  self.curDynPlayer = nil
  self.__winChipList = nil
  self.__winBuffList = nil
  self.__winRewardDic = nil
  self.__InstaKillFxName = nil
  self._eventCSelectChipComplete = BindCallback(self, self.__WCSelectChipComplete)
  self.__OnTimelineNoticeOpenResultUI = BindCallback(self, self.OnTimelineNoticeOpenResultUI)
  MsgCenter:AddListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
end

WarChessBattleCtrl.GetBattleEntity = function(self)
  -- function num : 0_1
  return self.enemyEntityData
end

WarChessBattleCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV, WarChessHelper, ChipData, eWarChessEnum
  if systemState == nil or systemState.battleSystemData == nil then
    error("not have data")
    return 
  end
  local x, y = (WarChessHelper.Coordination2Pos)(systemState.pos)
  local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPosXY(nil, x, y)
  self.enemyEntityData = entityData
  ;
  ((self.wcCtrl).palySquCtrl):SetWhereNewRewradBagFrom(entityData)
  local battleSystemData = systemState.battleSystemData
  self.curSceneId = battleSystemData.sceneId
  local monsters = battleSystemData.monsters
  local teamUid = identify.tid
  local teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid(teamUid)
  self.teamData = teamData
  local heroDic = ((self.wcCtrl).teamCtrl):GetDynHeroDicByTeamData(teamData)
  self.curDynPlayer = teamData:GetTeamDynPlayer()
  self.__systemPos = systemState.pos
  self.__allowQuit = battleSystemData.allowQuit
  self.__useedEventSystem = battleSystemData.useedEventSystem
  self.__identify = identify
  self.__refreshTime = battleSystemData.refreshTime
  self._originHeroPos = nil
  self.__winChipList = {}
  do
    for _,v in pairs(battleSystemData.algList) do
      local chipData = (ChipData.NewChipForServer)(v)
      ;
      (table.insert)(self.__winChipList, chipData)
    end
  end
  self.__winBuffList = battleSystemData.propChips
  if not battleSystemData.rewards then
    self.__winRewardDic = {}
    if systemState.state == (eWarChessEnum.eSystemState).selectChip_miaosha then
      if isGameDev then
        print("<color=blue>skip battle</color>")
      end
      local pos = (self.enemyEntityData):GetEntityShowPos()
      local instantDeathFx = ((self.wcCtrl).animaCtrl):ShowWCEffect(self.__InstaKillFxName or "FXP_bisha_GroundEffcte-monster", pos)
      ;
      (self.enemyEntityData):PlayEntityAnimation(-1, nil, function()
    -- function num : 0_2_0 , upvalues : self, instantDeathFx
    ;
    ((self.wcCtrl).animaCtrl):RecycleWCEffect(self.__InstaKillFxName or "FXP_bisha_GroundEffcte-monster", instantDeathFx)
    self:SelectWCBattleChip(true)
    self.enemyEntityData = nil
    self.__InstaKillFxName = nil
  end
)
      return 
    else
      do
        if systemState.state == (eWarChessEnum.eSystemState).selectChip then
          self:SelectWCBattleChip(true)
          return 
        end
        local EnterBattleFunc = function()
    -- function num : 0_2_1 , upvalues : _ENV, self, heroDic, monsters, teamData, battleSystemData
    local loadingWindow = UIManager:GetWindow(UIWindowTypeID.WarChessLoading)
    if loadingWindow ~= nil then
      loadingWindow:Delete()
    end
    loadingWindow = UIManager:ShowWindow(UIWindowTypeID.WarChessLoading)
    if loadingWindow ~= nil then
      local enemyEntity = self:GetBattleEntity()
      local forcePos = (Vector3.New)(0, 0, 0)
      if enemyEntity ~= nil then
        forcePos = (Vector3.New)((enemyEntity.pos).x, (enemyEntity.pos).y, (enemyEntity.pos).z)
      end
      self.__isInBattleScene = true
      loadingWindow:PlayLoadEffect(forcePos, true, function()
      -- function num : 0_2_1_0 , upvalues : self, heroDic, monsters, teamData, battleSystemData
      (self.wcCtrl):LeaveWarChessSecne()
      ;
      (self.sceneCtrl):WCLoadBattleScene(self.curSceneId, heroDic, monsters, function()
        -- function num : 0_2_1_0_0 , upvalues : self, teamData, battleSystemData
        self:__InitBattle(teamData, battleSystemData)
      end
)
    end
)
    end
  end

        if self.enemyEntityData ~= nil then
          (self.enemyEntityData):PlayMonsetAttackAnimation(self.teamData, EnterBattleFunc)
        else
          error("can\'t get enemyEntity by pos:" .. tostring(x) .. "," .. tostring(y))
          EnterBattleFunc()
        end
      end
    end
  end
end

WarChessBattleCtrl.__InitBattle = function(self, teamData, battleSystemData)
  -- function num : 0_3 , upvalues : _ENV, WarChessBattleRoom, DeployTeamUtil, eWarChessEnum
  if teamData:GetWCTeamIsGhost() or teamData:GetWCTeamIsDead() then
    error("dead or ghost team not allow to battle pls check it, force quit")
    WarChessManager:ExitWarChess()
    return 
  end
  local wcDynPlayer = teamData:GetTeamDynPlayer()
  local battleRoomData = (WarChessBattleRoom.CreateWCBattleRoom)(battleSystemData, wcDynPlayer, self)
  self._battleRoomData = battleRoomData
  self.battleRoomId = battleSystemData.roomId
  WarChessManager:PlayWcAuBgm()
  if battleRoomData:IsWcBossRoom() then
    WarChessManager:PlayWcAuSelctBossCombat()
  else
    WarChessManager:PlayWcAuSelctNormalCombat()
  end
  local epWindow = UIManager:ShowWindow(UIWindowTypeID.DungeonStateInfo)
  epWindow:InitHeroAndChip(wcDynPlayer)
  local onBattleNum = 0
  local normalNum = ((ConfigData.formation_rule)[0]).stage_num
  if self.curDynPlayer ~= nil then
    self._originHeroPos = {}
    for index,dynHero in pairs((self.curDynPlayer).heroList) do
      local x, y = (BattleUtil.Pos2XYCoord)(dynHero.coord)
      local isOneBench = (ConfigData.buildinConfig).BenchX <= x
      if not isOneBench then
        onBattleNum = onBattleNum + 1
        if normalNum < onBattleNum then
          local coord = (BattleUtil.XYCoord2Pos)((ConfigData.buildinConfig).BenchX, 0)
          dynHero:SetCoord(coord, (ConfigData.buildinConfig).BenchX)
        end
      end
      -- DECOMPILER ERROR at PC93: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (self._originHeroPos)[index] = dynHero.coord
    end
  else
    self._originHeroPos = nil
  end
  local size_row, size_col, deploy_rows = (self.sceneCtrl):GetBattleFieldSizeBySceneId()
  ;
  (DeployTeamUtil.AutoBattleDeploy)(battleRoomData, wcDynPlayer.heroList, size_row, size_col, deploy_rows, false)
  WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).BeforeNewWCBattle, self.__systemPos)
  local IsWithFormation = true
  local battleCtrl = ((CS.BattleManager).Instance):StartNewBattle(battleRoomData, wcDynPlayer, self, not IsWithFormation)
  if IsWithFormation then
    battleCtrl:StartEnterDeployState()
  else
    battleCtrl:StartBattleSkipDeploy()
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

WarChessBattleCtrl.ReqStartBattle = function(self, battleRoomData, originRoleList, battleAction)
  -- function num : 0_4 , upvalues : _ENV, base
  local roleCount = originRoleList.Count
  self._startDeployPos = {}
  for i = 0, roleCount - 1 do
    local role = originRoleList[i]
    local pos = (BattleUtil.XYCoord2Pos)(role.x, role.y)
    local uid = role.uid
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self._startDeployPos)[uid] = pos
  end
  do
    if not battleRoomData.formation or battleAction ~= nil then
      battleAction()
      ;
      (base.ReqStartBattle)(self, battleRoomData, originRoleList, battleAction)
    end
  end
end

WarChessBattleCtrl.GetWCAllowRetreatBattle = function(self)
  -- function num : 0_5
  if self.__allowQuit then
    return not self.__useedEventSystem
  end
end

WarChessBattleCtrl.SetWCAllowRetreatBattle = function(self, active)
  -- function num : 0_6
  self.__allowQuit = active
end

WarChessBattleCtrl.SetWCUseedEventSystemInbattle = function(self)
  -- function num : 0_7
  self.__useedEventSystem = true
end

WarChessBattleCtrl.WCEscapeFromBattle = function(self, callback)
  -- function num : 0_8 , upvalues : _ENV
  if self.__allowQuit and not self.__useedEventSystem then
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_Quit(self.__identify, function(args)
    -- function num : 0_8_0 , upvalues : _ENV, self, callback
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local isSuccess = args[0]
    if isSuccess then
      local battleController = ((CS.BattleManager).Instance).CurBattleController
      if battleController ~= nil then
        (battleController.fsm):ChangeState((CS.eBattleState).End)
        ;
        ((battleController.fsm).currentState):ResetPlayerCharacter(true)
        ;
        ((battleController.fsm).currentState):EndBattleAndClear()
      end
      if self._originHeroPos ~= nil and self.curDynPlayer ~= nil then
        for k,coord in pairs(self._originHeroPos) do
          local dynHero = ((self.curDynPlayer).heroList)[k]
          dynHero:SetCoord(coord, (ConfigData.buildinConfig).BenchX)
        end
      end
      do
        self._originHeroPos = nil
        if callback ~= nil then
          ((self.wcCtrl).palySquCtrl):SetReLoadSceneOverCallback(callback)
        end
        UIManager:DeleteAllWindow()
        self:ExitWCBattle(false, true)
      end
    end
  end
)
  end
end

WarChessBattleCtrl.WCReturnBattleBefore = function(self)
  -- function num : 0_9 , upvalues : _ENV
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_BackBeforeBattle(self.__identify, function(args)
    -- function num : 0_9_0 , upvalues : _ENV, self
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local battleController = ((CS.BattleManager).Instance).CurBattleController
    if battleController ~= nil then
      (battleController.fsm):ChangeState((CS.eBattleState).End)
      ;
      ((battleController.fsm).currentState):ResetPlayerCharacter(true)
      ;
      ((battleController.fsm).currentState):EndBattleAndClear()
    end
    if self._originHeroPos ~= nil and self.curDynPlayer ~= nil then
      for k,coord in pairs(self._originHeroPos) do
        local dynHero = ((self.curDynPlayer).heroList)[k]
        dynHero:SetCoord(coord, (ConfigData.buildinConfig).BenchX)
      end
    end
    do
      self._originHeroPos = nil
      local warChess = args[0]
      ;
      ((self.wcCtrl).palySquCtrl):SetReLoadSceneOverCallback(function()
      -- function num : 0_9_0_0 , upvalues : self, warChess
      (self.wcCtrl):WarChessApplyTimeRewind(warChess)
    end
)
      UIManager:DeleteAllWindow()
      self:ExitWCBattle(false, true)
    end
  end
)
end

WarChessBattleCtrl.OnBattleEnd = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_10 , upvalues : _ENV
  if WarChessSeasonManager:IsInWCS() then
    self:__OnBattleEndWcSeason(battleEndState, evenId, dealBattleEndEvent)
  else
    self:__OnBattleEndWc(battleEndState, evenId, dealBattleEndEvent)
  end
end

WarChessBattleCtrl.__OnBattleEndWcSeason = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_11 , upvalues : _ENV, eWarChessEnum, DungeonBattleBaseCtrl
  local LocalFunc_OpenRewind = function()
    -- function num : 0_11_0 , upvalues : _ENV, self
    local warchessCtrl = WarChessManager:GetWarChessCtrl()
    local _, rewindCount = (warchessCtrl.turnCtrl):GetWCRewindTimes()
    if rewindCount <= 0 then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessTimeRewind, function(win)
      -- function num : 0_11_0_0 , upvalues : self
      if win == nil then
        return 
      end
      win:InitWCTimeRewindInBattle(function(wid, rewindTurnNum)
        -- function num : 0_11_0_0_0 , upvalues : self
        self:WCEscapeFromBattle(function()
          -- function num : 0_11_0_0_0_0 , upvalues : self, wid, rewindTurnNum
          ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_ResetTheRound(wid, rewindTurnNum)
        end
)
      end
, function(wid)
        -- function num : 0_11_0_0_1 , upvalues : self
        self:WCReturnBattleBefore()
      end
)
    end
)
  end

  local LocalFunc_OpenReborn = function()
    -- function num : 0_11_1 , upvalues : _ENV, eWarChessEnum, self, battleEndState
    local healingItemId, healingCount, enventId = WarChessSeasonManager:GetWcSSpItemByLogicType((eWarChessEnum.WCSpecialItemLogicType).healing)
    local spitemCfg = WarChessSeasonManager:GetWcSSpItemConfigByLogicType((eWarChessEnum.WCSpecialItemLogicType).healing)
    if healingCount or 0 < (spitemCfg.ex_arg2)[2] then
      return 
    end
    local WarchessEventUtil = require("Game.Warchess.WarchessEventUtil")
    WarchessEventUtil:ApplyWcEventInBattle((spitemCfg.ex_arg2)[1], false, function()
      -- function num : 0_11_1_0 , upvalues : self, battleEndState, _ENV
      self.__useedEventSystem = true
      local battleCtrl = battleEndState.battleController
      local enemyList = (battleCtrl.EnemyTeamController).battleRoleList
      local curHpDic = {}
      for i = 0, enemyList.Count - 1 do
        local enemy = enemyList[i]
        curHpDic[enemy.uid] = enemy.hp * 10000 // enemy.maxHp
      end
      local luaEnemyList = (self._battleRoomData).monsterList
      for i,monster in ipairs(luaEnemyList) do
        if curHpDic[monster.uid] ~= nil then
          monster.hpPer = curHpDic[monster.uid]
        else
          monster.hpPer = 0
          curHpDic[monster.uid] = 0
        end
      end
      local teamData = ((self.wcCtrl).battleCtrl):GetCurSelectedTeamData()
      local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
      local identify = {wid = wid, tid = tid}
      ;
      ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_UpdateData(identify, curHpDic)
      self:ReqRestartBattle(battleEndState.battleController)
      UIManager:DeleteWindow(UIWindowTypeID.BattleFail)
      UIManager:DeleteWindow(UIWindowTypeID.BattleCrazyMode)
      UIManager:DeleteWindow(UIWindowTypeID.RichIntro)
    end
)
  end

  if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Failure then
    UIManager:ShowWindowAsync(UIWindowTypeID.BattleFail, function(win)
    -- function num : 0_11_2 , upvalues : self, LocalFunc_OpenRewind, dealBattleEndEvent, evenId, _ENV, battleEndState, LocalFunc_OpenReborn
    win:InitWCSeasonBattleFail(self:GetBattleSettleName(), LocalFunc_OpenRewind, function()
      -- function num : 0_11_2_0 , upvalues : dealBattleEndEvent, evenId, _ENV
      dealBattleEndEvent(evenId)
      UIManager:DeleteWindow(UIWindowTypeID.BattleFail)
    end
, function()
      -- function num : 0_11_2_1 , upvalues : self, battleEndState
      self:ReqRestartBattle(battleEndState.battleController)
    end
, function()
      -- function num : 0_11_2_2 , upvalues : win, _ENV, battleEndState
      win:Hide()
      ;
      (BattleUtil.ShowBattleResultSkada)(battleEndState.battleController, function()
        -- function num : 0_11_2_2_0 , upvalues : win
        win:SetIgnoreDelayFlagOnce(true)
        win:Show()
      end
)
    end
, LocalFunc_OpenReborn)
    if not self.__allowQuit then
      win:HideBattleReviewBtn()
    end
  end
)
  else
    dealBattleEndEvent(evenId)
  end
end

WarChessBattleCtrl.__OnBattleEndWc = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_12 , upvalues : DungeonBattleBaseCtrl, _ENV
  if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Failure then
    UIManager:ShowWindowAsync(UIWindowTypeID.BattleFail, function(win)
    -- function num : 0_12_0 , upvalues : self, dealBattleEndEvent, evenId, _ENV, battleEndState
    win:InitWCBattleFail(self:GetBattleSettleName(), function()
      -- function num : 0_12_0_0 , upvalues : self
      self:WCEscapeFromBattle()
    end
, function()
      -- function num : 0_12_0_1 , upvalues : dealBattleEndEvent, evenId, _ENV
      dealBattleEndEvent(evenId)
      UIManager:DeleteWindow(UIWindowTypeID.BattleFail)
    end
, function()
      -- function num : 0_12_0_2 , upvalues : self, battleEndState
      self:ReqRestartBattle(battleEndState.battleController)
    end
, function()
      -- function num : 0_12_0_3 , upvalues : win, _ENV, battleEndState
      win:Hide()
      ;
      (BattleUtil.ShowBattleResultSkada)(battleEndState.battleController, function()
        -- function num : 0_12_0_3_0 , upvalues : win
        win:SetIgnoreDelayFlagOnce(true)
        win:Show()
      end
)
    end
)
    win:SetBattleGiveupAcitve(self:GetWCAllowRetreatBattle())
  end
)
  else
    dealBattleEndEvent(evenId)
  end
end

WarChessBattleCtrl.ReqBattleSettle = function(self, battleEndState, requestData)
  -- function num : 0_13 , upvalues : _ENV
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(self.teamData)
  local isBattleWin = battleEndState.win
  local battleCtrl = battleEndState.battleController
  local playerRoleSettle = requestData.playerRoleSettle
  local monsterRoleSettle = requestData.monsterRoleSettle
  local dynPlayer = battleCtrl.PlayerData
  local sendMsg = {}
  sendMsg.identify = {wid = wid, tid = tid}
  sendMsg.win = isBattleWin
  sendMsg.misc = self:CreateBattleSettleMisc(battleCtrl)
  sendMsg.valid = self:CreateBattleSettleValid(battleCtrl, requestData)
  sendMsg.eplGoldNum = WarChessManager:GetWCCacheCoinNum()
  local isInGuardMode = self:IsInGuardBattle()
  if isInGuardMode then
    sendMsg.tdHpPer = dynPlayer.dungeonRoleHpPerDic
  end
  sendMsg.roles = {}
  for k,v in pairs(playerRoleSettle) do
    local role = v.role
    local coord = nil
    if self._startDeployPos ~= nil then
      coord = (self._startDeployPos)[k]
    end
    local elem = {hp = v.hpPer, coordination = coord}
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R20 in 'UnsetPending'

    ;
    (sendMsg.roles)[role.roleDataId] = elem
  end
  sendMsg.monster = {}
  local hpDic = {}
  for k,v in pairs(monsterRoleSettle) do
    local role = v.role
    -- DECOMPILER ERROR at PC70: Confused about usage of register: R19 in 'UnsetPending'

    if v.dead then
      (sendMsg.monster)[role.uid] = 0
      hpDic[role.uid] = 0
    else
      -- DECOMPILER ERROR at PC77: Confused about usage of register: R19 in 'UnsetPending'

      ;
      (sendMsg.monster)[role.uid] = v.hpPer
      hpDic[role.uid] = v.hpPer
    end
  end
  sendMsg.hmp = (self.curDynPlayer).playerUltSkillMp
  sendMsg.mp = (self.curDynPlayer).playerSkillMp
  sendMsg.tdmp = (self.curDynPlayer).playerTDMp or 0
  local epMvpData = ((self.wcCtrl).teamCtrl):GetWCMvpData()
  epMvpData:AddBattleStatisticsData()
  local combatStatStaticData = ((CS.BattleStatistics).Instance).combatStatStaticData
  -- DECOMPILER ERROR at PC107: Confused about usage of register: R15 in 'UnsetPending'

  ;
  (sendMsg.valid).combatStat = {}
  if combatStatStaticData.TotalRecord ~= nil then
    for k,v in pairs(combatStatStaticData.TotalRecord) do
      -- DECOMPILER ERROR at PC117: Confused about usage of register: R20 in 'UnsetPending'

      ((sendMsg.valid).combatStat)[k] = v
    end
  end
  do
    sendMsg.hurtMonsterHp = 0
    local playerDamageDic = ((CS.BattleStatistics).Instance).playerDamage
    for k,v in pairs(playerDamageDic) do
      sendMsg.hurtMonsterHp = v.damage + sendMsg.hurtMonsterHp
    end
    local bossDamageHpRatio = 0
    local bossEntity = (battleCtrl.EnemyTeamController).bossEntity
    if bossEntity ~= nil then
      bossDamageHpRatio = (math.floor)((1 - bossEntity.hp / bossEntity.maxHp) * 1000)
    end
    sendMsg.bossDamagePecent = bossDamageHpRatio
    ;
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_Settle(sendMsg, function()
    -- function num : 0_13_0 , upvalues : self, isBattleWin, battleEndState, hpDic
    self._originHeroPos = nil
    if not isBattleWin then
      battleEndState:ResetPlayerCharacter(true)
      battleEndState:EndBattleAndClear()
      ;
      (self.enemyEntityData):GenWCMonsterHP(hpDic)
      self:ExitWCBattle(isBattleWin)
    end
    self.__waitSettleResult = false
  end
)
  end
end

WarChessBattleCtrl.VictoryBattleEndCoroutine = function(self, battleEndState)
  -- function num : 0_14 , upvalues : _ENV, CS_BattleManager_Ins, util
  local battleController = battleEndState.battleController
  local CS_CameraController_Ins = (CS.CameraController).Instance
  self.__settleTimelinePause = false
  self.__showResultUI = false
  self.__startSelectChip = false
  self.__waitSettleResult = true
  local isBattleWin = battleEndState.win
  local playerRoleList = (battleController.PlayerTeamController).battleOriginRoleList
  local enemyRoleList = (battleController.EnemyTeamController).battleOriginRoleList
  local mvpGrade = (BattleUtil.GenMvp)(playerRoleList)
  local battleEndCoroutine = function()
    -- function num : 0_14_0 , upvalues : CS_CameraController_Ins, battleController, mvpGrade, self, _ENV, playerRoleList, enemyRoleList, battleEndState, CS_BattleManager_Ins, isBattleWin
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
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessBattleResult, function(win)
      -- function num : 0_14_0_0 , upvalues : self, playerRoleList, enemyRoleList, mvpGrade, _ENV
      if win == nil then
        return 
      end
      win:SetWCBattleResultTitle(self:GetBattleSettleName())
      win:SetWCBattleResultBattleData(playerRoleList, enemyRoleList, mvpGrade)
      win:SetWCBattleResultRewardData(self.__winRewardDic)
      win:SetContinueCallback(function()
        -- function num : 0_14_0_0_0 , upvalues : _ENV, self
        local loadingWindow = UIManager:ShowWindow(UIWindowTypeID.WarChessLoading)
        local preLoadFunc = function()
          -- function num : 0_14_0_0_0_0 , upvalues : self
          self.__startSelectChip = true
        end

        if loadingWindow ~= nil then
          loadingWindow:PlayLoadEffect(nil, false, preLoadFunc)
        end
      end
)
    end
)
    while 1 do
      if not CS_CameraController_Ins.settleTimlinePlayEnd or UIManager:GetWindow(UIWindowTypeID.WarChessBattleResult) == nil then
        (coroutine.yield)()
        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
    while not self.__startSelectChip do
      (coroutine.yield)()
    end
    battleEndState:ResetPlayerCharacter(true)
    battleEndState:EndBattleAndClear()
    CS_BattleManager_Ins:ClearBattleCache()
    self:ExitWCBattle(isBattleWin)
    MsgCenter:Broadcast(eMsgEventId.OnExitBattle)
  end

  return (util.cs_generator)(battleEndCoroutine)
end

WarChessBattleCtrl.OnTimelineNoticeOpenResultUI = function(self)
  -- function num : 0_15 , upvalues : _ENV
  self.__showResultUI = true
  if self.__waitSettleResult then
    ((CS.CameraController).Instance):PauseSettlementCut(true)
    self.__settleTimelinePause = true
  end
end

WarChessBattleCtrl.ExitWCBattle = function(self, isBattleWin, isEscape)
  -- function num : 0_16 , upvalues : _ENV, eWarChessEnum
  self.__isInBattleScene = false
  ;
  (self.wcCtrl):ReLoadWarChessSecne(function()
    -- function num : 0_16_0 , upvalues : self, isBattleWin, _ENV, eWarChessEnum
    (self.sceneCtrl):OnWCBattleOver()
    if isBattleWin then
      self:SelectWCBattleChip()
    end
    WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCBattleExit, self.__systemPos)
  end
)
end

WarChessBattleCtrl.SelectWCBattleChip = function(self, isSkipBattle)
  -- function num : 0_17 , upvalues : _ENV, eWarChessEnum
  self:__WCDropBuff(function()
    -- function num : 0_17_0 , upvalues : self, isSkipBattle, _ENV, eWarChessEnum
    local chipList = self.__winChipList
    if #chipList == 0 then
      if isSkipBattle then
        self:__WCSelectChipSkip()
      end
      return 
    end
    local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
      -- function num : 0_17_0_0 , upvalues : chipList, teamDataDic, self, _ENV, eWarChessEnum
      wcChipWindow:InitWCSelectChip(chipList, teamDataDic, self._eventCSelectChipComplete)
      wcChipWindow:InitWCSelectChipRefresh(BindCallback(self, self.__WCSelectChipRefresh), self.__refreshTime)
      wcChipWindow:InitWCSelectChipSkip(BindCallback(self, self.__WCSelectChipSkip))
      local logicPos = (self.teamData):GetWCTeamServerPos()
      WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCBSelectChip, self.__systemPos)
    end
)
  end
)
end

WarChessBattleCtrl.__WCSelectChipComplete = function(self, index, teamData, selectComplete)
  -- function num : 0_18
  if selectComplete ~= nil then
    selectComplete()
  end
  index = index - 1
  local stid = teamData:GetWCTeamId()
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(self.teamData)
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_SelectAlg(wid, tid, index, stid, function()
    -- function num : 0_18_0 , upvalues : self
    if self.enemyEntityData ~= nil then
      (self.enemyEntityData):PlayEntityAnimation(-1)
      self.enemyEntityData = nil
    end
  end
)
end

WarChessBattleCtrl.__WCSelectChipRefresh = function(self)
  -- function num : 0_19 , upvalues : _ENV, ChipData
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(self.teamData)
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_RefreshAlg(wid, tid, function(msgList)
    -- function num : 0_19_0 , upvalues : self, _ENV, ChipData
    if msgList.Count <= 0 then
      return 
    end
    local msg = msgList[0]
    local algList = msg.algList
    self.__winChipList = {}
    for _,v in pairs(algList) do
      local chipData = (ChipData.NewChipForServer)(v)
      ;
      (table.insert)(self.__winChipList, chipData)
    end
    local chipList = self.__winChipList
    if #chipList == 0 then
      return 
    end
    local wcChipWindow = UIManager:GetWindow(UIWindowTypeID.WarChessSelectChip)
    if wcChipWindow == nil then
      return wcChipWindow
    end
    local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
    wcChipWindow:InitWCSelectChip(chipList, teamDataDic, self._eventCSelectChipComplete)
    wcChipWindow:UpdateWCSelectChipRefreshInfo()
    wcChipWindow:UpdateWCSelectChipSkipInfo()
  end
)
end

WarChessBattleCtrl.__WCSelectChipSkip = function(self, selectComplete)
  -- function num : 0_20
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(self.teamData)
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BattleSystem_DropAlg(wid, tid, function()
    -- function num : 0_20_0 , upvalues : self, selectComplete
    if self.enemyEntityData ~= nil then
      (self.enemyEntityData):PlayEntityAnimation(-1)
      self.enemyEntityData = nil
    end
    if selectComplete ~= nil then
      selectComplete()
    end
  end
)
end

WarChessBattleCtrl.__WCDropBuff = function(self, callback)
  -- function num : 0_21 , upvalues : _ENV, WarChessBuffData
  if self.__winBuffList ~= nil and #self.__winBuffList > 0 then
    local buffList = {}
    do
      for k,id in pairs(self.__winBuffList) do
        local wcsBuffData = (WarChessBuffData.CrearteBuffById)(id)
        ;
        (table.insert)(buffList, wcsBuffData)
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_21_0 , upvalues : buffList, callback
    win:InitWCBuffDesc(buffList, callback, 3)
  end
)
    end
  else
    do
      if callback ~= nil then
        callback()
      end
    end
  end
end

WarChessBattleCtrl.GetEffectPoolCtrl = function(self)
  -- function num : 0_22
  return (self.sceneCtrl).effectPoolCtrl
end

WarChessBattleCtrl.GetHeroObjectDic = function(self)
  -- function num : 0_23
  return (self.sceneCtrl).heroObjectDic
end

WarChessBattleCtrl.GetRoleAppearEffect = function(self)
  -- function num : 0_24
  return (self.sceneCtrl):GetRoleAppearEffect()
end

WarChessBattleCtrl.GetRoleDisappearEffect = function(self)
  -- function num : 0_25
  return (self.sceneCtrl):GetRoleAppearEffect()
end

WarChessBattleCtrl.BattleLoadReady = function(self, battleController)
  -- function num : 0_26 , upvalues : base
  (base.BattleLoadReady)(self)
  self:TryShowWarChessBeforeBattleBuff(battleController.BattleRoomData)
end

WarChessBattleCtrl.TryShowWarChessBeforeBattleBuff = function(self)
  -- function num : 0_27 , upvalues : _ENV, eWarChessEnum
  local buffDic = ((self.wcCtrl).backPackCtrl):GetWCBuffDic()
  local showBuffList = {}
  for _,wcBuffData in pairs(buffDic) do
    if wcBuffData:GetWCBuffShowType() == (eWarChessEnum.eWarChessBuffShowType).beforeBattle then
      (table.insert)(showBuffList, wcBuffData)
    end
  end
  if #showBuffList > 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_27_0 , upvalues : showBuffList
    win:InitWCBuffDesc(showBuffList, nil, 5)
  end
)
  end
end

WarChessBattleCtrl.GetBattleSettleName = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if self.battleRoomId == nil then
    return ""
  end
  local monsterGroupCfg = (ConfigData.warchess_room_monster)[self.battleRoomId]
  if monsterGroupCfg ~= nil then
    return (LanguageUtil.GetLocaleText)(monsterGroupCfg.mon_name)
  end
  return ""
end

WarChessBattleCtrl.IsInGuardBattle = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.battleRoomId == nil then
    return false
  end
  local monsterGroupCfg = (ConfigData.warchess_room_monster)[self.battleRoomId]
  if monsterGroupCfg.type ~= proto_csmsg_DungeonType.DungeonType_GuardianProfessor then
    do return monsterGroupCfg == nil end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

WarChessBattleCtrl.SetInstaKillName = function(self, fxName)
  -- function num : 0_30
  self.__InstaKillFxName = fxName
end

WarChessBattleCtrl.GetIsInBattleScene = function(self)
  -- function num : 0_31
  return self.__isInBattleScene
end

WarChessBattleCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_32 , upvalues : _ENV
  if isSwitchClose then
    error("warChess Battle system not support Switch")
  end
  self.__allowQuit = nil
  self.__useedEventSystem = nil
  return 
end

WarChessBattleCtrl.GetCurSelectedTeamData = function(self)
  -- function num : 0_33
  return self.teamData
end

WarChessBattleCtrl.Delete = function(self)
  -- function num : 0_34 , upvalues : _ENV
  (self.sceneCtrl):OnDelete()
  MsgCenter:RemoveListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
  self:OnDelete()
end

return WarChessBattleCtrl

