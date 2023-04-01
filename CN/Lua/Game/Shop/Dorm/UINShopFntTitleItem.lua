-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopFntTitleItem = class("UINShopFntTitleItem", UIBaseNode)
local base = UIBaseNode
local UINFntThemeTag = require("Game.Shop.Dorm.UINFntThemeTag")
local resloader = CS.ResLoader
UINShopFntTitleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINFntThemeTag, resloader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_buy, self, self.OnClickBuy)
  self.tagPool = (UIItemPool.New)(UINFntThemeTag, (self.ui).obj_tagItem, false)
  self.resloader = (resloader.Create)()
end

UINShopFntTitleItem.InitFntItem = function(self, goodData, baseObj)
  -- function num : 0_1 , upvalues : _ENV
  self.goodData = goodData
  self.type = goodData.type
  self.shopGoodsDic = goodData.shopGoodsDic
  self.themeItem = (self.shopGoodsDic)[1]
  self.dormTheme = (ConfigData.dorm_theme)[((self.themeItem).shelfCfg).theme_id]
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetShopFurnitureThemePath((self.dormTheme).theme_pic2), function(texture)
    -- function num : 0_1_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

    ((self.ui).img_BK).texture = texture
  end
)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ThemeName).text = (LanguageUtil.GetLocaleText)((self.dormTheme).theme_name)
  local currencyItemCfg = (ConfigData.item)[(self.themeItem).currencyId]
  local smallIcon = currencyItemCfg.small_icon
  ;
  (((self.ui).img_money).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_money).sprite = CRH:GetSprite(smallIcon)
  ;
  (self.tagPool):HideAll()
  ;
  (CommonUIUtil.CreateFntThemeTags)(self.dormTheme, self.tagPool)
  local totalCost = 0
  local requiredCost = 0
  for i,itemData in pairs(self.shopGoodsDic) do
    if itemData.totallimitTime == nil or not itemData.totallimitTime then
      local limitCount = itemData.limitTime
    end
    local tempCost = (limitCount - itemData.purchases) * itemData.newCurrencyNum
    local rTempCost = limitCount * itemData.newCurrencyNum
    totalCost = totalCost + tempCost
    requiredCost = requiredCost + rTempCost
  end
  self.totalCost = totalCost
  if totalCost == 0 then
    ((self.ui).obj_cost):SetActive(false)
    -- DECOMPILER ERROR at PC92: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).btn_buy).interactable = false
    ;
    (((self.ui).tex_buy).gameObject):SetActive(false)
    ;
    ((self.ui).obj_soldOut):SetActive(true)
  else
    -- DECOMPILER ERROR at PC110: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_Cost).text = tostring(totalCost)
    -- DECOMPILER ERROR at PC113: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).btn_buy).interactable = true
    ;
    ((self.ui).obj_cost):SetActive(true)
    ;
    (((self.ui).tex_buy).gameObject):SetActive(true)
    ;
    ((self.ui).obj_soldOut):SetActive(false)
    if totalCost == requiredCost then
      ((self.ui).tex_buy):SetIndex(0)
    else
      ;
      ((self.ui).tex_buy):SetIndex(1)
    end
  end
end

UINShopFntTitleItem.OnClickBuy = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.totalCost == 0 then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(win)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    local resIds = {}
    ;
    (table.insert)(resIds, (self.themeItem).currencyId)
    ;
    (table.insert)(resIds, 1, ConstGlobalItem.PaidSubItem)
    ;
    (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
    win:SlideIn()
    win:InitBuyRoomTheme(self.shopGoodsDic, true, resIds)
  end
)
end

UINShopFntTitleItem.RefreshGoods = function(self)
  -- function num : 0_3
end

UINShopFntTitleItem.RefreshLeftSellTime = function(self)
  -- function num : 0_4
end

UINShopFntTitleItem.OnDelete = function(self)
  -- function num : 0_5
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.tagPool):DeleteAll()
end

return UINShopFntTitleItem

