-- params : ...
-- function num : 0 , upvalues : _ENV
local ShowCharacterSkinController = class("ShowCharacterSkinController", ControllerBase)
local base = ControllerBase
local ShowCharacterSkinSceneCtrl = require("Game.ShowCharacterSkin.Ctrl.ShowCharacterSkinSceneCtrl")
local util = require("XLua.Common.xlua_util")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local ShowCharacterUtil = require("Game.ShowCharacter.ShowCharacterUtil")
local CS_ResLoader = CS.ResLoader
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_Physics = CS.PhysicsUtility
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_Animator = (CS.UnityEngine).Animator
local CS_AnimationEffectController_Ins = (CS.AnimationEffectController).Instance
;
(xlua.private_accessible)(CS.CameraController)
ShowCharacterSkinController.ctor = function(self)
  -- function num : 0_0 , upvalues : ShowCharacterSkinSceneCtrl, _ENV, CS_GameObject
  self.ctrls = {}
  self.winLoopTimerIdList = {}
  self.sceneCtrl = (ShowCharacterSkinSceneCtrl.New)(self)
  self.__camMain = UIManager:GetMainCamera()
  self.__lightMain = (CS_GameObject.FindWithTag)(TagConsts.MainLight)
  self.onFingerTap = BindCallback(self, self.__onFingerTap)
  self.OnGesture = BindCallback(self, self.__onGesture)
end

ShowCharacterSkinController.OnInit = function(self)
  -- function num : 0_1 , upvalues : CS_ResLoader
  self.resloader = (CS_ResLoader.Create)()
end

ShowCharacterSkinController.InitShowCharacterSkinCtrl = function(self, heroId, skinId, enterFunc, exitFunc)
  -- function num : 0_2 , upvalues : _ENV, util
  self:__InitHeroData(heroId, skinId)
  self.__initSceneCoroutine = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.LoadScene)))
  self.enterFunc = enterFunc
  self.exitFunc = exitFunc
end

ShowCharacterSkinController.__InitHeroData = function(self, heroId, skinId)
  -- function num : 0_3 , upvalues : _ENV, CS_Animator
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local resCfg = skinCtr:GetResModel(heroId, skinId)
  self.modelPath = PathConsts:GetCharacterModelPathEx(resCfg.src_id_model)
  self.resName = resCfg.src_id_model
  local origresCfg = skinCtr:GetResModel(heroId)
  self.originName = origresCfg.src_id_model
  self.heroId = heroId
  self.skinId = skinId
  if self.AnimationIdList == nil then
    local commonStartFunc = function()
    -- function num : 0_3_0 , upvalues : self
    (self.characterAnimator):SetTrigger("BattleDie")
    ;
    (self.characterAnimator):SetBool("DeployFloat", self.float)
    ;
    (self.characterAnimator):SetBool("BattleRun", self.run)
    self.autoAnimation = false
  end

    do
      local heroCfg = (ConfigData.resource_model)[self.heroId]
      self.AnimationIdList = {
{animationName = (CS_Animator.StringToHash)("Deploy_Leap"), 
effectIdList = {}
, aniStartFunc = function()
    -- function num : 0_3_1 , upvalues : self, commonStartFunc
    self.float = false
    self.run = false
    commonStartFunc()
  end
, isPlay = true, tipId = 651, isDeploy = true}
, 
{animationName = (CS_Animator.StringToHash)("Deploy_Idle"), 
effectIdList = {}
, aniStartFunc = function()
    -- function num : 0_3_2 , upvalues : self, commonStartFunc
    self.float = false
    self.run = false
    commonStartFunc()
  end
, isPlay = true, tipId = 652}
, 
{animationName = (CS_Animator.StringToHash)("Battle_Win"), effectIdList = heroCfg.win_effect_id, aniStartFunc = function()
    -- function num : 0_3_3 , upvalues : self, commonStartFunc
    self.float = false
    self.run = false
    commonStartFunc()
  end
, isPlay = true, tipId = 653}
, 
{animationName = (CS_Animator.StringToHash)("Battle_Run"), 
effectIdList = {}
, aniStartFunc = function()
    -- function num : 0_3_4 , upvalues : self, commonStartFunc
    self.float = false
    self.run = true
    commonStartFunc()
  end
, isPlay = true, tipId = 654}
, 
{animationName = (CS_Animator.StringToHash)("Deploy_Float"), 
effectIdList = {}
, aniStartFunc = function()
    -- function num : 0_3_5 , upvalues : self, commonStartFunc
    self.float = true
    self.run = false
    commonStartFunc()
  end
, isPlay = true, tipId = 655}
}
    end
  end
end

ShowCharacterSkinController.LoadScene = function(self)
  -- function num : 0_4 , upvalues : _ENV, util
  (UIUtil.AddOneCover)("showCharacter", SafePack(nil, nil, nil, Color.clear, false))
  local path = PathConsts:GetShowCharacterSkinPrefabPath("ShowCharacterScene")
  local sceneWait = (self.resloader):LoadABAssetAsyncAwait(path)
  ;
  (coroutine.yield)(sceneWait)
  local scenePrefab = sceneWait.Result
  if scenePrefab ~= nil then
    self.sceneObj = scenePrefab:Instantiate()
    self.bind = {}
    ;
    (UIUtil.LuaUIBindingTable)(self.sceneObj, self.bind)
  end
  local currentScene = (LuaSceneManager:GetCurrentScene())
  local sceneName = nil
  if currentScene ~= nil then
    sceneName = currentScene.name
  end
  if sceneName == (Consts.SceneName).Main then
    local skyGameObject = (((CS.UnityEngine).GameObject).Find)("WeatherSystem")
    do
      skyGameObject:SetActive(false)
      local beforeExitFunc = self.exitFunc
      self.exitFunc = function()
    -- function num : 0_4_0 , upvalues : skyGameObject, beforeExitFunc
    skyGameObject:SetActive(true)
    if beforeExitFunc ~= nil then
      beforeExitFunc()
    end
  end

    end
  end
  do
    self:EnableMainCamAndLight(false)
    if self.enterFunc ~= nil then
      (self.enterFunc)()
      self.enterFunc = nil
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.ShowCharacterSkin, function(window)
    -- function num : 0_4_1 , upvalues : _ENV, self
    local hideWinList = UIManager:HideAllWindow({[UIWindowTypeID.TopStatus] = true, [UIWindowTypeID.ShowCharacterSkin] = true})
    local jumpCorverArgs = {hideWinList = hideWinList}
    window:SetFromWhichUI(eBaseWinFromWhere.jumpCorver)
    window.jumpCorverArgs = jumpCorverArgs
    window:InitShowCharacterSkin(self)
    self.__UIWindow = window
    ;
    (UIUtil.CloseOneCover)("showCharacter")
  end
)
    self.__initCharacterCoroutine = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.LoadCharacter)))
  end
end

ShowCharacterSkinController.LoadCharacter = function(self)
  -- function num : 0_5 , upvalues : _ENV, CS_Animator
  local showCharacterWait = (self.resloader):LoadABAssetAsyncAwait(self.modelPath)
  ;
  (coroutine.yield)(showCharacterWait)
  local showCharacterPrefab = showCharacterWait.Result
  if showCharacterPrefab ~= nil then
    self.characterObj = showCharacterPrefab:Instantiate()
    local characterTrans = ((self.bind).characterPos).transform
    ;
    ((self.characterObj).transform):SetParent(characterTrans)
    ;
    ((self.characterObj).transform):SetPositionAndRotation(characterTrans.position, characterTrans.rotation)
    self.characterAnimator = (self.characterObj):GetComponent(typeof(CS_Animator))
  end
  do
    self:OnLoadCompeleted()
  end
end

ShowCharacterSkinController.OnLoadCompeleted = function(self)
  -- function num : 0_6 , upvalues : ExplorationEnum, CS_LeanTouch
  self.cameraController = (self.bind).cameraController
  if self.cameraController ~= nil then
    (self.cameraController):SetControlState((ExplorationEnum.eEpCamControlState).Battle)
    self.__trackedDolly = (self.cameraController).trackedDolly
  end
  ;
  (CS_LeanTouch.OnFingerTap)("+", self.onFingerTap)
  ;
  (CS_LeanTouch.OnGesture)("+", self.OnGesture)
  self:PlayAnimationByIndex(1)
end

ShowCharacterSkinController.__onFingerTap = function(self)
  -- function num : 0_7 , upvalues : _ENV, CS_Physics, CS_AnimationEffectController_Ins
  if self.cameraController == nil then
    return 
  end
  local mainCamera = (self.cameraController).MainCamera
  if IsNull(mainCamera) then
    return 
  end
  local hits = (CS_Physics.Raycast)(mainCamera, 1 << LayerMask.Character)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) then
      CS_AnimationEffectController_Ins:KillAllEffects()
      CS_AnimationEffectController_Ins:RecycleEffects()
      self:PlayAnimation()
    end
  end
end

ShowCharacterSkinController.GetAnimationIdList = function(self)
  -- function num : 0_8
  return self.AnimationIdList
end

ShowCharacterSkinController.PlayAnimation = function(self, isCrossfade)
  -- function num : 0_9
  self:__StopwinLoopTimer()
  local hitPos = nil
  if self.characterAnimator ~= nil then
    local animationInfo, index = self:__GetNextAnimationInfo()
    if animationInfo.isPlay then
      if isCrossfade then
        (self.characterAnimator):CrossFade(animationInfo.animationName, 0.1)
      else
        ;
        (self.characterAnimator):Play(animationInfo.animationName)
      end
    else
      self:PlayAnimation()
      return 
    end
    ;
    (animationInfo.aniStartFunc)()
    self:PlayAnimationEnd(animationInfo, index)
  end
end

ShowCharacterSkinController.PlayAnimationByIndex = function(self, index)
  -- function num : 0_10 , upvalues : CS_AnimationEffectController_Ins
  self:__StopwinLoopTimer()
  CS_AnimationEffectController_Ins:KillAllEffects()
  CS_AnimationEffectController_Ins:RecycleEffects()
  local hitPos = nil
  if self.characterAnimator ~= nil then
    local animationInfo = (self.AnimationIdList)[index]
    self.next = index
    ;
    (self.characterAnimator):Play(animationInfo.animationName)
    ;
    (animationInfo.aniStartFunc)()
    self:PlayAnimationEnd(animationInfo, index)
  end
end

ShowCharacterSkinController.PlayAnimationEnd = function(self, animationInfo, index)
  -- function num : 0_11 , upvalues : _ENV, CS_Animator, CS_AnimationEffectController_Ins
  local battleWinClipLength = 0
  local deployClipLength = 0
  local animator = (self.characterObj):GetComponent(typeof(CS_Animator))
  for i = 0, ((animator.runtimeAnimatorController).animationClips).Length - 1 do
    local animationClip = ((animator.runtimeAnimatorController).animationClips)[i]
    if animationClip.name == "battle_win" then
      battleWinClipLength = animationClip.length
    else
      if animationClip.name == "deploy_leap" then
        deployClipLength = animationClip.length
      end
    end
  end
  if self.deployTimerId ~= nil then
    TimerManager:StopTimer(self.deployTimerId)
    self.deployTimerId = nil
  end
  if animationInfo.isDeploy then
    self.autoAnimation = true
    self.deployTimerId = TimerManager:StartTimer(deployClipLength + 1, function()
    -- function num : 0_11_0 , upvalues : self
    if self.autoAnimation then
      self:PlayAnimation(true)
    end
  end
, self, true, false, false)
  end
  for _,effectId in ipairs(animationInfo.effectIdList) do
    local effect = CS_AnimationEffectController_Ins:AddAnimationEffectByBattleEffectId(effectId, self.characterObj, self.resName, self.originName)
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (effect.effectCfg).Layer = LayerMask.Character
    if (string.find)(effect.Code, "win_loop") == nil then
      effect:Play()
    else
      local winLoopTimerId = TimerManager:StartTimer(battleWinClipLength, effect.Play, effect, true, false, false)
      ;
      (table.insert)(self.winLoopTimerIdList, winLoopTimerId)
    end
  end
  local win = UIManager:GetWindow(UIWindowTypeID.ShowCharacterSkin)
  if win then
    win:SetTopText(index)
  end
end

ShowCharacterSkinController.__StopwinLoopTimer = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.winLoopTimerIdList ~= nil then
    for i = 1, #self.winLoopTimerIdList do
      TimerManager:StopTimer((self.winLoopTimerIdList)[i])
    end
  end
  do
    self.winLoopTimerIdList = {}
  end
end

ShowCharacterSkinController.__onGesture = function(self, fingerList)
  -- function num : 0_13 , upvalues : ShowCharacterUtil
  (ShowCharacterUtil.DoGestureFunc)(self.__trackedDolly, fingerList)
end

ShowCharacterSkinController.__GetNextAnimationInfo = function(self)
  -- function num : 0_14
  if self.next == nil then
    self.next = 0
  end
  if #self.AnimationIdList <= self.next then
    self.next = 0
  end
  self.next = self.next + 1
  return (self.AnimationIdList)[self.next], self.next
end

ShowCharacterSkinController.EnableMainCamAndLight = function(self, enable)
  -- function num : 0_15 , upvalues : _ENV
  if not IsNull(self.__camMain) then
    ((self.__camMain).gameObject):SetActive(enable)
  end
  if not IsNull(self.__lightMain) then
    (self.__lightMain):SetActive(enable)
  end
end

ShowCharacterSkinController.ExitShowCharacter = function(self)
  -- function num : 0_16
  self:EnableMainCamAndLight(true)
  self:Delete()
end

ShowCharacterSkinController.OnDelete = function(self)
  -- function num : 0_17 , upvalues : CS_LeanTouch, _ENV, CS_AnimationEffectController_Ins, base
  (CS_LeanTouch.OnFingerTap)("-", self.onFingerTap)
  ;
  (CS_LeanTouch.OnGesture)("-", self.OnGesture)
  if self.deployTimerId ~= nil then
    TimerManager:StopTimer(self.deployTimerId)
    self.deployTimerId = nil
  end
  if self.__initSceneCoroutine ~= nil then
    (GR.StopCoroutine)(self.__initSceneCoroutine)
  end
  if self.__initCharacterCoroutine ~= nil then
    (GR.StopCoroutine)(self.__initCharacterCoroutine)
  end
  UIManager:DeleteWindow(UIWindowTypeID.ShowCharacterSkin)
  if self.exitFunc ~= nil then
    (self.exitFunc)()
    self.exitFunc = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.heroId = nil
  self.skinId = nil
  self:__StopwinLoopTimer()
  CS_AnimationEffectController_Ins:DisposeAllEffects()
  DestroyUnityObject(self.sceneObj)
  DestroyUnityObject(self.characterObj)
  ;
  (base.OnDelete)(self)
end

return ShowCharacterSkinController

