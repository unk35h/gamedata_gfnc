-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessTeamCtrl = class("WarChessTeamCtrl", base)
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WCHeroEntity = require("Game.WarChess.Entity.WCHeroEntity")
local WarChessTeamData = require("Game.WarChess.Data.WarChessTeamData")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local DynHero = require("Game.Exploration.Data.DynHero")
local eWCInteractType = require("Game.WarChess.Interact.Base.eWCInteractType")
local EpMvpData = require("Game.Exploration.Data.EpMvpData")
local DeployTeamUtil = require("Game.Exploration.Util.DeployTeamUtil")
local FormationUtil = require("Game.Formation.FormationUtil")
local FmtEnum = require("Game.Formation.FmtEnum")
local util = require("XLua.Common.xlua_util")
local CS_BattleManager = (CS.BattleManager).Instance
local TEAM_MOVE_SPEED_PER_SECOND = 6
local MAX_MOVE_COST_TIME = 1.5
local ACC_TIME = 0.3
local ROTATE_COST_TIME = 0.1
WarChessTeamCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__fmtMaxNum = 3
  self.__ServerTeamInfoDic = nil
  self.__WCDeployHeroEntityDic = {}
  self.__WCHeroEntityDic = {}
  self.__TeamDic = {}
  self.__DeadTeamDic = {}
  self.__AllUsedHeroDic = {}
  self.__bornSuccess = false
  self.__bornOverCallback = nil
  self.__epMvpData = nil
  self.__startAniOk = false
  self.__startPlayCall = {}
  self.startPlayAnimaPlaying = false
  self.__onUpdateTeamStateCallback = {}
end

WarChessTeamCtrl.OnSceneLoadOver = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if self.__allLoadOverFunc ~= nil then
    for _,func in pairs(self.__allLoadOverFunc) do
      if func ~= nil then
        func()
      end
    end
    self.__allLoadOverFunc = nil
  end
end

WarChessTeamCtrl.InitByMsg = function(self, forms, isReconnect)
  -- function num : 0_2 , upvalues : _ENV, eWarChessEnum, FormationUtil, FmtEnum, WarChessTeamData
  for teamIndex,teamData in pairs(self.__TeamDic) do
    self:DeleteHeroEntity(teamIndex)
  end
  self.__TeamDic = {}
  self.__DeadTeamDic = {}
  self.__WCHeroEntityDic = {}
  do
    if isReconnect then
      local BattlePlayerDiff = {}
      for _,fInfo in pairs(forms) do
        local isDead = fInfo.teamState & (eWarChessEnum.eWCTeamState).Die > 0
        local isGhost = fInfo.teamState & (eWarChessEnum.eWCTeamState).Ghost > 0
        if isDead or fInfo.teamState & ((eWarChessEnum.eWCTeamState).WaitDeploy | (eWarChessEnum.eWCTeamState).WaitForm) <= 0 then
          local index = fInfo.teamUid & CommonUtil.UInt16Max
          local fmtId = (FormationUtil.GetFmtIdOffsetByFmtFromModule)((FmtEnum.eFmtFromModule).WarChess) + index
          local fmtData = (PlayerDataCenter.formationDic)[fmtId]
          if fmtData == nil then
            fmtData = PlayerDataCenter:CreateFormation(fmtId)
          end
          local name = fmtData.name
          if (string.IsNullOrEmpty)(name) then
            name = (string.format)(ConfigData:GetTipContent(TipContent.WarChess_TeamDefaultName), tostring(index))
          end
          local data = {index = fInfo.teamUid & CommonUtil.UInt16Max, fInfo = fInfo, teamName = name}
          local teamData = (WarChessTeamData.GetNewTeamDataByMsg)(data, fmtData)
          -- DECOMPILER ERROR at PC104: Confused about usage of register: R17 in 'UnsetPending'

          if not isDead then
            (self.__TeamDic)[teamData:GetWCTeamIndex()] = teamData
            BattlePlayerDiff[fInfo.teamUid] = fInfo.player
            if isGhost then
              teamData:SetWCTeamIsGhost(true)
            end
          else
            -- DECOMPILER ERROR at PC119: Confused about usage of register: R17 in 'UnsetPending'

            if isDead then
              (self.__DeadTeamDic)[teamData:GetWCTeamIndex()] = teamData
              teamData:SetWCTeamIsDead(true)
            else
              -- DECOMPILER ERROR at PC127: Confused about usage of register: R17 in 'UnsetPending'

              (self.__TeamDic)[teamData:GetWCTeamIndex()] = teamData
              BattlePlayerDiff[fInfo.teamUid] = fInfo.player
            end
          end
        end
      end
      self:UpdateWCCommander(BattlePlayerDiff)
      self.__bornSuccess = true
      if self.__bornOverCallback ~= nil then
        (self.__bornOverCallback)()
      end
      self.__bornOverCallback = nil
    end
    self.__fmtMaxNum = (table.count)(forms)
    self.__ServerTeamInfoDic = {}
    for _,fInfo in pairs(forms) do
      local index = fInfo.teamUid & CommonUtil.UInt16Max
      -- DECOMPILER ERROR at PC159: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self.__ServerTeamInfoDic)[index] = fInfo
    end
    -- DECOMPILER ERROR: 11 unprocessed JMP targets
  end
end

WarChessTeamCtrl.ReSetTeamStandGridData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for teamIndex,teamData in pairs(self.__TeamDic) do
    local logicPos = teamData:GetWCTeamLogicPos()
    if logicPos ~= nil then
      local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, logicPos)
      gridData:SetWCGridIsStandTeam(true)
    else
      do
        do
          error("team not has pos, index:" .. tostring(teamIndex))
          -- DECOMPILER ERROR at PC25: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC25: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC25: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

WarChessTeamCtrl.WCReaddAllChipData = function(self, forms)
  -- function num : 0_4 , upvalues : _ENV
  for _,fInfo in pairs(forms) do
    local index = fInfo.teamUid & CommonUtil.UInt16Max
    local teamData = self:GetTeamDataByTeamIndexIgnoreDead(index)
    if teamData ~= nil then
      teamData:UpdateTeamChipDiff(fInfo.alg)
    end
  end
end

WarChessTeamCtrl.GetOneFInfo = function(self, index)
  -- function num : 0_5
  return (self.__ServerTeamInfoDic)[index]
end

WarChessTeamCtrl.GetWCFmtNum = function(self)
  -- function num : 0_6
  return self.__fmtMaxNum
end

WarChessTeamCtrl.GetWCFmtShowNum = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local wcLevelCfg = WarChessManager:GetWCLevelCfg()
  if not wcLevelCfg.edit_team then
    return self.__fmtMaxNum
  end
end

WarChessTeamCtrl.GetWCFmtCurNum = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return (table.count)(self:GetWCTeams())
end

WarChessTeamCtrl.GetWCFmtCurDeadNum = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (table.count)(self.__DeadTeamDic)
end

