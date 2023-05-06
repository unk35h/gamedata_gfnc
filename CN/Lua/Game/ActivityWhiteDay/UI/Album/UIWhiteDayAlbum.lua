-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayAlbum = class("UIWhiteDayAlbum", UIBaseWindow)
local base = UIBaseWindow
local ONE_PAGE_NUM = 8
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
local UINWhiteDayAlbumPageItem = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumPageItem")
local UINWhiteDayAlbumItem = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumItem")
local UINWhiteDayAlbumSelectNode = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumSelectNode")
local UINWhiteDayLookPhotoNode = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayLookPhotoNode")
local UINWhiteDayAlbHeroList = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbHeroList")
UIWhiteDayAlbum.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINWhiteDayAlbumPageItem, UINWhiteDayAlbumItem
  (((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):PushTopStatusDataToBackStack()
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetPhoto, self, self.OnWDClickGetAlbum)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PreviousPage, self, self.OnWDClickPreviousPage)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NextPage, self, self.OnWDClickNextPage)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnWDClickAlbumInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetSkin_2nd, self, self.OnClickGetSkin)
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
  self.__onWDClickLookPhoto = BindCallback(self, self.OnWDClickLookPhoto)
  self.__afterGetPhoto = BindCallback(self, self.__AfterGetPhoto)
  self.__onWDPhotoChange = BindCallback(self, self.OnWDPhotoChange)
  MsgCenter:AddListener(eMsgEventId.WhiteDayPhotoChange, self.__onWDPhotoChange)
  self.__RefreshPhotoItemSkinStateCallback = BindCallback(self, self.__RefreshPhotoItemSkinState)
  MsgCenter:AddListener(eMsgEventId.UpdateHeroSkin, self.__RefreshPhotoItemSkinStateCallback)
  self.__OnOpenSkinPanelCallback = BindCallback(self, self.__OnOpenSkinPanel)
  ;
  ((self.ui).heroListNode):SetActive(false)
end

UIWhiteDayAlbum.InitWDAlbun = function(self, AWDCtrl, AWDData)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDData = AWDData
  self.__photoCfgDic = (self.AWDData):GetWDPhotoCfgs()
  AWDData:SetWDReddot4Album(false)
  self:__RefreshPages()
  self:__RefreshCollectUI()
  self:__RefreshResItemUI()
  self:__RefreshBtnShow()
  self:__InitWDGetPhotoReddot()
  self:__RefreshPhotoSkinBtnState()
end

UIWhiteDayAlbum.OnWDPhotoChange = function(self)
  -- function num : 0_2
  self:__RefreshCurPageItems()
  self:__RefreshCollectUI()
  self:__RefreshResItemNum()
  self:__RefreshBtnShow()
  self:__RefreshPhotoSkinBtnState()
end

UIWhiteDayAlbum.__RefreshBtnShow = function(self)
  -- function num : 0_3
  local isActOpen = (self.AWDData):IsActivityOpen()
  local isUnlockAllPhoto = (self.AWDData):GetWDUnlockAllPhoto()
  ;
  ((self.ui).obj_resourcesNode):SetActive(isActOpen)
  if isActOpen then
    (((self.ui).btn_GetPhoto).gameObject):SetActive(not isUnlockAllPhoto)
  end
end

UIWhiteDayAlbum.__RefreshPages = function(self)
  -- function num : 0_4 , upvalues : _ENV, ONE_PAGE_NUM
  local totalItemNum = (table.count)(self.__photoCfgDic) + 2
  self.__pageNum = (math.ceil)(totalItemNum / ONE_PAGE_NUM)
  self.__pageItemDic = {}
  ;
  (self.pageItemPool):HideAll()
  for pageIndex = 1, self.__pageNum do
    local pageItem = (self.pageItemPool):GetOne()
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__pageItemDic)[pageIndex] = pageItem
  end
  self:WDChangeSelectPage(1)
end

UIWhiteDayAlbum.__RefreshCurPageItems = function(self)
  -- function num : 0_5 , upvalues : _ENV, ONE_PAGE_NUM
  local unlockedList = (self.AWDData):GetWDUnlockedPhotoList()
  local collectedNum = (self.AWDData):GetWDUnlockedPhotoNum()
  local totalItemNum = (table.count)(self.__photoCfgDic) + 1
  local startIndex = (self.__curPageIndex - 1) * ONE_PAGE_NUM
  local endIndex = (math.min)(startIndex + ONE_PAGE_NUM - 1, totalItemNum)
  ;
  (self.photoItemPool):HideAll()
  for index = startIndex, endIndex do
    local photoItem = (self.photoItemPool):GetOne()
    if index == 0 then
      local avgId = (self.AWDData):GetAWDFirstEnterAvgId()
      photoItem:InitWDPhotoAvgItem(self.AWDData, avgId, true, self.resloader)
    else
      do
        if index == totalItemNum then
          local isUnlock = (self.AWDData):GetWDUnlockAllPhoto()
          local avgId = (self.AWDData):GetAWDCollectAllAvgId()
          photoItem:InitWDPhotoAvgItem(self.AWDData, avgId, isUnlock, self.resloader)
        else
          do
            do
              local isUnlock = index <= collectedNum
              if isUnlock then
                local photoId = unlockedList[index]
                local photoCfg = (self.__photoCfgDic)[photoId]
                if photoCfg == nil then
                  error("photo not exist id:" .. tostring(photoId))
                else
                  photoItem:InitWDPhotoItem(isUnlock, photoCfg, self.resloader, self.__onWDClickLookPhoto)
                end
              else
                photoItem:InitWDPhotoItem(isUnlock)
              end
              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC88: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIWhiteDayAlbum.__RefreshCollectUI = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local collectedNum = (self.AWDData):GetWDUnlockedPhotoNum()
  local totalItemNum = (table.count)(self.__photoCfgDic)
  local collectRate = collectedNum / totalItemNum
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).slider_collect).value = collectRate
  ;
  ((self.ui).tex_collect):SetIndex(0, tostring(collectedNum), tostring(totalItemNum))
end

UIWhiteDayAlbum.__RefreshResItemUI = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon_1).sprite = CRH:GetSpriteByItemId(randomId)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon_2).sprite = CRH:GetSpriteByItemId(exchangeId)
  self:__RefreshResItemNum()
end

UIWhiteDayAlbum.__RefreshResItemNum = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local randomNum = PlayerDataCenter:GetItemCount(randomId)
  local exchangeNum = PlayerDataCenter:GetItemCount(exchangeId)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Count_1).text = tostring(randomNum)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Count_2).text = tostring(exchangeNum)
end

UIWhiteDayAlbum.WDChangeSelectPage = function(self, pageIndex)
  -- function num : 0_9
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

UIWhiteDayAlbum.OnWDClickNextPage = function(self)
  -- function num : 0_10
  if self.__pageNum <= self.__curPageIndex then
    self:WDChangeSelectPage(1)
  else
    self:WDChangeSelectPage(self.__curPageIndex + 1)
  end
end

UIWhiteDayAlbum.OnWDClickPreviousPage = function(self)
  -- function num : 0_11
  if self.__curPageIndex <= 1 then
    self:WDChangeSelectPage(self.__pageNum)
  else
    self:WDChangeSelectPage(self.__curPageIndex - 1)
  end
end

UIWhiteDayAlbum.OnWDClickGetAlbum = function(self)
  -- function num : 0_12 , upvalues : _ENV, cs_MessageCommon, UINWhiteDayAlbumSelectNode
  local randomId, _ = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, _ = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local randomNum = PlayerDataCenter:GetItemCount(randomId)
  local exchangeNum = PlayerDataCenter:GetItemCount(exchangeId)
  if randomNum <= 0 and exchangeNum <= 0 then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7202))
    return 
  end
  if self.selectNode == nil then
    self.selectNode = (UINWhiteDayAlbumSelectNode.New)()
    ;
    (self.selectNode):Init((self.ui).obj_selectTypeNode)
  end
  ;
  (self.selectNode):InitWDSelectNode(self.AWDCtrl, self.AWDData, self.__afterGetPhoto)
  ;
  (self.selectNode):Show()
end

UIWhiteDayAlbum.OnWDClickLookPhoto = function(self, photoCfg, closeCallback)
  -- function num : 0_13 , upvalues : UINWhiteDayLookPhotoNode
  if self.lookPhotoNode == nil then
    self.lookPhotoNode = (UINWhiteDayLookPhotoNode.New)(self.AWDCtrl, self.AWDData, self.resloader)
    ;
    (self.lookPhotoNode):Init((self.ui).obj_showNode)
  end
  ;
  (self.lookPhotoNode):InitWDSelectNode(photoCfg, closeCallback, self.__OnOpenSkinPanelCallback)
  ;
  (self.lookPhotoNode):Show()
end

UIWhiteDayAlbum.OnWDClickAlbumInfo = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_14_0 , upvalues : self, _ENV
    if window == nil then
      return 
    end
    local wdCfg = (self.AWDData):GetWDCfg()
    window:InitCommonInfo(ConfigData:GetTipContent(wdCfg.album_title), (ConfigData:GetTipContent(wdCfg.album_content)), nil, true)
  end
)
end

UIWhiteDayAlbum.OnClickGetSkin = function(self)
  -- function num : 0_15
  self:__OpenGetSkin()
end

UIWhiteDayAlbum.__OpenGetSkin = function(self, skinId)
  -- function num : 0_16 , upvalues : cs_MessageCommon, _ENV, UINWhiteDayAlbHeroList
  local isUnlockPhotoSkinGet = (self.AWDData):GetWDIsUnlockPhotoSkinGet()
  if isUnlockPhotoSkinGet then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7211))
    return 
  end
  if self._albSkinHeroListNode == nil then
    ((self.ui).heroListNode):SetActive(true)
    self._albSkinHeroListNode = (UINWhiteDayAlbHeroList.New)()
    ;
    (self._albSkinHeroListNode):Init((self.ui).heroListNode)
    ;
    (self._albSkinHeroListNode):InitAlbHeroList(self.AWDData, function()
    -- function num : 0_16_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:__RefreshPhotoSkinBtnState()
    end
  end
)
  else
    ;
    (self._albSkinHeroListNode):Show()
    ;
    (self._albSkinHeroListNode):RefreshAlbHeroList()
  end
  if skinId ~= nil then
    (self._albSkinHeroListNode):AutoSelectAlbHero(skinId)
  end
end

UIWhiteDayAlbum.__AfterGetPhoto = function(self, photoId)
  -- function num : 0_17 , upvalues : _ENV, ONE_PAGE_NUM
  local photoCfg = (self.__photoCfgDic)[photoId]
  local unlockedList = (self.AWDData):GetWDUnlockedPhotoList()
  for index,unlockedPhotoId in ipairs(unlockedList) do
    if photoId == unlockedPhotoId then
      local pageIndex = (math.ceil)((index + 1) / ONE_PAGE_NUM)
      self:WDChangeSelectPage(pageIndex)
    end
  end
  self:OnWDClickLookPhoto(photoCfg, function()
    -- function num : 0_17_0 , upvalues : _ENV, photoCfg, self
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_17_0_0 , upvalues : _ENV, photoCfg
      if window == nil then
        return 
      end
      local CommonRewardData = require("Game.CommonUI.CommonRewardData")
      local CRData = (CommonRewardData.CreateCRDataUseDic)(photoCfg.item)
      window:AddAndTryShowReward(CRData)
    end
)
    self:__RefreshPhotoSkinBtnState()
  end
)
  ;
  (self.lookPhotoNode):OnClickCheck()
end

UIWhiteDayAlbum.__InitWDGetPhotoReddot = function(self)
  -- function num : 0_18 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).photoNode, (ActivityWhiteDayEnum.redDotType).couldGetNewPhoto)
  if isOk then
    self.__refresnGetPhotoReddot = function(node)
    -- function num : 0_18_0 , upvalues : self
    ((self.ui).obj_GetPhotoBlueDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    self._addRedNodePath = node.nodePath
    RedDotController:AddListener(self._addRedNodePath, self.__refresnGetPhotoReddot)
    ;
    (self.__refresnGetPhotoReddot)(node)
  end
end

UIWhiteDayAlbum.__RemoveWDGetPhotoReddot = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self._addRedNodePath ~= nil then
    RedDotController:RemoveListener(self._addRedNodePath, self.__refresnGetPhotoReddot)
    self.__refresnGetPhotoReddot = nil
    self._addRedNodePath = nil
  end
end

UIWhiteDayAlbum.__RefreshPhotoSkinBtnState = function(self)
  -- function num : 0_20
  local isAllSkinGet = (self.AWDData):GetWDIsAllSkinGet()
  ;
  (((self.ui).btn_GetSkin_2nd).gameObject):SetActive(not isAllSkinGet)
end

UIWhiteDayAlbum.__RefreshPhotoItemSkinState = function(self)
  -- function num : 0_21 , upvalues : _ENV
  for k,item in pairs((self.photoItemPool).listItem) do
    item:RefreshDayAlbumItemSkinState()
  end
end

UIWhiteDayAlbum.__OnOpenSkinPanel = function(self, selectSkinId)
  -- function num : 0_22 , upvalues : _ENV
  if not (PlayerDataCenter.skinData):IsHaveSkin(selectSkinId) then
    (self.lookPhotoNode):OnClickCloseLookPhoto()
    self:__OpenGetSkin(selectSkinId)
    return 
  end
  local cfgDic = (self.AWDData):GetWDPhotoCfgs()
  local skinIdList = {}
  for k,cfg in pairs(cfgDic) do
    if cfg.skinId ~= nil then
      (table.insert)(skinIdList, cfg.skinId)
    end
  end
  ;
  (table.sort)(skinIdList)
  local win = UIManager:GetWindow(UIWindowTypeID.HeroSkin)
  if win ~= nil then
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.HeroSkin, false)
    ;
    (UIUtil.PopFromBackStackByUiTab)(self)
    win:InitSkinBySkinList(selectSkinId, skinIdList, win.buyCallback, win.closeCallback)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_22_0 , upvalues : self, selectSkinId, skinIdList, _ENV
    if win == nil then
      return 
    end
    self:Hide()
    win:InitSkinBySkinList(selectSkinId, skinIdList, nil, function()
      -- function num : 0_22_0_0 , upvalues : _ENV, self
      if IsNull(self.transform) then
        return 
      end
      self:Show()
    end
)
  end
)
  end
end

UIWhiteDayAlbum.BackAction = function(self)
  -- function num : 0_23
  self:__RemoveWDGetPhotoReddot()
  self:Delete()
end

UIWhiteDayAlbum.OnClickClose = function(self)
  -- function num : 0_24 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIWhiteDayAlbum.OnDelete = function(self)
  -- function num : 0_25 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self._albSkinHeroListNode ~= nil then
    (self._albSkinHeroListNode):Delete()
  end
  MsgCenter:RemoveListener(eMsgEventId.WhiteDayPhotoChange, self.__onWDPhotoChange)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHeroSkin, self.__RefreshPhotoItemSkinStateCallback)
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayAlbum

