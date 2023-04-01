-- params : ...
-- function num : 0 , upvalues : _ENV
local UINNotifySettingNode = class("UINNotifySettingNode", UIBaseNode)
local base = UIBaseNode
local UINNotifySettingItemGroup = require("Game.Setting.UI.UINNotifySettingItemGroup")
UINNotifySettingNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINNotifySettingItemGroup
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.noticeTypePool = (UIItemPool.New)(UINNotifySettingItemGroup, (self.ui).obj_Notice_Type)
  ;
  ((self.ui).obj_Notice_Type):SetActive(false)
end

UINNotifySettingNode.InitNotifySettingNode = function(self, noticeSwitchOffDic)
  -- function num : 0_1 , upvalues : _ENV
  (self.noticeTypePool):HideAll()
  local notifyTypeList = {}
  for noticeId,homesideSwitchCfg in pairs(ConfigData.homeside_switch) do
    (table.insert)(notifyTypeList, homesideSwitchCfg)
  end
  ;
  (table.sort)(notifyTypeList, function(a, b)
    -- function num : 0_1_0
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for _,homesideSwitchCfg in ipairs(notifyTypeList) do
    local notifyList = {}
    for _,homesideInfoCfg in pairs(ConfigData.homeside_info) do
      if homesideInfoCfg.switch_type == homesideSwitchCfg.id and homesideInfoCfg.info_type ~= 0 and (homesideInfoCfg.unlock_for_setting == 0 or FunctionUnlockMgr:ValidateUnlock(homesideInfoCfg.unlock_for_setting)) then
        (table.insert)(notifyList, homesideInfoCfg)
      end
    end
    if #notifyList > 0 then
      (table.sort)(notifyList, function(a, b)
    -- function num : 0_1_1
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
      local item = (self.noticeTypePool):GetOne()
      item:InitNotifySettingGroup(homesideSwitchCfg, noticeSwitchOffDic, notifyList)
    end
  end
end

UINNotifySettingNode.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINNotifySettingNode

