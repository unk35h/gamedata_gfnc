-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23ModeSelectDiffNode = class("UINSpring23ModeSelectDiffNode", UIBaseNode)
local base = UIBaseNode
local UINSpring23ModeSelectDiffItem = require("Game.ActivitySpring.UI.SelectLevel.UINSpring23ModeSelectDiffItem")
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local cs_MessageCommon = CS.MessageCommon
UINSpring23ModeSelectDiffNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23ModeSelectDiffItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  if not IsNull((self.ui).btn_Back) then
    (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickCloseMode)
  end
  self._itemPool = (UIItemPool.New)(UINSpring23ModeSelectDiffItem, (self.ui).modeItems)
  ;
  ((self.ui).modeItems):SetActive(false)
  self.__OnSelectItemCallback = BindCallback(self, self.__OnSelectItem)
end

UINSpring23ModeSelectDiffNode.InitSpring23SelectMode = function(self, actSpringData, envId, selectCallback, closeCallback)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self._data = actSpringData
  self._selectCallback = selectCallback
  self._closeCallback = closeCallback
  ;
  (self._itemPool):HideAll()
  local envCfg = (ConfigData.activity_spring_advanced_env)[envId]
  for index,diffId in ipairs(envCfg.difficulty_des) do
    local diffCfg = (ConfigData.activity_spring_difficulty)[diffId]
    if (self._data):IsSpring23EnvHaveDiff(envId, diffId, index) then
      local item = (self._itemPool):GetOne()
      local isUnlock, unlockDes = (self._data):IsSpring23DiffUnlock(envId, diffId, index)
      item:InitModelDiffItem(diffCfg, index, self.__OnSelectItemCallback)
      item:SetModelDiffItemUnLocke(isUnlock, unlockDes)
    end
  end
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(self.transform)
  local defaultSelect = ((self._itemPool).listItem)[1]
  self:__OnSelectItem(defaultSelect)
end

UINSpring23ModeSelectDiffNode.__OnSelectItem = function(self, item)
  -- function num : 0_2
  if item == nil then
    return 
  end
  if not item.isUnlock then
    return 
  end
  local diffcultyInfoCfg, index = item:GetModeItemDiffInfoCfg()
  local selectDiffId = diffcultyInfoCfg.difficulty_id
  local selectIndex = index
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).select).transform).anchoredPosition = (item.transform).anchoredPosition
  ;
  ((self.ui).select):SetActive(true)
  if self._selectCallback ~= nil then
    (self._selectCallback)(selectDiffId, selectIndex)
  end
end

UINSpring23ModeSelectDiffNode.OnClickCloseMode = function(self)
  -- function num : 0_3
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

return UINSpring23ModeSelectDiffNode

