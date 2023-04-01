-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopShelfTog = class("UINShopShelfTog", UIBaseNode)
local base = UIBaseNode
UINShopShelfTog.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_ShelfType, self, self.OnValueChage)
  self.__RedDotEvent = BindCallback(self, self.RefreshShelfTogReddot)
end

UINShopShelfTog.InitOnlyTitleShelfTog = function(self, titleName)
  -- function num : 0_1 , upvalues : _ENV
  self.__isOnlyTitle = true
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(titleName)
  self.refreshGoodsCallback = nil
  ;
  (((self.ui).img_Select).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).color = (self.ui).color_unSelect
  ;
  ((self.ui).obj_RedDot):SetActive(false)
  RedDotController:RemoveListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
end

UINShopShelfTog.InitShelfTog = function(self, shopId, pageId, refreshGoodsCallback, pageCount)
  -- function num : 0_2 , upvalues : _ENV
  self.__isOnlyTitle = false
  self.pageId = pageId
  self.shopId = shopId
  self.pageCount = pageCount
  self.refreshGoodsCallback = refreshGoodsCallback
  local pageCfg = (ConfigData.shop_page)[self.pageId]
  if pageCfg == nil then
    error("can\'t get pageCfg with pageId:" .. tostring(pageId) .. " shopId:" .. tostring(shopId))
    return 
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(pageCfg.page)
  self:RefreshShelfTogReddot()
  RedDotController:RemoveListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
  RedDotController:AddListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
end

UINShopShelfTog.OnValueChage = function(self, bool)
  -- function num : 0_3 , upvalues : _ENV
  if self.__isOnlyTitle then
    return 
  end
  do
    if bool and not self._inSetSelected and (ConfigData.shop_page)[self.pageId] ~= nil then
      local auId = ((ConfigData.shop_page)[self.pageId]).click_audio
      if auId == 0 then
        auId = 1060
      end
      AudioManager:PlayAudioById(auId)
      if self.refreshGoodsCallback ~= nil then
        (self.refreshGoodsCallback)(self.shopId, self.pageId)
      end
    end
    if bool and self.pageCount > 1 then
      (((self.ui).img_Select).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_Name).color = (self.ui).color_selected
    else
      ;
      (((self.ui).img_Select).gameObject):SetActive(false)
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_Name).color = (self.ui).color_unSelect
    end
  end
end

UINShopShelfTog.SetSelected = function(self, bool, autoSelectShelfId)
  -- function num : 0_4
  self._inSetSelected = true
  if ((self.ui).tog_ShelfType).isOn == bool then
    self:OnValueChage(bool)
  else
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tog_ShelfType).isOn = bool
  end
  if bool and self.refreshGoodsCallback ~= nil then
    (self.refreshGoodsCallback)(self.shopId, self.pageId, autoSelectShelfId)
  end
  self._inSetSelected = false
end

UINShopShelfTog.RefreshShelfTogReddot = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ok, shopNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ShopWindow, self.shopId, self.pageId)
  ;
  ((self.ui).obj_RedDot):SetActive(not ok or shopNode:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINShopShelfTog.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  RedDotController:RemoveListener(RedDotDynPath.ShopPath, self.__RedDotEvent)
  ;
  (base.OnDelete)(self)
end

return UINShopShelfTog

