-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityBase = require("Game.ActivityFrame.ActivityBase")
local ActivityInvitationData = class("ActivityInvitationData", ActivityBase)
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local CurActType = (ActivityFrameEnum.eActivityType).Invitation
ActivityInvitationData.InitInvitationData = function(self, msg)
  -- function num : 0_0 , upvalues : CurActType, _ENV
  self:SetActFrameDataByType(CurActType, msg.actId)
  self:UpdateActFrameDataSingleMsg(msg)
  self._mainCfg = (ConfigData.activity_invitation)[self:GetActId()]
  self._rewardCfg = (ConfigData.activity_invitation_reward)[self:GetActId()]
  self._code = msg.invitationCode
  self._isReturnUser = msg.isReturnUser
  self:UpdataInvitationData(msg)
end

ActivityInvitationData.UpdataInvitationData = function(self, msg)
  -- function num : 0_1
  self._invitees = msg.invitees
  self._rewardMast = msg.rewardMask
  self._isPickReturnReward = msg.pickReturnReward
  self:RefreshInvitationRed()
end

ActivityInvitationData.SetInvitationRegister = function(self)
  -- function num : 0_2
  self._isPickReturnReward = true
end

ActivityInvitationData.RefreshInvitationRed = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local reddot = self:GetActivityReddot()
  if reddot == nil then
    return 
  end
  local redCount = 0
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if not saveUserData:GetInvitationLooked(self:GetActId()) then
    redCount = 1
  else
    for i,_ in ipairs(self._invitees) do
      if not self:IsInvitationRewardPicked(R11_PC26) then
        redCount = 1
        break
      end
    end
  end
  do
    if redCount ~= reddot:GetRedDotCount() then
      reddot:SetRedDotCount(redCount)
    end
  end
end

ActivityInvitationData.ReqInvitationRegister = function(self, code)
  -- function num : 0_4 , upvalues : _ENV
  if self._lastRegisterTime ~= nil and PlayerDataCenter.timestamp - self._lastRegisterTime < 1 then
    return 
  end
  self._lastRegisterTime = PlayerDataCenter.timestamp
  local net = NetworkManager:GetNetwork(NetworkTypeID.Invitation)
  net:CS_ACTIVITY_Invitation_Register(self:GetActFrameId(), code)
end

ActivityInvitationData.ReqInvitationPicked = function(self, index, callback)
  -- function num : 0_5 , upvalues : _ENV
  local net = NetworkManager:GetNetwork(NetworkTypeID.Invitation)
  net:CS_ACTIVITY_Invitation_Pick(self:GetActFrameId(), index, function()
    -- function num : 0_5_0 , upvalues : self, index, callback
    self._rewardMast = self._rewardMast | 1 << index
    self:RefreshInvitationRed()
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityInvitationData.GetInvitationCode = function(self)
  -- function num : 0_6
  return self._code
end

ActivityInvitationData.GetInvitationMainCfg = function(self)
  -- function num : 0_7
  return self._mainCfg
end

ActivityInvitationData.GetInvitaionRewardCfg = function(self)
  -- function num : 0_8
  return self._rewardCfg
end

ActivityInvitationData.GetInvitationInvitees = function(self)
  -- function num : 0_9
  return self._invitees
end

ActivityInvitationData.IsInvitationReturnUser = function(self)
  -- function num : 0_10
  return self._isReturnUser
end

ActivityInvitationData.IsInvitationReturnPicked = function(self)
  -- function num : 0_11
  return self._isPickReturnReward
end

ActivityInvitationData.IsInvitationRewardPicked = function(self, num)
  -- function num : 0_12
  if num < 1 or #self._rewardCfg < num then
    return false
  end
  local flag = self._rewardMast >> num & 1
  do return flag == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return ActivityInvitationData