WarChessTeamCtrl.GetDynDeployCouldUseIndex = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local deadIndexList = {}
  local freeIndexList = {}
  for teamIndex,teamData in pairs(self.__DeadTeamDic) do
    if #teamData:GetWCTeamChipList() > 0 then
      (table.insert)(deadIndexList, teamIndex)
    else
      ;
      (table.insert)(freeIndexList, teamIndex)
    end
  end
  local maxFmtNum = self:GetWCFmtNum()
  for index = 1, maxFmtNum do
    local teamData = self:GetTeamDataByTeamIndexIgnoreDead(index)
    if teamData == nil then
      (table.insert)(freeIndexList, index)
    end
  end
  return deadIndexList, freeIndexList
end

WarChessTeamCtrl.GetWCTeams = function(self)
  -- function num : 0_11
  return self.__TeamDic
end

WarChessTeamCtrl.InitTeams = function(self, deployTeamDic, callback)
  -- function num : 0_12 , upvalues : _ENV, WarChessTeamData, eWCInteractType, WarChessHelper, util
  if self._InitTeamCo ~= nil then
    (GR.StopCoroutine)(self._InitTeamCo)
  end
  local wid = (self.wcCtrl):GetWCId()
  local gameStartInfo = {
identify = {}
, 
formation = {}
, 
deploy = {}
}
  local msg = {wid = wid, gameStartInfo = gameStartInfo}
  local curTeamCount = 0
  for teamIndex,dTeamData in pairs(deployTeamDic) do
    local heroDic = dTeamData:GetDTeamHeroDic()
    local isOnGround = dTeamData:GetBornPoint() ~= nil
    if isOnGround and (table.count)(heroDic) > 0 then
      curTeamCount = curTeamCount + 1
      local fInfo = self:GetOneFInfo(curTeamCount)
      local wid = (self.wcCtrl):GetWCId()
      local fmtId = dTeamData:GetFmtId()
      local clientIndex = dTeamData:GetDTeamIndex()
      local power = dTeamData:GetDTeamTeamPower()
      local officeAssist = dTeamData:GetOfficeAssistData()
      local identify = {wid = wid, tid = fInfo.teamUid}
      ;
      (table.insert)(gameStartInfo.identify, identify)
      local notNeedRefresh = WarChessSeasonManager:GetIsInWCSeasonNotFirstLevel()
      do
        if not notNeedRefresh then
          local fmtMsg = {
formInfo = {formationId = fmtId, support = nil}
, fromFormationIdx = clientIndex, powerNum = power, assist = officeAssist}
          ;
          (table.insert)(gameStartInfo.formation, fmtMsg)
        end
        local index = fInfo.teamUid & CommonUtil.UInt16Max
        -- DECOMPILER ERROR at PC90: Confused about usage of register: R23 in 'UnsetPending'

        ;
        (self.__WCHeroEntityDic)[index] = (self.__WCDeployHeroEntityDic)[teamIndex]
        -- DECOMPILER ERROR at PC92: Confused about usage of register: R23 in 'UnsetPending'

        ;
        (self.__WCDeployHeroEntityDic)[teamIndex] = nil
        local teamData = (WarChessTeamData.GetNewTeamDataByDTeamData)(fInfo, dTeamData)
        -- DECOMPILER ERROR at PC100: Confused about usage of register: R24 in 'UnsetPending'

        ;
        (self.__TeamDic)[teamData:GetWCTeamIndex()] = teamData
        local teamLogicPos = teamData:GetWCTeamLogicPos()
        if teamLogicPos == nil then
          error("born team not have a born grid")
        end
        local bornGridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamLogicPos)
        bornGridData:SetWCGridIsStandTeam(true)
        local interactCfg = bornGridData:GetFirstGridInertactWithCat(eWCInteractType.born)
        do
          local deployData = {
wcPos = {gid = bornGridData:GetWCGridBFId(), pos = (WarChessHelper.Pos2Coordination)(bornGridData:GetGridLogicPos())}
, entityCat = (bornGridData:GetGridUnit()).entityCat, interactionId = interactCfg.id}
          ;
          (table.insert)(gameStartInfo.deploy, deployData)
          MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self.__startAniOk = false
  ;
  ((self.wcCtrl).palySquCtrl):SetWCStartPlayFunc(function()
    -- function num : 0_12_0 , upvalues : self
    self.__startAniOk = true
    self:_StartPlayEventsInvoke(self)
    self.startPlayAnimaPlaying = false
  end
)
  self._InitTeamCo = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self._CoOnInitTeamComplete, msg, callback)))
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

WarChessTeamCtrl._CoOnInitTeamComplete = function(self, msg, callback)
  -- function num : 0_13 , upvalues : _ENV
  local notInFirstLobyyStart = WarChessSeasonManager:GetIsInWCSeasonNotFirstLevel()
  if notInFirstLobyyStart then
    self:UpdateHeroDataByMsg({})
  end
  local Exit = function()
    -- function num : 0_13_0 , upvalues : self, _ENV
    if self._InitTeamCo ~= nil then
      (GR.StopCoroutine)(self._InitTeamCo)
    end
    WarChessManager:ExitWarChess()
  end

  local starting = true
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_GameStart(msg, function(args)
    -- function num : 0_13_1 , upvalues : _ENV, Exit, self, callback, starting
    if args.Count == 0 then
      error("args.Count == 0")
      Exit()
      return 
    end
    local isSuccess = args[0]
    if isSuccess then
      self.__bornSuccess = true
      self:InitWCMvpData()
      if self.__bornOverCallback ~= nil then
        (self.__bornOverCallback)()
      end
      if callback ~= nil then
        callback()
      end
      self.__bornOverCallback = nil
      starting = false
    else
      error("start wc error, exit Game")
      Exit()
      return 
    end
  end
)
  while starting do
    (coroutine.yield)(nil)
  end
  while not self.__startAniOk do
    (coroutine.yield)(nil)
  end
  WarChessSeasonManager:TryWcSsBuffSelect()
  self._InitTeamCo = nil
end

WarChessTeamCtrl._StartPlayEventsInvoke = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local invokeSet = {}
  for i,func in ipairs(self.__startPlayCall) do
    (table.insert)(invokeSet, func)
  end
  for _,func in ipairs(invokeSet) do
    if func then
      func()
    end
  end
end

WarChessTeamCtrl.StartPlayEventsAdd = function(self, callback)
  -- function num : 0_15 , upvalues : _ENV
  if type(callback) ~= "function" then
    assert(not callback, " callback 类型必须为 function")
    do
      local hasFlag = false
      for i,func in ipairs(self.__startPlayCall) do
        if func == callback then
          hasFlag = true
          break
        end
      end
      if not hasFlag then
        (table.insert)(self.__startPlayCall, 1, callback)
      end
      do return true end
      do return false end
      -- DECOMPILER ERROR: 5 unprocessed JMP targets
    end
  end
end

WarChessTeamCtrl.StartPlayEventsRemove = function(self, callback)
  -- function num : 0_16 , upvalues : _ENV
  local removeIdx = nil
  for i,func in ipairs(self.__startPlayCall) do
    if func == callback then
      removeIdx = i
      break
    end
  end
  do
    if removeIdx then
      (table.remove)(self.__startPlayCall, removeIdx)
      return true
    end
    return false
  end
end

WarChessTeamCtrl.WCDynDeployTeams = function(self, deployTeamDic, callback)
  -- function num : 0_17 , upvalues : _ENV, WarChessTeamData, eWCInteractType
  local needUpdateTeamDatas = {}
  for _,dTeamData in pairs(deployTeamDic) do
    local heroDic = dTeamData:GetDTeamHeroDic()
    local isOnGround = dTeamData:GetBornPoint() ~= nil
    local teamData = nil
    if isOnGround and (table.count)(heroDic) > 0 then
      local wid = (self.wcCtrl):GetWCId()
      local fmtId = dTeamData:GetFmtId()
      local index = dTeamData:GetInheritTeamIndex()
      local teamIndex = dTeamData:GetDTeamIndex()
      local power = dTeamData:GetDTeamTeamPower()
      local officeAssist = dTeamData:GetOfficeAssistData()
      local fInfo = self:GetOneFInfo(index)
      ;
      ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_FreshFormation(wid, fInfo.teamUid, fmtId, teamIndex, power, officeAssist)
      local deadTeamData = (self.__DeadTeamDic)[index]
      teamData = (WarChessTeamData.GetNewTeamDataByDTeamData)(fInfo, dTeamData, deadTeamData)
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self.__WCHeroEntityDic)[index] = (self.__WCDeployHeroEntityDic)[teamIndex]
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self.__WCDeployHeroEntityDic)[teamIndex] = nil
      -- DECOMPILER ERROR at PC63: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self.__TeamDic)[index] = teamData
      -- DECOMPILER ERROR at PC65: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self.__DeadTeamDic)[index] = nil
      ;
      (table.insert)(needUpdateTeamDatas, teamData)
    end
  end
  for _,teamData in ipairs(needUpdateTeamDatas) do
    local teamLogicPos = teamData:GetWCTeamLogicPos()
    if teamLogicPos ~= nil then
      local bornGridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamLogicPos)
      bornGridData:SetWCGridIsStandTeam(true)
      local interactCfg = bornGridData:GetFirstGridInertactWithCat(eWCInteractType.born)
      MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
      ;
      ((self.wcCtrl).interactCtrl):WCDealGridInteract(bornGridData, teamData, interactCfg, function(isSucess)
    -- function num : 0_17_0 , upvalues : _ENV, callback
    if not isSucess then
      error("<color=red>warChess team born interact error</color>")
    else
      if isGameDev then
        print("队伍动态出生成功")
      end
      if callback ~= nil then
        callback()
      end
    end
  end
)
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

WarChessTeamCtrl.SetBornOverCallback = function(self, callback)
  -- function num : 0_18
  if self.__bornSuccess then
    callback()
    return 
  end
  self.__bornOverCallback = callback
end

WarChessTeamCtrl.UpdateHeroDataByMsg = function(self, BattleRoleDic)
  -- function num : 0_19 , upvalues : _ENV, HeroData, DynHero, DeployTeamUtil
  if self.__AllHerosSTCDatas == nil then
    self.__AllHerosSTCDatas = {}
  end
  for heroId,battleRole in pairs(BattleRoleDic) do
    local stc = battleRole.stc
    local dyc = battleRole.dyc
    local roleType = dyc.roleType
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.__AllHerosSTCDatas)[stc.dataId] = stc
    local heroCfg = (ConfigData.hero_data)[stc.dataId]
    local heroData = (HeroData.New)({
basic = {id = stc.dataId, level = stc.level, exp = 0, star = stc.rank, potentialLvl = stc.potential, ts = -1, career = heroCfg.career, company = heroCfg.camp, skinId = stc.skinId, cat = stc.cat, containSpecialModelSign = dyc.containSpecialModelSign}
, spWeapon = stc.specWeapon})
    for k,v in pairs(stc.skillGroup) do
      if (heroData.skillDic)[k] ~= nil then
        ((heroData.skillDic)[k]):UpdateSkill(v)
      end
    end
    local dynHeroData = (DynHero.New)(heroData, stc.uid, roleType)
    dynHeroData:SetCoord(dyc.coordination, (ConfigData.buildinConfig).BenchX)
    dynHeroData:SetDynHeroFmtIdx(dyc.formationIdx)
    dynHeroData:UpdateHpPer(dyc.hpPer)
    dynHeroData:UpdateBaseHeroData(stc.attr, stc.skillGroup, stc.athSkillGroup, stc.additionSkillGroup, stc.rawAttr)
    dynHeroData:SetDynHeroTalentLevel(stc.talent)
    dynHeroData:SetExtraFixedPower(stc.talentEfficiency)
    -- DECOMPILER ERROR at PC92: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (self.__AllUsedHeroDic)[heroId] = dynHeroData
  end
  for teamIndex,teamData in pairs(self.__TeamDic) do
    local wcDynPlayer = teamData:GetTeamDynPlayer()
    local upDateChipFunc = wcDynPlayer:WCRefillTeamDynHeros(teamData, self.__AllUsedHeroDic)
    wcDynPlayer:UpdateHeroAttr(self.__AllHerosSTCDatas)
    if upDateChipFunc ~= nil then
      upDateChipFunc()
    end
    teamData:RefreshWCTeamPower()
    teamData:GenWCTeamHP()
    if teamData:GetSetInitialDeploy() then
      local size_row, size_col, deploy_rows = WarChessManager:GetEpSceneBattleFieldSize()
      ;
      (DeployTeamUtil.DeployHeroTeam)(wcDynPlayer.heroList, size_row, size_col, deploy_rows)
    end
  end
  for teamIndex,teamData in pairs(self.__DeadTeamDic) do
    local wcDynPlayer = teamData:GetTeamDynPlayer()
    local upDateChipFunc = wcDynPlayer:WCRefillTeamDynHeros(teamData, self.__AllUsedHeroDic)
    wcDynPlayer:UpdateHeroAttr(self.__AllHerosSTCDatas)
    if upDateChipFunc ~= nil then
      upDateChipFunc()
    end
  end
  MsgCenter:Broadcast(eMsgEventId.WC_TeamHeroSTCUpdate)
  MsgCenter:Broadcast(eMsgEventId.WC_HeroDynUpdate)
end

WarChessTeamCtrl.UpdateHeroDynDataByMsg = function(self, rolesDynDiff)
  -- function num : 0_20 , upvalues : _ENV, CS_BattleManager
  for heroId,dyc in pairs(rolesDynDiff.update) do
    if (self.__AllUsedHeroDic)[heroId] == nil then
      error("UpdateHeroDynDataByMsg:hero not exit heroId:" .. tostring(heroId))
    else
      local dynHeroData = (self.__AllUsedHeroDic)[heroId]
      dynHeroData:SetCoord(dyc.coordination, (ConfigData.buildinConfig).BenchX)
      dynHeroData:UpdateHpPer(dyc.hpPer)
      dynHeroData:SetDynHeroFmtIdx(dyc.formationIdx)
    end
  end
  local hpIsAdd = false
  for teamIndex,teamData in pairs(self.__TeamDic) do
    local preTeamHp = teamData:GetWCTeamHP()
    teamData:GenWCTeamHP()
    if preTeamHp < teamData:GetWCTeamHP() then
      hpIsAdd = true
    end
  end
  if hpIsAdd then
    AudioManager:PlayAudioById(1238)
  end
  if CS_BattleManager.IsInBattle then
    CS_BattleManager:UpdateBattleRoleData()
    local csBattlePlayCtrl = CS_BattleManager:GetBattlePlayerController()
    if csBattlePlayCtrl ~= nil and csBattlePlayCtrl.UltSkillHandle ~= nil then
      local battleRoleList = ((CS_BattleManager.CurBattleController).PlayerTeamController).battleOriginRoleList
      for i = 0, battleRoleList.Count - 1 do
        local role = battleRoleList[i]
        ;
        (csBattlePlayCtrl.UltSkillHandle):RefreshSideHeadHpRate(role)
      end
      ;
      (csBattlePlayCtrl.UltSkillHandle):RefreshSideHeadHpUI()
    end
  end
  do
    MsgCenter:Broadcast(eMsgEventId.WC_HeroDynUpdate)
  end
end

WarChessTeamCtrl.UpdateWCTeamByHeroFormDiff = function(self, formDiffDic)
  -- function num : 0_21 , upvalues : _ENV
  local needRefreshLeadTeamList = nil
  for tid,formDiff in pairs(formDiffDic) do
    local teamData = self:GetTeamDataByTeamUid(tid)
    if teamData ~= nil then
      local isNeedRefreshLeader = teamData:UpdateWCTeamFormDiff(formDiff)
      if isNeedRefreshLeader then
        if not needRefreshLeadTeamList then
          needRefreshLeadTeamList = {}
        end
        ;
        (table.insert)(needRefreshLeadTeamList, teamData)
      end
    else
      do
        do
          error("want to update not exist team formDiff tid(teamUID):" .. tostring(tid))
          -- DECOMPILER ERROR at PC32: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC32: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC32: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return needRefreshLeadTeamList
end

WarChessTeamCtrl.RefreshWCTeamLeaderInList = function(self, needRefreshLeadTeamList)
  -- function num : 0_22 , upvalues : _ENV
  for _,teamData in ipairs(needRefreshLeadTeamList) do
    local teamIndex = teamData:GetWCTeamIndex()
    local heroEntity = self:GetWCHeroEntity(teamIndex)
    if heroEntity ~= nil then
      heroEntity:Delete()
    end
    local firstHeroId = teamData:GetFirstHeroId()
    local logicPos = teamData:GetWCTeamLogicPos()
    local dynHeroData = self:GetHeroDynDataById(firstHeroId)
    self:LoadWCHeroEntity(teamIndex, dynHeroData, logicPos, true)
  end
  MsgCenter:Broadcast(eMsgEventId.WC_TeamLeaderChange)
end

WarChessTeamCtrl.UpdateWCCommander = function(self, battlePlayerDiff)
  -- function num : 0_23 , upvalues : _ENV
  for teamUid,battlePlayerDiff in pairs(battlePlayerDiff) do
    local teamData = self:GetTeamDataByTeamUid(teamUid)
    if teamData == nil then
      error("teamData is alreay not exist teamUid:" .. tostring(teamUid))
    else
      local dynPlyer = teamData:GetTeamDynPlayer()
      do
        do
          if battlePlayerDiff.stc ~= nil then
            local treeId = teamData:GetTeamCSTreeId()
            dynPlyer:InitDynPlayerAttr(battlePlayerDiff.stc)
            dynPlyer:InitPlayerSkill((battlePlayerDiff.stc).skillGroup, treeId)
          end
          dynPlyer:UpdatePlayerDyc(battlePlayerDiff.dyc)
          -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

WarChessTeamCtrl.GetWCTeamIdentify = function(self, teamData)
  -- function num : 0_24
  local wid = (self.wcCtrl):GetWCId()
  local tid = teamData:GetWCTeamId()
  return wid, tid
end

WarChessTeamCtrl.ReloadAllTeam = function(self, isNeedClean)
  -- function num : 0_25 , upvalues : _ENV
  if isNeedClean then
    for teamIndex,heroEntity in pairs(self.__WCHeroEntityDic) do
      heroEntity:Delete()
    end
  end
  do
    self.__WCHeroEntityDic = {}
    local allAsyncWaitList = {}
    self.__allLoadOverFunc = {}
    for teamIndex,teamData in pairs(self.__TeamDic) do
      local firstHeroId = teamData:GetFirstHeroId()
      local logicPos = teamData:GetWCTeamLogicPos()
      local dynHeroData = self:GetHeroDynDataById(firstHeroId)
      local asyncWaitList, loadOverFunc = self:LoadWCHeroEntity(teamIndex, dynHeroData, logicPos, false)
      ;
      (table.insertto)(allAsyncWaitList, asyncWaitList)
      ;
      (table.insert)(self.__allLoadOverFunc, loadOverFunc)
    end
    return allAsyncWaitList
  end
end

WarChessTeamCtrl.GetHeroDynDataById = function(self, heroId)
  -- function num : 0_26
  return (self.__AllUsedHeroDic)[heroId]
end

WarChessTeamCtrl.WCUpdateTeamState = function(self, teamStateMask)
  -- function num : 0_27 , upvalues : _ENV, eWarChessEnum
  for tid,state in pairs(teamStateMask) do
    local teamData = self:GetTeamDataByTeamUid(tid)
    if state ~= 0 then
      local normal = teamData == nil
      local isDead = state & (eWarChessEnum.eWCTeamState).Die > 0
      do
        local isGhost = state & (eWarChessEnum.eWCTeamState).Ghost > 0
        if normal then
          self:__DealTeamState(teamData, (eWarChessEnum.eWCTeamState).TeamStateNone)
        elseif isGhost then
          self:__DealTeamState(teamData, (eWarChessEnum.eWCTeamState).Ghost)
        elseif isDead then
          self:__DealTeamState(teamData, (eWarChessEnum.eWCTeamState).Die)
        end
        MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
        MsgCenter:Broadcast(eMsgEventId.WC_TeamStateUpdate, teamData)
        -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

WarChessTeamCtrl.__DealTeamState = function(self, teamData, state)
  -- function num : 0_28 , upvalues : eWarChessEnum, _ENV
  local teamIndex = teamData:GetWCTeamIndex()
  if state == (eWarChessEnum.eWCTeamState).TeamStateNone then
    local isGhost = teamData:GetWCTeamIsGhost()
    do
      if isGhost then
        teamData:SetWCTeamIsGhost(false)
        teamData:RefreshWCTeamPower()
        local heroEntity = self:GetWCHeroEntity(teamIndex, nil)
        if heroEntity ~= nil then
          do
            heroEntity:SetWCHeroIsGhost(false)
            -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  else
    if state == (eWarChessEnum.eWCTeamState).Ghost then
      teamData:SetWCTeamIsGhost(true)
      local heroEntity = self:GetWCHeroEntity(teamIndex, nil)
      if heroEntity ~= nil then
        heroEntity:SetWCHeroIsGhost(true)
      end
    else
      do
        if state == (eWarChessEnum.eWCTeamState).Die then
          local teamIndex = teamData:GetWCTeamIndex()
          teamData:SetWCTeamIsDead(true)
          -- DECOMPILER ERROR at PC52: Confused about usage of register: R5 in 'UnsetPending'

          ;
          (self.__DeadTeamDic)[teamIndex] = teamData
          -- DECOMPILER ERROR at PC54: Confused about usage of register: R5 in 'UnsetPending'

          ;
          (self.__TeamDic)[teamIndex] = nil
          local logicPos = teamData:GetWCTeamLogicPos()
          local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, logicPos)
          gridData:SetWCGridIsStandTeam(false)
          local heroEntity = self:GetWCHeroEntity(teamIndex)
          if heroEntity ~= nil then
            heroEntity:WCAnimatorSetTrigger("WarChess_Dead")
          end
          TimerManager:StartTimer(2, function()
    -- function num : 0_28_0 , upvalues : self, teamIndex, _ENV, teamData
    self:DeleteHeroEntity(teamIndex)
    MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
    MsgCenter:Broadcast(eMsgEventId.WC_TeamStateUpdate, teamData)
  end
, nil, true)
        end
      end
    end
  end
end

WarChessTeamCtrl.DealBattleFailTeam = function(self, teamData)
  -- function num : 0_29 , upvalues : eWarChessEnum
  local isGhost = teamData:GetWCTeamIsGhost()
  if not isGhost then
    self:__DealTeamState(teamData, (eWarChessEnum.eWCTeamState).Ghost)
    return 
  end
  self:__DealTeamState(teamData, (eWarChessEnum.eWCTeamState).Die)
end

WarChessTeamCtrl.LoadWCHeroEntity = function(self, teamIndex, firstHeroData, creatLogicPos, notWait)
  -- function num : 0_30 , upvalues : WCHeroEntity
  local heroEntityRoot = nil
  if notWait then
    heroEntityRoot = ((self.wcCtrl).bind).trans_heroRoot
  end
  local heroEntity = (WCHeroEntity.New)(firstHeroData, teamIndex)
  local teamData = self:GetTeamDataByTeamIndex(teamIndex)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.__WCHeroEntityDic)[teamIndex] = heroEntity
  return heroEntity:WCLoadHeroModel(creatLogicPos, notWait, heroEntityRoot, teamData)
end

WarChessTeamCtrl.GetWCHeroEntity = function(self, teamIndex, firstHeroData)
  -- function num : 0_31
  local heroEntity = (self.__WCHeroEntityDic)[teamIndex]
  if heroEntity ~= nil then
    heroEntity:Show()
  else
    if firstHeroData == nil then
      return nil
    end
    self:LoadWCHeroEntity(teamIndex, firstHeroData, nil, true)
    heroEntity = (self.__WCHeroEntityDic)[teamIndex]
  end
  return heroEntity
end

WarChessTeamCtrl.DeleteHeroEntity = function(self, teamIndex)
  -- function num : 0_32
  local heroEntity = (self.__WCHeroEntityDic)[teamIndex]
  if heroEntity ~= nil then
    heroEntity:Delete()
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__WCHeroEntityDic)[teamIndex] = nil
end

WarChessTeamCtrl.LoadWCDeployHeroEntity = function(self, teamIndex, firstHeroData, creatLogicPos, notWait)
  -- function num : 0_33 , upvalues : WCHeroEntity
  local heroEntityRoot = nil
  if notWait then
    heroEntityRoot = ((self.wcCtrl).bind).trans_heroRoot
  end
  local heroEntity = (WCHeroEntity.New)(firstHeroData, teamIndex)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.__WCDeployHeroEntityDic)[teamIndex] = heroEntity
  return heroEntity:WCLoadHeroModel(creatLogicPos, notWait, heroEntityRoot)
end

WarChessTeamCtrl.GetWCDeployHeroEntity = function(self, teamIndex, firstHeroData)
  -- function num : 0_34
  local heroEntityRoot = ((self.wcCtrl).bind).trans_heroRoot
  local heroEntity = (self.__WCDeployHeroEntityDic)[teamIndex]
  if heroEntity ~= nil then
    heroEntity:CheckFirstHeroModel(firstHeroData, true, heroEntityRoot)
    heroEntity:Show()
  else
    self:LoadWCDeployHeroEntity(teamIndex, firstHeroData, nil, true)
    heroEntity = (self.__WCDeployHeroEntityDic)[teamIndex]
  end
  return heroEntity
end

WarChessTeamCtrl.RefreshDeployHeroEntity = function(self, firstHeroData, teamIndex)
  -- function num : 0_35
  local heroEntityRoot = ((self.wcCtrl).bind).trans_heroRoot
  local heroEntity = (self.__WCDeployHeroEntityDic)[teamIndex]
  if heroEntity ~= nil and firstHeroData ~= nil then
    heroEntity:CheckFirstHeroModel(firstHeroData, true, heroEntityRoot)
  end
end

WarChessTeamCtrl.RecycleDeployHeroEntity = function(self, teamIndex)
  -- function num : 0_36
  local heroEntity = (self.__WCDeployHeroEntityDic)[teamIndex]
  if heroEntity ~= nil then
    heroEntity:Hide()
  end
end

WarChessTeamCtrl.DeleteAllDeployHeroEntity = function(self)
  -- function num : 0_37 , upvalues : _ENV
  for _,heroEntity in pairs(self.__WCDeployHeroEntityDic) do
    if heroEntity ~= nil then
      heroEntity:Delete()
    end
  end
  self.__WCDeployHeroEntityDic = {}
end

WarChessTeamCtrl.GetDeployHeroEntityByGo = function(self, heroEntityGo)
  -- function num : 0_38 , upvalues : _ENV
  for teamIndex,heroEntity in pairs(self.__WCDeployHeroEntityDic) do
    if heroEntity:GetWCHeroEntityGo() == heroEntityGo then
      return heroEntity
    end
  end
end

WarChessTeamCtrl.GetTeamDataByGo = function(self, heroEntityGo)
  -- function num : 0_39 , upvalues : _ENV
  for teamIndex,heroEntity in pairs(self.__WCHeroEntityDic) do
    if heroEntity:GetWCHeroEntityGo() == heroEntityGo and heroEntity ~= nil then
      local teamIndex = heroEntity:GetWCHeroEntityTeamIndex()
      local teamData = self:GetTeamDataByTeamIndex(teamIndex)
      return teamData
    end
  end
end

WarChessTeamCtrl.GetTeamDataByTeamUid = function(self, teamUid)
  -- function num : 0_40 , upvalues : _ENV
  for teamIndex,WCTeamData in pairs(self.__TeamDic) do
    if WCTeamData:GetWCTeamId() == teamUid then
      return WCTeamData
    end
  end
end

WarChessTeamCtrl.GetFirstAliveTeamPosV2 = function(self)
  -- function num : 0_41
  for i = 1, self.__fmtMaxNum do
    local teamData = (self.__TeamDic)[i]
    if teamData ~= nil then
      return teamData:GetWCTeamLogicPos()
    end
  end
  return nil
end

WarChessTeamCtrl.GetTeamDataByTeamIndex = function(self, teamIndex)
  -- function num : 0_42
  return (self.__TeamDic)[teamIndex]
end

WarChessTeamCtrl.GetDeadTeamDataByTeamIndex = function(self, teamIndex)
  -- function num : 0_43
  return (self.__DeadTeamDic)[teamIndex]
end

WarChessTeamCtrl.GetTeamDataByTeamIndexIgnoreDead = function(self, teamIndex)
  -- function num : 0_44
  local teamData = self:GetTeamDataByTeamIndex(teamIndex)
  if teamData == nil then
    teamData = self:GetDeadTeamDataByTeamIndex(teamIndex)
  end
  return teamData
end

WarChessTeamCtrl.GetTeamDataByLogicPos = function(self, logicPos)
  -- function num : 0_45 , upvalues : _ENV
  for teamIndex,WCTeamData in pairs(self.__TeamDic) do
    if WCTeamData:GetWCTeamLogicPos() == logicPos then
      return WCTeamData
    end
  end
end

WarChessTeamCtrl.GetDynHeroDicByTeamData = function(self, teamData)
  -- function num : 0_46 , upvalues : _ENV
  local dynHeroDic = {}
  local heroIdDic = teamData:GetWCTeamOrderDic()
  for index,heroId in pairs(heroIdDic) do
    local dynHero = self:GetHeroDynDataById(heroId)
    dynHeroDic[heroId] = dynHero
  end
  return dynHeroDic
end

WarChessTeamCtrl.SetTeamFace2Grid = function(self, teamIndex, gridData)
  -- function num : 0_47 , upvalues : _ENV, ROTATE_COST_TIME
  local teamData = self:GetTeamDataByTeamIndex(teamIndex)
  local heroEntity = self:GetWCHeroEntity(teamIndex, nil, nil)
  local targeShowPos = gridData:GetGridShowPos()
  local entityCurPos = heroEntity:WCHeroEntityGetShowPos()
  local moveToward = ((Vector3.Normalize)(targeShowPos - entityCurPos))
  local targetRotate = nil
  local rotatePassedTime = 0
  local curRotate = nil
  if (Vector3.Normalize)(heroEntity:WCHeroEntityGetForward()) ~= moveToward then
    local newRotate = (Quaternion.LookRotation)(moveToward, Vector3.up)
    if newRotate == nil then
      return false
    end
    targetRotate = newRotate
    rotatePassedTime = 0
    curRotate = heroEntity:WCHeroEntityGetRotate()
    heroEntity:WCAnimatorSetWalk(true)
  else
    do
      do return false end
      local RotateEntity_Update = function()
    -- function num : 0_47_0 , upvalues : _ENV, rotatePassedTime, ROTATE_COST_TIME, curRotate, targetRotate, heroEntity
    local deltaTime = Time.deltaTime
    rotatePassedTime = rotatePassedTime + deltaTime
    local rate = rotatePassedTime / ROTATE_COST_TIME
    local rotate = (Quaternion.Slerp)(curRotate, targetRotate, rate)
    heroEntity:WCHeroEntitySetRotate(rotate)
    if rate >= 1 then
      targetRotate = nil
      heroEntity:WCAnimatorSetWalk(false)
      return true
    end
    return false
  end

      return true, RotateEntity_Update
    end
  end
end

WarChessTeamCtrl.CalAllTeamCouldMoveGridDic = function(self)
  -- function num : 0_48 , upvalues : _ENV
  for teamIndex,WCTeamData in pairs(self.__TeamDic) do
    self:CalTeamCouldMoveGridDic(WCTeamData)
  end
end

WarChessTeamCtrl.CalTeamCouldMoveGridDic = function(self, teamData)
  -- function num : 0_49 , upvalues : WarChessHelper, _ENV
  local teamLogicPos = teamData:GetWCTeamLogicPos()
  local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamLogicPos)
  if startGrid == nil then
    return 
  end
  local couldReachGridDic, couldInetactDic, levelNubDic = (WarChessHelper.BSFAllCouldReachGrid)((self.wcCtrl).mapCtrl, startGrid, teamData)
  teamData:SetWCTeamMoveableGirdDic(couldReachGridDic)
  teamData:SetWCTeamLevelNubDic(levelNubDic)
  teamData:SetWCTeamInteractablePosDic(couldInetactDic)
  MsgCenter:Broadcast(eMsgEventId.WC_TeamCouldMoveGridChange, teamData)
end

WarChessTeamCtrl.MoveWCTeam2Grid = function(self, teamIndex, gridData)
  -- function num : 0_50 , upvalues : _ENV, WarChessHelper, TEAM_MOVE_SPEED_PER_SECOND, MAX_MOVE_COST_TIME, ACC_TIME, eWarChessEnum, ROTATE_COST_TIME
  local teamData = self:GetTeamDataByTeamIndex(teamIndex)
  local heroEntity = self:GetWCHeroEntity(teamIndex, nil, nil)
  if teamData == nil or heroEntity == nil or gridData == nil then
    return 
  end
  if not gridData:GetCouldStand() then
    return 
  end
  local logicPos = gridData:GetGridLogicPos()
  local targetGridTeamData = self:GetTeamDataByLogicPos(logicPos)
  if targetGridTeamData ~= nil then
    ((CS.MessageCommon).ShowMessageTips)("格子已有友方")
    return 
  end
  local teamLogicPos = teamData:GetWCTeamLogicPos()
  local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamLogicPos)
  local isOK, pathList = (WarChessHelper.AStrarPathFind)((self.wcCtrl).mapCtrl, startGrid, gridData, false, teamData)
  if isOK then
    local logicPos = gridData:GetGridLogicPos()
    do
      startGrid:SetWCGridIsStandTeam(false)
      gridData:SetWCGridIsStandTeam(true)
      teamData:SetWCTeamLogicPos(logicPos)
      heroEntity:WCAnimatorSetWalk(true)
      teamData:SetIsMoving(true)
      self:_StopTeamMoveAudio()
      self._moveAuBack = AudioManager:PlayAudioById(1254, function()
    -- function num : 0_50_0 , upvalues : self
    self._moveAuBack = nil
  end
)
      ;
      ((self.wcCtrl).wcCamCtrl):WcCamCustomFollow((heroEntity:GetWCHeroEntityGo()).transform, true)
      ;
      ((self.wcCtrl).wcCamCtrl):SetWcCamCanDragStopFollow(true)
      ;
      ((self.wcCtrl).animaCtrl):WCSetMoveableFXVisiabel(nil)
      local index = #pathList
      local targetRotate = nil
      local rotatePassedTime = 0
      local needCalRotate = true
      local wayLength = #pathList
      local isNeedAccMove = MAX_MOVE_COST_TIME < wayLength / TEAM_MOVE_SPEED_PER_SECOND
      local vMax = wayLength / (MAX_MOVE_COST_TIME - ACC_TIME)
      local totalPassedTime = 0
      local MoveEntity_Update = function()
    -- function num : 0_50_1 , upvalues : index, _ENV, self, teamIndex, teamData, eWarChessEnum, pathList, totalPassedTime, TEAM_MOVE_SPEED_PER_SECOND, isNeedAccMove, MAX_MOVE_COST_TIME, vMax, ACC_TIME, WarChessHelper, needCalRotate, targetRotate, rotatePassedTime, ROTATE_COST_TIME
    if index == 0 then
      warn("0 step move, pls check")
      return true
    end
    local moveHeroEntity = self:GetWCHeroEntity(teamIndex, nil, nil)
    local StopMoveFun = function(isSuccess)
      -- function num : 0_50_1_0 , upvalues : self, moveHeroEntity, teamData, _ENV, eWarChessEnum
      self:_StopTeamMoveAudio()
      ;
      ((self.wcCtrl).wcCamCtrl):WcCamCustomFollow(nil)
      ;
      ((self.wcCtrl).wcCamCtrl):SetWcCamCanDragStopFollow(false)
      if not isSuccess then
        return 
      end
      moveHeroEntity:WCAnimatorSetWalk(false)
      moveHeroEntity:WCAnimatorSetFloat("WarChess_WalkSpeed", 1)
      teamData:SetIsMoving(false)
      local moveOverCallback = teamData:GetMoveOverCallback()
      teamData:SetMoveOverCallback()
      if moveOverCallback ~= nil then
        moveOverCallback()
      end
      ;
      ((self.wcCtrl).animaCtrl):WCSetMoveableFXVisiabel(teamData)
      MsgCenter:Broadcast(eMsgEventId.WC_SelectTeam, teamData)
      local logicPos = teamData:GetWCTeamServerPos()
      WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).EnterWCGrid, logicPos)
    end

    if moveHeroEntity == nil then
      StopMoveFun()
      return true
    end
    if (CommonUtil.GetIsWarChessQuickMove)() then
      local targeShowPos = (pathList[1]):GetGridShowPos()
      local entityCurPos = moveHeroEntity:WCHeroEntityGetShowPos()
      local lastShowPos = pathList[2] and (pathList[2]):GetGridShowPos() or entityCurPos
      local newRotate = (Quaternion.LookRotation)(targeShowPos - lastShowPos, Vector3.up)
      moveHeroEntity:WCHeroEntitySetRotate(newRotate)
      moveHeroEntity:WCHeroEntitySetPos(targeShowPos)
      ;
      ((self.wcCtrl).animaCtrl):PlayWcHeroQuickMoveFx(entityCurPos, targeShowPos)
      MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
      StopMoveFun(true)
      return true
    end
    do
      local heroGo = moveHeroEntity:GetWCHeroEntityGo()
      if IsNull(heroGo) then
        return false
      end
      local deltaTime = Time.deltaTime
      totalPassedTime = totalPassedTime + deltaTime
      local maxMoveDis = TEAM_MOVE_SPEED_PER_SECOND * deltaTime
      do
        if isNeedAccMove then
          local speed = TEAM_MOVE_SPEED_PER_SECOND
          if totalPassedTime <= MAX_MOVE_COST_TIME then
            speed = vMax * (totalPassedTime / MAX_MOVE_COST_TIME)
            speed = (math.max)(speed, TEAM_MOVE_SPEED_PER_SECOND)
          else
            if MAX_MOVE_COST_TIME - ACC_TIME < totalPassedTime then
              speed = vMax * ((MAX_MOVE_COST_TIME - totalPassedTime) / ACC_TIME)
              speed = (math.max)(speed, TEAM_MOVE_SPEED_PER_SECOND)
            else
              speed = vMax
            end
          end
          maxMoveDis = speed * deltaTime
          moveHeroEntity:WCAnimatorSetFloat("WarChess_WalkSpeed", speed / TEAM_MOVE_SPEED_PER_SECOND)
        end
        local targeGrid = pathList[index]
        local targeShowPos = targeGrid:GetGridShowPos()
        local entityCurPos = moveHeroEntity:WCHeroEntityGetShowPos()
        local pos = (WarChessHelper.Vector3MoveToward)(entityCurPos, targeShowPos, maxMoveDis)
        moveHeroEntity:WCHeroEntitySetPos(pos)
        MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
        if needCalRotate then
          local moveToward = (Vector3.Normalize)(targeShowPos - entityCurPos)
          do
            do
              if moveToward:SqrMagnitude() > 0.001 and moveHeroEntity:WCHeroEntityGetForward() ~= moveToward then
                local newRotate = (Quaternion.LookRotation)(moveToward, Vector3.up)
                targetRotate = newRotate
                rotatePassedTime = 0
              end
              needCalRotate = false
              if targetRotate ~= nil then
                rotatePassedTime = rotatePassedTime + deltaTime
                local rate = rotatePassedTime / ROTATE_COST_TIME
                local curRotate = moveHeroEntity:WCHeroEntityGetRotate()
                local rotate = (Quaternion.Slerp)(curRotate, targetRotate, rate)
                moveHeroEntity:WCHeroEntitySetRotate(rotate)
                if rate >= 1 then
                  targetRotate = nil
                end
              end
              do
                if pos == targeShowPos then
                  index = index - 1
                  needCalRotate = true
                end
                if index == 0 then
                  StopMoveFun(true)
                  return true
                end
                return false
              end
            end
          end
        end
      end
    end
  end

      return true, BindCallback(self, MoveEntity_Update)
    end
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

WarChessTeamCtrl._StopTeamMoveAudio = function(self)
  -- function num : 0_51 , upvalues : _ENV
  if self._moveAuBack ~= nil then
    AudioManager:StopAudioByBack(self._moveAuBack)
    self._moveAuBack = nil
  end
end

WarChessTeamCtrl.UpdateTeamPosByMsg = function(self, formDiffPos)
  -- function num : 0_52 , upvalues : _ENV, WarChessHelper
  local isApAdded = false
  for _,teamDiffData in pairs(formDiffPos) do
    local tid = teamDiffData.tid
    do
      local curAP = teamDiffData.point
      local moveAnima = teamDiffData.moveAnima
      local BFId, coordination = nil, nil
      if teamDiffData.update ~= nil then
        BFId = (teamDiffData.update).gid
        coordination = (teamDiffData.update).pos
      end
      local alg = teamDiffData.alg
      local numericUpdate = teamDiffData.numericUpdate
      local ForceSetTeamPos = function(teamData, coordination)
    -- function num : 0_52_0 , upvalues : self, WarChessHelper, _ENV
    local earlySetPos = teamData:GetEarlySettedPos()
    if earlySetPos ~= nil then
      if coordination == earlySetPos then
        teamData:SetEarlySettedPos(nil)
        local curGridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamData:GetWCTeamLogicPos())
        curGridData:SetWCGridIsStandTeam(true)
      end
      do
        do return  end
        local x, y = (WarChessHelper.Coordination2Pos)(coordination)
        local logicPos = (Vector2.New)(x, y)
        local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamData:GetWCTeamLogicPos())
        local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, logicPos)
        startGrid:SetWCGridIsStandTeam(false)
        gridData:SetWCGridIsStandTeam(true)
        teamData:SetWCTeamLogicPos(logicPos)
        local heroEntity = self:GetWCHeroEntity((teamData:GetWCTeamIndex()), nil, nil)
        local targeShowPos = (Vector3.New)(logicPos.x, 0, logicPos.y)
        heroEntity:WCHeroEntitySetPos(targeShowPos)
        ;
        ((self.wcCtrl).wcCamCtrl):SetWcCamFollowPos(targeShowPos)
        self:CalTeamCouldMoveGridDic(teamData)
        MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
      end
    end
  end

      local isApAdd = false
      for teamIndex,teamData in pairs(self.__TeamDic) do
        do
          if teamData:GetTeamActionPoint() >= curAP then
            isApAdd = teamData:GetWCTeamId() ~= tid
            teamData:SetTeamActionPoint(curAP)
            teamData:UpdateTeamChipDiff(alg)
            if numericUpdate ~= nil and (table.count)(numericUpdate) > 0 then
              teamData:UpdateTeamNumericDiff(numericUpdate)
              MsgCenter:Broadcast(eMsgEventId.WC_TeamNumericChange, teamData, numericUpdate)
            end
            local curCoordination = (WarChessHelper.Pos2Coordination)(teamData:GetWCTeamLogicPos())
            if coordination ~= nil and curCoordination ~= coordination then
              if moveAnima then
                local x, y = (WarChessHelper.Coordination2Pos)(coordination)
                do
                  local targetGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
                  ;
                  ((self.wcCtrl).curState):WCPlayStateSelectTeam(teamData, true, true)
                  if teamData:GetIsMoving() then
                    ((self.wcCtrl).curState):SeTryAutoMoveMoverOverCallback(function()
    -- function num : 0_52_1 , upvalues : self, targetGrid, teamData, ForceSetTeamPos, coordination
    ((self.wcCtrl).curState):Walk2Grid(targetGrid, nil, true)
    teamData:SetMoveOverCallback(function()
      -- function num : 0_52_1_0 , upvalues : ForceSetTeamPos, teamData, coordination
      ForceSetTeamPos(teamData, coordination)
    end
)
  end
)
                  else
                    ((self.wcCtrl).curState):Walk2Grid(targetGrid, nil, true)
                    teamData:SetMoveOverCallback(function()
    -- function num : 0_52_2 , upvalues : ForceSetTeamPos, teamData, coordination
    ForceSetTeamPos(teamData, coordination)
  end
)
                  end
                end
              elseif teamData:GetIsMoving() then
                teamData:SetMoveOverCallback(function()
    -- function num : 0_52_3 , upvalues : ForceSetTeamPos, teamData, coordination
    ForceSetTeamPos(teamData, coordination)
  end
)
              else
                ForceSetTeamPos(teamData, coordination)
              end
            end
            local isChangeAlgLimit = teamDiffData.algLimitMask & 1 > 0
            if isChangeAlgLimit then
              local algLimit = teamDiffData.algLimitMask >> 1
              local dynPlyer = teamData:GetTeamDynPlayer()
              dynPlyer:UpDateWCDynPlayerChipLimit(algLimit)
            end
            -- DECOMPILER ERROR at PC135: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC135: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      if not isApAdded and isApAdd then
        AudioManager:PlayAudioById(1241)
        isApAdded = isApAdd
      end
    end
  end
  do return isApAdded end
  -- DECOMPILER ERROR: 9 unprocessed JMP targets
end

WarChessTeamCtrl.GetWcTeamHeroHpPer = function(self, heroId)
  -- function num : 0_53
  local dynHeroData = (self.__AllUsedHeroDic)[heroId]
  return dynHeroData and dynHeroData.hpPer or 10000
end

WarChessTeamCtrl.InitWCMvpData = function(self)
  -- function num : 0_54 , upvalues : EpMvpData, _ENV
  self.__epMvpData = (EpMvpData.New)(self.__AllUsedHeroDic)
  for heroId,dynHeroData in pairs(self.__AllUsedHeroDic) do
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R6 in 'UnsetPending'

    (self.__epMvpData).defaultMVPHeroId = dynHeroData.dataId
    do break end
  end
end

WarChessTeamCtrl.GetWCMvpData = function(self)
  -- function num : 0_55
  return self.__epMvpData
end

WarChessTeamCtrl.GetWCAPMaxNum = function(self)
  -- function num : 0_56 , upvalues : _ENV
  return (ConfigData.warchess_general).defaultAPLimit + ((self.wcCtrl).backPackCtrl):GetWCUserNumericNum(proto_object_WarChessNumeric.WarChessNumericModifyBehaviorPointLimit)
end

WarChessTeamCtrl.WcAllTeamHasAp = function(self)
  -- function num : 0_57 , upvalues : _ENV
  for k,teamData in pairs(self.__TeamDic) do
    if teamData:GetTeamActionPoint() > 0 then
      return true
    end
  end
  return false
end

WarChessTeamCtrl.GetAllTeamChip = function(self)
  -- function num : 0_58 , upvalues : _ENV
  local chipList = {}
  for k,v in pairs(self.__TeamDic) do
    local tempDynPlayer = v:GetTeamDynPlayer()
    if tempDynPlayer ~= nil then
      local tempList = tempDynPlayer:GetChipList()
      for _,v2 in pairs(tempList) do
        (table.insert)(chipList, v2)
      end
    end
  end
  return chipList
end

WarChessTeamCtrl.ResposeHeroEntity = function(self)
  -- function num : 0_59 , upvalues : _ENV
  if self.__WCHeroEntityDic ~= nil then
    for key,heroEntity in pairs(self.__WCHeroEntityDic) do
      if heroEntity ~= nil then
        heroEntity:Delete()
      end
    end
    self.__WCHeroEntityDic = {}
  end
end

WarChessTeamCtrl.OnSceneUnload = function(self)
  -- function num : 0_60
  self:ResposeHeroEntity()
end

WarChessTeamCtrl.Delete = function(self)
  -- function num : 0_61 , upvalues : _ENV
  self:_StopTeamMoveAudio()
  if self._InitTeamCo ~= nil then
    (GR.StopCoroutine)(self._InitTeamCo)
    self._InitTeamCo = nil
  end
  self:ResposeHeroEntity()
end

return WarChessTeamCtrl

