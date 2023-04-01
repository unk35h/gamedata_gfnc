-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonLogicUtil = {}
local IsLegalFuncTable = {}
local GetCommonLogicDesConfig = function(logicId, moduleType)
  -- function num : 0_0 , upvalues : _ENV
  local logicDesCfg = nil
  local logicDesCfgDic = (ConfigData.common_logic_des)[logicId]
  if logicDesCfgDic ~= nil then
    if moduleType == nil or logicDesCfgDic[moduleType] == nil then
      logicDesCfg = logicDesCfgDic[0]
    else
      logicDesCfg = logicDesCfgDic[moduleType]
    end
    if logicDesCfg == nil then
      error("can\'t read logic cfg module ,id and module is " .. tostring(logicId) .. "," .. tostring(moduleType))
      return 
    end
  else
    error("can\'t read logic des id is " .. tostring(logicId))
    return 
  end
  return logicDesCfg
end

local GetDesFuncTable = {[eLogicType.ResourceLimit] = function(para1, para2, para3)
  -- function num : 0_1 , upvalues : _ENV
  local itemName = (LanguageUtil.GetLocaleText)(((ConfigData.item)[para1]).name)
  local itemNum = para2
  return (string.format)(ConfigData:GetTipContent(14001), itemName, tostring(itemNum)), itemName, itemNum
end
, [eLogicType.ResourceOutput] = function(para1, para2, para3)
  -- function num : 0_2 , upvalues : _ENV
  local itemName = (LanguageUtil.GetLocaleText)(((ConfigData.item)[para1]).name)
  local speed = para2 * 36 // 1000
  return (string.format)(ConfigData:GetTipContent(14002), itemName, tostring(speed)), itemName, speed
end
, [eLogicType.CampBuff] = function(para1, para2, para3)
  -- function num : 0_3 , upvalues : _ENV
  local campName = (LanguageUtil.GetLocaleText)(((ConfigData.camp)[para1]).name)
  local attrName = (LanguageUtil.GetLocaleText)(((ConfigData.attribute)[para2]).name)
  local attrValue = para3
  return (string.format)(ConfigData:GetTipContent(14003), campName, attrName, tostring(attrValue)), campName, attrName, attrValue
end
, [eLogicType.CareerBuff] = function(para1, para2, para3)
  -- function num : 0_4 , upvalues : _ENV
  local careerName = (LanguageUtil.GetLocaleText)(((ConfigData.career)[para1]).name)
  local attrName = (LanguageUtil.GetLocaleText)(((ConfigData.attribute)[para2]).name)
  local attrValue = para3
  return (string.format)(ConfigData:GetTipContent(14003), careerName, attrName, tostring(attrValue)), careerName, attrName, attrValue
end
, [eLogicType.FactoryPipelie] = function(para1, para2, para3)
  -- function num : 0_5 , upvalues : _ENV
  local lineNum = para1
  return (string.format)(ConfigData:GetTipContent(14004), tostring(lineNum)), lineNum
end
, [eLogicType.GlobalExpCeiling] = function(para1, para2, para3)
  -- function num : 0_6 , upvalues : _ENV
  local expLimt = para1
  return (string.format)(ConfigData:GetTipContent(14005), tostring(expLimt)), expLimt
end
, [eLogicType.StaminaCeiling] = function(para1, para2, para3)
  -- function num : 0_7 , upvalues : _ENV
  local staminaLimt = para1
  return (string.format)(ConfigData:GetTipContent(14006), tostring(staminaLimt)), staminaLimt
end
, [eLogicType.StaminaOutput] = function(para1, para2, para3)
  -- function num : 0_8 , upvalues : _ENV
  local speed = para1 * 0.036
  return (string.format)(ConfigData:GetTipContent(14007), tostring(speed)), speed
end
, [eLogicType.ResOutputEfficiency] = function(para1, para2, para3)
  -- function num : 0_9 , upvalues : _ENV
  local itemName = nil
  if para1 == 0 then
    itemName = ConfigData:GetTipContent(14010)
  else
    local itemCfg = (ConfigData.item)[para1]
    itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  end
  do
    local rate = GetPreciseDecimalStr(para2 / 10, 2) .. "%"
    return (string.format)(ConfigData:GetTipContent(14008), itemName, rate), itemName, rate
  end
end
, [eLogicType.BuildQueue] = function(para1, para2, para3)
  -- function num : 0_10 , upvalues : _ENV
  local placeName = nil
  if para1 == 1 then
    local systemName = (LanguageUtil.GetLocaleText)(((ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_Building]).name)
    placeName = systemName
  else
    do
      do
        local systemName = (LanguageUtil.GetLocaleText)(((ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration]).name)
        placeName = systemName
        local listNum = para2
        return (string.format)(ConfigData:GetTipContent(14011), placeName, tostring(listNum)), listNum
      end
    end
  end
end
, [eLogicType.BuildSpeed] = function(para1, para2, para3)
  -- function num : 0_11 , upvalues : _ENV
  ((theSelf.ui).tex_AttriName):SetIndex(eLogicType.BuildSpeed)
  local speed = para1
  local rate = GetPreciseDecimalStr(speed / 10, 2) .. "%"
  return (string.format)(ConfigData:GetTipContent(14012), rate), rate
end
, [eLogicType.GlobalExpRatio] = function(para1, para2, para3)
  -- function num : 0_12 , upvalues : _ENV
  local rate = GetPreciseDecimalStr(para1 / 10, 2) .. "%"
  return (string.format)(ConfigData:GetTipContent(14013), rate), rate
end
, [eLogicType.AllHeroBuff] = function(para1, para2, para3)
  -- function num : 0_13 , upvalues : _ENV
  local attrName = (LanguageUtil.GetLocaleText)(((ConfigData.attribute)[para1]).name)
  local attrValue = para2
  return (string.format)(ConfigData:GetTipContent(14014), attrName, tostring(attrValue)), attrName, attrValue
end
, [eLogicType.OverClock] = function(para1, para2, para3)
  -- function num : 0_14 , upvalues : _ENV
  local name = (LanguageUtil.GetLocaleText)((((ConfigData.overclock)[para1])[level]).name)
  local level = para2
  return (string.format)(ConfigData:GetTipContent(14015), name, tostring(level)), name, level
end
, [eLogicType.OverClockFreeNum] = function(para1, para2, para3)
  -- function num : 0_15 , upvalues : _ENV
  return (string.format)(ConfigData:GetTipContent(14016), tostring(para1)), para1
end
, [eLogicType.FocusPointCeiling] = function(para1, para2, para3)
  -- function num : 0_16 , upvalues : _ENV
  return (string.format)(ConfigData:GetTipContent(14017), tostring(para1)), para1
end
, [eLogicType.BattleExpBonus] = function(para1, para2, para3)
  -- function num : 0_17 , upvalues : _ENV
  local rate = GetPreciseDecimalStr(para1 / 10, 2) .. "%"
  return (string.format)(ConfigData:GetTipContent(14018), rate), rate
end
, [eLogicType.DynSkillUpgrade] = function(para1, para2, para3)
  -- function num : 0_18 , upvalues : _ENV
  local rate = GetPreciseDecimalStr(para1 / 100, 2) .. "%"
  return (string.format)(ConfigData:GetTipContent(14019), rate), rate
end
, [eLogicType.DynChipCountMax] = function(para1, para2, para3)
  -- function num : 0_19 , upvalues : _ENV
  return (string.format)(ConfigData:GetTipContent(14020), tostring(para1)), para1
end
, [eLogicType.AutoRecoverItem] = function(para1, para2, para3)
  -- function num : 0_20 , upvalues : _ENV
  local itemName = nil
  if para1 == 0 then
    itemName = ConfigData:GetTipContent(14010)
  else
    local itemCfg = (ConfigData.item)[para1]
    itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  end
  do
    local rate = GetPreciseDecimalStr(para2 / 100000 * 3600, 2)
    return (string.format)(ConfigData:GetTipContent(14021), itemName, rate), itemName, rate
  end
end
, [eLogicType.DungeonCountAdd] = function(para1, para2, para3)
  -- function num : 0_21 , upvalues : _ENV
  local dungeonName = (LanguageUtil.GetLocaleText)(((ConfigData.material_dungeon)[para1]).name)
  local describ = (LanguageUtil.GetLocaleText)(((ConfigData.buildingBuff)[eLogicType.DungeonCountAdd]).buff_text_context)
  local value = (LanguageUtil.GetLocaleText)(((ConfigData.buildingBuff)[eLogicType.DungeonCountAdd]).buff_value)
  local describ_text = dungeonName .. "：" .. (string.format)(describ, para2)
  return describ_text, para2
end
, [eLogicType.DungeonRewardExtraNum] = function(para1, para2, para3)
  -- function num : 0_22 , upvalues : _ENV
  local describ_text = (string.format)(ConfigData:GetTipContent(2029), para1)
  return describ_text
end
, [eLogicType.FriendshipBonus] = function(para1, para2, para3)
  -- function num : 0_23 , upvalues : _ENV
  local describ_text = (string.format)(ConfigData:GetTipContent(2030), para1)
  return describ_text
end
, [eLogicType.DailyFixedOutput] = function(para1, para2, para3)
  -- function num : 0_24 , upvalues : _ENV
  local para1Str = tostring(para1)
  local hourStr = (string.sub)(para1Str, 1, 2)
  local minuteStr = ((string.sub)(para1Str, 3, 4))
  local itemName = nil
  local itemCfg = (ConfigData.item)[para2]
  if itemCfg ~= nil then
    itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  end
  local describ_text = (string.format)(ConfigData:GetTipContent(2031), hourStr, minuteStr, itemName, para3)
  return describ_text
end
, [eLogicType.Activity_PointMultRate] = function(para1, para2, para3, moduleType)
  -- function num : 0_25 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_PointMultRate, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local pointName = nil
  local itemCfg = (ConfigData.item)[para2]
  pointName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  local addValue = GetPreciseDecimalStr(para3 / 10) .. "%"
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, pointName, addValue)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, pointName, addValue)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, pointName, addValue)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_Stamina2PointMultRate] = function(para1, para2, para3, moduleType)
  -- function num : 0_26 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_Stamina2PointMultRate, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local pointName = nil
  local itemCfg = (ConfigData.item)[para2]
  pointName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  local addValue = GetPreciseDecimalStr(para3 / 10) .. "%"
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, pointName, addValue)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, pointName, addValue)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, pointName, addValue)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_EffiMultRate] = function(para1, para2, para3, moduleType)
  -- function num : 0_27 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_EffiMultRate, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local multRate = nil
  multRate = tostring(para2 + 1)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, multRate)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, multRate)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, multRate)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_ChipGroupLevel] = function(para1, para2, para3, moduleType)
  -- function num : 0_28 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_ChipGroupLevel, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local suitName = nil
  local tagSuitCfg = (ConfigData.chip_tag)[para2]
  suitName = (LanguageUtil.GetLocaleText)(tagSuitCfg.tag_name)
  local qualityName = ConfigData:GetTipContent(ItemQualityColorName[eChipLevelToQaulity[para3]])
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, suitName, qualityName)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, suitName, qualityName)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, suitName, qualityName)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_UnlockBuff] = function(para1, para2, para3, moduleType)
  -- function num : 0_29 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_UnlockBuff, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local buffNmae, buffDes = nil, nil
  if moduleType == eLogicDesType.Warchess then
    local wcBuffCfg = (ConfigData.warchess_buff)[para2]
    if wcBuffCfg == nil then
      error("cant get warchess_buff cfg, buffId:" .. tostring(para2))
      return 
    end
    buffNmae = (LanguageUtil.GetLocaleText)(wcBuffCfg.name)
    buffDes = (LanguageUtil.GetLocaleText)(wcBuffCfg.description)
  else
    do
      do
        local buffCfg = (ConfigData.exploration_buff)[para2]
        if buffCfg == nil then
          error("cant get exploration_buff cfg, buffId:" .. tostring(para2))
          return 
        end
        buffNmae = (LanguageUtil.GetLocaleText)(buffCfg.name)
        buffDes = (LanguageUtil.GetLocaleText)(buffCfg.describe)
        longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, buffNmae, "", buffDes)
        shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, buffNmae)
        valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, buffNmae)
        return longDes, shortDes, valueDes
      end
    end
  end
end
, [eLogicType.Activity_DeleteBuff] = function(para1, para2, para3, moduleType)
  -- function num : 0_30 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_DeleteBuff, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local buffNmae, buffDes = nil, nil
  local buffCfg = (ConfigData.exploration_buff)[para2]
  buffNmae = (LanguageUtil.GetLocaleText)(buffCfg.name)
  buffDes = (LanguageUtil.GetLocaleText)(buffCfg.describe)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, buffNmae, "", buffDes)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, buffNmae)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, buffNmae)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_PowTestChipGroupLimitAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_31 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_PowTestChipGroupLimitAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local suitName = nil
  local tagSuitCfg = (ConfigData.chip_tag)[para2]
  suitName = (LanguageUtil.GetLocaleText)(tagSuitCfg.tag_name)
  local addCouldUseNum = tostring(para3)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, suitName, addCouldUseNum)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, suitName, addCouldUseNum)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, suitName, addCouldUseNum)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_ChipGroupCarryLimitAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_32 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_ChipGroupCarryLimitAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local addCouldPickNum = tostring(para2)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, addCouldPickNum)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, addCouldPickNum)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, addCouldPickNum)
  return longDes, shortDes, valueDes
end
, [eLogicType.FormationAttriAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_33 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.FormationAttriAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local attributeCfg = (ConfigData.attribute)[para1]
  if attributeCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, attriName, attriVal = nil, nil, nil, nil, nil
  if attributeCfg.merge_attribute or 0 > 0 then
    attriName = (LanguageUtil.GetLocaleText)(((ConfigData.attribute)[attributeCfg.merge_attribute]).name)
  else
    attriName = (LanguageUtil.GetLocaleText)(attributeCfg.name)
  end
  if attributeCfg.num_type == 2 then
    attriVal = tostring(FormatNum(para2 / 10)) .. "%"
  else
    attriVal = tostring(FormatNum(para2))
  end
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), attriName, attriVal)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), attriName, attriVal)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), attriName, attriVal)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_AttriAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_34 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_AttriAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData == nil then
    return 
  end
  local attributeCfg = (ConfigData.attribute)[para2]
  if attributeCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes = nil, nil, nil
  local actName = activityFrameData.name
  local attriName, attriVal = nil, nil
  if attributeCfg.merge_attribute or 0 > 0 then
    attriName = (LanguageUtil.GetLocaleText)(((ConfigData.attribute)[attributeCfg.merge_attribute]).name)
  else
    attriName = (LanguageUtil.GetLocaleText)(attributeCfg.name)
  end
  if attributeCfg.num_type == 2 then
    attriVal = tostring(FormatNum(para3 / 10)) .. "%"
  else
    attriVal = tostring(FormatNum(para3))
  end
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, attriName, attriVal)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, attriName, attriVal)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, attriName, attriVal)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_UnlockInitBuff] = function(para1, para2, para3, moduleType)
  -- function num : 0_35 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_UnlockInitBuff, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData == nil then
    return 
  end
  local buffCfg = (ConfigData.exploration_buff)[para2]
  if buffCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes = nil, nil, nil
  local actName = activityFrameData.name
  local buffName = (LanguageUtil.GetLocaleText)(buffCfg.name)
  local buffDes = (LanguageUtil.GetLocaleText)(buffCfg.describe)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, buffName, buffDes)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, buffName, buffDes)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, buffName, buffDes)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_UnlockStoreBuff] = function(para1, para2, para3, moduleType)
  -- function num : 0_36 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_UnlockStoreBuff, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData == nil then
    return 
  end
  local buffCfg = (ConfigData.exploration_buff)[para2]
  if buffCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes = nil, nil, nil
  local actName = activityFrameData.name
  local buffName = (LanguageUtil.GetLocaleText)(buffCfg.name)
  local buffDes = (LanguageUtil.GetLocaleText)(buffCfg.describe)
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, buffName, buffDes)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, buffName, buffDes)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, buffName, buffDes)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_CommanderAttriAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_37 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_CommanderAttriAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData == nil then
    return 
  end
  local attributeCfg = (ConfigData.attribute)[para2]
  if attributeCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes = nil, nil, nil
  local actName = activityFrameData.name
  local attriVal = nil
  if attributeCfg.cmd_num_type == 2 then
    attriVal = tostring(FormatNum(para3 / 10)) .. "%"
  else
    attriVal = tostring(FormatNum(para3))
  end
  longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, attriVal)
  shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, attriVal)
  valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, attriVal)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_InitialItemAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_38 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_InitialItemAdd, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local itemCfg = (ConfigData.item)[para2]
  local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  local longDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.intro)), nil, itemName, para3)
  local shortDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.short_des)), nil, itemName, para3)
  local valueDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.value)), nil, itemName, para3)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_InitialBuffAdd] = function(para1, para2, para3, moduleType)
  -- function num : 0_39 , upvalues : _ENV
  local wcBuffCfg = (ConfigData.warchess_buff)[para2]
  if wcBuffCfg == nil then
    error((string.format)("cant get warchess_buff cfg, buffId:%s,logicId:%s,para1:%s,para2:%s", para2, eLogicType.Activity_InitialBuffAdd, para1, para2))
    return 
  end
  local des = (LanguageUtil.GetLocaleText)(wcBuffCfg.description)
  local longDes = des
  return longDes
end
, [eLogicType.SeasonRoomAddItem] = function(para1, para2, para3, moduleType)
  -- function num : 0_40 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.SeasonRoomAddItem, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local roomCfg = (ConfigData.warchess_room_type)[para1]
  if roomCfg == nil then
    error(" roomType is nil " .. tostring(para1))
    return 
  end
  local roomName = (LanguageUtil.GetLocaleText)(roomCfg.type_name)
  local itemCfg = (ConfigData.item)[para2]
  local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  local longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), roomName, itemName, para3)
  local shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), roomName, itemName, para3)
  local valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), roomName, itemName, para3)
  return longDes, shortDes, valueDes
end
, [eLogicType.SeasonEnterAddItem] = function(para1, para2, para3, moduleType)
  -- function num : 0_41 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.SeasonEnterAddItem, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local itemCfg = (ConfigData.item)[para2]
  local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  local longDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.intro)), nil, itemName, para3)
  local shortDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.short_des)), nil, itemName, para3)
  local valueDes = (GR.StringFormat)(((LanguageUtil.GetLocaleText)(logicDesCfg.value)), nil, itemName, para3)
  return longDes, shortDes, valueDes
end
, [eLogicType.Activity_Mode_UnlockBuff] = function(para1, para2, para3, moduleType)
  -- function num : 0_42 , upvalues : GetCommonLogicDesConfig, _ENV
  local logicDesCfg = GetCommonLogicDesConfig(eLogicType.Activity_Mode_UnlockBuff, moduleType)
  if logicDesCfg == nil then
    return 
  end
  local longDes, shortDes, valueDes, actName = nil, nil, nil, nil
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityFrameData = activityFrameCtrl:GetActivityFrameData(para1)
  if activityFrameData ~= nil then
    actName = activityFrameData.name
  else
    actName = ""
    if isGameDev then
      error("activity miss " .. tostring(para1))
    end
  end
  local buffNmae, buffDes = nil, nil
  if para2 or 0 > 0 then
    local buffCfg = (ConfigData.exploration_buff)[para2]
    if buffCfg == nil then
      error("cant get exploration_buff cfg, buffId:" .. tostring(para2))
      return 
    end
    buffNmae = (LanguageUtil.GetLocaleText)(buffCfg.name)
    buffDes = (LanguageUtil.GetLocaleText)(buffCfg.describe)
  else
    do
      if para3 or 0 > 0 then
        local wcBuffCfg = (ConfigData.warchess_buff)[para2]
        if wcBuffCfg == nil then
          error("cant get warchess_buff cfg, buffId:" .. tostring(para2))
          return 
        end
        buffNmae = (LanguageUtil.GetLocaleText)(wcBuffCfg.name)
        buffDes = (LanguageUtil.GetLocaleText)(wcBuffCfg.description)
      else
        do
          if isGameDev then
            error(" Activity_ChessOrEx_UnlockBuff param2 and param3 error ")
          end
          longDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.intro), actName, buffNmae, "", buffDes)
          shortDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.short_des), actName, buffNmae)
          valueDes = (GR.StringFormat)((LanguageUtil.GetLocaleText)(logicDesCfg.value), actName, buffNmae)
          return longDes, shortDes, valueDes
        end
      end
    end
  end
end
}
local MergeType = {equal = 1, add = 2, max = 3}
local MergeInfoTable = {
[eLogicType.ResourceLimit] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.ResourceOutput] = {donotMerge = true}
, 
[eLogicType.CampBuff] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.CareerBuff] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.FactoryPipelie] = {[1] = MergeType.add}
, 
[eLogicType.GlobalExpCeiling] = {[1] = MergeType.add}
, 
[eLogicType.StaminaCeiling] = {[1] = MergeType.add}
, 
[eLogicType.StaminaOutput] = {[1] = MergeType.add}
, 
[eLogicType.ResOutputEfficiency] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.BuildQueue] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.BuildSpeed] = {[1] = MergeType.add}
, 
[eLogicType.GlobalExpRatio] = {[1] = MergeType.add}
, 
[eLogicType.AllHeroBuff] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.OverClock] = {[1] = MergeType.equal, [2] = MergeType.max}
, 
[eLogicType.OverClockFreeNum] = {[1] = MergeType.add}
, 
[eLogicType.FocusPointCeiling] = {[1] = MergeType.add}
, 
[eLogicType.BattleExpBonus] = {[1] = MergeType.add}
, 
[eLogicType.DynSkillUpgrade] = {[1] = MergeType.add}
, 
[eLogicType.DynChipCountMax] = {[1] = MergeType.add}
, 
[eLogicType.AutoRecoverItem] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.DungeonCountAdd] = {[1] = MergeType.equal, [2] = MergeType.add}
, 
[eLogicType.DungeonRewardExtraNum] = {[1] = MergeType.add}
, 
[eLogicType.FriendshipBonus] = {[1] = MergeType.add}
, 
[eLogicType.DailyFixedOutput] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.Activity_PointMultRate] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.Activity_Stamina2PointMultRate] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.Activity_EffiMultRate] = {[1] = MergeType.equal, [2] = MergeType.max}
, 
[eLogicType.Activity_AttriAdd] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.Activity_InitialItemAdd] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.Activity_InitialBuffAdd] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
, 
[eLogicType.SeasonEnterAddItem] = {[1] = MergeType.equal, [2] = MergeType.equal, [3] = MergeType.add}
}
local GetDesAboutLvDiffFuncTable = {[eLogicType.FormationAttriAdd] = function(para1, para2, para3, nextPara1, nextPara2, nextPara3)
  -- function num : 0_43 , upvalues : _ENV
  if para1 ~= nil and nextPara1 ~= nil and para1 ~= nextPara1 then
    error("attriId different")
    return nil, nil, nil
  end
  local buildBuffCfg = (ConfigData.buildingBuff)[eLogicType.FormationAttriAdd]
  local attriId = para1 ~= nil and para1 or nextPara1
  local attriCfg = (ConfigData.attribute)[attriId]
  if attriCfg == nil then
    error("attriId Miss")
    return nil, nil, nil
  end
  local context = (LanguageUtil.GetLocaleText)(buildBuffCfg.buff_text_context)
  context = (string.format)(context, (LanguageUtil.GetLocaleText)(attriCfg.name))
  local curValueStr, nextValueStr = nil, nil
  local curAttrVal = para2 or 0
  if attriCfg.num_type ~= 2 or not tostring(tostring(FormatNum(curAttrVal / 10)) .. "%") then
    curValueStr = tostring(curAttrVal)
  end
  if nextPara2 ~= nil and (attriCfg.num_type ~= 2 or not tostring(tostring(FormatNum(nextPara2 / 10)) .. "%")) then
    nextValueStr = tostring(nextPara2)
  end
  return context, curValueStr, nextValueStr
end
}
CommonLogicUtil.GetDesString = function(logic, para1, para2, para3, moduleType)
  -- function num : 0_44 , upvalues : GetDesFuncTable
  local desFunc = GetDesFuncTable[logic]
  if desFunc == nil then
    return ""
  else
    return desFunc(para1, para2, para3, moduleType)
  end
end

CommonLogicUtil.GetDesAboutLvDiff = function(self, logics, para1s, para2s, para3s, nextLogics, nextPara1s, nextPara2s, nextPara3s)
  -- function num : 0_45 , upvalues : _ENV, GetDesAboutLvDiffFuncTable
  if logics ~= nil and nextLogics ~= nil and #logics ~= #nextLogics then
    error("count different")
    return nil
  else
    if logics == nil and nextLogics == nil then
      error("logics is NIL")
      return nil
    end
  end
  local list = {}
  if logics == nil then
    for index,logicId in ipairs(nextLogics) do
      local func = GetDesAboutLvDiffFuncTable[logicId]
      if func == nil then
        error(" not have DesAboutLvDiffFunc ")
      else
        local des, curVal, nextVal = func(nil, nil, nil, nextPara1s[index], nextPara2s[index], nextPara3s[index])
        ;
        (table.insert)(list, {logicId = logicId, currentInfo = des, curValue = curVal, nextInfoValue = nextVal})
      end
    end
  else
    do
      if nextLogics == nil then
        for index,logicId in ipairs(logics) do
          local func = GetDesAboutLvDiffFuncTable[logicId]
          if func == nil then
            error(" not have DesAboutLvDiffFunc ")
          else
            local des, curVal, nextVal = func(para1s[index], para2s[index], para3s[index], nil, nil, nil)
            ;
            (table.insert)(list, {logicId = logicId, currentInfo = des, curValue = curVal, nextInfoValue = nextVal})
          end
        end
      else
        do
          for index,logicId in ipairs(logics) do
            if nextLogics[index] ~= logicId then
              error(" logicId different ")
            else
              local func = GetDesAboutLvDiffFuncTable[logicId]
              if func == nil then
                error(" not have DesAboutLvDiffFunc ")
              else
                local des, curVal, nextVal = func(para1s[index], para2s[index], para3s[index], nextPara1s[index], nextPara2s[index], nextPara3s[index])
                ;
                (table.insert)(list, {logicId = logicId, currentInfo = des, curValue = curVal, nextInfoValue = nextVal})
              end
            end
          end
          do
            return list
          end
        end
      end
    end
  end
end

CommonLogicUtil.CLUEnableLoopLv = function(level)
  -- function num : 0_46 , upvalues : CommonLogicUtil
  CommonLogicUtil._EnableLoopLv = level
end

CommonLogicUtil.GetLogicDesStrMultiLine = function(logic_list, para1_list, para2_List, para3_list, moduleType)
  -- function num : 0_47 , upvalues : _ENV, CommonLogicUtil
  local des = nil
  for index,logic in pairs(logic_list) do
    local para1 = para1_list[index]
    local para2 = para2_List[index]
    local para3 = para3_list[index]
    if CommonLogicUtil._EnableLoopLv ~= nil then
      para1 = (CommonLogicUtil.GetLoopLevelPara)(CommonLogicUtil._EnableLoopLv, logic, para1, para2, para3)
    end
    if (string.IsNullOrEmpty)(des) then
      des = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, moduleType)
    else
      des = des .. "\n" .. (CommonLogicUtil.GetDesString)(logic, para1, para2, para3, moduleType)
    end
  end
  ;
  (CommonLogicUtil.CLUEnableLoopLv)(nil)
  return des
end

CommonLogicUtil.MergeLogic = function(logicDic, logic, paras)
  -- function num : 0_48 , upvalues : _ENV, MergeInfoTable, MergeType
  local logicParaTable = logicDic[logic]
  if logicParaTable == nil then
    logicDic[logic] = {}
    for index,value in ipairs(paras) do
      -- DECOMPILER ERROR at PC11: Confused about usage of register: R9 in 'UnsetPending'

      (logicDic[logic])[index] = {}
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((logicDic[logic])[index])[1] = value
    end
    return logicDic
  end
  local mergeInfo = MergeInfoTable[logic]
  if mergeInfo == nil or mergeInfo.donotMerge then
    for index,para in ipairs(paras) do
      if logicParaTable[index] ~= nil then
        (table.insert)(logicParaTable[index], para)
      end
    end
  else
    do
      local isMerged = false
      for groupIndex,_ in ipairs(logicParaTable[1]) do
        local couldMerge = true
        local tempParas = {}
        for paraindex,type in ipairs(mergeInfo) do
          if type == MergeType.equal then
            if (logicParaTable[paraindex])[groupIndex] ~= paras[paraindex] then
              couldMerge = false
              break
            else
              tempParas[paraindex] = (logicParaTable[paraindex])[groupIndex]
            end
          else
            if type == MergeType.add then
              tempParas[paraindex] = (logicParaTable[paraindex])[groupIndex] + paras[paraindex]
            else
              if type == MergeType.max then
                tempParas[paraindex] = (math.max)((logicParaTable[paraindex])[groupIndex], paras[paraindex])
              end
            end
          end
        end
        do
          do
            if couldMerge then
              for index,type in ipairs(mergeInfo) do
                -- DECOMPILER ERROR at PC94: Confused about usage of register: R18 in 'UnsetPending'

                (logicParaTable[index])[groupIndex] = tempParas[index]
              end
              isMerged = true
              break
            end
            -- DECOMPILER ERROR at PC99: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
      if not isMerged then
        for index,para in ipairs(paras) do
          (table.insert)(logicParaTable[index], para)
        end
      end
      do
        return logicDic
      end
    end
  end
end

CommonLogicUtil.MinLogicCfg = function(cfg, front_cfg)
  -- function num : 0_49 , upvalues : _ENV, CommonLogicUtil
  if front_cfg == nil then
    return cfg.logic, cfg.para1, cfg.para2, cfg.para3
  else
    local logic_out = {}
    local para1_out = {}
    local para2_out = {}
    local para3_out = {}
    for index,logic in ipairs(cfg.logic) do
      local paras = {(cfg.para1)[index], (cfg.para2)[index], (cfg.para3)[index]}
      local success = false
      for index,front_logic in ipairs(front_cfg.logic) do
        local tempparas = {(front_cfg.para1)[index], (front_cfg.para2)[index], (front_cfg.para3)[index]}
        if logic == front_logic then
          success = (CommonLogicUtil.MinLogic)(logic, paras, front_logic, tempparas)
        else
          success = true
        end
        if not success then
          error("common logic can\'t min")
          return cfg.logic, cfg.para1, cfg.para2, cfg.para3
        else
        end
      end
      do
        do
          if paras == nil or paras ~= nil then
            (table.insert)(logic_out, logic)
            ;
            (table.insert)(para1_out, paras[1])
            ;
            (table.insert)(para2_out, paras[2])
            ;
            (table.insert)(para3_out, paras[3])
          end
          -- DECOMPILER ERROR at PC86: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
    return logic_out, para1_out, para2_out, para3_out
  end
end

CommonLogicUtil.MinLogic = function(logic1, argList1, logic2, argList2)
  -- function num : 0_50 , upvalues : _ENV, MergeInfoTable, MergeType
  if logic1 ~= logic2 then
    warn("use diff logic to min logic1:" .. tostring(logic1) .. " logic2:" .. tostring(logic2))
    return false
  end
  local mergeInfo = MergeInfoTable[logic1]
  if mergeInfo == nil or #argList1 < #mergeInfo then
    error("not have mergeInfo or mergeInfo error")
    return false
  end
  local argList = {}
  for index,type in ipairs(mergeInfo) do
    if type == MergeType.equal then
      if argList1[index] ~= argList2[index] then
        return true, argList1
      else
        argList[index] = argList1[index]
      end
    else
      if type == MergeType.add then
        argList[index] = argList1[index] - argList2[index]
        if argList[index] == 0 then
          return true, nil
        end
      else
        if type == MergeType.max then
          argList[index] = argList1[index] - argList2[index]
          if argList[index] == 0 then
            return true, nil
          end
        end
      end
    end
  end
  return true, argList
end

local LoopLvFunc = {[eLogicType.Activity_AttriAdd] = function(level, para1, para2, para3)
  -- function num : 0_51
  return para1, para2 * level, para3
end
, [eLogicType.Activity_InitialItemAdd] = function(level, para1, para2, para3)
  -- function num : 0_52
  return para1, para2, para3 * level
end
}
CommonLogicUtil.GetLoopLevelPara = function(level, logic, para1, para2, para3)
  -- function num : 0_53 , upvalues : LoopLvFunc, _ENV
  local func = LoopLvFunc[logic]
  if func == nil then
    error("Unsupported LoopLvFunc, logic = " .. tostring(logic))
    return para1, para2, para3
  end
  return func(level, para1, para2, para3)
end

CommonLogicUtil.GetMergeInfoTable = function(logic)
  -- function num : 0_54 , upvalues : MergeInfoTable, MergeType
  return MergeInfoTable[logic], MergeType
end

return CommonLogicUtil

