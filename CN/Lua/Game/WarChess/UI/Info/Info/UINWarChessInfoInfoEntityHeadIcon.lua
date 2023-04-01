-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoInfoEntityHeadIcon = class("UINWarChessInfoInfoEntityHeadIcon", base)
UINWarChessInfoInfoEntityHeadIcon.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__curHeadIconId = nil
end

UINWarChessInfoInfoEntityHeadIcon.RefreshEntityHeadIcon = function(self, iconAtlas, headIconId)
  -- function num : 0_1 , upvalues : _ENV
  if headIconId == nil then
    error("headIconId is nil")
    return 
  end
  if self.__curHeadIconId == headIconId then
    return 
  end
  self.__curHeadIconId = headIconId
  local headIconCfg = (ConfigData.warchess_icon_res)[headIconId]
  if headIconCfg == nil then
    error("headIconCfg is nil:" .. tostring(headIconId))
    return 
  end
  local iconName = headIconCfg.res_name
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_entityHeadIcon).sprite = (AtlasUtil.GetResldSprite)(iconAtlas, iconName)
end

UINWarChessInfoInfoEntityHeadIcon.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoEntityHeadIcon

