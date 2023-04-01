-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbHeroList = class("UINWhiteDayAlbHeroList", UIBaseNode)
local base = UIBaseNode
local UINWhiteDayAlbHero = require("Game.ActivityWhiteDay.UI.Album.UINWhiteDayAlbHero")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local JumpManager = require("Game.Jump.JumpManager")
local ShopEnum = require("Game.Shop.ShopEnum")
UINWhiteDayAlbHeroList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirmAlbHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickIntro)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.OnChangeItem)
  self._itemDic = {}
  self.__OnSelectPhotoCallback = BindCallback(self, self.__OnSelectPhoto)
  self._resloader = (cs_ResLoader.Create)()
  self.__ItemUpdateCallback = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
end

UINWhiteDayAlbHeroList.InitAlbHeroList = function(self, AWDData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = AWDData
  self._callback = callback
  local awdCfg = (self._data):GetWDCfg()
  self._costId = (awdCfg.skinCostIds)[1]
  self._costNum = (awdCfg.skinCostNums)[1]
  self._firstCostNum = (awdCfg.skinFirstCostNums)[1]
  self._skinOrgCostNums = (awdCfg.skinOrgCostNums)[1]
  local sprite = CRH:GetSpriteByItemId(self._costId, true)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon_title).sprite = sprite
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon_cost).sprite = sprite
  sprite = CRH:GetSpriteByItemId(ConstGlobalItem.PaidItem, true)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon_QZ).sprite = sprite
  self:RefreshAlbHeroList()
end

UINWhiteDayAlbHeroList.AutoSelectAlbHero = function(self, skinId)
  -- function num : 0_2 , upvalues : _ENV
  local selectPhotoCfg, index = nil, nil
  for i,photoCfg in ipairs(self._photoHeroCfgList) do
    if photoCfg.skinId == skinId then
      index = i - 1
      selectPhotoCfg = photoCfg
      break
    end
  end
  do
    if selectPhotoCfg == nil then
      return 
    end
    self._selectPhotoCfg = nil
    self._selectAlbHeroItem = nil
    ;
    ((self.ui).scroll):SrollToCell(index, 9999, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, selectPhotoCfg
    for go,item in pairs(self._itemDic) do
      if item:GetPhotoHeroCfg() == selectPhotoCfg then
        self._selectPhotoCfg = selectPhotoCfg
        self._selectAlbHeroItem = item
        ;
        (self._selectAlbHeroItem):SetAlbHeroSelectState(true)
      else
        item:SetAlbHeroSelectState(false)
      end
    end
  end
)
  end
end

UINWhiteDayAlbHeroList.RefreshAlbHeroList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._selectPhotoCfg = nil
  self._selectAlbHeroItem = nil
  self:__ItemUpdate()
  local unlockPhotoDic = (self._data):GetWDUnlockedPhotoDic()
  local photoCfgs = (self._data):GetWDPhotoCfgs()
  self._photoHeroCfgList = {}
  for id,_ in pairs(unlockPhotoDic) do
    local cfg = photoCfgs[id]
    if cfg.skinId ~= nil and (PlayerDataCenter.skinData):IsSkinUnlocked(cfg.skinId) and not (PlayerDataCenter.skinData):IsHaveSkin(cfg.skinId) then
      (table.insert)(self._photoHeroCfgList, cfg)
    end
  end
  ;
  (table.sort)(self._photoHeroCfgList, function(a, b)
    -- function num : 0_3_0
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).totalCount = #self._photoHeroCfgList
  ;
  ((self.ui).scroll):RefillCells()
  self:__RefreshConfirmBtnState()
end

UINWhiteDayAlbHeroList.OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINWhiteDayAlbHero
  local item = (UINWhiteDayAlbHero.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = item
end

UINWhiteDayAlbHeroList.OnChangeItem = function(self, go, index)
  -- function num : 0_5
  local item = (self._itemDic)[go]
  if item == self._selectAlbHeroItem then
    self._selectAlbHeroItem = nil
  end
  local cfg = (self._photoHeroCfgList)[index + 1]
  item:InitAlbHero(cfg, self._resloader, self.__OnSelectPhotoCallback)
  if cfg == self._selectPhotoCfg then
    self._selectAlbHeroItem = item
    ;
    (self._selectAlbHeroItem):SetAlbHeroSelectState(true)
  end
end

UINWhiteDayAlbHeroList.__ItemUpdate = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Count_title).text = tostring(PlayerDataCenter:GetItemCount(self._costId))
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Count_QZ).text = tostring(PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem))
end

UINWhiteDayAlbHeroList.__RefreshConfirmBtnState = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._firstCostNum ~= nil and not (self._data):GetWDIsPhotoSkinBought() then
    (((self.ui).tex_oldPrice).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_oldPrice).text = tostring(self._costNum)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_Count_cost).text = tostring(self._firstCostNum)
  else
    if self._skinOrgCostNums ~= nil then
      (((self.ui).tex_oldPrice).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_oldPrice).text = tostring(self._skinOrgCostNums)
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_Count_cost).text = tostring(self._costNum)
    else
      ;
      (((self.ui).tex_oldPrice).gameObject):SetActive(false)
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).tex_Count_cost).text = tostring(self._costNum)
    end
  end
end

UINWhiteDayAlbHeroList.__OnSelectPhoto = function(self, photoCfg, albHeroItem)
  -- function num : 0_8
  if self._selectAlbHeroItem ~= nil then
    (self._selectAlbHeroItem):SetAlbHeroSelectState(false)
  end
  if self._selectPhotoCfg == photoCfg then
    self._selectPhotoCfg = nil
    self._selectAlbHeroItem = nil
    return 
  end
  self._selectAlbHeroItem = albHeroItem
  self._selectPhotoCfg = photoCfg
  ;
  (self._selectAlbHeroItem):SetAlbHeroSelectState(true)
end

UINWhiteDayAlbHeroList.OnClickConfirmAlbHero = function(self)
  -- function num : 0_9 , upvalues : cs_MessageCommon, _ENV, CommonRewardData, ShopEnum
  if self._selectPhotoCfg == nil then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7214))
    return 
  end
  local LocalFunc_Buy = function()
    -- function num : 0_9_0 , upvalues : self, _ENV, CommonRewardData
    local actFrameId = (self._data):GetActFrameId()
    local photoId = (self._selectPhotoCfg).id
    local whiteNet = NetworkManager:GetNetwork(NetworkTypeID.WhiteDay)
    local skinId = (self._selectPhotoCfg).skinId
    whiteNet:CS_Activity_Polariod_Buy_Skin(actFrameId, photoId, function(msg)
      -- function num : 0_9_0_0 , upvalues : skinId, _ENV, CommonRewardData, self
      local itemIds = {skinId}
      local itemCounts = {1}
      local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
      UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
        -- function num : 0_9_0_0_0 , upvalues : CommonRewardData, itemIds, itemCounts, heroIdSnapShoot
        if window == nil then
          return 
        end
        local CRData = (((CommonRewardData.CreateCRDataUseList)(itemIds, itemCounts)):SetCRHeroSnapshoot(heroIdSnapShoot, false)):SetCRNotHandledGreat(true)
        window:AddAndTryShowReward(CRData)
      end
)
      if not IsNull(self.transform) then
        if (self._data):GetWDIsUnlockPhotoSkinGet() then
          self:Hide()
        else
          self:RefreshAlbHeroList()
          self:__RefreshConfirmBtnState()
        end
      end
    end
)
  end

  local hasNum = PlayerDataCenter:GetItemCount(self._costId)
  local isBought = (self._data):GetWDIsPhotoSkinBought()
  -- DECOMPILER ERROR at PC41: Unhandled construct in 'MakeBoolean' P3

  if (hasNum < self._costNum and self._firstCostNum == nil) or self._firstCostNum ~= nil and hasNum < self._firstCostNum and not isBought then
    if self._costId == ConstGlobalItem.PaidSubItem then
      local diff = self._costNum - hasNum
      do
        if diff <= PlayerDataCenter:GetItemCount(ConstGlobalItem.PaidItem) then
          local diffStr = tostring(diff)
          local tip = (string.format)(ConfigData:GetTipContent(10008), diffStr, diffStr)
          ;
          (cs_MessageCommon.ShowMessageBox)(tip, LocalFunc_Buy, nil)
        else
          do
            do
              do
                local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
                payCtrl:Jump2BuyQuartz(nil, nil, true)
                return 
              end
              if self._costId == ConstGlobalItem.ActivityToken then
                local quickBuyData = (ShopEnum.eQuickBuy).activityToken
                local shopId = quickBuyData.shopId
                local shelfId = quickBuyData.shelfId
                local goodData = nil
                local ctrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
                ctrl:GetShopData(shopId, function(shopData)
    -- function num : 0_9_1 , upvalues : goodData, shelfId, _ENV, quickBuyData, self
    goodData = (shopData.shopGoodsDic)[shelfId]
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
      -- function num : 0_9_1_0 , upvalues : _ENV, goodData, quickBuyData, self
      if win == nil then
        error("can\'t open QuickBuy win")
        return 
      end
      win:SlideIn(nil, true)
      win:InitBuyTarget(goodData, nil, true, quickBuyData.resourceIds, function()
        -- function num : 0_9_1_0_0 , upvalues : self
        if self.closeCommonRewardCallback ~= nil then
          (self.closeCommonRewardCallback)()
          self.closeCommonRewardCallback = nil
        end
      end
)
      win:OnClickAdd(true)
    end
)
  end
)
              end
              do
                LocalFunc_Buy()
              end
            end
          end
        end
      end
    end
  end
end

UINWhiteDayAlbHeroList.OnClickIntro = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_10_0 , upvalues : self
    if window == nil then
      return 
    end
    local wdCfg = (self._data):GetWDCfg()
    window:InitCommonInfoByRule(wdCfg.skin_rule, true)
  end
)
end

UINWhiteDayAlbHeroList.OnHide = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnHide)(self)
  if self._callback ~= nil then
    (self._callback)()
  end
end

UINWhiteDayAlbHeroList.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self._resloader then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
end

return UINWhiteDayAlbHeroList

