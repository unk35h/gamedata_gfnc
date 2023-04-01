-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenBounsItemEmptyElement = class("UINHalloweenBounsItemEmptyElement", UIBaseNode)
local base = UIBaseNode
UINHalloweenBounsItemEmptyElement.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHalloweenBounsItemEmptyElement.BindHalloweenBounsItemClass = function(self, itemClass, cycleClass)
  -- function num : 0_1
  self._itemClass = itemClass
  self._cycleClass = cycleClass
end

UINHalloweenBounsItemEmptyElement.InitBounsItem = function(self, hallowmasData, level, rewardFunc)
  -- function num : 0_2 , upvalues : _ENV
  if self._cycleItem ~= nil then
    (self._cycleItem):Hide()
  end
  if self._item == nil then
    local go = ((self.ui).item):Instantiate(self.transform)
    go:SetActive(true)
    self._item = ((self._itemClass).New)()
    ;
    (self._item):Init(go)
    self:__SetBounsItemExtra()
  else
    do
      ;
      (self._item):Show()
      ;
      (self._item):InitBounsItem(hallowmasData, level, rewardFunc)
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._item).transform).anchoredPosition = Vector2.zero
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self.transform).sizeDelta = (((self._item).transform).rect).size
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).layoutElement).preferredHeight = ((self.transform).sizeDelta).y
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).layoutElement).preferredWidth = ((self.transform).sizeDelta).x
    end
  end
end

UINHalloweenBounsItemEmptyElement.__SetBounsItemExtra = function(self)
  -- function num : 0_3
end

UINHalloweenBounsItemEmptyElement.InitBounsCycleItem = function(self, hallowmasData, rewardFunc)
  -- function num : 0_4 , upvalues : _ENV
  if self._item ~= nil then
    (self._item):Hide()
  end
  if self._cycleItem == nil then
    local go = ((self.ui).finalItem):Instantiate(self.transform)
    go:SetActive(true)
    self._cycleItem = ((self._cycleClass).New)()
    ;
    (self._cycleItem):Init(go)
  else
    do
      ;
      (self._cycleItem):Show()
      ;
      (self._cycleItem):InitBounsCycleItem(hallowmasData, rewardFunc)
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self._cycleItem).transform).anchoredPosition = Vector2.zero
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.transform).sizeDelta = (((self._cycleItem).transform).rect).size
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).layoutElement).preferredHeight = ((self.transform).sizeDelta).y
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).layoutElement).preferredWidth = ((self.transform).sizeDelta).x
    end
  end
end

UINHalloweenBounsItemEmptyElement.RefreshBounsElement = function(self)
  -- function num : 0_5
  if self._item ~= nil and (self._item).active then
    (self._item):RefreshBounsItem()
  else
    if self._cycleItem ~= nil and (self._cycleItem).active then
      (self._cycleItem):RefreshBounsCycleItem()
    end
  end
end

return UINHalloweenBounsItemEmptyElement

