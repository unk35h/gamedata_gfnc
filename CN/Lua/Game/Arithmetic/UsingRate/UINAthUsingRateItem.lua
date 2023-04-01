-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINAthUsingRateItem = class("UINAthUsingRateItem", base)
UINAthUsingRateItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINAthUsingRateItem.InitAthUsingRateItem = function(self, statEelem)
  -- function num : 0_1 , upvalues : _ENV
  local cfg = (ConfigData.attribute)[statEelem.id]
  if cfg == nil then
    error("Can\'t find attribute, id = " .. tostring(statEelem.id))
    return 
  end
  local name = (LanguageUtil.GetLocaleText)(cfg.name)
  if cfg.num_type ~= 1 then
    name = name .. "%"
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).Tex_Name).text = name
  ;
  ((self.ui).Tex_Rate):SetIndex(0, GetPreciseDecimalStr(statEelem.ratio // 100, 2))
end

UINAthUsingRateItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINAthUsingRateItem

