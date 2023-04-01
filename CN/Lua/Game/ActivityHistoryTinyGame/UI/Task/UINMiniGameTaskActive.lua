-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTaskActive = class("UINMiniGameTaskOnce", UIBaseNode)
local base = UIBaseNode
local UINMiniGameTaskActiveItem = require("Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTaskActiveItem")
UINMiniGameTaskActive.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMiniGameTaskActiveItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).down, self, self.__OnClickReviewAll)
  self._taskPool = (UIItemPool.New)(UINMiniGameTaskActiveItem, (self.ui).cupItem)
  ;
  ((self.ui).cupItem):SetActive(false)
  self.__OnClickReviewSingleCallback = BindCallback(self, self.__OnClickReviewSingle)
end

UINMiniGameTaskActive.InitMiniGameTaskActive = function(self, actTinyData)
  -- function num : 0_1 , upvalues : _ENV
  self._actTinyData = actTinyData
  ;
  (self._taskPool):HideAll()
  local pointCfg = (self._actTinyData):GetTGActiveCfg()
  ;
  (self._taskPool):HideAll()
  for i,single in ipairs(pointCfg) do
    local item = (self._taskPool):GetOne()
    item:InitMiniGameTaskOnceItem(self._actTinyData, single, self.__OnClickReviewSingleCallback)
  end
  self:__RefreshBtnState()
end

UINMiniGameTaskActive.RefreshMiniGameTaskActive = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self._taskPool).listItem) do
    v:RefreshMiniGameTaskOnceItem()
  end
  self:__RefreshBtnState()
end

UINMiniGameTaskActive.__RefreshBtnState = function(self)
  -- function num : 0_3
  local level = (self._actTinyData):GetActiveLevel()
  for i = 1, level do
    if (self._actTinyData):IsTinyGameActiveCanReward(i) then
      (((self.ui).down).gameObject):SetActive(true)
      return 
    end
  end
  ;
  (((self.ui).down).gameObject):SetActive(false)
end

UINMiniGameTaskActive.__OnClickReviewAll = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self._actTinyData):ReqHTGActiveReward(true, 0, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshMiniGameTaskActive()
    end
  end
)
end

UINMiniGameTaskActive.__OnClickReviewSingle = function(self, level)
  -- function num : 0_5 , upvalues : _ENV
  (self._actTinyData):ReqHTGActiveReward(false, level, function()
    -- function num : 0_5_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefreshMiniGameTaskActive()
    end
  end
)
end

return UINMiniGameTaskActive

