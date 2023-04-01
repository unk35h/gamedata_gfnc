-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23ModeSelectEnvNode = class("UINSpring23ModeSelectEnvNode", UIBaseNode)
local base = UIBaseNode
local UINSpring23ModeSelectEnvItem = require("Game.ActivitySpring.UI.SelectLevel.UINSpring23ModeSelectEnvItem")
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
UINSpring23ModeSelectEnvNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSpring23ModeSelectEnvItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINSpring23ModeSelectEnvItem, (self.ui).environmentSelectNode)
  ;
  ((self.ui).environmentSelectNode):SetActive(false)
end

UINSpring23ModeSelectEnvNode.InitSpring23EnvNode = function(self, actSpringData, selectCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = actSpringData
  self._selectCallback = selectCallback
  ;
  (self._itemPool):HideAll()
  local list = (self._data):GetSpringLevelEnvs()
  for _,env_id in ipairs(list) do
    local item = (self._itemPool):GetOne()
    local envCfg = (ConfigData.activity_spring_advanced_env)[env_id]
    item:InitSpring23EnvItem(self._data, envCfg, self._selectCallback)
  end
end

UINSpring23ModeSelectEnvNode.RefreshSpring23EnvNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for i,envItem in ipairs((self._itemPool).listItem) do
    envItem:RefreshChristmas22EnvItem()
    local actId = (self._data):GetActId()
    local envId = envItem:GetSpring23EnvId()
    local isHaveNotEnteredNewEnv = userDataCache:GetSpring23IsNotEnteredNewEnv(actId, envId)
    envItem:SetSpring23EnvBlueDot(isHaveNotEnteredNewEnv)
  end
end

UINSpring23ModeSelectEnvNode.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINSpring23ModeSelectEnvNode

