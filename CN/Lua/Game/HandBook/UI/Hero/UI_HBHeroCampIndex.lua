-- params : ...
-- function num : 0 , upvalues : _ENV
local UI_HBHeroCampIndex = class("UI_HBHeroCampIndex", UIBaseWindow)
local base = UIBaseWindow
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
local UIN_HBHeroCampIndexItem = require("Game.Handbook.UI.Hero.UIN_HBHeroCampIndexItem")
UI_HBHeroCampIndex.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIN_HBHeroCampIndexItem
  self.handBookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
  self.__itemPool = (UIItemPool.New)(UIN_HBHeroCampIndexItem, (self.ui).obj_item)
  ;
  ((self.ui).obj_item):SetActive(false)
  self.__itemList = nil
end

UI_HBHeroCampIndex.InitHBHeroCampIndex = function(self, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  ;
  (UIUtil.SetTopStatus)(self, self.__OnClickBack)
  ;
  (self.__itemPool):HideAll()
  self.__itemList = {}
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).rect_main).enabled = true
  for campId,campCfg in ipairs(ConfigData.camp) do
    local campitem = (self.__itemPool):GetOne()
    campitem:InitCampIndexItem(campCfg, self.handBookCtrl)
    ;
    (table.insert)(self.__itemList, campitem)
  end
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)(((self.ui).rect_main).transform)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).rect_main).enabled = false
  self:HBCIPlayEnterTween()
end

UI_HBHeroCampIndex.HBCIRefreshCollectRate = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for _,campitem in ipairs(self.__itemList) do
    campitem:HBCIIRefreshCollectRate()
  end
end

UI_HBHeroCampIndex.HBCIPlayEnterTween = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local totalNum = #self.__itemList
  for index,campitem in ipairs(self.__itemList) do
    campitem:DoHBCampIndexItemZoomOutTween(index, totalNum)
  end
end

UI_HBHeroCampIndex.__OnClickBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.__itemPool):DeleteAll()
  self:Delete()
  ;
  (UIUtil.SetTopStatusBtnShow)(true, true)
  UIManager:DeleteWindow(UIWindowTypeID.HandBookCampInfo)
  UIManager:DeleteWindow(UIWindowTypeID.HandBookHeroCampHeroList)
  UIManager:DeleteWindow(UIWindowTypeID.HandbookHeroRelation)
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UI_HBHeroCampIndex

