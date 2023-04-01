-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckSkinVoice = {}
CheckSkinVoice.LengthCheck = function(param)
  -- function num : 0_0
  if #param == 3 then
    return true
  end
  return false
end

CheckSkinVoice.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local skinId = param[2]
  local voiceId = param[3]
  local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
  if not cvCtr:HasSkinCv(skinId) then
    return true
  end
  if not cvCtr:IsExistVoiceId(voiceId) then
    return true
  end
  if (PlayerDataCenter.skinData):IsHaveSkin(skinId) then
    return true
  end
  return false
end

CheckSkinVoice.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  return (string.format)(ConfigData:GetTipContent(16001))
end

return CheckSkinVoice

