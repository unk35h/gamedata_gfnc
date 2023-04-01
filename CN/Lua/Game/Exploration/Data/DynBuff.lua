-- params : ...
-- function num : 0 , upvalues : _ENV
local DynBuff = class("DynBuff")
DynBuff.CreateByDungeonLevel = function(dunBuffId, buffCfg)
  -- function num : 0_0 , upvalues : DynBuff
  local data = (DynBuff.New)()
  data.isDunBuff = true
  data.dataId = dunBuffId
  data.dunBuffCfg = buffCfg
  return data
end

DynBuff.CreateByEpBuffId = function(id)
  -- function num : 0_1 , upvalues : DynBuff, _ENV
  local data = (DynBuff.New)()
  data.dataId = id
  local buffCfg = (ConfigData.exploration_buff)[data.dataId]
  if buffCfg == nil then
    error("exploration buff cfg is null,id:" .. tostring(data.dataId))
    return 
  end
  data.epBuffCfg = buffCfg
  return data
end

DynBuff.ctor = function(self)
  -- function num : 0_2
  self.isDunBuff = false
end

DynBuff.InitDynEpBuffInfo = function(self, buff)
  -- function num : 0_3
  if buff.info ~= nil then
    self.expireTm = (buff.info).expireTm
    self.cnt = (buff.info).cnt
    self.durationLayer = (buff.info).durationLayer
  else
    self.expireTm = -1
    self.cnt = -1
    self.durationLayer = -1
  end
end

DynBuff.InitDynEpBuffItemId = function(self, itemId, level)
  -- function num : 0_4 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("Cant get item cfg, id = " .. tostring(itemId))
    return 
  end
  self.itemCfg = itemCfg
  self._level = level or 1
end

DynBuff.IsBuffNeedShowOnBuffList = function(self)
  -- function num : 0_5
  if self.isDunBuff then
    return not (self.dunBuffCfg).is_hide
  end
  return (self.epBuffCfg).is_listshow
end

DynBuff.GetBuffCfg = function(self)
  -- function num : 0_6
  if self.isDunBuff then
    return self.dunBuffCfg
  end
  return self.epBuffCfg
end

DynBuff.GetSpecificLogicPara = function(self, logic)
  -- function num : 0_7
  if self.isDunBuff then
    return false
  end
  if (self.epBuffCfg).logic ~= logic then
    return false
  end
  return true, (self.epBuffCfg).logic_num, (self.epBuffCfg).logic_per
end

DynBuff.GetEpBuffBuyPrice = function(self, epModuleId)
  -- function num : 0_8 , upvalues : _ENV
  local epTypeCfg = (ConfigData.exploration_type)[epModuleId]
  if epTypeCfg == nil then
    error("Cant get exploration_type cfg, epModuleId = " .. tostring(epModuleId))
    return 0
  end
  return (epTypeCfg.chip_buff_price)[self._level] or 0
end

DynBuff.GetEpBuffName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.isDunBuff then
    return (LanguageUtil.GetLocaleText)((self.dunBuffCfg).name)
  end
  return (LanguageUtil.GetLocaleText)((self.epBuffCfg).name)
end

DynBuff.GetEpBuffIcon = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.isDunBuff then
    return CRH:GetSprite((self.dunBuffCfg).icon, CommonAtlasType.ExplorationIcon)
  end
  return CRH:GetSprite((self.epBuffCfg).icon, CommonAtlasType.ExplorationIcon)
end

DynBuff.GetEpBuffDescribe = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.isDunBuff then
    return (LanguageUtil.GetLocaleText)((self.dunBuffCfg).describe)
  end
  return (LanguageUtil.GetLocaleText)((self.epBuffCfg).describe)
end

return DynBuff

