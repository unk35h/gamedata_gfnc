-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechItem = class("UINChristmas22TechItem", UIBaseNode)
local base = UIBaseNode
UINChristmas22TechItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).techItem, self, self.OnClickTech)
end

UINChristmas22TechItem.InitChristmas22TechItem = function(self, techData, resloader, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._techData = techData
  self._clickCallback = clickCallback
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
  self:RefreshChristmas22TechItem()
end

UINChristmas22TechItem.BindChristmas22TechItemLockFunc = function(self, lockObjFunc)
  -- function num : 0_2
  self._lockObjFunc = lockObjFunc
end

UINChristmas22TechItem.RefreshChristmas22TechItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local isUnlock = (self._techData):GetIsUnlock()
  if not isUnlock then
    if self._lockObjFunc ~= nil then
      if self._lockedObj == nil then
        self._lockedObj = (self._lockObjFunc)()
        ;
        ((self._lockedObj).transform):SetParent(self.transform)
        -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self._lockedObj).transform).anchoredPosition = Vector2.zero
      end
      ;
      (self._lockedObj):SetActive(true)
    end
    ;
    (((self.ui).tex_Level).gameObject):SetActive(false)
    ;
    ((self.ui).obj_CanLevelUp):SetActive(false)
    return 
  end
  if self._lockedObj ~= nil then
    (self._lockedObj):SetActive(false)
  end
  ;
  (((self.ui).tex_Level).gameObject):SetActive(true)
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring((self._techData):GetCurLevel()), tostring((self._techData):GetMaxLevel()))
  ;
  ((self.ui).obj_CanLevelUp):SetActive((self._techData):IsCouldLevelUp())
end

UINChristmas22TechItem.OnClickTech = function(self)
  -- function num : 0_4
  if self._clickCallback ~= nil then
    (self._clickCallback)(self, self._techData)
  end
end

UINChristmas22TechItem.GetChristmas22TechData = function(self)
  -- function num : 0_5
  return self._techData
end

return UINChristmas22TechItem

