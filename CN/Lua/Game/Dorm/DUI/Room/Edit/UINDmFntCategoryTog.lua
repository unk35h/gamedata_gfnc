-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmFntCategoryTog = class("UINDmFntCategoryTog", UIBaseNode)
local base = UIBaseNode
local DormEnum = require("Game.Dorm.DormEnum")
UINDmFntCategoryTog.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).rootTog, self, self._OnClickTogRoot)
end

UINDmFntCategoryTog.InitDmFntCategoryTog = function(self, fntCatgCfg, sprite, selectFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.fntCatgCfg = fntCatgCfg
  self.selectFunc = selectFunc
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = sprite
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_typeName).text = (LanguageUtil.GetLocaleText)(fntCatgCfg.name)
end

UINDmFntCategoryTog.SetDmFntCategoryTogOn = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).rootTog).isOn = true
end

UINDmFntCategoryTog._OnClickTogRoot = function(self, isOn)
  -- function num : 0_3 , upvalues : _ENV, DormEnum
  if not isOn or not Color.black then
    local col = Color.gray
  end
  if isOn then
    (((self.ui).img_SelFurnType).transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).img_SelFurnType).transform).anchoredPosition = Vector2.zero
    ;
    (((self.ui).img_SelFurnType).transform):SetAsFirstSibling()
    local isTheme = (self.fntCatgCfg).id == DormEnum.ThemeCatId
    ;
    ((self.ui).img_SelFurnType):SetIndex(isTheme and 1 or 0)
    if isTheme then
      col = Color.white
    end
  end
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_typeName).color = col
  -- DECOMPILER ERROR at PC53: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).color = col
  if self.selectFunc ~= nil then
    (self.selectFunc)((self.fntCatgCfg).id)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINDmFntCategoryTog.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmFntCategoryTog

