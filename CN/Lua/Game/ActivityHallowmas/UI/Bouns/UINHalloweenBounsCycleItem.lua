-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenBounsCycleItem = class("UINHalloweenBounsCycleItem", UIBaseNode)
local base = UIBaseNode
UINHalloweenBounsCycleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).image, self, self.OnClickConfirm)
end

UINHalloweenBounsCycleItem.InitBounsCycleItem = function(self, hallowmasData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = hallowmasData
  self._callback = callback
  self._cycleExpLimit = (self._data):GetHallowmasCycleExpLimit()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(((self._data):GetHallowmasMainCfg()).cir_des)
  self:RefreshBounsCycleItem()
end

UINHalloweenBounsCycleItem.RefreshBounsCycleItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local curLevel = (self._data):GetHallowmasLv()
  local maxLevel = (self._data):GetHallowmasLvLimit()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  if curLevel < maxLevel then
    ((self.ui).canvasGroup).alpha = 0.9
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).text = "0"
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ExpProgress).fillAmount = 0
    ;
    ((self.ui).tex_ExpProgress):SetIndex(0, "0", tostring(self._cycleExpLimit))
    return 
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 1
  local exp = (self._data):GetHallowmasCurExp()
  local count = exp // self._cycleExpLimit
  local curExp = exp % self._cycleExpLimit
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(count)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_ExpProgress).fillAmount = curExp / self._cycleExpLimit
  ;
  ((self.ui).tex_ExpProgress):SetIndex(0, tostring(curExp), tostring(self._cycleExpLimit))
end

UINHalloweenBounsCycleItem.OnClickConfirm = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UINHalloweenBounsCycleItem

