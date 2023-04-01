-- params : ...
-- function num : 0 , upvalues : _ENV
local UI_HBHeroHeroList = class("UI_HBHeroHeroList", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
local UIN_HBHeroHeroListHeroItem = require("Game.HandBook.UI.Hero.UIN_HBHeroHeroListHeroItem")
UI_HBHeroHeroList.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resloader = (cs_ResLoader.Create)()
  self.handBookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook, true)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroLoopList).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroLoopList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__heroItemDic = {}
  self.__onClickHeroItem = BindCallback(self, self.__OnClickHeroItem)
  self.__reshow = BindCallback(self, self.__ReshowTween)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ToInfo, self, self.__OnClickCampInfo)
end

UI_HBHeroHeroList.InitHBHeroHeroList = function(self, campId)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__OnClickBack)
  self.campId = campId
  self:__RefreshCampInfo()
  self:RefreshHeroCollect()
  self:__RefreshHeroHeads()
  self:__EnterTween()
end

UI_HBHeroHeroList.__RefreshCampInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.__showingCampId == self.campId then
    (self.handBookCtrl):SetHBViewSetLayer(2, ((self.ui).tex_Camp).text)
    return 
  end
  self.__showingCampId = self.campId
  local campCfg = (ConfigData.camp)[self.campId]
  ;
  (((self.ui).img_CampIcon).gameObject):SetActive(false)
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCampPicPath(campCfg.icon), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_CampIcon).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_CampIcon).texture = texture
  end
)
  local name = (LanguageUtil.GetLocaleText)(campCfg.name)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Camp).text = name
  ;
  (self.handBookCtrl):SetHBViewSetLayer(2, name)
end

UI_HBHeroHeroList.RefreshHeroCollect = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local collectRate, totalNum = (self.handBookCtrl):GetCampHeroCollectNum(self.campId)
  ;
  ((self.ui).tex_Count):SetIndex(0, tostring(collectRate), tostring(totalNum))
end

UI_HBHeroHeroList.__RefreshHeroHeads = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if not ((ConfigData.camp).camp2HeroListDic)[self.campId] then
    self.__heroList = {}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).heroLoopList).totalCount = #self.__heroList
    ;
    ((self.ui).heroLoopList):RefillCells()
  end
end

UI_HBHeroHeroList.__OnNewItem = function(self, go)
  -- function num : 0_5 , upvalues : UIN_HBHeroHeroListHeroItem
  local heroHeadItem = (UIN_HBHeroHeroListHeroItem.New)()
  heroHeadItem:Init(go)
  heroHeadItem:InitHBHeroHeadItem(self.__onClickHeroItem)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__heroItemDic)[go] = heroHeadItem
end

UI_HBHeroHeroList.__OnChangeItem = function(self, go, index)
  -- function num : 0_6 , upvalues : _ENV
  local heroHeadItem = (self.__heroItemDic)[go]
  if heroHeadItem == nil then
    error("Can\'t find heroHeadItem by gameObject")
    return 
  end
  local heroId = (self.__heroList)[index + 1]
  if heroId == nil then
    error("Can\'t find heroId by index, index = " .. tostring(index))
    return 
  end
  heroHeadItem:RefreshHBHeroHeadItem(heroId)
end

UI_HBHeroHeroList.__GetItemGoByIndex = function(self, index)
  -- function num : 0_7
  local go = ((self.ui).heroLoopList):GetCellByIndex(index - 1)
  if go ~= nil then
    return (self.__heroItemDic)[go]
  end
  return nil
end

UI_HBHeroHeroList.__GetItemByHeroId = function(self, theHeroId)
  -- function num : 0_8 , upvalues : _ENV
  for index,heroId in ipairs(self.__heroList) do
    if heroId == theHeroId then
      return self:__GetItemGoByIndex(index)
    end
  end
end

UI_HBHeroHeroList.__OnClickHeroItem = function(self, heroId)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon
  if not PlayerDataCenter:ContainsHeroData(heroId) then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8301))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HandbookHeroRelation, function(win)
    -- function num : 0_9_0 , upvalues : self, heroId
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

    ((self.ui).layoutGroup_rect).enabled = false
    local headItem = self:__GetItemByHeroId(heroId)
    ;
    (headItem.gameObject):SetActive(false)
    win:InitHBHeroHeroRelation(heroId, self.resloader, self.__reshow)
    win:PlayFromListTween((headItem.transform).position)
    self:__PlayOutTween(function()
      -- function num : 0_9_0_0 , upvalues : self, headItem
      self:Hide()
      ;
      (headItem.gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).layoutGroup_rect).enabled = true
    end
)
  end
)
end

UI_HBHeroHeroList.__OnClickCampInfo = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local campCfg = (ConfigData.camp)[self.campId]
  AudioManager:PlayAudioById(campCfg.camp_info_audio)
  self:__PlayOutTween(function()
    -- function num : 0_10_0 , upvalues : _ENV, self
    UIManager:ShowWindowAsync(UIWindowTypeID.HandBookCampInfo, function(win)
      -- function num : 0_10_0_0 , upvalues : self
      win:InitHBCampInfo(self.campId, self.resloader, self.__reshow)
      self:Hide()
    end
)
  end
)
end

UI_HBHeroHeroList.HBHLOnHeroSkinChange = function(self, changeHeroId)
  -- function num : 0_11 , upvalues : _ENV
  for _,heroId in pairs(self.__heroList) do
    if changeHeroId == heroId then
      local headItem = self:__GetItemByHeroId(heroId)
      if headItem ~= nil then
        headItem:RefreshHBHeroHeadItem(heroId)
      end
    end
  end
end

UI_HBHeroHeroList.__PlayOutTween = function(self, callback, isBackwards)
  -- function num : 0_12 , upvalues : cs_DoTween, _ENV, cs_Ease
  self.__outTweenOverCallback = callback
  self.__outTweenOverisBackwards = isBackwards
  do
    if self.__sequence == nil then
      local sequence = (cs_DoTween.Sequence)()
      sequence:AppendCallback(function()
    -- function num : 0_12_0 , upvalues : self, _ENV
    if self.__outTweenOverisBackwards then
      (UIUtil.CloseOneCover)("UI_HBHeroHeroList")
    else
      ;
      (UIUtil.AddOneCover)("UI_HBHeroHeroList")
    end
  end
)
      sequence:Append((((self.ui).cg_main):DOFade(0, 0.2)):SetEase(cs_Ease.OutQuart))
      sequence:Join((((self.ui).rect_main):DOScale(0.8, 0.2)):SetEase(cs_Ease.OutQuart))
      sequence:AppendCallback(function()
    -- function num : 0_12_1 , upvalues : self, _ENV
    if self.__outTweenOverCallback ~= nil then
      (self.__outTweenOverCallback)()
    end
    if self.__outTweenOverisBackwards then
      (UIUtil.AddOneCover)("UI_HBHeroHeroList")
    else
      ;
      (UIUtil.CloseOneCover)("UI_HBHeroHeroList")
    end
  end
)
      sequence:SetAutoKill(false)
      sequence:Pause()
      self.__sequence = sequence
    end
    if isBackwards then
      (self.__sequence):PlayBackwards()
    else
      ;
      (self.__sequence):Restart()
    end
  end
end

UI_HBHeroHeroList.__ReshowTween = function(self)
  -- function num : 0_13
  self:Show()
  ;
  (self.handBookCtrl):SetHBViewSetLayer(2, ((self.ui).tex_Camp).text)
  self:__PlayOutTween(nil, true)
end

UI_HBHeroHeroList.__EnterTween = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local order = 0
  for index,value in ipairs(self.__heroList) do
    local headItem = self:__GetItemGoByIndex(index)
    if headItem ~= nil then
      order = order + 1
      headItem:HBHeroHeadPlayBlinkTween(order)
    end
  end
end

UI_HBHeroHeroList.__OnClickBack = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (UIManager:ShowWindow(UIWindowTypeID.HandBookHeroCampIndex)):HBCIPlayEnterTween()
  ;
  (self.handBookCtrl):SetHBViewSetLayer(1)
  self:Hide()
end

UI_HBHeroHeroList.OnShow = function(self)
  -- function num : 0_16
end

UI_HBHeroHeroList.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV
  for index,value in ipairs(self.__heroList) do
    local headItem = self:__GetItemGoByIndex(index)
    if headItem ~= nil then
      headItem:Delete()
    end
  end
  if self.__sequence ~= nil then
    (self.__sequence):Kill()
    self.__sequence = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
  end
end

return UI_HBHeroHeroList

