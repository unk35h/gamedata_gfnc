-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWinter23TechSpItem = class("UINWinter23TechSpItem", UIBaseNode)
local base = UIBaseNode
UINWinter23TechSpItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Effct, self, self.OnClickLv)
  ;
  (UIUtil.AddButtonListener)((self.ui).techItem, self, self.OnClickDetail)
end

UINWinter23TechSpItem.InitWin23TechSpItem = function(self, techData, resloader, callback, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._techData = techData
  self._callback = callback
  self._clickFunc = clickFunc
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
  self:RefreshWin23TechSpItem()
end

UINWinter23TechSpItem.SetWin23LogicDesType = function(self, desType)
  -- function num : 0_2
  self._desType = desType
end

UINWinter23TechSpItem.RefreshWin23TechSpItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_TechDes).text = (self._techData):GetTechDescription(nil, self._desType)
  ;
  ((self.ui).tex_TechLvl):SetIndex(0, tostring((self._techData):GetActTechPrfeTotleLevel()))
  if not (self._techData):GetIsUnlock() then
    (((self.ui).btn_Effct).gameObject):SetActive(false)
    ;
    ((self.ui).obj_Lock):SetActive(true)
    ;
    ((self.ui).obj_ItemLocked):SetActive(true)
    ;
    (((self.ui).tex_Level).gameObject):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_Lock):SetActive(false)
  ;
  ((self.ui).obj_ItemLocked):SetActive(false)
  local isInEffect = (self._techData):GetCurLevel() > 0
  ;
  (((self.ui).btn_Effct).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R2 in 'UnsetPending'

  if not isInEffect or not (self.ui).color_effect then
    ((self.ui).image_Effct).color = (self.ui).color_unlock
    ;
    ((self.ui).tex_Text):SetIndex(isInEffect and 0 or 1)
    ;
    (((self.ui).tex_Level).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Level):SetIndex(0, tostring((self._techData):GetCurLevel()), tostring((self._techData):GetMaxLevel()))
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINWinter23TechSpItem.OnClickLv = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self._techData)
  end
end

UINWinter23TechSpItem.OnClickDetail = function(self)
  -- function num : 0_5
  if self._clickFunc ~= nil then
    (self._clickFunc)(self, self._techData)
  end
end

return UINWinter23TechSpItem

