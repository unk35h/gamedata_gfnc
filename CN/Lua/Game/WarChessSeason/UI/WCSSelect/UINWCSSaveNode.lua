-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCSSaveNode = class("UINWCSSaveNode", UIBaseNode)
local base = UIBaseNode
local UINWCSSaveNodeItem = require("Game.WarChessSeason.UI.WCSSelect.UINWCSSaveNodeItem")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UINWCSSaveNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCSSaveNodeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).newGameItem, self, self.OnClickNewArchive)
  self._itemPool = (UIItemPool.New)(UINWCSSaveNodeItem, (self.ui).checkPointItems)
  ;
  ((self.ui).checkPointItems):SetActive(false)
  self.__OnSelectArchiveCallback = BindCallback(self, self.__OnSelectArchive)
  for i,v in ipairs((self.ui).selectObjs) do
    v:SetActive(false)
  end
end

UINWCSSaveNode.InitWCSSelectSaves = function(self, seasonId, selectCallback)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._selectCallback = selectCallback
  local savingDatas = WarChessSeasonManager:GetWCSSavingData()
  local saveCount = WarChessSeasonManager:GetWCSSaveNum(seasonId)
  for i = 1, saveCount do
    local item = (self._itemPool):GetOne()
    local seasonData = savingDatas ~= nil and savingDatas[i - 1] or nil
    item:InitSelectSavingItem(seasonId, i, seasonData, self.__OnSelectArchiveCallback)
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(self.transform)
end

UINWCSSaveNode.SetFileNameByEnvName = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:SetFileNameByEnvName()
  end
end

UINWCSSaveNode.__OnSelectArchive = function(self, item)
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

UINWCSSaveNode.OnClickNewArchive = function(self)
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

UINWCSSaveNode.__SetSelectObjs = function(self, localPosition)
  -- function num : 0_5
end

UINWCSSaveNode.GetArchiveSelect = function(self)
  -- function num : 0_6
  return self._selectNewGame, self._selectArchive
end

return UINWCSSaveNode

