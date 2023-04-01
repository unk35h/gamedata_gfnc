-- params : ...
-- function num : 0 , upvalues : _ENV
local HomeMainBg = class("HomeMainBg")
local CS_Resloader = CS.ResLoader
local CS_Object = (CS.UnityEngine).Object
local CS_coroutine = require("XLua.Common.cs_coroutine")
HomeMainBg.SetLoadedSuccessFunc = function(self, func)
  -- function num : 0_0
  self._loadSuccessFunc = func
end

HomeMainBg.MainBgSetBind = function(self, bind)
  -- function num : 0_1 , upvalues : _ENV
  self._mainBind = bind
  self._mainImage = (self._mainBind):GetBind("commandCentre_Image")
  if self._bgCfg ~= nil and not (string.IsNullOrEmpty)((self._bgCfg).src_id_pic_prefab) then
    self._obj = (self._mainBind):GetBind((self._bgCfg).src_id_pic_prefab)
  end
  self._stopMeshParentObj = (self._mainBind):GetBind("static")
end

HomeMainBg.UpdateBgId = function(self, bgCfg)
  -- function num : 0_2 , upvalues : _ENV, CS_Resloader, CS_Object
  if bgCfg == self._bgCfg then
    do
      if IsNull(self._stopMeshObj) then
        local stopMeshObj = (self._resloader):LoadABAsset(PathConsts:GetMainSceneDeckPath((self._bgCfg).stop_mesh))
        if not IsNull(stopMeshObj) then
          self._stopMeshObj = stopMeshObj:Instantiate()
          ;
          (self._stopMeshObj):SetActive(self._isShow)
          if not IsNull(self._stopMeshParentObj) then
            ((self._stopMeshObj).transform):SetParent((self._stopMeshParentObj).transform)
          end
        end
      end
      do return  end
      if self._oldResloader ~= nil then
        (self._resloader):Put2Pool()
        self._resloader = nil
      else
        self._oldResloader = self._resloader
        self._oldDayMat = self._matDay
        self._oldNightMat = self._matNight
      end
      if self._isShow and not IsNull(self._obj) then
        (self._obj):SetActive(false)
      end
      self._textureDay = nil
      self._textureNight = nil
      self._obj = nil
      self._matDay = nil
      self._matNight = nil
      self._bgCfg = bgCfg
      self._resloader = (CS_Resloader.Create)()
      if not (string.IsNullOrEmpty)((self._bgCfg).src_id_pic_prefab) and self._mainBind ~= nil then
        self._obj = (self._mainBind):GetBind((self._bgCfg).src_id_pic_prefab)
      end
      if not IsNull(self._stopMeshObj) then
        DestroyUnityObject(self._stopMeshObj)
        self._stopMeshObj = nil
      end
      local stopMeshObj = (self._resloader):LoadABAsset(PathConsts:GetMainSceneDeckPath((self._bgCfg).stop_mesh))
      if not IsNull(stopMeshObj) then
        self._stopMeshObj = stopMeshObj:Instantiate()
        ;
        (self._stopMeshObj):SetActive(false)
        if not IsNull(self._stopMeshParentObj) then
          ((self._stopMeshObj).transform):SetParent((self._stopMeshParentObj).transform)
        end
      end
      local progress = 4
      ;
      (self._resloader):LoadABAssetAsync(PathConsts:GetMainSceneBgPath((self._bgCfg).src_id_pic_day), function(texture)
    -- function num : 0_2_0 , upvalues : self, progress
    self._textureDay = texture
    progress = progress - 1
    self:__TryApply(progress)
  end
)
      ;
      (self._resloader):LoadABAssetAsync(PathConsts:GetMainSceneMatPath((self._bgCfg).src_id_mat_day), function(mat)
    -- function num : 0_2_1 , upvalues : _ENV, self, CS_Object, progress
    if not IsNull(self._matDay) then
      DestroyUnityObject(self._matDay)
    end
    self._matDay = (CS_Object.Instantiate)(mat)
    progress = progress - 1
    self:__TryApply(progress)
  end
)
      ;
      (self._resloader):LoadABAssetAsync(PathConsts:GetMainSceneBgPath((self._bgCfg).src_id_pic_night), function(texture)
    -- function num : 0_2_2 , upvalues : self, progress
    self._textureNight = texture
    progress = progress - 1
    self:__TryApply(progress)
  end
)
      ;
      (self._resloader):LoadABAssetAsync(PathConsts:GetMainSceneMatPath((self._bgCfg).src_id_mat_night), function(mat)
    -- function num : 0_2_3 , upvalues : _ENV, self, CS_Object, progress
    if not IsNull(self._matNight) then
      DestroyUnityObject(self._matNight)
    end
    self._matNight = (CS_Object.Instantiate)(mat)
    progress = progress - 1
    self:__TryApply(progress)
  end
)
    end
  end
end

HomeMainBg.__TryApply = function(self, progress)
  -- function num : 0_3 , upvalues : _ENV
  if progress > 0 then
    return 
  end
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._matDay).mainTexture = self._textureDay
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._matNight).mainTexture = self._textureNight
  if self._isShow then
    if not IsNull(self._obj) then
      (self._obj):SetActive(self._isShow)
    end
    self:__RefreshHomeMainMat()
  end
  if not IsNull(self._stopMeshObj) then
    (self._stopMeshObj):SetActive(self._isShow)
  end
  if not IsNull(self._oldDayMat) then
    DestroyUnityObject(self._oldDayMat)
    self._oldDayMat = nil
  end
  if not IsNull(self._oldNightMat) then
    DestroyUnityObject(self._oldNightMat)
    self._oldNightMat = nil
  end
  if self._oldResloader ~= nil then
    (self._oldResloader):Put2Pool()
    self._oldResloader = nil
  end
  if self._loadSuccessFunc ~= nil then
    (self._loadSuccessFunc)()
  end
end

HomeMainBg.SetHomeMainEnable = function(self, isShow)
  -- function num : 0_4 , upvalues : _ENV
  self._isShow = isShow
  if self._bgCfg == nil then
    return 
  end
  if not IsNull(self._obj) then
    (self._obj):SetActive(self._isShow)
  end
  if not self._isShow and not IsNull(self._stopMeshObj) then
    (self._stopMeshObj):SetActive(false)
  end
  do return  end
  self:__RefreshHomeMainMat()
end

HomeMainBg.SetHomeMainState = function(self, isDay)
  -- function num : 0_5
  self._isDay = isDay
  if self._bgCfg == nil then
    return 
  end
  if not self._isShow then
    return 
  end
  self:__RefreshHomeMainMat()
end

HomeMainBg.__RefreshHomeMainMat = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if IsNull(self._mainImage) or IsNull(self._matDay) or IsNull(self._matNight) then
    return 
  end
  if not IsNull(self._stopMeshObj) then
    (self._stopMeshObj):SetActive(true)
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

  if not self._isDay or not self._matDay then
    (self._mainImage).material = self._matNight
  end
end

HomeMainBg.ClearMainBgRes = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self._bgCfg = nil
  self._textureDay = nil
  self._textureNight = nil
  if not IsNull(self._obj) then
    self._obj = nil
  end
  if not IsNull(self._matDay) then
    DestroyUnityObject(self._matDay)
    self._matDay = nil
  end
  if not IsNull(self._matNight) then
    DestroyUnityObject(self._matNight)
    self._matNight = nil
  end
  if not IsNull(self._stopMeshObj) then
    DestroyUnityObject(self._stopMeshObj)
    self._stopMeshObj = nil
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  if not IsNull(self._oldDayMat) then
    DestroyUnityObject(self._oldDayMat)
    self._oldDayMat = nil
  end
  if not IsNull(self._oldNightMat) then
    DestroyUnityObject(self._oldNightMat)
    self._oldNightMat = nil
  end
  if self._oldResloader ~= nil then
    (self._oldResloader):Put2Pool()
    self._oldResloader = nil
  end
end

HomeMainBg.Delete = function(self)
  -- function num : 0_8
  self:ClearMainBgRes()
end

return HomeMainBg

