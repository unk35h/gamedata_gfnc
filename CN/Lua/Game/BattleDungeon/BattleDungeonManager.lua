-- params : ...
-- function num : 0 , upvalues : _ENV
BattleDungeonManager = {}
local BattleDungeonController = require("Game.BattleDungeon.BattleDungeonController")
local BattleDungeonAutoCtrl = require("Game.BattleDungeon.Ctrl.BattleDungeonAutoCtrl")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
-- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.__Init = function(self)
  -- function num : 0_0 , upvalues : BattleDungeonAutoCtrl
  self.__inDungeon = false
  self.autoCtrl = (BattleDungeonAutoCtrl.New)()
end

-- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.IsInTDDungeon = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if not self:InBattleDungeon() then
    return false
  end
  local ctrl = self:GetDungeonCtrl()
  if ctrl == nil then
    return false
  end
  local dungeonCfg = ctrl.dungeonCfg
  if dungeonCfg == nil then
    return false
  end
  if dungeonCfg.dungeon_type == proto_csmsg_DungeonType.DungeonType_TD then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.IsInBrotatoDungeon = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not self:InBattleDungeon() then
    return false
  end
  local ctrl = self:GetDungeonCtrl()
  if ctrl == nil then
    return false
  end
  local dungeonCfg = ctrl.dungeonCfg
  if dungeonCfg == nil then
    return false
  end
  if dungeonCfg.dungeon_type == proto_csmsg_DungeonType.DungeonType_Brotato then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.IsInGuardDungeon = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not self:InBattleDungeon() then
    return false
  end
  local ctrl = self:GetDungeonCtrl()
  if ctrl == nil then
    return false
  end
  local dungeonCfg = ctrl.dungeonCfg
  if dungeonCfg == nil then
    return false
  end
  if dungeonCfg.dungeon_type == proto_csmsg_DungeonType.DungeonType_GuardianProfessor then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.InBattleDungeon = function(self)
  -- function num : 0_4
  return self.__inDungeon
end

-- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.RequestEnterDungeon = function(self, stageId, formationData, interfaceData, callBack, firstPower, benchPower)
  -- function num : 0_5 , upvalues : _ENV
  if self.__dungeonNetworkCtrl == nil then
    self.__dungeonNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)
  end
  local activateDrop = interfaceData:GetDIDExtraDrop()
  local activateDecompose = interfaceData:GetAutoDecompose()
  ;
  (self.__dungeonNetworkCtrl):CS_BATTLE_DungeonEnter(stageId, formationData, activateDrop, function(dataList)
    -- function num : 0_5_0 , upvalues : _ENV, self, interfaceData, callBack
    if dataList.Count == 0 then
      return 
    else
      if dataList.Count ~= 2 then
        error("CS_BATTLE_DungeonEnter callback data error")
        return 
      end
    end
    local EnterMsgData = dataList[0]
    local NtfEnterMsgData = dataList[1]
    self:RealEnterDungeon(NtfEnterMsgData, EnterMsgData, interfaceData)
    NetworkManager:HandleDiff(NtfEnterMsgData.syncUpdateDiff)
    if callBack ~= nil then
      callBack()
    end
  end
, firstPower, benchPower, activateDecompose)
end

-- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.RealEnterDungeon = function(self, NtfEnterMsgData, EnterMsgData, interfaceData)
  -- function num : 0_6 , upvalues : DungeonInterfaceData
  if self:InBattleDungeon() then
    self:ClearBattleDungeon()
  end
  if interfaceData == nil then
    interfaceData = (DungeonInterfaceData.CreateDefaultBattleInterface)()
  end
  self:BindDungeonInterface(interfaceData)
  return self:__EnterDungeon(NtfEnterMsgData, EnterMsgData)
end

-- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.BindDungeonInterface = function(self, interfaceData)
  -- function num : 0_7
  self.dunInterfaceData = interfaceData
end

-- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.__EnterDungeon = function(self, dungeonData, EnterMsgData)
  -- function num : 0_8 , upvalues : _ENV, BattleDungeonController
  if self.__formationData == nil then
    error("formation Data is null,can\'t to start battle dungeon")
    return nil
  end
  local dungeonCtrl = (BattleDungeonController.New)(dungeonData, EnterMsgData, self.__formationData)
  self.dungeonCtrl = dungeonCtrl
  self.__inDungeon = true
  UIManager:DeleteAllWindow()
  dungeonCtrl:Start()
  return dungeonCtrl
end

-- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetDungeonCtrl = function(self)
  -- function num : 0_9
  return self.dungeonCtrl
end

-- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetDungeonDynPlayer = function(self)
  -- function num : 0_10
  if self.dungeonCtrl == nil then
    return 
  end
  return (self.dungeonCtrl).dynPlayer
end

-- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetIsGuide = function(self)
  -- function num : 0_11
  return (self.dungeonCtrl).isGuide
end

-- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.AddDungeonLogic = function(self, logicType, msgData)
  -- function num : 0_12
  if not self:InBattleDungeon() then
    return 
  end
  ;
  (self.dungeonCtrl):AddDungeonLogic(logicType, msgData)
end

-- DECOMPILER ERROR at PC52: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.SaveFormation = function(self, formationData)
  -- function num : 0_13
  self.__formationData = formationData
end

-- DECOMPILER ERROR at PC55: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetFormation = function(self)
  -- function num : 0_14
  if self.__formationData ~= nil then
    return self.__formationData
  end
end

-- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.InjectBattleWinEvent = function(self, winEvent)
  -- function num : 0_15
  self.battleWinEvent = winEvent
end

-- DECOMPILER ERROR at PC61: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetBattleWinEvent = function(self)
  -- function num : 0_16
  return self.battleWinEvent
end

-- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.ClearBattleWinEvent = function(self)
  -- function num : 0_17
  self.battleWinEvent = nil
end

-- DECOMPILER ERROR at PC67: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.InjectBattleExitEvent = function(self, exitEvent)
  -- function num : 0_18
  self.battleExitEvent = exitEvent
end

-- DECOMPILER ERROR at PC70: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.ClearBattleDungeon = function(self, isLogout)
  -- function num : 0_19
  self.__inDungeon = false
  self.dunInterfaceData = nil
  if self.dungeonCtrl ~= nil then
    (self.dungeonCtrl):OnDelete()
    self.dungeonCtrl = nil
  end
  if isLogout then
    self.battleExitEvent = nil
    ;
    (self.autoCtrl):DungeonAutoReset()
  end
end

-- DECOMPILER ERROR at PC73: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.RestartDungeon = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local battleController = ((CS.BattleManager).Instance).CurBattleController
  if battleController ~= nil then
    (battleController.LuaBattleCtrl):ReqRestartBattle(battleController)
  end
end

-- DECOMPILER ERROR at PC76: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.RetreatDungeon = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local battleController = ((CS.BattleManager).Instance).CurBattleController
  if battleController ~= nil then
    (battleController.LuaBattleCtrl):ReqGiveUpBattle(battleController)
  end
end

-- DECOMPILER ERROR at PC79: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.RetreatDungeonNoReq = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local battleController = ((CS.BattleManager).Instance).CurBattleController
  if battleController ~= nil then
    (battleController.fsm):ChangeState((CS.eBattleState).End)
    ;
    ((battleController.fsm).currentState):EndBattleAndClear()
  end
  self:ExitDungeon()
end

-- DECOMPILER ERROR at PC82: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.ExitDungeon = function(self, isBatlleWin, withLoginVoice)
  -- function num : 0_23 , upvalues : _ENV
  (self.autoCtrl):ExitDungeonAutoModel()
  self._lastMvpVoiceHeroId = nil
  self._lastVoiceId = nil
  if not self:InBattleDungeon() then
    return 
  end
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_Character)
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_Monster)
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_SupSkill)
  AudioManager:RemoveCueSheet(eAuCueSheet.Battle_Buff)
  AudioManager:RemoveCueSheet(eAuCueSheet.CommonSkill)
  AudioManager:RemoveCueSheet(eAuCueSheet.Ambience)
  AudioManager:RemoveAllVoice()
  self:ClearBattleDungeon()
  BattleDungeonManager:ClearBattleWinEvent()
  UIManager:DeleteAllWindow()
  ;
  ((CS.UIManager).Instance):DeleteAllWindow()
  if self.battleExitEvent == nil then
    (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
    -- function num : 0_23_0 , upvalues : _ENV, withLoginVoice
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_23_0_0 , upvalues : _ENV, withLoginVoice
      if window == nil then
        return 
      end
      window:SetFrom2Home(AreaConst.Sector)
      if withLoginVoice then
        (window.homeController):PlayLoginHeroGreeting()
      end
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
      if aftertTeatmentCtrl ~= nil then
        aftertTeatmentCtrl:TeatmentBengin()
      end
    end
)
  end
)
  else
    ;
    (self.battleExitEvent)(isBatlleWin)
    self.battleExitEvent = nil
  end
end

-- DECOMPILER ERROR at PC85: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.GetLastDungeonDeploy = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.dunInterfaceData == nil or not (self.dunInterfaceData):IsNeedRecordFormation() then
    self.__lastDeployData = nil
    return 
  end
  local lastDeployData, dungeonStageData = nil, nil
  dungeonStageData = (self.dunInterfaceData):GetIDungeonStageData()
  if dungeonStageData ~= nil then
    local dungeonId, isFrageDungeon = (dungeonStageData.dungeonData).dungeonId, (dungeonStageData.dungeonData).isFrageDungeon
    local fileName = nil
    if isFrageDungeon then
      fileName = tostring(dungeonId) .. "_" .. tostring((dungeonStageData.dungeonData).itemId)
    else
      fileName = tostring(dungeonId)
    end
    lastDeployData = PersistentManager:LoadAndDecodeData((PersistentConfig.ePackage).DeploySaveData, fileName)
  else
    do
      if (self.dunInterfaceData):GetIDungeonLevelData() ~= nil then
        local dungeonLevelData = (self.dunInterfaceData):GetIDungeonLevelData()
        local dungeonId = dungeonLevelData:GetDungeonLevelStageId()
        if dungeonId ~= nil then
          local fileName = tostring(dungeonId)
          lastDeployData = PersistentManager:LoadAndDecodeData((PersistentConfig.ePackage).DeploySaveData, fileName)
        end
      end
      do
        self.__lastDeployData = lastDeployData
        return self.__lastDeployData
      end
    end
  end
end

-- DECOMPILER ERROR at PC88: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.SaveDungeonDeploy = function(self, dynPlayer)
  -- function num : 0_25 , upvalues : _ENV
  if self.__lastDeployData == nil then
    return 
  end
  local equal = true
  for _,dynHero in pairs(dynPlayer.heroList) do
    if not dynHero.onBench and ((self.__lastDeployData).hero_pos)[dynHero.dataId] ~= dynHero.coord then
      equal = false
      break
    end
  end
  do
    if equal then
      return 
    end
    local hero_pos = {}
    for _,dynHero in pairs(dynPlayer.heroList) do
      if not dynHero.onBench then
        hero_pos[dynHero.dataId] = dynHero.coord
      end
    end
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.__lastDeployData).hero_pos = hero_pos
    PersistentManager:SaveModelData((PersistentConfig.ePackage).DeploySaveData, self.__lastDeployData)
  end
end

-- DECOMPILER ERROR at PC91: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.PlayMVPVoice = function(self, heroId)
  -- function num : 0_26 , upvalues : _ENV
  local voiceId = 0
  if heroId == self._lastMvpVoiceHeroId then
    voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.MVP, self._lastVoiceId, heroId)
  else
    voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.MVP, nil, heroId)
  end
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  cvCtr:PlayCv(heroId, voiceId)
  self._lastMvpVoiceHeroId = heroId
  self._lastVoiceId = voiceId
end

-- DECOMPILER ERROR at PC94: Confused about usage of register: R3 in 'UnsetPending'

BattleDungeonManager.TryGetCurBattleDungeonId = function(self)
  -- function num : 0_27
  if self.dungeonCtrl == nil then
    return 
  end
  return (self.dungeonCtrl).dungeonId
end

BattleDungeonManager:__Init()

