-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenSelectArchive = class("UINHalloweenSelectArchive", UIBaseNode)
local base = UIBaseNode
local UINHalloweenSelectArchiveItem = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectArchiveItem")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UINHalloweenSelectArchive.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHalloweenSelectArchiveItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).newGameItem, self, self.OnClickNewArchive)
  self._itemPool = (UIItemPool.New)(UINHalloweenSelectArchiveItem, (self.ui).checkPointItems)
  ;
  ((self.ui).checkPointItems):SetActive(false)
  self.__OnSelectArchiveCallback = BindCallback(self, self.__OnSelectArchive)
  for i,v in ipairs((self.ui).selectObjs) do
    v:SetActive(false)
  end
end

UINHalloweenSelectArchive.InitHalloweenSelectArchive = function(self, hallowmasData, selectCallback)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._data = hallowmasData
  self._selectCallback = selectCallback
  local seasonDatas = WarChessSeasonManager:GetWCSSavingData()
  local saveCount = ((self._data):GetHallowmasMainCfg()).max_save
  for i = 1, saveCount do
    local item = (self._itemPool):GetOne()
    local seasonData = seasonDatas ~= nil and seasonDatas[i - 1] or nil
    item:InitSelectArchiveItem(self._data, i, seasonData, self.__OnSelectArchiveCallback)
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(self.transform)
end

UINHalloweenSelectArchive.SetFileNameByEnvName = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetFileNameByEnvName()
  end
end

UINHalloweenSelectArchive.__OnSelectArchive = function(self, item)
  -- function num : 0_3 , upvalues : _ENV
  local archive = item:GetArchiveData()
  if archive == nil then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Frame).color = Color.white
  self._selectArchive = archive
  self._selectNewGame = nil
  if self._selectCallback ~= nil then
    (self._selectCallback)()
  end
end

UINHalloweenSelectArchive.OnClickNewArchive = function(self)
  -- function num : 0_4
  self._selectArchive = nil
  self._selectNewGame = true
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Frame).color = (self.ui).color_selected
  if self._selectCallback ~= nil then
    (self._selectCallback)()
  end
end

UINHalloweenSelectArchive.__SetSelectObjs = function(self, localPosition)
  -- function num : 0_5
end

UINHalloweenSelectArchive.GetArchiveSelect = function(self)
  -- function num : 0_6
  return self._selectNewGame, self._selectArchive
end

return UINHalloweenSelectArchive

