-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGameSetTypeItem = class("UINGameSetTypeItem", UIBaseNode)
local base = UIBaseNode
local UIMultiSwitchTogItem = require("Game.Setting.UI.UIMultiSwitchTogItem")
UINGameSetTypeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).item):SetActive(false)
end

UINGameSetTypeItem.InitGameSetTypeItem = function(self, setCtrl, groupCfg)
  -- function num : 0_1 , upvalues : _ENV, UIMultiSwitchTogItem
  self.setCtrl = setCtrl
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_title).text = (LanguageUtil.GetLocaleText)(groupCfg.group_name)
  local systemSaveData = (self.setCtrl):GetSystemSaveData()
  for _,id in ipairs(groupCfg.order) do
    local cfg = (ConfigData.game_set_describe)[id]
    if cfg == nil then
      error("can\'t get setting describe cfg with id:" .. tostring(id))
      return 
    end
    local strList = cfg.option_group_name
    local curValue, bindEvent = nil, nil
    if id == eGameSetDescType.chip or id == eGameSetDescType.skill then
      curValue = BindCallback(PlayerDataCenter.gameSettingData, (PlayerDataCenter.gameSettingData).GetGSIsShowDetailDescribeValue, id)
      bindEvent = BindCallback(self, self.OnToogleCallback, id)
    else
      curValue = BindCallback(systemSaveData, systemSaveData.GetMultSettingIndex, id)
      bindEvent = BindCallback(self, self.OnToogleCallback, id)
    end
    local item = (UIBaseNode.New)()
    item:Init(((self.ui).item):Instantiate(self.transform))
    ;
    (UIUtil.LuaUIBindingTable)(item.transform, item.ui)
    -- DECOMPILER ERROR at PC87: Confused about usage of register: R14 in 'UnsetPending'

    ;
    ((item.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(cfg.setting_name)
    ;
    (item.gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC98: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (item.gameObject).name = "option_" .. tostring(id)
    local itemGo = ((self.ui).tog_DisplayGroup):Instantiate(item.transform)
    itemGo:SetActive(true)
    local multiSwitchTogItem = (UIMultiSwitchTogItem.New)()
    multiSwitchTogItem:Init(itemGo)
    multiSwitchTogItem:InitUIMultiSwitchTogItem(curValue, strList, false, bindEvent, self)
    -- DECOMPILER ERROR at PC125: Confused about usage of register: R16 in 'UnsetPending'

    ;
    (multiSwitchTogItem.gameObject).name = "togGroup_" .. tostring(id)
  end
end

UINGameSetTypeItem.OnToogleCallback = function(self, id, value, togItem)
  -- function num : 0_2 , upvalues : _ENV
  if id == eGameSetDescType.chip or id == eGameSetDescType.skill then
    local isDetail = false
    if togItem.index == 0 and value then
      isDetail = false
    end
    if togItem.index == 1 and value then
      isDetail = true
    end
    ;
    (self.setCtrl):SetShowDetailDescribe(id, isDetail)
  else
    do
      if value then
        (self.setCtrl):SetGSMultSettingIndex(id, togItem.index)
      end
    end
  end
end

UINGameSetTypeItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINGameSetTypeItem

