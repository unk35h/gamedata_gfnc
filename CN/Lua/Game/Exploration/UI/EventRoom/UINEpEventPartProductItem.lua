-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEpEventPartProductItem = class("UINEpEventPartProductItem", UIBaseNode)
local ChipData = require("Game.PlayerData.Item.ChipData")
UINEpEventPartProductItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_product, self, self.__OnEventPartProductClicked)
  self.__notHaveAlpha = ((self.ui).cg_product).alpha
end

UINEpEventPartProductItem.InitEventPartProduct = function(self, index, chipId, hasChip, clickEvent)
  -- function num : 0_1 , upvalues : ChipData, _ENV
  self.__index = index
  self.__clickEvent = clickEvent
  local chipData = (ChipData.NewChipForLocal)(chipId)
  self.__chipData = chipData
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

  if chipData:IsConsumeSkillChip() then
    ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(chipData:GetIcon(), CommonAtlasType.SkillIcon)
  else
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_SkillIcon).sprite = CRH:GetSprite(chipData:GetIcon())
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = chipData:GetName()
  ;
  ((self.ui).img_ItemIcon):SetIndex(self.__index - 1)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R6 in 'UnsetPending'

  if hasChip then
    ((self.ui).cg_product).alpha = 1
    ;
    ((self.ui).img_Buttom):SetIndex(1)
  else
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).cg_product).alpha = self.__notHaveAlpha
    ;
    ((self.ui).img_Buttom):SetIndex(0)
  end
end

UINEpEventPartProductItem.__OnEventPartProductClicked = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.__clickEvent ~= nil then
    (self.__clickEvent)(self, self.__index)
  end
  AudioManager:PlayAudioById(1157)
end

return UINEpEventPartProductItem

