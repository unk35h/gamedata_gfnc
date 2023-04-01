-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEffectMask = class("UIEffectMask", UIBaseWindow)
local base = UIBaseWindow
UIEffectMask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  local uiCamera = UIManager.UICamera
  if not IsNull(uiCamera) then
    self.uiCameraPostProcessLayer = uiCamera:GetComponent(typeof((((CS.UnityEngine).Rendering).PostProcessing).PostProcessLayer))
    self.uiCameraPostProcessVolume = uiCamera:GetComponent(typeof((((CS.UnityEngine).Rendering).PostProcessing).PostProcessVolume))
    if not IsNull(self.uiCameraPostProcessLayer) then
      self.originalLayerEnable = (self.uiCameraPostProcessLayer).enabled
    end
    if not IsNull(self.uiCameraPostProcessVolume) then
      self.originalProfile = (self.uiCameraPostProcessVolume).profile
    end
  end
end

UIEffectMask.ShowOldMovieEffectMask = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if not IsNull((self.ui).oldMovieEffectMask) then
    ((self.ui).oldMovieEffectMask):SetActive(true)
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.uiCameraPostProcessLayer) then
    (self.uiCameraPostProcessLayer).enabled = true
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.uiCameraPostProcessVolume) then
    (self.uiCameraPostProcessVolume).profile = (self.ui).pp_OldMovie
  end
end

UIEffectMask.HideOldMovieEffectMask = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not IsNull((self.ui).oldMovieEffectMask) then
    ((self.ui).oldMovieEffectMask):SetActive(false)
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.uiCameraPostProcessLayer) then
    (self.uiCameraPostProcessLayer).enabled = self.originalLayerEnable
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.uiCameraPostProcessVolume) then
    (self.uiCameraPostProcessVolume).profile = self.originalProfile
  end
end

UIEffectMask.OnShow = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnShow)(self)
end

UIEffectMask.OnHide = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnHide)(self)
end

UIEffectMask.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  self.uiCameraPostProcessLayer = nil
  self.uiCameraPostProcessVolume = nil
  self.originalLayerEnable = nil
  self.originalProfile = nil
  ;
  (base.OnDelete)(self)
end

return UIEffectMask

