-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnivalEmptyItem = class("UINCarnivalEmptyItem", UIBaseNode)
local base = UIBaseNode
local UINCarnivalLevelItem = require("Game.ActivityCarnival.UI.CarnivalProgress.UINCarnivalLevelItem")
local UINCarnivalLevelCycleItem = require("Game.ActivityCarnival.UI.CarnivalProgress.UINCarnivalLevelCycleItem")
UINCarnivalEmptyItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCarnivalEmptyItem.InitCarnivalNormalItem = function(self, carnivalData, levelData, isPicked, pickRewardFunc, jumpFunc)
  -- function num : 0_1 , upvalues : UINCarnivalLevelItem, _ENV
  if self._cycleItem ~= nil then
    (self._cycleItem):Hide()
  end
  if self._normalItem == nil then
    self._normalItem = (UINCarnivalLevelItem.New)()
    local gameObj = ((self.ui).item):Instantiate(self.transform)
    gameObj:SetActive(true)
    ;
    (self._normalItem):Init(gameObj)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self._normalItem).transform).anchoredPosition = Vector2.zero
  else
    do
      ;
      (self._normalItem):Show()
      ;
      (self._normalItem):InitCarnivalLevelItem(carnivalData, levelData, isPicked, pickRewardFunc, jumpFunc)
      self:__ResetSizeDetail(self._normalItem)
    end
  end
end

UINCarnivalEmptyItem.InitCarnivalCycleItem = function(self, carnivalData, pickRewardFunc)
  -- function num : 0_2 , upvalues : UINCarnivalLevelCycleItem, _ENV
  if self._normalItem ~= nil then
    (self._normalItem):Hide()
  end
  if self._cycleItem == nil then
    self._cycleItem = (UINCarnivalLevelCycleItem.New)()
    local gameObj = ((self.ui).finalItem):Instantiate(self.transform)
    gameObj:SetActive(true)
    ;
    (self._cycleItem):Init(gameObj)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self._cycleItem).transform).anchoredPosition = Vector2.zero
  else
    do
      ;
      (self._cycleItem):Show()
      ;
      (self._cycleItem):InitCarnivalLevelCycleItem(carnivalData, pickRewardFunc)
      self:__ResetSizeDetail(self._cycleItem)
    end
  end
end

UINCarnivalEmptyItem.__ResetSizeDetail = function(self, node)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  (self.transform).sizeDelta = ((node.transform).rect).size
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).emptyItem).preferredHeight = ((node.transform).sizeDelta).y
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).emptyItem).preferredWidth = ((node.transform).sizeDelta).x
end

UINCarnivalEmptyItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  if self._normalItem ~= nil then
    (self._normalItem):Delete()
  end
  if self._cycleItem ~= nil then
    (self._cycleItem):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINCarnivalEmptyItem

