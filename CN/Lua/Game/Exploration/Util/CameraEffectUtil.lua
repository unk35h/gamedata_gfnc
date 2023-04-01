-- params : ...
-- function num : 0 , upvalues : _ENV
local CameraEffectUtil = {}
local OldMovieCameraEffect = function(resloader, camera)
  -- function num : 0_0 , upvalues : _ENV
  if IsNull(camera) then
    return 
  end
  if IsNull(resloader) then
    return 
  end
  local oldMovieMaskPath = "FX/Scene/BattleScene/OldMovieEffect/FXP_OldMovieMask" .. PathConsts.PrefabExtension
  local oldMovieMaskWait = resloader:LoadABAssetAsyncAwait(oldMovieMaskPath)
  ;
  (coroutine.yield)(oldMovieMaskWait)
  local oldMovieMaskPrefab = oldMovieMaskWait.Result
  if IsNull(oldMovieMaskPrefab) then
    return 
  end
  local oldMovieMaskPoj = oldMovieMaskPrefab:Instantiate(camera.transform)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (oldMovieMaskPoj.transform).position = (camera.transform).position + (camera.transform).forward * 0.2
  local bind = {}
  ;
  (UIUtil.LuaUIBindingTable)(oldMovieMaskPoj.transform, bind)
  local oldMoviePostProcessVolumeProfile = bind.pp_OldMovie
  if not IsNull(oldMoviePostProcessVolumeProfile) then
    local oldMoviePostProcessVolume = camera:GetComponent(typeof((((CS.UnityEngine).Rendering).PostProcessing).PostProcessVolume))
    if IsNull(oldMoviePostProcessVolume) then
      oldMoviePostProcessVolume = camera:AddComponent(typeof((((CS.UnityEngine).Rendering).PostProcessing).PostProcessVolume))
    end
    oldMoviePostProcessVolume.profile = oldMoviePostProcessVolumeProfile
  end
end

local ShowOldMovieUIEffect = function()
  -- function num : 0_1 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EffectMask, function(window)
    -- function num : 0_1_0
    window:ShowOldMovieEffectMask()
  end
)
end

local HideOldMovieUIEffect = function()
  -- function num : 0_2 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.EffectMask)
  if window ~= nil then
    window:HideOldMovieEffectMask()
    window:OnDelete()
    UIManager:DeleteWindow(UIWindowTypeID.EffectMask)
  end
end

CameraEffectUtil.CameraEffectFunction = {}
CameraEffectUtil.CloseCameraEffectFunction = {}
-- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

;
(CameraEffectUtil.CameraEffectFunction)[1] = ShowOldMovieUIEffect
-- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

;
(CameraEffectUtil.CloseCameraEffectFunction)[1] = HideOldMovieUIEffect
return CameraEffectUtil

