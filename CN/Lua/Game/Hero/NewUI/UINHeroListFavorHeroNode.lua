-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroListFavorHeroNode = class("UINHeroListFavorHeroNode", UIBaseNode)
local base = UIBaseNode
local HeroListStateEnum = require("Game.Hero.NewUI.HeroListStateEnum")
UINHeroListFavorHeroNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_FollowHero, self, self.__OnFavorHeroTogChange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BatchFollow, self, self.__OnClickEditFavor)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonYes, self, self.__OnClickEditYes)
  ;
  (UIUtil.AddButtonListener)((self.ui).buttonNo, self, self.__OnClickEditNo)
end

UINHeroListFavorHeroNode.InitFavorHeroNode = function(self, newUIHeroList)
  -- function num : 0_1
  self.newUIHeroList = newUIHeroList
end

UINHeroListFavorHeroNode.OnHeroListFlageChange = function(self, flag)
  -- function num : 0_2 , upvalues : HeroListStateEnum
  local isShowFavor = (HeroListStateEnum.isHaveFlag)(flag, (HeroListStateEnum.eHeroListFlag).showFavor)
  local isEditorFavor = (HeroListStateEnum.isHaveFlag)(flag, (HeroListStateEnum.eHeroListFlag).editorFavor)
  local showFavorBg = isShowFavor or isEditorFavor
  ;
  ((self.ui).img_FavorBg):SetActive(showFavorBg)
  local isShowEmpty = #((self.newUIHeroList).heroSortList).curHeroList <= 0
  ;
  ((self.ui).img_FollowEmpty):SetActive(isShowEmpty)
  ;
  ((self.ui).tex_Empty):SetIndex(isShowFavor and 0 or 1)
  if isShowFavor then
    (((self.ui).btn_BatchFollow).gameObject):SetActive(not isEditorFavor)
    ;
    ((self.ui).yesNoNode):SetActive(isEditorFavor)
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

UINHeroListFavorHeroNode.__OnFavorHeroTogChange = function(self, bool)
  -- function num : 0_3 , upvalues : _ENV, HeroListStateEnum
  if bool then
    if PlayerDataCenter.favorHeroData == nil then
      error("can\'t get favorHeroData")
      return 
    end
    ;
    (self.newUIHeroList):ChangeHeroListFlage(true, (HeroListStateEnum.eHeroListFlag).showFavor)
  else
    if PlayerDataCenter.favorHeroData ~= nil then
      (PlayerDataCenter.favorHeroData):CleanFavorHeroBuffDic()
    end
    ;
    (self.newUIHeroList):ChangeHeroListFlage(false, (HeroListStateEnum.eHeroListFlag).showFavor | (HeroListStateEnum.eHeroListFlag).editorFavor)
    ;
    ((self.newUIHeroList).heroSortList):SetAllFavorHero()
  end
end

UINHeroListFavorHeroNode.__OnClickEditFavor = function(self)
  -- function num : 0_4 , upvalues : HeroListStateEnum
  (self.newUIHeroList):ChangeHeroListFlage(true, (HeroListStateEnum.eHeroListFlag).editorFavor)
  ;
  ((self.newUIHeroList).heroSortList):SetAllFavorHero()
end

UINHeroListFavorHeroNode.__OnClickEditYes = function(self)
  -- function num : 0_5 , upvalues : _ENV, HeroListStateEnum
  (PlayerDataCenter.favorHeroData):ApplyFavorHeroBuffDic()
  ;
  (PlayerDataCenter.favorHeroData):CleanFavorHeroBuffDic()
  ;
  (self.newUIHeroList):ChangeHeroListFlage(false, (HeroListStateEnum.eHeroListFlag).editorFavor)
  ;
  ((self.newUIHeroList).heroSortList):SetAllFavorHero()
end

UINHeroListFavorHeroNode.__OnClickEditNo = function(self)
  -- function num : 0_6 , upvalues : _ENV, HeroListStateEnum
  (PlayerDataCenter.favorHeroData):CleanFavorHeroBuffDic()
  ;
  (self.newUIHeroList):ChangeHeroListFlage(false, (HeroListStateEnum.eHeroListFlag).editorFavor)
  ;
  ((self.newUIHeroList).heroSortList):SetAllFavorHero()
end

UINHeroListFavorHeroNode.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINHeroListFavorHeroNode

