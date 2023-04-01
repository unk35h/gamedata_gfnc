-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessSeasonCtrl = class("WarChessSeasonCtrl")
local cs_ResLoader = CS.ResLoader
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
WarChessSeasonCtrl.ctor = function(self, seasonId, towerId, wcsEnvId)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData, cs_ResLoader
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_level)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_floor)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_season_item)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_general_env_pool)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_assist)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_monster_change)
  ConfigData:LoadDynCfg(eDynConfigData.warchess_tower_shop_drop)
  self.resloader = (cs_ResLoader.Create)()
  self.__wcSeasonId = seasonId
  self.__wcSeasonCfg = (ConfigData.warchess_season)[self.__wcSeasonId]
  self.__wcTowerId = towerId
  self.__wcsEnvId = wcsEnvId
  self.__wcsEnvCfg = (ConfigData.warchess_general_env_pool)[wcsEnvId]
  self.isInLobby = true
  self.isInFirstLobby = true
  self.__couldSelectWCLevelList = nil
  self.__formMsg = nil
  self.warChessSeasonFloor = 0
  self.wcsTotalScore = 0
  self.__curWCSRoomData = nil
end

WarChessSeasonCtrl.EnterWCSeasonLobbyByMsg = function(self, lobbyMessage, isReconnect)
  -- function num : 0_1 , upvalues : _ENV
  self.__couldSelectWCLevelList = lobbyMessage.RoomData
  self.__formMsg = (lobbyMessage.backLobbyReMainData).forms
  self.warChessSeasonFloor = (lobbyMessage.backLobbyReMainData).warChessSeasonFloor
  WarChessSeasonManager:SetOutSideInfo2WCManager()
  WarChessManager:EnterWarChessByOutMsg(lobbyMessage.backLobbyReMainData, isReconnect)
end

WarChessSeasonCtrl.GetWCSTowerId = function(self)
  -- function num : 0_2
  return self.__wcTowerId
end

WarChessSeasonCtrl.GetWCSSeasonId = function(self)
  -- function num : 0_3
  return self.__wcSeasonId
end

WarChessSeasonCtrl.GetWCSSeasonCfg = function(self)
  -- function num : 0_4
  return self.__wcSeasonCfg
end

WarChessSeasonCtrl.GetWCSOfficialSupportCfgId = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local towerID = WarChessSeasonManager:GetWCSSeasonTowerID()
  local floorIndex = self:WCSGetFloor()
  local floorCfg = ((ConfigData.warchess_season_floor)[towerID])[floorIndex]
  if floorCfg == nil then
    return 0
  end
  return floorCfg.assist_id
end

WarChessSeasonCtrl.GetWCEnvId = function(self)
  -- function num : 0_6
  return self.__wcsEnvId
end

WarChessSeasonCtrl.GetWCEnvCfg = function(self)
  -- function num : 0_7
  return self.__wcsEnvCfg
end

WarChessSeasonCtrl.WCSGetLobbyNextRoomDataMsg = function(self)
  -- function num : 0_8
  return self.__couldSelectWCLevelList
end

WarChessSeasonCtrl.WCSGetFloor = function(self)
  -- function num : 0_9
  return self.warChessSeasonFloor
end

WarChessSeasonCtrl.WCSGetIsAtLastFloor = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local curFloor = self:WCSGetFloor()
  local towerID = WarChessSeasonManager:GetWCSSeasonTowerID()
  local floorCfgs = (ConfigData.warchess_season_floor)[towerID]
  local maxFloor = #floorCfgs
  do return maxFloor <= curFloor end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessSeasonCtrl.WCSGetTotalScore = function(self)
  -- function num : 0_11
  return self.wcsTotalScore
end

WarChessSeasonCtrl.WCSSetTotalScore = function(self, wcsTotalScore)
  -- function num : 0_12
  self.wcsTotalScore = wcsTotalScore
end

WarChessSeasonCtrl.WCSSetSurWCSRoomData = function(self, curWCSRoomData)
  -- function num : 0_13
  self.__curWCSRoomData = curWCSRoomData
end

WarChessSeasonCtrl.WCSGetSurWCSRoomData = function(self)
  -- function num : 0_14
  return self.__curWCSRoomData
end

WarChessSeasonCtrl.Delete = function(self)
  -- function num : 0_15 , upvalues : _ENV, eDynConfigData
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.WCS3DUINode = nil
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_level)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_floor)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_season_item)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_general_env_pool)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_assist)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_monster_change)
  ConfigData:ReleaseDynCfg(eDynConfigData.warchess_tower_shop_drop)
end

return WarChessSeasonCtrl

