-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCSSelectNubIconItem = class("UINWCSSelectNubIconItem", base)
local eWarChessUIEnum = require("Game.WarChess.UI.eWarChessUIEnum")
UINWCSSelectNubIconItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.uiDownTextColor = {}
  ;
  (UIUtil.LuaUIBindingTable)(((self.ui).img_Num).transform, self.uiDownTextColor)
  self._lastBarItemType = nil
end

UINWCSSelectNubIconItem.InitWCSNubState = function(self, barItemType, nub, hasFlg)
  -- function num : 0_1 , upvalues : eWarChessUIEnum, _ENV
  ((self.ui).obj_Next):SetActive(false)
  if self._lastBarItemType == barItemType then
    return 
  end
  self._lastBarItemType = barItemType
  if barItemType == (eWarChessUIEnum.WCSBarItemType).Lobby then
    ((self.ui).img_BgSmall):SetIndex(1)
    ;
    ((self.ui).img_BgItemInfo):SetIndex(1)
    ;
    (((self.ui).icon_Boss).gameObject):SetActive(false)
    ;
    (((self.ui).img_Num).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.ui).img_BgSmall).transform).localScale = (Vector3.Temp)(1, 1, 1)
  else
    if barItemType == (eWarChessUIEnum.WCSBarItemType).Boss then
      ((self.ui).img_BgSmall):SetIndex(0)
      ;
      ((self.ui).img_BgItemInfo):SetIndex(0)
      ;
      (((self.ui).icon_Boss).gameObject):SetActive(true)
      ;
      (((self.ui).img_Num).gameObject):SetActive(false)
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (((self.ui).img_BgSmall).transform).localScale = (Vector3.Temp)(1.43, 1.43, 1)
    else
      ;
      ((self.ui).img_BgSmall):SetIndex(0)
      ;
      ((self.ui).img_BgItemInfo):SetIndex(0)
      ;
      (((self.ui).icon_Boss).gameObject):SetActive(false)
      ;
      (((self.ui).img_Num).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC115: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (((self.ui).img_BgSmall).transform).localScale = (Vector3.Temp)(1, 1, 1)
      -- DECOMPILER ERROR at PC120: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).img_Num).color = (self.ui).color_WhiteBackground
      -- DECOMPILER ERROR at PC126: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).img_Num).text = tostring(nub)
    end
  end
  if hasFlg then
    ((self.ui).obj_Flag):SetActive(true)
  else
    ;
    ((self.ui).obj_Flag):SetActive(false)
  end
end

UINWCSSelectNubIconItem.WCSNubIconGrey = function(self)
  -- function num : 0_2
  (((self.ui).img_BgItemInfo).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Num).color = (self.ui).color_GreyBackground
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).icon_Boss).color = (self.ui).color_GreyBackground
end

UINWCSSelectNubIconItem.WCSNubIconLight = function(self)
  -- function num : 0_3
  (((self.ui).img_BgItemInfo).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Num).color = (self.ui).color_WhiteBackground
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).icon_Boss).color = (self.ui).color_WhiteBackground
end

UINWCSSelectNubIconItem.WCSPlayNextTips = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_Next):SetActive(true)
  ;
  (((((self.ui).obj_Next).transform):DOPunchPosition((Vector3.New)(0, 10, 0), 1, 1)):SetLoops(-1)):SetLink((self.ui).obj_Next)
end

UINWCSSelectNubIconItem.WCSAppendIconComplete = function(self, seq)
  -- function num : 0_5 , upvalues : _ENV
  (((self.ui).img_BgItemInfo).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).img_BgItemInfo).image).color = (Color.New)(1, 1, 1, 0)
  seq:Append(((((self.ui).img_BgItemInfo).image):DOFade(1, 0.6)):SetLink(self.gameObject))
  seq:Join((((self.ui).img_Num):DOColor((self.ui).color_WhiteBackground, 0.6)):SetLink(self.gameObject))
end

UINWCSSelectNubIconItem.WCSGetBarItemType = function(self)
  -- function num : 0_6
  return self._lastBarItemType
end

UINWCSSelectNubIconItem.AddWCSBarItemCompleteOutlineExpand = function(self, seq)
  -- function num : 0_7 , upvalues : _ENV
  (((seq:AppendCallback(function()
    -- function num : 0_7_0 , upvalues : self
    (((self.ui).img_BgCompleteOutline).gameObject):SetActive(true)
  end
)):Append((((self.ui).img_BgCompleteOutline):DOFade(0, 0.2)):From())):Join((((self.ui).img_BgCompleteOutline).transform):DOScale((Vector3.New)(2, 2, 2), 0.16))):Join((((self.ui).img_BgCompleteOutline):DOFade(0, 0.2)):SetDelay(0.1))
end

UINWCSSelectNubIconItem.AddWCSBarItemExpand = function(self, seq, delay)
  -- function num : 0_8 , upvalues : _ENV
  self:Show()
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).cg_item).alpha = 0
  seq:Insert(delay, ((self.ui).cg_item):DOFade(1, 0.2))
  seq:Insert(delay, ((self.transform):DOScale(Vector3.zero, 0.3)):From())
end

UINWCSSelectNubIconItem.WCSAppendIconFlag = function(self, seq)
  -- function num : 0_9 , upvalues : _ENV
  seq:AppendCallback(function()
    -- function num : 0_9_0 , upvalues : self
    ((self.ui).obj_Flag):SetActive(true)
  end
)
  seq:Append(((((self.ui).obj_Flag).transform):DOLocalMove((Vector3.New)(0, 10, 0), 0.2)):From())
end

return UINWCSSelectNubIconItem

