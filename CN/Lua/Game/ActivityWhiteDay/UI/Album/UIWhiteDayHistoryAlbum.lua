-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayHistoryAlbum = class("UIWhiteDayHistoryAlbum", UIBaseWindow)
local base = UIBaseWindow
local ONE_PAGE_NUM = 8
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
local UINWhiteDayAlbumPageItem = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumPageItem")
local UINWhiteDayAlbumItem = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumItem")
local UINWhiteDayAlbumSelectNode = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumSelectNode")
local UINWhiteDayLookPhotoNode = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayLookPhotoNode")
UIWhiteDayHistoryAlbum.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData, cs_ResLoader, UINWhiteDayAlbumPageItem, UINWhiteDayAlbumItem
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_photo)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day)
  ;
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PreviousPage, self, self.OnWDClickPreviousPage)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NextPage, self, self.OnWDClickNextPage)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnWDClickAlbumInfo)
  self.pageItemPool = (UIItemPool.New)(UINWhiteDayAlbumPageItem, (self.ui).obj_img_Page)
  ;
  ((self.ui).obj_img_Page):SetActive(false)
  self.photoItemPool = (UIItemPool.New)(UINWhiteDayAlbumItem, (self.ui).obj_item)
  ;
  ((self.ui).obj_item):SetActive(false)
  ;
  ((self.ui).obj_selectTypeNode):SetActive(false)
  ;
  ((self.ui).obj_showNode):SetActive(false)
  self.__pageNum = nil
  self.__photoCfgDic = nil
  self.__curPageIndex = nil
  self.__pageItemDic = nil
  self.startAvgId = nil
  self.endAvgId = nil
  self.isEndAvgUnlock = nil
  self.__onWDClickLookPhoto = BindCallback(self, self.OnWDClickLookPhoto)
  self.__OnOpenSkinPanelCallback = BindCallback(self, self.__OnOpenSkinPanel)
end

UIWhiteDayHistoryAlbum.InitWDHistoryAlbum = function(self, actid)
  -- function num : 0_1 , upvalues : _ENV
  local whiteDayNetWork = NetworkManager:GetNetwork(NetworkTypeID.WhiteDay)
  whiteDayNetWork:CS_Activity_Polariod_History(actid, function(args)
    -- function num : 0_1_0 , upvalues : _ENV, actid, self
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local activityPolariodData = args[0]
    if activityPolariodData == nil or not activityPolariodData.data then
      local unlockedPhotoDic = {}
    end
    local wdCfg = (ConfigData.activity_white_day)[actid]
    self.__photoCfgDic = (ConfigData.activity_white_day_photo)[actid]
    self.__unlockedPhotoDic = unlockedPhotoDic
    self.__unlockedPhotoList = {}
    for photoId,_ in pairs(unlockedPhotoDic) do
      (table.insert)(self.__unlockedPhotoList, photoId)
    end
    ;
    (table.sort)(self.__unlockedPhotoList)
    self.startAvgId = wdCfg.activity_avg
    self.endAvgId = wdCfg.finish_avg
    self.isEndAvgUnlock = (table.count)(self.__photoCfgDic) <= (table.count)(unlockedPhotoDic)
    self._skinIdList = {}
    for k,cfg in pairs(self.__photoCfgDic) do
      local skinUseful = (cfg.skinId ~= nil and (PlayerDataCenter.skinData):IsSkinUnlocked(cfg.skinId))
      if skinUseful then
        (table.insert)(self._skinIdList, cfg.skinId)
      end
    end
    ;
    (table.sort)(self._skinIdList)
    self:__RefreshPages()
    self:__RefreshBtnShow()
    self:__RefreshCollectUI()
    self:Show()
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
end

UIWhiteDayHistoryAlbum.__RefreshBtnShow = function(self)
  -- function num : 0_2
  ((self.ui).obj_resourcesNode):SetActive(false)
  ;
  (((self.ui).btn_GetPhoto).gameObject):SetActive(false)
  ;
  ((self.ui).obj_slider_collect):SetActive(true)
end

UIWhiteDayHistoryAlbum.__RefreshPages = function(self)
  -- function num : 0_3 , upvalues : _ENV, ONE_PAGE_NUM
  local totalItemNum = (table.count)(self.__photoCfgDic) + 2
  self.__pageNum = (math.ceil)(totalItemNum / ONE_PAGE_NUM)
  ;
  (((self.ui).btn_PreviousPage).gameObject):SetActive(self.__pageNum > 1)
  ;
  (((self.ui).btn_NextPage).gameObject):SetActive(self.__pageNum > 1)
  self.__pageItemDic = {}
  ;
  (self.pageItemPool):HideAll()
  for pageIndex = 1, self.__pageNum do
    local pageItem = (self.pageItemPool):GetOne()
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__pageItemDic)[pageIndex] = pageItem
  end
  self:WDChangeSelectPage(1)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWhiteDayHistoryAlbum.__RefreshCurPageItems = function(self)
  -- function num : 0_4 , upvalues : _ENV, ONE_PAGE_NUM
  local collectedNum = (table.count)(self.__unlockedPhotoDic)
  local totalItemNum = (table.count)(self.__photoCfgDic) + 1
  local startIndex = (self.__curPageIndex - 1) * ONE_PAGE_NUM
  local endIndex = (math.min)(startIndex + ONE_PAGE_NUM - 1, totalItemNum)
  ;
  (self.photoItemPool):HideAll()
  for index = startIndex, endIndex do
    local photoItem = (self.photoItemPool):GetOne()
    photoItem:SetJustLookAvg()
    if index == 0 then
      local isUnlock = true
      photoItem:InitWDPhotoAvgItem(nil, self.startAvgId, isUnlock, self.resloader, true)
    else
      do
        if index == totalItemNum then
          photoItem:InitWDPhotoAvgItem(nil, self.endAvgId, self.isEndAvgUnlock, self.resloader)
        else
          local isUnlock = index <= collectedNum
          if isUnlock then
            local photoId = (self.__unlockedPhotoList)[index]
            local photoCfg = (self.__photoCfgDic)[photoId]
            photoItem:InitWDPhotoItem(isUnlock, photoCfg, self.resloader, self.__onWDClickLookPhoto)
          else
            photoItem:InitWDPhotoItem(isUnlock)
          end
        end
        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out DO_STMT

        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_ELSE_STMT

        -- DECOMPILER ERROR at PC72: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWhiteDayHistoryAlbum.__RefreshCollectUI = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local collectedNum = (table.count)(self.__unlockedPhotoDic)
  local totalItemNum = (table.count)(self.__photoCfgDic)
  local collectRate = collectedNum / totalItemNum
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).slider_collect).value = collectRate
  ;
  ((self.ui).tex_collect):SetIndex(0, tostring(collectedNum), tostring(totalItemNum))
end

UIWhiteDayHistoryAlbum.WDChangeSelectPage = function(self, pageIndex)
  -- function num : 0_6
  if pageIndex == self.__curPageIndex then
    return 
  end
  do
    if self.__curPageIndex ~= nil then
      local previousSelectPage = (self.__pageItemDic)[self.__curPageIndex]
      previousSelectPage:SetIsSelected(false)
    end
    self.__curPageIndex = pageIndex
    local selectPageItem = (self.__pageItemDic)[pageIndex]
    selectPageItem:SetIsSelected(true)
    self:__RefreshCurPageItems()
  end
end

UIWhiteDayHistoryAlbum.OnWDClickNextPage = function(self)
  -- function num : 0_7
  if self.__pageNum <= self.__curPageIndex then
    self:WDChangeSelectPage(1)
  else
    self:WDChangeSelectPage(self.__curPageIndex + 1)
  end
end

UIWhiteDayHistoryAlbum.OnWDClickPreviousPage = function(self)
  -- function num : 0_8
  if self.__curPageIndex <= 1 then
    self:WDChangeSelectPage(self.__pageNum)
  else
    self:WDChangeSelectPage(self.__curPageIndex - 1)
  end
end

UIWhiteDayHistoryAlbum.OnWDClickLookPhoto = function(self, photoCfg, closeCallback)
  -- function num : 0_9 , upvalues : UINWhiteDayLookPhotoNode
  if self.lookPhotoNode == nil then
    self.lookPhotoNode = (UINWhiteDayLookPhotoNode.New)(self.AWDCtrl, self.AWDData, self.resloader)
    ;
    (self.lookPhotoNode):Init((self.ui).obj_showNode)
    ;
    (self.lookPhotoNode):SetJustLookAvg()
  end
  ;
  (self.lookPhotoNode):InitWDSelectNode(photoCfg, closeCallback, self.__OnOpenSkinPanelCallback)
  ;
  (self.lookPhotoNode):Show()
end

UIWhiteDayHistoryAlbum.OnWDClickAlbumInfo = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_10_0 , upvalues : _ENV
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(7209), (ConfigData:GetTipContent(7210)), nil, true)
  end
)
end

UIWhiteDayHistoryAlbum.__OnOpenSkinPanel = function(self, selectSkinId)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_11_0 , upvalues : selectSkinId, self
    if win == nil then
      return 
    end
    win:InitSkinBySkinList(selectSkinId, self._skinIdList)
  end
)
end

UIWhiteDayHistoryAlbum.BackAction = function(self)
  -- function num : 0_12
  self:Delete()
end

UIWhiteDayHistoryAlbum.OnClickClose = function(self)
  -- function num : 0_13 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIWhiteDayHistoryAlbum.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, eDynConfigData, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_photo)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day)
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayHistoryAlbum

