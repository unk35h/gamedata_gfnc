-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSetHero = class("UINAdjEditorSetHero", UIBaseNode)
local base = UIBaseNode
local UINAdjEditorSetHeroIcon = require("Game.AdjCustom.AdjEdit.UINAdjEditorSetHeroIcon")
local UINSortButtonGroup = require("Game.Hero.NewUI.SortList.UINSortButtonGroup")
local HeroSortEnum = require("Game.Hero.NewUI.HeroSortEnum")
local HeroFilterEnum = require("Game.Hero.NewUI.HeroFilterEnum")
local UINAdjCareerFilterItem = require("Game.AdjCustom.AdjEdit.UINAdjCareerFilterItem")
local CS_UnityEngine_GameObject = (CS.UnityEngine).GameObject
local CS_ResLoader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
UINAdjEditorSetHero.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSortButtonGroup, HeroSortEnum, UINAdjCareerFilterItem, HeroFilterEnum
  self._isInInit = true
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.__OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.__OnClickCancle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Filter, self, self.__OnClickFilter)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_close_filter, self, self.__OnClickCloseFilter)
  ;
  (((self.ui).img_HeadItemSel).gameObject):SetActive(false)
  self._sortFunc = nil
  self._sortBtnGroup = (UINSortButtonGroup.New)()
  ;
  (self._sortBtnGroup):Init((self.ui).sortButtonGroup)
  ;
  (self._sortBtnGroup):InitSortButtonGroup(HeroSortEnum.SortMannerDefine, BindCallback(self, self.__OnClickSort), (HeroSortEnum.eSortResource).adjSelect, {[1] = (HeroSortEnum.eSortMannerType).Rank, [2] = (HeroSortEnum.eSortMannerType).GetOrder})
  self.__OnClickHeadItemCallback = BindCallback(self, self.__OnClickHeadItem)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroHeadList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC84: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroHeadList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).heroHeadList).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self._heroList = {}
  self._heroHeadDic = {}
  self._heroGoDic = {}
  self.__SetFilterCallback = BindCallback(self, self.__SetFilter)
  self._careerFilterPool = (UIItemPool.New)(UINAdjCareerFilterItem, (self.ui).sortKindItem)
  ;
  (((self.ui).sortKindItem).gameObject):SetActive(false)
  local careerCount = (HeroFilterEnum.eKindMaxCount)[(HeroFilterEnum.eKindType).Career]
  for i = 1, careerCount do
    local item = (self._careerFilterPool):GetOne()
    item:InitAdjCareerFilterItem(i, self.__SetFilterCallback)
  end
  ;
  ((self.ui).sortConditionNode):SetActive(false)
  self._defaultConfirmColor = ((self.ui).img_confirm).color
end

UINAdjEditorSetHero.InitUINAdjEditorSetHero = function(self, editMain)
  -- function num : 0_1
  self._editMain = editMain
  self._isInInit = nil
end

UINAdjEditorSetHero.UpdateUINAdjEditorSetHero = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local modifyIndex = (self._editMain):GetAdjModifyIndex()
  ;
  ((self.ui).sortConditionNode):SetActive(false)
  self._filterCareer = nil
  for _,item in ipairs(self._careerFilterPool) do
    item:SetSelectState(false)
  end
  self:__CreateSortList()
  self:__RefreshConfirmState()
  ;
  (((self.ui).btn_Cancel).gameObject):SetActive((self._editMain):IsAdjCacheInModify())
  for i,v in ipairs((self._careerFilterPool).listItem) do
    v:ResetAdjCareerFilterItem()
  end
end

UINAdjEditorSetHero.__CreateSortList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (table.removeall)(self._heroList)
  for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
    if self:__FilterHeroList(heroData) then
      (table.insert)(self._heroList, heroData)
    end
  end
  if self._sortFunc ~= nil then
    (table.sort)(self._heroList, self._sortFunc)
  else
    ;
    (table.sort)(self._heroList, function(a, b)
    -- function num : 0_3_0
    do return a.dataId < b.dataId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
  local total = #self._heroList
  if total > 0 then
    local selectIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
    local curModifyIndex = (self._editMain):GetAdjModifyIndex()
    if selectIndexDic[curModifyIndex] == nil then
      local heroId = ((self._heroList)[1]).dataId
      ;
      (self._editMain):SetAdjEditHero(heroId, true)
    end
  end
  do
    ;
    ((self.ui).img_HeadItemSel):SetActive(false)
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).heroHeadList).totalCount = total
    ;
    ((self.ui).heroHeadList):RefillCells()
  end
end

UINAdjEditorSetHero.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINAdjEditorSetHeroIcon
  local heroHead = (UINAdjEditorSetHeroIcon.New)()
  heroHead:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._heroGoDic)[go] = heroHead
end

UINAdjEditorSetHero.__OnChangeItem = function(self, go, index)
  -- function num : 0_5 , upvalues : _ENV
  local selectIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
  local curModifyIndex = (self._editMain):GetAdjModifyIndex()
  local heroHead = (self._heroGoDic)[go]
  local oriHeroId = heroHead:GetAdjHeroIconId()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R7 in 'UnsetPending'

  if (self._heroHeadDic)[oriHeroId] == heroHead then
    (self._heroHeadDic)[oriHeroId] = nil
    if (((self.ui).img_HeadItemSel).transform).parent == heroHead.transform then
      ((self.ui).img_HeadItemSel):SetActive(false)
    end
  end
  local heroData = (self._heroList)[index + 1]
  heroHead:InitAdjSetHeroIcon(heroData.dataId, self.__OnClickHeadItemCallback)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self._heroHeadDic)[heroData.dataId] = heroHead
  if selectIndexDic[curModifyIndex] == heroData.dataId then
    heroHead:SetAdjHeroIconUsedState(false)
    ;
    (((self.ui).img_HeadItemSel).transform):SetParent(heroHead.transform)
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).img_HeadItemSel).transform).localPosition = Vector3.zero
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).img_HeadItemSel).transform).localScale = Vector3.one
    ;
    ((self.ui).img_HeadItemSel):SetActive(true)
  else
    heroHead:SetAdjHeroIconUsedState((self._editMain):IsAdjHeroIdInPreset(heroData.dataId))
  end
end

UINAdjEditorSetHero.__OnReturnItem = function(self, go)
  -- function num : 0_6
  local heroHead = (self._heroGoDic)[go]
  local oriHeroId = heroHead:GetAdjHeroIconId()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  if (self._heroHeadDic)[oriHeroId] == heroHead then
    (self._heroHeadDic)[oriHeroId] = nil
  end
  if (((self.ui).img_HeadItemSel).transform).parent == go.transform then
    ((self.ui).img_HeadItemSel):SetActive(false)
  end
end

UINAdjEditorSetHero.__OnClickSort = function(self, sortFunc)
  -- function num : 0_7
  self._sortFunc = sortFunc
  if self._isInInit then
    return 
  end
  self:__CreateSortList()
end

UINAdjEditorSetHero.__OnClickHeadItem = function(self, heroId)
  -- function num : 0_8 , upvalues : _ENV
  local selectIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
  local curModify = (self._editMain):GetAdjModifyIndex()
  local selectHead = (self._heroHeadDic)[heroId]
  if selectHead == nil then
    return 
  end
  local heroHeadTr = selectHead.transform
  if selectIndexDic[curModify] == heroId then
    (self._editMain):SetAdjEditHero(heroId, false)
    ;
    ((self.ui).img_HeadItemSel):SetActive(false)
  else
    if not (self._editMain):IsAdjHeroIdInPreset(heroId) then
      (self._editMain):SetAdjEditHero(heroId, true)
      ;
      (((self.ui).img_HeadItemSel).transform):SetParent(heroHeadTr)
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_HeadItemSel).transform).localPosition = Vector3.zero
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).img_HeadItemSel).transform).localScale = Vector3.one
      ;
      ((self.ui).img_HeadItemSel):SetActive(true)
    end
  end
  self:__RefreshConfirmState()
end

UINAdjEditorSetHero.__OnClickFilter = function(self)
  -- function num : 0_9
  ((self.ui).sortConditionNode):SetActive(true)
end

UINAdjEditorSetHero.__OnClickCloseFilter = function(self)
  -- function num : 0_10
  ((self.ui).sortConditionNode):SetActive(false)
end

UINAdjEditorSetHero.__OnClickConfirm = function(self)
  -- function num : 0_11 , upvalues : CS_MessageCommon, _ENV
  local heroIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
  local curModifyIndex = (self._editMain):GetAdjModifyIndex()
  if curModifyIndex == 1 and heroIndexDic[curModifyIndex] == nil then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(403))
    return 
  end
  if curModifyIndex ~= 1 and heroIndexDic[curModifyIndex] == nil and not (self._editMain):IsAdjCacheInModify() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(403))
    return 
  end
  if heroIndexDic[curModifyIndex] == nil then
    (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).Operation)
  else
    ;
    (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).SetSkin)
  end
end

UINAdjEditorSetHero.__RefreshConfirmState = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local heroIndexDic = (self._editMain):GetAdjEditAdjIndexDic()
  local curModifyIndex = (self._editMain):GetAdjModifyIndex()
  local canContinue = heroIndexDic[curModifyIndex] ~= nil
  canContinue = canContinue or not (self._editMain):IsAdjCacheInModify() or curModifyIndex ~= 1
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  if not canContinue or not self._defaultConfirmColor then
    ((self.ui).img_confirm).color = Color.gray
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINAdjEditorSetHero.__OnClickCancle = function(self)
  -- function num : 0_13
  (self._editMain):ResetAdjCache()
  ;
  (self._editMain):AdjEditJumpSubNode(((self._editMain).subType).Operation)
end

UINAdjEditorSetHero.__FilterHeroList = function(self, heroData)
  -- function num : 0_14 , upvalues : _ENV
  if self._filterCareer == nil or (table.count)(self._filterCareer) == 0 then
    return true
  end
  return (self._filterCareer)[heroData.career]
end

UINAdjEditorSetHero.__SetFilter = function(self, index, select)
  -- function num : 0_15
  if select then
    if self._filterCareer == nil then
      self._filterCareer = {}
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._filterCareer)[index] = true
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

    if self._filterCareer ~= nil then
      (self._filterCareer)[index] = nil
    end
  end
  self:__CreateSortList()
end

UINAdjEditorSetHero.OnDelete = function(self)
  -- function num : 0_16 , upvalues : base
  (base.OnDelete)(self)
end

return UINAdjEditorSetHero

