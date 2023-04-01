-- params : ...
-- function num : 0 , upvalues : _ENV
local CharacterVoiceController = class("AvgController", ControllerBase)
local base = ControllerBase
local CS_LanguageGlobal = CS.LanguageGlobal
local SheetMaxNum = 10
local CommanderNameStrTag = "<cmdr>"
CharacterVoiceController.OnInit = function(self)
  -- function num : 0_0
  self.sheetDic = {}
  self.textCfgDic = {}
end

CharacterVoiceController.HasCv = function(self, heroId)
  -- function num : 0_1 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg ~= nil then
    return heroCfg.hero_audio_res
  end
  return false
end

CharacterVoiceController.PlayCv = function(self, heroId, voiceId, completeEvent, OpenMouseListen, skinId)
  -- function num : 0_2 , upvalues : SheetMaxNum, _ENV
  local sheetName, cueName = self:GetSheetNameAndCueName(heroId, voiceId, skinId)
  if sheetName == nil then
    return 
  end
  if ((self.sheetDic)[heroId] == nil or ((self.sheetDic)[heroId])[sheetName] == nil) and SheetMaxNum <= self:__GetSheetCount() then
    for heroId,v in pairs(self.sheetDic) do
      if (self.sheetDic)[heroId] ~= nil then
        self:RemoveCvCueSheet(heroId)
      end
      do break end
    end
  end
  do
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R8 in 'UnsetPending'

    if (self.sheetDic)[heroId] == nil then
      (self.sheetDic)[heroId] = {}
    end
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.sheetDic)[heroId])[sheetName] = sheetName
    self.lastPlayedHeroId = heroId
    if OpenMouseListen == true then
      return AudioManager:PlayAudio(cueName, sheetName, eAudioSourceType.Live2DSource, completeEvent)
    else
      return AudioManager:PlayAudio(cueName, sheetName, eAudioSourceType.VoiceSource, completeEvent)
    end
  end
end

CharacterVoiceController.__GetSheetCount = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local count = 0
  for heroId,table in pairs(self.sheetDic) do
    for key,sheetName in pairs(table) do
      count = count + 1
    end
  end
  return count
end

CharacterVoiceController.RemoveCvCueSheet = function(self, heroId)
  -- function num : 0_4 , upvalues : _ENV
  local sheetNameTable = (self.sheetDic)[heroId]
  if sheetNameTable ~= nil then
    for index,sheetName in pairs(sheetNameTable) do
      AudioManager:RemoveCueSheet(sheetName)
    end
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.sheetDic)[heroId] = nil
  end
end

CharacterVoiceController.RemoveCvAllCueSheet = function(self, removeLastCvHero)
  -- function num : 0_5 , upvalues : _ENV
  local lastsheetNameTable = nil
  for heroId,sheetNameTable in pairs(self.sheetDic) do
    if not removeLastCvHero and heroId == self.lastPlayedHeroId then
      lastsheetNameTable = sheetNameTable
    else
      for index,sheetName in pairs(sheetNameTable) do
        AudioManager:RemoveCueSheet(sheetName)
      end
    end
  end
  self.sheetDic = {}
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  if not removeLastCvHero and self.lastPlayedHeroId ~= nil then
    (self.sheetDic)[self.lastPlayedHeroId] = lastsheetNameTable
  end
end

CharacterVoiceController.GetCvText = function(self, heroId, voiceId, skinId)
  -- function num : 0_6 , upvalues : CS_LanguageGlobal, _ENV, CommanderNameStrTag
  local heroCfg, resCfg, voiceCfg, skinCfg = self:GetVoiceInfo(heroId, voiceId, skinId)
  local lang = (CS_LanguageGlobal.GetLanguageStr)()
  local langPath = (self:GetTextConfigPath(skinCfg, resCfg, lang, voiceId))
  local textCfg = nil
  local textCfgTable = (self.textCfgDic)[heroId]
  if textCfgTable ~= nil then
    textCfg = textCfgTable[langPath]
  end
  do
    if textCfg == nil then
      local ok, err = pcall(function()
    -- function num : 0_6_0 , upvalues : textCfg, _ENV, langPath
    textCfg = require(langPath)
    textCfg.cvLangPath = langPath
    return true
  end
)
      if not ok then
        error("Can\'t get CvLanguage, path = " .. langPath .. ",\n" .. tostring(err))
        return 
      end
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R14 in 'UnsetPending'

      if (self.textCfgDic)[heroId] == nil then
        (self.textCfgDic)[heroId] = {}
      end
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R14 in 'UnsetPending'

      ;
      ((self.textCfgDic)[heroId])[langPath] = textCfg
    end
    local text = textCfg[voiceCfg.name]
    if text == nil then
      error("文本不存在！！ 文件名 " .. langPath .. " 文本名 = " .. voiceCfg.name .. " heroId = " .. tostring(heroId) .. ", voiceId = " .. tostring(voiceId))
      return nil
    end
    if (string.find)(text, CommanderNameStrTag) and PlayerDataCenter.playerName ~= nil then
      text = (string.gsub)(text, CommanderNameStrTag, PlayerDataCenter.playerName)
    end
    return text
  end
end

CharacterVoiceController.GetTextConfigPath = function(self, skinCfg, resCfg, lang, voiceId)
  -- function num : 0_7
  local langPath = nil
  if resCfg ~= nil then
    langPath = "CvTextConfig." .. resCfg.res_Name .. "_" .. lang
  end
  if skinCfg == nil then
    return langPath
  end
  local existVoice = self:IsExistSkinVoiceId(skinCfg.id, voiceId)
  if existVoice then
    langPath = "CvTextConfig." .. skinCfg.src_id_pic .. "_" .. lang
  end
  return langPath
end

CharacterVoiceController.RemoveCvText = function(self, heroId)
  -- function num : 0_8 , upvalues : _ENV
  local textCfgTable = (self.textCfgDic)[heroId]
  if textCfgTable ~= nil then
    for path,textCfg in pairs(textCfgTable) do
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R8 in 'UnsetPending'

      if textCfg ~= nil then
        (package.loaded)[textCfg.cvLangPath] = nil
        -- DECOMPILER ERROR at PC15: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.textCfgDic)[heroId] = nil
      end
    end
    collectgarbage()
  end
end

CharacterVoiceController.RemoveAllCvText = function(self)
  -- function num : 0_9 , upvalues : _ENV
  for heroId,textCfgTable in pairs(self.textCfgDic) do
    if textCfgTable ~= nil then
      for path,textCfg in pairs(textCfgTable) do
        -- DECOMPILER ERROR at PC13: Confused about usage of register: R11 in 'UnsetPending'

        (package.loaded)[textCfg.cvLangPath] = nil
      end
    end
  end
  self.textCfgDic = {}
  collectgarbage()
end

CharacterVoiceController.GetVoiceIdFromName = function(self, voiceName)
  -- function num : 0_10 , upvalues : _ENV
  for id,cfg in pairs(ConfigData.audio_voice) do
    if cfg.name == voiceName then
      return id
    end
  end
  return nil
end

CharacterVoiceController.GetSheetNameAndCueName = function(self, heroId, voiceId, skinId)
  -- function num : 0_11
  if not self:HasCv(heroId) then
    return 
  end
  local heroCfg, resCfg, voiceCfg, skinCfg = self:GetVoiceInfo(heroId, voiceId, skinId)
  local sheetName = self:GetSheetName(resCfg, skinCfg, voiceId)
  local cueName = self:GetCueName(resCfg, voiceCfg, skinCfg, voiceId)
  return sheetName, cueName
end

CharacterVoiceController.GetVoiceInfo = function(self, heroId, voiceId, skinId)
  -- function num : 0_12 , upvalues : _ENV
  if skinId == nil then
    skinId = self:GetHeroCurrentSkinId(heroId)
  end
  if skinId == 0 then
    skinId = heroId
  end
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg == nil then
    error("Cant get hero_data, heroId = " .. tostring(heroId))
    return 
  end
  local resCfg = (ConfigData.resource_model)[heroCfg.src_id]
  if resCfg == nil then
    error("resource model Cfg is null,id:" .. tostring(heroCfg.src_id))
    return 
  end
  local skinVoiceId = self:GetRealVoiceId(skinId, voiceId)
  local voiceCfg = (ConfigData.audio_voice)[skinVoiceId]
  if voiceCfg == nil then
    error("Cant get audio_voice, voiceId = " .. tostring(voiceId))
    return 
  end
  local skinCfg = (ConfigData.skin)[skinId]
  return heroCfg, resCfg, voiceCfg, skinCfg
end

CharacterVoiceController.GetVoiceLength = function(self, heroId, voiceId, skinId)
  -- function num : 0_13 , upvalues : _ENV
  local sheetName, cueName = self:GetSheetNameAndCueName(heroId, voiceId, skinId)
  if sheetName == nil then
    return 0
  end
  return AudioManager:GetAudioLength(sheetName, cueName)
end

CharacterVoiceController.OnDelete = function(self)
  -- function num : 0_14 , upvalues : base
  self:RemoveAllCvText()
  self:RemoveCvAllCueSheet(true)
  ;
  (base.OnDelete)(self)
end

CharacterVoiceController.GetSheetName = function(self, resCfg, skinCfg, voiceId)
  -- function num : 0_15
  local sheetName = nil
  if resCfg ~= nil then
    sheetName = "VO_" .. resCfg.res_Name
  end
  if skinCfg == nil then
    return sheetName
  end
  local existVoice = self:IsExistSkinVoiceId(skinCfg.id, voiceId)
  if existVoice then
    sheetName = "VO_" .. skinCfg.src_id_pic
  end
  return sheetName
end

CharacterVoiceController.GetCueName = function(self, resCfg, voiceCfg, skinCfg, voiceId)
  -- function num : 0_16
  local cueName = nil
  if resCfg ~= nil then
    cueName = resCfg.res_Name .. "_" .. voiceCfg.name
  end
  if skinCfg == nil then
    return cueName
  end
  local existVoice = self:IsExistSkinVoiceId(skinCfg.id, voiceId)
  if existVoice then
    cueName = skinCfg.src_id_pic .. "_" .. voiceCfg.name
  end
  return cueName
end

CharacterVoiceController.IsExistSkinVoiceId = function(self, skinId, voiceId)
  -- function num : 0_17
  if not self:HasSkinCv(skinId) then
    return false
  end
  local skinVoiceId = self:GetSkinVoiceId(skinId, voiceId)
  local existVoice = self:IsExistVoiceId(skinVoiceId)
  return existVoice
end

CharacterVoiceController.HasSkinCv = function(self, SkinId)
  -- function num : 0_18 , upvalues : _ENV
  local skinCfg = (ConfigData.skin)[SkinId]
  if skinCfg ~= nil then
    return skinCfg.has_voice
  end
  return false
end

CharacterVoiceController.IsExistVoiceId = function(self, voiceId)
  -- function num : 0_19 , upvalues : _ENV
  local voiceCfg = (ConfigData.audio_voice)[voiceId]
  do return voiceCfg ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CharacterVoiceController.GetSkinVoiceId = function(self, skinId, voiceId)
  -- function num : 0_20
  if voiceId >= 300000000 then
    return voiceId
  end
  if skinId < 3000 then
    return voiceId
  end
  local skinVoiceId = skinId * 1000 + voiceId
  return skinVoiceId
end

CharacterVoiceController.GetRealVoiceId = function(self, skinId, voiceId)
  -- function num : 0_21
  local skinVoiceId = self:GetSkinVoiceId(skinId, voiceId)
  if self:IsExistVoiceId(skinVoiceId) then
    return skinVoiceId
  else
    return voiceId
  end
end

CharacterVoiceController.GetHeroCurrentSkinId = function(self, heroId)
  -- function num : 0_22 , upvalues : _ENV
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData ~= nil then
    return heroData:GetCurrentUseSkinId()
  end
  return (heroId + 2000) * 100
end

return CharacterVoiceController

