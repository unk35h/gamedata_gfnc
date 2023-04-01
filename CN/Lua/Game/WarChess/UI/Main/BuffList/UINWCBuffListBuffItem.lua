-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCBuffListBuffItem = class("UINWCBuffListBuffItem", UIBaseNode)
local OnPressScale = (Vector3.New)(1.5, 1.5, 1)
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
UINWCBuffListBuffItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).btn_buffItem).onPress):AddListener(BindCallback(self, self.__OnSkillLongPress))
  ;
  (((self.ui).btn_buffItem).onPressUp):AddListener(BindCallback(self, self.__OnSkillPressUp))
  ;
  ((self.ui).obj_buffNum):SetActive(false)
end

UINWCBuffListBuffItem.RefreshWCBuffItem = function(self, buffData)
  -- function num : 0_1 , upvalues : _ENV
  self.buffData = buffData
  local buffIcon = buffData:GetWCBuffIcon()
  if (string.IsNullOrEmpty)(buffIcon) then
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(buffIcon, CommonAtlasType.ExplorationIcon)
end

UINWCBuffListBuffItem.__OnSkillLongPress = function(self)
  -- function num : 0_2 , upvalues : _ENV, HAType, VAType, OnPressScale
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  win:SetTitleAndContext((self.buffData):GetWCBuffName(), (self.buffData):GetWCBuffDes())
  win:FloatTo(self.transform, HAType.autoCenter, VAType.down)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).localScale = OnPressScale
end

UINWCBuffListBuffItem.__OnSkillPressUp = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).localScale = Vector3.one
end

UINWCBuffListBuffItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWCBuffListBuffItem

