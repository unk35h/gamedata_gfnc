-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightCtrl = class("DormFightCtrl", ControllerBase)
local base = ControllerBase
local util = require("XLua.Common.xlua_util")
local DormEnum = require("Game.Dorm.DormEnum")
local cs_P3_PvpFight = (CS.P3).PvpFight
local cs_QualitySettings = (CS.UnityEngine).QualitySettings
local CS_pvpFightManager_ins = (CS.PvpFightManager).Instance
local DormFightUICtrl = require("Game.DormFight.Ctrl.DormFightUICtrl")
local DormFightAudioCtrl = require("Game.DormFight.Audio.DormFightAudioCtrl")
local DormFightEffectCtrl = require("Game.DormFight.Ctrl.DormFightEffectCtrl")
-- DECOMPILER ERROR at PC31: Confused about usage of register: R10 in 'UnsetPending'

ControllerBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, DormFightUICtrl, DormFightAudioCtrl, DormFightEffectCtrl
  self.ctrls = {}
  self._fightNetwork = NetworkManager:GetNetwork(NetworkTypeID.DormFight)
  self.dormFightUICtrl = (DormFightUICtrl.New)(self)
  self.dormFightAudioCtrl = (DormFightAudioCtrl.New)(self)
  ;
  (self.dormFightAudioCtrl):InitDormFightAudioCtrl()
  self.effectCtrl = (DormFightEffectCtrl.New)(self)
end

DormFightCtrl.TestEnterPvpEntry = function(self)
  -- function num : 0_1
  (self._fightNetwork):CS_PVP_Test_CreateRoom(1)
  self.isSingle = false
end

DormFightCtrl.TestEnterPvpEntrySingle = function(self)
  -- function num : 0_2
  (self._fightNetwork):CS_PVP_Test_CreateRoom(0)
  self.isSingle = true
end

DormFightCtrl.RecvPvpCreateRoom = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  if isGameDev then
    print("pvp server:" .. msg.PvpAddr)
    print((serpent.block)(msg))
  end
  local result = (string.split)(msg.PvpAddr, ":")
  if #result ~= 2 then
    error("pvp fight addr format error:" .. msg.PvpAddr)
  end
  local ip = result[1]
  local port = tostring(result[2])
  self:UpdatePvpRoomInfo(msg.roomId, msg.roomInfo, msg.token)
  self:StartDormFightConnectPvpServer(ip, port)
end

DormFightCtrl.UpdatePvpRoomInfo = function(self, roomId, roomInfo, token)
  -- function num : 0_4
  self.roomId = roomId
  self.roomInfo = roomInfo
  self._token = token
end

DormFightCtrl.StartDormFightConnectPvpServer = function(self, ip, port)
  -- function num : 0_5 , upvalues : CS_pvpFightManager_ins, _ENV, cs_P3_PvpFight
  self.CS_pvpFightController = CS_pvpFightManager_ins:StartNewPvpFight()
  ;
  (self.CS_pvpFightController):InitDormFight(self)
  local cs_netCtrl = CS_pvpFightManager_ins.PvpFightNetCtrl
  cs_netCtrl:CreatePvpTcpChannel(ip, port)
  cs_netCtrl:ConnectTcpChannel(function(result, ex)
    -- function num : 0_5_0 , upvalues : _ENV, cs_netCtrl, cs_P3_PvpFight, self
    if result == (CS.ConnectResults).Success then
      if IsNull(cs_netCtrl:GetNetworkCtrl((cs_P3_PvpFight.PvpNetworkCtrlID).Fight)) then
        cs_netCtrl:AddNetworkCtrl((cs_P3_PvpFight.PvpFightNetworkCtrl)())
      end
      self:OnDormPvpServerConnected()
    else
      error("Connect to Pvp Server fail, ex = " .. tostring(ex))
    end
  end
)
end

DormFightCtrl.OnDormPvpServerConnected = function(self)
  -- function num : 0_6
  (self.CS_pvpFightController):StartEnterSelectFighterState()
  local RoomInfo = self:CreateCSRoomInfo()
  ;
  (self.CS_pvpFightController):InitRoomInfo(RoomInfo)
  ;
  (self.CS_pvpFightController):ConfirmFighters()
  self:LoadDormFightScene()
end

DormFightCtrl.CreateCSRoomInfo = function(self, fighterList)
  -- function num : 0_7 , upvalues : cs_P3_PvpFight, _ENV
  local roomInfo = (cs_P3_PvpFight.RoomInfo)()
  roomInfo.selfUserId = (self.roomInfo).userId
  roomInfo.roomTypeId = (self.roomInfo).roomType
  roomInfo.roomId = self.roomId
  roomInfo.roomToken = self._token
  for i,player in pairs((self.roomInfo).players) do
    if player.isMaster then
      roomInfo.masterUserId = player.uid
    end
    local csPlayer = (cs_P3_PvpFight.RoomPlayer)(player.uid, player.bornPos)
    csPlayer.userName = "测试玩家"
    ;
    (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1002, 300200))
    ;
    (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1022, 302200))
    ;
    (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1013, 301303))
    ;
    (roomInfo.userList):Add(csPlayer)
  end
  do
    if self.isSingle then
      local csPlayer = (cs_P3_PvpFight.RoomPlayer)(9999999999, 2)
      csPlayer.userName = "测试玩家"
      ;
      (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1002, 300200))
      ;
      (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1022, 302200))
      ;
      (csPlayer.fighterInfos):Add((cs_P3_PvpFight.FighterInfo)(1013, 301303))
      ;
      (roomInfo.userList):Add(csPlayer)
    end
    return roomInfo
  end
end

DormFightCtrl.LoadDormFightScene = function(self)
  -- function num : 0_8 , upvalues : _ENV, cs_QualitySettings, DormEnum, util
  local preLoadFunc = function()
    -- function num : 0_8_0 , upvalues : self
    (self.dormFightUICtrl):OnPrepareDormFightUI(self.roomInfo)
  end

  UIManager:DeleteAllWindow()
  ;
  ((CS.RenderManager).Instance):SetUnityShadow(true)
  self.__oldShadowDistance = cs_QualitySettings.shadowDistance
  cs_QualitySettings.shadowDistance = DormEnum.DormShadowDistance
  self.__oldLoadBias = cs_QualitySettings.lodBias
  cs_QualitySettings.lodBias = DormEnum.DormLodBias
  local __OnLoadSceneOver = BindCallback(self, self.OnLoadSceneOver)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByABEx("009_Fight_002", true, false, __OnLoadSceneOver, (util.cs_generator)(preLoadFunc))
end

DormFightCtrl.OnLoadSceneOver = function(self)
  -- function num : 0_9
  (self.CS_pvpFightController):InitScene(function()
    -- function num : 0_9_0 , upvalues : self
    (self.CS_pvpFightController):SendIsReady()
    ;
    (self.dormFightUICtrl):OnEnterDormFightScene()
  end
)
end

DormFightCtrl.OnSyncNetStart = function(self)
  -- function num : 0_10
end

DormFightCtrl.ExitDormFightScene = function(self)
  -- function num : 0_11 , upvalues : _ENV, cs_QualitySettings
  ((CS.RenderManager).Instance):SetUnityShadow(false)
  if self.__oldShadowDistance ~= nil then
    cs_QualitySettings.shadowDistance = self.__oldShadowDistance
    self.__oldShadowDistance = nil
  end
  if self.__oldLoadBias ~= nil then
    cs_QualitySettings.lodBias = self.__oldLoadBias
    self.__oldLoadBias = nil
  end
end

DormFightCtrl.OnFightStateChange = function(self, pvpFightController, stateId)
  -- function num : 0_12
end

DormFightCtrl.DormFightStartSelectFighter = function(self, pvpFightController)
  -- function num : 0_13
end

DormFightCtrl.LoadingSceneCompleted = function(self, pvpFightController)
  -- function num : 0_14
end

DormFightCtrl.DormFightLoadReady = function(self, pvpFightController)
  -- function num : 0_15
end

DormFightCtrl.OnDormFightStart = function(self, pvpFightController)
  -- function num : 0_16
end

DormFightCtrl.FightSecondsChanged = function(self, pvpFightController, dormFightInGameState, seconds)
  -- function num : 0_17
  (self.dormFightUICtrl):FightSecondsChanged(pvpFightController, dormFightInGameState, seconds)
end

DormFightCtrl.OnDormFightEnd = function(self, battleEndState, eventId, dealBattleEndEvent)
  -- function num : 0_18 , upvalues : _ENV
  (self.dormFightUICtrl):OnFightEnd()
  print("dorm fight End!")
  dealBattleEndEvent(eventId)
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageBox, function(win)
    -- function num : 0_18_0 , upvalues : eventId, self, _ENV, battleEndState
    if win == nil then
      return 
    end
    win:ShowTextBoxWithConfirm(eventId == 1 and "胜利！" or "失败~", function()
      -- function num : 0_18_0_0 , upvalues : self, _ENV, battleEndState
      self:Delete()
      ;
      (self.dormFightUICtrl):Delete()
      UIManager:DeleteAllWindow()
      ;
      ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
        -- function num : 0_18_0_0_0 , upvalues : _ENV, battleEndState
        (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
        UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
          -- function num : 0_18_0_0_0_0 , upvalues : _ENV, battleEndState
          if window == nil then
            return 
          end
          window:SetFrom2Home(AreaConst.Sector, true)
          battleEndState:EndDormFightAndClear()
        end
)
      end
)
    end
)
  end
)
end

DormFightCtrl.ReqDormFightSettle = function(self, battleEndState, requestData)
  -- function num : 0_19
end

DormFightCtrl.VictoryDormFightEndCoroutine = function(self, battleEndState)
  -- function num : 0_20 , upvalues : _ENV, util
  local battleEndCoroutine = function()
    -- function num : 0_20_0 , upvalues : _ENV
    print("胜利!")
  end

  return (util.cs_generator)(battleEndCoroutine)
end

DormFightCtrl.GetSkinIdByFighterController = function(self, fighterController)
  -- function num : 0_21 , upvalues : _ENV
  if IsNull(fighterController) then
    return 
  end
  local skinId = ((fighterController.NetCharacter).NetId).PrefabId
  return skinId
end

DormFightCtrl.PlayEffect = function(self, fighterController, effectId)
  -- function num : 0_22 , upvalues : _ENV
  if self.effectCtrl ~= nil then
    local skinId = self:GetSkinIdByFighterController(fighterController)
    local skinCfg = (ConfigData.skin)[skinId]
    ;
    (self.effectCtrl):AddFighterEffectByDormFightEffectId(fighterController, effectId, skinCfg.src_id_pic, skinCfg.src_id_pic)
  end
end

DormFightCtrl.OnFighterNetSrart = function(self, fighterController)
  -- function num : 0_23 , upvalues : _ENV
  if IsNull(fighterController) then
    return 
  end
  local selfFighterEffectId = tonumber((ConfigData.dorm_fight_config).selfFighterEffectId)
  local enemyFighterEffectId = tonumber((ConfigData.dorm_fight_config).enemyFighterEffectId)
  local effectId = (fighterController.NetCharacter).IsOwnedBySelf and selfFighterEffectId or enemyFighterEffectId
  self:PlayEffect(fighterController, effectId)
end

DormFightCtrl.OnFighterHit = function(self, fighterController)
  -- function num : 0_24 , upvalues : _ENV
  local hitEffectId = tonumber((ConfigData.dorm_fight_config).hitEffectId)
  self:PlayEffect(fighterController, hitEffectId)
end

DormFightCtrl.ReqGiveUpFight = function(self, pvpFightController)
  -- function num : 0_25
end

DormFightCtrl.OnCreateFighter = function(self, pvpFightController, fighterController)
  -- function num : 0_26 , upvalues : _ENV
  if IsNull(pvpFightController) then
    return 
  end
  if IsNull(fighterController) then
    return 
  end
  ;
  (self.dormFightUICtrl):OnCreateFighter(fighterController)
  ;
  (self.dormFightAudioCtrl):OnCreateFighter(fighterController)
  local __OnFighterNetSrart = BindCallback(self, function()
    -- function num : 0_26_0 , upvalues : self, fighterController
    self:OnFighterNetSrart(fighterController)
  end
)
  local __OnHit = BindCallback(self, function()
    -- function num : 0_26_1 , upvalues : self, fighterController
    self:OnFighterHit(fighterController)
  end
)
  fighterController.OnStart = __OnFighterNetSrart
  fighterController.OnHit = __OnHit
end

DormFightCtrl.OnDestroyFighter = function(self, pvpFightController, fighterController)
  -- function num : 0_27 , upvalues : _ENV
  if IsNull(pvpFightController) then
    return 
  end
  if IsNull(fighterController) then
    return 
  end
  ;
  (self.effectCtrl):ClearFighterEffect(fighterController)
  ;
  (self.dormFightUICtrl):OnDestroyFighter(pvpFightController, fighterController)
  ;
  (self.dormFightAudioCtrl):OnDestroyFighter(fighterController)
  fighterController.OnStart = nil
  fighterController.OnHit = nil
end

DormFightCtrl.OnUpdateBtnWeapon = function(self, pvpFightController, netCharacter)
  -- function num : 0_28
  (self.dormFightUICtrl):OnUpdateBtnWeapon(netCharacter)
end

DormFightCtrl.OnUpdateBtnRun = function(self, pvpFightController, netCharacter)
  -- function num : 0_29
  (self.dormFightUICtrl):OnUpdateBtnRun(netCharacter)
end

DormFightCtrl.OnNetObjectLoadComplete = function(self, netId)
  -- function num : 0_30
end

DormFightCtrl.OnNetObjectDestroy = function(self, netId)
  -- function num : 0_31
end

DormFightCtrl.Delete = function(self)
  -- function num : 0_32
end

return DormFightCtrl

