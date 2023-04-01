-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22EnvDetail = class("UINCarnival22EnvDetail", UIBaseNode)
local base = UIBaseNode
local UINCarnival22EnvDetailItem = require("Game.ActivityCarnival.UI.CarnivalSelect.UINCarnival22EnvDetailItem")
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
UINCarnival22EnvDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCarnival22EnvDetailItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self.OnClickHide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.OnClickHide)
  self._itemPool = (UIItemPool.New)(UINCarnival22EnvDetailItem, (self.ui).theme)
  ;
  ((self.ui).theme):SetActive(false)
  self.__OnClickEnvSelectCallback = BindCallback(self, self.OnClickEnvSelect)
end

UINCarnival22EnvDetail.InitEnvDetail = function(self, carnivalData, envId, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._carnivalData = carnivalData
  self._sortEnvList = {}
  self._clickFunc = clickFunc
  for i,envCfg in ipairs((self._carnivalData):GetCarnivalEnvCfg()) do
    (table.insert)(self._sortEnvList, envCfg)
  end
  self._count = #self._sortEnvList
  self:OpenEnvDetail(envId)
end

UINCarnival22EnvDetail.OpenEnvDetail = function(self, envId)
  -- function num : 0_2 , upvalues : _ENV
  (table.sort)(self._sortEnvList, function(a, b)
    -- function num : 0_2_0 , upvalues : self
    local aUnlock = (self._carnivalData):IsCarnivalUnlockEnv(a.id)
    local bUnlock = (self._carnivalData):IsCarnivalUnlockEnv(b.id)
    if aUnlock ~= bUnlock then
      return aUnlock
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (self._itemPool):HideAll()
  for i,envCfg in ipairs(self._sortEnvList) do
    local item = (self._itemPool):GetOne()
    item:InitEnvDetailItem(self._carnivalData, envCfg, i == self._count, self.__OnClickEnvSelectCallback)
    item:SetEvnDetailItemCurrent(envId == envCfg.id)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINCarnival22EnvDetail.OnClickEnvSelect = function(self, envId)
  -- function num : 0_3
  if self._clickFunc ~= nil then
    (self._clickFunc)(envId)
    self:OnClickHide()
  end
end

UINCarnival22EnvDetail.OnShow = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnShow)(self)
  ;
  (UIUtil.SetTopStatus)(self, self.Hide)
end

UINCarnival22EnvDetail.OnHide = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnHide)(self)
end

UINCarnival22EnvDetail.OnClickHide = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

return UINCarnival22EnvDetail

