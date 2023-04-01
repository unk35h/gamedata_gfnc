-- params : ...
-- function num : 0 , upvalues : _ENV
local UICustomHeroGift = class("UICustomHeroGift", UIBaseWindow)
local base = UIBaseWindow
local UINCustomHeroGiftNode = require("Game.PayGift.UINCustomHeroGiftNode")
local UINChipGiftRewardItem = require("Game.PayGift.UINChipGiftRewardItem")
local CS_MessageCommon = CS.MessageCommon
local CS_Resloader = CS.ResLoader
UICustomHeroGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINChipGiftRewardItem, UINCustomHeroGiftNode
  (UIUtil.SetTopStatus)(self, self.OnBackHeroSelectGift, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, nil, UIUtil.OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Popup, self, self.OnTogIgnore)
  self._rewardPool = (UIItemPool.New)(UINChipGiftRewardItem, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self._selectHeroItem = (UINCustomHeroGiftNode.New)()
  ;
  (self._selectHeroItem):Init((self.ui).heroSelectItem)
  ;
  (self._selectHeroItem):BindGiftHeroSelectCallback(BindCallback(self, self.OnClickSelectHero))
end

UICustomHeroGift.InitCustomHeroGift = function(self, giftInfo, callback)
  -- function num : 0_1 , upvalues : CS_Resloader, _ENV
  self._giftInfo = giftInfo
  self._callback = callback
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.resloader = (CS_Resloader.Create)()
  self._isHeroSelct = (self._giftInfo):IsSelfSelectHeroGift()
  local flag, _, times = (self._giftInfo):GetLimitBuyCount()
  ;
  ((self.ui).limit):SetActive(flag)
  if flag then
    ((self.ui).tex_limit):SetIndex(0, tostring(times))
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  local flag, _, endTime = (self._giftInfo):IsUnlockTimeCondition()
  if flag and endTime > 0 then
    ((self.ui).time):SetActive(true)
    self._timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_1_0 , upvalues : self
    self:__RefreshTime()
  end
, self)
    self:__RefreshTime()
  else
    ;
    ((self.ui).time):SetActive(false)
  end
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_giftName).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).name)
  -- DECOMPILER ERROR at PC86: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_des).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).des)
  if (self._giftInfo):IsUseItemPay() then
    (((self.ui).img_icon).gameObject):SetActive(true)
    CRH:GetSpriteByItemId(((self._giftInfo).defaultCfg).costId)
    -- DECOMPILER ERROR at PC111: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tex_price).text = tostring(((self._giftInfo).defaultCfg).costCount)
  else
    ;
    (((self.ui).img_icon).gameObject):SetActive(false)
    local payId = ((self._giftInfo).defaultCfg).payId
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
    local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
    -- DECOMPILER ERROR at PC132: Confused about usage of register: R13 in 'UnsetPending'

    ;
    ((self.ui).tex_price).text = priceStr
  end
  do
    self:__GenRewardList()
    local path = ((self._giftInfo).groupCfg).pop_bg_res
    if not (string.IsNullOrEmpty)(path) then
      (((self.ui).bg).gameObject):SetActive(false)
      ;
      (self.resloader):LoadABAssetAsync(PathConsts:GetGiftPopBg(path), function(texture)
    -- function num : 0_1_1 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(self.transform) then
      ((self.ui).bg).texture = texture
      ;
      (((self.ui).bg).gameObject):SetActive(true)
    end
  end
)
    end
  end
end

UICustomHeroGift.__RefreshTime = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local _, _, endTime = (self._giftInfo):IsUnlockTimeCondition()
  local diff = endTime - PlayerDataCenter.timestamp
  if diff <= 0 then
    if self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
    ;
    ((self.ui).tex_Time):SetIndex(3, "0")
    return 
  end
  local d = (math.floor)(diff / 86400)
  diff = diff % 86400
  local h = (math.floor)(diff / 3600)
  diff = diff % 3600
  local m = (math.floor)(diff / 60)
  local s = (math.floor)(diff % 60)
  if d > 0 then
    ((self.ui).tex_Time):SetIndex(0, tostring(d), tostring(h), tostring(m))
  else
    if h > 0 then
      ((self.ui).tex_Time):SetIndex(1, tostring(h), tostring(m))
    else
      if m > 0 then
        ((self.ui).tex_Time):SetIndex(2, tostring(m), tostring(s))
      else
        ;
        ((self.ui).tex_Time):SetIndex(3, tostring(s))
      end
    end
  end
end

UICustomHeroGift.__GenRewardList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:RefreshcCustomNode()
  local rewardIds = ((self._giftInfo).defaultCfg).awardIds
  local rewardCounts = ((self._giftInfo).defaultCfg).awardCounts
  ;
  (self._rewardPool):HideAll()
  for i,itemId in ipairs(rewardIds) do
    local count = rewardCounts[i]
    local item = (self._rewardPool):GetOne()
    item:InitChipGiftReward(itemId, count)
  end
end

UICustomHeroGift.OnClickBuy = function(self)
  -- function num : 0_4 , upvalues : CS_MessageCommon, _ENV
  if not (self._giftInfo):IsUnlock() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7208))
    return 
  end
  if not (self._giftInfo):GetSelfSelectGiftIsSelected() then
    if self._isHeroSelct then
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(418))
    else
      ;
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(419))
    end
    return 
  end
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local paramList = (self._giftInfo):GetSelfSelectGiftParams()
  payGiftCtrl:SendBuyGifit((self._giftInfo).defaultCfg, paramList, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      (UIUtil.OnClickBack)()
    end
  end
)
end

UICustomHeroGift.OnClickSelectHero = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  payGiftCtrl:SelfSelectGift((self._giftInfo).defaultCfg, self._giftInfo, function()
    -- function num : 0_5_0 , upvalues : self
    self:RefreshcCustomNode()
  end
)
end

UICustomHeroGift.RefreshcCustomNode = function(self)
  -- function num : 0_6
  local params = (self._giftInfo):GetSelfSelectGiftParams()
  local selectHeroId = params ~= nil and (params[1]).param or nil
  if self._isHeroSelct then
    (self._selectHeroItem):RefreshCustomHeroGiftSelect(selectHeroId)
  else
    ;
    (self._selectHeroItem):RefreshCustomChipGiftSelect(selectHeroId)
  end
end

UICustomHeroGift.OnTogIgnore = function(self, value)
  -- function num : 0_7
  ((self.ui).img_Select):SetActive(value)
end

UICustomHeroGift.OnBackHeroSelectGift = function(self)
  -- function num : 0_8 , upvalues : _ENV
  do
    if ((self.ui).tog_Popup).isOn then
      local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      userData:SetChipGiftPopIgnore(((self._giftInfo).groupCfg).id, PlayerDataCenter.timestamp)
    end
    ;
    (self._giftInfo):CleanSelfSelectInfo()
    self:Delete()
    if self._callback ~= nil then
      (self._callback)()
    end
  end
end

UICustomHeroGift.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICustomHeroGift

