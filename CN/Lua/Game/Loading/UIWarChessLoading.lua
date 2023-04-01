-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarChessLoading = class("UIWarChessLoading", UIBaseWindow)
local base = UIBaseWindow
local cs_RenderTexture = (CS.UnityEngine).RenderTexture
local cs_DOTween = ((CS.DG).Tweening).DOTween
UIWarChessLoading.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__permanent = true
  self.bg = (self.ui).bG
  self.captureSceen = (self.ui).captureSceen
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.captureSceen).renderCamera = UIManager:GetUICamera()
  self.loadEffectMat = (self.bg).material
  if not IsNull(self.loadEffectMat) then
    (self.loadEffectMat):SetFloat("_Alpha", 1)
    ;
    (self.loadEffectMat):SetColor("_MainColor", Color.white)
  end
end

UIWarChessLoading.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  (self.captureSceen).renderCamera = UIManager:GetUICamera()
  self:__Capture()
  self:__ClearTimer()
  self.delayOpenTimerId = TimerManager:StartTimer(1, self.__ShowBg, self, true, true, true)
  ;
  (base.OnShow)(self)
end

UIWarChessLoading.__Capture = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_RenderTexture
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R1 in 'UnsetPending'

  (self.bg).enabled = false
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.captureSceen).enabled = false
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.captureSceen).enabled = true
  local temp = (self.captureSceen).screenTex
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.captureSceen).screenTex = nil
  local isHasScreenTex = not IsNull(temp)
  if isHasScreenTex then
    cs_RenderTexture:ReleaseTemporary(temp)
  end
  if isHasScreenTex == false then
    (self.captureSceen):Capture()
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.bg).texture = (self.captureSceen).screenTex
  end
  local temp = (self.captureSceen).screenTex
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.captureSceen).screenTex = nil
  if not IsNull(temp) then
    self.cacheRT = temp
    cs_RenderTexture:ReleaseTemporary(temp)
  end
end

UIWarChessLoading.__ShowBg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.bg) then
    (self.bg).enabled = true
  end
  if self.startAction ~= nil then
    (self.startAction)()
    self.startAction = nil
  end
end

UIWarChessLoading.PlayLoadEffect = function(self, forcePos, isForward, startAction)
  -- function num : 0_4 , upvalues : _ENV
  self.startAction = startAction
  if forcePos ~= nil then
    (self.captureSceen):SetWorldToScreenPoint(forcePos)
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.captureSceen).effectCenter = (Vector2.New)(0.5, 0.5)
  end
  ;
  (self.captureSceen):PlayLoadEffect(isForward)
end

UIWarChessLoading.__ClearTimer = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.delayOpenTimerId ~= nil then
    TimerManager:StopTimer(self.delayOpenTimerId)
    self.delayOpenTimerId = nil
  end
end

UIWarChessLoading.PlayHideEffect = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_DOTween
  if not IsNull(self.loadEffectMat) then
    self.hideTweener = (cs_DOTween.To)(function()
    -- function num : 0_6_0
    return 1
  end
, function(x)
    -- function num : 0_6_1 , upvalues : self
    (self.loadEffectMat):SetFloat("_Alpha", x)
  end
, 0, (self.ui).hideEffectDuration)
    local __OnPlayHideEffectEnd = function()
    -- function num : 0_6_2 , upvalues : self, _ENV
    self:Hide()
    ;
    (self.loadEffectMat):SetFloat("_Alpha", 1)
    ;
    (self.loadEffectMat):SetColor("_MainColor", Color.white)
    self.hideTweener = nil
    if self.cacheRT ~= nil then
      DestroyUnityObject(self.cacheRT)
      self.cacheRT = nil
    end
  end

    ;
    (self.hideTweener):SetUpdate(true)
    ;
    (self.hideTweener):SetRecyclable()
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.hideTweener).onComplete = BindCallback(self, __OnPlayHideEffectEnd)
  else
    do
      self:Hide()
    end
  end
end

UIWarChessLoading.OnHide = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_RenderTexture, base
  self:__ClearTimer()
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.bg).texture = nil
  local temp = (self.captureSceen).screenTex
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.captureSceen).screenTex = nil
  if not IsNull(temp) then
    cs_RenderTexture:ReleaseTemporary(temp)
  end
  ;
  (base.OnHide)(self)
end

UIWarChessLoading.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  self:__ClearTimer()
  if not IsNull(self.hideTweener) then
    (self.hideTweener):Kill()
    self.hideTweener = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWarChessLoading

