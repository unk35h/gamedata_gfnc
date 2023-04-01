-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroCubismInteration = class("HeroCubismInteration")
local cs_CubismMaskTexture = ((((CS.Live2D).Cubism).Rendering).Masking).CubismMaskTexture
local cs_CubismMaskController = ((((CS.Live2D).Cubism).Rendering).Masking).CubismMaskController
local HeroL2dInterationController = require("Game.Hero.Live2D.HeroL2dInterationController")
local HeroPicInterationController = require("Game.Hero.Live2D.HeroPicInterationController")
HeroCubismInteration.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__PlayCvCallback = BindCallback(self, self.__PlayCv)
  self.IsCvOverBank = BindCallback(self, self.SetInterationCVOver)
end

HeroCubismInteration.InitHeroCubism = function(self, cs_CubismInterationController, heroId, heroSkinId, camera, haveCV, lastCvId, needHideBg)
  -- function num : 0_1 , upvalues : HeroL2dInterationController
  self.skinId = heroSkinId
  self._controller = (HeroL2dInterationController.New)()
  local aniFunc = haveCV and self.__PlayCvCallback or nil
  ;
  (self._controller):InitL2dInteration(cs_CubismInterationController, heroId, heroSkinId, camera, true, aniFunc, nil, lastCvId or 0, needHideBg)
  self:__SetCommonWhenInit(heroId)
end

HeroCubismInteration.InitHeroPicCubism = function(self, go, heroId, skinId, lastCvId)
  -- function num : 0_2 , upvalues : HeroPicInterationController
  self.skinId = skinId
  self._controller = (HeroPicInterationController.New)()
  ;
  (self._controller):InitPicInteration(go, self.__PlayCvCallback, lastCvId, heroId, skinId)
  self:__SetCommonWhenInit(heroId)
end

HeroCubismInteration.__SetCommonWhenInit = function(self, heroId)
  -- function num : 0_3 , upvalues : _ENV
  self.homeController = ControllerManager:GetController(ControllerTypeId.HomeController, true)
  self.heroId = heroId
end

HeroCubismInteration.JudgeL2DLocked = function(heroSkinId)
  -- function num : 0_4 , upvalues : _ENV
  if heroSkinId == 0 then
    return false
  end
  if (ConfigData.skin)[heroSkinId] == nil then
    return false
  end
  do return ((ConfigData.skin)[heroSkinId]).live2d_level == 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroCubismInteration.InitShopCubism = function(self, cs_CubismInterationController, camera, callFunction)
  -- function num : 0_5 , upvalues : HeroL2dInterationController
  self._controller = (HeroL2dInterationController.New)()
  ;
  (self._controller):InitL2dInteration(cs_CubismInterationController, 0, 0, camera, false, nil, callFunction)
end

HeroCubismInteration.SetInterationCVOver = function(self, flag)
  -- function num : 0_6
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):SetInterationCVOver(flag)
end

HeroCubismInteration.SetInterationOpenWait = function(self, flag)
  -- function num : 0_7
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):SetInterationOpenWait(flag)
end

HeroCubismInteration.SetInterationOpenRayCast = function(self, flag)
  -- function num : 0_8
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):SetInterationOpenRayCast(flag)
end

HeroCubismInteration.PlayHeroEnterHomeAnimation = function(self, loginType)
  -- function num : 0_9
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):PlayHeroEnterHomeAnimation(loginType)
end

HeroCubismInteration.PlayLoginAnimation = function(self, loginType)
  -- function num : 0_10
  if self._controller == nil then
    return 0
  end
  return (self._controller):PlayLoginAnimation(loginType)
end

HeroCubismInteration.ResetInterationWaitTime = function(self)
  -- function num : 0_11
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):ResetInterationWaitTime()
end

HeroCubismInteration.__PlayCv = function(self, cvId, timeLength, OpenMouseListen)
  -- function num : 0_12
  if self.homeController ~= nil then
    local heroId = self:GetCubismHeroId()
    local skinId = self:GetCubismSkinId()
    ;
    (self.homeController):PlayHomeVoice(heroId, skinId, cvId, self.IsCvOverBank, timeLength, OpenMouseListen)
  end
end

HeroCubismInteration.RestartBodyAnimation = function(self)
  -- function num : 0_13
  if self._controller == nil then
    return 
  end
  ;
  (self._controller):SetInterationCVOver(true)
  ;
  (self._controller):RestartBodyAnimation()
end

HeroCubismInteration.IsPlayLoginAnimationOnAutoShowOver = function(self, loginType)
  -- function num : 0_14
  if self._controller == nil then
    return 
  end
  return (self._controller):IsPlayLoginAnimationOnAutoShowOver(loginType)
end

HeroCubismInteration.GetCubismHeroId = function(self)
  -- function num : 0_15
  return self.heroId
end

HeroCubismInteration.GetCubismSkinId = function(self)
  -- function num : 0_16
  return self.skinId
end

HeroCubismInteration.OpenLookTarget = function(self, camera)
  -- function num : 0_17
  if self._controller ~= nil and (self._controller).OpenLookTarget ~= nil then
    (self._controller):OpenLookTarget(camera)
  end
end

HeroCubismInteration.SetRenderControllerSetting = function(self, sortingLayerName, uiCanvasGroup, sortingOrder, InfluencedByUICanvas)
  -- function num : 0_18
  if self._controller ~= nil and (self._controller).SetRenderControllerSetting ~= nil then
    (self._controller):SetRenderControllerSetting(sortingLayerName, uiCanvasGroup, sortingOrder, InfluencedByUICanvas)
  end
end

HeroCubismInteration.SetL2DPosType = function(self, posTypeName, alignUIFakeCam)
  -- function num : 0_19
  if self._controller ~= nil and (self._controller).SetL2DPosType ~= nil then
    (self._controller):SetL2DPosType(posTypeName, alignUIFakeCam)
  end
end

HeroCubismInteration.DestroyInterationInstance = function(interationGameObject)
  -- function num : 0_20 , upvalues : _ENV, cs_CubismMaskController, cs_CubismMaskTexture
  if IsNull(interationGameObject) then
    return 
  end
  local maskController = interationGameObject:GetComponent(typeof(cs_CubismMaskController))
  do
    if not IsNull(maskController) then
      local maskTexture = cs_CubismMaskTexture.GlobalMaskTexture
      maskTexture:RemoveSource(maskController)
    end
    DestroyUnityObject(interationGameObject)
  end
end

HeroCubismInteration.Delete = function(self)
  -- function num : 0_21
  if self._controller ~= nil then
    (self._controller):Delete()
  end
end

return HeroCubismInteration

