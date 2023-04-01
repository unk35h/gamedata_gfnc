-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22EnvNode = class("UINChristmas22EnvNode", UIBaseNode)
local base = UIBaseNode
local UINChristmas22EnvItem = require("Game.ActivityChristmas.UI.ModeSelect.UINChristmas22EnvItem")
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
UINChristmas22EnvNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChristmas22EnvItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINChristmas22EnvItem, (self.ui).environmentSelectNode)
  ;
  ((self.ui).environmentSelectNode):SetActive(false)
end

UINChristmas22EnvNode.InitChristmas22EnvNode = function(self, hallowmasData, selectCallback, taskCallback, rankCallback)
  -- function num : 0_1 , upvalues : _ENV, ActivityHallowmasEnum
  self._data = hallowmasData
  self._selectCallback = selectCallback
  self._taskCallback = taskCallback
  self._rankCallback = rankCallback
  ;
  (self._itemPool):HideAll()
  local list = ((self._data):GetHallowmasMainCfg()).env_id
  for i,v in ipairs(list) do
    local item = (self._itemPool):GetOne()
    local envCfg = (ConfigData.activity_hallowmas_general_env)[v]
    item:InitChristmas22EnvItem(self._data, envCfg, self._selectCallback)
    item:BindChristmas22EnvCallback(self._taskCallback, self._rankCallback)
  end
  self._reddot = (self._data):GetActivityReddot()
  if self._reddot ~= nil then
    self._reddot = (self._reddot):GetChild((ActivityHallowmasEnum.reddotType).EnvTask)
  end
  if self._reddot ~= nil then
    self._reddotFunc = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
    self:__RefreshReddot(self._reddot)
  end
end

UINChristmas22EnvNode.RefreshChristmas22EnvNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    v:RefreshChristmas22EnvItem()
  end
  if self._reddot ~= nil then
    self:__RefreshReddot(self._reddot)
  end
end

UINChristmas22EnvNode.__RefreshReddot = function(self, reddot)
  -- function num : 0_3 , upvalues : _ENV
  for i,v in ipairs((self._itemPool).listItem) do
    local envId = (v:GetChristmasEnvCfg()).general_env_id
    local red = reddot:GetChild(envId)
    local redActive = red ~= nil and red:GetRedDotCount() > 0
    v:SetChristmasEnvTaskRed(redActive)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINChristmas22EnvNode.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINChristmas22EnvNode

