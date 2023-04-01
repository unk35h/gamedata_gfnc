-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Tech.UIChristmas22StrategyOverview")
local UISpring23StrategyOverview = class("UISpring23StrategyOverview", base)
UISpring23StrategyOverview.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (((self.ui).list).onValueChanged):AddListener(BindCallback(self, self.OnValueChange))
end

UISpring23StrategyOverview.__SetNodeClass = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self._techItemClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechItem")
  self._techTitleClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechTitle")
  self._specialListClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechSpecialList")
  self._specialSideClass = require("Game.ActivitySpring.UI.Tech.UINSpring23TechSpeicalSide")
  self._techLvClass = require("Game.ActivitySpring.UI.Tech.UINSpring23TechLv")
  self._desType = eLogicDesType.Spring
  self._lvNodeOffset = 20
  self._itemNoEnoughTip = 9109
  self._resetNoEnoughTip = 9110
end

UISpring23StrategyOverview.OnClickLvCallback = function(self, techItem, techData)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnClickLvCallback)(self, techItem, techData)
  ;
  ((self.ui).obj_OnSelelct):SetActive(true)
  ;
  (((self.ui).obj_OnSelelct).transform):SetParent(techItem.transform)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_OnSelelct).transform).anchoredPosition = Vector2.zero
end

UISpring23StrategyOverview.OnClickBg = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnClickBg)(self)
  ;
  ((self.ui).obj_OnSelelct):SetActive(false)
end

UISpring23StrategyOverview.OnValueChange = function(self, vecPos)
  -- function num : 0_4 , upvalues : _ENV
  local vecPointY = vecPos.y
  if self._lastPointY ~= nil and (math.abs)(vecPointY - self._lastPointY) < 0.001 then
    self._lastPointY = vecPointY
    return 
  end
  self._lastPointY = vecPointY
  if self._lvNode ~= nil and (self._lvNode).active then
    self:OnClickBg()
  end
end

return UISpring23StrategyOverview

