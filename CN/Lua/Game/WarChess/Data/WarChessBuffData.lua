-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessBuffData = class("WarChessBuffData")
WarChessBuffData.CrearteBuffByMsg = function(buffMsg)
  -- function num : 0_0 , upvalues : WarChessBuffData
  local uid = buffMsg.uid
  local id = buffMsg.configId
  local data = (WarChessBuffData.New)(uid, id)
  return data
end

WarChessBuffData.CrearteBuffById = function(buffId)
  -- function num : 0_1 , upvalues : WarChessBuffData
  local uid = -1
  local id = buffId
  local data = (WarChessBuffData.New)(uid, id)
  if data.wcBuffCfg == nil then
    return nil
  end
  return data
end

WarChessBuffData.ctor = function(self, uid, id)
  -- function num : 0_2 , upvalues : _ENV
  self.uid = uid
  self.id = id
  self.dataId = id
  self.wcBuffCfg = (ConfigData.warchess_buff)[id]
  if self.wcBuffCfg == nil then
    error("warches buff cfg not exist id:" .. tostring(id))
  end
end

WarChessBuffData.UpdateWCBuff = function(self)
  -- function num : 0_3
end

WarChessBuffData.GetWCBuffIsNeedShow = function(self)
  -- function num : 0_4
  return (self.wcBuffCfg).is_show
end

WarChessBuffData.GetWCBuffIcon = function(self)
  -- function num : 0_5
  return (self.wcBuffCfg).icon
end

WarChessBuffData.GetWCBuffPrice = function(self)
  -- function num : 0_6
  return (self.wcBuffCfg).cost_num
end

WarChessBuffData.GetWCBuffColorType = function(self)
  -- function num : 0_7
  return (self.wcBuffCfg).color_type
end

WarChessBuffData.GetWcBuffDataCfg = function(self)
  -- function num : 0_8
  return self.wcBuffCfg
end

WarChessBuffData.GetWCBuffName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.wcBuffCfg).name)
end

WarChessBuffData.GetWCBuffDes = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.wcBuffCfg).description)
end

WarChessBuffData.GetWCBuffShowType = function(self)
  -- function num : 0_11
  return (self.wcBuffCfg).show_type
end

WarChessBuffData.GetWCBuffType = function(self)
  -- function num : 0_12
  return (self.wcBuffCfg).buff_type
end

local WCBuff2EpBuffColor = {[1] = 1, [2] = 0, [3] = 2}
WarChessBuffData.GetBuffCfg = function(self)
  -- function num : 0_13 , upvalues : WCBuff2EpBuffColor
  do
    if self._epBuffCfg == nil then
      local colorType = self:GetWCBuffColorType()
      self._epBuffCfg = {icon = self:GetWCBuffIcon(), buff_type = WCBuff2EpBuffColor[colorType] or 0, name = (self.wcBuffCfg).name, describe = (self.wcBuffCfg).description}
    end
    return self._epBuffCfg
  end
end

return WarChessBuffData

