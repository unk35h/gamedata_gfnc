-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSkadaType = class("UINSkadaType", UIBaseNode)
UINSkadaType.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_DataType, self, self.OnSkadaTogChanged)
end

UINSkadaType.InitSkadaType = function(self, typeId, eventAction)
  -- function num : 0_1
  self.typeId = typeId
  ;
  ((self.ui).tex_TypeName):SetIndex(typeId - 1)
  self.eventAction = eventAction
end

UINSkadaType.OnSkadaTogChanged = function(self, value)
  -- function num : 0_2 , upvalues : _ENV
  if value then
    ((self.ui).img_DataType):SetIndex(1)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_DataType).image).color = Color.white
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_AttriIcon).color = (self.ui).color_normal
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_TypeName).text).color = (self.ui).color_normal
  else
    ;
    ((self.ui).img_DataType):SetIndex(0)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_DataType).image).color = (self.ui).color_normal
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_AttriIcon).color = Color.white
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_TypeName).text).color = Color.white
  end
  if self.eventAction ~= nil then
    (self.eventAction)(value, self)
  end
end

UINSkadaType.SetSkadaTypeOpen = function(self, active)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tog_DataType).isOn = active
end

return UINSkadaType

