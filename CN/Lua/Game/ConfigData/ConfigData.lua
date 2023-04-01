-- params : ...
-- function num : 0 , upvalues : _ENV
ConfigData = {}
local SectorEnum = require("Game.Sector.SectorEnum")
local cs_GameData = (CS.GameData).instance
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local emptyString = ""
local DefineConfigDataFunc = function()
  -- function num : 0_0 , upvalues : _ENV
  local langInt = ((CS.LanguageGlobal).GetLanguageInt)()
  local item_metatable = (ConfigData.item).__basemetatable
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (item_metatable.__index).GetHeroResCfg = function(self)
    -- function num : 0_0_0 , upvalues : _ENV
    if self.action_type == eItemActionType.HeroCard or self.action_type == eItemActionType.HeroCardFrag then
      local heroId = (self.arg)[1]
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg == nil then
        return heroCfg
      end
      local resCfg = (ConfigData.resource_model)[heroCfg.src_id]
      return resCfg
    end
    do
      return nil
    end
  end

  if langInt ~= eLanguageType.ZH_CN then
    local langStr = "_" .. ((CS.LanguageGlobal).GetLanguageStr)()
    for _,itemId in pairs((ConfigData.item).item_lang_icons) do
      local itemCfg = (ConfigData.item)[itemId]
      itemCfg.icon = itemCfg.icon .. langStr
    end
  end
  do
    item_metatable.__newindex = function()
    -- function num : 0_0_1 , upvalues : _ENV
    error("Attempt to modify read-only table")
  end

    -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((ConfigData.hero_data).__basemetatable).__index).GetHeroResCfg = function(self)
    -- function num : 0_0_2 , upvalues : _ENV
    local resCfg = (ConfigData.resource_model)[self.src_id]
    return resCfg
  end

    -- DECOMPILER ERROR at PC48: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((ConfigData.guide).__basemetatable).__index).GetFirstCondition = function(self)
    -- function num : 0_0_3 , upvalues : _ENV
    local firstId = (self.step_list)[1]
    if firstId == nil then
      return 0
    end
    local stepCfg = (ConfigData.guide_step)[firstId]
    if stepCfg == nil then
      error("guide step cfg is null,id:" .. tostring(firstId))
      return 0
    end
    return stepCfg.condition, stepCfg.condition_arg
  end

  end
end

-- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.InitConfigData = function(self)
  -- function num : 0_1 , upvalues : DefineConfigDataFunc, _ENV
  self.DynConfigNum = {}
  DefineConfigDataFunc()
  self.buildinConfig = require("Game.ConfigData.BuildinConfig")
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.game_config).heroMaxCamp = (table.count)(ConfigData.camp)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.game_config).heroMaxCareer = 5
end

-- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.LoadDynCfg = function(self, type)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if ConfigData[type] == nil then
    ConfigData[type] = require("LuaConfigs." .. type)
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.DynConfigNum)[type] = ((self.DynConfigNum)[type] or 0) + 1
end

-- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.ReleaseDynCfg = function(self, type)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.DynConfigNum)[type] = ((self.DynConfigNum)[type] or 0) - 1
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  if (self.DynConfigNum)[type] <= 0 then
    ConfigData[type] = nil
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (package.loaded)["LuaConfigs." .. type] = nil
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.DynConfigNum)[type] = nil
  end
end

-- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.ForceReleaseDynCfg = function(self, type)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  ConfigData[type] = nil
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (package.loaded)["LuaConfigs." .. type] = nil
end

-- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.GetCampFetter = function(self, camp, number)
  -- function num : 0_5
  local fetterList = ((self.camp_connection).fetterList)[camp]
  if fetterList == nil then
    return nil
  end
  for i = #fetterList, 1, -1 do
    local curNum = fetterList[i]
    if curNum <= number then
      return ((self.camp_connection)[camp])[curNum]
    end
  end
  return nil
end

-- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.GetCareerIcon = function(self, career)
  -- function num : 0_6
  local careerCfg = (self.career)[career]
  if careerCfg == nil then
    return nil
  end
  return careerCfg.icon
end

-- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.GetCampIcon = function(self, camp)
  -- function num : 0_7
  local campCfg = (self.camp)[camp]
  if campCfg == nil then
    return nil
  end
  return campCfg.icon
end

-- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

ConfigData.GetAudioCategoryCfg = function(self, id)
  -- function num : 0_8 , upvalues : _ENV
  local cfg = (self.audio_category)[id]
  if cfg == nil then
    error("Can\'t find audio_category, id = " .. tostring(id))
    return 
  end
  return cfg.category, cfg.aisac
end

local eVoicePointTypeFunc = function(normalCfg, normalList, specialCfg, specialList, key)
  -- function num : 0_9
  normalList = normalCfg[key]
  if specialCfg then
    specialList = specialCfg[key]
  end
  return specialList, normalList
end

local eVoicePointTypeKey = {[eVoicePointType.EnterHome] = "vo_main", [eVoicePointType.WaitInHome] = "vo_afk", [eVoicePointType.EnterTeam] = "vo_formation", [eVoicePointType.StartBattle] = "vo_battle", [eVoicePointType.MVP] = "vo_mvp", [eVoicePointType.InFactory] = "vo_duty", [eVoicePointType.HellowDrom] = "vo_dormgreet", [eVoicePointType.PicClick] = "vo_interact", [eVoicePointType.ultSkill] = "vo_ultSkill", [eVoicePointType.levelup] = "vo_levelup", [eVoicePointType.rankup] = "vo_rankup", [eVoicePointType.title] = "vo_title"}
-- DECOMPILER ERROR at PC77: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetVoListByPointId = function(self, heroId, voPointId)
  -- function num : 0_10 , upvalues : _ENV, eVoicePointTypeKey, eVoicePointTypeFunc
  local cfgList = self.audio_voice_point
  local specialCfg, specialList = nil, nil
  if heroId and cfgList[heroId] then
    specialCfg = cfgList[heroId]
  else
    specialList = table.emptytable
  end
  local normalCfg = cfgList[0]
  local normalList = nil
  if eVoicePointTypeKey[voPointId] == nil then
    error("Can\'t get audio_voice_point cfg, voPointId = " .. tostring(voPointId))
    return nil
  else
    specialList = eVoicePointTypeFunc(normalCfg, normalList, specialCfg, specialList, eVoicePointTypeKey[voPointId])
  end
  local realList = {}
  ;
  (table.insertto)(realList, specialList, 0)
  ;
  (table.insertto)(realList, normalList, 0)
  return realList
end

-- DECOMPILER ERROR at PC80: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetVoicePointRandom = function(self, voPointId, excludeVoiceId, heroId)
  -- function num : 0_11
  local vo_list = self:GetVoListByPointId(heroId, voPointId)
  if self.lastAllHeroVoiceIdDic == nil then
    self.lastAllHeroVoiceIdDic = {}
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  if heroId then
    if (self.lastAllHeroVoiceIdDic)[heroId] == nil then
      (self.lastAllHeroVoiceIdDic)[heroId] = {}
    end
    if excludeVoiceId == nil or excludeVoiceId == 0 then
      excludeVoiceId = ((self.lastAllHeroVoiceIdDic)[heroId])[voPointId]
    end
  end
  local voiceId = self:GetRandomExcludeSpecify(vo_list, excludeVoiceId)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

  if heroId then
    ((self.lastAllHeroVoiceIdDic)[heroId])[voPointId] = voiceId
  end
  return voiceId
end

-- DECOMPILER ERROR at PC83: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetRandomExcludeSpecify = function(self, list, excludeSpecify)
  -- function num : 0_12 , upvalues : _ENV
  if #list == 1 then
    return list[1]
  end
  ;
  (math.randomseed)((os.time)())
  local index = (math.random)(#list)
  local item = list[index]
  if excludeSpecify == nil then
    return item
  end
  if item ~= excludeSpecify then
    return item
  end
  if #list <= index then
    item = list[1]
  else
    item = list[index + 1]
  end
  return item
end

-- DECOMPILER ERROR at PC86: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetUnLockFriendShipCvIds = function(self, heroId, heroData)
  -- function num : 0_13 , upvalues : _ENV
  if heroData == nil then
    return 
  end
  local friendship_awardCfg = (self.friendship_award)[heroId]
  if friendship_awardCfg == nil then
    return 
  end
  local cvIds = nil
  for fsLevel,friendshipcCfg in pairs(friendship_awardCfg) do
    if friendshipcCfg.is_audio and heroData:IsArchiveUnlocked(fsLevel) then
      for cvId,voiceCfg in pairs(self.audio_voice) do
        if voiceCfg.name == friendshipcCfg.open then
          if cvIds == nil then
            cvIds = {}
          end
          ;
          (table.insert)(cvIds, cvId)
        end
      end
    end
  end
  return cvIds
end

-- DECOMPILER ERROR at PC89: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetAttribute = function(self, attrId, value)
  -- function num : 0_14 , upvalues : _ENV
  local cfg = (self.attribute)[attrId]
  if cfg == nil then
    error("Can\'t find attribute, id = " .. tostring(attrId))
    return 
  end
  local name = ((LanguageUtil.GetLocaleText)(cfg.name))
  local valueStr = nil
  if value ~= nil then
    if type(value) == "table" then
      valueStr = {}
      for index,val in ipairs(value) do
        if cfg.num_type == 1 then
          valueStr[index] = tostring(val)
        else
          valueStr[index] = tostring(FormatNum(val / 10)) .. "%"
        end
      end
    else
      do
        if type(value) == "number" then
          if cfg.num_type == 1 then
            valueStr = tostring(value)
          else
            valueStr = tostring(FormatNum(value / 10)) .. "%"
          end
        end
        return name, valueStr, cfg.icon
      end
    end
  end
end

-- DECOMPILER ERROR at PC92: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetFormulaValue = function(formulaId, tab)
  -- function num : 0_15 , upvalues : _ENV
  local cfg = (ConfigData.attr_combat)[formulaId]
  if cfg == nil or cfg.formula == nil or cfg.formula == "" then
    error("Cant get attr_combat.formula, formulaId = " .. tostring(formulaId))
    return 0
  end
  local formulaFunc = cfg.formula
  if type(formulaFunc) ~= "function" then
    formulaFunc = (load("return function(tab) return " .. formulaFunc .. " end"))()
    cfg.formula = formulaFunc
  end
  local power = formulaFunc(tab)
  return power
end

-- DECOMPILER ERROR at PC95: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetAddictionCfg = function(self, age)
  -- function num : 0_16 , upvalues : _ENV
  local cfg = nil
  for _,ageRange in ipairs((self.anti_addiction).id_sort_list) do
    if age < ageRange then
      cfg = (self.anti_addiction)[ageRange]
      break
    end
  end
  do
    return cfg
  end
end

-- DECOMPILER ERROR at PC98: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetTipContent = function(self, id, ...)
  -- function num : 0_17 , upvalues : _ENV
  if type(id) ~= "number" then
    id = 1
  end
  local tipCfg = (ConfigData.tip_language)[id]
  if tipCfg == nil then
    return (LanguageUtil.GetLocaleText)(((ConfigData.tip_language)[1]).content)
  end
  if select("#", ...) > 0 then
    return (string.format)((LanguageUtil.GetLocaleText)(tipCfg.content), ...)
  end
  return (LanguageUtil.GetLocaleText)(tipCfg.content)
end

-- DECOMPILER ERROR at PC101: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetTipTag = function(self, tagTypeId, tagIndexId)
  -- function num : 0_18 , upvalues : _ENV
  if type(tagTypeId) ~= "number" then
    return (LanguageUtil.GetLocaleText)(((ConfigData.tip_language)[1]).content)
  end
  local tipTagCfg = ((ConfigData.label_text).tipTagDic)[tagTypeId]
  if tipTagCfg == nil or tipTagCfg[tagIndexId] == nil then
    return (LanguageUtil.GetLocaleText)(((ConfigData.tip_language)[1]).content)
  end
  return (LanguageUtil.GetLocaleText)(tipTagCfg[tagIndexId])
end

-- DECOMPILER ERROR at PC104: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.LoadLocalText = function()
  -- function num : 0_19 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R0 in 'UnsetPending'

  if (package.loaded)[ConfigData.locale_text] ~= nil then
    (package.loaded)[ConfigData.locale_text] = nil
  end
  local ConfigDataLoader = require("Game.ConfigData.ConfigDataLoader")
  local fileName = ((CS.GlobalRegister).IsLocalTextDebug)() and "locale_text_debug" or "locale_text"
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R2 in 'UnsetPending'

  ConfigData.locale_text = require(ConfigDataLoader.LoadConfigHead .. fileName)
end

-- DECOMPILER ERROR at PC107: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetFormationHeroCount = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local count = (ConfigData.game_config).max_stage_hero
  for i = 1, (ConfigData.game_config).max_bench_hero do
    local sysFuncId = proto_csmsg_SystemFunctionID["SystemFunctionID_bench" .. tostring(i)]
    local unlock = FunctionUnlockMgr:ValidateUnlock(sysFuncId)
    if unlock then
      count = count + 1
    end
  end
  return count
end

-- DECOMPILER ERROR at PC110: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.IsManualOpenGiftItem = function(self, itemCfg)
  -- function num : 0_21 , upvalues : _ENV
  if itemCfg == nil then
    return false
  end
  if self.__GiftItemActionType == nil then
    self.__GiftItemActionType = {[proto_csmsg_ItemActionType.ItemActionTypeFixedItem] = true, [proto_csmsg_ItemActionType.ItemActionTypeRadioChoiceGift] = true, [proto_csmsg_ItemActionType.ItemActionTypeRandomReward] = true}
  end
  local action_type = itemCfg.action_type
  return (self.__GiftItemActionType)[action_type] or false
end

-- DECOMPILER ERROR at PC113: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.IsManualOpenItem = function(self, itemCfg)
  -- function num : 0_22
  do return itemCfg.available or 0 > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC116: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.IsAutoUseGift = function(self, itemCfg)
  -- function num : 0_23
  do return itemCfg.available or 0 == 2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC119: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.IsRewardNotShowATH = function(self, itemCfg)
  -- function num : 0_24 , upvalues : _ENV
  local id = itemCfg.id
  local isAthItemOrAutoUseAthGift = itemCfg.type ~= eItemType.Arithmetic and ((((ConfigData.item).athGiftDic)[id] ~= nil and self:IsAutoUseGift(itemCfg)))
  do return isAthItemOrAutoUseAthGift end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC122: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetChipDescriptionById = function(self, chipId, num, isShowDetail)
  -- function num : 0_25 , upvalues : _ENV, cs_GameData
  local showDetail = isShowDetail == nil or isShowDetail == true
  local description = ""
  local chipCfg = (ConfigData.chip)[chipId]
  if chipCfg == nil then
    error("Can\'t find chip cfg, id = " .. tostring(chipId))
    return description
  end
  if #chipCfg.skill_list > 0 then
    local skillId = (chipCfg.skill_list)[1]
    local skillCfg = (cs_GameData.listBattleSkillDatas):GetDataById(skillId)
    if skillCfg == nil then
      error("Can\'t find skillCfg, id = " .. tostring(skillId))
      return description
    end
    description = skillCfg:GetLevelDescribe(num, false, showDetail)
  elseif #chipCfg.attribute_id > 0 then
    local attrInfo = (BattleUtil.GetChipAttrInfo)(chipCfg.attribute_id, chipCfg.attribute_initial, chipCfg.level_increase, num)
    description = ConfigData:GetChipinfluenceIntro(chipCfg.id, attrInfo)
  end
  do return description end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC125: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetChipinfluenceIntro = function(self, chipId, extraInfo)
  -- function num : 0_26 , upvalues : _ENV
  local chipCfg = (ConfigData.chip)[chipId]
  if chipCfg == nil then
    return ""
  end
  local introCfg1 = (ConfigData.chip_intro)[chipCfg.influence]
  if introCfg1 == nil then
    return ""
  end
  local intro_type = ((ConfigData.chip_intro).influence_type)[chipCfg.influence]
  local content = ""
  if intro_type == 0 then
    local introCfg2 = introCfg1[chipCfg.arg]
    if introCfg2 ~= nil then
      content = (string.format)((LanguageUtil.GetLocaleText)(introCfg2.intro), extraInfo)
    end
  else
    do
      if intro_type == 1 then
        local careerCfg = (ConfigData.career)[chipCfg.arg]
        local introCfg2 = introCfg1[0]
        if careerCfg ~= nil and introCfg2 ~= nil then
          content = (string.format)((LanguageUtil.GetLocaleText)(introCfg2.intro), (LanguageUtil.GetLocaleText)(careerCfg.name), extraInfo)
        end
      else
        do
          if intro_type == 2 then
            local campCfg = (ConfigData.camp)[chipCfg.arg]
            local introCfg2 = introCfg1[0]
            if campCfg ~= nil and introCfg2 ~= nil then
              content = (string.format)((LanguageUtil.GetLocaleText)(introCfg2.intro), (LanguageUtil.GetLocaleText)(campCfg.name), extraInfo)
            end
          else
            do
              if intro_type == 3 then
                local roleCfg = (ConfigData.hero_data)[chipCfg.arg]
                local introCfg2 = introCfg1[0]
                if roleCfg == nil then
                  roleCfg = (ConfigData.monster)[chipCfg.arg]
                end
                if roleCfg ~= nil and introCfg2 ~= nil then
                  content = (string.format)((LanguageUtil.GetLocaleText)(introCfg2.intro), (LanguageUtil.GetLocaleText)(roleCfg.name), extraInfo)
                end
              end
              do
                return content
              end
            end
          end
        end
      end
    end
  end
end

-- DECOMPILER ERROR at PC128: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetChipQuality = function(self, count)
  -- function num : 0_27 , upvalues : _ENV
  if count <= 0 then
    return eItemQualityType.Blue
  end
  if not eChipLevelToQaulity[count] then
    return eItemQualityType.Orange
  end
end

-- DECOMPILER ERROR at PC131: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetChipQualityColor = function(self, count)
  -- function num : 0_28 , upvalues : _ENV
  return ItemQualityColor[ConfigData:GetChipQuality(count)]
end

-- DECOMPILER ERROR at PC134: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetItemType = function(self, itemId)
  -- function num : 0_29 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    return 0
  end
  return itemCfg.type
end

-- DECOMPILER ERROR at PC137: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetItemName = function(self, itemId)
  -- function num : 0_30 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    return ""
  end
  return (LanguageUtil.GetLocaleText)(itemCfg.name)
end

-- DECOMPILER ERROR at PC140: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.CalculateEpChipSalePrice = function(self, epRoomId, chipLvl, chipPrice, dynPlayer)
  -- function num : 0_31 , upvalues : _ENV
  local shopCfg = (ConfigData.exploration_shop)[epRoomId]
  if shopCfg == nil then
    error("exploration shop is null,id:" .. tostring(epRoomId))
    return 0
  end
  local levels = shopCfg.discount_level
  local disCount = shopCfg.discount_scale
  local levelCount = #levels
  if dynPlayer ~= nil then
    local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
    local scaleNum = dynPlayer:GetSpecificBuffLogicPerPara((ExplorationEnum.eBuffLogicId).sealChipScale)
    if scaleNum ~= nil and scaleNum ~= 0 then
      return (math.floor)(chipPrice * (scaleNum / 100))
    end
  end
  do
    if levelCount <= 0 then
      return chipPrice
    end
    local index = 1
    for i = 1, levelCount do
      if levels[i] < 0 then
        index = i
        break
      end
      if chipLvl <= levels[i] then
        index = i
        break
      end
    end
    do
      return chipPrice * disCount[index] // 1000
    end
  end
end

-- DECOMPILER ERROR at PC143: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.CalculateEpChipDiscardSalePrice = function(self, discardId, chipLvl, chipPrice, dynPlayer)
  -- function num : 0_32 , upvalues : _ENV
  local discardCfg = (ConfigData.exploration_discard)[discardId]
  if discardCfg == nil then
    error("exploration discard cfg is null,id:" .. tostring(discardId))
    return 0
  end
  local levels = discardCfg.discard_level
  local disCount = discardCfg.discard_scaleValues
  local levelCount = #levels
  if dynPlayer ~= nil then
    local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
    local scaleNum = dynPlayer:GetSpecificBuffLogicPerPara((ExplorationEnum.eBuffLogicId).sealChipScale)
    if scaleNum ~= nil and scaleNum ~= 0 then
      return (math.floor)(chipPrice * (scaleNum / 100))
    end
  end
  do
    if levelCount <= 0 then
      return chipPrice
    end
    local index = 1
    for i = 1, levelCount do
      if levels[i] < 0 then
        index = i
        break
      end
      if chipLvl <= levels[i] then
        index = i
        break
      end
    end
    do
      return chipPrice * disCount[index] // 1000
    end
  end
end

-- DECOMPILER ERROR at PC146: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.CalculateEpChipUpgradePrice = function(self, epRoomId, refreshTimes)
  -- function num : 0_33 , upvalues : _ENV
  local refreshTimeCfg = ((ConfigData.event_upgrade)[epRoomId]).refresh_times
  local price = ((ConfigData.event_upgrade)[epRoomId]).prices
  return self:CalculatePriceGeneralFunc(refreshTimes, refreshTimeCfg, price)
end

-- DECOMPILER ERROR at PC149: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.CalculatePriceGeneralFunc = function(self, currentTime, cfgTimes, cfgPrices)
  -- function num : 0_34
  local currentTime = currentTime + 1
  local refreshTimeCfgCount = #cfgTimes
  for i = 1, refreshTimeCfgCount do
    -- DECOMPILER ERROR at PC12: Unhandled construct in 'MakeBoolean' P1

    if i <= 1 and currentTime <= cfgTimes[1] then
      return cfgPrices[1]
    end
    -- DECOMPILER ERROR at PC21: Unhandled construct in 'MakeBoolean' P1

    if refreshTimeCfgCount <= i and cfgTimes[i - 1] < currentTime then
      return cfgPrices[refreshTimeCfgCount]
    end
    if cfgTimes[i - 1] < currentTime and currentTime <= cfgTimes[i] then
      return cfgPrices[i]
    end
  end
  return cfgPrices[refreshTimeCfgCount]
end

-- DECOMPILER ERROR at PC152: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetPerformanceTypeinfoByName = function(self, name)
  -- function num : 0_35 , upvalues : _ENV
  local id = ((ConfigData.performance_typeinfo).name_index)[name]
  if id == nil then
    error("performance_typeinfo cfg is null,name:" .. tostring(name))
    return nil
  end
  local typeinfoCfg = (ConfigData.performance_typeinfo)[id]
  if typeinfoCfg == nil then
    error("performance_typeinfo cfg is null,id:" .. tostring(id))
  end
  return typeinfoCfg
end

-- DECOMPILER ERROR at PC155: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetResModelCfg = function(self, id)
  -- function num : 0_36 , upvalues : _ENV
  return (ConfigData.resource_model)[id]
end

-- DECOMPILER ERROR at PC158: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetResNameByHeroId = function(self, heroId)
  -- function num : 0_37 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg == nil then
    error("[GetResNameByHeroId] hero cfg is null,id:" .. tostring(heroId))
    return ""
  end
  local resModelCfg = (ConfigData.resource_model)[heroCfg.src_id]
  if resModelCfg == nil then
    error("[GetResNameByHeroId] resource_model cfg is null,id:" .. tostring(heroCfg.src_id))
    return ""
  end
  return resModelCfg.res_Name
end

-- DECOMPILER ERROR at PC161: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetSectorIdShow = function(self, sectorId)
  -- function num : 0_38 , upvalues : SectorEnum, _ENV
  if sectorId == SectorEnum.NewbeeSectorId then
    return 0, false
  end
  local convertId = ((ConfigData.sector).sector_show_convert)[sectorId]
  if convertId ~= nil then
    return convertId, true
  end
  return sectorId, false
end

-- DECOMPILER ERROR at PC164: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetSectorStageName = function(self, stageId)
  -- function num : 0_39 , upvalues : _ENV, ExplorationEnum
  local stageCfg = (ConfigData.sector_stage)[stageId]
  if stageCfg == nil then
    error("Cant get sector_stage cfg, stageId = " .. tostring(stageId))
    return 
  end
  local sectorCfg = (ConfigData.sector)[stageCfg.sector]
  local sectorName = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  local showSectorId = ConfigData:GetSectorIdShow(stageCfg.sector)
  local sectorNum = stageCfg.num
  local diffstr = nil
  local difficult = stageCfg.difficulty
  if difficult == (ExplorationEnum.eDifficultType).Normal then
    diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_1)
  else
    if difficult == (ExplorationEnum.eDifficultType).Hard then
      diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_2)
    else
      diffstr = ConfigData:GetTipContent(TipContent.DifficultyName_3)
    end
  end
  local content = (string.format)("%s %s-%s(%s)", sectorName, showSectorId, sectorNum, diffstr)
  return content
