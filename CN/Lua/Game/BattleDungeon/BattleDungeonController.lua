-- params : ...
-- function num : 0 , upvalues : _ENV
local BattleDungeonController = class("BattleDungeonController")
local ChipData = require("Game.PlayerData.Item.ChipData")
local Messenger = require("Framework.Common.Messenger")
local BattleDungeonSceneCtrl = require("Game.BattleDungeon.Ctrl.BattleDungeonSceneCtrl")
local BattleDungeonBattleCtrl = require("Game.BattleDungeon.Ctrl.BattleDungeonBattleCtrl")
local BattleDungeonObjectCtrl = require("Game.BattleDungeon.Ctrl.BattleDungeonObjectCtrl")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
BattleDungeonController.ctor = function(self, dungeonData, enterMsgData, formationData)
  -- function num : 0_0 , upvalues : Messenger, _ENV, BattleDungeonBattleCtrl, BattleDungeonObjectCtrl, BattleDungeonSceneCtrl
  self.ctrls = {}
  self.isGuide = false
  self.__dungeonLogicMessage = (Messenger.New)()
  self.__cacheDungeonLogic = {}
  if dungeonData.dungeonId == (GuideManager.firstBattleGuideCtrl).guideDungeonId then
    self.battleGuideType = (GuideManager.firstBattleGuideCtrl).battleGuideType
    local BattleDungeonGuideBatteCtrl = require("Game.BattleDungeon.Guide.BattleDungeonGuideBatteCtrl")
    self.battleCtrl = (BattleDungeonGuideBatteCtrl.New)(self, self.battleGuideType)
    local BattleDungeonGuideObjectCtrl = require("Game.BattleDungeon.Guide.BattleDungeonGuideObjectCtrl")
    self.objectCtrl = (BattleDungeonGuideObjectCtrl.New)(self, self.battleGuideType)
    self.isGuide = true
  else
    do
      self.battleCtrl = (BattleDungeonBattleCtrl.New)(self)
      self.objectCtrl = (BattleDungeonObjectCtrl.New)(self)
      self.sceneCtrl = (BattleDungeonSceneCtrl.New)(self)
      self.battleNetwork = NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)
      self:__InitDungeonCtrl(dungeonData, enterMsgData, formationData)
    end
  end
end

BattleDungeonController.__InitDungeonCtrl = function(self, dungeonData, enterMsgData, formationData)
  -- function num : 0_1 , upvalues : _ENV
  self.dungeonData = dungeonData
  self.enterMsgData = enterMsgData
  self.dungeonId = dungeonData.dungeonId
  self.dungeonCfg = (ConfigData.battle_dungeon)[self.dungeonId]
  if self.dungeonCfg == nil then
    error("battle dungeon cfg is null,id:" .. tostring(self.dungeonId))
  end
  local lastDeployData = BattleDungeonManager:GetLastDungeonDeploy()
  if enterMsgData ~= nil then
    for index,battleRole in pairs(dungeonData.role) do
      if (battleRole.stc).dataId == enterMsgData.astHeroId then
        battleRole.roleType = proto_object_EplBattleRoleType.BattleRoleFriendAssist
        break
      end
    end
  end
  do
    if (self.dungeonCfg).dungeon_type == proto_csmsg_DungeonType.DungeonType_TD then
      local TowerDefenceDynPlayer = require("Game.BattleDungeon.Data.TdDungeonDynPlayer")
      self.dynPlayer = (TowerDefenceDynPlayer.CreateTdDungeonPlayer)(dungeonData.role, dungeonData.player, self.dungeonCfg, lastDeployData, dungeonData.treeId)
    else
      do
        if (self.dungeonCfg).dungeon_type == proto_csmsg_DungeonType.DungeonType_GuardianProfessor then
          local GuardDungeonDynPlayer = require("Game.BattleDungeon.Data.GuardDungeonDynPlayer")
          self.dynPlayer = (GuardDungeonDynPlayer.CreateGuardDungeonPlayer)(dungeonData.role, dungeonData.player, self.dungeonCfg, lastDeployData, dungeonData.treeId)
        else
          do
            do
              local DungeonDynPlayer = require("Game.BattleDungeon.Data.DungeonDynPlayer")
              self.dynPlayer = (DungeonDynPlayer.CreateDungeonPlayer)(lastDeployData, (BattleDungeonManager.dunInterfaceData):GetDunFormationRuleCfg())
              ;
              (self.dynPlayer):InitDynPlayer(dungeonData.role, self.dungeonCfg, dungeonData.player, dungeonData.treeId)
              ;
              (self.dynPlayer):InitDynPlayerChip(dungeonData.algData)
              ;
              (self.dynPlayer):UpdateDungeonBuff(dungeonData.buffGroup)
              if self.dungeonId == (GuideManager.firstBattleGuideCtrl).guideDungeonId then
                (self.dynPlayer):InitPlayerSkillCustom(formationData.userSkill, formationData.cstId)
              end
              if dungeonData.player ~= nil then
                (self.dynPlayer):InitDynPlayerAttr((dungeonData.player).stc)
              end
            end
          end
        end
      end
    end
  end
end

BattleDungeonController.Start = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._waitFirstLoadScene = true
  ;
  (self.sceneCtrl):EnterDungeonScene((self.dungeonData).wave, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    if self._afterEnterSceneExit then
      BattleDungeonManager:RetreatDungeonNoReq()
      return 
    end
    local epWindow = UIManager:ShowWindow(UIWindowTypeID.DungeonStateInfo)
    epWindow:InitHeroAndChip(self.dynPlayer)
    local unlockChipSuit = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_TagSuit)
    do
      if unlockChipSuit then
        local epSuitWindow = UIManager:ShowWindow(UIWindowTypeID.EpChipSuit)
        epSuitWindow:InitEpChipSuit(self.dynPlayer)
        epSuitWindow:RefreshChipSuitSimpleUI()
        self.__onChipSuitUpdate = BindCallback(self, self._RefreshChipSuitItemPreview)
        MsgCenter:AddListener(eMsgEventId.OnEpChipSuitUpdate, self.__onChipSuitUpdate)
      end
      self:StartRunNextLogic()
      self:ShowDungeonBuffAndChip()
      self._waitFirstLoadScene = false
    end
  end
)
end

BattleDungeonController.DungeonIsInWaitFirstLoadScene = function(self)
  -- function num : 0_3
  return self._waitFirstLoadScene
end

BattleDungeonController.SetDungeonAfterEnterSceneExit = function(self)
  -- function num : 0_4
  self._afterEnterSceneExit = true
end

BattleDungeonController.ExitBattleDungeon = function(self, battleWin, notNeedWinEvent)
  -- function num : 0_5 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local param1 = battleWin and 2 or 3
  avgPlayCtrl:TryPlayTaskAvg(param1, function()
    -- function num : 0_5_0 , upvalues : self, _ENV, battleWin
    if self.battleGuideType ~= 1 then
      BattleDungeonManager:ExitDungeon(battleWin, true)
    end
  end
)
  if battleWin and not notNeedWinEvent then
    local winEvent = BattleDungeonManager:GetBattleWinEvent()
    if winEvent ~= nil then
      winEvent()
    end
  end
end

BattleDungeonController.StartRunNextLogic = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self:__TryRunTopLogic() then
    return 
  end
  self.__runLogicTimerId = TimerManager:StartTimer(1, self.__TryRunTopLogic, self, false, true)
end

BattleDungeonController.__TryRunTopLogic = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if #self.__cacheDungeonLogic > 0 then
    TimerManager:StopTimer(self.__runLogicTimerId)
    local logicData = (table.remove)(self.__cacheDungeonLogic, 1)
    ;
    (self.__dungeonLogicMessage):Broadcast(logicData.logicType, logicData.logicContent)
    if logicData.logicFunc ~= nil then
      (logicData.logicFunc)()
    end
    return true
  end
  do
    return false
  end
end

BattleDungeonController.AddDungeonLogic = function(self, logicType, msgData, func)
  -- function num : 0_8 , upvalues : _ENV
  local logicCacheData = {logicType = logicType, logicContent = msgData, logicFunc = func}
  ;
  (table.insert)(self.__cacheDungeonLogic, logicCacheData)
end

BattleDungeonController.RegisterDungeonLogic = function(self, logicId, action)
  -- function num : 0_9
  (self.__dungeonLogicMessage):AddListener(logicId, action)
end

BattleDungeonController.UnRegisterDungeonLogic = function(self, logicId, action)
  -- function num : 0_10
  (self.__dungeonLogicMessage):RemoveListener(logicId, action)
end

BattleDungeonController.CalculateBloodGrid = function(self, monsterList)
  -- function num : 0_11 , upvalues : _ENV
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
  for id,monsterRole in ipairs(monsterList) do
    local hp = monsterRole:GetRealAttr(eHeroAttr.maxHp)
    if maxHp ~= nil or not hp then
      maxHp = (math.max)(maxHp, hp)
    end
    if minHp ~= nil or not hp then
      minHp = (math.min)(minHp, hp)
    end
  end
  self.unitBlood = (BattleUtil.CalculateBloodGrid)(maxHp, minHp)
end

BattleDungeonController._RefreshChipSuitItemPreview = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.EpChipSuit)
  win:RefreshChipSuitSimpleUI()
end

BattleDungeonController.ShowDungeonBuffAndChip = function(self)
  -- function num : 0_13 , upvalues : _ENV
  self._firstChipEvent = nil
  if #(self.dungeonCfg).enter_chip_select > 0 then
    self._firstChipIndex = 1
    self._firstChipEvent = BindCallback(self, self.DungeonFirstSelectChip)
  end
  local isAuto = (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode()
  local buffList, buffCfgList = (self.dynPlayer):GetDungeonBuff()
  if not isAuto and buffList ~= nil and #buffList > 0 then
    local showBuffList = {}
    do
      for _,buffCfg in ipairs(buffCfgList) do
        if not buffCfg.is_hide then
          (table.insert)(showBuffList, buffCfg)
        end
      end
      if #showBuffList > 0 then
        UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_13_0 , upvalues : showBuffList, self
    win:InitDunBuffDesc(showBuffList, self._firstChipEvent)
  end
)
        local stateInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
        if stateInfoWin ~= nil then
          (stateInfoWin.buffList):InitBuffList((self.dynPlayer):GetDungeonBuffDataList())
          stateInfoWin:SetBuffListActive(true)
        end
        return 
      end
    end
  end
  do
    if self._firstChipEvent ~= nil then
      (self._firstChipEvent)()
    end
  end
end

BattleDungeonController.DungeonAbleSelectChip = function(self)
  -- function num : 0_14
  do return #(self.dungeonCfg).enter_chip_select > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

BattleDungeonController.DungeonRestartSelectChip = function(self)
  -- function num : 0_15
  (self.battleNetwork):CS_BATTLE_OpeningAlgSelect(0, function(dataList)
    -- function num : 0_15_0 , upvalues : self
    self._firstChipIndex = 1
    self:DungeonFirstSelectChip()
  end
)
end

BattleDungeonController.DungeonFirstSelectChip = function(self)
  -- function num : 0_16 , upvalues : _ENV, ChipData
  if self.dungeonCfg == nil then
    return 
  end
  if #(self.dungeonCfg).enter_chip_select < self._firstChipIndex then
    return 
  end
  local chipGroup = ((self.dungeonCfg).enter_chip_select)[self._firstChipIndex]
  local rewardChipList = {}
  for k,chipId in ipairs(chipGroup.chip_ids) do
    local chipCount = (chipGroup.chip_lvs)[k]
    local chipData = (ChipData.NewChipForLocal)(chipId, chipCount)
    rewardChipList[k] = chipData
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.SelectChip, function(window)
    -- function num : 0_16_0 , upvalues : _ENV, rewardChipList, self
    if window == nil then
      return 
    end
    MsgCenter:Broadcast(eMsgEventId.OnSettleMentTimeLinePlayToEnd)
    window:InitSelectChip(false, rewardChipList, self.dynPlayer, (BindCallback(self, self.__SelectChipComplete)), nil, false, nil)
  end
)
end

BattleDungeonController.GetBattleRoom = function(self)
  -- function num : 0_17
  if self.battleCtrl ~= nil then
    return (self.battleCtrl).battleRoomData
  end
  return nil
end

BattleDungeonController.__SelectChipComplete = function(self, index, selectComplete)
  -- function num : 0_18
  if self.dungeonCfg == nil then
    return 
  end
  local chipGroup = ((self.dungeonCfg).enter_chip_select)[self._firstChipIndex]
  local chipId = (chipGroup.chip_ids)[index]
  ;
  (self.battleNetwork):CS_BATTLE_OpeningAlgSelect(chipId, function(dataList)
    -- function num : 0_18_0 , upvalues : selectComplete, self
    if selectComplete ~= nil then
      selectComplete()
    end
    self._firstChipIndex = self._firstChipIndex + 1
    self:DungeonFirstSelectChip()
  end
)
end

BattleDungeonController.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV
  TimerManager:StopTimer(self.__runLogicTimerId)
  if self.__onChipSuitUpdate ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.OnEpChipSuitUpdate, self.__onChipSuitUpdate)
    self.__onChipSuitUpdate = nil
  end
  for k,v in pairs(self.ctrls) do
    v:OnDelete()
  end
  self.ctrls = nil
end

return BattleDungeonController

