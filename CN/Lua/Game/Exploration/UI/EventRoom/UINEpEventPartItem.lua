-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEpEventPartItem = class("UINEpEventPartItem", UIBaseNode)
local ChipData = require("Game.PlayerData.Item.ChipData")
UINEpEventPartItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btnPlus_Root, self, self.__OnEpPartItemClick)
  ;
  (((self.ui).btnPlus_Root).onPress):AddListener(BindCallback(self, self.__OnChipLongPress))
  ;
  (((self.ui).btnPlus_Root).onPressUp):AddListener(BindCallback(self, self.__OnChipPressUp))
end

UINEpEventPartItem.InitEpEventPartItem = function(self, chipId, index, hasChip)
  -- function num : 0_1 , upvalues : ChipData, _ENV
  ((self.ui).obj_empty):SetActive(false)
  ;
  ((self.ui).obj_normal):SetActive(true)
  self.__partIndex = index
  self.__isEmpty = false
  self.__hasChip = hasChip
  local chipData = (ChipData.NewChipForLocal)(chipId)
  self.__chipData = chipData
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  if chipData:IsConsumeSkillChip() then
    ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(chipData:GetIcon(), CommonAtlasType.SkillIcon)
  else
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(chipData:GetIcon())
  end
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = chipData:GetName()
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R5 in 'UnsetPending'

  if self.__hasChip then
    ((self.ui).cg_Root).alpha = 1
  else
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).cg_Root).alpha = 0.5
  end
end

UINEpEventPartItem.BindEventPartBtnEvent = function(self, clickEvent, longPressFunc, pressUpFunc)
  -- function num : 0_2
  self.__clickEvent = clickEvent
  self.__longPressFunc = longPressFunc
  self.__pressUpFunc = pressUpFunc
end

UINEpEventPartItem.InitEpEventEmpty = function(self, index)
  -- function num : 0_3
  self.__partIndex = index
  self.__isEmpty = true
  self.__hasChip = false
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).cg_Root).alpha = 1
  ;
  ((self.ui).obj_empty):SetActive(true)
  ;
  ((self.ui).obj_normal):SetActive(false)
end

UINEpEventPartItem.GetEventPartIndex = function(self)
  -- function num : 0_4
  return self.__partIndex
end

UINEpEventPartItem.GetEventPartChip = function(self)
  -- function num : 0_5
  return self.__chipData
end

UINEpEventPartItem.IsEventPartEmpty = function(self)
  -- function num : 0_6
  return not self.__hasChip
end

UINEpEventPartItem.SetPartItemypeLineColor = function(self, color)
  -- function num : 0_7
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  (((self.ui).img_TypeLine).image).color = color
end

UINEpEventPartItem.SetPartItemLineType = function(self, index)
  -- function num : 0_8
  ((self.ui).img_TypeLine):SetIndex(index)
end

UINEpEventPartItem.__OnEpPartItemClick = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.__isEmpty then
    return 
  end
  if self.__clickEvent ~= nil then
    (self.__clickEvent)(self)
  end
  AudioManager:PlayAudioById(1156)
end

UINEpEventPartItem.__OnChipLongPress = function(self)
  -- function num : 0_10
  if self.__isEmpty then
    return 
  end
  if self.__longPressFunc ~= nil then
    (self.__longPressFunc)(self.__chipData, self)
  end
end

UINEpEventPartItem.__OnChipPressUp = function(self)
  -- function num : 0_11
  if self.__isEmpty then
    return 
  end
  if self.__pressUpFunc ~= nil then
    (self.__pressUpFunc)(self.__chipData, self)
  end
end

return UINEpEventPartItem

