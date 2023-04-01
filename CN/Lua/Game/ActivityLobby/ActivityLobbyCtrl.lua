-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ControllerBase
local ActivityLobbyCtrl = class("ActivityLobbyCtrl", base)
local util = require("XLua.Common.xlua_util")
local ActLbCmderCtrl = require("Game.ActivityLobby.Ctrl.ActLbCmderCtrl")
local ActLbAStarPathCtrl = require("Game.ActivityLobby.Ctrl.ActLbAStarPathCtrl")
local ActLbInputCtrl = require("Game.ActivityLobby.Ctrl.ActLbInputCtrl")
local ActLbCamCtrl = require("Game.ActivityLobby.Ctrl.ActLbCamCtrl")
local ActLbInteractCtrl = require("Game.ActivityLobby.Ctrl.ActLbInteractCtrl")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
local cs_GSceneManager_Ins = (CS.GSceneManager).Instance
ActivityLobbyCtrl.OnInit = function(self)
  -- function num : 0_0 , upvalues : ActLbCmderCtrl, ActLbAStarPathCtrl, ActLbInputCtrl, ActLbCamCtrl, ActLbInteractCtrl, _ENV, eDynConfigData, ActLbEnum
  self.ctrls = {}
  self.actLbCmderCtrl = (ActLbCmderCtrl.New)(self)
  self.actLbAStarPathCtrl = (ActLbAStarPathCtrl.New)(self)
  self.actLbInputCtrl = (ActLbInputCtrl.New)(self)
  self.actLbCamCtrl = (ActLbCamCtrl.New)(self)
  self.actLbIntrctCtrl = (ActLbInteractCtrl.New)(self)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby_interact_obj)
  self.__UpdateHandle = BindCallback(self, self._OnUpdate)
  UpdateManager:AddUpdate(self.__UpdateHandle)
  self.__LateUpdateHandle = BindCallback(self, self._OnLateUpdate)
  UpdateManager:AddLateUpdate(self.__LateUpdateHandle)
  self._actLbState = (ActLbEnum.eActLbState).Normal
end

ActivityLobbyCtrl.InitActLobbyCtrl = function(self, actId)
  -- function num : 0_1 , upvalues : _ENV
  self._actId = actId
  local actLbCfg = (ConfigData.activity_lobby)[self._actId]
  if actLbCfg == nil then
    error("Cant get activity_lobby cfg, actId:" .. tostring(self._actId))
    return 
  end
  self._actLbCfg = actLbCfg
  local avgId = (self._actLbCfg).first_avg
  self._isFirstEnter = (avgId > 0 and not (ControllerManager:GetController(ControllerTypeId.AvgPlay, true)):IsAvgPlayed(avgId))
  if self._isFirstEnter then
    (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    if ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl) == nil then
      return 
    end
    UIManager:DeleteAllWindow()
    self:EnterActLb()
  end
)
  else
    UIManager:DeleteAllWindow()
    self:EnterActLb()
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

ActivityLobbyCtrl.SkipActLbStartShow = function(self)
  -- function num : 0_2
  self._skipStartShow = true
end

ActivityLobbyCtrl.EnterActLb = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_GSceneManager_Ins, util
  self._isInLoadingScene = true
  UIManager:DeleteAllWindow()
  self.lbComResloader = ((CS.ResLoader).Create)()
  local preLoadFunc = BindCallback(self, self._OnScenePreload)
  local sceneLoadedFunc = BindCallback(self, self._OnSceneLoaded)
  cs_GSceneManager_Ins:LoadSceneAsyncByABEx((self._actLbCfg).scene_name, true, false, sceneLoadedFunc, (util.cs_generator)(preLoadFunc))
end

ActivityLobbyCtrl._OnScenePreload = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.lbComRes = {}
  local cmderPrefabWait = (self.lbComResloader):LoadABAssetAsyncAwait(PathConsts:GetCharacterActivityLobbyModelPath((self.actLbCmderCtrl):GetActLbCmderResPath()))
  local cmderHeadFxWait = (self.lbComResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath("CommonPrefab/Fx_CmdHeadGem"))
  ;
  (coroutine.yield)(cmderPrefabWait)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.lbComRes).cmderPrefab = cmderPrefabWait.Result
  ;
  (coroutine.yield)(cmderHeadFxWait)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.lbComRes).cmderHeadFxPrefab = cmderHeadFxWait.Result
end

ActivityLobbyCtrl._OnSceneLoaded = function(self)
  -- function num : 0_5 , upvalues : _ENV
  AudioManager:PlayAudioById((self._actLbCfg).bgm)
  local rootGo = (((CS.UnityEngine).GameObject).Find)("ActLobboyRoot")
  if IsNull(rootGo) then
    error("Cant find ActLobboyRoot")
    return 
  end
  self._bind = {}
  ;
  (UIUtil.LuaUIBindingTable)(rootGo.transform, self._bind)
  for k,v in ipairs(self.ctrls) do
    v:OnActLbSceneEnter(self._bind)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActLobbyMain, function(win)
    -- function num : 0_5_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitActLobbyMain(self)
    ;
    (self.actLbIntrctCtrl):UpdLbCurInteractList()
  end
)
  ;
  (self.actLbCamCtrl):ActLbPlayStartShowTimeLine(self._skipStartShow)
  self._isInLoadingScene = false
  if self._ExitAfterLoadedScene then
    self:_ExitCtrl()
  end
end

ActivityLobbyCtrl.GetActLbActId = function(self)
  -- function num : 0_6
  return self._actId
end

ActivityLobbyCtrl.GetActLbCfg = function(self)
  -- function num : 0_7
  return self._actLbCfg
end

ActivityLobbyCtrl.IsFirstEnterActLb = function(self)
  -- function num : 0_8
  return self._isFirstEnter
end

ActivityLobbyCtrl._OnUpdate = function(self)
  -- function num : 0_9
  (self.actLbCamCtrl):OnLbCamUpdate()
end

ActivityLobbyCtrl._OnLateUpdate = function(self)
  -- function num : 0_10
  (self.actLbCamCtrl):OnLbCamLateUpdate()
end

ActivityLobbyCtrl.ShowActLbUI = function(self, isShow)
  -- function num : 0_11 , upvalues : ActLbUtil, ActLbEnum, _ENV
  if isShow then
    (ActLbUtil.OnActLbInteractEnter)(false)
    self._actLbState = (ActLbEnum.eActLbState).Normal
    ;
    (UIUtil.ReShowTopStatus)()
    return 
  end
  ;
  (UIUtil.HideTopStatus)()
  ;
  (ActLbUtil.OnActLbInteractEnter)(true)
  self._actLbState = (ActLbEnum.eActLbState).HideUI
end

ActivityLobbyCtrl.SetActLbState = function(self, actLbState)
  -- function num : 0_12
  self._actLbState = actLbState
end

ActivityLobbyCtrl.IsActLbState = function(self, actLbState)
  -- function num : 0_13
  do return self._actLbState == actLbState end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityLobbyCtrl.ExitActLbCtrl = function(self, toHome)
  -- function num : 0_14
  self._exit2Home = toHome
  if self._isInLoadingScene then
    self._ExitAfterLoadedScene = true
    return 
  end
  self:_ExitCtrl()
end

ActivityLobbyCtrl._ExitCtrl = function(self)
  -- function num : 0_15 , upvalues : _ENV, cs_GSceneManager_Ins
  UIManager:DeleteAllWindow()
  self:Delete()
  if self._exit2Home then
    cs_GSceneManager_Ins:LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
    -- function num : 0_15_0 , upvalues : _ENV
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_15_0_0
      if window == nil then
        return 
      end
      window:SetFrom2Home(nil, true)
    end
)
  end
)
  else
    cs_GSceneManager_Ins:LoadSceneAsyncByAB((Consts.SceneName).Sector, function()
    -- function num : 0_15_1 , upvalues : _ENV
    (ControllerManager:GetController(ControllerTypeId.SectorController, true)):SetFrom(AreaConst.Home)
  end
)
  end
end

ActivityLobbyCtrl.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, eDynConfigData
  for k,v in ipairs(self.ctrls) do
    v:Delete()
  end
  if self.lbComResloader ~= nil then
    (self.lbComResloader):Put2Pool()
    self.lbComResloader = nil
  end
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby_interact_action)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby_interact_obj)
  UpdateManager:RemoveUpdate(self.__UpdateHandle)
  UpdateManager:RemoveLateUpdate(self.__LateUpdateHandle)
end

return ActivityLobbyCtrl

