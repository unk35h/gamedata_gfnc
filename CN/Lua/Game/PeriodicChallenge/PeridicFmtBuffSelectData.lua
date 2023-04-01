-- params : ...
-- function num : 0 , upvalues : _ENV
local PeridicFmtBuffSelectData = class("PeridicFmtBuffSelectData")
PeridicFmtBuffSelectData.CreateFmtBuffByWc = function(id, wcCfg, serverCfg)
  -- function num : 0_0 , upvalues : PeridicFmtBuffSelectData, _ENV
  local data = (PeridicFmtBuffSelectData.New)()
  data._buffDic = {}
  ;
  (table.merge)(data._buffDic, serverCfg.initBuffId)
  ;
  (table.merge)(data._buffDic, serverCfg.assistBuffId)
  data._assistBuffIdDic = serverCfg.assistBuffId
  data._buffGroup = wcCfg.buffGroup
  data._explorationBuffDic = serverCfg.exploreBuffId
  data._groupOrder = wcCfg.groupOrder
  data._groupNameDic = wcCfg.group_name
  data._baseRecommandPower = ((ConfigData.game_config).weeklyRecommandPower)[id] or 0
  data._rateRecommandPower = (ConfigData.game_config).weeklyRecommandPowerEffectRate or 0
  data._buffScoreValueDic = ConfigData.weekly_challenge_warning
  data._enemyPowerRatePerLevel = (ConfigData.game_config).wcEnemyPowerRatePerLevel
  data._title = ConfigData:GetTipContent(13005)
  data._intro = ConfigData:GetTipContent(TipContent.WeeklyDebuffIntro)
  data._isShowEmenyPower = true
  data:__CalculateBuffSum()
  return data
end

PeridicFmtBuffSelectData.CreateFmtBuffByADC = function(adcData, dungeonId)
  -- function num : 0_1 , upvalues : PeridicFmtBuffSelectData, _ENV
  local data = (PeridicFmtBuffSelectData.New)()
  local adcDunCfg = (adcData:GetADCDungeonCfg())[dungeonId]
  data._buffDic = {}
  ;
  (table.merge)(data._buffDic, adcDunCfg.init_buff_id)
  ;
  (table.merge)(data._buffDic, adcDunCfg.assist_buff)
  data._assistBuffIdDic = adcDunCfg.assist_buff
  data._buffGroup = adcDunCfg.buffGroup
  data._groupOrder = adcDunCfg.groupOrder
  data._groupNameDic = adcDunCfg.group_name
  data._baseRecommandPower = 0
  data._rateRecommandPower = 0
  data._buffScoreValueDic = ConfigData.weekly_challenge_warning
  data._enemyPowerRatePerLevel = 0
  data._title = ConfigData:GetTipContent(8415)
  data._intro = ConfigData:GetTipContent(8416)
  data:__CalculateBuffSum()
  return data
end

PeridicFmtBuffSelectData.SetSelectCallback = function(self, selectSaveFunc)
  -- function num : 0_2
  self._selectSaveFunc = selectSaveFunc
end

PeridicFmtBuffSelectData.SetDefaultSelect = function(self, buffDic)
  -- function num : 0_3 , upvalues : _ENV
  local buffIds = {}
  for k,_ in pairs(buffDic) do
    if (self._buffDic)[k] ~= nil or (self._assistBuffIdDic)[k] ~= nil then
      (table.insert)(buffIds, k)
    end
  end
  self:SetFmtBuffSelect(buffIds)
end

PeridicFmtBuffSelectData.__CalculateBuffSum = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._buffSum = 0
  local groupMaxVlaueDic = {}
  for buffId,value in pairs(self._buffDic) do
    if value > 0 then
      local groupId = (self._buffGroup)[buffId]
      if groupId == nil then
        self._buffSum = self._buffSum + value
      else
        if groupMaxVlaueDic[groupId] == nil or groupMaxVlaueDic[groupId] < value then
          groupMaxVlaueDic[groupId] = value
        end
      end
    end
  end
  for _,value in pairs(groupMaxVlaueDic) do
    self._buffSum = self._buffSum + value
  end
  if self._explorationBuffDic ~= nil then
    for _,value in pairs(self._explorationBuffDic) do
      if value > 0 then
        self._buffSum = self._buffSum + value
      end
    end
  end
end

PeridicFmtBuffSelectData.SetFmtBuffSelect = function(self, buffIds)
  -- function num : 0_5 , upvalues : _ENV
  self._curScore = 0
  self._lastBuffSelects = buffIds
  if self._lastBuffSelects == nil then
    return 
  end
  for _,buffId in ipairs(self._lastBuffSelects) do
    self._curScore = self._curScore + self:GetFmtBuffEffect(buffId)
  end
  if self._selectSaveFunc ~= nil then
    local buffDic = {}
    for _,buffId in ipairs(buffIds) do
      buffDic[buffId] = true
    end
    ;
    (self._selectSaveFunc)(buffDic)
  end
end

PeridicFmtBuffSelectData.GetFmtBuffSelect = function(self)
  -- function num : 0_6
  return self._lastBuffSelects
end

PeridicFmtBuffSelectData.GetFmtAllBuff = function(self)
  -- function num : 0_7
  return self._buffDic
end

PeridicFmtBuffSelectData.GetFmtBuffEffect = function(self, buffId)
  -- function num : 0_8
  if (self._buffDic)[buffId] ~= nil then
    return (self._buffDic)[buffId]
  end
  if self._explorationBuffDic == nil then
    return 0
  end
  return (self._explorationBuffDic)[buffId] or 0
end

PeridicFmtBuffSelectData.IsFmtEffectBuff = function(self, buffId)
  -- function num : 0_9
  if (self._buffDic)[buffId] ~= nil then
    return true
  end
  if (self._explorationBuffDic)[buffId] == nil then
    do return self._explorationBuffDic == nil end
    do return false end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

PeridicFmtBuffSelectData.GetFmtBuffHighestSum = function(self)
  -- function num : 0_10
  return self._buffSum
end

PeridicFmtBuffSelectData.IsFmtBuffAssis = function(self, buffId)
  -- function num : 0_11
  do return self._assistBuffIdDic ~= nil and (self._assistBuffIdDic)[buffId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

PeridicFmtBuffSelectData.GetFmtBuffGroupId = function(self, buffId)
  -- function num : 0_12
  return (self._buffGroup)[buffId] or 0
end

PeridicFmtBuffSelectData.GetFmtBuffGroupOrder = function(self)
  -- function num : 0_13
  return self._groupOrder
end

PeridicFmtBuffSelectData.GetFmtBuffGroupName = function(self, groupId)
  -- function num : 0_14
  if self._groupNameDic == nil then
    return ""
  end
  return (self._groupNameDic)[groupId] or ""
end

PeridicFmtBuffSelectData.GetFmtBuffRecomPowerBase = function(self)
  -- function num : 0_15
  return self._baseRecommandPower
end

PeridicFmtBuffSelectData.GetFmtBuffRecomPowerRate = function(self)
  -- function num : 0_16
  return self._rateRecommandPower
end

PeridicFmtBuffSelectData.GetFmtBuffCurAddScoreRate = function(self)
  -- function num : 0_17
  return self._curScore
end

PeridicFmtBuffSelectData.GetFmtBuffTitle = function(self)
  -- function num : 0_18
  return self._title
end

PeridicFmtBuffSelectData.GetFmtBuffIntro = function(self)
  -- function num : 0_19
  return self._intro
end

PeridicFmtBuffSelectData.GetBuffScoreWarningValue = function(self, level)
  -- function num : 0_20 , upvalues : _ENV
  local warnValueCfg = (self._buffScoreValueDic)[level]
  if warnValueCfg ~= nil then
    return warnValueCfg.warning_level
  end
  return math.maxinteger
end

PeridicFmtBuffSelectData.GetBuffEmenyPower = function(self, layer, level)
  -- function num : 0_21 , upvalues : _ENV
  local layerRate = 1 + layer * self._rateRecommandPower
  local enemyRate = 1 + (level - 1) * self._enemyPowerRatePerLevel
  return (math.floor)(self._baseRecommandPower * layerRate * enemyRate)
end

PeridicFmtBuffSelectData.IsShowEmenyPowerInFmtBuff = function(self)
  -- function num : 0_22
  return self._isShowEmenyPower
end

return PeridicFmtBuffSelectData

