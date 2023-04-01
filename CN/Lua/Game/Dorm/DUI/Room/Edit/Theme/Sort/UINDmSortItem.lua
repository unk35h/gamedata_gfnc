-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINDmSortItem = class("UINDmSortItem", base)
UINDmSortItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).rootBtn, self, self._OnClickRoot)
end

UINDmSortItem.InitDmSortItem = function(self, sortTypeId, sortData, clickFunc)
  -- function num : 0_1
  self._clickFunc = clickFunc
  self._sortTypeId = sortTypeId
  self._sortData = sortData
  ;
  ((self.ui).tex_SortName):SetIndex(sortTypeId - 1)
  self:UpdDmSortItem()
end

UINDmSortItem.UpdDmSortItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isCur = (self._sortData):IsDmThemeCurSortType(self._sortTypeId)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  if not isCur or not ((self.ui).textColor)[1] then
    (((self.ui).tex_SortName).text).color = ((self.ui).textColor)[2]
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    if not isCur or not ((self.ui).bgColor)[1] then
      ((self.ui).img_bg).color = ((self.ui).bgColor)[2]
      local isReverse = (self._sortData):GetDmThemeCurSortTypeReverse(self._sortTypeId)
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

      if not isReverse or not Color.white then
        ((self.ui).img_Ascend).color = Color.gray
        -- DECOMPILER ERROR at PC56: Confused about usage of register: R3 in 'UnsetPending'

        if not isReverse or not Color.gray then
          ((self.ui).img_Descend).color = Color.white
        end
      end
    end
  end
end

UINDmSortItem._OnClickRoot = function(self)
  -- function num : 0_3
  if self._clickFunc then
    (self._clickFunc)(self, self._sortTypeId)
  end
end

UINDmSortItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmSortItem

