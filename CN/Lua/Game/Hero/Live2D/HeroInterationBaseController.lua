-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroInterationBaseController = class("HeroInterationBaseController")
HeroInterationBaseController.PlayHeroEnterHomeAnimation = function(self, loginType)
  -- function num : 0_0
end

HeroInterationBaseController.PlayLoginAnimation = function(self, loginType, dontCheckTime)
  -- function num : 0_1
end

HeroInterationBaseController.SetInterationOpenRayCast = function(self, flag)
  -- function num : 0_2
end

HeroInterationBaseController.SetInterationCVOver = function(self, flag)
  -- function num : 0_3
end

HeroInterationBaseController.SetInterationOpenWait = function(self, flag)
  -- function num : 0_4
end

HeroInterationBaseController.ResetInterationWaitTime = function(self)
  -- function num : 0_5
end

HeroInterationBaseController.RestartBodyAnimation = function(self)
  -- function num : 0_6
end

HeroInterationBaseController.CheckGlobalPlayTimeInterval = function(self, currentHeroId, dontCheckTime)
  -- function num : 0_7 , upvalues : _ENV
  local lastCvInfo = (PlayerDataCenter.cacheSaveData):GetLastHeroInterationCVInfo()
  local currentTime = ((CS.UnityEngine).Time).time
  local timeInterval = (ConfigData.game_config).l2dGlobalWaitTimeInterval
  if lastCvInfo ~= nil and not dontCheckTime and lastCvInfo.lastVoiceHeroId == currentHeroId and lastCvInfo.lastVoiceTIme ~= nil and currentTime - lastCvInfo.lastVoiceTIme < timeInterval then
    return false
  end
  return true
end

HeroInterationBaseController.IsPlayLoginAnimationOnAutoShowOver = function(self, loginType)
  -- function num : 0_8
  return true
end

HeroInterationBaseController.Delete = function(self)
  -- function num : 0_9
end

return HeroInterationBaseController

