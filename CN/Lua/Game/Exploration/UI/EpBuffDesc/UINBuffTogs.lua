-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBuffTogs = class("UINBuffTogs", UIBaseNode)
local base = UIBaseNode
local eEpBuffDescEnum = require("Game.Exploration.UI.EpBuffDesc.eEpBuffDescEnum")
local eTogsType = eEpBuffDescEnum.TogsType
local UINBuffTogItem = require("Game.Exploration.UI.EpBuffDesc.UINBuffTogItem")
UINBuffTogs.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBuffTogItem, eTogsType
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._onTogChange = BindCallback(self, self._OnTogChange)
  self.__togItemPool = (UIItemPool.New)(UINBuffTogItem, (self.ui).obj_togItem)
  ;
  ((self.ui).obj_togItem):SetActive(false)
  self.__pageTogs = {}
  self:AddTog(eTogsType.All)
  self:AddTog(eTogsType.Positive)
  self:AddTog(eTogsType.Neutral)
  self:AddTog(eTogsType.Negative)
  self.__firstTogType = eTogsType.All
end

UINBuffTogs.OnShow = function(self)
  -- function num : 0_1
  local defultTog = (self.__pageTogs)[self.__firstTogType]
  self:_OnTogChange(defultTog)
end

UINBuffTogs.AddTog = function(self, TogType)
  -- function num : 0_2
  if not (self.__pageTogs)[TogType] then
    local addTog = (self.__togItemPool):GetOne()
    addTog:InitBuffTog(TogType, self._onTogChange)
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__pageTogs)[TogType] = addTog
  end
end

UINBuffTogs._OnTogChange = function(self, togItem)
  -- function num : 0_3 , upvalues : _ENV
  if togItem == self.__curTog then
    return 
  end
  if self.__curTog then
    (self.__curTog):CamcelSelectBuffTog()
  end
  local epBuffDescWin = UIManager:GetWindow(UIWindowTypeID.EpBuffDesc)
  epBuffDescWin:RefershDescriptPageEpBuff(togItem:GetTogType())
  togItem:SelectBuffTog()
  self.__curTog = togItem
end

UINBuffTogs.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.__togItemPool):DeleteAll()
  self.__pageTogs = nil
  ;
  (base.OnDelete)(self)
end

return UINBuffTogs

