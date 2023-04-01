-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopRefreshNode = class("UINShopRefreshNode", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINShopRefreshNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnRefreshBtnClick)
  self._RefreshCallback = BindCallback(self, self.RefreshCallback)
  self.__UpdateTime = BindCallback(self, self.UpdateTime)
end

UINShopRefreshNode.HeadBarCommonInit = function(self, uiShop)
  -- function num : 0_1
  self.OpenShopePageCallback = uiShop.__OnClickRefreshShop
  self.shopCtrl = uiShop.shopCtrl
end

UINShopRefreshNode.RefreshHeadBarNode = function(self, shopData)
  -- function num : 0_2
  ((self.ui).obj_refresh):SetActive(false)
  if shopData == nil then
    return 
  end
  if not shopData:GetIsHaveRefresh() then
    return 
  end
  ;
  ((self.ui).obj_refresh):SetActive(true)
  self:InitRefreshNode(shopData)
end

UINShopRefreshNode.InitRefreshNode = function(self, shopData)
  -- function num : 0_3 , upvalues : _ENV
  self.shopData = shopData
  ;
  (((self.ui).btn_Refresh).gameObject):SetActive(true)
  ;
  (((self.ui).tex_CashNum).gameObject):SetActive(shopData.couldFresh)
  ;
  (((self.ui).img_CashIcon).gameObject):SetActive(shopData.couldFresh)
  ;
  ((self.ui).tex_limit):SetActive(not shopData.couldFresh)
  if shopData.couldFresh then
    self.cost = shopData.refreshCost
    self.costItemCfg = (ConfigData.item)[(self.cost).costId]
    local costNum = (self.cost).costNum
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_CashNum).text = costNum
    local smallIcon = (self.costItemCfg).small_icon
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_CashIcon).sprite = CRH:GetSprite(smallIcon)
    ;
    ((self.ui).text_Count):SetIndex(0, tostring(shopData.freshCount), tostring(shopData.couldFreshCount))
  else
    do
      ;
      ((self.ui).text_Count):SetIndex(0, tostring(shopData.couldFreshCount), tostring(shopData.couldFreshCount))
      ;
      (self.shopCtrl):AddShopTimerCallback(self.__UpdateTime, "RefreshNode")
      self:UpdateTime()
    end
  end
end

UINShopRefreshNode.UpdateTime = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local time = (self.shopData):GetRemainAutoRefreshTime()
  local d, h, m, s = TimeUtil:TimestampToTimeInter(time, false, true)
  if h < 10 or not tostring(h) then
    local hStr = "0" .. tostring(h)
  end
  if m < 10 or not tostring(m) then
    local mStr = "0" .. tostring(m)
  end
  if s < 10 or not tostring(s) then
    local sStr = "0" .. tostring(s)
  end
  if d > 0 then
    ((self.ui).tex_Timer):SetIndex(0, tostring(d), hStr, mStr, sStr)
  else
    ;
    ((self.ui).tex_Timer):SetIndex(1, hStr, mStr, sStr)
  end
  if time < -1 then
    (self.shopCtrl):ReqShopDetail((self.shopData).shopId, self._RefreshCallback)
    ;
    (self.shopCtrl):RemoveShopTimerCallback(self.__UpdateTime)
  end
end

UINShopRefreshNode.OnRefreshBtnClick = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if not (self.shopData).couldFresh then
    ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Shop_CanNotRefresh_RefreshCountInsufficient))
    return 
  end
  local msg = ConfigData:GetTipContent(328, (self.cost).costNum, (LanguageUtil.GetLocaleText)((self.costItemCfg).name))
  if self._refreshShopFunc == nil then
    self._refreshShopFunc = BindCallback(self, self._RefreshShop)
  end
  if (PlayerDataCenter.cacheSaveData):GetEnableShopRefreshExecuteConfirm() then
    local window = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    window:ShowTextBoxWithYesAndNo(msg, self._refreshShopFunc)
    window:ShowDontRemindTog(function(isOn)
    -- function num : 0_5_0 , upvalues : _ENV
    (PlayerDataCenter.cacheSaveData):SetEnableShopRefreshExecuteConfirm(not isOn)
  end
)
  else
    do
      ;
      (self._refreshShopFunc)()
    end
  end
end

UINShopRefreshNode._RefreshShop = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_MessageCommon
  local buyFunc = function()
    -- function num : 0_6_0 , upvalues : self, _ENV
    (self.shopCtrl):RemoveShopTimerCallback(self.__UpdateTime)
    local win = UIManager:GetWindow(UIWindowTypeID.QuickBuy)
    if win ~= nil then
      win:SlideOut()
    end
    ;
    (self.shopCtrl):ReqRefreshShopDetail((self.shopData).shopId, self._RefreshCallback)
  end

  local ownNum = PlayerDataCenter:GetItemCount((self.cost).costId)
  if (self.cost).costNum <= ownNum then
    buyFunc()
  else
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
    if not payCtrl:TryConvertPayItem((self.cost).costId, (self.cost).costNum - ownNum, nil, nil, buyFunc) then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)((string.format)(ConfigData:GetTipContent(TipContent.Shop_CanNotRefresh_LackOfItem), (LanguageUtil.GetLocaleText)((self.costItemCfg).name)))
    end
  end
end

UINShopRefreshNode.RefreshCallback = function(self)
  -- function num : 0_7 , upvalues : cs_MessageCommon, _ENV
  self:_TryHideShowMessageCommon(function()
    -- function num : 0_7_0 , upvalues : cs_MessageCommon, _ENV
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(329))
  end
)
  if self.OpenShopePageCallback ~= nil then
    local win = UIManager:GetWindow(UIWindowTypeID.QuickBuy)
    if win ~= nil then
      win:SlideOut()
    end
    ;
    (self.OpenShopePageCallback)((self.shopData).shopId)
  end
end

UINShopRefreshNode._TryHideShowMessageCommon = function(self, Func)
  -- function num : 0_8 , upvalues : _ENV, cs_MessageCommon
  local window = UIManager:GetWindow(UIWindowTypeID.MessageCommon)
  if window ~= nil and window.active then
    window:Hide()
    if Func ~= nil then
      Func()
    end
    ;
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(329))
  end
end

UINShopRefreshNode.OnHide = function(self)
  -- function num : 0_9 , upvalues : base
  (self.shopCtrl):RemoveShopTimerCallback(self.__UpdateTime)
  self:_TryHideShowMessageCommon()
  ;
  (base.OnHide)(self)
end

UINShopRefreshNode.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINShopRefreshNode

