-- params : ...
-- function num : 0 , upvalues : _ENV
local GMNetworkCtrl = class("GMNetworkCtrl", NetworkCtrlBase)
GMNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self.gmOperationTab = {}
end

GMNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_GM_GMOperation, self, proto_csmsg.SC_GM_GMOperation, self.SC_GM_GMOperation)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_EXPLORATION_GM_COMPLETE, self, proto_csmsg.SC_EXPLORATION_GM_COMPLETE, self.SC_EXPLORATION_GM_COMPLETE)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_GM_ShieldGuide, self, proto_csmsg.SC_GM_ShieldGuide, self.SC_GM_ShieldGuide)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_GM_WarChessStart, self, proto_csmsg.SC_GM_WarChessStart, self.SC_GM_WarChessStart)
end

GMNetworkCtrl.CS_GM_GMOperation = function(self, id, param)
  -- function num : 0_2 , upvalues : _ENV
  self._lastGmId = id
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.gmOperationTab).id = id
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.gmOperationTab).param = param
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_GM_GMOperation, proto_csmsg.CS_GM_GMOperation, self.gmOperationTab)
end

GMNetworkCtrl.SC_GM_GMOperation = function(self, msg)
  -- function num : 0_3 , upvalues : _ENV
  if msg.ret ~= proto_csmsg_ErrorCode.None then
    local err = "GMNetworkCtrl:SC_GM_GMOperation error:" .. tostring(msg.ret)
    self:ShowSCErrorMsg(err)
  else
    do
      print("GM Success")
      do
        if self._lastGmId == proto_csmsg_GMType.GMTypeSuperman then
          local msg = "使用了GM SuperMan，需要重开游戏，否则可能会有未知问题。"
          warn(msg)
          ;
          ((CS.MessageCommon).ShowMessageBox)(msg, function()
    -- function num : 0_3_0 , upvalues : _ENV
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R0 in 'UnsetPending'

    if isEditorMode then
      ((CS.UnityEditor).EditorApplication).isPlaying = false
    else
      ;
      (((CS.UnityEngine).Application).Quit)()
    end
  end
, nil)
        end
        NetworkManager:HandleDiff(msg.syncUpdateDiff)
      end
    end
  end
end

GMNetworkCtrl.SC_EXPLORATION_GM_COMPLETE = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Exploration)):CS_EXPLORATION_Detail()
  if ExplorationManager:IsInExploration() then
    ExplorationManager:ExitExploration(nil, nil, true)
  end
end

GMNetworkCtrl.SC_GM_ShieldGuide = function(self)
  -- function num : 0_5 , upvalues : _ENV
  GuideManager:SetGMSkipGuide(true)
  GuideManager:SkipGuide()
end

GMNetworkCtrl.SC_GM_WarChessStart = function(self, msg)
  -- function num : 0_6 , upvalues : _ENV
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local err = "SC_GM_WarChessStart error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(err)
      return 
    end
    local warChessMsg = msg.warChess
    WarChessManager:InitWarchessCtrl()
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R3 in 'UnsetPending'

    WarChessManager.wcLevelId = warChessMsg.configId
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    WarChessManager.wcLevelCfg = (ConfigData.warchess_level)[WarChessManager.wcLevelId]
    WarChessManager:CleanOrtherWhenEnter()
    ;
    (WarChessManager.__wcCtrl):EnterWarChessByMsg(warChessMsg)
  end
end

GMNetworkCtrl.Reset = function(self)
  -- function num : 0_7
end

return GMNetworkCtrl

