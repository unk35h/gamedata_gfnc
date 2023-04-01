-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAWDunLevelItem = class("UINAWDunLevelItem", UIBaseNode)
local base = UIBaseNode
UINAWDunLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).rootBtn, self, self.__OnClickLevelItem)
  self:SetTexTileBestFit(false)
end

UINAWDunLevelItem.RefreshWADunLevelItem = function(self, SIIDunData, onClickWADunItem)
  -- function num : 0_1 , upvalues : _ENV
  self.SIIDunData = SIIDunData
  self.onClickWADunItem = onClickWADunItem
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.gameObject).name = tostring(SIIDunData:GetDungeonLevelStageId())
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = SIIDunData:GetAWDungeonPos()
  self:RefreshUI()
end

UINAWDunLevelItem.RefreshUI = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Tile).text = (self.SIIDunData):GetDungeonLevelName()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_SubTile).text = (self.SIIDunData):GetDungeonLevelOrderName()
  local isUnlock = (self.SIIDunData):GetIsLevelUnlock()
  self:_ShowUILock(not isUnlock)
  self:_ShowUITitle(isUnlock)
  self:_ShowUIComplete((self.SIIDunData):GetIsLevelComplete())
  self:__RefreshBlueDot()
end

UINAWDunLevelItem._ShowUILock = function(self, enabled)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_Lock).enabled = enabled
end

UINAWDunLevelItem._ShowUIComplete = function(self, enabled)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_Complete).enabled = enabled
end

UINAWDunLevelItem._ShowUITitle = function(self, isUnlock)
  -- function num : 0_5
  (((self.ui).rect_title).gameObject):SetActive(isUnlock)
end

UINAWDunLevelItem.__RefreshBlueDot = function(self)
  -- function num : 0_6
  if (self.SIIDunData):GetIsLevelUnlock() and not (self.SIIDunData):GetIsLevelComplete() then
    ((self.ui).blueDot):SetActive(true)
    return 
  end
  ;
  ((self.ui).blueDot):SetActive(false)
end

UINAWDunLevelItem.GetStageHolderRect = function(self)
  -- function num : 0_7
  return (self.ui).stageHolder
end

UINAWDunLevelItem.__OnClickLevelItem = function(self)
  -- function num : 0_8
  if self.onClickWADunItem ~= nil then
    (self.onClickWADunItem)(self)
  end
end

UINAWDunLevelItem.GetPointUI = function(self)
  -- function num : 0_9
  return (self.ui).rect_point
end

UINAWDunLevelItem.GetTitleUI = function(self)
  -- function num : 0_10
  return (self.ui).rect_title
end

UINAWDunLevelItem.SetTexTileBestFit = function(self, isOn)
  -- function num : 0_11
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Tile).resizeTextForBestFit = isOn
end

UINAWDunLevelItem.GetAWDunLevelAnchoredPos = function(self)
  -- function num : 0_12
  return (self.transform).anchoredPosition
end

UINAWDunLevelItem.OnDelete = function(self)
  -- function num : 0_13
end

return UINAWDunLevelItem

