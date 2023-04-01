-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22TechItem = class("UINCarnival22TechItem", UIBaseNode)
local base = UIBaseNode
UINCarnival22TechItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).techItem, self, self.OnClickTechItem)
end

UINCarnival22TechItem.InitCarnivalTechItem = function(self, techData, lockObjCallback, resloader, clickFunc, branchIndex)
  -- function num : 0_1 , upvalues : _ENV
  self._techData = techData
  self._clickFunc = clickFunc
  self._branchIndex = branchIndex
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self._techData):GetWATechIcon())
  end
)
  if lockObjCallback ~= nil and not (self._techData):GetIsUnlock() then
    self._lockedItem = lockObjCallback()
    ;
    ((self._lockedItem).gameObject):SetActive(true)
    ;
    ((self._lockedItem).transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self._lockedItem).transform).anchoredPosition = Vector2.zero
  end
  self:RefreshCarnivalTechItem()
end

UINCarnival22TechItem.RefreshCarnivalTechItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local unlock = (self._techData):GetIsUnlock()
  if not unlock then
    ((self.ui).norGroup):SetIndex(3)
    ;
    ((self.ui).level):SetActive(false)
    ;
    ((self.ui).obj_CanLevelUp):SetActive(false)
    if self._lockedItem ~= nil then
      (self._lockedItem):Show()
    end
    return 
  end
  if self._lockedItem ~= nil then
    (self._lockedItem):Hide()
  end
  ;
  ((self.ui).norGroup):SetIndex(self._branchIndex - 1)
  ;
  ((self.ui).level):SetActive(true)
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring((self._techData):GetCurLevel()), tostring((self._techData):GetMaxLevel()))
  ;
  ((self.ui).obj_CanLevelUp):SetActive((self._techData):IsCouldLevelUp())
end

UINCarnival22TechItem.SetCarnivalTechLockedAlpha = function(self, value)
  -- function num : 0_3
  if self._lockedItem ~= nil and (self._lockedItem).active then
    (self._lockedItem):SetTechItemLockedAlpha(value)
  end
end

UINCarnival22TechItem.OnClickTechItem = function(self)
  -- function num : 0_4
  if self._clickFunc ~= nil then
    (self._clickFunc)(self)
  end
end

UINCarnival22TechItem.GetCarnivalTechData = function(self)
  -- function num : 0_5
  return self._techData
end

return UINCarnival22TechItem

