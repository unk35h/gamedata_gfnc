-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHeroGrow.UI.UINCharaDungeonBase")
local UINCharDunKuro = class("UINCharDunKuro", base)
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local cs_AudioManager = (CS.AudioManager).Instance
local cs_ResLoader = CS.ResLoader
local cs_MovieManager = (CS.MovieManager).Instance
UINCharDunKuro.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Player, self, self._OnBtnPlayerChange)
  local settingCtrl = ControllerManager:GetController(ControllerTypeId.Setting, true)
  self.audioSetting = settingCtrl:GetSettingAudioData()
  AudioManager:PlayAudioById(3001)
  self.heroID = 1044
  self:_LoadRes(true)
end

UINCharDunKuro._OnBtnPlayerChange = function(self, pause)
  -- function num : 0_1 , upvalues : cs_AudioManager
  local idx = pause and 1 or 0
  ;
  ((self.ui).Img_Player):SetIndex(idx)
  self:_SetPlayerDOTweenPause(pause)
  local setValue = 0
  if not pause then
    setValue = ((self.audioSetting).volumes)[1]
  end
  cs_AudioManager:SetVolume(1, setValue)
end

UINCharDunKuro._LoadRes = function(self, isMovie)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).img_Kuro).gameObject):SetActive(false)
  ;
  (((self.ui).img_Movie).gameObject):SetActive(false)
  self:_SetWaitActive(true)
  self:_SetLiveDOTweenPause(true)
  local resIsDoneFunc = function(obj, l2dBinding)
    -- function num : 0_2_0 , upvalues : self, _ENV
    self.l2dBinding = l2dBinding
    self.timeID = TimerManager:StartTimer(1.5, function()
      -- function num : 0_2_0_0 , upvalues : obj, self
      obj:SetActive(true)
      self:_SetWaitActive(false)
      self:_SetLiveDOTweenPause(false)
    end
, true)
  end

  if isMovie then
    self:_LoadMovie(resIsDoneFunc)
    return 
  end
  self:_LoadLive2D(resIsDoneFunc)
end

UINCharDunKuro._LoadMovie = function(self, resIsDoneFunc)
  -- function num : 0_3 , upvalues : cs_MovieManager, _ENV
  if self.moviePlayer == nil then
    self.moviePlayer = cs_MovieManager:GetMoviePlayer()
  end
  ;
  (self.moviePlayer):SetVideoRender((self.ui).img_Movie)
  local path = PathConsts:GetCharDunVideoPath(self.heroID)
  ;
  (self.moviePlayer):PlayVideo(path, nil, 1, true)
  resIsDoneFunc(((self.ui).img_Movie).gameObject)
end

UINCharDunKuro._LoadLive2D = function(self, resIsDoneFunc)
  -- function num : 0_4 , upvalues : _ENV, HeroData, cs_ResLoader, HeroCubismInteration
  local heroCfg = (ConfigData.hero_data)[self.heroID]
  if heroCfg == nil then
    error("Can\'t Get HeroCfg by ID:" .. "1044")
    return 
  end
  local heroData = (HeroData.New)({
basic = {id = self.heroID, level = 1, exp = 0, star = heroCfg.rank, potentialLvl = 0, ts = -1, career = heroCfg.career, company = heroCfg.camp}
})
  DestroyUnityObject(self.liveGo)
  self.resLoader = (cs_ResLoader.Create)()
  local picName = heroData:GetResPicName()
  local resPath = PathConsts:GetCharacterLive2DPath(picName)
  local showLive2d = (PlayerDataCenter.skinData):GetLive2dSwitchState(heroData.dataId, heroData.skinId)
  if not ((CS.ResManager).Instance):ContainsAsset(resPath) or not showLive2d then
    resIsDoneFunc(((self.ui).img_Kuro).gameObject)
    return 
  end
  ;
  (self.resLoader):LoadABAssetAsync(resPath, function(l2dModelAsset)
    -- function num : 0_4_0 , upvalues : self, _ENV, HeroCubismInteration, heroData, resIsDoneFunc
    self.liveGo = l2dModelAsset:Instantiate(((self.ui).resHolder).transform)
    ;
    ((self.liveGo).transform):SetLayer(LayerMask.UI)
    ;
    ((self.liveGo).gameObject):SetActive(false)
    local cs_CubismInterationController = ((self.liveGo).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    if cs_CubismInterationController ~= nil then
      self.heroCubismInteration = (HeroCubismInteration.New)()
      local heroId = heroData.dataId
      local skinId = heroData.skinId
      ;
      (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, heroId, skinId, UIManager:GetUICamera(), false)
      ;
      (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
      ;
      (self.heroCubismInteration):SetRenderControllerSetting((self.charDunWin):GetWindowSortingLayer(), (self.ui).resHolder, nil, true)
      ;
      (self.heroCubismInteration):SetL2DPosType("CharDun", false)
    end
    do
      local l2dBinding = {}
      ;
      (UIUtil.LuaUIBindingTable)(self.liveGo, l2dBinding)
      resIsDoneFunc((self.liveGo).gameObject, l2dBinding)
    end
  end
)
end

UINCharDunKuro._SetPlayerDOTweenPause = function(self, pause)
  -- function num : 0_5 , upvalues : _ENV
  for _,doTween in ipairs((self.ui).playerDOTweens) do
    if pause then
      doTween:DOPause()
    else
      doTween:DOPlay()
    end
  end
end

UINCharDunKuro._SetLiveDOTweenPause = function(self, isPause)
  -- function num : 0_6 , upvalues : _ENV
  for _,tween in ipairs((self.ui).liveDOTween) do
    if isPause then
      tween:DOPause()
    else
      tween:DOPlay()
    end
  end
end

UINCharDunKuro._SetWaitActive = function(self, active)
  -- function num : 0_7
  ((self.ui).obj_wait):SetActive(active)
end

UINCharDunKuro.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, cs_MovieManager, cs_AudioManager, base
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  if self.timeID ~= nil then
    TimerManager:StopTimer(self.timeID)
    self.timeID = nil
  end
  if self.moviePlayer ~= nil then
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  DestroyUnityObject(self.liveGo)
  cs_AudioManager:SetVolume(1, ((self.audioSetting).volumes)[1])
  AudioManager:PlayAudioById(3002)
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Home).name, (eAuSelct.Home).sector)
  ;
  (base.OnDelete)(self)
end

return UINCharDunKuro

