-- params : ...
-- function num : 0 , upvalues : _ENV
local UILogicPreviewNodeBase = require("Game.CommonUI.LogicPreviewNode.UILogicPreviewNodeBase")
local UINAttrOutLineWindow = class("UINHeroStateSkillItem", UILogicPreviewNodeBase)
local base = UILogicPreviewNodeBase
local UINAttrIntroItem = require("Game.Formation.UI.Common.UINHeroAttrIntroItem")
local UINAttrOutLineRowItem = require("Game.CommonUI.Hero.Attr.UINAttrOutLineRowItem")
UINAttrOutLineWindow.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, UINAttrOutLineRowItem
  (base.OnInit)(self)
  ;
  (base.InitWithClass)(self, nil, UINAttrOutLineRowItem)
  ;
  (self.headAttrPool):HideAll()
  ;
  (self.rowItemPool):HideAll()
end

UINAttrOutLineWindow.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  (UIUtil.SetTopStatus)(self, base._Close)
  ;
  (base.OnShow)(self)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).verticalNormalizedPosition = 1
  ;
  (UIUtil.HideTopStatus)()
end

UINAttrOutLineWindow.OnHide = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.Hide)(self)
  ;
  (UIUtil.ReShowTopStatus)()
  AudioManager:PlayAudioById(1068)
  local heroStateWin = UIManager:GetWindow(UIWindowTypeID.HeroState)
  if heroStateWin ~= nil and heroStateWin.active then
    heroStateWin:AddAllTouch()
  end
end

UINAttrOutLineWindow.OnUpdateAttrData = function(self, name, attrDataList)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tex_SkillName):SetIndex(2, name)
  if attrDataList == nil then
    return 
  end
  self.attrDataList = attrDataList
  ;
  (self.rowItemPool):HideAll()
  for index = 1, #self.attrDataList do
    local rowItem = (self.rowItemPool):GetOne()
    local curData = (self.attrDataList)[index]
    local iconSprite = CRH:GetSprite(curData.icon)
    rowItem:InitAttrOutLineRowItem(curData.name, iconSprite, (curData.attrValueStrs)[1], (curData.attrValueStrs)[2], curData.isRecommend)
    rowItem:InjectPressAndUpFunc(BindCallback(self, self.__onAttrPressDown, curData.attrId, iconSprite, rowItem.transform), BindCallback(self, self.__onAttrPressUp))
  end
end

UINAttrOutLineWindow.__onAttrPressDown = function(self, valueId, iconSprite, itemTrans)
  -- function num : 0_4 , upvalues : UINAttrIntroItem
  local velocitySqr = (((self.ui).scrollRect).velocity).sqrMagnitude
  if velocitySqr > 0 then
    return 
  end
  if self.uiAttrIntro == nil then
    self.uiAttrIntro = (UINAttrIntroItem.New)()
    ;
    (self.uiAttrIntro):Init((self.ui).uINAttrPopDetail)
  end
  ;
  (self.uiAttrIntro):ShowAttrPopIntro(valueId, iconSprite)
  ;
  ((self.uiAttrIntro).transform):SetParent(itemTrans, false)
  ;
  (self.uiAttrIntro):Show()
end

UINAttrOutLineWindow.__onAttrPressUp = function(self)
  -- function num : 0_5
  if self.uiAttrIntro ~= nil then
    (self.uiAttrIntro):Hide()
  end
end

UINAttrOutLineWindow.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self.uiAttrIntro ~= nil then
    (self.uiAttrIntro):Hide()
    ;
    (self.uiAttrIntro):OnDelete()
  end
  ;
  (base.OnDelete)(self)
end

return UINAttrOutLineWindow

