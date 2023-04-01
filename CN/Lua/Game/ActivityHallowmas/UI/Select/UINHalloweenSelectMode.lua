-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenSelectMode = class("UINHalloweenSelectMode", UIBaseNode)
local base = UIBaseNode
local UINHalloweenSelectModeItem = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectModeItem")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local cs_MessageCommon = CS.MessageCommon
UINHalloweenSelectMode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHalloweenSelectModeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if not IsNull((self.ui).btn_Back) then
    (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickCloseMode)
  end
  self._itemPool = (UIItemPool.New)(UINHalloweenSelectModeItem, (self.ui).modeItems)
  ;
  ((self.ui).modeItems):SetActive(false)
  self.__OnSelectItemCallback = BindCallback(self, self.__OnSelectItem)
end

UINHalloweenSelectMode.InitHalloweenSelectMode = function(self, hallowmasData, envId, selectCallback, closeCallback)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._data = hallowmasData
  self._selectCallback = selectCallback
  self._closeCallback = closeCallback
  ;
  (self._itemPool):HideAll()
  local stageInfoCfgs = (self._data):GetHallowmasStageInfoCfg()
  for i,cfg in ipairs(stageInfoCfgs) do
    if envId or 0 == 0 or (self._data):IsHallowmasEnvDiffcultyExist(envId, cfg.difficulty_id) then
      local item = (self._itemPool):GetOne()
      item:InitModelItem(cfg, self.__OnSelectItemCallback)
      item:SetModelColor(cfg.difficulty_color + 1)
      item:SetModelItemUnLocke((self._data):IsHallowmasDiffUnlock(cfg.difficulty_id))
    end
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(self.transform)
  local defaultSelect = ((self._itemPool).listItem)[1]
  self:__OnSelectItem(defaultSelect)
  local saveData = WarChessSeasonManager:GetWCSSavingData()
  if saveData == nil or (table.count)(saveData) <= 0 then
    (((self.ui).btn_Back).gameObject):SetActive(IsNull((self.ui).btn_Back))
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINHalloweenSelectMode.__OnSelectItem = function(self, item)
  -- function num : 0_2 , upvalues : _ENV, cs_MessageCommon
  local diffcultyInfoCfg = item:GetModeItemDiffInfoCfg()
  if not (self._data):IsHallowmasDiffUnlock(diffcultyInfoCfg.difficulty_id) then
    local conditionList = diffcultyInfoCfg.preConditions
    local unlockStr = nil
    if diffcultyInfoCfg.preConditionsNum > 1 then
      unlockStr = (CheckCondition.GetUnlockInfoLuaByManyList)(conditionList)
    else
      if diffcultyInfoCfg.preConditionsNum == 1 then
        local firstCond = conditionList[1]
        unlockStr = (CheckCondition.GetUnlockInfoLua)(firstCond[1], firstCond[2], firstCond[3])
      end
    end
    do
      do
        ;
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8708, unlockStr))
        do return  end
        self._selectDiffId = diffcultyInfoCfg.difficulty_id
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

        ;
        (((self.ui).select).transform).anchoredPosition = (item.transform).anchoredPosition
        ;
        ((self.ui).select):SetActive(true)
        if self._selectCallback ~= nil then
          (self._selectCallback)()
        end
      end
    end
  end
end

UINHalloweenSelectMode.GetSelectHallowDiffId = function(self)
  -- function num : 0_3
  return self._selectDiffId
end

UINHalloweenSelectMode.OnClickCloseMode = function(self)
  -- function num : 0_4
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

return UINHalloweenSelectMode

