-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpEventChoiceItem = class("UIEpEventChoiceItem", UIBaseNode)
local base = UIBaseNode
local ChipData = require("Game.PlayerData.Item.ChipData")
local EpCommonUtil = require("Game.Exploration.Util.EpCommonUtil")
UIEpEventChoiceItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_choiceItem, self, self.OnChoiceItemClick)
end

UIEpEventChoiceItem.InitEventChoiceItem = function(self, choiceData, clickAction, hideGoodsNode)
  -- function num : 0_1
  self.idx = choiceData.idx
  self.choiceId = choiceData.choiceId
  self.catId = choiceData.catId
  self.choiceData = choiceData
  self.cfg = choiceData.cfg
  self.hideGoodsNode = hideGoodsNode
  self.onClickAction = clickAction
end

UIEpEventChoiceItem.RefreshChoiceUI = function(self, displayGetNewData)
  -- function num : 0_2 , upvalues : EpCommonUtil, _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Describe).text = (EpCommonUtil.GetEventReplaceText)(self.cfg, "describe")
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite((self.cfg).icon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

  if not (self.cfg).choice_color or not Color.white then
    ((self.ui).tex_Describe).color = Color.black
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R2 in 'UnsetPending'

    if not (self.cfg).choice_color or not (Color.New)(1, 1, 1, 0.3) then
      ((self.ui).img_IconBg).color = (Color.New)(0, 0, 0, 0.7)
      ;
      ((self.ui).img_Buttom):SetIndex((self.cfg).choice_color and 1 or 0)
      self:__SetChipItem(displayGetNewData)
      if (self.choiceData).isAble ~= nil then
        self:SetItemCanClick((self.choiceData).isAble)
      end
    end
  end
end

UIEpEventChoiceItem.SetItemCanClick = function(self, isAble)
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

UIEpEventChoiceItem.OnChoiceItemClick = function(self)
  -- function num : 0_4
  if self.onClickAction ~= nil then
    (self.onClickAction)(self.cfg, self.idx, self.isAble, self.catId)
  end
end

UIEpEventChoiceItem.__SetChipItem = function(self, displayGetNewData)
  -- function num : 0_5 , upvalues : _ENV, ChipData
  self.chipData = nil
  if displayGetNewData == nil or self.hideGoodsNode then
    return 
  end
  if self.extraItemPool == nil then
    return 
  end
  -- DECOMPILER ERROR at PC27: Unhandled construct in 'MakeBoolean' P1

  if displayGetNewData.type == eEpEvtChoiceGetNewType.item and ConfigData:GetItemType(displayGetNewData.dataId) == eItemType.GlobalChip then
    self.goodsItem = (self.extraItemPool):GetOne()
    ;
    ((self.goodsItem).transform):SetParent(self.transform)
    if displayGetNewData.dataNum > 1 then
      self.chipData = (ChipData.New)(displayGetNewData.dataId, displayGetNewData.dataNum)
    else
      self.chipData = (ChipData.NewChipForLocal)(displayGetNewData.dataId)
    end
    ;
    (self.goodsItem):ShowWithChipData(self.chipData, false)
    ;
    (self.goodsItem):Show()
  end
  if displayGetNewData.type == eEpEvtChoiceGetNewType.expBuff then
    self.goodsItem = (self.extraItemPool):GetOne()
    ;
    ((self.goodsItem).transform):SetParent(self.transform)
    ;
    (self.goodsItem):ShowWithBuffData(displayGetNewData.dataId)
    ;
    (self.goodsItem):Show()
  end
end

UIEpEventChoiceItem.InjectExtraItemPool = function(self, extraItemPool)
  -- function num : 0_6
  self.extraItemPool = extraItemPool
end

UIEpEventChoiceItem.GetAutoTipsHolder = function(self)
  -- function num : 0_7
  return (self.ui).autoTipsHolder
end

UIEpEventChoiceItem.SetParent = function(self, transform)
  -- function num : 0_8
  (self.transform):SetParent(transform)
end

UIEpEventChoiceItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  if self.goodsItem ~= nil then
    (self.goodsItem):OnDelete()
  end
  ;
  (base.OnDelete)(self)
end

return UIEpEventChoiceItem

