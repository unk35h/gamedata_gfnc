-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGuidePicture_0623New = class("UIGuidePicture_0623New", UIBaseWindow)
local base = UIBaseWindow
local UINGuidePicture_0623NewItem = require("Game.Guide.GuidePicture.UINGuidePicture_0623NewItem")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local cs_MovieManager = (CS.MovieManager).Instance
UIGuidePicture_0623New.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData, UINGuidePicture_0623NewItem
  ConfigData:LoadDynCfg(eDynConfigData.guide_describe)
  ConfigData:LoadDynCfg(eDynConfigData.tips)
  ;
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnBtnCloseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Last, self, self.OnLastPageClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Next, self, self.OnNextPageClicked)
  ;
  ((self.ui).picItem):SetActive(false)
  self.picItemPool = (UIItemPool.New)(UINGuidePicture_0623NewItem, (self.ui).picItem)
  self.__OnPageIndexChanged = BindCallback(self, self.OnPageIndexChanged)
  ;
  ((self.ui).picList):onPageIndexChanged("+", self.__OnPageIndexChanged)
  self._pointWidthUnit = (((self.ui).tran_TotalPoint).rect).width
  self._pointHeightUnit = (((self.ui).tran_TotalPoint).rect).height
end

UIGuidePicture_0623New.InitGuidePicture_New = function(self, guideType, completeAction, finishShowClose)
  -- function num : 0_1 , upvalues : _ENV
  local tipsCfg = (ConfigData.tips)[guideType]
  local tipsDesCfg = (ConfigData.guide_describe)[guideType]
  if tipsCfg == nil or tipsDesCfg == nil then
    error("can\'t read tips with guideType:" .. tostring(guideType))
    if completeAction ~= nil then
      completeAction()
    end
    self:Delete()
    return 
  end
  self.completeAction = completeAction
  self.__finishShowClose = finishShowClose or false
  self.pageCount = #tipsCfg.content
  self.curPageNum = 1
  self._tipsCfg = tipsCfg
  local canScroll = self.pageCount > 1
  ;
  ((self.ui).count):SetActive(canScroll)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).scroll_picList).horizontal = false
  if self.__finishShowClose then
    (((self.ui).btn_Close).gameObject):SetActive(false)
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
  end
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (self.picItemPool):HideAll()
  for index,contentName in ipairs(tipsCfg.content) do
    local picItem = (self.picItemPool):GetOne()
    local deslist = tipsDesCfg[index]
    local title = (tipsCfg.title)[index]
    if (self._tipsCfg).guide_vedio then
      picItem:InitPictureItemBase(deslist, index, title)
    else
      local resPath = PathConsts:GetGuideTipsPath(tipsCfg.path, contentName)
      picItem:InitPictureItem(deslist, index, title, resPath, self.resloader)
    end
  end
  ;
  ((self.ui).picList):InitPosList()
  self:OnPageIndexChanged(0)
  self:_InitPagePointUI(0)
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UIGuidePicture_0623New.__TryShowCloseButton = function(self)
  -- function num : 0_2
  if self.pageCount <= self.curPageNum and self.__finishShowClose then
    self.__finishShowClose = false
    ;
    (((self.ui).btn_Close).gameObject):SetActive(true)
  end
end

UIGuidePicture_0623New.OnPageIndexChanged = function(self, pageIndex)
  -- function num : 0_3 , upvalues : _ENV, cs_MovieManager
  local page = pageIndex + 1
  self.curPageNum = page
  ;
  (((self.ui).btn_Last).gameObject):SetActive(page > 1)
  ;
  (((self.ui).btn_Next).gameObject):SetActive(page < self.pageCount)
  ;
  ((self.ui).tex_Page):SetIndex(0, tostring(page), tostring(self.pageCount))
  self:RefreshPagePointUI(pageIndex)
  self:__TryShowCloseButton()
  if (self._tipsCfg).guide_vedio then
    if self.moviePlayer ~= nil then
      cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    end
    self.moviePlayer = cs_MovieManager:GetMoviePlayer()
    local picItem = ((self.picItemPool).listItem)[page]
    if picItem ~= nil then
      local content = ((self._tipsCfg).content)[page]
      local vedioPath = PathConsts:GetGuideVideoPath((self._tipsCfg).path, content)
      picItem:PlayGuideVedio(vedioPath, self.moviePlayer)
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIGuidePicture_0623New.EnterCurrentGuidePage = function(self)
  -- function num : 0_4
  ((self.ui).picList):SetPageIndex(self.curPageNum - 1)
end

UIGuidePicture_0623New.BackAction = function(self)
  -- function num : 0_5
  if self.completeAction ~= nil then
    (self.completeAction)()
  end
  self:Delete()
end

UIGuidePicture_0623New.OnBtnCloseClicked = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIGuidePicture_0623New.OnLastPageClicked = function(self)
  -- function num : 0_7
  if self.curPageNum <= 1 then
    return 
  end
  self.curPageNum = self.curPageNum - 1
  self:EnterCurrentGuidePage()
end

UIGuidePicture_0623New.OnNextPageClicked = function(self)
  -- function num : 0_8
  if self.pageCount <= self.curPageNum then
    return 
  end
  self.curPageNum = self.curPageNum + 1
  self:EnterCurrentGuidePage()
  self:__TryShowCloseButton()
end

UIGuidePicture_0623New._InitPagePointUI = function(self, pageIndex)
  -- function num : 0_9 , upvalues : _ENV
  local totalWidth = self._pointWidthUnit * self.pageCount
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tran_TotalPoint).sizeDelta = (Vector2.New)(totalWidth, self._pointHeightUnit)
  self:RefreshPagePointUI(pageIndex)
end

UIGuidePicture_0623New.RefreshPagePointUI = function(self, pageIndex)
  -- function num : 0_10 , upvalues : _ENV
  local moveX = pageIndex * self._pointWidthUnit
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_CurPoint).anchoredPosition = (Vector2.New)(moveX, 0, 0)
end

UIGuidePicture_0623New.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, eDynConfigData, base
  ((self.ui).picList):onPageIndexChanged("-", self.__OnPageIndexChanged)
  ConfigData:ReleaseDynCfg(eDynConfigData.guide_describe)
  ConfigData:ReleaseDynCfg(eDynConfigData.tips)
  ;
  (base.OnDelete)(self)
end

UIGuidePicture_0623New.OnDeleteEntity = function(self)
  -- function num : 0_12 , upvalues : cs_MovieManager, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.moviePlayer ~= nil then
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  ;
  (base.OnDeleteEntity)(self)
end

return UIGuidePicture_0623New

