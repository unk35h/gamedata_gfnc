-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroInterationBaseController = require("Game.Hero.Live2D.HeroInterationBaseController")
local HeroPicInterationController = class("HeroPicInterationController", HeroInterationBaseController)
local base = HeroInterationBaseController
local CS_EventTriggerListener = CS.EventTriggerListener
HeroPicInterationController.ctor = function(self)
  -- function num : 0_0
end

HeroPicInterationController.InitPicInteration = function(self, go, aniPlayFunc, lastCvId, heroId, skinId)
  -- function num : 0_1 , upvalues : _ENV, CS_EventTriggerListener
  self._picImage = (go.transform):GetComponent(typeof(((CS.UnityEngine).UI).RawImage))
  self._shortInterival = (ConfigData.buildinConfig).HomeOnHookVoiceTime
  self._aniPlayFunc = aniPlayFunc
  self._lastPlayedCVId = lastCvId or 0
  self.heroId = heroId
  self.skinId = skinId
  self._openRayCast = true
  self._isCVOver = true
  self.timerId = TimerManager:StartTimer(1, self.__TimeCallback, self)
  self:ResetInterationWaitTime()
  if IsNull(self._picImage) then
    return 
  end
  ;
  ((CS_EventTriggerListener.Get)((self._picImage).gameObject)):onUp("+", BindCallback(self, self.__OnInPutUp))
  self._oriRaycastTarget = (self._picImage).raycastTarget
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

  if not self._oriRaycastTarget then
    (self._picImage).raycastTarget = true
  end
end

HeroPicInterationController.__TimeCallback = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if PlayerDataCenter.timestamp < self._nextPlayTime then
    return 
  end
  if not self:CheckGlobalPlayTimeInterval(self.heroId, false) then
    return 
  end
  local cvId = self:GetCvId(self.heroId, eVoicePointType.WaitInHome, self._lastPlayedCVId)
  self:__RecordAndPlayCv(cvId)
end

HeroPicInterationController.GetCvId = function(self, heroId, VoicePointType, lastPlayedCVId)
  -- function num : 0_3 , upvalues : _ENV
  if VoicePointType == eVoicePointType.PicClick then
    return ConfigData:GetVoicePointRandom(eVoicePointType.PicClick, self._lastPlayedCVId, heroId)
  end
  local waitCvid = ConfigData:GetVoicePointRandom(VoicePointType, lastPlayedCVId, heroId)
  do
    if heroId ~= 0 then
      local heroData = PlayerDataCenter:GetHeroData(heroId)
      if self.friendShipCvids == nil then
        self.friendShipCvids = ConfigData:GetUnLockFriendShipCvIds(heroId, heroData)
      end
    end
    local friendShipCvids = self.friendShipCvids
    if friendShipCvids ~= nil and (table.length)(friendShipCvids) > 0 then
      local index = (math.random)(#friendShipCvids)
      local friendShipCvid = friendShipCvids[index]
      return (math.random)(2) == 1 and waitCvid or friendShipCvid
    else
      do
        do return waitCvid end
        return 
      end
    end
  end
end

HeroPicInterationController.__RecordAndPlayCv = function(self, cvId)
  -- function num : 0_4 , upvalues : _ENV
  self._lastPlayedCVId = cvId
  local lastCvInfo = (PlayerDataCenter.cacheSaveData):GetLastHeroInterationCVInfo()
  lastCvInfo.lastVoiceHeroId = self.heroId
  lastCvInfo.lastVoiceTIme = ((CS.UnityEngine).Time).time
  ;
  (PlayerDataCenter.cacheSaveData):SetLastHeroInterationCVInfo(lastCvInfo)
  if self._aniPlayFunc ~= nil then
    self._isCVOver = false
    ;
    (self._aniPlayFunc)(cvId)
  end
end

HeroPicInterationController.__OnInPutUp = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if not self._openRayCast or not self._isCVOver then
    return 
  end
  local cvId = self:GetCvId(self.heroId, eVoicePointType.PicClick, self._lastPlayedCVId)
  self:__RecordAndPlayCv(cvId)
end

HeroPicInterationController.__GetCvidByLoginType = function(self, loginType)
  -- function num : 0_6 , upvalues : _ENV
  local skinId = self.skinId
  if skinId == 0 then
    skinId = ((ConfigData.hero_data)[self.heroId]).default_skin
  end
  local skinConfig = (ConfigData.skin)[skinId]
  local cvid = nil
  do
    if skinConfig ~= nil and type(skinConfig.login_type_cvid) == "table" then
      local cvidList = (skinConfig.login_type_cvid)[loginType]
      ;
      (math.randomseed)((os.time)())
      if #cvidList > 0 then
        cvid = cvidList[(math.random)(#cvidList)]
      end
    end
    if cvid == nil then
      cvid = loginType
    end
    return cvid
  end
end

HeroPicInterationController.PlayHeroEnterHomeAnimation = function(self, loginType)
  -- function num : 0_7 , upvalues : _ENV
  if not self._isCVOver then
    return 
  end
  if not self:CheckGlobalPlayTimeInterval(self.heroId, false) then
    return 
  end
  local isEndBattle = (PlayerDataCenter.cacheSaveData):GetIsEndBattleForHeroInteration()
  if isEndBattle then
    self:PlayLoginAnimation(loginType)
    return 
  end
  local cvId = self:GetCvId(self.heroId, eVoicePointType.EnterHome, self._lastPlayedCVId)
  self:__RecordAndPlayCv(cvId)
end

HeroPicInterationController.PlayLoginAnimation = function(self, loginType)
  -- function num : 0_8
  if not self._isCVOver then
    return 0
  end
  local cvid = self:__GetCvidByLoginType(loginType)
  self:__RecordAndPlayCv(cvid)
  return 0
end

HeroPicInterationController.SetInterationOpenRayCast = function(self, flag)
  -- function num : 0_9
  self._openRayCast = flag
end

HeroPicInterationController.SetInterationCVOver = function(self, flag)
  -- function num : 0_10
  self._isCVOver = flag
  self:ResetInterationWaitTime()
end

HeroPicInterationController.SetInterationOpenWait = function(self, flag)
  -- function num : 0_11 , upvalues : _ENV
  if flag and self.timerId == nil then
    self.timerId = TimerManager:StartTimer(1, self.__TimeCallback, self)
    self:ResetInterationWaitTime()
  else
    if not flag and self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
  end
end

HeroPicInterationController.ResetInterationWaitTime = function(self)
  -- function num : 0_12 , upvalues : _ENV
  self._nextPlayTime = PlayerDataCenter.timestamp + self._shortInterival
end

HeroPicInterationController.Delete = function(self)
  -- function num : 0_13 , upvalues : _ENV, CS_EventTriggerListener, base
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if not IsNull(self._picImage) then
    ((CS_EventTriggerListener.Get)((self._picImage).gameObject)):onUp("-", BindCallback(self, self.__OnInPutUp))
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._picImage).raycastTarget = self._oriRaycastTarget
  end
  self.friendShipCvIds = nil
  ;
  (base.Delete)(self)
end

return HeroPicInterationController