end

-- DECOMPILER ERROR at PC167: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetSectorInfoMsg = function(self, sectorId, stageIndex, difficultyId)
  -- function num : 0_40 , upvalues : _ENV, emptyString
  local msg, str = nil, nil
  do
    if ((ConfigData.sector).onlyShowStageIdSectorDic)[sectorId] then
      local sectorCfg = (ConfigData.sector)[sectorId]
      str = ConfigData:GetTipContent(13006)
      msg = (string.format)(str, (LanguageUtil.GetLocaleText)(sectorCfg.name), stageIndex)
      return msg
    end
    local sectorActCoverCfg = (ConfigData.sector_act_des_cover)[sectorId]
    local isConvert = nil
    sectorId = ConfigData:GetSectorIdShow(sectorId)
    if sectorActCoverCfg and (sectorActCoverCfg.act_tip_long)[difficultyId] ~= 0 and (sectorActCoverCfg.normal_tip_long)[difficultyId] ~= 0 then
      local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(sectorId)
      local tipId = (sectorActCoverCfg.normal_tip_long)[difficultyId]
      if actData and not actData:IsActivityRunningTimeout() then
        tipId = (sectorActCoverCfg.act_tip_long)[difficultyId]
      end
      str = ConfigData:GetTipContent(tipId)
      msg = (string.format)(str, sectorId, stageIndex)
      return msg
    end
    do
      do
        if (ConfigData.sector)[sectorId] ~= nil then
          local courseDes = ((ConfigData.sector)[sectorId]).course_des
          if courseDes ~= emptyString then
            return (LanguageUtil.GetLocaleText)(courseDes)
          end
        end
        if difficultyId ~= 1 or not ConfigData:GetTipContent(13000) then
          local str = ConfigData:GetTipContent(13001)
        end
        msg = (string.format)(str, sectorId, stageIndex)
        return msg
      end
    end
  end
