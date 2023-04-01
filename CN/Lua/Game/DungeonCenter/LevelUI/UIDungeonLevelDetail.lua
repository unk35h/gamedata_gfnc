-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonLevelDetail = class("UIDungeonLevelDetail", UIBaseWindow)
local base = UIBaseWindow
local UINDunLevelDetail = require("Game.DungeonCenter.LevelUI.UINDunLevelDetail")
UIDungeonLevelDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDunLevelDetail
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBg)
  self.resloader = ((CS.ResLoader).Create)()
  self.dlevelDetailNode = (UINDunLevelDetail.New)()
  ;
  (self.dlevelDetailNode):Init((self.ui).detailNode)
  ;
  (self.dlevelDetailNode):BindDetailCommonData(self.resloader)
  self.isPushBack2Stack = false
  ;
  (((self.ui).tex_Tips).gameObject):SetActive(false)
end

UIDungeonLevelDetail.InitDungeonLevelDetail = function(self, dunLevelData, isLocked)
  -- function num : 0_1 , upvalues : _ENV
  self.__dunLevelData = dunLevelData
  if self.isPushBack2Stack then
    (UIUtil.PopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickDungeonLevelDetailBack, {dunLevelData:GetLevelResourceGroup()})
  self.isPushBack2Stack = true
  self:InitDungeonLevelPic()
  ;
  (self.dlevelDetailNode):InitDunLevelDetailNode(dunLevelData, isLocked)
end

UIDungeonLevelDetail.InitDungeonLevelPic = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_LevelPic).texture = (self.resloader):LoadABAsset(PathConsts:GetSectorBackgroundPath((self.__dunLevelData):GetDungeonLevelPic()))
end

UIDungeonLevelDetail.GetDLevelDetailWidthAndDuration = function(self)
  -- function num : 0_3
  return (self.dlevelDetailNode):GetDNLevelDetailWidthAndDuration()
end

UIDungeonLevelDetail.RefreshDunLevelDetaiEnterCost = function(self)
  -- function num : 0_4
  (self.dlevelDetailNode):RefreshEnterBattleCost()
  ;
  (self.dlevelDetailNode):RefreshNormalNodeReward()
end

UIDungeonLevelDetail.SetDunLevelDetaiHideStartEvent = function(self, hideEndEvent)
  -- function num : 0_5
  self.hideStartEvent = hideEndEvent
end

UIDungeonLevelDetail.SetDunLevelDetaiHideEndEvent = function(self, hideEndEvent)
  -- function num : 0_6
  self.hideEndEvent = hideEndEvent
end

UIDungeonLevelDetail.OnClickDungeonLevelDetailBack = function(self)
  -- function num : 0_7
  self.isPushBack2Stack = false
  if self.dlevelDetailNode ~= nil then
    (self.dlevelDetailNode):PlayMoveTween(false)
  end
  if self.hideStartEvent ~= nil then
    (self.hideStartEvent)()
  end
end

UIDungeonLevelDetail.SetDungeonLevelBgClose = function(self, flag)
  -- function num : 0_8
  (((self.ui).btn_Close).gameObject):SetActive(flag)
end

UIDungeonLevelDetail.OnClickBg = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIDungeonLevelDetail.OnShow = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnShow)(self)
  ;
  (self.dlevelDetailNode):OnShow()
end

UIDungeonLevelDetail.OnHide = function(self)
  -- function num : 0_11
  (self.dlevelDetailNode):OnHide()
  if self.hideEndEvent ~= nil then
    (self.hideEndEvent)()
  end
end

UIDungeonLevelDetail.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  if self.dlevelDetailNode ~= nil then
    (self.dlevelDetailNode):Delete()
    self.dlevelDetailNode = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIDungeonLevelDetail

