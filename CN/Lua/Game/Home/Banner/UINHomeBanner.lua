-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeBanner = class("UICarouselBanner", UIBaseNode)
local base = UIBaseNode
local ImgSelectWidth = 22
local CS_EventTriggerListener = CS.EventTriggerListener
local HomeBannerManager = require("Game.Home.Banner.HomeBannerManager")
local UINHomeBannerLoopList = require("Game.Home.Banner.UINHomeBannerLoopList")
local UINHomeBannerIndexItem = require("Game.Home.Banner.UINHomeBannerIndexItem")
UINHomeBanner.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHomeBannerLoopList, ImgSelectWidth, UINHomeBannerIndexItem, CS_EventTriggerListener
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.bannerLoopList = (UINHomeBannerLoopList.New)()
  ;
  (self.bannerLoopList):Init((self.ui).obj_advList)
  ;
  (self.bannerLoopList):SetPointerExitSucChecker(function()
    -- function num : 0_0_0 , upvalues : self, _ENV
    do return self.__onPointerCornerStaty == false and UIManager:GetWindow(UIWindowTypeID.BannerSpread) == nil end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self.__OnPageIndexChanged = BindCallback(self, self.OnPageIndexChanged)
  self.bannerSelectWidth = (self.ui).float_bannerSelectWidth or ImgSelectWidth
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_OpenList, self, self.__OnCornerClick)
  self.__HomeBannerIndexItemPool = (UIItemPool.New)(UINHomeBannerIndexItem, (self.ui).obj_indexItem)
  ;
  ((self.ui).obj_indexItem):SetActive(false)
  self.__cornerEventTrigger = (CS_EventTriggerListener.Get)((self.ui).btn_OpenList)
  TimerManager:StopTimer(self.__cornerPointerExitDelayCheckTimerId)
  self.__cornerPointerExitDelayCheckTimerId = TimerManager:StartTimer(1.5, function()
    -- function num : 0_0_1 , upvalues : self, _ENV
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R0 in 'UnsetPending'

    if (self.bannerLoopList).__isAutoPlay == false and (self.bannerLoopList).__onPointerStaty == false and UIManager:GetWindow(UIWindowTypeID.BannerSpread) == nil then
      (self.bannerLoopList).__isAutoPlay = true
    end
    TimerManager:PauseTimer(self.__cornerPointerExitDelayCheckTimerId)
  end
, self)
  TimerManager:PauseTimer(self.__cornerPointerExitDelayCheckTimerId)
end

UINHomeBanner.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV, base
  (self.__cornerEventTrigger):onEnter("+", BindCallback(self, self.__OnCornerPointerEnter))
  ;
  (self.__cornerEventTrigger):onExit("+", BindCallback(self, self.__OnCornerPointerExit))
  self.__onPointerCornerStaty = false
  ;
  (base.OnShow)()
end

UINHomeBanner.InitialHomeBanner = function(self, bannerDataList, oldDataId)
  -- function num : 0_2 , upvalues : _ENV
  self.bannerDataList = bannerDataList
  self.pageCount = #bannerDataList
  self.curPageNum = 1
  if self.IndexItems ~= nil then
    for iPageIndex,_ in pairs(self.IndexItems) do
      self:SetPageIndexColor(iPageIndex, 1)
    end
  end
  do
    ;
    (self.__HomeBannerIndexItemPool):HideAll()
    ;
    (((self.ui).indexItemParent).gameObject):SetActive(true)
    self.IndexItems = {}
    for iIndex = 1, self.pageCount do
      local indexItem = (self.__HomeBannerIndexItemPool):GetOne()
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.IndexItems)[iIndex] = indexItem
      indexItem:Show()
    end
    self:SetPageIndexColor(self.curPageNum, 2)
    local initIndex = nil
    for index,value in ipairs(bannerDataList) do
      if value.id == oldDataId then
        initIndex = index
        break
      end
    end
    do
      if initIndex == nil then
        initIndex = 1
      end
      ;
      (self.bannerLoopList):SetLoopBannerDataList(bannerDataList, initIndex, self.__OnPageIndexChanged)
      ;
      (self.bannerLoopList):SetInterval(((self.bannerDataList)[initIndex]).delay)
    end
  end
end

UINHomeBanner.SetPageIndexColor = function(self, pageIndex, colorIndex)
  -- function num : 0_3
  ((self.IndexItems)[pageIndex]):SetBannerIndexItemColor(((self.ui).col_IndexItem)[colorIndex])
end

UINHomeBanner.RefreshAllBannerData = function(self)
  -- function num : 0_4 , upvalues : HomeBannerManager
  HomeBannerManager:RefreshBannerDataList(function(bannerDataList)
    -- function num : 0_4_0 , upvalues : self
    if bannerDataList ~= nil and #bannerDataList > 0 then
      local oldCurDataId = ((self.bannerDataList)[self.curPageNum]).id
      self:InitialHomeBanner(bannerDataList, oldCurDataId)
      self:Show()
    else
      do
        self:Hide()
      end
    end
  end
)
end

UINHomeBanner.OnPageIndexChanged = function(self, pageIndex)
  -- function num : 0_5 , upvalues : _ENV
  self:SetPageIndexColor(self.curPageNum, 1)
  local page = pageIndex
  self.curPageNum = page
  self:SetPageIndexColor(self.curPageNum, 2)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).trans_indexItem).anchoredPosition3D = (Vector3.New)(self.bannerSelectWidth * (self.curPageNum - 1))
  ;
  (self.bannerLoopList):SetInterval(((self.bannerDataList)[self.curPageNum]).delay)
  if ((self.bannerDataList)[self.curPageNum]):GetBannerIsOutOfData() or ((self.bannerDataList)[self.curPageNum]):GetIsLotteryOrShopItemClosed() then
    self:RefreshAllBannerData()
  end
  self:__UpdateBannerLeftTime()
  self:__UpdateBannerDurationTime()
end

UINHomeBanner.__UpdateBannerLeftTime = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not ((self.bannerDataList)[self.curPageNum]):GetBannerIsShowLeftTime() then
    (((self.ui).obj_Time).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).obj_Time).gameObject):SetActive(true)
  local d, h, m, s = TimeUtil:TimestampToTimeInter((((self.bannerDataList)[self.curPageNum]):GetBannerLeftTime()), nil, true)
  if d > 0 then
    ((self.ui).tex_Time):SetIndex(0, tostring(d))
  else
    if h > 0 then
      ((self.ui).tex_Time):SetIndex(1, tostring(h))
    else
      ;
      ((self.ui).tex_Time):SetIndex(2, tostring(m))
    end
  end
end

UINHomeBanner.__UpdateBannerDurationTime = function(self)
  -- function num : 0_7
  local startTime, endTime = ((self.bannerDataList)[self.curPageNum]):GetStartAndEndTime()
  ;
  ((self.ui).tex_AdvContent):SetIndex(0, startTime, endTime)
end

UINHomeBanner.__OnCornerClick = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local win = UIManager:ShowWindowAsync(UIWindowTypeID.BannerSpread, function(win)
    -- function num : 0_8_0 , upvalues : self
    win:SetSpreadBannerProperty(self.bannerLoopList, self.bannerDataList)
  end
)
  self:Hide()
end

UINHomeBanner.__OnCornerPointerEnter = function(self)
  -- function num : 0_9
  self.__onPointerCornerStaty = true
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.bannerLoopList).__isAutoPlay = false
end

UINHomeBanner.__OnCornerPointerExit = function(self)
  -- function num : 0_10 , upvalues : _ENV
  self.__onPointerCornerStaty = false
  if self.__cornerPointerExitDelayCheckTimerId ~= nil then
    TimerManager:ResetTimer(self.__cornerPointerExitDelayCheckTimerId)
    TimerManager:ResumeTimer(self.__cornerPointerExitDelayCheckTimerId)
  end
end

UINHomeBanner.OnHide = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  (self.__cornerEventTrigger):onEnter("-", BindCallback(self, self.__OnCornerPointerEnter))
  ;
  (self.__cornerEventTrigger):onExit("-", BindCallback(self, self.__OnCornerPointerExit))
  ;
  (base.OnHide)()
end

UINHomeBanner.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  (self.bannerLoopList):Delete()
  TimerManager:StopTimer(self.__cornerPointerExitDelayCheckTimerId)
  self.__cornerPointerExitDelayCheckTimerId = nil
  if self.IndexItems ~= nil then
    for _,indexItem in pairs(self.IndexItems) do
      indexItem:Delete()
    end
  end
  do
    ;
    (base.OnDelete)(self)
  end
end

return UINHomeBanner