end

-- DECOMPILER ERROR at PC170: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetChallengeInfoMsg = function(self, moduleId)
  -- function num : 0_41 , upvalues : _ENV
  local msg = nil
  if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_DailyChallenge then
    msg = ConfigData:GetTipContent(13004)
  else
    if moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_WeeklyChallenge then
      msg = ConfigData:GetTipContent(13005)
    end
  end
  return msg
end

-- DECOMPILER ERROR at PC173: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetEndlessInfoMsg = function(self, sectorCfg, depth)
  -- function num : 0_42 , upvalues : _ENV
  return (string.format)(ConfigData:GetTipContent(13002), (LanguageUtil.GetLocaleText)(sectorCfg.name), depth)
end

-- DECOMPILER ERROR at PC176: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetTalentStage = function(self, level)
  -- function num : 0_43 , upvalues : _ENV
  if level or 0 == 0 then
    return 1, ConfigData:GetTipContent(((ConfigData.game_config).heroTalentLevelDesbrices)[1])
  end
  local stage = #(ConfigData.game_config).heroTalentLevelSplit
  for index,limit in ipairs((ConfigData.game_config).heroTalentLevelSplit) do
    if level < limit then
      stage = index
      break
    end
  end
  do
    return stage, ConfigData:GetTipContent(((ConfigData.game_config).heroTalentLevelDesbrices)[stage])
  end
end

-- DECOMPILER ERROR at PC179: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetAdjPresetHeroCount = function(self, teamId)
  -- function num : 0_44 , upvalues : _ENV
  if ((ConfigData.game_config).adjCustomMultDic)[teamId] ~= nil then
    return 2
  end
  return 1
end

-- DECOMPILER ERROR at PC182: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetHeroNameById = function(self, heroId)
  -- function num : 0_45 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg == nil then
    error("heroCfg is nil ,id is" .. tostring(heroId))
    return nil
  end
  return (LanguageUtil.GetLocaleText)(heroCfg.name)
end

-- DECOMPILER ERROR at PC185: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetFixedCstSkillsExp = function(self, stageId)
  -- function num : 0_46 , upvalues : _ENV
  if stageId == nil then
    return false
  end
  local sectorStageCfg = (ConfigData.sector_stage)[stageId]
  if sectorStageCfg == nil or #sectorStageCfg.const_cstIds == 0 then
    return false
  end
  return true, sectorStageCfg.const_cstIds, sectorStageCfg.const_cstIdPosDic
end

-- DECOMPILER ERROR at PC188: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetFixedCstSkillsDun = function(self, dungenId)
  -- function num : 0_47 , upvalues : _ENV
  if dungenId == nil then
    return false
  end
  local dungeonCfg = (ConfigData.battle_dungeon)[dungenId]
  if dungeonCfg == nil or #dungeonCfg.const_cstIds == 0 then
    return false
  end
  return true, dungeonCfg.const_cstIds, dungeonCfg.const_cstIdPosDic
end

-- DECOMPILER ERROR at PC191: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.SetSpecailPayCfg = function(self, currencySymbol, priceDic)
  -- function num : 0_48
  self._payCurrencySymbol = currencySymbol
  self._payPriceDic = priceDic
end

-- DECOMPILER ERROR at PC194: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.TryGetSpecailPayPrice = function(self, sdkId)
  -- function num : 0_49
  if self._payPriceDic == nil then
    return 
  end
  return (self._payPriceDic)[sdkId]
end

-- DECOMPILER ERROR at PC197: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.TryGetSpecailPayCurrencySymbol = function(self)
  -- function num : 0_50
  return self._payCurrencySymbol
end

-- DECOMPILER ERROR at PC200: Confused about usage of register: R7 in 'UnsetPending'

ConfigData.GetSkillMovieBySkin = function(self, movieName, skinId)
  -- function num : 0_51 , upvalues : _ENV
  if skinId == 0 then
    return movieName
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil or not skinCfg.has_skill_movie then
    return movieName
  end
  return movieName .. "_" .. skinCfg.src_id_pic
end


