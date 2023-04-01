-- params : ...
-- function num : 0 , upvalues : _ENV
local HomeAdjutant = class("HomeAdjutant")
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local HeroL2dInterationController = require("Game.Hero.Live2D.HeroL2dInterationController")
local cs_ResLoader = CS.ResLoader
HomeAdjutant.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.homeController = ControllerManager:GetController(ControllerTypeId.HomeController, true)
  self._resDic = {}
  self.__OnListenerAdjChangeCallback = BindCallback(self, self.OnListenerAdjChange)
  MsgCenter:AddListener(eMsgEventId.AdjCustomModify, self.__OnListenerAdjChangeCallback)
  MsgCenter:AddListener(eMsgEventId.AdjCustomChange, self.__OnListenerAdjChangeCallback)
end

HomeAdjutant.InitHomeAdjutant = function(self, bind, emptyHolder, loadOverCallback)
  -- function num : 0_1 , upvalues : _ENV, cs_ResLoader
  self.bind = bind
  self.isInit = true
  self.emptyHolder = emptyHolder
  self.loadOverCallback = loadOverCallback
  self.__interationOpenWait = true
  self.__interationOpenRayCast = true
  self:__ClearRes()
  if (math.random)(100000) == 666 then
    if self._surpriseLoader ~= nil then
      (self._surpriseLoader):Put2Pool()
      self._surpriseLoader = nil
    end
    self._surpriseLoader = (cs_ResLoader.Create)()
    self:LoadHeroPic("miemiezi", self._surpriseLoader, function(obj)
    -- function num : 0_1_0 , upvalues : self, _ENV
    self._surpriseObj = obj
    self.__randTimerId = TimerManager:StartTimer(0.6, function()
      -- function num : 0_1_0_0 , upvalues : self
      self.__randTimerId = nil
      self:LoadBoardHero()
    end
, nil, true)
  end
)
    return 
  end
  self:LoadBoardHero()
  self:RecordPosOnBorn()
end

HomeAdjutant.LoadBoardHero = function(self, callback)
  -- function num : 0_2 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MainPreset1) then
    return 
  end
  local adjPresetData = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  if adjPresetData == nil then
    return 
  end
  local heroList = adjPresetData:GetAdjPresetHeroList()
  local limitCount = #heroList
  local successCount = 0
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.homeController).homeCurrAdjutantLoaded = false
  local finishCallback = function()
    -- function num : 0_2_0 , upvalues : successCount, self, limitCount, callback
    successCount = successCount + 1
    if self._isHideBordGirl then
      self:HideBordGirl()
    end
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R0 in 'UnsetPending'

    if successCount == limitCount then
      (self.homeController).homeCurrAdjutantLoaded = true
      if self._waitGreeting then
        self:PlayAdjutantLoginGreeting()
      end
      if self.loadOverCallback ~= nil then
        (self.loadOverCallback)()
      end
      if callback ~= nil then
        callback()
      end
    end
  end

  if self.__randTimerId ~= nil then
    TimerManager:StopTimer(self.__randTimerId)
    self.__randTimerId = nil
  end
  if self._surpriseLoader ~= nil then
    (self._surpriseLoader):Put2Pool()
    self._surpriseLoader = nil
  end
  if not IsNull(self._surpriseObj) then
    DestroyUnityObject(self._surpriseObj)
    self._surpriseObj = nil
  end
  self.isInit = false
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.homeController).homeCurrAdjutantLoaded = false
  self:RecoverLastL2DRenderData()
  self:__ClearRes()
  for index,heroId in ipairs(heroList) do
    local adjInfo = adjPresetData:GetAdjPresetElemData(heroId)
    local resSingle = {}
    self:__ResetResInfo(resSingle, adjInfo)
    self:LoadAjutant(resSingle, finishCallback)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (self._resDic)[resSingle.dataId] = resSingle
  end
  if self.homeController ~= nil then
    (self.homeController):ResetHomeVoice()
  end
end

HomeAdjutant.__ResetResInfo = function(self, resInfo, adjInfo)
  -- function num : 0_3 , upvalues : _ENV, cs_ResLoader
  if not IsNull(resInfo.obj) then
    DestroyUnityObject(resInfo.obj)
    resInfo.obj = nil
  end
  if resInfo.resloader ~= nil then
    (resInfo.resloader):Put2Pool()
    resInfo.resloader = nil
  end
  resInfo.resloader = (cs_ResLoader.Create)()
  resInfo.dataId = adjInfo.dataId
  resInfo.skinId = adjInfo.skinId
  resInfo.isMain = adjInfo.isMain
  resInfo.isL2d = adjInfo.isL2d
  resInfo.pos = adjInfo.pos
  resInfo.size = adjInfo.size
  local isHideBg = (PlayerDataCenter.skinData):IsHideL2dBg(adjInfo.skinId)
  resInfo.isHideBg = isHideBg
end

HomeAdjutant.__ActiveL2dBg = function(self, resInfo, currentLive2dIsHideBg)
  -- function num : 0_4 , upvalues : _ENV, HeroL2dInterationController
  if IsNull(resInfo.obj) then
    return 
  end
  if resInfo.l2dBinding == nil then
    return 
  end
  if IsNull((resInfo.l2dBinding).renderController) then
    return 
  end
  resInfo.isHideBg = currentLive2dIsHideBg
  ;
  (HeroL2dInterationController.ActiveLive2dBg)((resInfo.l2dBinding).renderController, not currentLive2dIsHideBg)
end

HomeAdjutant.HideBordGirl = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self:OpenAdjutantWait(false)
  self._isHideBordGirl = true
  for k,resInfo in pairs(self._resDic) do
    if resInfo.obj ~= nil then
      ((resInfo.obj).transform):SetParent((self.emptyHolder).transform, false)
    end
  end
end

HomeAdjutant.ShowBordGirl = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self:OpenAdjutantWait(true)
  self._isHideBordGirl = false
  for i,resInfo in pairs(self._resDic) do
    if not IsNull(resInfo.obj) then
      if resInfo.l2dBinding ~= nil then
        ((resInfo.obj).transform):SetParent(((self.bind).live2DRoot).transform, false)
      else
        ;
        ((resInfo.obj).transform):SetParent(((self.bind).heroHolder).transform, false)
      end
      self:__SetPosAndSize(resInfo)
    end
  end
end

HomeAdjutant.OpenAdjutantWait = function(self, flag)
  -- function num : 0_7
  self.__interationOpenWait = flag
  self.__interationOpenRayCast = flag
  if not flag then
    self._waitGreeting = false
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):SetInterationOpenWait(flag)
    ;
    (self.heroCubismInteration):SetInterationOpenRayCast(flag)
  end
end

HomeAdjutant.__SetHeroCubismInteration = function(self, resInfo)
  -- function num : 0_8 , upvalues : _ENV, HeroCubismInteration
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  if resInfo.isL2d then
    local cs_CubismInterationController = ((resInfo.obj).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    if cs_CubismInterationController ~= nil then
      self.heroCubismInteration = (HeroCubismInteration.New)()
      ;
      (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, resInfo.dataId, resInfo.skinId, UIManager:GetMainCamera(), true, (self.homeController):GetLastCVId(), true)
      ;
      (self.heroCubismInteration):SetInterationOpenWait(self.__interationOpenWait)
      ;
      (self.heroCubismInteration):SetInterationOpenRayCast(self.__interationOpenRayCast)
    end
  else
    do
      self.heroCubismInteration = (HeroCubismInteration.New)()
      ;
      (self.heroCubismInteration):InitHeroPicCubism(resInfo.obj, resInfo.dataId, resInfo.skinId, (self.homeController):GetLastCVId())
      ;
      (self.heroCubismInteration):SetInterationOpenWait(self.__interationOpenWait)
      ;
      (self.heroCubismInteration):SetInterationOpenRayCast(self.__interationOpenRayCast)
    end
  end
end

HomeAdjutant.__SetPosAndSize = function(self, resInfo)
  -- function num : 0_9 , upvalues : _ENV
  if resInfo.isMain then
    ((resInfo.obj).transform):SetAsLastSibling()
  else
    ;
    ((resInfo.obj).transform):SetAsFirstSibling()
  end
  if resInfo.pos ~= nil then
    local vec = ((resInfo.obj).transform).localPosition
    vec.x = (resInfo.pos)[1]
    vec.y = (resInfo.pos)[2]
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((resInfo.obj).transform).localPosition = vec
  else
    do
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((resInfo.obj).transform).localPosition = resInfo.oriPos
      if resInfo.size ~= nil then
        local size = resInfo.oriSize * resInfo.size
        -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

        ;
        ((resInfo.obj).transform).localScale = (Vector3.New)(size, size, size)
      else
        do
          -- DECOMPILER ERROR at PC56: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((resInfo.obj).transform).localScale = (Vector3.New)(resInfo.oriSize, resInfo.oriSize, resInfo.oriSize)
        end
      end
    end
  end
end

HomeAdjutant.LoadAjutant = function(self, resInfo, finishCallback)
  -- function num : 0_10 , upvalues : _ENV
  if resInfo.isMain and self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local Local_SetAdjustAttribute = function(obj, l2dBinding)
    -- function num : 0_10_0 , upvalues : resInfo, self, _ENV, skinCtrl, finishCallback
    resInfo.obj = obj
    resInfo.l2dBinding = l2dBinding
    resInfo.oriSize = ((obj.transform).localScale).x
    resInfo.oriPos = (obj.transform).localPosition
    self:__SetPosAndSize(resInfo)
    do
      if resInfo.isL2d then
        local cubismCriwareAudioMouthInput = ((resInfo.obj).gameObject):GetComponent(typeof(CS.CubismCriwareAudioMouthInput))
        if not IsNull(cubismCriwareAudioMouthInput) then
          cubismCriwareAudioMouthInput.enabled = skinCtrl:CheckMouseOpen(resInfo.dataId, resInfo.skinId)
        end
      end
      if resInfo.isMain then
        self:__SetHeroCubismInteration(resInfo)
      end
      if finishCallback ~= nil then
        finishCallback()
      end
    end
  end

  local modelCfg = skinCtrl:GetResModel(resInfo.dataId, resInfo.skinId)
  local resName = modelCfg.src_id_pic
  if resInfo.isL2d then
    self:LoadLive2D(resName, resInfo.resloader, Local_SetAdjustAttribute)
  else
    self:LoadHeroPic(resName, resInfo.resloader, Local_SetAdjustAttribute)
  end
end

HomeAdjutant.LoadHeroPic = function(self, resName, resloader, finishCallback)
  -- function num : 0_11 , upvalues : _ENV
  resloader:LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(resName), function(prefab)
    -- function num : 0_11_0 , upvalues : self, _ENV, finishCallback
    local obj = prefab:Instantiate(((self.bind).heroHolder).transform)
    local comPerspHandle = obj:FindComponent(eUnityComponentID.CommonPicController)
    comPerspHandle:SetL2DPicPosType("Home", true)
    if finishCallback ~= nil then
      finishCallback(obj)
    end
  end
)
end

HomeAdjutant.LoadLive2D = function(self, resName, resloader, finishCallback)
  -- function num : 0_12 , upvalues : _ENV, HeroLookTargetController
  resloader:LoadABAssetAsync(PathConsts:GetCharacterLive2DPath(resName), function(l2dModelAsset)
    -- function num : 0_12_0 , upvalues : self, _ENV, HeroLookTargetController, finishCallback
    local obj = l2dModelAsset:Instantiate()
    ;
    (obj.transform):SetParent(((self.bind).live2DRoot).transform)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (obj.gameObject).layer = (((self.bind).live2DRoot).gameObject).layer
    local l2dBinding = {}
    ;
    (UIUtil.LuaUIBindingTable)(obj, l2dBinding)
    local canvasGroup = (self.bind).canvas_canvasGroup
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

    if canvasGroup ~= nil then
      (l2dBinding.renderController).uiCanvasGroup = canvasGroup
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (l2dBinding.renderController).SortingLayer = "UI3D"
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (l2dBinding.renderController).SortingOrder = -900
    end
    local cubismLookController = (obj.gameObject):GetComponent(typeof(((((CS.Live2D).Cubism).Framework).LookAt).CubismLookController))
    ;
    (HeroLookTargetController.OpenLookTarget)(cubismLookController, (l2dBinding.lookTarget).gameObject, UIManager:GetMainCamera())
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (l2dBinding.renderController).InfluencedByUICanvas = true
    ;
    (l2dBinding.commonPerpectiveHandle):SetRenderCamera((self.bind).live2DRoot)
    ;
    (l2dBinding.commonPerpectiveHandle):SetL2DPosType("Home", true)
    if finishCallback ~= nil then
      finishCallback(obj, l2dBinding)
    end
  end
)
end

HomeAdjutant.RecoverLastL2DRenderData = function(self)
  -- function num : 0_13 , upvalues : _ENV
  for i,resSingle in pairs(self._resDic) do
    if resSingle.l2dBinding ~= nil and (resSingle.l2dBinding).commonPerpectiveHandle ~= nil then
      ((resSingle.l2dBinding).commonPerpectiveHandle):RecoverRenderCameraData()
    end
  end
end

HomeAdjutant.RecordPosOnBorn = function(self)
  -- function num : 0_14
  if (self.bind).heroHolder ~= nil then
    self.picHolderPosOnBornX = ((((self.bind).heroHolder).transform).localPosition).x
  end
  if ((self.bind).live2DRoot).transform ~= nil then
    self.live2DHolderPosOnBornX = ((((self.bind).live2DRoot).transform).localPosition).x
  end
end

HomeAdjutant.HomeRightUnfoldRate = function(self, rate)
  -- function num : 0_15
  if not rate then
    rate = 0
  end
  local xValue = self.picHolderPosOnBornX or 0
  local offsXValue = (self.bind).picHolderSliderRatio * rate + xValue
  ;
  (((self.bind).heroHolder).transform):SetLocalX(offsXValue)
  xValue = self.live2DHolderPosOnBornX or 0
  offsXValue = (self.bind).live2dHolderSliderRatio * rate + (xValue)
  ;
  (((self.bind).live2DRoot).transform):SetLocalX(offsXValue)
end

HomeAdjutant.PlayAdjutantLoginGreeting = function(self)
  -- function num : 0_16
  if self.heroCubismInteration == nil then
    self._waitGreeting = true
    return 
  end
  self._waitGreeting = false
  local voiceId = self:GetLoginType()
  ;
  (self.heroCubismInteration):PlayLoginAnimation(voiceId)
end

HomeAdjutant.PlayAdjutantHeroEnterHomeAnimation = function(self)
  -- function num : 0_17
  if self.heroCubismInteration == nil then
    return 
  end
  local voiceId = self:GetLoginType()
  ;
  (self.heroCubismInteration):PlayHeroEnterHomeAnimation(voiceId)
end

HomeAdjutant.GetLoginType = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local loginType = nil
  local curAdjPreset = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  if curAdjPreset == nil then
    return 0
  end
  local mainAdj = curAdjPreset:GetAdjPresetElemMain()
  local heroId = mainAdj.dataId
  local skinId = mainAdj.skinId
  do
    if skinId == 0 then
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg ~= nil then
        skinId = heroCfg.default_skin
      end
    end
    local curHour = (TimeUtil:TimestampToDate(((os.time)()), nil, true)).hour
    local live2dConfig = nil
    if skinId ~= 0 then
      live2dConfig = (ConfigData.skin_live2d)[skinId]
    else
      live2dConfig = (ConfigData.skin_live2d)[heroId]
      warn("has heroId l2d!!!")
    end
    if live2dConfig ~= nil and live2dConfig.login_time_range ~= nil and (live2dConfig.login_time_range)[curHour + 1] ~= nil and #live2dConfig.login_time_range == 24 then
      loginType = (live2dConfig.login_time_range)[curHour + 1]
      return loginType
    else
      local loginRange = {0, 6, 12, 18}
      if loginRange[1] <= curHour and curHour < loginRange[2] then
        loginType = eVoiceType.MIDNIGHT
      else
        if loginRange[2] <= curHour and curHour < loginRange[3] then
          loginType = eVoiceType.MORNING
        else
          if loginRange[3] <= curHour and curHour < loginRange[4] then
            loginType = eVoiceType.AFTERNOON
          else
            loginType = eVoiceType.EVENING
          end
        end
      end
      return loginType
    end
  end
end

HomeAdjutant.IsPlayLoginAnimationOnAutoShowOver = function(self)
  -- function num : 0_19
  do
    if self.heroCubismInteration ~= nil then
      local loginType = (self.GetLoginType)()
      return (self.heroCubismInteration):IsPlayLoginAnimationOnAutoShowOver(loginType)
    end
    return true
  end
end

HomeAdjutant.OnListenerAdjChange = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local adjPresetData = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  if adjPresetData == nil then
    return 
  end
  local oriMainHeorId = nil
  if self.heroCubismInteration ~= nil then
    oriMainHeorId = (self.heroCubismInteration):GetCubismHeroId()
  end
  local ChangeFinishFunc = function()
    -- function num : 0_20_0 , upvalues : self, oriMainHeorId, _ENV
    if self._recordCubismHeroId ~= nil then
      return 
    end
    local curMainHeroId = (self.heroCubismInteration):GetCubismHeroId()
    if oriMainHeorId ~= nil and curMainHeroId ~= oriMainHeorId then
      local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
      if homeCtrl ~= nil and not GuideManager.inGuide then
        homeCtrl:PlayLoginHeroGreeting()
      end
    end
  end

  local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeCtrl ~= nil then
    homeCtrl:ResetShowHeroVoiceImme()
  end
  local heroList = adjPresetData:GetAdjPresetHeroList()
  if #heroList ~= (table.count)(self._resDic) then
    self:LoadBoardHero(ChangeFinishFunc)
    return 
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  local resetResIdDic = {}
  local needLoadDic = {}
  for index,heroId in ipairs(heroList) do
    resetResIdDic[heroId] = true
    local resInfo = (self._resDic)[heroId]
    local adjInfo = adjPresetData:GetAdjPresetElemData(heroId)
    if resInfo == nil then
      resInfo = {}
      self:__ResetResInfo(resInfo, adjInfo)
      -- DECOMPILER ERROR at PC67: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (self._resDic)[resInfo.dataId] = resInfo
      needLoadDic[resInfo.dataId] = resInfo
    else
      if adjInfo.skinId ~= resInfo.skinId or adjInfo.isL2d ~= resInfo.isL2d then
        self:__ResetResInfo(resInfo, adjInfo)
        needLoadDic[resInfo.dataId] = resInfo
      else
        resInfo.isMain = adjInfo.isMain
        resInfo.pos = adjInfo.pos
        resInfo.size = adjInfo.size
        if resInfo.isMain then
          self:__SetHeroCubismInteration(resInfo)
        end
        self:__SetPosAndSize(resInfo)
      end
      local currentLive2dIsHideBg = (PlayerDataCenter.skinData):IsHideL2dBg(adjInfo.skinId)
      if currentLive2dIsHideBg ~= resInfo.isHideBg then
        self:__ActiveL2dBg(resInfo, currentLive2dIsHideBg)
      end
    end
  end
  local waitLoadCount = (table.count)(needLoadDic)
  local hasLoadCount = 0
  -- DECOMPILER ERROR at PC123: Confused about usage of register: R10 in 'UnsetPending'

  if waitLoadCount > 0 then
    (self.homeController).homeCurrAdjutantLoaded = false
  else
    ChangeFinishFunc()
  end
  for k,resInfo in pairs(needLoadDic) do
    self:LoadAjutant(resInfo, function()
    -- function num : 0_20_1 , upvalues : hasLoadCount, self, waitLoadCount, ChangeFinishFunc
    hasLoadCount = hasLoadCount + 1
    if self._isHideBordGirl then
      self:HideBordGirl()
    end
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R0 in 'UnsetPending'

    if hasLoadCount == waitLoadCount then
      (self.homeController).homeCurrAdjutantLoaded = true
      ChangeFinishFunc()
    end
  end
)
  end
  for heroId,resInfo in pairs(self._resDic) do
    if resetResIdDic[heroId] == nil then
      if not IsNull(resInfo.obj) then
        DestroyUnityObject(resInfo.obj)
        resInfo.obj = nil
      end
      if resInfo.l2dBinding ~= nil then
        resInfo.l2dBinding = nil
      end
      ;
      (resInfo.resloader):Put2Pool()
      resInfo.resloader = nil
      -- DECOMPILER ERROR at PC162: Confused about usage of register: R15 in 'UnsetPending'

      ;
      (self._resDic)[heroId] = nil
    end
  end
end

HomeAdjutant.RecordCurCubismHeroId = function(self)
  -- function num : 0_21 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MainPreset1) then
    return 
  end
  local preset = (PlayerDataCenter.allAdjCustomData):GetUsingCustomPreset()
  if preset ~= nil then
    local mainInfo = preset:GetAdjPresetElemMain()
    self._recordCubismHeroId = mainInfo.dataId
  end
end

HomeAdjutant.IsChangeCubismHero = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_MainPreset1) then
    return false
  end
  if self._recordCubismHeroId == nil then
    return false
  end
  local nowCubismHeroId = nil
  if self.heroCubismInteration ~= nil then
    nowCubismHeroId = (self.heroCubismInteration):GetCubismHeroId()
  end
  do return nowCubismHeroId or 0 ~= self._recordCubismHeroId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HomeAdjutant.ClearCurCubismHeroRecord = function(self)
  -- function num : 0_23
  self._recordCubismHeroId = nil
end

HomeAdjutant.__ClearRes = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  for k,resSingle in pairs(self._resDic) do
    (resSingle.resloader):Put2Pool()
    resSingle.resloader = nil
    if not IsNull(resSingle.obj) then
      DestroyUnityObject(resSingle.obj)
      resSingle.obj = nil
    end
    if resSingle.l2dBinding ~= nil then
      resSingle.l2dBinding = nil
    end
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self._resDic)[k] = nil
  end
end

HomeAdjutant.Delete = function(self)
  -- function num : 0_25 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.AdjCustomModify, self.__OnListenerAdjChangeCallback)
  MsgCenter:RemoveListener(eMsgEventId.AdjCustomChange, self.__OnListenerAdjChangeCallback)
  if self.__randTimerId ~= nil then
    TimerManager:StopTimer(self.__randTimerId)
    self.__randTimerId = nil
  end
  if self._surpriseLoader ~= nil then
    (self._surpriseLoader):Put2Pool()
    self._surpriseLoader = nil
  end
  self:__ClearRes()
end

return HomeAdjutant

