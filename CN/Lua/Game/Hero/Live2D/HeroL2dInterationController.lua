-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroInterationBaseController = require("Game.Hero.Live2D.HeroInterationBaseController")
local HeroL2dInterationController = class("HeroL2dInterationController", HeroInterationBaseController)
local base = HeroInterationBaseController
local cs_l2dParameterClip = (((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).L2dParameterClip
local cs_time = (CS.UnityEngine).Time
local csCubismInterationController = (((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController
local csL2DAnimationClipType = CS.L2DAnimationClipType
local cs_SortingLayer = (CS.UnityEngine).SortingLayer
local cs_ParticleSystemRenderer = (CS.UnityEngine).ParticleSystemRenderer
local friendshipAnimationName = "friendShipAnimation"
local L2DAnimationClipType = {Normal = 1, Idle = 2, Interaction = 3, ExternalEvent = 4, Login = 5}
HeroL2dInterationController.InitL2dInteration = function(self, cs_CubismInterationController, heroId, heroSkinId, camera, openGuiJudge, aniPlayFunc, animationPlayEventCallback, lastCv, needHideBg)
  -- function num : 0_0 , upvalues : _ENV, csCubismInterationController, csL2DAnimationClipType
  self.closeMouseListen = false
  if needHideBg == nil then
    needHideBg = false
  end
  self:SetL2DHideBg(needHideBg)
  self.cs_CubismInterationController = cs_CubismInterationController
  self.heroId = heroId
  do
    if heroSkinId == 0 then
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg ~= nil then
        heroSkinId = heroCfg.default_skin
      end
    end
    self.heroSkinId = heroSkinId
    self.aniPlayFunc = aniPlayFunc
    self._lastPlayedCVId = lastCv
    self.aniCallback = nil
    if animationPlayEventCallback ~= nil then
      self.aniCallback = animationPlayEventCallback
      ;
      (self.cs_CubismInterationController):OnAnimationPlayEvent("+", self.aniCallback)
    else
      if self.aniPlayFunc ~= nil then
        self.aniCallback = BindCallback(self, self.AniPlayCallback)
        ;
        (self.cs_CubismInterationController):OnAnimationPlayEvent("+", self.aniCallback)
      end
    end
    self.l2dAnimationEventCallback = BindCallback(self, self.l2dAnimationEvent)
    ;
    (self.cs_CubismInterationController):AnimationEventAction("+", self.l2dAnimationEventCallback)
    self:__InitCSComponent()
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R10 in 'UnsetPending'

    if not IsNull(self.cs_mouth) then
      (self.cs_mouth).BlendMode = ((((CS.Live2D).Cubism).Framework).CubismParameterBlendMode).Additive
    end
    self:SetMouthActive(false)
    if self.heroSkinId ~= 0 then
      self.config = (ConfigData.skin_live2d)[self.heroSkinId]
    else
      self.config = (ConfigData.skin_live2d)[self.heroId]
      warn("has heroId l2d!!!")
    end
    if IsNull(self.normalClip) then
      self.normalClip = (self.cs_CubismInterationController).NormalAnimation
    end
    if IsNull(self.normalClip) then
      local l2DParameterClips = (self.cs_CubismInterationController).L2DParameterClips
      for i = 0, l2DParameterClips.Count - 1 do
        local l2dClip = l2DParameterClips[i]
        if l2dClip.Name == csCubismInterationController.NormalL2DClipName and l2dClip.AnimationClipType == csL2DAnimationClipType.Normal then
          self.normalClip = l2dClip.Clip
        end
      end
    end
    do
      self:__AddFriendShipAnimation(heroId)
      self._isHasWaitLive2dAni = (self.cs_CubismInterationController):IsHasWaitLive2dAni()
      self._isHasTouchLive2dAni = (self.cs_CubismInterationController):IsHasTouchLive2dAni()
      local shortTime, longTime = nil, nil
      if self._isHasWaitLive2dAni then
        shortTime = ((ConfigData.game_config).l2dWaitAnimationTime).ShortTime
        longTime = ((ConfigData.game_config).l2dWaitAnimationTime).LongTime
      else
        shortTime = (ConfigData.buildinConfig).HomeOnHookVoiceTime
        longTime = (ConfigData.buildinConfig).HomeOnHookVoiceTime
      end
      ;
      (self.cs_CubismInterationController):InitController(true, true, shortTime, longTime, camera)
      -- DECOMPILER ERROR at PC159: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self.cs_CubismInterationController).enabled = true
      -- DECOMPILER ERROR at PC161: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self.cs_CubismInterationController).OpenGuiJudge = openGuiJudge
      self:HideL2dBg()
    end
  end
end

HeroL2dInterationController.__AddFriendShipAnimation = function(self, heroId)
  -- function num : 0_1 , upvalues : _ENV, friendshipAnimationName, cs_l2dParameterClip, cs_time
  if IsNull(self.cs_CubismInterationController) then
    return 
  end
  if heroId ~= 0 then
    if not PlayerDataCenter:ContainsHeroData(heroId) then
      return 
    end
    local heroData = PlayerDataCenter:GetHeroData(heroId)
    self.friendShipCvIds = ConfigData:GetUnLockFriendShipCvIds(heroId, heroData)
  end
  do
    local L2DParameterClips = (self.cs_CubismInterationController).L2DParameterClips
    local friendShipClip = nil
    for i = 0, L2DParameterClips.Count - 1 do
      local l2dClip = L2DParameterClips[i]
      l2dClip.isHaveMouseAni = self:IsSSRLive2D() and ((not self:IsUseNormalClip(l2dClip) and self:IsHasMouseAnim(l2dClip)))
      if l2dClip.Name == friendshipAnimationName then
        friendShipClip = l2dClip
      end
    end
    if friendShipClip ~= nil then
      if self.friendShipCvIds == nil or #self.friendShipCvIds == 0 then
        friendShipClip.RandomPlayWeight = 0
        return 
      else
        friendShipClip.RandomPlayWeight = 4
        return 
      end
    end
    if self.friendShipCvIds == nil or #self.friendShipCvIds == 0 then
      return 
    end
    if IsNull(self.normalClip) then
      return 
    end
    local friendShipAnimation = cs_l2dParameterClip(self.normalClip, (self.cs_CubismInterationController).MainLayer)
    friendShipAnimation.Name = friendshipAnimationName
    friendShipAnimation.isHaveMouseAni = false
    friendShipAnimation.RandomPlayWeight = 4
    friendShipAnimation.ConditionStateIndex = (self.cs_CubismInterationController).currentStateIndex
    friendShipAnimation:UpdateTimeStamp(cs_time.time)
    if L2DParameterClips ~= nil then
      L2DParameterClips:Add(friendShipAnimation)
      ;
      (self.cs_CubismInterationController):ReSetCacheValue()
    end
    -- DECOMPILER ERROR: 10 unprocessed JMP targets
  end
end

HeroL2dInterationController.__InitCSComponent = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if IsNull(self.cs_CubismInterationController) then
    return 
  end
  local live2dGameObject = (self.cs_CubismInterationController).gameObject
  self.cs_rayCast = live2dGameObject:GetComponent(typeof(((((CS.Live2D).Cubism).Framework).Raycasting).CubismRaycaster))
  self.cs_mouth = live2dGameObject:GetComponent(typeof(((((CS.Live2D).Cubism).Framework).MouthMovement).CubismMouthController))
  self.cs_cubismLookController = live2dGameObject:GetComponent(typeof(((((CS.Live2D).Cubism).Framework).LookAt).CubismLookController))
  self.cs_cubismParitcleController = (self.cs_CubismInterationController):GetComponent(typeof(((((CS.Live2D).Cubism).Framework).Effect).CubismParitcleEffectController))
  local l2dBinding = {}
  ;
  (UIUtil.LuaUIBindingTable)(live2dGameObject, l2dBinding)
  self.cs_renderController = l2dBinding.renderController
  self.cs_commonPerpectiveHandle = l2dBinding.commonPerpectiveHandle
  self.cs_lookTarget = ((l2dBinding.lookTarget).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismLookTarget))
end

HeroL2dInterationController.IsSSRLive2D = function(self)
  -- function num : 0_3
  do
    if self.config ~= nil then
      local live2d_level = (self.config).level
      return live2d_level == 3
    end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

HeroL2dInterationController.IsUseNormalClip = function(self, l2dClip)
  -- function num : 0_4
  if l2dClip.Clip ~= self.normalClip then
    do return l2dClip == nil or self.normalClip == nil end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

HeroL2dInterationController.IsHasMouseAnim = function(self, l2dClip)
  -- function num : 0_5 , upvalues : _ENV, friendshipAnimationName
  local clipName = l2dClip.Name
  local hasMouseAnim = (string.sub)(clipName, 0, 6) ~= "wait_0" and clipName ~= "login_0" and clipName ~= friendshipAnimationName
  do return hasMouseAnim end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroL2dInterationController.AniPlayCallback = function(self, l2dClipType, loginType, hitArea, animName, animLength, isHaveMouseAni)
  -- function num : 0_6 , upvalues : L2DAnimationClipType, _ENV
  if l2dClipType == L2DAnimationClipType.Normal then
    return 
  end
  print("animName = " .. animName)
  if self.config == nil then
    warn("英雄:" .. self.heroId .. "{" .. animName .. "}动作的cv未适配")
    return 
  end
  local cvId = self:GetRandomWaitCvId(self.heroId, animName, self.config)
  if cvId == nil and l2dClipType == L2DAnimationClipType.Login then
    if loginType ~= 0 then
      local loginCvIds = ((self.config).aniCvDic)[tostring(loginType)]
      if loginCvIds ~= nil and #loginCvIds > 0 then
        cvId = loginCvIds[1]
      else
        cvId = loginType
      end
    else
      do
        do
          local window = UIManager:GetWindow(UIWindowTypeID.Home)
          if window ~= nil and window.homeAdjutant ~= nil then
            cvId = (window.homeAdjutant):GetLoginType()
          end
          local delay_second = ((self.config).delay_seconds)[cvId]
          if delay_second ~= nil then
            return nil
          end
          if cvId == nil then
            return 
          end
          local dontCheckTime = false
          if l2dClipType == L2DAnimationClipType.Interaction or l2dClipType == L2DAnimationClipType.ExternalEvent then
            dontCheckTime = true
          end
          if animName == "touch_0" then
            animLength = 0
          end
          local closeMouseListen = isHaveMouseAni
          self.closeMouseListen = closeMouseListen
          self:__PlayCV(cvId, animLength, dontCheckTime, closeMouseListen)
        end
      end
    end
  end
end

HeroL2dInterationController.__PlayCV = function(self, cvId, aniLength, dontCheckTime, closeMouseListen)
  -- function num : 0_7 , upvalues : _ENV, cs_time
  if not self:CheckGlobalPlayTimeInterval(self.heroId, dontCheckTime) then
    return 
  end
  self._lastPlayedCVId = cvId
  if self.aniPlayFunc ~= nil then
    (self.aniPlayFunc)(self._lastPlayedCVId, aniLength, not closeMouseListen)
    local lastCvInfo = (PlayerDataCenter.cacheSaveData):GetLastHeroInterationCVInfo()
    lastCvInfo.lastVoiceHeroId = self.heroId
    lastCvInfo.lastVoiceTIme = cs_time.time
    ;
    (PlayerDataCenter.cacheSaveData):SetLastHeroInterationCVInfo(lastCvInfo)
  end
end

HeroL2dInterationController.l2dAnimationEvent = function(self, eventArgsStr)
  -- function num : 0_8 , upvalues : _ENV
  if eventArgsStr == nil then
    return 
  end
  local args = (string.split)(eventArgsStr, "_")
  if (table.length)(args) == 0 then
    return 
  end
  local eventType = args[1]
  if eventType == Live2dAnimationEventType.characterVoice then
    self:PlayL2DCharacterVoiceEvent(tonumber(args[2]), tonumber(args[3]))
    return 
  end
  if args[3] ~= "1" then
    self:PlayL2DEffectEvent(args[2], eventType ~= Live2dAnimationEventType.particle)
    do return  end
    if args[2] ~= "0" then
      self:SetLoginTimeLine(eventType ~= Live2dAnimationEventType.loginTimeLine)
      do return  end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
end

HeroL2dInterationController.PlayL2DCharacterVoiceEvent = function(self, cvId, animLength)
  -- function num : 0_9
  self:__PlayCV(cvId, animLength, true, true)
end

HeroL2dInterationController.PlayL2DEffectEvent = function(self, particleName, isActive)
  -- function num : 0_10 , upvalues : _ENV
  if IsNull(self.cs_cubismParitcleController) then
    return 
  end
  if isActive then
    (self.cs_cubismParitcleController):PlayParticle(particleName)
  else
    ;
    (self.cs_cubismParitcleController):StopParticle(particleName)
  end
end

HeroL2dInterationController.SetLoginTimeLine = function(self, isPause)
  -- function num : 0_11 , upvalues : _ENV
  if (PlayerDataCenter.cacheSaveData):IsHasPlayedL2dLoginAnim() then
    return 
  end
  local window = UIManager:GetWindow(UIWindowTypeID.Home)
  if window == nil then
    return 
  end
  if isPause then
    window:PauseEnterTimeLine()
  else
    window:PlayEnterTimeLine()
    ;
    (PlayerDataCenter.cacheSaveData):SetHasPlayedL2dLoginAnim(true)
  end
end

Live2dAnimationEventType = {characterVoice = "characterVoice", particle = "particle", loginTimeLine = "loginTimeLine"}
HeroL2dInterationController.GetRandomWaitCvId = function(self, heroId, animName, skinLive2dConfig)
  -- function num : 0_12 , upvalues : friendshipAnimationName, _ENV
  local cvIds = nil
  if animName == friendshipAnimationName then
    cvIds = self.friendShipCvIds
  end
  if cvIds == nil or (table.length)(cvIds) == 0 then
    if (string.find)(animName, "assign") ~= nil then
      cvIds = {tonumber(((string.split)(animName, "_"))[2])}
    else
      cvIds = (skinLive2dConfig.aniCvDic)[animName]
    end
  end
  if cvIds ~= nil and (table.length)(cvIds) > 0 then
    local index = (math.random)(#cvIds)
    local cvId = cvIds[index]
    return cvId
  end
end

HeroL2dInterationController.IsExistLoginAni = function(self, loginType)
  -- function num : 0_13 , upvalues : _ENV
  if IsNull(self.cs_CubismInterationController) then
    return false
  end
  local loginL2DClips = (self.cs_CubismInterationController):GetLoginL2DClips(loginType, false)
  if IsNull(loginL2DClips) or loginL2DClips.Count == 0 then
    return false
  end
  return true
end

HeroL2dInterationController.SetRenderControllerSetting = function(self, sortingLayerName, uiCanvasGroup, sortingOrder, InfluencedByUICanvas)
  -- function num : 0_14 , upvalues : _ENV
  local renderController = self.cs_renderController
  if IsNull(renderController) then
    return 
  end
  if sortingLayerName ~= nil and sortingLayerName ~= "" then
    renderController.SortingLayer = sortingLayerName
  end
  if not IsNull(uiCanvasGroup) then
    renderController.uiCanvasGroup = uiCanvasGroup
  end
  if sortingOrder ~= nil then
    renderController.SortingOrder = sortingOrder
  end
  renderController.InfluencedByUICanvas = InfluencedByUICanvas == true
  self:SetL2dEffectSortingLayer(sortingLayerName)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroL2dInterationController.SetL2dEffectSortingLayer = function(self, sortingLayerName)
  -- function num : 0_15 , upvalues : _ENV, cs_SortingLayer, cs_ParticleSystemRenderer
  local l2dParitcleController = self.cs_cubismParitcleController
  if IsNull(l2dParitcleController) then
    return 
  end
  local sortingLayerID = (cs_SortingLayer.NameToID)(sortingLayerName)
  local particleEffects = l2dParitcleController.cubismParticleEffects
  if not IsNull(particleEffects) then
    for i = 0, particleEffects.Count - 1 do
      local particleEffect = particleEffects[i]
      if not IsNull(particleEffect) then
        local particle = particleEffect.Particle
        if not IsNull(particle) then
          local childParticleRenders = (particle.gameObject):GetComponentsInChildren(typeof(cs_ParticleSystemRenderer))
          if not IsNull(childParticleRenders) then
            for j = 0, childParticleRenders.Length - 1 do
              local childParticle = childParticleRenders[j]
              childParticle.sortingLayerID = sortingLayerID
            end
          end
        end
      end
    end
  end
end

HeroL2dInterationController.SetL2DHideBg = function(self, value)
  -- function num : 0_16
  self.needHIdeL2dBg = value
end

HeroL2dInterationController.IsHideL2dBg = function(self)
  -- function num : 0_17 , upvalues : _ENV
  if self.needHIdeL2dBg == false then
    return false
  end
  if self.config ~= nil then
    local isOpenHideBg = (self.config).is_open_hide_bg
    if not isOpenHideBg then
      return false
    end
    local skinId = (self.config).id
    local isHideBg = (PlayerDataCenter.skinData):IsHideL2dBg(skinId)
    return isHideBg
  end
  do
    return false
  end
end

HeroL2dInterationController.HideL2dBg = function(self)
  -- function num : 0_18
  local isHideL2dBg = self:IsHideL2dBg()
  if not isHideL2dBg then
    return 
  end
  local renderController = self.cs_renderController
  ;
  (self.ActiveLive2dBg)(renderController, false)
end

HeroL2dInterationController.SetL2DPosType = function(self, posTypeName, alignUIFakeCam)
  -- function num : 0_19 , upvalues : _ENV
  local commonPerpectiveHandle = self.cs_commonPerpectiveHandle
  if IsNull(commonPerpectiveHandle) then
    return 
  end
  commonPerpectiveHandle:SetL2DPosType(posTypeName, alignUIFakeCam == true)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroL2dInterationController.OpenLookTarget = function(self, camera)
  -- function num : 0_20 , upvalues : _ENV
  local cubismLookController = self.cs_cubismLookController
  local lookTarget = self.cs_lookTarget
  if IsNull(cubismLookController) or IsNull(lookTarget) then
    return 
  end
  cubismLookController.enabled = true
  cubismLookController:SetCamera(camera)
  lookTarget:SetCamera(camera)
  lookTarget:SetTimeClip(0.2)
end

HeroL2dInterationController.PlayHeroEnterHomeAnimation = function(self, loginType)
  -- function num : 0_21 , upvalues : _ENV
  if IsNull(self.cs_CubismInterationController) then
    return 
  end
  if not self:CheckGlobalPlayTimeInterval(self.heroId, false) then
    return 
  end
  local isEndBattle = (PlayerDataCenter.cacheSaveData):GetIsEndBattleForHeroInteration()
  if isEndBattle then
    self:PlayLoginAnimation(loginType, false)
    return 
  end
  ;
  (self.cs_CubismInterationController):PlayWaitAni()
end

HeroL2dInterationController.PlayLoginAnimation = function(self, loginType, dontCheckTime)
  -- function num : 0_22 , upvalues : _ENV
  if IsNull(self.cs_CubismInterationController) then
    return 0
  end
  if dontCheckTime == nil then
    dontCheckTime = true
  end
  if self:CheckGlobalPlayTimeInterval(self.heroId, dontCheckTime) then
    if self:IsSSRLive2D() then
      local closeMouseListen = self:IsExistLoginAni(loginType)
    end
    self.closeMouseListen = closeMouseListen
    local aniLength = (self.cs_CubismInterationController):PlayLoginAni(loginType, true)
    ;
    (PlayerDataCenter.cacheSaveData):SetIsEndBattleForHeroInteration(false)
    return aniLength
  end
  do
    return 0
  end
end

HeroL2dInterationController.SetInterationOpenRayCast = function(self, flag)
  -- function num : 0_23 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if not IsNull(self.cs_rayCast) then
    (self.cs_rayCast).enabled = flag
  end
end

HeroL2dInterationController.SetInterationCVOver = function(self, flag)
  -- function num : 0_24 , upvalues : _ENV
  if flag then
    self.closeMouseListen = false
  end
  if not IsNull(self.cs_CubismInterationController) then
    self:SetMouthActive(not flag)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.cs_CubismInterationController).IsCVOver = flag
  end
end

HeroL2dInterationController.SetInterationOpenWait = function(self, flag)
  -- function num : 0_25 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if not IsNull(self.cs_CubismInterationController) then
    (self.cs_CubismInterationController).IsOpenWait = flag
  end
end

HeroL2dInterationController.ResetInterationWaitTime = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if not IsNull(self.cs_CubismInterationController) then
    (self.cs_CubismInterationController):InitIdleAnimationTime()
  end
end

HeroInterationBaseController.RestartBodyAnimation = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if not IsNull(self.cs_CubismInterationController) then
    ((self.cs_CubismInterationController)._motionController):StopAnimation(0, 0)
    ;
    (self.cs_CubismInterationController):RestartBodyAnimation()
  end
end

HeroL2dInterationController.IsPlayLoginAnimationOnAutoShowOver = function(self, loginType)
  -- function num : 0_28 , upvalues : _ENV
  if not IsNull(self.cs_CubismInterationController) then
    return (self.cs_CubismInterationController):IsLoginAniPlayOnAutoShowOver(loginType)
  end
  return true
end

HeroL2dInterationController.Delete = function(self)
  -- function num : 0_29 , upvalues : _ENV, base
  if not IsNull(self.cs_CubismInterationController) and self.aniCallback ~= nil then
    (self.cs_CubismInterationController):OnAnimationPlayEvent("-", self.aniCallback)
    ;
    (self.cs_CubismInterationController):AnimationEventAction("-", self.l2dAnimationEventCallback)
  end
  self:__DisposeCSComponent()
  self.normalClip = nil
  self.friendShipCvIds = nil
  ;
  (base.Delete)(self)
end

HeroL2dInterationController.SetMouthActive = function(self, isEnabled)
  -- function num : 0_30 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if not IsNull(self.cs_mouth) and isEnabled then
    (self.cs_mouth).enabled = not self.closeMouseListen
  end
end

HeroL2dInterationController.__DisposeCSComponent = function(self)
  -- function num : 0_31
  self.cs_rayCast = nil
  self.cs_mouth = nil
  self.cs_cubismLookController = nil
  self.cs_cubismParitcleController = nil
  self.cs_renderController = nil
  self.cs_commonPerpectiveHandle = nil
  self.cs_lookTarget = nil
  self.cs_CubismInterationController = nil
end

HeroL2dInterationController.ActiveLive2dBg = function(renderController, isActive)
  -- function num : 0_32 , upvalues : _ENV
  if IsNull(renderController) then
    return 
  end
  local renders = renderController.Renderers
  if renders == nil or renders.length == 0 then
    return 
  end
  for i = 0, renders.Length - 1 do
    local render = renders[i]
    if not IsNull(render) and not IsNull(render.MeshRenderer) and not (render.MeshRenderer).receiveShadows then
      ((render.MeshRenderer).gameObject):SetActive(isActive)
    end
  end
end

return HeroL2dInterationController

