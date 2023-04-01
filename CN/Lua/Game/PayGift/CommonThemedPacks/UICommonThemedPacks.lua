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
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(cfg.name)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(cfg.des)
  self:__RefillGift()
end

UICommonThemedPacks.__RefillGift = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self._giftPool):HideAll()
  local giftids = ((ConfigData.pay_gift_pop_des).popGroup)[self._giftPopGroupId]
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  local giftList = {}
  for _,giftId in ipairs(giftids) do
    local giftInfo = payGiftCtrl:GetPayGiftDataById(giftId)
    if giftInfo ~= nil and giftInfo:IsUnlock() then
      (table.insert)(giftList, giftInfo)
    end
  end
  ;
  (table.sort)(giftList, function(a, b)
    -- function num : 0_2_0
    if a:IsSoldOut() ~= b:IsSoldOut() then
      return not a:IsSoldOut()
    end
    do return (a.groupCfg).id < (b.groupCfg).id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for i,giftInfo in ipairs(giftList) do
    local item = (self._giftPool):GetOne()
    item:InitCommonThemedPacksItem(giftInfo, self.__RefillGiftCallback)
  end
end

UICommonThemedPacks.OnClickClosePacks = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if ((self.ui).tog_Popup).isOn then
    local giftids = ((ConfigData.pay_gift_pop_des).popGroup)[self._giftPopGroupId]
    local endTime = (ControllerManager:GetController(ControllerTypeId.TimePass)):GetLogicTodayPassTimeStamp()
    local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    for _,giftId in ipairs(giftids) do
      userData:SetChipGiftPopIgnore(giftId, PlayerDataCenter.timestamp, endTime)
    end
  end
  do
    ;
    (UIUtil.OnClickBack)()
  end
end

UICommonThemedPacks.OnClosePacks = function(self)
  -- function num : 0_4
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UICommonThemedPacks.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self._giftPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UICommonThemedPacks

