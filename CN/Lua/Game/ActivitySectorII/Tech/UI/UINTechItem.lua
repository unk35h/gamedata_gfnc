-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTechItem = class("UINTechItem", UIBaseNode)
local base = UIBaseNode
UINTechItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_techItem, self, self.OnClickTechItem)
end

UINTechItem.InitWATechItem = function(self, techData, resloader, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.techData = techData
  self.resloader = resloader
  self.clickCallback = clickCallback
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, techData
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, techData:GetWATechIcon())
  end
)
  self:RefreshTechItem()
end

UINTechItem.RefreshTechItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local curLevel = (self.techData):GetCurLevel()
  local maxLevel = (self.techData):GetMaxLevel()
  local isMaxLevel = curLevel == maxLevel
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(curLevel), tostring(maxLevel))
  ;
  ((self.ui).obj_IsLock):SetActive(not (self.techData):GetIsUnlock())
  if isMaxLevel then
    ((self.ui).img_bottom):SetIndex(1)
  else
    ((self.ui).img_bottom):SetIndex(0)
  end
  local couldLevelUp = (self.techData):IsCouldLevelUp()
  ;
  ((self.ui).obj_TypeLevelUp):SetActive(couldLevelUp)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINTechItem.OnClickTechItem = function(self)
  -- function num : 0_3
  if self.clickCallback ~= nil then
    (self.clickCallback)(self)
  end
end

UINTechItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINTechItem

