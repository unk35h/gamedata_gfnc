-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonTowerController = class("DungeonTowerController", ControllerBase)
local base = ControllerBase
local DungeonTypeTower = require("Game.DungeonCenter.Data.DungeonTypeTower")
local DungeonInterfaceData = require("Game.BattleDungeon.IData.DungeonInterfaceData")
local DungeonCenterUtil = require("Game.DungeonCenter.Util.DungeonCenterUtil")
local FmtEnum = require("Game.Formation.FmtEnum")
DungeonTowerController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__dunTowerNetwork = NetworkManager:GetNetwork(NetworkTypeID.DungeonTower)
end

DungeonTowerController.ShowDungeonTowerMain = function(self, closeFunc, openFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.__closeFunc = closeFunc
  self.__noProgressShow = false
  self._myRakDetail = nil
  self._cacheHeroPass = nil
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerSelect, function(window)
    -- function num : 0_1_0 , upvalues : self, openFunc
    if window == nil then
      return 
    end
    window:InitDungeonTowerSelect(self)
    if openFunc ~= nil then
      openFunc()
    end
  end
)
end

DungeonTowerController.DirectEnterTowerLevel = function(self, towerId, closeFunc, openFunc)
  -- function num : 0_2 , upvalues : _ENV, DungeonTypeTower
  self.__closeFunc = closeFunc
  self.__noProgressShow = true
  self._myRakDetail = nil
  self._cacheHeroPass = nil
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerSelect, function(window)
    -- function num : 0_2_0 , upvalues : DungeonTypeTower, towerId, self, _ENV, openFunc
    if window == nil then
      return 
    end
    local towerTypeData = (DungeonTypeTower.New)(towerId)
    window:InitDungeonTowerSelect(self, towerTypeData:GetTowerCategory())
    local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
    UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerLevel, function(window)
      -- function num : 0_2_0_0 , upvalues : self, towerTypeData, completeLevel, openFunc
      if window == nil then
        return 
      end
      window:InitDungeonTowerLevel(self, towerTypeData, completeLevel)
      if openFunc ~= nil then
        openFunc()
      end
    end
)
  end
)
end

DungeonTowerController.GetNeedAutoShowProgress = function(self)
  -- function num : 0_3
  return not self.__noProgressShow
end

DungeonTowerController.GetDungonTowerAutoBattleInfo = function(self, dungeonLevelData)
  -- function num : 0_4 , upvalues : _ENV
  if dungeonLevelData:IsTwinTowerLevel() then
    return false, false
  end
  local towerId = dungeonLevelData:GetDungeonTowerType()
  local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
  local levelNum = dungeonLevelData:GetDunTowerLevelNum()
  if levelNum <= completeLevel then
    return false, false
  end
  return true, true
end

DungeonTowerController.EnterDungeonTowerFormation = function(self, tmpDungeonLevelData, isAutoBattle)
  -- function num : 0_5 , upvalues : FmtEnum, _ENV, DungeonCenterUtil, DungeonInterfaceData
  local towerId = tmpDungeonLevelData:GetDungeonTowerType()
  local levelNum = tmpDungeonLevelData:GetDunTowerLevelNum()
  local towerTypeData = tmpDungeonLevelData:GetLevelTowerTypeData()
  local isTwinTower = (tmpDungeonLevelData:IsTwinTowerLevel())
  local fmtModule = nil
  if isTwinTower then
    fmtModule = (FmtEnum.eFmtFromModule).DungeonTwinTower
  else
    fmtModule = (FmtEnum.eFmtFromModule).DungeonTower
  end
  local ruleId = (towerTypeData:GetTowerFormationRuleId())
  local fmtRuleCfg = nil
  if ruleId > 0 then
    fmtRuleCfg = (ConfigData.formation_rule)[ruleId]
  end
  local autoBattleCount = 0
  if isAutoBattle then
    autoBattleCount = tmpDungeonLevelData:GetTowerTypeTotalLevel() - tmpDungeonLevelData:GetDunTowerLevelNum() + 1
  end
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local enterFunc = function()
    -- function num : 0_5_0 , upvalues : autoBattleCount, _ENV, tmpDungeonLevelData, DungeonCenterUtil
    if autoBattleCount > 0 then
      (BattleDungeonManager.autoCtrl):EnterDungeonAutoModel(tmpDungeonLevelData:GetTowerTypeTotalLevel(), true)
      ;
      (BattleDungeonManager.autoCtrl):SetStartDungeonAutoCount(autoBattleCount)
    end
    ;
    (DungeonCenterUtil.EnterDungeonFormationDeal)()
  end

  local exitFunc = function(fmtId)
    -- function num : 0_5_1 , upvalues : _ENV, DungeonCenterUtil
    if (BattleDungeonManager.autoCtrl):IsEnbaleDungeonAutoMode() then
      (BattleDungeonManager.autoCtrl):ExitDungeonAutoModel()
    end
    ;
    (DungeonCenterUtil.ExitDungeonFormationDeal)()
  end

  local commonBattleFunc = nil
  local nextBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_5_2 , upvalues : _ENV, commonBattleFunc
    if dinterfaceData == nil then
      error("dungeon interface data is null,can\'t to next level")
      return 
    end
    local dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    if dungeonLevelData == nil then
      error("dungeon tower level data is null,can\'t to next level")
      return 
    end
    local nextDunLevelData = dungeonLevelData:GetNextTowerLevelData()
    commonBattleFunc(curSelectFormationData, callBack, nextDunLevelData)
  end

  local startBattleFunc = nil
  startBattleFunc = function(curSelectFormationData, callBack, dinterfaceData)
    -- function num : 0_5_3 , upvalues : tmpDungeonLevelData, commonBattleFunc
    local dungeonLevelData = nil
    if dinterfaceData ~= nil then
      dungeonLevelData = dinterfaceData:GetIDungeonLevelData()
    else
      dungeonLevelData = tmpDungeonLevelData
    end
    commonBattleFunc(curSelectFormationData, callBack, dungeonLevelData)
  end

  commonBattleFunc = function(curSelectFormationData, callBack, dungeonLevelData)
    -- function num : 0_5_4 , upvalues : _ENV, fmtModule, towerId, DungeonInterfaceData, fmtRuleCfg, nextBattleFunc, startBattleFunc, fmtCtrl
    local needKey = dungeonLevelData:GetConsumeKeyNum()
    if (PlayerDataCenter.stamina):GetCurrentStamina() < needKey then
      JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
      return 
    end
    local curSelectFormationId = curSelectFormationData.id
    local formationData = (PlayerDataCenter.formationDic)[curSelectFormationId]
    if formationData == nil then
      return 
    end
    BattleDungeonManager:SaveFormation(formationData)
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetLastFromModuleFmtId(fmtModule, curSelectFormationId)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    BattleDungeonManager:InjectBattleExitEvent(function()
      -- function num : 0_5_4_0 , upvalues : _ENV, towerId
      local loadMatUIFunc = function()
        -- function num : 0_5_4_0_0 , upvalues : _ENV, towerId
        (UIUtil.CloseOneCover)("loadMatUIFunc")
        local dungeonTowerCtrl = ControllerManager:GetController(ControllerTypeId.DungeonTower, true)
        dungeonTowerCtrl:DirectEnterTowerLevel(towerId, function(tohome)
          -- function num : 0_5_4_0_0_0 , upvalues : _ENV
          local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
          sectorCtrl:ResetToNormalState(tohome)
        end
, function()
          -- function num : 0_5_4_0_0_1 , upvalues : _ENV
          local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
          if aftertTeatmentCtrl ~= nil then
            aftertTeatmentCtrl:BindResultAfterAction(function()
            -- function num : 0_5_4_0_0_1_0 , upvalues : _ENV
            local towerLevelWindow = UIManager:GetWindow(UIWindowTypeID.DungeonTowerLevel)
            if towerLevelWindow ~= nil then
              towerLevelWindow:InitLastTowerProgressShow()
            end
          end
)
            aftertTeatmentCtrl:TeatmentBengin()
          end
        end
)
      end

      ;
      (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
        -- function num : 0_5_4_0_1 , upvalues : _ENV, loadMatUIFunc
        local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController, true)
        ;
        (UIUtil.AddOneCover)("loadMatUIFunc")
        sectorCtrl:SetFrom(AreaConst.DungeonBattle, loadMatUIFunc)
        sectorCtrl:OnEnterDungeonTower()
      end
)
    end
)
    local dungeonTowerCtrl = ControllerManager:GetController(ControllerTypeId.DungeonTower, true)
    local towerId = dungeonLevelData:GetDungeonTowerType()
    local floorId = dungeonLevelData:GetDunTowerLevelNum()
    local interfaceData = (DungeonInterfaceData.CreateDungeonTowerInterface)(dungeonLevelData, fmtRuleCfg)
    if dungeonLevelData:HasNextTowerLevel() then
      local nextLevelData = dungeonLevelData:GetNextTowerLevelData()
      local nextKeyCost = nextLevelData:GetConsumeKeyNum()
      interfaceData:SetDungeonNextInfo(nextBattleFunc, nextKeyCost)
    end
    do
      interfaceData:SetDungeonReplayInfo(startBattleFunc, dungeonLevelData:GetConsumeKeyNum())
      local firstPower, benchPower = fmtCtrl:CalculatePower(formationData)
      dungeonTowerCtrl:RequestEnterDungeonTower(interfaceData, towerId, floorId, formationData, function()
      -- function num : 0_5_4_1 , upvalues : dungeonTowerCtrl, _ENV, callBack
      dungeonTowerCtrl:Delete()
      ControllerManager:DeleteController(ControllerTypeId.SectorController)
      if callBack ~= nil then
        callBack()
      end
    end
, firstPower, benchPower)
    end
  end

  local needKey = tmpDungeonLevelData:GetConsumeKeyNum()
  local stageId = tmpDungeonLevelData:GetDungeonLevelStageId()
  local lastFmtId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastFromModuleFmtId(fmtModule)
  fmtCtrl:ResetFmtCtrlState()
  local enterFmtData = ((((fmtCtrl:GetNewEnterFmtData()):SetFmtCtrlBaseInfo(fmtModule, stageId, lastFmtId)):SetFmtCtrlCallback(enterFunc, exitFunc, startBattleFunc)):SetEnterBattleCostTicketNum(needKey)):SetFormationRuleCfg(fmtRuleCfg)
  if isTwinTower then
    self:RequestTowerHeroPassInfo(towerId, levelNum, function(heroPassStats)
    -- function num : 0_5_5 , upvalues : enterFmtData, fmtCtrl
    enterFmtData:SetFmtHeroPassInfo(heroPassStats)
    fmtCtrl:EnterFormation()
  end
)
  else
    fmtCtrl:EnterFormation()
  end
end

DungeonTowerController.RequestEnterDungeonTower = function(self, interfaceData, towerId, floorId, formationData, callBack, firstPower, benchPower)
  -- function num : 0_6 , upvalues : _ENV
  (self.__dunTowerNetwork):CS_DUNGEONTOWER_Enter(towerId, floorId, formationData, function(dataList)
    -- function num : 0_6_0 , upvalues : _ENV, interfaceData, callBack
    if dataList.Count == 0 then
      return 
    end
    local NtfEnterMsgData = dataList[0]
    BattleDungeonManager:RealEnterDungeon(NtfEnterMsgData, nil, interfaceData)
    NetworkManager:HandleDiff(NtfEnterMsgData.syncUpdateDiff)
    if callBack ~= nil then
      callBack()
    end
  end
, firstPower, benchPower)
end

DungeonTowerController.RequestRacingRankSelfInfo = function(self, callback)
  -- function num : 0_7
  if self._myRakDetail ~= nil then
    callback(self._myRakDetail)
    return 
  end
  ;
  (self.__dunTowerNetwork):CS_DUNGEONTOWER_RacingRankSelfDetail(function(dataList)
    -- function num : 0_7_0 , upvalues : self, callback
    if dataList.Count == 0 then
      return 
    end
    local msg = dataList[0]
    self._myRakDetail = msg.myRank
    callback(self._myRakDetail)
  end
)
end

DungeonTowerController.RequestTowerHeroPassInfo = function(self, towerId, floorId, callback)
  -- function num : 0_8
  if self._cacheHeroPass ~= nil and (self._cacheHeroPass).towerId == towerId and (self._cacheHeroPass).floorId == floorId then
    callback((self._cacheHeroPass).stats)
    return 
  end
  ;
  (self.__dunTowerNetwork):CS_DUNGEONTOWER_HeroPassDetail(towerId, floorId, function(dataList)
    -- function num : 0_8_0 , upvalues : self, towerId, floorId, callback
    if dataList.Count == 0 then
      return 
    end
    local msg = dataList[0]
    self._cacheHeroPass = {towerId = towerId, floorId = floorId, stats = msg.stats}
    callback((self._cacheHeroPass).stats)
  end
)
end

DungeonTowerController.ExitDungeonTower = function(self, tohome)
  -- function num : 0_9
  if self.__closeFunc ~= nil then
    (self.__closeFunc)(tohome)
  end
  self:Delete()
end

DungeonTowerController.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  UIManager:DeleteWindow(UIWindowTypeID.DungeonTowerSelect)
  UIManager:DeleteWindow(UIWindowTypeID.DungeonTowerLevel)
  ;
  (base.OnDelete)(self)
end

return DungeonTowerController

