-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChangeUserTitle = class("UIChangeUserTitle", UIBaseNode)
local base = UIBaseNode
local UIToogleItem = require("Game.User.Dialogs.UITitleToogleItem")
local UINUserTitle = require("Game.CommonUI.Title.UINNormalTitleItem")
local UINUserTitleItem = require("Game.User.Dialogs.UINTitleItem")
local UINUserTitleBgItem = require("Game.User.Dialogs.UINTitleBgItem")
local titleEnum = require("Game.CommonUI.Title.TitleEnum")
UIChangeUserTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserTitleItem, UINUserTitleBgItem, UIToogleItem, UINUserTitle
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.lastTog = 0
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.OnClickRandomSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Clear, self, self.OnClickClearSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  local cs_EventTrigger = CS.EventTriggerListener
  local leftScrollerEventTrigger = (cs_EventTrigger.Get)((self.ui).obj_leftScrollbar)
  local rightScrollerEventTrigger = (cs_EventTrigger.Get)((self.ui).obj_rightScrollbar)
  leftScrollerEventTrigger:onUp("+", function()
    -- function num : 0_0_0 , upvalues : self
    ((self.ui).pagePreView_root):OnEndDrag(nil)
  end
)
  rightScrollerEventTrigger:onUp("+", function()
    -- function num : 0_0_1 , upvalues : self
    ((self.ui).pagePostView_root):OnEndDrag(nil)
  end
)
  self.resloader = ((CS.ResLoader).Create)()
  self.uiTitlePreViewItemPool = (UIItemPool.New)(UINUserTitleItem, (self.ui).obj_titlePreViewItem)
  ;
  ((self.ui).obj_titlePreViewItem):SetActive(false)
  self.uiTitlePostViewItemPool = (UIItemPool.New)(UINUserTitleItem, (self.ui).obj_titlePostViewItem)
  ;
  ((self.ui).obj_titlePostViewItem):SetActive(false)
  self.uiTitleBgItemPool = (UIItemPool.New)(UINUserTitleBgItem, (self.ui).obj_bgItem)
  ;
  ((self.ui).obj_bgItem):SetActive(false)
  self.tog_Title = (UIToogleItem.New)()
  ;
  (self.tog_Title):Init((self.ui).tog_title)
  -- DECOMPILER ERROR at PC99: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.tog_Title).changeValueFunc = BindCallback(self, self.ClickTitle)
  self.tog_titleBG = (UIToogleItem.New)()
  ;
  (self.tog_titleBG):Init((self.ui).tog_titleBG)
  -- DECOMPILER ERROR at PC113: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.tog_titleBG).changeValueFunc = BindCallback(self, self.ClickTitleBg)
  self.userTitlePreview = (UINUserTitle.New)()
  ;
  (self.userTitlePreview):Init((self.ui).obj_titleItem)
  self.__OnClickBgItem = BindCallback(self, self.OnClickBgItem)
  self.__PreTitleViewCallback = BindCallback(self, self.__PreTitleView)
  self.__PostTitleViewCallback = BindCallback(self, self.__PostTitleView)
  ;
  ((self.ui).pagePreView_root):onPageIndexChanged("+", self.__PreTitleViewCallback)
  ;
  ((self.ui).pagePostView_root):onPageIndexChanged("+", self.__PostTitleViewCallback)
  local atlasPath = PathConsts:GetSpriteAtlasPath("TitleIcon")
  self._titleBgAtlas = (self.resloader):LoadABAsset(atlasPath)
end

UIChangeUserTitle.InitChangeUserTitle = function(self)
  -- function num : 0_1
  (self.tog_Title):SelectActivityTag()
end

UIChangeUserTitle.BindCloseFun = function(self, onCloseCallback)
  -- function num : 0_2
  self._onCloseCallback = onCloseCallback
end

UIChangeUserTitle.InitChooseInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.isFirst then
    return 
  end
  self.showAll = false
  self.showType = 0
  self.lastChoose = 0
  local title = (PlayerDataCenter.inforData).title
  if title == nil or title.titlePrefix == 0 or not title.titlePrefix then
    self.choosedTitlePreId = self.choosedTitlePreId ~= nil or nil
    if title == nil or title.titlePostfix == 0 or not title.titlePostfix then
      self.choosedTitlePostId = self.choosedTitlePostId ~= nil or nil
      if title == nil or title.titleBackGround == 0 or not title.titleBackGround then
        self.choosedTitleBgId = self.choosedTitleBgId ~= nil or nil
        ;
        (self.userTitlePreview):InitNormalTitleItem(self.choosedTitlePreId, self.choosedTitlePostId, self.choosedTitleBgId, self.resloader, self._titleBgAtlas)
        self.isFirst = true
      end
    end
  end
end

UIChangeUserTitle.ClickTitle = function(self, togItem, value)
  -- function num : 0_4 , upvalues : _ENV
  if not value then
    return 
  end
  if self.lastTog == 1 then
    return 
  end
  self.lastTog = 1
  self:InitChooseInfo()
  ;
  (((self.ui).tex_Condition).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Cancle).gameObject):SetActive(true)
  ;
  (self.uiTitlePreViewItemPool):HideAll()
  ;
  (self.uiTitlePostViewItemPool):HideAll()
  ;
  ((self.ui).obj_title):SetActive(true)
  ;
  ((self.ui).obj_titleBG):SetActive(false)
  self.allPreTitleList = self:_GetUserTitleData()
  local viewPreId = 1
  local viewPostId = 1
  for i,v in pairs(self.allPreTitleList) do
    local item = (self.uiTitlePreViewItemPool):GetOne()
    item:InitTitleItem(v)
    if v.id == self.choosedTitlePreId then
      viewPreId = i
    end
  end
  for i,v in pairs(self.allPostTitleList) do
    local item = (self.uiTitlePostViewItemPool):GetOne()
    item:InitTitleItem(v)
    if v.id == self.choosedTitlePostId then
      viewPostId = i
    end
  end
  if not self.choosedTitlePreId then
    ((self.ui).obj_select):SetActive(false)
  end
  ;
  ((self.ui).pagePreView_root):InitPosList(#(self.uiTitlePreViewItemPool).listItem)
  if self.choosedTitlePreId then
    ((self.ui).pagePreView_root):SetPageIndex(#(self.uiTitlePreViewItemPool).listItem - viewPreId)
  end
  ;
  ((self.ui).pagePostView_root):InitPosList(#(self.uiTitlePostViewItemPool).listItem)
  if self.choosedTitlePostId then
    ((self.ui).pagePostView_root):SetPageIndex(#(self.uiTitlePostViewItemPool).listItem - viewPostId)
  end
end

UIChangeUserTitle._HasTitleCfg = function(self, cfg)
  -- function num : 0_5 , upvalues : _ENV
  if cfg == nil then
    return 0
  else
    return PlayerDataCenter:GetItemCount(cfg.id)
  end
end

UIChangeUserTitle._GetUserTitleData = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local cfgPreAllList = {}
  local cfgPostAllList = {}
  for id,cfg in pairs(ConfigData.title) do
    local count = self:_HasTitleCfg(cfg)
    if not cfg.is_hide and count > 0 then
      if cfg.position == 1 then
        (table.insert)(cfgPreAllList, cfg)
      else
        ;
        (table.insert)(cfgPostAllList, cfg)
      end
    end
  end
  return cfgPreAllList, cfgPostAllList
end

UIChangeUserTitle.ClickTitleBg = function(self, togItem, value)
  -- function num : 0_7 , upvalues : _ENV
  if not value then
    return 
  end
  if self.lastTog == 2 then
    return 
  end
  self.lastTog = 2
  ;
  (((self.ui).btn_Cancle).gameObject):SetActive(false)
  ;
  (self.uiTitleBgItemPool):HideAll()
  ;
  ((self.ui).obj_titleBG):SetActive(true)
  ;
  ((self.ui).obj_title):SetActive(false)
  self.allBGList = self:_GetUserTitleBgData()
  for i,v in pairs(self.allBGList) do
    local item = (self.uiTitleBgItemPool):GetOne()
    item:InitTitleBgItem(v, self.resloader, self._titleBgAtlas, self.__OnClickBgItem)
    if self.choosedTitleBgId == v.id then
      item:OnClickTitleBg()
    end
  end
end

UIChangeUserTitle._GetUserTitleBgData = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local cfgAllList = {}
  for id,cfg in pairs(ConfigData.title_background) do
    local count = self:_HasTitleCfg(cfg)
    if not cfg.is_hide and count > 0 then
      (table.insert)(cfgAllList, cfg)
    end
  end
  return cfgAllList
end

UIChangeUserTitle.OnClickBgItem = function(self, cfg)
  -- function num : 0_9 , upvalues : _ENV
  (self.userTitlePreview):SetTitleBg(cfg)
  self.choosedTitleBgId = cfg.id
  local desText = (LanguageUtil.GetLocaleText)(cfg.describe_text)
  if (string.IsNullOrEmpty)(desText) then
    (((self.ui).tex_Condition).gameObject):SetActive(false)
  else
    ;
    (((self.ui).tex_Condition).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Condition).text = ConfigData:GetTipContent(6051, desText)
  end
  for i,v in pairs((self.uiTitleBgItemPool).listItem) do
    v:SetTitleBgSelect(cfg == v.cfg)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIChangeUserTitle.__PreTitleView = function(self, index)
  -- function num : 0_10
  local realIndex = #self.allPreTitleList - index
  ;
  (self.userTitlePreview):SetPreTitle((self.allPreTitleList)[realIndex])
  self.choosedTitlePreId = ((self.allPreTitleList)[realIndex]).id
  if not self.choosedTitlePostId then
    ((self.ui).pagePostView_root):SetPageIndex(0)
  end
  ;
  ((self.ui).obj_select):SetActive(true)
  self:CheckShield()
end

UIChangeUserTitle.__PostTitleView = function(self, index)
  -- function num : 0_11
  local realIndex = #self.allPostTitleList - index
  ;
  (self.userTitlePreview):SetPostTitle((self.allPostTitleList)[realIndex])
  self.choosedTitlePostId = ((self.allPostTitleList)[realIndex]).id
  if not self.choosedTitlePreId then
    ((self.ui).pagePreView_root):SetPageIndex(0)
  end
  self:CheckShield()
end

UIChangeUserTitle.OnClickRandomSelect = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local preListCount = #self.allPreTitleList
  local postListCount = #self.allPostTitleList
  local preIndex = (math.random)(1, preListCount)
  local postIndex = (math.random)(1, #self.allPostTitleList)
  local randomNum = preListCount + postListCount
  local num = 0
  while ((ConfigData.title).blockDic)[((self.allPreTitleList)[preIndex]).id] and (((ConfigData.title).blockDic)[((self.allPreTitleList)[preIndex]).id])[((self.allPostTitleList)[postIndex]).id] do
    preIndex = (math.random)(1, preListCount)
    postIndex = (math.random)(1, postListCount)
    num = num + 1
  end
  if randomNum >= num then
    self.choosedTitlePostId = ((self.allPostTitleList)[postIndex]).id
    self.choosedTitlePreId = ((self.allPreTitleList)[preIndex]).id
    ;
    ((self.ui).pagePreView_root):SetPageIndex(preListCount - preIndex)
    ;
    ((self.ui).pagePostView_root):SetPageIndex(postListCount - postIndex)
  end
end

UIChangeUserTitle.OnClickClearSelect = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
  window:ShowTextBoxWithYesAndNo((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(6048)), function()
    -- function num : 0_13_0 , upvalues : self
    self.choosedTitlePostId = nil
    self.choosedTitlePreId = nil
    self.choosedTitleBgId = nil
    ;
    ((self.ui).obj_select):SetActive(false)
    ;
    (self.userTitlePreview):InitNormalTitleItem(self.choosedTitlePreId, self.choosedTitlePostId, self.choosedTitleBgId, self.resloader, self._titleBgAtlas)
  end
)
end

UIChangeUserTitle.OnClickConfirm = function(self)
  -- function num : 0_14 , upvalues : titleEnum, _ENV
  do
    if not self.choosedTitleBgId and self.choosedTitlePreId then
      local realTitleBgId = not self:CheckConfirm() or titleEnum.NormalBGItemId
    end
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_SetTitle(self.choosedTitlePreId, self.choosedTitlePostId, realTitleBgId)
    if self.exUserTitleCallback then
      (self.exUserTitleCallback)(self.choosedTitlePreId, self.choosedTitlePostId, realTitleBgId)
    end
    if self._onCloseCallback then
      (self._onCloseCallback)()
    end
    ;
    (PlayerDataCenter.inforData):SetTitle(self.choosedTitlePreId, self.choosedTitlePostId, realTitleBgId)
    if self._onCloseCallback then
      (self._onCloseCallback)()
    end
  end
end

UIChangeUserTitle.CheckConfirm = function(self)
  -- function num : 0_15 , upvalues : _ENV, titleEnum
  local title = (PlayerDataCenter.inforData).title
  if not self.choosedTitlePreId and not self.choosedTitlePostId and not self.choosedTitleBgId and title then
    return true
  end
  if not self.choosedTitlePreId or not self.choosedTitlePostId then
    return false
  end
  if ((ConfigData.title).blockDic)[self.choosedTitlePreId] and (((ConfigData.title).blockDic)[self.choosedTitlePreId])[self.choosedTitlePostId] then
    return false
  end
  if not title then
    return true
  end
  if self.choosedTitlePreId == title.titlePrefix and self.choosedTitlePostId == title.titlePostfix and (self.choosedTitleBgId == title.titleBackGround or self.choosedTitleBgId ~= nil or title.titleBackGround == titleEnum.NormalBGItemId) then
    return false
  end
  return true
end

UIChangeUserTitle.CheckShield = function(self)
  -- function num : 0_16 , upvalues : _ENV
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  if self.choosedTitlePreId and self.choosedTitlePostId and ((ConfigData.title).blockDic)[self.choosedTitlePreId] and (((ConfigData.title).blockDic)[self.choosedTitlePreId])[self.choosedTitlePostId] then
    ((self.ui).btn_Confirm).interactable = false
  else
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).btn_Confirm).interactable = true
  end
end

UIChangeUserTitle.SetExUserTitleChangeCallback = function(self, callback)
  -- function num : 0_17
  self.exUserTitleCallback = callback
end

UIChangeUserTitle.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  local isDirty, recordDic = (PlayerDataCenter.gameSettingData):IsGSDataDirty()
  recordDic.newTitleRead = 1
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_Client_Record_Set(recordDic)
  ;
  (PlayerDataCenter.gameSettingData):SetNewTitleItemDicEmpty()
  local ok, newTitleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Title)
  if ok then
    newTitleNode:SetRedDotCount(0)
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.tog_Title):OnDelete()
  ;
  (self.tog_titleBG):OnDelete()
  ;
  (self.userTitlePreview):OnDelete()
  ;
  (base.OnDelete)(self)
end

return UIChangeUserTitle

