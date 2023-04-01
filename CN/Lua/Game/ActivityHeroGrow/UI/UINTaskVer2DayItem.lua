-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTaskVer2DayItem = class("UINTaskVer2DayItem", UIBaseNode)
local base = UIBaseNode
UINTaskVer2DayItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickSelect)
end

UINTaskVer2DayItem.InitTaskVer2DayItem = function(self, heroGrowData, day, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._heroGrowData = heroGrowData
  self._day = day
  self._callback = callback
  ;
  ((self.ui).text):SetIndex(0, tostring(self._day))
  ;
  ((self.ui).bottom):SetActive(false)
end

UINTaskVer2DayItem.RefreshTaskVer2DayState = function(self)
  -- function num : 0_2
  local unlock = (self._heroGrowData):IsHeroGrowDailyTaskIsUnlock(self._day)
  if unlock then
    ((self.ui).blueDot):SetActive(not (self._heroGrowData):IsLookedHeroGrowDailyTask(self._day))
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

    if not self.__isSelect and (not unlock or not (self.ui).color_unlock) then
      (((self.ui).text).text).color = (self.ui).color_locked
    end
  end
end

UINTaskVer2DayItem.RefreshTaskVer2DaySelect = function(self, day)
  -- function num : 0_3
  self.__isSelect = day == self._day
  ;
  ((self.ui).bottom):SetActive(self.__isSelect)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  if self.__isSelect then
    (((self.ui).text).text).color = (self.ui).color_selected
  else
    self:RefreshTaskVer2DayState()
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINTaskVer2DayItem.OnClickSelect = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self._day)
  end
end

return UINTaskVer2DayItem

