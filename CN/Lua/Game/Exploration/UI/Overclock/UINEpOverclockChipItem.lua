-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Exploration.UI.Base.UINBaseEpChipItem")
local UINEpOverclockChipItem = class("UINEpOverclockChipItem", base)
UINEpOverclockChipItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_chipItem, self, self.OnChipItemClick)
end

UINEpOverclockChipItem.InitOverclockChipItem = function(self, index, chipData, clickCallback)
  -- function num : 0_1 , upvalues : base
  self.index = index
  self.chipData = chipData
  ;
  (base.InitBaseEpChipUI)(self, chipData, true)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (self.chipData):GetName()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_QuailtyColor).color = (self.chipData):GetColor()
  self.clickCallback = clickCallback
  self:SetUnlockUI(true)
  self:SetSelectUI(false)
  self:Show()
end

UINEpOverclockChipItem.OnChipItemClick = function(self)
  -- function num : 0_2
  if not self.unlock then
    return 
  end
  if self.clickCallback ~= nil then
    (self.clickCallback)(self)
  end
end

UINEpOverclockChipItem.SetSelectUI = function(self, isSelect)
  -- function num : 0_3
  self.isSelect = isSelect
  ;
  ((self.ui).obj_OnSelect):SetActive(isSelect)
end

UINEpOverclockChipItem.SetUnlockUI = function(self, isUnlock)
  -- function num : 0_4
  self.unlock = isUnlock
  ;
  ((self.ui).obj_Lock):SetActive(not isUnlock)
end

UINEpOverclockChipItem.SetHasUI = function(self, isHas)
  -- function num : 0_5
  ((self.ui).obj_Has):SetActive(isHas)
end

UINEpOverclockChipItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINEpOverclockChipItem

