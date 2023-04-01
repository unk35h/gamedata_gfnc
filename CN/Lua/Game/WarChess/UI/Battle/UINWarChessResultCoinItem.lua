-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessResultCoinItem = class("UINWarChessResultCoinItem", base)
UINWarChessResultCoinItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessResultCoinItem.InitResultCoinItem = function(self, itemCfg, itemCount)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_Title):SetIndex(0, (LanguageUtil.GetLocaleText)(itemCfg.name))
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Coin).sprite = CRH:GetSprite(itemCfg.icon)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CoinCount).text = tostring(itemCount)
end

UINWarChessResultCoinItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessResultCoinItem

