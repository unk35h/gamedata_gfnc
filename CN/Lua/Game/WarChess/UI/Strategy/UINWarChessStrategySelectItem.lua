-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessStrategySelectItem = class("UINWarChessStrategySelectItem", UIBaseNode)
local base = UIBaseNode
UINWarChessStrategySelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.srData = nil
  self.srSubItemId = nil
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_StrategyItem, self, self.__OnClick)
end

UINWarChessStrategySelectItem.InitAsWCStrategySelectItem = function(self, srData, onSelect)
  -- function num : 0_1 , upvalues : _ENV
  self.srData = srData
  self.srSubItemId = nil
  self.onSelect = onSelect
  local srId = (self.srData).srId
  local wcStrategyEffectCfg = (ConfigData.warchess_strategy_effect)[srId]
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_name).text = (LanguageUtil.GetLocaleText)(wcStrategyEffectCfg.name)
  self.des = (LanguageUtil.GetLocaleText)(wcStrategyEffectCfg.describ)
end

UINWarChessStrategySelectItem.InitAsWCStrategySubSelectItem = function(self, data, rewardType, onSelect, index)
  -- function num : 0_2 , upvalues : _ENV
  self.srData = nil
  self.onSelect = onSelect
  self.index = index
  if rewardType ~= 1 or rewardType == 2 then
    local buffData = data
    self.srSubItemId = buffData.id
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite(buffData:GetWCBuffIcon(), CommonAtlasType.ExplorationIcon)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self.ui).tex_name = (LanguageUtil.GetLocaleText)(buffData:GetWCBuffName())
    self.des = (LanguageUtil.GetLocaleText)(buffData:GetWCBuffDes())
  end
end

UINWarChessStrategySelectItem.__OnClick = function(self)
  -- function num : 0_3
  if self.onSelect ~= nil then
    (self.onSelect)(true, self)
  end
end

UINWarChessStrategySelectItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessStrategySelectItem

