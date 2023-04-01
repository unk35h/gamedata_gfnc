-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityInvitationController = class("ActivityInvitationController", ControllerBase)
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityInvitationData = require("Game.ActivityInvitation.Data.ActivityInvitationData")
ActivityInvitationController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.activity_invitation)
  ConfigData:LoadDynCfg(eDynConfigData.activity_invitation_reward)
  self.__SetInvitationRegister = BindCallback(self, self.SetInvitationRegister)
  MsgCenter:AddListener(eMsgEventId.InvitationCodeRegister, self.__SetInvitationRegister)
  self._dataDic = {}
end

ActivityInvitationController.AddInvitation = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum, ActivityInvitationData
  local frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local frameData = frameCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Invitation, msg.actId)
  if frameData == nil or not frameData:IsActivityOpen() then
    return 
  end
  if (self._dataDic)[msg.actId] ~= nil then
    return 
  end
  local data = (ActivityInvitationData.New)()
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._dataDic)[msg.actId] = data
  data:InitInvitationData(msg)
end

ActivityInvitationController.UpdateInvitation = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV
  if (self._dataDic)[msg.actId] == nil then
    return 
  end
  ;
  ((self._dataDic)[msg.actId]):UpdataInvitationData(msg)
  MsgCenter:Broadcast(eMsgEventId.ActivityInvitation, msg.actId)
end

ActivityInvitationController.SetInvitationRegister = function(self, frameId)
  -- function num : 0_3 , upvalues : _ENV
  for k,v in pairs(self._dataDic) do
    if v:GetActFrameId() == frameId then
      v:SetInvitationRegister()
      break
    end
  end
end

ActivityInvitationController.RemoveInvitation = function(self, actId)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[actId] = nil
end

ActivityInvitationController.IsHaveInvitation = function(self)
  -- function num : 0_5 , upvalues : _ENV
  do return (table.count)(self._dataDic) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ActivityInvitationController.GetInvitationDataByActId = function(self, actId)
  -- function num : 0_6
  return (self._dataDic)[actId]
end

ActivityInvitationController.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_invitation)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_invitation_reward)
  MsgCenter:RemoveListener(eMsgEventId.InvitationCodeRegister, self.__SetInvitationRegister)
end

return ActivityInvitationController

