-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharDungeonShopPage = class("UINCharDungeonShopPage", UIBaseNode)
local base = UIBaseNode
UINCharDungeonShopPage.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_pageItem, self, self.OnPageValueChanged)
end

UINCharDungeonShopPage.InitCharDungeonShopPage = function(self, shopId, unlock, valueEvent)
  -- function num : 0_1
  self.__shopId = shopId
  self.__unlock = unlock or false
  self.__valueEvent = valueEvent
  self:RefreshShopPageInfo()
end

UINCharDungeonShopPage.RefreshCharDungeonUnlock = function(self, unlock)
  -- function num : 0_2
  self.__unlock = unlock or false
  self:RefreshShopPageInfo()
end

UINCharDungeonShopPage.SetDungeonShopPageIsOn = function(self, isOn)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tog_pageItem).isOn = isOn
end

UINCharDungeonShopPage.SetCharDungeonShopPageReddot = function(self, active)
  -- function num : 0_4
  ((self.ui).blueDot_Page):SetActive(active)
end

UINCharDungeonShopPage.RefreshShopPageInfo = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local shopCfg = (ConfigData.shop)[self.__shopId]
  if shopCfg == nil then
    error("shop cfg is null,id:" .. tostring(self.__shopId))
    return 
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_PageName).text = (LanguageUtil.GetLocaleText)(shopCfg.name)
  ;
  ((self.ui).img_IsLock):SetActive(not self.__unlock)
  self.__isRecommend = shopCfg.is_recommended
  self:SetShopRecommend(self.__isRecommend)
end

UINCharDungeonShopPage.GetCharDungeonShopId = function(self)
  -- function num : 0_6
  return self.__shopId
end

UINCharDungeonShopPage.GetCharDungeonUnlock = function(self)
  -- function num : 0_7
  return self.__unlock
end

UINCharDungeonShopPage.IsItemRecommendShop = function(self)
  -- function num : 0_8
  return self.__isRecommend
end

UINCharDungeonShopPage.OnPageValueChanged = function(self, value)
  -- function num : 0_9 , upvalues : _ENV
  ((self.ui).obj_PageSelect):SetActive(value)
  if self.__valueEvent ~= nil then
    (self.__valueEvent)(self, value)
  end
  if not self.__unlock then
    return 
  end
  if not value or not Color.white then
    local col = (self.ui).col_Unsel
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_PageName).color = col
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).color = col
end

UINCharDungeonShopPage.SetShopRecommend = function(self, active)
  -- function num : 0_10
  if (self.ui).obj_RecommendIcon == nil then
    return 
  end
  ;
  ((self.ui).obj_RecommendIcon):SetActive(active)
end

UINCharDungeonShopPage.SetSelectColor = function(self, color)
  -- function num : 0_11
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_PageSelect).color = color
end

UINCharDungeonShopPage.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
end

return UINCharDungeonShopPage

