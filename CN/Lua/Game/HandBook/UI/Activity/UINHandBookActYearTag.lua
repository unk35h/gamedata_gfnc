-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookActYearTag = class("UINHandBookActYearTag", UIBaseNode)
local base = UIBaseNode
UINHandBookActYearTag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).yearItem, self, self.OnClickActYearTag)
end

UINHandBookActYearTag.InitHandBookActYearTag = function(self, year, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._year = year
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Year).text = tostring(self._year)
  self._callback = callback
end

UINHandBookActYearTag.RefreshActYearTag = function(self, year)
  -- function num : 0_2
  local flag = self._year == year
  ;
  ((self.ui).img_Selected):SetActive(flag)
  local color = ((self.ui).tex_Year).color
  color.a = flag and 1 or 0.2
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Year).color = color
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINHandBookActYearTag.OnClickActYearTag = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._year)
  end
end

return UINHandBookActYearTag

