-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroInfoVoiceNode = class("UINHeroInfoVoiceNode", UIBaseNode)
local base = UIBaseNode
local UISkinVoiceISelectItem = require("Game.Hero.NewUI.HeroInfo.UISkinVoiceISelectItem")
local UINHeroInfoVoiceNodeItem = require("Game.Hero.NewUI.HeroInfo.UINHeroInfoVoiceNodeItem")
local defaultSkinVoiceName = ConfigData:GetTipContent(16002)
UINHeroInfoVoiceNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroInfoVoiceNodeItem
  self.__playStoryVoice = BindCallback(self, self.PlayStoryVoice)
  self.defaultVoiceDatas = nil
  self.skinVoiceDatas = nil
  self.isOpenVoiceFilter = false
  self.hasSkinVoice = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).skinVoiceItem):SetActive(false)
  self.voiceItemPool = (UIItemPool.New)(UINHeroInfoVoiceNodeItem, (self.ui).friendShipItem)
  ;
  ((self.ui).friendShipItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchAudio, self, self.OnClickSwitchAudio)
end

UINHeroInfoVoiceNode.GetCurrentSelectVoiceSkinId = function(self)
  -- function num : 0_1
  return self.currentSelectVoiceSkinId
end

UINHeroInfoVoiceNode.SetCurrentSelectVoiceSkinId = function(self, newSkinId)
  -- function num : 0_2
  self.currentSelectVoiceSkinId = newSkinId
  return true
end

UINHeroInfoVoiceNode.InitUsefulData = function(self, heroData, HeroInfoTextUtil)
  -- function num : 0_3
  self.heroData = heroData
  self.defaultVoiceDatas = nil
  self.skinVoiceDatas = nil
  self:SetCurrentSelectVoiceSkinId(self:GetHeroId())
end

UINHeroInfoVoiceNode.GetVoiceDatas = function(self)
  -- function num : 0_4
  self:InitVoiceDatas()
  if not self.hasSkinVoice then
    return self.defaultVoiceDatas
  end
  if not self:IsSelectSkinVoiceFilter() then
    return self.defaultVoiceDatas
  end
  local skinId = self:GetCurrentSelectVoiceSkinId()
  return (self.skinVoiceDatas)[skinId]
end

UINHeroInfoVoiceNode.InitVoiceDatas = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local heroId = self:GetHeroId()
  local hasVoice = (ControllerManager:GetController(ControllerTypeId.Cv, true)):HasCv(heroId)
  do
    if self.defaultVoiceDatas == nil then
      local defaultVoiceCfgList = ConfigData.audio_voice
      self.defaultVoiceDatas = self:GenerateVoiceDatas(defaultVoiceCfgList, heroId, heroId, hasVoice, false)
    end
    if self:HasSkinVoice() and self.skinVoiceDatas == nil then
      self.skinVoiceDatas = {}
      local skinVoiceIdList = (ConfigData.audio_voice).skinVoice
      for skinId,voiceIdList in pairs(skinVoiceIdList) do
        local skinVOiceCfgList = {}
        for index,voiceId in ipairs(voiceIdList) do
          (table.insert)(skinVOiceCfgList, (ConfigData.audio_voice)[voiceId])
        end
        -- DECOMPILER ERROR at PC62: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.skinVoiceDatas)[skinId] = self:GenerateVoiceDatas(skinVOiceCfgList, heroId, skinId, hasVoice, true)
      end
    end
  end
end

UINHeroInfoVoiceNode.GenerateVoiceDatas = function(self, cfgList, heroId, skinId, hasVoice, needSkinVoice)
  -- function num : 0_6 , upvalues : _ENV
  local voiceDatas = {}
  for key,cfg in pairs(cfgList) do
    if cfg.exclusive_skin == nil or cfg.exclusive_skin == 0 then
      local isSkinVoice = cfg.is_show <= 0
      if isSkinVoice == needSkinVoice then
        local isNewVoice = not (self.heroData):IsAudioListed(cfg.is_show)
        local isUnlock = ((CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2))
        local unlockInfo = nil
        if not isUnlock then
          unlockInfo = (CheckCondition.GetUnlockInfoLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
        end
        ;
        (table.insert)(voiceDatas, {heroData = self.heroData, isNewVoice = isNewVoice, isUnlock = isUnlock, cfg = cfg, unlockInfo = unlockInfo, heroId = heroId, skinId = skinId, hasVoice = hasVoice})
      end
      -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_THEN_STMT

      -- DECOMPILER ERROR at PC53: LeaveBlock: unexpected jumping out IF_STMT

    end
  end
  do return voiceDatas end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINHeroInfoVoiceNode.InitHeroInfoNode = function(self)
  -- function num : 0_7
  self:InitVoiceDatas()
  self:RefreshVoiceSkinData()
  self:RefreshBtnSwitchVoiceState()
  local currentSelectVoiceSkinName = self:GetCurrentVoiceSkinName()
  self:RefreshVoiceSkinBtnName(currentSelectVoiceSkinName)
  self:SortAllVoiceItem()
  self:RefreshAllVoiceItem()
end

UINHeroInfoVoiceNode.GetHeroId = function(self)
  -- function num : 0_8
  if self.heroData ~= nil then
    return (self.heroData).dataId
  end
end

UINHeroInfoVoiceNode.HasSkinVoice = function(self)
  -- function num : 0_9
  return self.hasSkinVoice
end

UINHeroInfoVoiceNode.RefreshVoiceSkinData = function(self)
  -- function num : 0_10 , upvalues : _ENV, defaultSkinVoiceName
  local heroId = self:GetHeroId()
  self.hasSkinVoice = ((ConfigData.audio_voice).heroVoiceSkinIdList)[heroId] ~= nil
  self.isOpenVoiceFilter = false
  if not self.hasSkinVoice then
    return 
  end
  self.voiceSkinIdList = ((ConfigData.audio_voice).heroVoiceSkinIdList)[heroId]
  self.voiceSkinNameList = {}
  ;
  (table.insert)(self.voiceSkinNameList, defaultSkinVoiceName)
  for i = 2, #self.voiceSkinIdList do
    local skinId = (self.voiceSkinIdList)[i]
    local name = (LanguageUtil.GetLocaleText)(((ConfigData.skin)[skinId]).name)
    ;
    (table.insert)(self.voiceSkinNameList, name)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINHeroInfoVoiceNode.OnClickSwitchAudio = function(self)
  -- function num : 0_11
  local hasSkinVoice = self:HasSkinVoice()
  if not hasSkinVoice then
    return 
  end
  self.isOpenVoiceFilter = not self.isOpenVoiceFilter
  self:StopPlayVoice()
  self:ActiveSwitchVoiceList(self.isOpenVoiceFilter)
  self:RefreshAllVoiceItem()
end

UINHeroInfoVoiceNode.ActiveSwitchVoiceList = function(self, active)
  -- function num : 0_12 , upvalues : _ENV
  ((self.ui).switchSkinVoiceList):SetActive(active)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  if not active or not (Vector3.New)(0, 0, 90) then
    ((self.ui).img_Arrow).localEulerAngles = (Vector3.New)(180, 0, 90)
    if active then
      self:RefreshSkinVoiceList(self.voiceSkinNameList, self.voiceSkinIdList)
    else
      self:HideAllSkinVoiceSelectItem()
    end
  end
end

UINHeroInfoVoiceNode.RefreshSkinVoiceList = function(self, skinNameList, skinIdList)
  -- function num : 0_13 , upvalues : _ENV, UISkinVoiceISelectItem
  for index,value in ipairs(skinNameList) do
    local skinName = skinNameList[index]
    local skinId = skinIdList[index]
    if self.skinVoiceSelectItemPool == nil then
      self.skinVoiceSelectItemPool = (UIItemPool.New)(UISkinVoiceISelectItem, (self.ui).skinVoiceItem)
    end
    local skinVoiceSelectItem = (self.skinVoiceSelectItemPool):GetOne()
    local __SelectSkinVoice = function(skinId, index)
    -- function num : 0_13_0 , upvalues : self
    self:SelectSkinVoice(skinId, index)
  end

    skinVoiceSelectItem:InitVoiceSelectItem(skinName, skinId, index, __SelectSkinVoice)
  end
end

UINHeroInfoVoiceNode.SelectSkinVoice = function(self, skinId, index)
  -- function num : 0_14
  self:SetCurrentSelectVoiceSkinId(skinId)
  self.isOpenVoiceFilter = false
  local name = (self.voiceSkinNameList)[index]
  self:StopPlayVoice()
  self:RefreshVoiceSkinBtnName(name)
  self:ActiveSwitchVoiceList(false)
  self:InitHeroInfoNode()
end

UINHeroInfoVoiceNode.HideAllSkinVoiceSelectItem = function(self)
  -- function num : 0_15
  if self.skinVoiceSelectItemPool ~= nil then
    (self.skinVoiceSelectItemPool):HideAll()
  end
end

UINHeroInfoVoiceNode.GetCurrentVoiceSkinName = function(self)
  -- function num : 0_16 , upvalues : defaultSkinVoiceName
  if self.voiceSkinNameList == nil then
    return defaultSkinVoiceName
  end
  if not self.hasSkinVoice then
    return defaultSkinVoiceName
  end
  if not self:IsSelectSkinVoiceFilter() then
    return defaultSkinVoiceName
  end
  local currentSelectVoiceSkinId = self:GetCurrentSelectVoiceSkinId()
  local index = self:GetSkinVoiceIndexBySkinId(currentSelectVoiceSkinId)
  return (self.voiceSkinNameList)[index]
end

UINHeroInfoVoiceNode.GetSkinVoiceIndexBySkinId = function(self, skinId)
  -- function num : 0_17 , upvalues : _ENV
  if self.voiceSkinIdList == nil then
    return 1
  end
  for index,value in ipairs(self.voiceSkinIdList) do
    if (self.voiceSkinIdList)[index] == skinId then
      return index
    end
  end
  return 1
end

UINHeroInfoVoiceNode.IsSelectSkinVoiceFilter = function(self)
  -- function num : 0_18
  if not self.hasSkinVoice then
    return false
  end
  local currentSelectVoiceSkinId = self:GetCurrentSelectVoiceSkinId()
  if currentSelectVoiceSkinId ~= nil and currentSelectVoiceSkinId ~= self:GetHeroId() then
    return true
  end
  return false
end

UINHeroInfoVoiceNode.RefreshVoiceSkinBtnName = function(self, name)
  -- function num : 0_19
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).text_SwitchAudio).text = name
end

UINHeroInfoVoiceNode.RefreshBtnSwitchVoiceState = function(self)
  -- function num : 0_20
  ((self.ui).btn_SwitchAudioParent):SetActive(self.hasSkinVoice)
  ;
  ((self.ui).switchSkinVoiceList):SetActive(self.isOpenVoiceFilter)
end

UINHeroInfoVoiceNode.SortAllVoiceItem = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local sortFunc = function(a, b)
    -- function num : 0_21_0
    do return (a.cfg).is_show < (b.cfg).is_show end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

  local voiceDatas = self:GetVoiceDatas()
  ;
  (table.sort)(voiceDatas, sortFunc)
end

UINHeroInfoVoiceNode.RefreshAllVoiceItem = function(self)
  -- function num : 0_22 , upvalues : _ENV
  (self.voiceItemPool):HideAll()
  if self.isOpenVoiceFilter then
    return 
  end
  local voiceDatas = self:GetVoiceDatas()
  for _,voiceData in ipairs(voiceDatas) do
    if (self.heroData).dataId == (voiceData.cfg).exclusive_hero or (voiceData.cfg).exclusive_hero == 0 then
      local item = (self.voiceItemPool):GetOne()
      item:InitHeroInfoNodeItem(voiceData, self.__playStoryVoice)
    end
  end
end

UINHeroInfoVoiceNode.PlayStoryVoice = function(self, heroId, skinId, voiceId, playerRateCallback, playOverCallback)
  -- function num : 0_23 , upvalues : _ENV
  local CVController = ControllerManager:GetController(ControllerTypeId.Cv, true)
  if self.isPlayingVoice and self.AudioPlayback ~= nil then
    AudioManager:StopAudioByBack(self.AudioPlayback)
    self.AudioPlayback = nil
    self:__HideVoiceWords()
    if self.playOverCallback ~= nil then
      (self.playOverCallback)()
    end
    TimerManager:StopTimer(self.playerRateTimerId)
    self.playerRateTimerId = nil
    if self.playerRateCallback ~= nil then
      (self.playerRateCallback)(0)
    end
  end
  if self.__isShowingCvTextWithoutVoice then
    (self.playerRateCallback)(0)
    self.__isShowingCvTextWithoutVoice = false
  end
  self.playOverCallback = playOverCallback
  self.playerRateCallback = playerRateCallback
  if not CVController:HasCv(heroId) then
    self.__isShowingCvTextWithoutVoice = true
    self:__ShowVoiceWords(CVController:GetCvText(heroId, voiceId), true)
    ;
    (self.playerRateCallback)(1)
    return 
  end
  self.isPlayingVoice = true
  if skinId == nil then
    skinId = self:GetCurrentSelectVoiceSkinId()
  end
  self:__ShowVoiceWords(CVController:GetCvText(heroId, voiceId, skinId))
  local _audioPlayback = function()
    -- function num : 0_23_0
  end

  self.AudioPlayback = CVController:PlayCv(heroId, voiceId, function()
    -- function num : 0_23_1 , upvalues : self, _ENV
    self.AudioPlayback = nil
    self.isPlayingVoice = false
    self:__HideVoiceWords()
    if self.playOverCallback ~= nil then
      (self.playOverCallback)()
    end
    TimerManager:StopTimer(self.playerRateTimerId)
    self.playerRateTimerId = nil
    if self.playerRateCallback ~= nil then
      (self.playerRateCallback)(0)
    end
  end
, nil, skinId)
  local sheetName, cueName = CVController:GetSheetNameAndCueName(heroId, voiceId, skinId)
  local RefreshPlayRate = function()
    -- function num : 0_23_2 , upvalues : self, _ENV, sheetName, cueName
    local curLength = 0
    local totalLength = 1
    if self.AudioPlayback ~= nil then
      totalLength = AudioManager:GetAudioLengthById(sheetName, cueName)
      curLength = AudioManager:GetAudioPlayedTime(self.AudioPlayback)
    end
    if self.playerRateCallback ~= nil then
      (self.playerRateCallback)(curLength / totalLength)
    end
  end

  RefreshPlayRate()
  self.playerRateTimerId = TimerManager:StartTimer(0.0167, function()
    -- function num : 0_23_3 , upvalues : RefreshPlayRate
    RefreshPlayRate()
  end
, self, false, false, false)
end

UINHeroInfoVoiceNode.__ShowVoiceWords = function(self, text, notNeedWave)
  -- function num : 0_24
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_VoiceDialog).text = text
  ;
  ((self.ui).obj_imgwave):SetActive(not notNeedWave)
  ;
  ((self.ui).obj_ani_VoiceIcon):SetActive(not notNeedWave)
  ;
  ((self.ui).voiceDialog):SetActive(true)
end

UINHeroInfoVoiceNode.__HideVoiceWords = function(self)
  -- function num : 0_25
  if self.ui == nil or (self.ui).voiceDialog == nil then
    return 
  end
  ;
  ((self.ui).voiceDialog):SetActive(false)
end

UINHeroInfoVoiceNode.StopPlayVoice = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if self.isPlayingVoice and self.AudioPlayback ~= nil then
    AudioManager:StopAudioByBack(self.AudioPlayback)
    self.AudioPlayback = nil
    self:__HideVoiceWords()
    if self.playOverCallback ~= nil then
      (self.playOverCallback)()
      self.playOverCallback = nil
    end
    TimerManager:StopTimer(self.playerRateTimerId)
    self.playerRateTimerId = nil
    if self.playerRateCallback ~= nil then
      (self.playerRateCallback)(0)
      self.playerRateCallback = nil
    end
  end
  if self.__isShowingCvTextWithoutVoice then
    self:__HideVoiceWords()
    ;
    (self.playerRateCallback)(0)
    self.__isShowingCvTextWithoutVoice = false
  end
end

UINHeroInfoVoiceNode.OnHide = function(self)
  -- function num : 0_27 , upvalues : base
  if self.__isShowingCvTextWithoutVoice then
    self:__HideVoiceWords()
    ;
    (self.playerRateCallback)(0)
    self.__isShowingCvTextWithoutVoice = false
  end
  if self.skinVoiceSelectItemPool ~= nil then
    (self.skinVoiceSelectItemPool):HideAll()
  end
  ;
  (base.OnHide)(self)
end

UINHeroInfoVoiceNode.OnTcpLogOut_HeroInfoNode = function(self)
  -- function num : 0_28 , upvalues : _ENV
  TimerManager:StopTimer(self.playerRateTimerId)
  self.playerRateTimerId = nil
end

UINHeroInfoVoiceNode.OnDelete = function(self)
  -- function num : 0_29 , upvalues : _ENV, base
  TimerManager:StopTimer(self.playerRateTimerId)
  self.playerRateTimerId = nil
  self:SetCurrentSelectVoiceSkinId(nil)
  if self.skinVoiceSelectItemPool ~= nil then
    (self.skinVoiceSelectItemPool):DeleteAll()
    self.skinVoiceSelectItemPool = nil
  end
  if self.voiceItemPool ~= nil then
    (self.voiceItemPool):DeleteAll()
    self.voiceItemPool = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINHeroInfoVoiceNode

