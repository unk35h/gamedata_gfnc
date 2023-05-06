-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.Tech.UISpring23StrategyOverview")
local UIWinter23StrategyOverview = class("UIWinter23StrategyOverview", base)
local UINCommonActivityBG = require("Game.ActivityFrame.UI.UINCommonActivityBG")
UIWinter23StrategyOverview.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINCommonActivityBG
  (base.OnInit)(self)
  ;
  (self._sideNode):SetSpItemClick(BindCallback(self, self.OnClickSpItemDetail))
  ;
  (self._sideNode):SetTechInfoHideFunc(BindCallback(self, self.OnClickBg))
  self._actBgNode = (UINCommonActivityBG.New)()
  ;
  (self._actBgNode):Init((self.ui).uI_CommonActivityBG)
end

UIWinter23StrategyOverview.__SetNodeClass = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self._techItemClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechItem")
  self._techTitleClass = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechTitle")
  self._specialSideClass = require("Game.ActivityWinter23.UI.Tech.UINWinter23TechSpecialSide")
  self._techLvClass = require("Game.ActivitySpring.UI.Tech.UINSpring23TechLv")
  self._lvNodeOffset = 20
  self._desType = eLogicDesType.Winter23
  self._itemNoEnoughTip = 9204
  self._resetNoEnoughTip = 9205
end

UIWinter23StrategyOverview.InitChristmas22StrategyOverview = function(self, actTechTree, specialBranchId, callback)
  -- function num : 0_2 , upvalues : base
  (base.InitChristmas22StrategyOverview)(self, actTechTree, specialBranchId, callback)
  ;
  (self._actBgNode):InitActivityBG(actTechTree:GetTechActFrameId(), self.resloader)
  self:ResetActivityBaseTechInfo(actTechTree)
end

UIWinter23StrategyOverview.ResetActivityBaseTechInfo = function(self, actTechTree)
  -- function num : 0_3 , upvalues : _ENV
  local treeId = actTechTree:GetTreeId()
  local infoCfg = (ConfigData.activity_tech_type)[treeId]
  if infoCfg.itemNoEnoughTip == 0 or not infoCfg.itemNoEnoughTip then
    self._itemNoEnoughTip = self._itemNoEnoughTip
    if infoCfg.resetNoEnoughTip == 0 or not infoCfg.resetNoEnoughTip then
      self._resetNoEnoughTip = self._resetNoEnoughTip
      if infoCfg.common_des == 0 or not infoCfg.common_des then
        self._desType = self._desType
      end
    end
  end
end

UIWinter23StrategyOverview.OnClickSpItemDetail = function(self, techItem, techData)
  -- function num : 0_4 , upvalues : _ENV
  if self._lvNode == nil then
    ((self.ui).techInfoNode):SetActive(true)
    self._lvNode = ((self._techLvClass).New)()
    ;
    (self._lvNode):Init((self.ui).techInfoNode)
    ;
    (self._lvNode):SetChristmas22LogicDesType(self._desType)
  else
    ;
    (self._lvNode):Show()
  end
  ;
  (self._lvNode):InitChristmas22TechLv(techData)
  ;
  (self._lvNode):HideChristmas22TechBtnState()
  local pos = (((self._lvNode).transform).parent):InverseTransformPoint((techItem.transform).position)
  pos.x = (self._lvNodePointRang).maxX
  pos.y = (math.clamp)(pos.y, (self._lvNodePointRang).minY, (self._lvNodePointRang).maxY)
  -- DECOMPILER ERROR at PC53: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self._lvNode).transform).localPosition = pos
  ;
  ((self.ui).obj_OnSelelct):SetActive(false)
end

return UIWinter23StrategyOverview

