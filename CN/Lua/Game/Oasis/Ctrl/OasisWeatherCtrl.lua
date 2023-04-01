-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Oasis.Ctrl.OasisCtrlBase")
local OasisWeatherCtrl = class("OasisWeatherCtrl", base)
local cs_OasisWeatherController = CS.OasisWeatherController
local cs_WeatherConfig = CS.WeatherConfig
local cs_SkyController = CS.SkyController
local cs_ResLoader = CS.ResLoader
local cs_time = (CS.UnityEngine).Time
OasisWeatherCtrl.InitOasisWeatherCtrl = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_OasisWeatherController, cs_WeatherConfig, cs_SkyController, cs_ResLoader
  self.isInOasis = false
  local unlockSkySetting = ((PlayerDataCenter.AllBuildingData).built)[eBuildingId.SkyBuilding] ~= nil
  local systemData = PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)
  local effectQuality = systemData:GetDisplaySettingValue("effect_quality")
  self.isActive = not unlockSkySetting or systemData:GetDisplaySettingValue("open_weather") == 1
  self:SetOasisWeatherSetting(effectQuality)
  self.lastTranWeatherTime = 0
  self.weatherDuration = 0
  local weatherConfigData = ConfigData.oasis_weather
  self.oasisWeatherController = cs_OasisWeatherController.Instance
  self.defaultWeatherConfig = cs_WeatherConfig()
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.defaultWeatherConfig).transDuration = 1
  if not IsNull(cs_SkyController.Instance) then
    self.cloud2d = (cs_SkyController.Instance).clouds
    self.uskyPro = ((cs_SkyController.Instance).gameObject):GetComponent(typeof(CS.uSkyPro))
  end
  self.resLoader = (cs_ResLoader.Create)()
  self.mainCamera = UIManager:GetMainCamera()
  self:GenerateweatherList(weatherConfigData)
  self:ResetDefaultWeather()
  if self.isActive then
    self:RandomNewWeather()
    self:TransToHomeEffect()
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

OasisWeatherCtrl.SetOasisWeatherSetting = function(self, effectQuality)
  -- function num : 0_1 , upvalues : _ENV, cs_OasisWeatherController
  self._effectQuality = effectQuality
  if IsNull(self.oasisWeatherController) then
    self.oasisWeatherController = cs_OasisWeatherController.Instance
  end
  if IsNull(self.oasisWeatherController) then
    return 
  end
  if effectQuality == 0 then
    (self.oasisWeatherController):SetMaxSnowParticleCount(0)
    ;
    (self.oasisWeatherController):SetMaxRainBoxCount(0)
  else
    if effectQuality == 1 then
      (self.oasisWeatherController):SetMaxSnowParticleCount(1000)
      ;
      (self.oasisWeatherController):SetMaxRainBoxCount(3)
    else
      if effectQuality == 2 then
        (self.oasisWeatherController):SetMaxSnowParticleCount(2000)
        ;
        (self.oasisWeatherController):SetMaxRainBoxCount(5)
      end
    end
  end
end

OasisWeatherCtrl.GenerateweatherList = function(self, weatherConfigData)
  -- function num : 0_2 , upvalues : _ENV, cs_WeatherConfig
  self.weatherList = {}
  self.totalWeight = 0
  for _,weatherData in pairs(weatherConfigData) do
    local weather = {}
    weather.weight = weatherData.weight
    self.totalWeight = self.totalWeight + weather.weight
    local weatherConfig = cs_WeatherConfig()
    weatherConfig.transDuration = weatherData.trans_duration
    weatherConfig.weatherDuration = weatherData.weather_duration
    weatherConfig.rainIntensity = weatherData.rain_intensity * 0.01
    weatherConfig.wettingIntensity = weatherData.wetting_intensity * 0.01
    weatherConfig.snowIntensity = weatherData.snow_intensity * 0.01
    weatherConfig.accumulatedSnowIntensity = weatherData.accumulated_snow_intensity * 0.01
    weatherConfig.windIntensity = weatherData.wind_intensity * 0.01
    weatherConfig.lightningIntensity = weatherData.lightning_intensity * 0.01
    weather.weatherConfig = weatherConfig
    weather.weatherData = weatherData
    ;
    (table.insert)(self.weatherList, weather)
  end
end

OasisWeatherCtrl.RandomNewWeather = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_time
  if not self.isActive then
    return 
  end
  local newRandomWeather = nil
  if self:GetCurrentWeather() == nil or (self:GetCurrentWeather()).weatherData == nil then
    newRandomWeather = self:GetRandomWeather()
  end
  if newRandomWeather == nil then
    local lastChangeWeatherTimeStamp = (PlayerDataCenter.cacheSaveData):GetLastChangeWeatherTimeStamp()
    local isWeatherEnd = ((self:GetCurrentWeather()).weatherData).weather_duration < cs_time.time - lastChangeWeatherTimeStamp
    if isWeatherEnd then
      newRandomWeather = self:GetRandomWeather()
      ;
      (PlayerDataCenter.cacheSaveData):SetLastChangeWeatherTimeStamp(cs_time.time)
    else
      newRandomWeather = self:GetCurrentWeather()
    end
  end
  if newRandomWeather == nil then
    return 
  end
  self:SetEffect(newRandomWeather.weatherData)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

OasisWeatherCtrl.StopWeatherEffect = function(self)
  -- function num : 0_4
  self:_StopAmbienceAudio()
end

OasisWeatherCtrl.GetCurrentWeather = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local weatherIndex = (PlayerDataCenter.cacheSaveData):GetLastWeatherIndex()
  if weatherIndex ~= nil then
    return (self.weatherList)[weatherIndex]
  end
end

OasisWeatherCtrl.GetRandomWeather = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local weight = (math.random)(self.totalWeight)
  local curWeight = 0
  for i = 1, #self.weatherList do
    curWeight = curWeight + ((self.weatherList)[i]).weight
    if weight <= curWeight then
      (PlayerDataCenter.cacheSaveData):SetLastWeatherIndex(i)
      return self:GetCurrentWeather()
    end
  end
end

OasisWeatherCtrl.SetWeatherManager = function(self, weatherConfig, isForce)
  -- function num : 0_7 , upvalues : _ENV, cs_OasisWeatherController
  if not self.isInOasis and not isForce then
    return 
  end
  if IsNull(self.oasisWeatherController) then
    self.oasisWeatherController = cs_OasisWeatherController.Instance
  end
  if IsNull(self.oasisWeatherController) then
    return 
  end
  if IsNull((self.oasisWeatherController).weatherManagers) then
    return 
  end
  local weatherManagers = (self.oasisWeatherController).weatherManagers
  for i = 0, weatherManagers.Length - 1 do
    local weatherManager = weatherManagers[i]
    if not IsNull(weatherManager) and not IsNull(weatherConfig) then
      weatherManager:SetCurrentWeatherConfig(weatherConfig)
    end
  end
end

local homeRainEffectPrefabPaths = {"FX/Scene/tianqi/new/FX_003_Oasis_001_rain_low.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_rain_mid.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_rain_high.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_high_snow_low.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_high_snow_mid.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_high_snow_high.prefab"}
local oasisWeatherEffectPrefabPaths = {"FX/Scene/tianqi/new/FX_003_Oasis_001_rain_low-lvzhou.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_rain_mid-lvzhou.prefab", "FX/Scene/tianqi/new/FX_003_Oasis_001_rain_high-lvzhou.prefab"}
OasisWeatherCtrl.SetEffect = function(self, weatherData)
  -- function num : 0_8 , upvalues : homeRainEffectPrefabPaths, oasisWeatherEffectPrefabPaths
  if weatherData == nil then
    return 
  end
  self:_SetAmbienceAuido(weatherData)
  self:ReSetEffect()
  if weatherData.snow_intensity == 0 and weatherData.rain_intensity == 0 then
    return 
  end
  local effectId = 1
  if weatherData.snow_intensity > 75 then
    effectId = 6
  else
    if weatherData.snow_intensity > 50 then
      effectId = 5
    else
      effectId = 4
    end
  end
  if weatherData.rain_intensity > 75 then
    effectId = 3
  else
    if weatherData.rain_intensity > 50 then
      effectId = 2
    else
      effectId = 1
    end
  end
  if self.resLoader == nil then
    return 
  end
  local homeWeatherEffectPath = homeRainEffectPrefabPaths[effectId]
  if homeWeatherEffectPath ~= nil then
    (self.resLoader):LoadABAssetAsync(homeWeatherEffectPath, function(prefab)
    -- function num : 0_8_0 , upvalues : self
    if prefab == nil then
      return 
    end
    self.homeRainEffect = prefab:Instantiate((self.mainCamera).transform)
  end
)
  end
  local oasisRainEffectPrefabPath = oasisWeatherEffectPrefabPaths[effectId]
  if oasisRainEffectPrefabPath then
    (self.resLoader):LoadABAssetAsync(oasisRainEffectPrefabPath, function(prefab)
    -- function num : 0_8_1 , upvalues : self
    if prefab == nil then
      return 
    end
    self.oasisRainEffect = prefab:Instantiate((self.mainCamera).transform)
  end
)
  end
  self:SetSkyProParam(effectId)
end

OasisWeatherCtrl._SetAmbienceAuido = function(self, oasisWeatherCfg)
  -- function num : 0_9 , upvalues : _ENV
  if oasisWeatherCfg.amb_audio_id == 0 or self._effectQuality < 2 then
    self:_StopAmbienceAudio()
    return 
  end
  if self._ambAuId ~= oasisWeatherCfg.amb_audio_id then
    self:_StopAmbienceAudio()
    self._ambAuId = oasisWeatherCfg.amb_audio_id
    self._ambAuBack = AudioManager:PlayAudioById(oasisWeatherCfg.amb_audio_id)
  end
  if not (string.IsNullOrEmpty)(oasisWeatherCfg.audio_aisac_control) then
    local audioCfg = AudioManager:GetAudioCfg(self._ambAuId)
    if audioCfg ~= nil then
      AudioManager:SetSourceAisacControl(audioCfg.Type, oasisWeatherCfg.audio_aisac_control, oasisWeatherCfg.audio_aisac_value)
    end
  end
end

OasisWeatherCtrl._StopAmbienceAudio = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._ambAuBack ~= nil then
    AudioManager:StopAudioByBack(self._ambAuBack)
  end
  self._ambAuBack = nil
  self._ambAuId = nil
end

local skyCloudMatPaths = {"FX/Scene/tianqi/new/uSkyPro Clouds 2D_rain_low.mat", "FX/Scene/tianqi/new/uSkyPro Clouds 2D_rain_mid.mat", "FX/Scene/tianqi/new/uSkyPro Clouds 2D_rain_high.mat"}
OasisWeatherCtrl.SetSkyProParam = function(self, effectId)
  -- function num : 0_11 , upvalues : _ENV, skyCloudMatPaths
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if not IsNull(self.uskyPro) then
    (self.uskyPro).StarIntensity = 0
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.uskyPro).OuterSpaceIntensity = 0
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.uskyPro).SunSize = 0
  end
  local skyCloudMatPath = skyCloudMatPaths[effectId]
  if not IsNull(self.cloud2d) and self.resLoader ~= nil then
    (self.resLoader):LoadABAssetAsync(skyCloudMatPath, function(material)
    -- function num : 0_11_0 , upvalues : self, _ENV
    if material == nil then
      return 
    end
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.cloud2d).Clouds2DMaterial = ((CS.UnityEngine).Material)(material)
  end
)
  end
end

OasisWeatherCtrl.ReSetEffect = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if not IsNull(self.homeRainEffect) then
    DestroyUnityObject((self.homeRainEffect).gameObject)
  end
  if not IsNull(self.oasisRainEffect) then
    DestroyUnityObject((self.oasisRainEffect).gameObject)
  end
end

OasisWeatherCtrl.ResetDefaultWeather = function(self)
  -- function num : 0_13
  self:SetWeatherManager(self.defaultWeatherConfig, true)
  self:ReSetEffect()
end

OasisWeatherCtrl.TransEffect = function(self, isInOasis)
  -- function num : 0_14 , upvalues : _ENV
  if not IsNull(self.homeRainEffect) then
    ((self.homeRainEffect).gameObject):SetActive(not isInOasis)
  end
  if not IsNull(self.oasisRainEffect) then
    ((self.oasisRainEffect).gameObject):SetActive(isInOasis)
  end
end

OasisWeatherCtrl.TransToOasisEffect = function(self)
  -- function num : 0_15
  if self.isActive then
    self:TransEffect(true)
    if self:GetCurrentWeather() ~= nil then
      self:SetWeatherManager((self:GetCurrentWeather()).weatherConfig)
    end
  end
end

OasisWeatherCtrl.TransToHomeEffect = function(self)
  -- function num : 0_16
  self:TransEffect(false)
  self:SetWeatherManager(self.defaultWeatherConfig, true)
end

OasisWeatherCtrl.OnEnterOasis = function(self)
  -- function num : 0_17 , upvalues : _ENV
  self.isInOasis = true
  self:TransToOasisEffect()
  local cloud = ((CS.SkyController).Instance).clouds
  local material = cloud.Clouds2DMaterial
end

OasisWeatherCtrl.OnExitOasis = function(self)
  -- function num : 0_18
  self.isInOasis = false
  self:TransToHomeEffect()
end

OasisWeatherCtrl.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV
  self:_StopAmbienceAudio()
  self:ResetDefaultWeather()
  self.isInOasis = false
  self.defaultWeatherConfig = nil
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
  end
  self.resLoader = nil
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  if not IsNull(self.cloud2d) and isEditorMode then
    (self.cloud2d).Clouds2DMaterial = nil
  end
end

return OasisWeatherCtrl

