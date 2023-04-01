-- params : ...
-- function num : 0 , upvalues : _ENV
local CommanderSkillNetworkCtrl = class("CommanderSkillNetworkCtrl", NetworkCtrlBase)
local cs_WaitNetworkResponse = (CS.WaitNetworkResponse).Instance
CommanderSkillNetworkCtrl.ctor = function(self)
  -- function num : 0_0
  self._modifyFmt = {}
  self._freshSavingTreeTab = {}
end

CommanderSkillNetworkCtrl.InitNetwork = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_COMMANDSKILL_SaveFromFormation, self, proto_csmsg.SC_COMMANDSKILL_SaveFromFormation, self.SC_COMMANDSKILL_SaveFromFormation)
  self:RegisterNetwork(proto_csmsg_MSG_ID.MSG_SC_COMMANDSKILL_FreshSavingTree, self, proto_csmsg.SC_COMMANDSKILL_FreshSavingTree, self.SC_COMMANDSKILL_FreshSavingTree)
end

CommanderSkillNetworkCtrl._TryGenTreeTab = function(self, treeId, skills)
  -- function num : 0_2 , upvalues : _ENV
  for index,value in ipairs(skills) do
    if value == 0 then
      error("skillActive list has value 0")
      return false
    end
  end
  local treeTab = {id = treeId, skills = skills}
  return true, treeTab
end

CommanderSkillNetworkCtrl.CS_COMMANDSKILL_SaveFromFormation = function(self, formId, treeId, skills, callBack)
  -- function num : 0_3 , upvalues : _ENV, cs_WaitNetworkResponse
  local ok, treeTab = self:_TryGenTreeTab(treeId, skills)
  if not ok then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self._modifyFmt).formId = formId
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self._modifyFmt).tree = treeTab
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_SaveFromFormation, proto_csmsg.CS_COMMANDSKILL_SaveFromFormation, self._modifyFmt)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_SaveFromFormation, function()
    -- function num : 0_3_0 , upvalues : _ENV, formId, self, callBack
    local formatData = (PlayerDataCenter.formationDic)[formId]
    formatData:ModifyCSTData((self._modifyFmt).tree)
    MsgCenter:Broadcast(eMsgEventId.OnCommanderSkillChande)
    if callBack ~= nil then
      callBack()
    end
  end
, proto_csmsg_MSG_ID.MSG_SC_COMMANDSKILL_SaveFromFormation)
end

CommanderSkillNetworkCtrl.SC_COMMANDSKILL_SaveFromFormation = function(self, msg)
  -- function num : 0_4 , upvalues : _ENV, cs_WaitNetworkResponse
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local errorMsg = "HeroNetworkCtrl:SC_COMMANDSKILL_SaveFromFormation error:" .. tostring(msg.ret)
      error(errorMsg)
      if isGameDev then
        ((CS.MessageCommon).ShowMessageTips)(errorMsg)
      end
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_SaveFromFormation)
    end
    NetworkManager:HandleDiff(msg.syncUpdateDiff)
  end
end

CommanderSkillNetworkCtrl.CS_COMMANDSKILL_FreshSavingTree = function(self, treeId, skills, callBack)
  -- function num : 0_5 , upvalues : _ENV, cs_WaitNetworkResponse
  local ok, treeTab = self:_TryGenTreeTab(treeId, skills)
  if not ok then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._freshSavingTreeTab).tree = treeTab
  self:SendMsg(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_FreshSavingTree, proto_csmsg.CS_COMMANDSKILL_FreshSavingTree, self._freshSavingTreeTab)
  cs_WaitNetworkResponse:StartWait(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_FreshSavingTree, callBack, proto_csmsg_MSG_ID.MSG_SC_COMMANDSKILL_FreshSavingTree)
end

CommanderSkillNetworkCtrl.SC_COMMANDSKILL_FreshSavingTree = function(self, msg)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitNetworkResponse
  NetworkManager:HandleDiff(msg.syncUpdateDiff)
  do
    if msg.ret ~= proto_csmsg_ErrorCode.None then
      local errorMsg = "HeroNetworkCtrl:SC_COMMANDSKILL_SaveFromFormation error:" .. tostring(msg.ret)
      self:ShowSCErrorMsg(errorMsg)
      cs_WaitNetworkResponse:RemoveWait(proto_csmsg_MSG_ID.MSG_CS_COMMANDSKILL_FreshSavingTree)
    end
    PlayerDataCenter:UpdCstData(((self._freshSavingTreeTab).tree).id, ((self._freshSavingTreeTab).tree).skills)
    MsgCenter:Broadcast(eMsgEventId.OnCommanderSkillChande)
  end
end

CommanderSkillNetworkCtrl.Reset = function(self)
  -- function num : 0_7
end

return CommanderSkillNetworkCtrl

