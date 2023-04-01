-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessEventChoiceItem = class("UINWarChessEventChoiceItem", base)
UINWarChessEventChoiceItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_choiceItem, self, self.__OnChoiceItemClick)
end

UINWarChessEventChoiceItem.InitWCEventChoiceItem = function(self, choiceData, onChoiceClick)
  -- function num : 0_1
  self.choiceData = choiceData
  self.onChoiceClick = onChoiceClick
  self:RefreshChoiceUI()
end

UINWarChessEventChoiceItem.RefreshChoiceUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local choiceCfg = (self.choiceData).choiceCfg
  local couldChoice = (self.choiceData).couldChoice
  self:SetItemCanClick(couldChoice)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Describe).text = (LanguageUtil.GetLocaleText)(choiceCfg.choice_describe_txt)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(choiceCfg.icon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  if choiceCfg.choice_color == 0 or not Color.white then
    ((self.ui).tex_Describe).color = Color.black
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R3 in 'UnsetPending'

    if choiceCfg.choice_color == 0 or not (Color.New)(1, 1, 1, 0.3) then
      ((self.ui).img_IconBg).color = (Color.New)(0, 0, 0, 0.7)
      ;
      ((self.ui).img_Buttom):SetIndex(choiceCfg.choice_color ~= 0 and 1 or 0)
    end
  end
end

UINWarChessEventChoiceItem.SetItemCanClick = function(self, isAble)
  -- function num : 0_3 , upvalues : _ENV
  self.isAble = isAble
  if not isAble or not Color.white then
    local color = (self.ui).col_CantSelect
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).img_Buttom).image).color = color
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).color = color
  ;
  ((self.ui).ani_Select):SetActive(isAble)
end

UINWarChessEventChoiceItem.__OnChoiceItemClick = function(self)
  -- function num : 0_4
  if self.isAble and self.onChoiceClick ~= nil then
    (self.onChoiceClick)(self.choiceData)
  end
end

UINWarChessEventChoiceItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessEventChoiceItem

