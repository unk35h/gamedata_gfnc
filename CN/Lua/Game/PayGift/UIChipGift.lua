-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChipGift = class("UIChipGift", UIBaseWindow)
local base = UIBaseWindow
local UINChipGiftRewardItem = require("Game.PayGift.UINChipGiftRewardItem")
local CS_Resloader = CS.ResLoader
local CS_UnityEngine_GameObject = (CS.UnityEngine).GameObject
local CS_MessageCommon = CS.MessageCommon
UIChipGift.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnBackChipGift, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.OnClickCloseBtn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Popup, self, self.OnTogIgnore)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rewardListNode).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rewardListNode).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._rewardGoDic = {}
end

UIChipGift.InitChipGift = function(self, giftInfo, callback)
  -- function num : 0_1 , upvalues : _ENV, CS_Resloader
  if not IsNull(self._heroPrefab) then
    DestroyUnityObject(self._heroPrefab)
    self._heroPrefab = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tog_Popup).isOn = false
  self.resloader = (CS_Resloader.Create)()
  self._giftInfo = giftInfo
  self._callbakc = callback
  local flag, heroId = (self._giftInfo):IsHeroConditionInGift()
  if flag then
    self:__LoadHero(heroId)
  end
  local flag, _, times = (self._giftInfo):GetLimitBuyCount()
  ;
  ((self.ui).limit):SetActive(flag)
  if flag then
    ((self.ui).tex_limit):SetIndex(0, tostring(times))
  end
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_giftName).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).name)
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_des).text = (LanguageUtil.GetLocaleText)(((self._giftInfo).groupCfg).des)
  self.rewardIds = ((self._giftInfo).defaultCfg).awardIds
  self.rewardCounts = ((self._giftInfo).defaultCfg).awardCounts
  -- DECOMPILER ERROR at PC80: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).rewardListNode).totalCount = #self.rewardIds
  ;
  ((self.ui).rewardListNode):RefillCells()
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  local flag, _, endTime = (self._giftInfo):IsUnlockTimeCondition()
  if flag and endTime > 0 then
    ((self.ui).time):SetActive(true)
    self.timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_1_0 , upvalues : self
    self:__RefreshTime()
  end
, self)
    self:__RefreshTime()
  else
    ;
    ((self.ui).time):SetActive(false)
  end
  if (self._giftInfo):IsUseItemPay() then
    (((self.ui).img_icon).gameObject):SetActive(true)
    CRH:GetSpriteByItemId(((self._giftInfo).defaultCfg).costId)
    -- DECOMPILER ERROR at PC144: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).tex_price).text = tostring(((self._giftInfo).defaultCfg).costCount)
  else
    ;
    (((self.ui).img_icon).gameObject):SetActive(false)
    local payId = ((self._giftInfo).defaultCfg).payId
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay)
    local priceStr, priceNum = payCtrl:GetPayPriceShow(payId)
    -- DECOMPILER ERROR at PC165: Confused about usage of register: R15 in 'UnsetPending'

    ;
    ((self.ui).tex_price).text = priceStr
  end
  do
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

UIChipGift.__LoadHero = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  local rscCfg = (ConfigData.resource_model)[heroCfg.src_id]
  local path = PathConsts:GetCharacterBigImgPrefabPath(rscCfg.res_Name)
  ;
  (self.resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(prefab) or IsNull(self.transform) then
      return 
    end
    self._heroPrefab = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self._heroPrefab):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("ChipGift")
  end
)
end

UIChipGift.__RefreshTime = function(self)
  -- function num : 0_3 , upvalues : _ENV
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

UIChipGift.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINChipGiftRewardItem
  local rewardItem = (UINChipGiftRewardItem.New)()
  rewardItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._rewardGoDic)[go] = rewardItem
end

UIChipGift.__OnChangeItem = function(self, go, index)
  -- function num : 0_5
  local rewardItem = (self._rewardGoDic)[go]
  rewardItem:InitChipGiftReward((self.rewardIds)[index + 1], (self.rewardCounts)[index + 1])
end

UIChipGift.OnTogIgnore = function(self, value)
  -- function num : 0_6
  ((self.ui).img_Select):SetActive(value)
end

UIChipGift.OnClickBuy = function(self)
  -- function num : 0_7 , upvalues : CS_MessageCommon, _ENV
  if not (self._giftInfo):IsUnlock() then
    (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7208))
    return 
  end
  local giftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
  giftCtrl:SendBuyGifit((self._giftInfo).defaultCfg, nil, function()
    -- function num : 0_7_0 , upvalues : self
    self:OnClickCloseBtn()
  end
)
end

UIChipGift.OnClickCloseBtn = function(self)
  -- function num : 0_8 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIChipGift.OnBackChipGift = function(self)
  -- function num : 0_9 , upvalues : _ENV
  do
    if ((self.ui).tog_Popup).isOn then
      local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      userData:SetChipGiftPopIgnore(((self._giftInfo).groupCfg).id, PlayerDataCenter.timestamp)
    end
    self:Delete()
    if self._callbakc ~= nil then
      (self._callbakc)()
    end
  end
end

UIChipGift.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if not IsNull(self._heroPrefab) then
    DestroyUnityObject(self._heroPrefab)
    self._heroPrefab = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
end

return UIChipGift

