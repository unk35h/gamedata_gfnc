-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbumSelectNode = class("UINWhiteDayAlbumSelectNode", UIBaseNode)
local base = UIBaseNode
local UINWhiteDayAlbumSelectNodeItem = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbumSelectNodeItem")
UINWhiteDayAlbumSelectNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWhiteDayAlbumSelectNodeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickClose)
  self.__onClickGetPhotoItem = BindCallback(self, self.__OnClickGetPhotoItem)
  self.__onReceivePhoto = BindCallback(self, self.__OnReceivePhoto)
  local secondItemGo = ((self.ui).btn_GetPhoto):Instantiate()
  self.randomItem = (UINWhiteDayAlbumSelectNodeItem.New)()
  ;
  (self.randomItem):Init((self.ui).btn_GetPhoto)
  self.exchangeItem = (UINWhiteDayAlbumSelectNodeItem.New)()
  ;
  (self.exchangeItem):Init(secondItemGo)
end

UINWhiteDayAlbumSelectNode.InitWDSelectNode = function(self, AWDCtrl, AWDData, afterGetPhoto)
  -- function num : 0_1 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDData = AWDData
  self.afterGetPhoto = afterGetPhoto
  local wdCfg = (self.AWDData):GetWDCfg()
  local randomId, randomCostNum = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
  local exchangeId, exchangeCostNum = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
  local randomNum = PlayerDataCenter:GetItemCount(randomId)
  local exchangeNum = PlayerDataCenter:GetItemCount(exchangeId)
  local desStr_random = (LanguageUtil.GetLocaleText)(wdCfg.random_des)
  local desStr_exchange = (LanguageUtil.GetLocaleText)(wdCfg.exchange_des)
  if randomNum > 0 then
    (self.randomItem):InitWDSelectNodeItem(true, randomId, randomCostNum, desStr_random, self.__onClickGetPhotoItem)
    ;
    (self.randomItem):Show()
  else
    ;
    (self.randomItem):Hide()
  end
  if exchangeNum > 0 then
    (self.exchangeItem):InitWDSelectNodeItem(false, exchangeId, exchangeCostNum, desStr_exchange, self.__onClickGetPhotoItem)
    ;
    (self.exchangeItem):Show()
  else
    ;
    (self.exchangeItem):Hide()
  end
end

UINWhiteDayAlbumSelectNode.__OnClickGetPhotoItem = function(self, isRandom)
  -- function num : 0_2 , upvalues : _ENV
  if isRandom then
    (self.AWDCtrl):WDRandomPickPhoto(self.AWDData, self.__onReceivePhoto)
    self:__OnClickClose()
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayHeroList, function(window)
    -- function num : 0_2_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitWDHeroList(self.AWDCtrl, self.AWDData, nil, true, function(photoId)
      -- function num : 0_2_0_0 , upvalues : self
      (self.AWDCtrl):WDPickPhoto(self.AWDData, photoId, self.__onReceivePhoto)
      self:__OnClickClose()
    end
, nil)
  end
)
  end
end

UINWhiteDayAlbumSelectNode.__OnReceivePhoto = function(self, photoId)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull(self.transform) then
    return 
  end
  local photoCfg = ((self.AWDData):GetWDPhotoCfgs())[photoId]
  local storyId = photoCfg.story_id
  if storyId ~= nil then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    ;
    (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, storyId, function()
    -- function num : 0_3_0 , upvalues : self, photoId
    if self.afterGetPhoto ~= nil then
      (self.afterGetPhoto)(photoId)
    end
  end
)
  end
end

UINWhiteDayAlbumSelectNode.__OnClickClose = function(self)
  -- function num : 0_4
  self:Hide()
end

UINWhiteDayAlbumSelectNode.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayAlbumSelectNode

