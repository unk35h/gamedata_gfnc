-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWCSSavePanel_Halloween22 = class("UIWCSSavePanel_Halloween22", UIBaseWindow)
local UINHalloweenSelectArchiveItem = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectArchiveItem")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UIWCSSavePanel_Halloween22.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHalloweenSelectArchiveItem
  (UIUtil.AddButtonListener)((self.ui).btn_NewGame, self, self.__OnClickSave)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Delete)
  self.itemPool = (UIItemPool.New)(UINHalloweenSelectArchiveItem, (self.ui).checkPointItems)
  ;
  ((self.ui).checkPointItems):SetActive(false)
  self.__curSelectIndex = nil
  self.__OnSelectArchiveCallback = BindCallback(self, self.__OnSelectSaving)
  self.__reGenSavingItems = BindCallback(self, self.__ReGenSavingItems)
  MsgCenter:AddListener(eMsgEventId.WCS_SavingDataRefresh, self.__reGenSavingItems)
  self._colorDefaultBottom = ((self.ui).bottom).color
end

UIWCSSavePanel_Halloween22.InitWCSSavePanel = function(self, saveCallback)
  -- function num : 0_1
  self.saveCallback = saveCallback
  self:__ReGenSavingItems()
end

UIWCSSavePanel_Halloween22.__ReGenSavingItems = function(self)
  -- function num : 0_2 , upvalues : _ENV, cs_LayoutRebuilder
  local savingDataDic = WarChessSeasonManager:GetWCSSavingData()
  local saveCount = 3
  local seasonId = WarChessSeasonManager:GetWCSSeasonId()
  local _, _, actFramData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySeasonId(seasonId)
  local actBaseData = actFramData:GetActivityData()
  ;
  (self.itemPool):HideAll()
  local selectItem = nil
  for i = 1, saveCount do
    local item = (self.itemPool):GetOne()
    local seasonData = savingDataDic ~= nil and savingDataDic[i - 1] or nil
    item:InitSelectArchiveItem(actBaseData, i, seasonData, self.__OnSelectArchiveCallback)
    item:SetFileNameByEnvName()
    if selectItem == nil and seasonData ~= nil then
      selectItem = item
    end
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).checkPointNode)
  if selectItem == nil then
    selectItem = ((self.itemPool).listItem)[1]
  end
  self:__OnSelectSaving(selectItem)
end

UIWCSSavePanel_Halloween22.__OnSelectSaving = function(self, item)
  -- function num : 0_3 , upvalues : _ENV
  self.__selectOne = item
  self.__curSelectIndex = item:GetArchiveIndex()
  self:__SetSelectObjs((item.transform).localPosition)
  local isHaveSavingData = item:GetArchiveData() ~= nil
  if isHaveSavingData then
    ((self.ui).tex_Text):SetIndex(1)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).bottom).color = Color.white
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R3 in 'UnsetPending'

    if (self.ui).color_overrideSave ~= nil then
      (((self.ui).tex_Text).text).color = (self.ui).color_overrideSave
    else
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

      (((self.ui).tex_Text).text).color = Color.black
    end
  else
    ((self.ui).tex_Text):SetIndex(0)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).bottom).color = self._colorDefaultBottom
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_Text).text).color = Color.white
  end
  for i,v in ipairs((self.itemPool).listItem) do
    v:RefreshSelectArchiveState(v == item)
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UIWCSSavePanel_Halloween22.__OnClickSave = function(self)
  -- function num : 0_4
  if self.__selectOne == nil then
    return 
  end
  local index = (self.__selectOne):GetArchiveIndex()
  if self.saveCallback ~= nil then
    (self.saveCallback)(index - 1)
    self:Delete()
  end
end

UIWCSSavePanel_Halloween22.__SetSelectObjs = function(self, localPosition)
  -- function num : 0_5 , upvalues : _ENV
  for i,v in ipairs((self.ui).selectObjs) do
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R7 in 'UnsetPending'

    (v.transform).localPosition = localPosition
    v:SetActive(true)
  end
end

UIWCSSavePanel_Halloween22.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WCS_SavingDataRefresh, self.__reGenSavingItems)
  ;
  (base.OnDelete)(self)
end

return UIWCSSavePanel_Halloween22

