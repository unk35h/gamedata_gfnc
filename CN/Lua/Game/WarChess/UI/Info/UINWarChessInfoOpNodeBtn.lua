-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessInfoOpNodeBtn = class("UINWarChessInfoOpNodeBtn", base)
UINWarChessInfoOpNodeBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.__OnClick)
end

UINWarChessInfoOpNodeBtn.SetClickCallback = function(self, clickCallback)
  -- function num : 0_1
  self.clickCallback = clickCallback
end

UINWarChessInfoOpNodeBtn.SetInterActionType = function(self, index, costAP)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  (self.gameObject).name = tostring(index)
  if costAP ~= nil and costAP > 0 then
    ((self.ui).obj_ActionPoint):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Point).text = tostring(-costAP)
  else
    ;
    ((self.ui).obj_ActionPoint):SetActive(false)
  end
  ;
  ((self.ui).img_Info):SetIndex(index)
  ;
  ((self.ui).tex_des):SetIndex(index)
end

UINWarChessInfoOpNodeBtn.__OnClick = function(self)
  -- function num : 0_3
  if self.clickCallback ~= nil then
    (self.clickCallback)()
    self.clickCallback = nil
  end
end

UINWarChessInfoOpNodeBtn.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoOpNodeBtn

