-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonBattleBaseCtrl = require("Game.Common.CommonGameCtrl.DungeonBattleBaseCtrl")
local BattleDungeonBattleCtrl = class("BattleDungeonBattleCtrl", DungeonBattleBaseCtrl)
local base = DungeonBattleBaseCtrl
local DungeonConst = require("Game.BattleDungeon.DungeonConst")
local DungeonBattleRoom = require("Game.BattleDungeon.Data.DungeonBattleRoom")
local ChipData = require("Game.PlayerData.Item.ChipData")
local JumpManager = require("Game.Jump.JumpManager")
local util = require("XLua.Common.xlua_util")
local eDungeonEnum = require("Game.Dungeon.eDungeonEnum")
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
local BattleCustomMoveCtrl = require("Game.BattleCustomMove.BattleCustomMoveCtrl")
local cs_BattleStatistics = (CS.BattleStatistics).Instance
local cs_MessageCommon = CS.MessageCommon
BattleDungeonBattleCtrl.ctor = function(self, bdCtrl)
  -- function num : 0_0 , upvalues : _ENV, DungeonConst
  self.bdCtrl = bdCtrl
  ;
  (table.insert)((self.bdCtrl).ctrls, self)
  self.__battleStepLogic = BindCallback(self, self.DungeonBattleStepLogic)
  ;
  (self.bdCtrl):RegisterDungeonLogic((DungeonConst.LogicType).BattleStep, self.__battleStepLogic)
  self.__chipStepLogic = BindCallback(self, self.DungeonChipStepLogic)
  ;
  (self.bdCtrl):RegisterDungeonLogic((DungeonConst.LogicType).ChipStep, self.__chipStepLogic)
  self.__OnTimelineNoticeOpenResultUI = BindCallback(self, self.OnTimelineNoticeOpenResultUI)
  MsgCenter:AddListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
  self._OnWinterChallengeScoreShowFunc = BindCallback(self, self._OnWinterChallengeScoreShow)
  MsgCenter:AddListener(eMsgEventId.WinterChallengeScoreShow, self._OnWinterChallengeScoreShowFunc)
  self.__onOverKillValueChange = BindCallback(self, self.__OnOverKillValueChange)
  MsgCenter:AddListener(eMsgEventId.OnOverKillValueChange, self.__onOverKillValueChange)
end

BattleDungeonBattleCtrl.GetEffectPoolCtrl = function(self)
  -- function num : 0_1
  return ((self.bdCtrl).sceneCtrl).effectPoolCtrl
end

BattleDungeonBattleCtrl.GetHeroObjectDic = function(self)
  -- function num : 0_2
  return ((self.bdCtrl).sceneCtrl).heroObjectDic
end

BattleDungeonBattleCtrl.OnBattleStateChange = function(self, battleCtrl, stateId, isDeployRoom)
  -- function num : 0_3 , upvalues : _ENV
  if stateId == eBattleState.Deploy then
    UIManager:ShowWindowOnly(UIWindowTypeID.EpChipSuit)
  end
end

BattleDungeonBattleCtrl.GetRoleAppearEffect = function(self)
  -- function num : 0_4
  return ((self.bdCtrl).sceneCtrl):GetRoleAppearEffect()
end

BattleDungeonBattleCtrl.GetRoleDisappearEffect = function(self)
  -- function num : 0_5
  return ((self.bdCtrl).sceneCtrl):GetRoleDisappearEffect()
end

BattleDungeonBattleCtrl.DungeonBattleStepLogic = function(self, monsterGroup)
  -- function num : 0_6 , upvalues : DungeonBattleRoom, _ENV, DeployTeamUtil, BattleCustomMoveCtrl
  local battleRoomData = (DungeonBattleRoom.CreateBattleDungeonRoom)(self.bdCtrl, monsterGroup, (self.bdCtrl).dungeonCfg, (self.bdCtrl).dynPlayer)
  self.battleRoomData = battleRoomData
  if isEditorMode then
    local isBattleOffLine = ((CS.GMController).Instance).isBattleOffLine
  end
  do
    if not isBattleOffLine then
      local dungeonCfg = (self.bdCtrl).dungeonCfg
      ;
      (DeployTeamUtil.AutoBattleDeploy)(self.battleRoomData, ((self.bdCtrl).dynPlayer).heroList, dungeonCfg.size_row, dungeonCfg.size_col, dungeonCfg.deploy_rows, false)
    end
    local btlMgr = (CS.BattleManager).Instance
    local IsWithFormation = (self.battleRoomData).formation
    local battleCtrl = btlMgr:StartNewBattle(battleRoomData, (self.bdCtrl).dynPlayer, self, not IsWithFormation)
    if (BattleUtil.IsInBrotatBattle)() then
      self.CustomMoveCtrl = (BattleCustomMoveCtrl.CreateCustomMoveCtrl)(btlMgr)
    end
    if IsWithFormation then
      battleCtrl:StartEnterDeployState()
    else
      battleCtrl:StartBattleSkipDeploy()
    end
    if isBattleOffLine then
      return 
    end
    if ((self.bdCtrl).sceneCtrl).sceneWave ~= nil then
      UIManager:CreateWindowAsync(UIWindowTypeID.DungeonWaveTip, function(window)
    -- function num : 0_6_0 , upvalues : self
    window:InjectWave(((self.bdCtrl).sceneCtrl).sceneWave, (self.bdCtrl).dungeonId)
    window:Show()
  end
)
    end
  end
end

BattleDungeonBattleCtrl.ReqStartBattle = function(self, battleRoomData, originRoleList, battleAction)
  -- function num : 0_7 , upvalues : _ENV, base
  if (self.battleRoomData).formation then
    local roleCount = originRoleList.Count
    local sendMsg = {}
    sendMsg.data = {}
    for i = 0, roleCount - 1 do
      local role = originRoleList[i]
      local heroId = role.roleDataId
      local pos = (BattleUtil.XYCoord2Pos)(role.x, role.y)
      local uid = (((self.bdCtrl).dynPlayer):GetDynHeroByDataId(heroId)).uid
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (sendMsg.data)[uid] = pos
    end
    ;
    ((self.bdCtrl).battleNetwork):CS_BATTLE_StartBattleWithForm(sendMsg, function(objList)
    -- function num : 0_7_0 , upvalues : battleAction, base, self, battleRoomData, originRoleList
    if battleAction ~= nil then
      local randomSeed = 0
      if objList ~= nil and objList.Count > 0 then
        randomSeed = objList[0]
      end
      battleAction(randomSeed)
      ;
      (base.ReqStartBattle)(self, battleRoomData, originRoleList, battleAction)
    end
  end
)
  else
    do
      if battleAction ~= nil then
        battleAction()
        ;
        (base.ReqStartBattle)(self, battleRoomData, originRoleList, battleAction)
      end
    end
  end
end

BattleDungeonBattleCtrl.OnBattleStart = function(self, battleCtrl)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnBattleStart)(self, battleCtrl)
  local dInterfaceData = BattleDungeonManager.dunInterfaceData
  if dInterfaceData ~= nil then
    local enableRacingTime, lastRacingTime, hideCompare = dInterfaceData:GetDunRacingData()
    if enableRacingTime then
      local uiBattle = UIManager:GetWindow(UIWindowTypeID.Battle)
      if hideCompare then
        lastRacingTime = -1
      end
      ;
      (uiBattle.gameplayScore):StartBattleRacingShow(battleCtrl, lastRacingTime)
    end
  end
  do
    if self.CustomMoveCtrl ~= nil then
      (self.CustomMoveCtrl):BeginCustomControl(battleCtrl)
    end
  end
end

BattleDungeonBattleCtrl.OnBattleEnd = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_9 , upvalues : DungeonBattleBaseCtrl, _ENV
  local dealBattleEndEventFunc = function()
    -- function num : 0_9_0 , upvalues : dealBattleEndEvent, evenId
    dealBattleEndEvent(evenId)
  end

  self._isWin = evenId == (DungeonBattleBaseCtrl.eBattleEndType).Victory
  if evenId == (DungeonBattleBaseCtrl.eBattleEndType).Failure and (BattleUtil.IsBattleEnableFormation)() then
    self:_DailyDungeonFail(battleEndState, dealBattleEndEventFunc)
  else
    dealBattleEndEventFunc()
  end
  if self.CustomMoveCtrl ~= nil then
    (self.CustomMoveCtrl):EndCustomControl(battleEndState.battleController)
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

BattleDungeonBattleCtrl.ReqBattleSettle = function(self, battleEndState, requestData)
  -- function num : 0_10 , upvalues : _ENV, cs_BattleStatistics
  self.__waitSettleResult = true
  if (BattleUtil.IsInWinterChallengeDungeon)() then
    self._lastWinChallengeScore = (BattleDungeonManager.dunInterfaceData):GetDgWinChallengeCurScore()
  end
  local win = battleEndState.win
  local battleCtrl = battleEndState.battleController
  local playerRoleSettle = requestData.playerRoleSettle
  local monsterRoleSettle = requestData.monsterRoleSettle
  local battlePlayerController = battleCtrl.PlayerController
  local sendMsg = {}
  sendMsg.hero = {}
  sendMsg.monster = {}
  sendMsg.win = win
  sendMsg.misc = self:CreateBattleSettleMisc(battleCtrl)
  sendMsg.valid = self:CreateBattleSettleValid(battleCtrl, requestData)
  local isInTdMode = (BattleUtil.IsInTDBattle)()
  if isInTdMode then
    sendMsg.tdHeroCoord = {}
    sendMsg.tdHpPer = ((self.bdCtrl).dynPlayer).dungeonRoleHpPerDic
  end
  for k,v in pairs(playerRoleSettle) do
    -- DECOMPILER ERROR at PC48: Confused about usage of register: R15 in 'UnsetPending'

    (sendMsg.hero)[k] = v.hpPer
    local role = v.role
    if isInTdMode then
      local coord = self:__UpdatePlayerPosOnTDSettle(role.roleDataId, role.x, role.y)
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R17 in 'UnsetPending'

      if coord ~= nil then
        (sendMsg.tdHeroCoord)[k] = coord
      end
    end
  end
  for k,v in pairs(monsterRoleSettle) do
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R15 in 'UnsetPending'

    (sendMsg.monster)[k] = v.hpPer
  end
  sendMsg.hmp = ((self.bdCtrl).dynPlayer).playerUltSkillMp
  sendMsg.mp = ((self.bdCtrl).dynPlayer).playerSkillMp
  sendMsg.tdmp = ((self.bdCtrl).dynPlayer).playerTDMp or 0
  if (BattleUtil.IsInWinterChallengeDungeon)() then
    local combatStatStaticData = ((CS.BattleStatistics).Instance).combatStatStaticData
    -- DECOMPILER ERROR at PC98: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (sendMsg.valid).combatStat = {}
    local csBtCtrl = battleEndState.battleController
    cs_BattleStatistics:RecordBattleTime(csBtCtrl.frame, csBtCtrl.CrazyTime, true)
    if combatStatStaticData.TotalRecord ~= nil then
      for k,v in pairs(combatStatStaticData.TotalRecord) do
        -- DECOMPILER ERROR at PC115: Confused about usage of register: R17 in 'UnsetPending'

        ((sendMsg.valid).combatStat)[k] = v
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC123: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (sendMsg.valid).overkill = self.__overkillValue or 0
    ;
    ((self.bdCtrl).battleNetwork):CS_BATTLE_BattleSettle(sendMsg, function(dataList)
    -- function num : 0_10_0 , upvalues : win, _ENV, self, battleEndState
    if not win and not (BattleUtil.IsBattleEnableFormation)() then
      self:_NormalDungeonFail(battleEndState)
    end
    ;
    (self.bdCtrl):StartRunNextLogic()
    self.__waitSettleResult = false
  end
)
  end
end

BattleDungeonBattleCtrl._NormalDungeonFail = function(self, battleEndState)
  -- function num : 0_11 , upvalues : _ENV
  (PlayerDataCenter.cacheSaveData):SetIsEndBattleForHeroInteration(true)
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonFailureResult, function(window)
    -- function num : 0_11_0 , upvalues : battleEndState, self, _ENV
    if window == nil then
      return 
    end
    window:FailDungeon(function()
      -- function num : 0_11_0_0 , upvalues : battleEndState
      battleEndState:EndBattleAndClear()
    end
, function()
      -- function num : 0_11_0_1 , upvalues : self
      (self.bdCtrl):ExitBattleDungeon(false)
    end
, function()
      -- function num : 0_11_0_2 , upvalues : window, _ENV, battleEndState
      window:Hide()
      UIManager:ShowWindowAsync(UIWindowTypeID.ResultSkada, function(SkadaWindow)
        -- function num : 0_11_0_2_0 , upvalues : _ENV, battleEndState, window
        if SkadaWindow == nil then
          return 
        end
        SkadaWindow:InitBattleSkada((CS.BattleStatistics).Instance, ((battleEndState.battleController).PlayerTeamController).battleOriginRoleList, ((battleEndState.battleController).EnemyTeamController).battleOriginRoleList)
        SkadaWindow:SetSkadaCloseCallback(function()
          -- function num : 0_11_0_2_0_0 , upvalues : window
          window:Show()
        end
)
      end
)
    end
)
    if BattleDungeonManager.dunInterfaceData ~= nil and (BattleDungeonManager.dunInterfaceData):AbleFailRestart() then
      self.battleEndState = battleEndState
      if not self.__BattleDungeonAgain then
        self.__BattleDungeonAgain = BindCallback(self, self.BattleDungeonAgain)
        window:DungeonFaileSetPlayeAgain(self.__BattleDungeonAgain, BattleDungeonManager.dunInterfaceData)
        ;
        (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
      end
    end
  end
)
end

BattleDungeonBattleCtrl._DailyDungeonFail = function(self, battleEndState, dealBattleEndEventFunc)
  -- function num : 0_12 , upvalues : _ENV, DungeonConst, cs_BattleStatistics
  (PlayerDataCenter.cacheSaveData):SetIsEndBattleForHeroInteration(true)
  UIManager:ShowWindowAsync(UIWindowTypeID.BattleFail, function(win)
    -- function num : 0_12_0 , upvalues : self, DungeonConst, battleEndState, _ENV, dealBattleEndEventFunc, cs_BattleStatistics
    win:SetBattleFailEnterFmtFunc(function()
      -- function num : 0_12_0_0 , upvalues : self, DungeonConst, battleEndState, _ENV, dealBattleEndEventFunc
      (self.bdCtrl):AddDungeonLogic((DungeonConst.LogicType).DailyDungeonEnterFmt, nil, function()
        -- function num : 0_12_0_0_0 , upvalues : battleEndState, _ENV
        battleEndState:EndBattleAndClear()
        if (BattleUtil.IsInDailyDungeon)() then
          local dgDyncData = (BattleDungeonManager.dunInterfaceData):GetDgInterfaceDungeonDyncData()
          local dailyDgCtrl = ControllerManager:GetController(ControllerTypeId.DailyDungeonLevelCtrl, true)
          dailyDgCtrl:ReqEnterDailyDungeon(dgDyncData)
        else
          do
            if (BattleUtil.IsInWinterChallengeDungeon)() then
              local dgLvData = (BattleDungeonManager.dunInterfaceData):GetIDungeonLevelData()
              local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
              if sectorIICtrl ~= nil then
                sectorIICtrl:ReqEnterActSctIIChallengeDg(dgLvData)
              end
            end
          end
        end
      end
)
      dealBattleEndEventFunc()
    end
)
    win:InitBattleFail(function()
      -- function num : 0_12_0_1 , upvalues : self, DungeonConst, battleEndState, dealBattleEndEventFunc
      (self.bdCtrl):AddDungeonLogic((DungeonConst.LogicType).ExitDungeon, nil, function()
        -- function num : 0_12_0_1_0 , upvalues : battleEndState, self
        battleEndState:EndBattleAndClear()
        ;
        (self.bdCtrl):ExitBattleDungeon(false)
      end
)
      dealBattleEndEventFunc()
    end
, function()
      -- function num : 0_12_0_2 , upvalues : battleEndState
      battleEndState:RestartBattle()
    end
, function()
      -- function num : 0_12_0_3 , upvalues : win, _ENV, cs_BattleStatistics, battleEndState
      win:Hide()
      UIManager:ShowWindowAsync(UIWindowTypeID.ResultSkada, function(SkadaWindow)
        -- function num : 0_12_0_3_0 , upvalues : cs_BattleStatistics, battleEndState, win
        if SkadaWindow == nil then
          return 
        end
        SkadaWindow:InitBattleSkada(cs_BattleStatistics, ((battleEndState.battleController).PlayerTeamController).battleOriginRoleList, ((battleEndState.battleController).EnemyTeamController).battleOriginRoleList)
        SkadaWindow:SetSkadaCloseCallback(function()
          -- function num : 0_12_0_3_0_0 , upvalues : win
          win:SetIgnoreDelayFlagOnce(true)
          win:Show()
        end
)
      end
)
    end
)
    ;
    (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
  end
)
end

BattleDungeonBattleCtrl.VictoryBattleEndCoroutine = function(self, battleEndState)
  -- function num : 0_13 , upvalues : _ENV, DungeonConst, util
  (PlayerDataCenter.cacheSaveData):SetIsEndBattleForHeroInteration(true)
  local wave = ((self.bdCtrl).sceneCtrl).sceneWave
  local battleController = battleEndState.battleController
  if wave.total ~= wave.cur then
    battleController:PlayRecycleRoleEffect()
    battleEndState:EndBattleAndClear()
    return 
  end
  local CS_CameraController_Ins = (CS.CameraController).Instance
  self.__settleTimelinePause = false
  self.__showResultUI = false
  local playerRoleList = (battleController.PlayerTeamController).battleOriginRoleList
  local enemyRoleList = (battleController.EnemyTeamController).battleOriginRoleList
  local mvpGrade = (BattleUtil.GenMvp)(playerRoleList)
  local resultData = {playerRoleList = playerRoleList, enemyRoleList = enemyRoleList, 
lastHeroList = {}
}
  local dungeonPlayer = battleController.PlayerData
  for _,dynHero in ipairs(dungeonPlayer.heroList) do
    local lastHeroData = {}
    lastHeroData.exp = dynHero:GetCurExp()
    lastHeroData.level = dynHero:GetLevel()
    lastHeroData.totalExp = dynHero:GetTotalExp()
    ;
    (table.insert)(resultData.lastHeroList, lastHeroData)
  end
  local battleEndCoroutine = function()
    -- function num : 0_13_0 , upvalues : _ENV, CS_CameraController_Ins, battleController, mvpGrade, self, battleEndState, resultData, DungeonConst
    local isGuide = BattleDungeonManager:GetIsGuide()
    do
      if not isGuide then
        local win = UIManager:CreateWindow(UIWindowTypeID.DungeonResult)
        win:Hide()
      end
      CS_CameraController_Ins:PlaySettlementCut(battleController, mvpGrade.role, self:GetRoleMvpCameraOffset(mvpGrade.role))
      while self.__waitSettleResult do
        (coroutine.yield)()
      end
      local resMsg = ((self.bdCtrl).objectCtrl).rewardMsg
      ;
      (BattleDungeonManager.dunInterfaceData):DealDungeonResult(resMsg)
      if self.__settleTimelinePause then
        CS_CameraController_Ins:PauseSettlementCut(false)
      end
      while not self.__showResultUI do
        (coroutine.yield)()
      end
      self.battleEndState = battleEndState
      if ((self.bdCtrl).objectCtrl).dontShowResult then
        (self.bdCtrl):ExitBattleDungeon(true)
        return 
      end
      BattleDungeonManager:PlayMVPVoice((mvpGrade.role).roleDataId)
      local dungeonRoleList = (battleController.PlayerTeamController).battleRoleList
      self:PlayRoleWinActionAndEffect(dungeonRoleList, mvpGrade.role)
      local isAuto, isEndAoto = (BattleDungeonManager.autoCtrl):RecordAndCheckAutoState()
      local StOCareerItemIdDic = (ConfigData.game_config).STOCareerCostDic
      local showRewards = {}
      local StOCareerRewardDic = {}
      local activityExchangeDic = {}
      local notShowExtrAward = (BattleDungeonManager.dunInterfaceData):IsNotShowExtrAward()
      local extrAwardDic = {}
      ;
      (table.merge)(extrAwardDic, (ConfigData.activity_time_limit).exchangeMapping)
      if not notShowExtrAward then
        local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
        if sectorIICtrl ~= nil then
          local idDic = sectorIICtrl:GetAfterBattleShowItemDic()
          ;
          (table.merge)(extrAwardDic, idDic)
        end
      end
      do
        local AddItemFunc = function(resourceDic)
      -- function num : 0_13_0_0 , upvalues : _ENV, StOCareerItemIdDic, StOCareerRewardDic, notShowExtrAward, extrAwardDic, activityExchangeDic, showRewards
      for id,count in pairs(resourceDic) do
        local dic = nil
        if StOCareerItemIdDic[id] ~= nil then
          dic = StOCareerRewardDic
        else
          if not notShowExtrAward and extrAwardDic[id] ~= nil then
            dic = activityExchangeDic
          else
            dic = showRewards
          end
        end
        local newCount = dic[id] or 0
        dic[id] = newCount + count
      end
    end

        AddItemFunc(resMsg.innerRewards)
        AddItemFunc(resMsg.firstClear)
        AddItemFunc(resMsg.overRewards)
        local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
        aftertTeatmentCtrl:AddShowStOCareerReward(StOCareerRewardDic)
        aftertTeatmentCtrl:AddShowReward(activityExchangeDic)
        if isAuto then
          aftertTeatmentCtrl:AddDungeonAutoFightReward(BattleDungeonManager.dunInterfaceData, showRewards, (((self.bdCtrl).objectCtrl).rewardMsg).getATH, (BattleDungeonManager.autoCtrl):GetRealBattleCount())
        end
        local dunScoreServerData = resMsg.activityDailyChallengeDungeonScore
        UIManager:ShowWindowAsync(UIWindowTypeID.DungeonResult, function(window)
      -- function num : 0_13_0_1 , upvalues : _ENV, self, showRewards, resultData, mvpGrade, battleEndState, DungeonConst, battleController, dunScoreServerData, resMsg, isAuto
      if window == nil then
        return 
      end
      local isGuide = BattleDungeonManager:GetIsGuide()
      window:CompleteDungeon(isGuide, ((self.bdCtrl).objectCtrl).rewardMsg, showRewards, resultData, mvpGrade, (self.battleRoomData).dungeonType)
      if (BattleUtil.IsInWinterChallengeDungeon)() then
        local curScore = (BattleDungeonManager.dunInterfaceData):GetDgWinChallengeCurScore()
        do
          local scoreAdd = curScore - self._lastWinChallengeScore
          local dgLvData = (BattleDungeonManager.dunInterfaceData):GetIDungeonLevelData()
          local curDungeonId = BattleDungeonManager:TryGetCurBattleDungeonId()
          local isLastDg = dgLvData:IsSctIIChallengeDgLast(curDungeonId)
          window:InitWinterChallengeDgResult(scoreAdd, curScore, isLastDg, function()
        -- function num : 0_13_0_1_0 , upvalues : _ENV, battleEndState, dgLvData
        local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
        if sectorIICtrl ~= nil then
          battleEndState:EndBattleAndClear()
          sectorIICtrl:ReqEnterActSctIIChallengeDg(dgLvData)
        end
      end
)
          self:DgTryAddWinterChallengeScoreShow()
        end
      else
        do
          if (BattleUtil.IsInDailyDungeon)() then
            local dgDyncData = (BattleDungeonManager.dunInterfaceData):GetDgInterfaceDungeonDyncData()
            if dgDyncData.isDailyDungeonNew then
              dgDyncData = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
            end
            local isLastDungeon = dgDyncData:IsDgDyncComplete()
            window:InitDailyDgResult(isLastDungeon, function()
        -- function num : 0_13_0_1_1 , upvalues : battleEndState, _ENV, dgDyncData
        battleEndState:EndBattleAndClear()
        local dailyDgCtrl = ControllerManager:GetController(ControllerTypeId.DailyDungeonLevelCtrl, true)
        dailyDgCtrl:ReqEnterDailyDungeon(dgDyncData)
      end
)
          end
          do
            local winEvent = BattleDungeonManager:GetBattleWinEvent()
            if (BattleDungeonManager.dungeonCtrl).enterMsgData == nil or ((BattleDungeonManager.dungeonCtrl).enterMsgData).ab == nil then
              do
                local hasSupport = winEvent == nil
                winEvent(hasSupport)
                if not self.__ExitBattleDungeon then
                  self.__ExitBattleDungeon = BindCallback(self, self.ExitBattleDungeon)
                  if not self.__BattleDungeonAgain then
                    self.__BattleDungeonAgain = BindCallback(self, self.BattleDungeonAgain)
                    if not self.__BattleDungeonNext then
                      self.__BattleDungeonNext = BindCallback(self, self.BattleDungeonNextLevel)
                      if not self.__CheckCanAutoAgain then
                        self.__CheckCanAutoAgain = BindCallback(self, self.CheckCanAutoAgain)
                        ;
                        (self.bdCtrl):AddDungeonLogic((DungeonConst.LogicType).ExitDungeon, nil, self.__ExitBattleDungeon)
                        local continueFunc = function()
        -- function num : 0_13_0_1_2 , upvalues : self
        (self.bdCtrl):StartRunNextLogic()
      end

                        window:SetContinueCallback(continueFunc)
                        if BattleDungeonManager.dunInterfaceData ~= nil then
                          if not isGuide then
                            if (BattleDungeonManager.dunInterfaceData):AbleContinueNextLevel() then
                              window:DungeonSetPlayeNext(self.__BattleDungeonNext, BattleDungeonManager.dunInterfaceData)
                            else
                              local dungeonStageData = (BattleDungeonManager.dunInterfaceData):GetIDungeonStageData()
                              window:DungeonSetPlayeAgain(self.__BattleDungeonAgain, BattleDungeonManager.dunInterfaceData, dungeonStageData)
                            end
                          end
                          local enableRacingTime, lastRacingTime, hideCompare = (BattleDungeonManager.dunInterfaceData):GetDunRacingData()
                          if enableRacingTime then
                            local stime = (BattleDungeonManager.dunInterfaceData):GetDunRacingServerTime()
                            local frame = battleController.frame
                            local isNew = false
                            local isCheat = BattleUtil.CheatFrame <= stime
                            if lastRacingTime >= 0 and frame >= lastRacingTime then
                              do
                                isNew = isCheat
                                if isNew then
                                  isNew = not hideCompare
                                end
                                window:InitDungeonRacingResult(frame, isCheat, isNew)
                                local enableScoreAddRate, scoreAddRate = (BattleDungeonManager.dunInterfaceData):GetDunScoreAddRate()
                                if enableScoreAddRate then
                                  window:InitDungeonScoreAddRateResult(scoreAddRate, false)
                                end
                                do
                                  if dunScoreServerData ~= nil and dunScoreServerData[2] ~= nil then
                                    local springCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
                                    if springCtrl then
                                      local springData = springCtrl:GetTheLastSpring()
                                      if springData:IsActivityRunning() and springData:CheckIsSpringChallengeDungeon(dunScoreServerData[1]) then
                                        springData:UpdateDungeonFrameByDunId(dunScoreServerData[1], dunScoreServerData[2])
                                      else
                                        window:InitDungeonScoreResult(dunScoreServerData[2], false)
                                      end
                                    else
                                      window:InitDungeonScoreResult(dunScoreServerData[2], false)
                                    end
                                  end
                                  if (table.count)(resMsg.extraRewards) > 0 then
                                    UIManager:ShowWindowAsync(UIWindowTypeID.BattleResultExtra, function(resultExtraWindow)
        -- function num : 0_13_0_1_3 , upvalues : _ENV, resMsg
        if resultExtraWindow == nil then
          return 
        end
        if UIManager:GetWindow(UIWindowTypeID.DungeonResult) == nil then
          UIManager:DeleteWindow(UIWindowTypeID.BattleResultExtra)
          return 
        end
        resultExtraWindow:InitBattleResultExtra(resMsg.extraRewards)
      end
)
                                  end
                                  if isAuto then
                                    local battleCount = (BattleDungeonManager.autoCtrl):GetBattleCount()
                                    local totalCount = (BattleDungeonManager.autoCtrl):GetTotalDungeonAutoCount()
                                    if not self.__RealDungeonAgainCallback then
                                      do
                                        self.__RealDungeonAgainCallback = BindCallback(self, self.__RealBattleAgain)
                                        ;
                                        (BattleDungeonManager.autoCtrl):OnEnterBattleResult(self.__RealDungeonAgainCallback, self.__ExitBattleDungeon, self.__CheckCanAutoAgain, self.__BattleDungeonNext)
                                        window:InitAutoModeShow(battleCount, totalCount)
                                        -- DECOMPILER ERROR: 19 unprocessed JMP targets
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
)
      end
    end
  end

  return (util.cs_generator)(battleEndCoroutine)
end

BattleDungeonBattleCtrl.OnTimelineNoticeOpenResultUI = function(self)
  -- function num : 0_14 , upvalues : _ENV
  self.__showResultUI = true
  if self.__waitSettleResult then
    ((CS.CameraController).Instance):PauseSettlementCut(true)
    self.__settleTimelinePause = true
  end
end

BattleDungeonBattleCtrl.ReqBattleFreshFormation = function(self, battleController)
  -- function num : 0_15
end

BattleDungeonBattleCtrl.DungeonChipStepLogic = function(self, chipDataGroup)
  -- function num : 0_16 , upvalues : _ENV, ChipData
  local rewardChipList = {}
  for k,v in ipairs(chipDataGroup.alg) do
    local chipData = (ChipData.NewChipForServer)(v)
    rewardChipList[k] = chipData
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.SelectChip, function(window)
    -- function num : 0_16_0 , upvalues : _ENV, rewardChipList, self
    if window == nil then
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.OnSettleMentTimeLinePlayToEnd)
    window:InitSelectChip(false, rewardChipList, (self.bdCtrl).dynPlayer, BindCallback(self, self.__SelectChipComplete), BindCallback(self, self.__GiveSelectChipComplect), false, nil)
  end
)
end

BattleDungeonBattleCtrl.__SelectChipComplete = function(self, index, selectComplete)
  -- function num : 0_17
  index = index - 1
  ;
  ((self.bdCtrl).battleNetwork):CS_BATTLE_AlgSelect(index, function(dataList)
    -- function num : 0_17_0 , upvalues : self, selectComplete
    (self.bdCtrl):StartRunNextLogic()
    if selectComplete ~= nil then
      selectComplete()
    end
  end
)
end

BattleDungeonBattleCtrl.__GiveSelectChipComplect = function(self, selectComplete)
  -- function num : 0_18
  (self.epNetwork):CS_BATTLE_AlgGiveUp(function()
    -- function num : 0_18_0 , upvalues : selectComplete
    if selectComplete ~= nil then
      selectComplete()
    end
  end
)
end

BattleDungeonBattleCtrl.ReqGiveUpBattle = function(self, battleController)
  -- function num : 0_19 , upvalues : _ENV
  (battleController.fsm):ChangeState((CS.eBattleState).End)
  ;
  ((battleController.fsm).currentState):EndBattleAndClear()
  ;
  ((self.bdCtrl).battleNetwork):CS_BATTLE_Quit(function()
    -- function num : 0_19_0 , upvalues : _ENV
    GuideManager:BreakSkipGuide()
    BattleDungeonManager:ExitDungeon()
  end
)
end

BattleDungeonBattleCtrl.BattleDungeonAgain = function(self, dinterfaceData)
  -- function num : 0_20 , upvalues : cs_MessageCommon, _ENV, JumpManager
  if dinterfaceData == nil then
    return 
  end
  if dinterfaceData:RestartAthAlreadyFull() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    return 
  end
  if dinterfaceData:GetReplayStaminaReplaceItemId() == ConstGlobalItem.SKey and (PlayerDataCenter.stamina):GetCurrentStamina() < dinterfaceData:GetIStaminaCost() then
    JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
    return 
  end
  if dinterfaceData:RestartAthMaybeFull() then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(145), function()
    -- function num : 0_20_0 , upvalues : self, dinterfaceData
    self:__RealBattleAgain(dinterfaceData)
  end
, nil)
  else
    self:__RealBattleAgain(dinterfaceData)
  end
end

BattleDungeonBattleCtrl.__RealBattleAgain = function(self, dinterfaceData)
  -- function num : 0_21 , upvalues : _ENV
  if self.battleEndState ~= nil then
    (self.battleEndState):EndBattleAndClear()
  end
  local battleRestartEvent = dinterfaceData:GetIDungeonRestartEvent()
  if battleRestartEvent ~= nil then
    local formation = BattleDungeonManager:GetFormation()
    battleRestartEvent(formation, nil, dinterfaceData)
  end
end

BattleDungeonBattleCtrl.BattleDungeonNextLevel = function(self, dinterfaceData)
  -- function num : 0_22 , upvalues : cs_MessageCommon, _ENV, JumpManager
  if dinterfaceData == nil then
    return 
  end
  if dinterfaceData:RestartAthAlreadyFull() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
    return 
  end
  if dinterfaceData:GetINextStaminaReplaceItemId() == ConstGlobalItem.SKey and (PlayerDataCenter.stamina):GetCurrentStamina() < dinterfaceData:GetINextStaminaCost() then
    JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
    return 
  end
  if self.battleEndState ~= nil then
    (self.battleEndState):EndBattleAndClear()
  end
  local battleNextEvent = dinterfaceData:GetIDungeonNextLevelEvent()
  if battleNextEvent ~= nil then
    local formation = BattleDungeonManager:GetFormation()
    battleNextEvent(formation, nil, dinterfaceData)
  end
end

BattleDungeonBattleCtrl.CheckCanAutoAgain = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local dungeonStageData = (BattleDungeonManager.dunInterfaceData):GetIDungeonStageData()
  if #(PlayerDataCenter.allAthData):GetAllAthList() >= (ConfigData.game_config).athMaxNum - (ConfigData.game_config).athSpaceNotEnoughNum then
    local canContinue = dungeonStageData == nil or not dungeonStageData:IsHaveATHReward()
    do
      local reallyCannot = (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList()
      do return canContinue, ConfigData:GetTipContent(145), reallyCannot end
      do return true end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

BattleDungeonBattleCtrl._OnWinterChallengeScoreShow = function(self, msg)
  -- function num : 0_24 , upvalues : _ENV
  local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment, true)
  aftertTeatmentCtrl:AddShowReward(msg.rewards)
  self._winterChallengeScoreShowMsg = msg
end

BattleDungeonBattleCtrl.DgTryAddWinterChallengeScoreShow = function(self)
  -- function num : 0_25 , upvalues : _ENV, DungeonConst
  if self._winterChallengeScoreShowMsg == nil then
    return 
  end
  local msg = self._winterChallengeScoreShowMsg
  local ShowScoreFunc = function()
    -- function num : 0_25_0 , upvalues : _ENV, self, msg
    UIManager:ShowWindowAsync(UIWindowTypeID.WCDebuffResult, function(window)
      -- function num : 0_25_0_0 , upvalues : self, _ENV, msg
      if window == nil then
        return 
      end
      local nextFunc = function()
        -- function num : 0_25_0_0_0 , upvalues : self
        (self.bdCtrl):StartRunNextLogic()
      end

      local historyMaxScore = (BattleDungeonManager.dunInterfaceData):GetDgWinChallengeMaxScore()
      window:InitWinChallengeScoreShow(msg, self._isWin, historyMaxScore, nextFunc)
    end
)
  end

  ;
  (self.bdCtrl):AddDungeonLogic((DungeonConst.LogicType).WinterChallengeScoreShow, nil, ShowScoreFunc)
end

BattleDungeonBattleCtrl.__OnOverKillValueChange = function(self, value, isEnd)
  -- function num : 0_26
  if not isEnd then
    return 
  end
  self.__overkillValue = value or 0
end

BattleDungeonBattleCtrl.ExitBattleDungeon = function(self)
  -- function num : 0_27
  if self.battleEndState ~= nil then
    (self.battleEndState):EndBattleAndClear()
  end
  ;
  (self.bdCtrl):ExitBattleDungeon(true, true)
end

BattleDungeonBattleCtrl.OnDelete = function(self)
  -- function num : 0_28 , upvalues : _ENV, DungeonConst, DungeonBattleBaseCtrl
  if ((self.bdCtrl).objectCtrl).dontShowResult then
    PlayerDataCenter:UnlockCommanderSkill()
    if self.battleEndState ~= nil then
      (self.battleEndState):EndBattleAndClear()
    end
    return 
  end
  ;
  (self.bdCtrl):UnRegisterDungeonLogic((DungeonConst.LogicType).BattleStep, self.__battleStepLogic)
  ;
  (self.bdCtrl):UnRegisterDungeonLogic((DungeonConst.LogicType).ChipStep, self.__chipStepLogic)
  MsgCenter:RemoveListener(eMsgEventId.OnTimelineNoticeCreateResultUI, self.__OnTimelineNoticeOpenResultUI)
  MsgCenter:RemoveListener(eMsgEventId.WinterChallengeScoreShow, self._OnWinterChallengeScoreShowFunc)
  MsgCenter:RemoveListener(eMsgEventId.OnOverKillValueChange, self.__onOverKillValueChange)
  self.battleEndState = nil
  ;
  (DungeonBattleBaseCtrl.OnDelete)(self)
  if self.CustomMoveCtrl ~= nil then
    (self.CustomMoveCtrl):OnDelete()
    self.CustomMoveCtrl = nil
  end
end

return BattleDungeonBattleCtrl

