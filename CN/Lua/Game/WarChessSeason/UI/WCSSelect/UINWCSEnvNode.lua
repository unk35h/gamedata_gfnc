-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWCSEnvNode = class("UINWCSEnvNode", UIBaseNode)
local base = UIBaseNode
local UINWCSEnvNodeItem = require("Game.WarChessSeason.UI.WCSSelect.UINWCSEnvNodeItem")
UINWCSEnvNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCSEnvNodeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINWCSEnvNodeItem, (self.ui).environmentSelectNode)
  ;
  ((self.ui).environmentSelectNode):SetActive(false)
end

UINWCSEnvNode.InitWCSEnvNode = function(self, seasonId, selectCallback, taskCallback, rankCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._selectCallback = selectCallback
  self._taskCallback = taskCallback
  self._rankCallback = rankCallback
  ;
  (self._itemPool):HideAll()
  local envCfgList = WarChessSeasonManager:GetWCSEnvCfgList(seasonId)
  for _,envCfg in ipairs(envCfgList) do
    local item = (self._itemPool):GetOne()
    item:InitChristmas22EnvItem(seasonId, envCfg, self._selectCallback)
    item:BindChristmas22EnvCallback(self._taskCallback, self._rankCallback)
  end
end

UINWCSEnvNode.RefreshChristmas22EnvNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:RefreshChristmas22EnvItem()
  end
end

UINWCSEnvNode.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWCSEnvNode

