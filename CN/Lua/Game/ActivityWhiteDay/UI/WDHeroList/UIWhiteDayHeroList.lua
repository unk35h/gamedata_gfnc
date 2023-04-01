-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayHeroList = class("UIWhiteDayHeroList", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local ActivityWhiteDayUtil = require("Game.ActivityWhiteDay.ActivityWhiteDayUtil")
local UINWhiteDayHeroItem = require("Game.ActivityWhiteDay.UI.WDHeroList.UINWhiteDayHeroItem")
local UINWhiteDayShiftNodeItem = require("Game.ActivityWhiteDay.UI.WDHeroList.UINWhiteDayShiftNodeItem")
UIWhiteDayHeroList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINWhiteDayShiftNodeItem
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.__OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Screen, self, self.__OnClickShiftHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickRule)
  self.resloader = (cs_ResLoader.Create)()
  self.itemDic = {}
  self.showingHeroList = {}
  self.selectedHeroId = nil
  self.__heroAssistTypeDic = {}
  self.__shiftAssistType = nil
  self.shiftFunc = BindCallback(self, self.__DefaultShiftFunc)
  self.sortFunc = BindCallback(self, self.__DefaultSortFunc)
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopscroll).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopscroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__onClickHeroItem = BindCallback(self, self.__OnClickHeroItem)
  self.__onClickShiftHeroItem = BindCallback(self, self.__OnClickShiftHeroItem)
  self.shiftItemPool = (UIItemPool.New)(UINWhiteDayShiftNodeItem, (self.ui).obj_optionItem)
  ;
  ((self.ui).obj_optionItem):SetActive(false)
  ;
  ((self.ui).obj_screenNode):SetActive(false)
end

UIWhiteDayHeroList.InitWDHeroList = function(self, AWDCtrl, AWDData, AWDLineData, isPickPhoto, confirmCallback, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  self.AWDData = AWDData
  if not isPickPhoto then
    self.selectedHeroId = AWDLineData:GetWDLDAssistHeroID()
  else
    self.selectedHeroId = nil
  end
  ;
  (((self.ui).btn_Info).gameObject):SetActive(not isPickPhoto)
  self.isPickPhoto = isPickPhoto
  self.confirmCallback = confirmCallback
  self.closeCallback = closeCallback
  ;
  ((self.ui).obj_selectHeroNode):SetActive(isPickPhoto)
  ;
  ((self.ui).obj_shifHeroNode):SetActive(not isPickPhoto)
  do
    if isPickPhoto then
      local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(exchangeId)
    end
    self:__ShiftAndSortList()
    self:__RefreshList()
    self:__GenShiftItems()
    self:__RefreshAssistHeroEffect()
    ;
    (self.transform):SetAsLastSibling()
  end
end

UIWhiteDayHeroList.__GenShiftItems = function(self)
  -- function num : 0_2 , upvalues : ActivityWhiteDayUtil, _ENV
  ((self.ui).obj_screenNode):SetActive(false)
  if self.isPickPhoto then
    return 
  end
  ;
  (self.shiftItemPool):HideAll()
  local item = (self.shiftItemPool):GetOne()
  item:InitWDShiftItem(nil, self.__onClickShiftHeroItem)
  local assistGroup = (ActivityWhiteDayUtil.GetAssistTypes)(self.AWDData)
  for index,cfg in ipairs(assistGroup) do
    local item = (self.shiftItemPool):GetOne()
    item:InitWDShiftItem(cfg, self.__onClickShiftHeroItem)
  end
end

UIWhiteDayHeroList.__ShiftAndSortList = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityWhiteDayUtil
  self.showingHeroList = {}
  if self.isPickPhoto then
    self.__heroId2PhotoIdDic = {}
    local photoCfgs = (self.AWDData):GetWDPhotoCfgs()
    if not (self.AWDData):GetWDUnlockedPhotoDic() then
      local unlockedPhotoIdDic = table.emptytable
    end
    for photoId,photoCfg in pairs(photoCfgs) do
      if not unlockedPhotoIdDic[photoId] then
        local heroId = photoCfg.photo_hero
        local heroCfg = (ConfigData.hero_data)[heroId]
        ;
        (table.insert)(self.showingHeroList, heroCfg)
        -- DECOMPILER ERROR at PC34: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.__heroId2PhotoIdDic)[heroId] = photoId
      end
    end
  else
    do
      local underAssistHeroDic = (self.AWDData):GetWDUnderAssistHeroDic()
      for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
        if not underAssistHeroDic[heroId] then
          local heroCfg = heroData.heroCfg
          if self.shiftFunc ~= nil and (self.shiftFunc)(heroCfg) then
            (table.insert)(self.showingHeroList, heroCfg)
            -- DECOMPILER ERROR at PC68: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (self.__heroAssistTypeDic)[heroId] = (ActivityWhiteDayUtil.GetAssistHeroTypeByHeroId)(self.AWDData, heroCfg)
          end
        end
        ;
        (table.insert)(self.showingHeroList, heroCfg)
        -- DECOMPILER ERROR at PC80: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.__heroAssistTypeDic)[heroId] = (ActivityWhiteDayUtil.GetAssistHeroTypeByHeroId)(self.AWDData, heroCfg)
      end
      do
        if self.sortFunc ~= nil then
          (table.sort)(self.showingHeroList, self.sortFunc)
        end
      end
    end
  end
end

UIWhiteDayHeroList.__DefaultSortFunc = function(self, heroCfgA, heroCfgB)
  -- function num : 0_4
  do return heroCfgA.id < heroCfgB.id end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWhiteDayHeroList.__DefaultShiftFunc = function(self, heroCfg)
  -- function num : 0_5
  if self.__shiftAssistType == nil then
    return true
  end
  local heroAssistType = (self.__heroAssistTypeDic)[heroCfg.id]
  do return heroAssistType == self.__shiftAssistType end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWhiteDayHeroList.__RefreshList = function(self)
  -- function num : 0_6
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).loopscroll).totalCount = #self.showingHeroList
  ;
  ((self.ui).loopscroll):RefillCells()
end

UIWhiteDayHeroList.__OnNewItem = function(self, go)
  -- function num : 0_7 , upvalues : UINWhiteDayHeroItem
  local heroCardItem = (UINWhiteDayHeroItem.New)()
  heroCardItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = heroCardItem
end

UIWhiteDayHeroList.__OnChangeItem = function(self, go, index)
  -- function num : 0_8 , upvalues : _ENV
  local heroCardItem = (self.itemDic)[go]
  if heroCardItem == nil then
    error("Can\'t find heroCardItem by gameObject")
    return 
  end
  local heroCfg = (self.showingHeroList)[index + 1]
  if heroCfg == nil then
    error("Can\'t find heroCfg by index, index = " .. tonumber(index))
    return 
  end
  local isSelected = self.selectedHeroId == heroCfg.id
  if self.isPickPhoto then
    heroCardItem:InitWDHeroItem(heroCfg, true, nil, self.__onClickHeroItem, self.resloader)
    heroCardItem:SetWDHeroItemSelected(isSelected)
  else
    local heroAssistType = (self.__heroAssistTypeDic)[heroCfg.id]
    heroCardItem:InitWDHeroItem(heroCfg, false, heroAssistType, self.__onClickHeroItem, self.resloader)
    heroCardItem:SetWDHeroItemSelected(isSelected)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWhiteDayHeroList.__GetItemByIndex = function(self, index)
  -- function num : 0_9
  local go = ((self.ui).loopscroll):GetCellByIndex(index - 1)
  if go ~= nil then
    return (self.itemDic)[go]
  end
  return nil
end

UIWhiteDayHeroList.__OnClickHeroItem = function(self, heroItem)
  -- function num : 0_10 , upvalues : _ENV
  if self.selectedHeroId ~= nil then
    if self.selectedHeroId == (heroItem.heroCfg).id then
      heroItem:SetWDHeroItemSelected(false)
      self.selectedHeroId = nil
      self:__RefreshAssistHeroEffect()
      AudioManager:PlayAudioById(1200)
      return 
    end
    local lastIndex = nil
    for index,heroCfg in ipairs(self.showingHeroList) do
      if heroCfg.id == self.selectedHeroId then
        lastIndex = index
        break
      end
    end
    do
      do
        if lastIndex ~= nil then
          local lastSelectItem = self:__GetItemByIndex(lastIndex)
          if lastSelectItem ~= nil then
            lastSelectItem:SetWDHeroItemSelected(false)
          end
        end
        heroItem:SetWDHeroItemSelected(true)
        self.selectedHeroId = (heroItem.heroCfg).id
        self:__RefreshAssistHeroEffect()
        AudioManager:PlayAudioById(1201)
      end
    end
  end
end

UIWhiteDayHeroList.__RefreshAssistHeroEffect = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivityWhiteDayUtil
  if self.isPickPhoto then
    return 
  end
  ;
  ((self.ui).obj_effectNode):SetActive(self.selectedHeroId ~= nil)
  if self.selectedHeroId == nil then
    return 
  end
  local heroCfg = (ConfigData.hero_data)[self.selectedHeroId]
  local assistTypeId, assistCfg = (ActivityWhiteDayUtil.GetAssistHeroTypeByHeroId)(self.AWDData, heroCfg)
  ;
  ((self.ui).img_HeroEffectIcon):SetIndex(assistTypeId - 1)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(assistCfg.effect_text)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWhiteDayHeroList.__OnClickShiftHero = function(self)
  -- function num : 0_12
  ((self.ui).obj_screenNode):SetActive(not ((self.ui).obj_screenNode).activeSelf)
end

UIWhiteDayHeroList.__OnClickShiftHeroItem = function(self, shiftAssistType)
  -- function num : 0_13
  ((self.ui).obj_screenNode):SetActive(false)
  if shiftAssistType == self.__shiftAssistType then
    return 
  end
  self.__shiftAssistType = shiftAssistType
  self:__ShiftAndSortList()
  self:__RefreshList()
end

UIWhiteDayHeroList.__OnClickConfirm = function(self)
  -- function num : 0_14 , upvalues : cs_MessageCommon, _ENV
  if self.confirmCallback ~= nil then
    if self.isPickPhoto then
      local photoId = (self.__heroId2PhotoIdDic)[self.selectedHeroId]
      if photoId == nil then
        return 
      end
      ;
      (self.confirmCallback)(photoId)
    else
      do
        if self.selectedHeroId == nil then
          (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7215))
          return 
        end
        ;
        (self.confirmCallback)(self.selectedHeroId)
        self:OnClickClose()
      end
    end
  end
end

UIWhiteDayHeroList.OnClickRule = function(self)
  -- function num : 0_15 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_15_0 , upvalues : self
    if window == nil then
      return 
    end
    local wdCfg = (self.AWDData):GetWDCfg()
    window:InitCommonInfoByRule(wdCfg.assist_rule, true)
  end
)
end

UIWhiteDayHeroList.OnClickClose = function(self)
  -- function num : 0_16
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self.__shiftAssistType = nil
  self:Hide()
end

UIWhiteDayHeroList.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  ;
  (self.shiftItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayHeroList

