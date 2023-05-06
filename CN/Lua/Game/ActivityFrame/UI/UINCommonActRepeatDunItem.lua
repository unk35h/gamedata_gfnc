-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonActRepeatDunItem = class("UINCommonActRepeatDunItem", UIBaseNode)
local base = UIBaseNode
UINCommonActRepeatDunItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickDunItem)
end

UINCommonActRepeatDunItem.InitActRepeatDunItem = function(self, dungeonlLevel, index, callback, resLoader)
  -- function num : 0_1 , upvalues : _ENV
  self._dungeonlLevel = dungeonlLevel
  self._callback = callback
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ChapterNum).text = tostring(index)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_CNName).text = (self._dungeonlLevel):GetDungeonLevelName()
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)((self._dungeonlLevel):GetSpecialUnlockInfo())
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).text = (self._dungeonlLevel):GetDungeonNameEn()
  resLoader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorLevelIcon"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if spriteAtlas ~= nil and not IsNull(self.transform) then
      local spriteIcon = (AtlasUtil.GetResldSprite)(spriteAtlas, (self._dungeonlLevel):GetDungeonIcon())
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).icon).sprite = spriteIcon
    end
  end
)
  self:RefreshActRepeatDunItem()
end

UINCommonActRepeatDunItem.RefreshActRepeatDunItem = function(self)
  -- function num : 0_2
  ((self.ui).obj_Lock):SetActive(not (self._dungeonlLevel):GetIsLevelUnlock())
end

UINCommonActRepeatDunItem.OnClickDunItem = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._dungeonlLevel, self)
  end
end

return UINCommonActRepeatDunItem

