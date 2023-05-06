-- params : ...
-- function num : 0 , upvalues : _ENV
local UIQuickPurchaseKey = class("UIQuickPurchaseKey", UIBaseWindow)
local base = UIBaseWindow
local HomeEnum = require("Game.Home.HomeEnum")
local UINQuickPrchaseKayItemNode = require("Game.QuickPurchaseBox.PurchaseKey.UINQuickPrchaseKayItemNode")
local UINQuickPrchaseKayMoneyNode = require("Game.QuickPurchaseBox.PurchaseKey.UINQuickPrchaseKayMoneyNode")
local cs_MessageCommon = CS.MessageCommon
local ShopEnum = require("Game.Shop.ShopEnum")
local quickBuyData = (ShopEnum.eQuickBuy).stamina
UIQuickPurchaseKey.eBuyKeyTogType = {usePackage = 1, useMoney = 2}
UIQuickPurchaseKey.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINQuickPrchaseKayItemNode, UINQuickPrchaseKayMoneyNode, UIQuickPurchaseKey, _ENV
  self.keyPackageList = nil
  self.selectedTogType = nil
  self.maxNeededKeyNum = nil
  self.itemNode = (UINQuickPrchaseKayItemNode.New)()
  ;
  (self.itemNode):Init((self.ui).obj_useItem)
  ;
  (self.itemNode):Hide()
  self.moneyNode = (UINQuickPrchaseKayMoneyNode.New)()
  ;
  (self.moneyNode):Init((self.ui).obj_useMoney)
  ;
  (self.moneyNode):Hide()
  self.togUIDic = {
[(UIQuickPurchaseKey.eBuyKeyTogType).usePackage] = {tog = (self.ui).tog_useItem, selectObj = (self.ui).obj_itemSelect, text = (self.ui).tex_UseItem, page = self.itemNode, image = (self.ui).img_tog_Item}
, 
[(UIQuickPurchaseKey.eBuyKeyTogType).useMoney] = {tog = (self.ui).tog_useMoney, selectObj = (self.ui).obj_moneySelect, text = (self.ui).tex_UseMoney, page = self.moneyNode, image = nil}
}
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_Back, self, self.SlideOut, nil, true)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_useItem, self, self._OnClickTog, (UIQuickPurchaseKey.eBuyKeyTogType).usePackage)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_useMoney, self, self._OnClickTog, (UIQuickPurchaseKey.eBuyKeyTogType).useMoney)
  ;
  (((self.ui).tween_side).onComplete):AddListener(BindCallback(self, self.OnSlideInComplete))
  ;
  (((self.ui).tween_side).onRewind):AddListener(BindCallback(self, self.OnSlideInClose))
  self.__SlideOut = BindCallback(self, self.SlideOut, false, true)
end

UIQuickPurchaseKey.InitQuickPurchaseKey = function(self, defaultTogType, maxNeededKeyNum, goodData, closeCallback)
  -- function num : 0_1 , upvalues : UIQuickPurchaseKey
  self.maxNeededKeyNum = maxNeededKeyNum
  self.goodData = goodData
  self.closeCallback = closeCallback
  ;
  (self.itemNode):RefreshCouldUsePackList()
  local isHaveCouldUseItem = (self.itemNode):GetIsHavePackageList()
  ;
  (self.moneyNode):SetNodeData(self, goodData)
  ;
  (self.itemNode):SetNodeData(self)
  local selectedTogType = nil
  if defaultTogType ~= nil then
    selectedTogType = defaultTogType
  else
    if isHaveCouldUseItem then
      selectedTogType = (UIQuickPurchaseKey.eBuyKeyTogType).usePackage
    else
      selectedTogType = (UIQuickPurchaseKey.eBuyKeyTogType).useMoney
    end
  end
  self:SelectTog(selectedTogType)
end

UIQuickPurchaseKey.SlideIn = function(self, isJumpIn, isHideLeftBtn)
  -- function num : 0_2 , upvalues : _ENV, HomeEnum
  self.isJumpIn = isJumpIn
  self.__isHideLeftBtn = isHideLeftBtn
  ;
  ((self.ui).tween_side):DOPlayForward()
  AudioManager:PlayAudioById(1070)
  if not self.isJumpIn then
    (UIUtil.SetTopStatus)(self, self.SlideOut, {1001, 1002, 1007}, nil, nil, nil)
    ;
    (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
  else
    local backData = (UIUtil.PeekBackStack)()
    if backData == nil or backData.backAction == nil then
      if (ControllerManager:GetController(ControllerTypeId.HomeController)).homeState == (HomeEnum.eHomeState).Normal then
        (UIUtil.SetTopStatus)(self, self.SlideOut, nil, nil, nil, nil)
        ;
        (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
      else
        ;
        (UIUtil.SetTopStatus)(self, self.SlideOut, {1001, 1002, 1007}, nil, nil, nil)
        ;
        (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
      end
    else
      ;
      (UIUtil.SetTopStatus)(self, self.SlideOut, {1001, 1002, 1007}, nil, nil, nil)
      ;
      (UIUtil.SetCurButtonGroupActive)(not isHideLeftBtn)
    end
  end
  do
    self.slideInOver = false
    self.isSlideOuting = false
  end
end

UIQuickPurchaseKey.OnSlideInComplete = function(self)
  -- function num : 0_3
  self.slideInOver = true
end

UIQuickPurchaseKey.SlideOut = function(self, isHome, popBackStack)
  -- function num : 0_4 , upvalues : _ENV
  if not self.slideInOver then
    self:OnSlideInClose()
    if popBackStack then
      (UIUtil.PopFromBackStackByUiTab)(self)
    end
    if self.closeCallback ~= nil then
      (self.closeCallback)()
    end
    return 
  else
    if self.isSlideOuting then
      return 
    end
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self.isSlideOuting = true
  AudioManager:PlayAudioById(1071)
  ;
  ((self.ui).tween_side):DOPlayBackwards()
  if popBackStack then
    if not self.isJumpIn then
      (UIUtil.PopFromBackStackByUiTab)(self)
      self.isJumpIn = nil
    else
      ;
      (UIUtil.PopFromBackStackByUiTab)(self)
    end
  end
end

UIQuickPurchaseKey._OnClickTog = function(self, type, bool)
  -- function num : 0_5 , upvalues : UIQuickPurchaseKey, _ENV
  local togUIDic = (self.togUIDic)[type]
  ;
  (togUIDic.selectObj):SetActive(not bool)
  if bool then
    self.selectedTogType = type
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (togUIDic.text).color = (self.ui).color_black
    ;
    (togUIDic.page):Show()
    ;
    (togUIDic.page):InitQPKNode(self.maxNeededKeyNum, self.__SlideOut)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    if type == (UIQuickPurchaseKey.eBuyKeyTogType).usePackage then
      (togUIDic.image).color = Color.black
    end
  else
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (togUIDic.text).color = (self.ui).color_white
    ;
    (togUIDic.page):Hide()
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

    if type == (UIQuickPurchaseKey.eBuyKeyTogType).usePackage then
      (togUIDic.image).color = Color.white
    end
  end
end

UIQuickPurchaseKey.SelectTog = function(self, selectedTogType)
  -- function num : 0_6 , upvalues : _ENV, UIQuickPurchaseKey
  for _,type in pairs(UIQuickPurchaseKey.eBuyKeyTogType) do
    local isSelected = type == selectedTogType
    self:_OnClickTog(type, isSelected)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.togUIDic)[type]).tog).isOn = isSelected
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

local waitRecorverNUM = 0
UIQuickPurchaseKey.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_7 , upvalues : _ENV, waitRecorverNUM
  local dataTable = {}
  for key,value in pairs(self) do
    dataTable[key] = value
  end
  waitRecorverNUM = waitRecorverNUM + 1
  self:SlideOut(nil, true)
  return function()
    -- function num : 0_7_0 , upvalues : waitRecorverNUM, _ENV, dataTable, self
    waitRecorverNUM = waitRecorverNUM - 1
    for key,value in pairs(dataTable) do
      self[key] = value
    end
    self:SlideIn(self.isJumpIn, self.__isHideLeftBtn)
    self:InitQuickPurchaseKey(self.selectedTogType, self.maxNeededKeyNum, self.goodData, self.closeCallback)
  end

end

UIQuickPurchaseKey.OnSlideInClose = function(self)
  -- function num : 0_8 , upvalues : waitRecorverNUM
  self.isSlideOuting = false
  if waitRecorverNUM <= 0 then
    self:Delete()
  else
    self:Hide()
  end
end

UIQuickPurchaseKey.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self.itemNode):Delete()
  ;
  (self.moneyNode):Delete()
  ;
  (base.OnDelete)(self)
end

return UIQuickPurchaseKey

