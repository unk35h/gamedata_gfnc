-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySummer.Year22.Shop.UINActSum22ShopPage")
local UINWinter23ShopPage = class("UINWinter23ShopPage", base)
UINWinter23ShopPage.RefreshSum22ShopPageState = function(self, shopId)
  -- function num : 0_0 , upvalues : _ENV
  local flag = self._shopId == shopId
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  if flag then
    ((self.ui).tex_PageName).color = Color.white
    ;
    ((self.ui).img_pageItem):SetIndex(1)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).img_pageItem).image).color = (self.ui).color_selected
  else
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

    ((self.ui).tex_PageName).color = (self.ui).color_texUnSelected
    ;
    ((self.ui).img_pageItem):SetIndex(0)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).img_pageItem).image).color = (self.ui).color_unselected
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINWinter23ShopPage.SetWinter23ShopRed = function(self, flag)
  -- function num : 0_1
  ((self.ui).redDot):SetActive(flag)
end

UINWinter23ShopPage.HideWinter23ShopLine = function(self)
  -- function num : 0_2
  ((self.ui).line):SetActive(false)
end

return UINWinter23ShopPage

