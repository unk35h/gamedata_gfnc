-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessFXData = class("WarChessFXData")
WarChessFXData.ctor = function(self, isGrid, fxId, isOnce, isBind, data)
  -- function num : 0_0 , upvalues : _ENV
  self.__fxId = fxId
  self.__isOnce = isOnce
  self.__isBind = isBind
  self.__isGrid = isGrid
  if isGrid then
    self.__gridData = data
  else
    self.__entityData = data
  end
  self.__fxCfg = (ConfigData.warchess_fx_res)[fxId]
  if self.__fxCfg == nil then
    error("can\'t get warchess fx res cfg fxId:" .. tostring(fxId) .. (serpent.block)(data))
  end
end

WarChessFXData.GetWCFxResName = function(self)
  -- function num : 0_1
  if self.__fxCfg == nil then
    return nil
  end
  return (self.__fxCfg).prefab_res
end

WarChessFXData.GetWCFxAudioId = function(self)
  -- function num : 0_2
  if self.__fxCfg == nil then
    return nil
  end
  return (self.__fxCfg).audio_id
end

WarChessFXData.GetWCFxLogicPos = function(self)
  -- function num : 0_3
  if self.__isGrid then
    return (self.__gridData):GetGridLogicPos()
  else
    return (self.__entityData):GetEntityLogicPos()
  end
end

WarChessFXData.GetWCFXIsNotOnce = function(self)
  -- function num : 0_4
  return not self.__isOnce
end

WarChessFXData.GetWCFXIsBound = function(self)
  -- function num : 0_5
  return self.__isBind
end

WarChessFXData.GetWCFXIsNeedFillCount = function(self)
  -- function num : 0_6
  return (self.__fxCfg).need_count
end

WarChessFXData.GetWCFXCoutNum = function(self)
  -- function num : 0_7
  if self.__isGrid then
    return (self.__gridData):GetFxCount()
  else
    return (self.__entityData):GetFxCount()
  end
end

return WarChessFXData

