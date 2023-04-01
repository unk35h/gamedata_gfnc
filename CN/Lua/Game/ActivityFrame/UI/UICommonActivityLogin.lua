-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonActivityLogin = class("UICommonActivityLogin", UIBaseWindow)
local base = UIBaseWindow
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UICommonActivityLogin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Background, self, self.OnActivityBtnCloseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnActivityBtnCloseClicked)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Popup, self, self.OnReadOnePopupChanged)
  ;
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.resloader = ((CS.ResLoader).Create)()
end

UICommonActivityLogin.InitActivityLoginUI = function(self, loginPopupUiCfg)
  -- function num : 0_1 , upvalues : _ENV
  self.__loginPopupUiCfg = loginPopupUiCfg
  local prefabPath = PathConsts:GetUIPrefabPath("ActivityLoginInHolder/" .. (self.__loginPopupUiCfg).login_prefab)
  ;
  (self.resloader):LoadABAssetAsync(prefabPath, function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, loginPopupUiCfg, self
    if IsNull(prefab) then
      return 
    end
    if loginPopupUiCfg ~= self.__loginPopupUiCfg then
      return 
    end
    local go = prefab:Instantiate()
    self:__InitActivityGameObject(go)
  end
)
  local systemSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tog_Popup).isOn = systemSaveData:GetActEntranceReadOneValue()
  ;
  (((self.ui).tog_Popup).gameObject):SetActive(not loginPopupUiCfg.ishide)
end

UICommonActivityLogin.__InitActivityGameObject = function(self, go)
  -- function num : 0_2 , upvalues : _ENV, UINBaseItem
  (go.transform):SetParent((self.ui).activityHolder)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (go.transform).localScale = Vector3.one
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (go.transform).anchoredPosition3D = Vector3.zero
  self.contentui = {}
  ;
  (UIUtil.LuaUIBindingTable)(go.transform, self.contentui)
  if (self.contentui).jumpBtn ~= nil then
    (UIUtil.AddButtonListener)((self.contentui).jumpBtn, self, self.OnClickJump)
  end
  if self.lateJumpFunc ~= nil then
    (self.lateJumpFunc)()
  end
  if self.lateTimeFunc ~= nil then
    (self.lateTimeFunc)()
  end
  if (self.__loginPopupUiCfg).item_icon <= 0 then
    return 
  end
  local itemCfg = (ConfigData.item)[(self.__loginPopupUiCfg).item_icon]
  if itemCfg == nil then
    error("item cfg is null,id:" .. tostring((self.__loginPopupUiCfg).item_icon))
    return 
  end
  self.baseItem = (UINBaseItem.New)()
  ;
  (self.baseItem):Init((self.contentui).baseItem)
  ;
  (self.baseItem):SetNotNeedAnyJump(true)
  ;
  (self.baseItem):InitBaseItem(itemCfg)
end

UICommonActivityLogin.SetJumpFunc = function(self, func)
  -- function num : 0_3 , upvalues : _ENV
  self.lateJumpFunc = function()
    -- function num : 0_3_0 , upvalues : _ENV, self, func
    if not IsNull(((self.contentui).jumpBtn).gameObject) then
      self._jumpCallback = func
    end
  end

end

UICommonActivityLogin.SetTimeId = function(self, isShop, shopId)
  -- function num : 0_4 , upvalues : _ENV
  self.lateTimeFunc = function()
    -- function num : 0_4_0 , upvalues : _ENV, self, isShop, shopId
    if IsNull(((self.contentui).tex_time).gameObject) then
      return 
    end
    if isShop == false then
      return 
    end
    local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
    if not shopCtrl:GetIsThisShopHasTimeLimit(shopId) then
      return 
    end
    self:ClearTimeId()
    local timeCut = function()
      -- function num : 0_4_0_0 , upvalues : shopCtrl, shopId, _ENV, self
      local hasLimit, startTime, endTime = shopCtrl:GetIsThisShopHasTimeLimit(shopId)
      if not hasLimit then
        (UIUtil.OnClickBack)()
        return 
      end
      local remaindTime = endTime - PlayerDataCenter.timestamp
      local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
      if remaindTime < 0 then
        (UIUtil.OnClickBack)()
        return 
      end
      if d > 0 then
        ((self.contentui).tex_time):SetIndex(0, tostring(d), tostring(h), tostring(m))
      else
        if h > 0 then
          ((self.contentui).tex_time):SetIndex(1, tostring(h), tostring(m))
        else
          if m > 0 then
            ((self.contentui).tex_time):SetIndex(2, tostring(m), tostring(s))
          else
            ;
            ((self.contentui).tex_time):SetIndex(3, tostring(s))
          end
        end
      end
    end

    self._timerID = TimerManager:StartTimer(1, timeCut, self, false, false, false)
    timeCut()
  end

end

UICommonActivityLogin.SetIgnoreExtraPopupUI = function(self)
  -- function num : 0_5
  (((self.ui).btn_Close).gameObject):SetActive(false)
  ;
  (((self.ui).tog_Popup).gameObject):SetActive(false)
end

UICommonActivityLogin.OnClickJump = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._jumpCallback ~= nil then
    (UIUtil.OnClickBack)()
    ;
    (self._jumpCallback)()
  end
end

UICommonActivityLogin.BackAction = function(self)
  -- function num : 0_7
  self:Delete()
  if self.__closeCallback ~= nil then
    local action = self.__closeCallback
    self.__closeCallback = nil
    action()
  end
end

UICommonActivityLogin.SetCloseCallback = function(self, callback)
  -- function num : 0_8
  self.__closeCallback = callback
end

UICommonActivityLogin.OnActivityBtnCloseClicked = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UICommonActivityLogin.OnReadOnePopupChanged = function(self, value)
  -- function num : 0_10 , upvalues : _ENV
  local systemSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)
  systemSaveData:SetActEntranceReadOneValue(value)
end

UICommonActivityLogin.ClearTimeId = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self._timerID ~= nil then
    TimerManager:StopTimer(self._timerID)
    self._timerID = nil
  end
end

UICommonActivityLogin.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  if self.__loginPopupUiCfg ~= nil and ((self.ui).tog_Popup).isOn then
    local showTime = (math.floor)(PlayerDataCenter.timestamp)
    local userSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    userSaveData:SaveActEntranceLastShow((self.__loginPopupUiCfg).id, showTime)
  end
  do
    PersistentManager:SaveModelData((PersistentConfig.ePackage).SystemData)
    PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
    if self.resloader ~= nil then
      (self.resloader):Put2Pool()
      self.resloader = nil
    end
    self:ClearTimeId()
    ;
    (base.OnDelete)(self)
  end
end

return UICommonActivityLogin

