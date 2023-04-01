-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAvgNounTypeTog = class("UINAvgNounTypeTog", UIBaseNode)
local base = UIBaseNode
UINAvgNounTypeTog.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_NounType, self, self.OnClickAvgNounTypeTog)
  self:__SetNounTypeSelected(false)
end

UINAvgNounTypeTog.InitAvgNounTypeTog = function(self, cfg, clickCallback, typeId, desId)
  -- function num : 0_1 , upvalues : _ENV
  self.noun_des_typeCfg = cfg
  self.clickCallback = clickCallback
  self.typeId = typeId
  self.desId = desId
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_TypeName).text = (LanguageUtil.GetLocaleText)(cfg.type_name)
end

UINAvgNounTypeTog.SetAvgNonTypeTogIsOn = function(self, isOn)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tog_NounType).isOn = isOn
end

UINAvgNounTypeTog.OnClickAvgNounTypeTog = function(self, bool)
  -- function num : 0_3
  self:__SetNounTypeSelected(bool)
  if self.clickCallback ~= nil then
    (self.clickCallback)(self, bool, self.typeId, self.desId)
  end
end

UINAvgNounTypeTog.__SetNounTypeSelected = function(self, bool)
  -- function num : 0_4 , upvalues : _ENV
  if bool then
    local cor = (Color.New)(1, 1, 1, 1)
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_tog).color = cor
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_TypeName).color = Color.black
  else
    do
      local cor = (Color.New)(1, 1, 1, 0)
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).img_tog).color = cor
      -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_TypeName).color = Color.white
    end
  end
end

UINAvgNounTypeTog.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINAvgNounTypeTog

