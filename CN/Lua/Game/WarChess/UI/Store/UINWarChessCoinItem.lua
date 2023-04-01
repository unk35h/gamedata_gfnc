-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessCoinItem = class("UINWarChessCoinItem", UIBaseNode)
local base = UIBaseNode
UINWarChessCoinItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINWarChessCoinItem.InitWarchessStoreCoinItem = function(self, itemCfg, MoneyIconId, buyPrice, GetCount, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.clickFunc = clickFunc
  self.itemCfg = itemCfg
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemConfig(itemCfg)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Count).text = GetCount
  self.MoneyIconId = MoneyIconId
  self.buyPrice = (math.ceil)(buyPrice)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Money).text = tostring(self.buyPrice)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Money).sprite = CRH:GetSprite(MoneyIconId)
end

UINWarChessCoinItem.SetStoreCoinItemSelect = function(self, selected)
  -- function num : 0_2 , upvalues : _ENV
  if selected then
    (((self.ui).img_OnSelect).transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_OnSelect).transform).anchoredPosition = Vector2.zero
  end
end

UINWarChessCoinItem.UpdateSellOutActive = function(self, bSellOut)
  -- function num : 0_3
  ((self.ui).img_SellOut):SetActive(bSellOut)
end

UINWarChessCoinItem._OnClickRoot = function(self)
  -- function num : 0_4
  if self.clickFunc ~= nil then
    (self.clickFunc)(self)
  end
end

UINWarChessCoinItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessCoinItem

