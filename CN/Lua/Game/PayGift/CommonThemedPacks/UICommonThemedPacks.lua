-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonThemedPacks = class("UICommonThemedPacks", UIBaseWindow)
local base = UIBaseWindow
local UINCommonThemedPacksItem = require("Game.PayGift.CommonThemedPacks.UINCommonThemedPacksItem")
UICommonThemedPacks.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonThemedPacksItem
  (UIUtil.SetTopStatus)(self, self.OnClosePacks, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Background, self, self.OnClickClosePacks)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClosePacks)
  self._giftPool = (UIItemPool.New)(UINCommonThemedPacksItem, (self.ui).gIftItem)
  ;
  ((self.ui).gIftItem):SetActive(false)
  self.__RefillGiftCallback = BindCallback(self, self.__RefillGift)
end

UICommonThemedPacks.InitCommonThemedPacks = function(self, payGiftPopGroupId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._giftPopGroupId = payGiftPopGroupId
  local cfg = (ConfigData.pay_gift_pop_des)[payGiftPopGroupId]
  self._callback = callback
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).tex_Title).text).text = (LanguageUtil.GetLocaleText)(cfg.name)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(cfg.des)
  self._giftIdList = ((ConfigData.pay_gift_pop_des).popGroup)[payGiftPopGroupId]
  self:__RefillGift()
end

UICommonThemedPacks.InitLotteryQuickGift = function(self, giftIdList, closeFunc)
  -- function num : 0_2
  self._callback = closeFunc
  self._giftIdList = giftIdList
  self._isLtr = true
  ;
  (((self.ui).tog_Popup).gameObject):SetActive(false)
  ;
  ((self.ui).tex_Title):SetIndex(0)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = nil
  self:__RefillGift()
end

UICommonThemedPacks.__RefillGift = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self._giftPool):HideAll()
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local giftList = {}
  local giftIdxDic = {}
  for idx,giftId in ipairs(self._giftIdList) do
    local giftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    if giftInfo ~= nil and giftInfo:IsUnlock() then
      (table.insert)(giftList, giftInfo)
    end
    giftIdxDic[giftId] = idx
  end
  ;
  (table.sort)(giftList, function(a, b)
    -- function num : 0_3_0 , upvalues : giftIdxDic
    if a:IsSoldOut() ~= b:IsSoldOut() then
      return not a:IsSoldOut()
    end
    do return giftIdxDic[a.initPreGroupId] < giftIdxDic[b.initPreGroupId] end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for i,giftInfo in ipairs(giftList) do
    local item = (self._giftPool):GetOne()
    item:InitCommonThemedPacksItem(giftInfo, self.__RefillGiftCallback, not self._isLtr)
  end
end

UICommonThemedPacks.OnClickClosePacks = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if ((self.ui).tog_Popup).isOn then
    local endTime = (ControllerManager:GetController(ControllerTypeId.TimePass)):GetLogicTodayPassTimeStamp()
    local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    for _,giftId in ipairs(self._giftIdList) do
      userData:SetChipGiftPopIgnore(giftId, PlayerDataCenter.timestamp, endTime)
    end
  end
  do
    ;
    (UIUtil.OnClickBackByUiTab)(self)
  end
end

UICommonThemedPacks.OnClosePacks = function(self)
  -- function num : 0_5
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UICommonThemedPacks.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (self._giftPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UICommonThemedPacks

