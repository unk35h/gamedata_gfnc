-- params : ...
-- function num : 0 , upvalues : _ENV
local FormationSupportData = class("FormationSupportData")
FormationSupportData.eSupportType = {nono = 0, friend = 1, official = 2}
FormationSupportData.ctor = function(self)
  -- function num : 0_0 , upvalues : FormationSupportData
  self.__supportType = (FormationSupportData.eSupportType).nono
  self.__formIdx = nil
  self.__heroId = nil
  self.__uid = nil
  self.__officialCfgId = nil
end

FormationSupportData.ExchangeLocation = function(self)
  -- function num : 0_1
end

return FormationSupportData

