-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINRfctSuccessResultItem = class("UINRfctSuccessResultItem", base)
local UINAthDetailAttr = require("Game.Arithmetic.AthDetail.UINAthDetailAttr")
local ArthmeticEnum = require("Game.Arithmetic.ArthmeticEnum")
UINRfctSuccessResultItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthDetailAttr
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_root, self, self._OnClickTog)
  self._attrItemPool = (UIItemPool.New)(UINAthDetailAttr, (self.ui).attriItem, false)
end

UINRfctSuccessResultItem.InitRfctSuccessResultItem = function(self, idx, affixList, selectFunc, isSelected)
  -- function num : 0_1 , upvalues : _ENV, ArthmeticEnum
  self._idx = idx
  self._selectFunc = selectFunc
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  if isSelected then
    ((self.ui).tog_root).isOn = true
  end
  ;
  (self._attrItemPool):HideAll()
  for k,affix in ipairs(affixList) do
    local cfg = (ConfigData.ath_affix_pool)[affix.id]
    if cfg == nil then
      error("Can\'t find ath_affix_pool, id = " .. tostring(affix.id))
    else
      local color = (ArthmeticEnum.AthQualityColor)[affix.quality]
      local attrItem = (self._attrItemPool):GetOne()
      attrItem:InitAthDetailAttr(cfg.affix_para, affix.value, color)
      attrItem:SetAthDetailAttrBtnActive(false)
    end
  end
end

UINRfctSuccessResultItem._OnClickTog = function(self, isOn)
  -- function num : 0_2 , upvalues : _ENV
  if not isOn then
    return 
  end
  ;
  ((self.ui).obj_Selected):SetParent(self.transform)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).obj_Selected).anchoredPosition = Vector2.zero
  if self._selectFunc ~= nil then
    (self._selectFunc)(self._idx)
  end
end

UINRfctSuccessResultItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (self._attrItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINRfctSuccessResultItem

