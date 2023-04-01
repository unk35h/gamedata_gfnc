-- params : ...
-- function num : 0 , upvalues : _ENV
local SettingController = class("SettingController", ControllerBase)
local rapidjson = require("rapidjson")
local cs_RenderManager = (CS.RenderManager).Instance
local cs_QualitySettings = (CS.UnityEngine).QualitySettings
SettingController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  if self.__OnSceneUnload ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.OnSceneUnload, self.__OnSceneUnload)
  end
  self.__OnSceneUnload = BindCallback(self, self.OnSceneUnload)
  MsgCenter:AddListener(eMsgEventId.OnSceneUnload, self.__OnSceneUnload)
end

SettingController.InitSettingData = function(self)
  -- function num : 0_1 , upvalues : _ENV, cs_RenderManager
  PersistentManager:LoadAndDecodeData((PersistentConfig.ePackage).SystemData)
  local audioSetting = self:GetSettingAudioData()
  local cs_AudioManager = (CS.AudioManager).Instance
  for index = 1, AudioManager.AudioTypeCount do
    cs_AudioManager:SetVolume(index, (audioSetting.volumes)[index])
    ;
    ((CS.AudioManager).Instance):SetMute(index, audioSetting.globalMute)
  end
  cs_RenderManager:ResetRenderSetting()
  local systemSaveData = self:GetSystemSaveData()
  self:SetResolutionIndex(systemSaveData:GetDisplaySettingValue("resolution"))
  self:SetTextureLimit(systemSaveData:GetDisplaySettingValue("texture_limit"))
  self:SetFrameRateIndex(systemSaveData:GetDisplaySettingValue("frame_rate"))
  self:SetDynShadowIndex(systemSaveData:GetDisplaySettingValue("dyn_shadow"))
  self:SetAntiAliasingIndex(systemSaveData:GetDisplaySettingValue("anti_aliasing"))
  self:SetEffectQuality(systemSaveData:GetDisplaySettingValue("effect_quality"))
  self:SetModelQuality(systemSaveData:GetDisplaySettingValue("model_quality"))
  self:SetOutlineIndex(systemSaveData:GetDisplaySettingValue("outline"))
  self:SetPostEffect(systemSaveData:GetDisplaySettingValue("post_effect"))
  self:SetOpenLittleManIndex(systemSaveData:GetDisplaySettingValue("open_little_man"))
  self:SetOpenWeatherIndex(systemSaveData:GetDisplaySettingValue("open_weather"))
  self:RefreshSettingReddot()
end

SettingController.GetSystemSaveData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  return PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)
end

SettingController.GetSettingAudioData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)):GetAudioData()
end

SettingController.SetSettingAudioVolume = function(self, index, value)
  -- function num : 0_4
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetAudioDataVolume(index, value)
end

SettingController.SetSettingAudioMute = function(self, index, value)
  -- function num : 0_5
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetAudioDataMute(index, value)
end

SettingController.SetSettingAudioGlobalMute = function(self, value)
  -- function num : 0_6
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetAudioDataGlobalMute(value)
end

SettingController.GetSettingNoticeSwitch = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetNoticeSwitchOff()
end

SettingController.GetPerformanceLevel = function(self)
  -- function num : 0_8
  local systemSaveData = self:GetSystemSaveData()
  return systemSaveData:GetDisplayPerformanceLevelValue()
end

SettingController.SetPerformanceLevel = function(self, index)
  -- function num : 0_9
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplayPerformanceLevelValue(index)
end

SettingController.ForceSetToCurrentPerformanceLevel = function(self)
  -- function num : 0_10
  if self:GetPerformanceLevel() == 0 then
    return 
  end
  local systemSaveData = self:GetSystemSaveData()
  local resolutionRatioIndex = systemSaveData:GetDisplaySettingValue("resolution")
  self:__RealChangeResolutionRatio(resolutionRatioIndex)
  local textureLimit = systemSaveData:GetDisplaySettingValue("texture_limit")
  self:__RealChangeTextureLimit(textureLimit)
  local effectQuality = systemSaveData:GetDisplaySettingValue("effect_quality")
  self:__RealChangePostEffectLevel(effectQuality)
  local modelQuality = systemSaveData:GetDisplaySettingValue("model_quality")
  self:__RealChangeModelQualityLevel(modelQuality)
  local postEffectLevel = systemSaveData:GetDisplaySettingValue("post_effect")
  self:__RealChangePostEffectLevel(postEffectLevel)
  local frameRateIndex = systemSaveData:GetDisplaySettingValue("frame_rate")
  self:__RealChangeFrameRate(frameRateIndex)
  local dynShadowIndex = systemSaveData:GetDisplaySettingValue("dyn_shadow")
  self:__RealChangeDynShadow(dynShadowIndex)
  local antiAliasingIndex = systemSaveData:GetDisplaySettingValue("anti_aliasing")
  self:__RealChangeAntiAliasing(antiAliasingIndex)
  local outlineIndex = systemSaveData:GetDisplaySettingValue("outline")
  self:__RealChangeOutlineActive(outlineIndex)
  local openLittleManIndex = systemSaveData:GetDisplaySettingValue("open_little_man")
  self:__RealChangeOpenLittleMan(openLittleManIndex)
  local openWeatherIndex = systemSaveData:GetDisplaySettingValue("open_weather")
  self:__RealChangeOpenWeather(openWeatherIndex)
end

SettingController.SetResolutionIndex = function(self, index)
  -- function num : 0_11
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("resolution", index)
  self.needChangeResolution = true
end

SettingController.SetTextureLimit = function(self, limit)
  -- function num : 0_12
  self:__RealChangeTextureLimit(limit)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("texture_limit", limit)
end

SettingController.SetEffectQuality = function(self, quality)
  -- function num : 0_13
  self:__RealChangeEffectQualityLevel(quality)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("effect_quality", quality)
end

SettingController.SetModelQuality = function(self, quality)
  -- function num : 0_14
  self:__RealChangeModelQualityLevel(quality)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("model_quality", quality)
end

SettingController.SetPostEffect = function(self, quality)
  -- function num : 0_15
  self:__RealChangePostEffectLevel(quality)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("post_effect", quality)
end

SettingController.SetFrameRateIndex = function(self, index)
  -- function num : 0_16
  self:__RealChangeFrameRate(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("frame_rate", index)
end

SettingController.SetDynShadowIndex = function(self, index)
  -- function num : 0_17
  self:__RealChangeDynShadow(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("dyn_shadow", index)
end

SettingController.SetAntiAliasingIndex = function(self, index)
  -- function num : 0_18
  self:__RealChangeAntiAliasing(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("anti_aliasing", index)
end

SettingController.SetOutlineIndex = function(self, index)
  -- function num : 0_19
  self:__RealChangeOutlineActive(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("outline", index)
end

SettingController.SetOpenLittleManIndex = function(self, index)
  -- function num : 0_20
  self:__RealChangeOpenLittleMan(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("open_little_man", index)
end

SettingController.SetOpenWeatherIndex = function(self, index)
  -- function num : 0_21
  self:__RealChangeOpenWeather(index)
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetDisplaySettingValue("open_weather", index)
end

SettingController.__RealChangeResolutionRatio = function(self, index)
  -- function num : 0_22 , upvalues : _ENV, cs_RenderManager
  local cs_screen_height = ((CS.UnityEngine).Screen).height
  if cs_screen_height <= 720 then
    if index == 0 then
      cs_RenderManager:SetResolutionRatio(1)
    else
      if index == 1 then
        cs_RenderManager:SetResolutionRatio(0.833333)
      else
        if index == 2 then
          cs_RenderManager:SetResolutionRatio(0.75)
        else
          if index == 3 then
            cs_RenderManager:SetResolutionRatio(0.666666)
          end
        end
      end
    end
  else
    if cs_screen_height <= 1080 then
      if index == 0 then
        cs_RenderManager:SetResolutionRatio(1)
      else
        if index == 1 then
          cs_RenderManager:SetResolutionRatio(0.833333)
        else
          if index == 2 then
            cs_RenderManager:SetResolutionRatio(0.666666)
          else
            if index == 3 then
              cs_RenderManager:SetResolutionRatio(0.444444)
            end
          end
        end
      end
    else
      if cs_screen_height <= 1300 then
        if index == 0 then
          cs_RenderManager:SetResolutionRatio(1)
        else
          if index == 1 then
            cs_RenderManager:SetResolutionRatio(0.75)
          else
            if index == 2 then
              cs_RenderManager:SetResolutionRatio(0.5)
            else
              if index == 3 then
                cs_RenderManager:SetResolutionRatio(0.4)
              end
            end
          end
        end
      else
        if index == 0 then
          cs_RenderManager:SetResolutionRatio(1)
        else
          if index == 1 then
            cs_RenderManager:SetResolutionRatio(0.65)
          else
            if index == 2 then
              cs_RenderManager:SetResolutionRatio(0.5)
            else
              if index == 3 then
                cs_RenderManager:SetResolutionRatio(0.333333)
              end
            end
          end
        end
      end
    end
  end
end

SettingController.__RealChangeTextureLimit = function(self, limit)
  -- function num : 0_23 , upvalues : cs_RenderManager
  cs_RenderManager:SetTextureLimit(limit)
end

SettingController.__RealChangeEffectQualityLevel = function(self, quality)
  -- function num : 0_24 , upvalues : cs_RenderManager
  cs_RenderManager:SetEffectQualityLevel(quality)
end

SettingController.__RealChangeModelQualityLevel = function(self, quality)
  -- function num : 0_25 , upvalues : cs_RenderManager
  cs_RenderManager:SetModelQualityLevel(quality)
end

SettingController.__RealChangePostEffectLevel = function(self, quality)
  -- function num : 0_26 , upvalues : cs_RenderManager
  cs_RenderManager:SetPostEffectLevel(quality)
end

SettingController.__RealChangeFrameRate = function(self, index)
  -- function num : 0_27 , upvalues : cs_RenderManager
  if index == 0 then
    cs_RenderManager:SetFrameRate(30)
  else
    if index == 1 then
      cs_RenderManager:SetFrameRate(60)
    else
      if index == 2 then
        cs_RenderManager:SetFrameRate(120)
      end
    end
  end
end

SettingController.__RealChangeDynShadow = function(self, index)
  -- function num : 0_28 , upvalues : cs_RenderManager
  if index == 0 then
    cs_RenderManager:SetDynShadow(false)
  else
    if index > 0 then
      cs_RenderManager:SetDynShadow(true)
    end
  end
end

SettingController.__RealChangeAntiAliasing = function(self, index)
  -- function num : 0_29 , upvalues : cs_QualitySettings
  cs_QualitySettings.antiAliasing = index * 4
end

SettingController.__RealChangeOutlineActive = function(self, index)
  -- function num : 0_30 , upvalues : cs_RenderManager
  if index == 0 then
    cs_RenderManager:SetOutlineActive(false)
  else
    if index > 0 then
      cs_RenderManager:SetOutlineActive(true)
    end
  end
end

SettingController.__RealChangeOpenLittleMan = function(self, index)
  -- function num : 0_31 , upvalues : _ENV
  print("OpenLittleMan " .. tostring(index))
end

SettingController.__RealChangeOpenWeather = function(self, index)
  -- function num : 0_32 , upvalues : _ENV
  print("OpenWeather " .. tostring(index))
end

SettingController.SetNoticeSwitchOff = function(self, noticeId, value)
  -- function num : 0_33 , upvalues : _ENV
  (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetNoticeSwitchOff(noticeId, value)
end

SettingController.UserLogout = function(self)
  -- function num : 0_34 , upvalues : _ENV
  (NetworkManager.luaNetworkAgent):LogoutToLogin(true)
end

SettingController.OpenUserCenter = function(self)
  -- function num : 0_35 , upvalues : _ENV
  ((CS.MicaSDKManager).Instance):OpenUserCenter()
end

SettingController.EnterCustomService = function(self)
  -- function num : 0_36 , upvalues : _ENV
  ((CS.MicaSDKManager).Instance):EnterCustomService()
end

SettingController.BiliCloseAccount = function(self)
  -- function num : 0_37 , upvalues : _ENV, rapidjson
  local timeDate = TimeUtil:TimestampToDate(((PlayerDataCenter.inforData):GetCreateTime()), nil, true)
  local creatTimeStr = timeDate.year .. "." .. timeDate.month .. "." .. timeDate.day
  local paramTab = {role_name = PlayerDataCenter.playerName, server_name = "bilibili", level = tostring((PlayerDataCenter.playerLevel).level), time = creatTimeStr}
  local tab = {}
  ;
  (table.insert)(tab, paramTab)
  local paramJson = (rapidjson.encode)(tab)
  ;
  ((CS.MicaSDKManager).Instance):BiliCloseAccount(paramJson)
end

SettingController.GetIsShowDetailDescribe = function(self, eDescTypeId)
  -- function num : 0_38 , upvalues : _ENV
  return (PlayerDataCenter.gameSettingData):GetGSIsShowDetailDescribe(eDescTypeId)
end

SettingController.SetShowDetailDescribe = function(self, eDescTypeId, bool)
  -- function num : 0_39 , upvalues : _ENV
  (PlayerDataCenter.gameSettingData):SetGSDescribe(eDescTypeId, bool)
end

SettingController.TryReqSaveGameSettingData = function(self)
  -- function num : 0_40 , upvalues : _ENV
  local isDirty, recordDic = (PlayerDataCenter.gameSettingData):IsGSDataDirty()
  if isDirty then
    (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_Client_Record_Set(recordDic)
    ;
    (PlayerDataCenter.gameSettingData):ClearGSDataDirty()
  end
end

SettingController.GetGSMultSettingIndex = function(self, eDescTypeId)
  -- function num : 0_41
  local systemSaveData = self:GetSystemSaveData()
  return systemSaveData:GetMultSettingIndex(eDescTypeId)
end

SettingController.SetGSMultSettingIndex = function(self, eDescTypeId, index)
  -- function num : 0_42
  local systemSaveData = self:GetSystemSaveData()
  return systemSaveData:SetMultSettingIndex(eDescTypeId, index)
end

SettingController.IsTodayPlayedUltSkillAnimi = function(self, skillId)
  -- function num : 0_43
  local systemSaveData = self:GetSystemSaveData()
  return systemSaveData:GetIsTodayPlayedUltSkillAnimi(skillId)
end

SettingController.SetIsTodayPlayedUltSkillAnimi = function(self, skillId, bool)
  -- function num : 0_44
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetIsTodayPlayedUltSkillAnimi(skillId, bool)
end

SettingController.CleanIsTodayPlayedUltSkillAnimi = function(self)
  -- function num : 0_45
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:CleanIsTodayPlayedUltSkillAnimi()
end

SettingController.OnSceneUnload = function(self)
  -- function num : 0_46
  if self.needChangeResolution == true then
    local systemSaveData = self:GetSystemSaveData()
    local index = systemSaveData:GetDisplaySettingValue("resolution")
    self:__RealChangeResolutionRatio(index)
    self.needChangeResolution = false
  end
end

SettingController.RefreshSettingReddot = function(self)
  -- function num : 0_47 , upvalues : _ENV
  local isOk, gameSettingNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Setting, RedDotStaticTypeId.GameSetting)
  if not isOk then
    return 
  end
  local systemSaveData = self:GetSystemSaveData()
  if systemSaveData:GetGameSettingIsHaveReddot() then
    gameSettingNode:SetRedDotCount(1)
  else
    gameSettingNode:SetRedDotCount(0)
  end
end

SettingController.SetGameSettingReddotLooked = function(self)
  -- function num : 0_48
  local systemSaveData = self:GetSystemSaveData()
  systemSaveData:SetGameSettingIsHaveReddot(nil)
  self:RefreshSettingReddot()
end

SettingController.OnDelete = function(self)
  -- function num : 0_49 , upvalues : _ENV
  if self.__OnSceneUnload ~= nil then
    MsgCenter:RemoveListener(eMsgEventId.OnSceneUnload, self.__OnSceneUnload)
  end
end

return SettingController

