-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22ShopPage = class("UINActSum22ShopPage", UIBaseNode)
local base = UIBaseNode
UINActSum22ShopPage.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).pageItem, self, self.OnClickPage)
end

UINActSum22ShopPage.InitSum22ShopPage = function(self, shopId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._shopId = shopId
  self._callback = callback
  local shopCfg = (ConfigData.shop)[shopId]
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_PageName).text = (LanguageUtil.GetLocaleText)(shopCfg.name)
end

UINActSum22ShopPage.RefreshSum22ShopPageState = function(self, shopId)
  -- function num : 0_2
  local flag = self._shopId == shopId
  ;
  ((self.ui).selected):SetActive(flag)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  if flag then
    ((self.ui).tex_PageName).color = (self.ui).color_tex_selected
  else
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

    ((self.ui).tex_PageName).color = (self.ui).color_tex_unselect
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINActSum22ShopPage.OnClickPage = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._shopId, self)
  end
end

return UINActSum22ShopPage

