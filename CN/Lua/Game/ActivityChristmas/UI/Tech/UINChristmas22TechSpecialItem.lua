-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechSpecialItem = class("UINChristmas22TechSpecialItem", UIBaseNode)
local base = UIBaseNode
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
UINChristmas22TechSpecialItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Active, self, self.OnClickUnlock)
end

UINChristmas22TechSpecialItem.SetChristmas22LogicDesType = function(self, desType)
  -- function num : 0_1
  self._desType = desType
end

UINChristmas22TechSpecialItem.InitChristmas22TechSpecialItem = function(self, techData, resloader, callback)
  -- function num : 0_2 , upvalues : _ENV
  self._techData = techData
  self._callback = callback
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_2_0 , upvalues : self, _ENV
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self._techData):GetWATechIcon())
  end
)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (self._techData):GetTechDescription(nil, self._desType)
  ;
  ((self.ui).tex_Lvl):SetIndex(0, tostring((self._techData):GetActTechPrfeTotleLevel()))
  self:RefreshChristmas22TechSpecialItem()
end

UINChristmas22TechSpecialItem.RefreshChristmas22TechSpecialItem = function(self)
  -- function num : 0_3
  if not (self._techData):GetIsUnlock() then
    ((self.ui).obj_Effect):SetActive(false)
    ;
    ((self.ui).obj_Lock):SetActive(true)
    ;
    (((self.ui).btn_Active).gameObject):SetActive(false)
    return 
  end
  ;
  ((self.ui).obj_Lock):SetActive(false)
  local isInEffect = (self._techData):GetCurLevel() > 0
  ;
  ((self.ui).obj_Effect):SetActive(isInEffect)
  ;
  (((self.ui).btn_Active).gameObject):SetActive(not isInEffect)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINChristmas22TechSpecialItem.OnClickUnlock = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self._techData)
  end
end

return UINChristmas22TechSpecialItem

