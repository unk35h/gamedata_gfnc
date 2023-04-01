-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGameSetPanel = class("UINGameSetPanel", UIBaseNode)
local base = UIBaseNode
local UINGameSetTypeItem = require("Game.Setting.UI.UINGameSetTypeItem")
UINGameSetPanel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINGameSetTypeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.typeItemPool = (UIItemPool.New)(UINGameSetTypeItem, (self.ui).obj_type)
  ;
  ((self.ui).obj_type):SetActive(false)
end

UINGameSetPanel.InitGameSetPanel = function(self, ctrl)
  -- function num : 0_1
  self.setCtrl = ctrl
  self:__RefreshAllTypes()
end

UINGameSetPanel.__RefreshAllTypes = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self.typeItemPool):HideAll()
  for groupId,groupCfg in ipairs(ConfigData.game_set_group) do
    if #groupCfg.order > 0 then
      local typeItem = (self.typeItemPool):GetOne()
      typeItem:InitGameSetTypeItem(self.setCtrl, groupCfg)
    end
  end
end

UINGameSetPanel.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINGameSetPanel

