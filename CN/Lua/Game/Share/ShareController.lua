-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ControllerBase
local ShareController = class("ShareController", base)
local cs_MicaSDKManager = CS.MicaSDKManager
local eShare = require("Game.Share.eShare")
ShareController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._shareNet = NetworkManager:GetNetwork(NetworkTypeID.Share)
end

ShareController.IsShareUnlock = function(self)
  -- function num : 0_1 , upvalues : _ENV
  return FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Share)
end

ShareController.ShareImg = function(self, shareId, shareImgChannelType, callBack)
  -- function num : 0_2 , upvalues : _ENV, cs_MicaSDKManager
  self._shareId = shareId
  self._shareImgChannelType = shareImgChannelType
  self._shareCallback = callBack
  if isEditorMode then
    self:_OnShareEnd(true)
    return 
  end
  TimerManager:StopTimer(self._shareTimer)
  self._shareCompleteByTimer = false
  self._shareTimer = TimerManager:StartTimer(3, function()
    -- function num : 0_2_0 , upvalues : self
    self:_OnShareEnd(true)
    self._shareCompleteByTimer = true
  end
, self, true)
  ;
  (cs_MicaSDKManager.Instance):ShareImg(shareImgChannelType, PathConsts.PersistentShareImgPath, function(paramStr)
    -- function num : 0_2_1 , upvalues : self
    local success = paramStr == "1"
    self:_OnShareEnd(success)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

ShareController._OnShareEnd = function(self, success)
  -- function num : 0_3 , upvalues : _ENV, eShare
  TimerManager:StopTimer(self._shareTimer)
  if self._shareCompleteByTimer then
    return 
  end
  if self._shareCallback ~= nil then
    (self._shareCallback)(success)
  end
  if success and self._shareImgChannelType ~= (eShare.eShareImgChannelType).SaveGallery then
    (self._shareNet):CS_Share(self._shareId, self._shareImgChannelType, function(objList)
    -- function num : 0_3_0 , upvalues : _ENV
    if objList.Count ~= 1 then
      error("objList.Count error:" .. tostring(objList.Count))
      return 
    end
    local msg = objList[0]
    local rewardDic = msg.rewards
    if (table.IsEmptyTable)(rewardDic) then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_3_0_0 , upvalues : _ENV, msg
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = (CommonRewardData.CreateCRDataUseDic)(msg.rewards)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
  end
  if not success then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(14028))
  end
  if isEditorMode and success then
    (((CS.UnityEngine).Application).OpenURL)(PathConsts.PersistentShareImgPath)
  end
end

ShareController.CanGetShareReward = function(self, shareId)
  -- function num : 0_4 , upvalues : _ENV
  local shareCfg = (ConfigData.share)[shareId]
  if shareCfg == nil then
    error("Cant get shareCfg, id:" .. tostring(shareId))
    return false
  end
  local rewardNum = self:GetShareRewardNum(shareId)
  do return rewardNum < shareCfg.reward_num end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ShareController.GetShareRewardNum = function(self, shareId)
  -- function num : 0_5 , upvalues : _ENV
  local elem = (ControllerManager:GetController(ControllerTypeId.TimePass, true)):getCounterElemData(proto_object_CounterModule.CounterModuleShareReward, shareId)
  if elem == nil or elem.nextExpiredTm <= PlayerDataCenter.timestamp then
    return 0
  end
  return elem.times
end

ShareController.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  TimerManager:StopTimer(self._shareTimer)
  ;
  (base.OnDelete)(self)
end

return ShareController

