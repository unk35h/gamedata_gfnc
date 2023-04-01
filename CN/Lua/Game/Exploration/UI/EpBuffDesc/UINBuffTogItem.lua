-- params : ...
-- function num : 0 , upvalues : _ENV
local eEpBuffDescEnum = require("Game.Exploration.UI.EpBuffDesc.eEpBuffDescEnum")
local eTogsType = eEpBuffDescEnum.TogsType
local UINBuffTogItem = class("UINBuffTogItem", UIBaseNode)
local base = UIBaseNode
UINBuffTogItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tog, self, self._OnTogClick)
  self:_InitTogSwitch()
  self.__selectedIdx = nil
  self.__cancelSelectIdx = nil
end

UINBuffTogItem._SetTogTypeIdx = function(self, eTogType)
  -- function num : 0_1
  self.__selectedIdx = eTogType * 2
  self.__cancelSelectIdx = self.__selectedIdx + 1
  ;
  ((self.ui).textItem_Name):SetIndex(self.__cancelSelectIdx)
end

UINBuffTogItem._InitTogSwitch = function(self)
  -- function num : 0_2 , upvalues : eTogsType
  self.__setTogSwitch = {[eTogsType.All] = function()
    -- function num : 0_2_0 , upvalues : self, eTogsType
    self:_SetTogTypeIdx(eTogsType.All)
  end
, [eTogsType.Positive] = function()
    -- function num : 0_2_1 , upvalues : self, eTogsType
    self:_SetTogTypeIdx(eTogsType.Positive)
  end
, [eTogsType.Neutral] = function()
    -- function num : 0_2_2 , upvalues : self, eTogsType
    self:_SetTogTypeIdx(eTogsType.Neutral)
  end
, [eTogsType.Negative] = function()
    -- function num : 0_2_3 , upvalues : self, eTogsType
    self:_SetTogTypeIdx(eTogsType.Negative)
  end
, [eTogsType.Custom] = function()
    -- function num : 0_2_4 , upvalues : self, eTogsType
    self:_SetTogTypeIdx(eTogsType.Custom)
  end
}
end

UINBuffTogItem.InitBuffTog = function(self, eTogType, clickCallback)
  -- function num : 0_3
  if (self.__setTogSwitch)[eTogType] then
    ((self.__setTogSwitch)[eTogType])()
  end
  self.__eTogType = eTogType
  self.__onClickCallback = clickCallback
end

UINBuffTogItem._OnTogClick = function(self)
  -- function num : 0_4
  if self.__onClickCallback then
    (self.__onClickCallback)(self)
  end
end

UINBuffTogItem.SelectBuffTog = function(self)
  -- function num : 0_5
  ((self.ui).textItem_Name):SetIndex(self.__selectedIdx)
end

UINBuffTogItem.CamcelSelectBuffTog = function(self)
  -- function num : 0_6
  ((self.ui).textItem_Name):SetIndex(self.__cancelSelectIdx)
end

UINBuffTogItem.GetTogType = function(self)
  -- function num : 0_7
  return self.__eTogType
end

UINBuffTogItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  self.__setTogswitch = nil
  ;
  (base.OnDelete)(self)
end

return UINBuffTogItem

