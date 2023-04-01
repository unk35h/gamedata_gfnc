-- params : ...
-- function num : 0 , upvalues : _ENV
local NewUIHeroList = class("NewUIHeroList", UIBaseWindow)
local base = UIBaseWindow
local HeroFilterEnum = require("Game.Hero.NewUI.HeroFilterEnum")
local HeroSortEnum = require("Game.Hero.NewUI.HeroSortEnum")
local HeroListStateEnum = require("Game.Hero.NewUI.HeroListStateEnum")
local UINHeroSortList = require("Game.Hero.NewUI.SortList.UINHeroSortList")
local UINSortButtonGroup = require("Game.Hero.NewUI.SortList.UINSortButtonGroup")
local UINSiftCondition = require("Game.Hero.NewUI.SortList.UINSiftCondition")
local UINHeroListFavorHeroNode = require("Game.Hero.NewUI.UINHeroListFavorHeroNode")
local cs_ResLoader = CS.ResLoader
local cs_DoTween = ((CS.DG).Tweening).DOTween
NewUIHeroList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self:__InitUI()
  self:__InitData()
  self:SetHeroListTweens()
  self.__onHeroListUpdate = BindCallback(self, self.__OnHeroListUpdate)
  self.__siftFunction = BindCallback(self, self.__SiftFunction)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__onHeroListUpdate)
end

NewUIHeroList.__InitUI = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnReturnClicked, nil, nil, nil)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Filter, self, self.__OnBtnFilterClick)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_ShowAllHero, self, self.__OnClickShowAllHeroTog)
  ;
  (((self.ui).tog_ShowAllHero).gameObject):SetActive(true)
  ;
  ((self.ui).sortConditionNode):SetActive(false)
  ;
  (((self.ui).btn_Comfirm).gameObject):SetActive(false)
  self:ShowHeroCollection()
end

NewUIHeroList.__InitData = function(self)
  -- function num : 0_2 , upvalues : cs_ResLoader, _ENV, HeroListStateEnum
  self.resloader = (cs_ResLoader.Create)()
  self.__returnEvent = nil
  self.__onSelHeroItemClick = BindCallback(self, self.OnSelHeroItemClick)
  self.__onFilterConfirmAction = BindCallback(self, self.__OnFilterConfirmAction)
  self.__onBtnSortItemClick = BindCallback(self, self.__OnBtnSortItemClick)
  self.__heroListFlag = (HeroListStateEnum.eHeroListFlag).none
  self:__InitHeroList()
  self:__InitSortButtonGroup()
  self:__InitFavorHeroNode()
  self:InitRedDotEvent()
end

NewUIHeroList.ChangeHeroListFlage = function(self, isAdd, flagEnum)
  -- function num : 0_3
  if isAdd then
    self.__heroListFlag = self.__heroListFlag | flagEnum
  else
    self.__heroListFlag = self.__heroListFlag & ~flagEnum
  end
  if self.heroSortList == nil then
    self:__InitHeroList()
  end
  ;
  (self.heroSortList):RefreshHeroSortList(self.__siftFunction, nil, self.__heroListFlag)
  ;
  (self.favorHeroNode):OnHeroListFlageChange(self.__heroListFlag)
end

NewUIHeroList.__OnHeroListUpdate = function(self, heroList)
  -- function num : 0_4
  self:ShowHeroCollection()
end

NewUIHeroList.InitRedDotEvent = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.__onHeroCardRedDotEvent = function(node)
    -- function num : 0_5_0 , upvalues : self
    local heroItem = (self.heroSortList):__GetHeroItemById(node.nodeId)
    if node:GetRedDotCount() <= 0 then
      heroItem:SetRedDotActive(heroItem == nil)
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end

  RedDotController:AddListener(RedDotDynPath.HeroCardPath, self.__onHeroCardRedDotEvent)
end

NewUIHeroList.RemoveRedDotEvent = function(self)
  -- function num : 0_6 , upvalues : _ENV
  RedDotController:RemoveListener(RedDotDynPath.HeroCardPath, self.__onHeroCardRedDotEvent)
end

NewUIHeroList.SetReturnEvent = function(self, returnEvent)
  -- function num : 0_7
  self.__returnEvent = returnEvent
end

NewUIHeroList.OnReturnClicked = function(self)
  -- function num : 0_8
  if self.__returnEvent ~= nil then
    (self.__returnEvent)()
    self.__returnEvent = nil
  else
    self:CloseSelf()
  end
end

NewUIHeroList.__InitHeroList = function(self)
  -- function num : 0_9 , upvalues : UINHeroSortList, _ENV
  if self.heroSortList == nil then
    local HeroSortList = (UINHeroSortList.New)()
    HeroSortList:Init(((self.ui).heroListFade).gameObject)
    HeroSortList:SetShowRedDotActive(true)
    HeroSortList:InitHeroSortList(self.resloader, nil, self.__onSelHeroItemClick, true, nil, false, nil, nil, true, true)
    HeroSortList:ShowHeroPower(true)
    self.heroSortList = HeroSortList
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.heroSortList).ui).scrollRest).onReturnItem = function(go)
    -- function num : 0_9_0 , upvalues : self, _ENV
    if ((self.ui).head).constraintActive then
      local heroItem = ((self.heroSortList).heroItemDic)[go]
      local heroData = heroItem.heroData
      local index = (table.indexof)((self.heroSortList).curHeroList, heroData)
      -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

      if index == 1 then
        ((self.ui).head).constraintActive = false
      end
    end
  end

    ;
    (self.heroSortList):SetChangeItemCallback(function(index)
    -- function num : 0_9_1 , upvalues : self
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

    if index == 1 then
      ((self.ui).head).constraintActive = true
    end
  end
)
  end
end

NewUIHeroList.OnSelHeroItemClick = function(self, heroData, selectItem)
  -- function num : 0_10 , upvalues : HeroListStateEnum, _ENV
  if heroData == nil then
    return 
  end
  if (HeroListStateEnum.isHaveFlag)(self.__heroListFlag, (HeroListStateEnum.eHeroListFlag).editorFavor) then
    local heroId = heroData.dataId
    local isFavorHero = (PlayerDataCenter.favorHeroData):IsFavorHero(heroId)
    if isFavorHero then
      (PlayerDataCenter.favorHeroData):SetIsFavorHero(heroId, false)
      selectItem:SetSelectActive(false)
    else
      ;
      (PlayerDataCenter.favorHeroData):SetIsFavorHero(heroId, true)
      selectItem:SetSelectActive(true, nil, true)
    end
    return 
  end
  do
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroState, function(windows)
    -- function num : 0_10_0 , upvalues : _ENV, heroData, self
    if windows == nil then
      error((LanguageUtil.GetLocaleText)(heroData.name) .. "Click can\'t show state")
      return 
    end
    local heroList = {}
    for index,heroData in ipairs((self.heroSortList).curHeroList) do
      if not heroData.isLockedHero then
        (table.insert)(heroList, heroData)
      end
    end
    windows:InitHeroState(heroData, heroList, function()
      -- function num : 0_10_0_0 , upvalues : self, _ENV
      (self.heroSortList):RefreshHeroSortList(self.__siftFunction, nil, self.__heroListFlag, true)
      for go,heroItem in pairs((self.heroSortList).heroItemDic) do
        heroItem:RefreshHeroCardItem()
        heroItem:RefreshFightPower()
      end
    end
)
    windows:RegistFromeWindowTypeID(UIWindowTypeID.HeroList)
    TimerManager:StartTimer(1, function()
      -- function num : 0_10_0_1 , upvalues : _ENV
      local parWin = UIManager:GetWindow(UIWindowTypeID.HeroList)
      if parWin ~= nil then
        parWin:Hide()
      end
    end
, nil, true, true, true)
  end
)
  end
end

NewUIHeroList.__InitSortButtonGroup = function(self)
  -- function num : 0_11 , upvalues : UINSortButtonGroup, HeroSortEnum
  if self.sortButtonGroup == nil then
    local sortButtonGroup = (UINSortButtonGroup.New)()
    sortButtonGroup:Init((self.ui).buttonGroup)
    sortButtonGroup:InitSortButtonGroup(HeroSortEnum.SortMannerDefine, self.__onBtnSortItemClick, (HeroSortEnum.eSortResource).heroList)
    self.sortButtonGroup = sortButtonGroup
  end
end

NewUIHeroList.__InitFavorHeroNode = function(self)
  -- function num : 0_12 , upvalues : UINHeroListFavorHeroNode
  self.favorHeroNode = (UINHeroListFavorHeroNode.New)()
  ;
  (self.favorHeroNode):Init((self.ui).favorHeroBindHelper)
  ;
  (self.favorHeroNode):InitFavorHeroNode(self)
  ;
  (self.favorHeroNode):OnHeroListFlageChange(self.__heroListFlag)
end

NewUIHeroList.__OnBtnSortItemClick = function(self, sortFunc)
  -- function num : 0_13
  if self.heroSortList == nil then
    self:__InitHeroList()
  end
  ;
  (self.heroSortList):RefreshHeroSortList(self.__siftFunction, sortFunc, self.__heroListFlag)
end

NewUIHeroList.__OnBtnFilterClick = function(self)
  -- function num : 0_14 , upvalues : UINSiftCondition, HeroFilterEnum
  do
    if self.siftCondition == nil then
      local SiftConditionPage = (UINSiftCondition.New)()
      SiftConditionPage:Init((self.ui).sortConditionNode)
      SiftConditionPage:InitSiftCondition(HeroFilterEnum.eKindType, HeroFilterEnum.eKindMaxCount, self.__onFilterConfirmAction)
      self.siftCondition = SiftConditionPage
    end
    ;
    (self.siftCondition):Show()
  end
end

NewUIHeroList.__OnClickShowAllHeroTog = function(self, bool)
  -- function num : 0_15 , upvalues : HeroListStateEnum
  self:ChangeHeroListFlage(bool, (HeroListStateEnum.eHeroListFlag).showLocked)
end

NewUIHeroList.__OnFilterConfirmAction = function(self, sortKindData)
  -- function num : 0_16
  self.sortKindData = sortKindData
  if self.heroSortList == nil then
    self:__InitHeroList()
  end
  ;
  (self.heroSortList):RefreshHeroSortList(self.__siftFunction, nil, self.__heroListFlag)
  ;
  (self.favorHeroNode):OnHeroListFlageChange(self.__heroListFlag)
end

NewUIHeroList.__SiftFunction = function(self, heroData)
  -- function num : 0_17 , upvalues : HeroListStateEnum, _ENV, HeroFilterEnum
  local isShowFavor = (HeroListStateEnum.isHaveFlag)(self.__heroListFlag, (HeroListStateEnum.eHeroListFlag).showFavor)
  local isEditorFavor = (HeroListStateEnum.isHaveFlag)(self.__heroListFlag, (HeroListStateEnum.eHeroListFlag).editorFavor)
  if heroData.isLockedHero and (isEditorFavor or isShowFavor) then
    return false
  end
  if not isEditorFavor and isShowFavor and not (PlayerDataCenter.favorHeroData):IsFavorHero(heroData.dataId) then
    return false
  end
  if self.sortKindData == nil then
    return true
  end
  local rareConfig = (self.sortKindData)[(HeroFilterEnum.eKindType).Rank]
  local Star = (math.floor)(heroData.rank / 2)
  if Star == 0 then
    Star = 1
  end
  if not rareConfig.nocondition then
    local rankOk = (rareConfig.selectIndexs)[Star]
  end
  if not rankOk then
    return false
  end
  local campConfig = (self.sortKindData)[(HeroFilterEnum.eKindType).Camp]
  if not campConfig.nocondition then
    local campOk = (campConfig.selectIndexs)[heroData.camp]
  end
  if not campOk then
    return false
  end
  local careerConfig = (self.sortKindData)[(HeroFilterEnum.eKindType).Career]
  if not careerConfig.nocondition then
    local careerOk = (careerConfig.selectIndexs)[heroData.career]
  end
  if not careerOk then
    return false
  end
  return true
end

NewUIHeroList.ShowHeroCollection = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local totalCount = (ConfigData.hero_data).totalHeroCount
  local collectRate = 0
  collectRate = (math.ceil)(PlayerDataCenter.heroCount / totalCount * 100)
  ;
  (((self.ui).tex_Trim).gameObject):SetActive(collectRate / 100 > 0)
  ;
  ((self.ui).tex_Collect):SetIndex(0, tostring(collectRate))
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

NewUIHeroList.SetHeroListTweens = function(self)
  -- function num : 0_19 , upvalues : cs_DoTween
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).decorFade).alpha = 0
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroListFade).alpha = 0
  self.pageSequence = (cs_DoTween.Sequence)()
  ;
  (self.pageSequence):Append((((self.ui).decorFade):DOFade(1, 0.1)):SetLoops(3))
  ;
  (self.pageSequence):Append(((self.ui).heroListFade):DOFade(1, 0.15))
  ;
  (self.pageSequence):SetDelay(0.1)
  ;
  (self.pageSequence):SetAutoKill(false)
end

NewUIHeroList.DeleteHeroListTweens = function(self)
  -- function num : 0_20
  if self.pageSequence ~= nil then
    (self.pageSequence):Kill()
    self.pageSequence = nil
  end
end

NewUIHeroList.Roll2Hero = function(self, heroId)
  -- function num : 0_21 , upvalues : _ENV
  local targetIndex = nil
  for index,heroData in ipairs((self.heroSortList).curHeroList) do
    if heroData.dataId == heroId then
      targetIndex = index - 1
      return 
    end
  end
  ;
  (self.heroSortList):SrollToCell(targetIndex, 5000)
end

NewUIHeroList.CloseSelf = function(self)
  -- function num : 0_22
  self:Delete()
end

NewUIHeroList.Delete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
  self:OnCloseWin()
  do
    if self.fromType == eBaseWinFromWhere.home then
      local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWin ~= nil then
        AudioManager:RemoveAllVoice()
      end
    end
    ;
    (base.Delete)(self)
  end
end

NewUIHeroList.OnDelete = function(self)
  -- function num : 0_24 , upvalues : _ENV, base
  self:RemoveRedDotEvent()
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__onHeroListUpdate)
  MsgCenter:Broadcast(eMsgEventId.UIHeroListClosed)
  if self.sortButtonGroup ~= nil then
    (self.sortButtonGroup):Delete()
  end
  if self.siftCondition ~= nil then
    (self.siftCondition):Delete()
  end
  if self.heroSortList ~= nil then
    (self.heroSortList):Delete()
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (PlayerDataCenter.favorHeroData):CleanFavorHeroBuffDic()
  ;
  (self.favorHeroNode):Delete()
  self:DeleteHeroListTweens()
  ;
  (base.OnDelete)(self)
end

return NewUIHeroList

