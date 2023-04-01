-- params : ...
-- function num : 0 , upvalues : _ENV
local DmFntThemeData = class("DmFntThemeData")
DmFntThemeData.ctor = function(self, themeCfg, inSell, editRoomData)
  -- function num : 0_0 , upvalues : _ENV
  self.dmFntThemeCfg = themeCfg
  self._editRoomData = editRoomData
  self.id = themeCfg.id
  self._inSell = inSell
  local comformt = 0
  local totalNum = 0
  for fntId,num in pairs(themeCfg.theme_furniture_id) do
    local fntCfg = (ConfigData.dorm_furniture)[fntId]
    comformt = comformt + fntCfg.comfort * num
    totalNum = totalNum + num
  end
  self._comformt = comformt
  self._totalNum = totalNum
end

DmFntThemeData.IsDmFntThemeInSell = function(self)
  -- function num : 0_1
  return self._inSell
end

DmFntThemeData.GetDmFntThemeTotalNum = function(self)
  -- function num : 0_2
  return self._totalNum
end

DmFntThemeData.GetDmFntThemeComformt = function(self)
  -- function num : 0_3
  return self._comformt
end

DmFntThemeData.GetDmFntThemeUseableNum = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local useableNum = 0
  for fntId,num in pairs((self.dmFntThemeCfg).theme_furniture_id) do
    local fntCfg = (ConfigData.dorm_furniture)[fntId]
    local storageFntData = (self._editRoomData):GetDmStorageFntData(fntId)
    if storageFntData ~= nil then
      useableNum = useableNum + (math.min)(storageFntData.count, num)
    end
  end
  return useableNum
end

return DmFntThemeData

