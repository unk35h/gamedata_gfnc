-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActivitySeasonBonus = class("UIActivitySeasonBonus", UIBaseWindow)
local base = UIBaseWindow
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local UINCommonActivityBG = require("Game.ActivityFrame.UI.UINCommonActivityBG")
local cs_ResLoader = CS.ResLoader
UIActivitySeasonBonus.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, ConditionListener, UINCommonActivityBG, cs_ResLoader
  self:BindActivitySeasonBtn()
  self:SetActivitySeasonItemClass()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__OnPickedSingleCallback = BindCallback(self, self.__OnPickedSingle)
  self.__OnPickedSingleCycleCallback = BindCallback(self, self.__OnPickedSingleCycle)
  self._goItem = {}
  self._conditionListener = (ConditionListener.New)()
  self._actBgNode = (UINCommonActivityBG.New)()
  ;
  (self._actBgNode):Init((self.ui).uI_CommonActivityBG)
  self._resloader = (cs_ResLoader.Create)()
end

UIActivitySeasonBonus.BindActivitySeasonBtn = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseBouns)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReceiveAll, self, self.OnClickPickedAll)
end

UIActivitySeasonBonus.SetActivitySeasonItemClass = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._itemClass = require("Game.ActivitySeason.UI.UINActivitySeasonBonusItem")
  self._cycleClass = require("Game.ActivitySeason.UI.UINActivitySeasonBonusCycleItem")
  self._emetyElement = require("Game.ActivityHallowmas.UI.Bouns.UINHalloweenBounsItemEmptyElement")
end

UIActivitySeasonBonus.InitActivitySeasonBouns = function(self, activitySeasonData)
  -- function num : 0_3
  self._data = activitySeasonData
  self:__InitFixed()
  self:__Refresh()
  ;
  (self._actBgNode):InitActivityBG((self._data):GetActFrameId(), self._resloader)
end

UIActivitySeasonBonus.RefreshActivitySeasonBouns = function(self)
  -- function num : 0_4
  self:__Refresh()
end

UIActivitySeasonBonus.SetCloseCallback = function(self, closeCallback)
  -- function num : 0_5
  self._closeCallback = closeCallback
end

UIActivitySeasonBonus.__InitFixed = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local itemId = (self._data):GetSeasonTokenItemId()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenName).text = ConfigData:GetItemName(itemId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Token).sprite = CRH:GetSpriteByItemId(itemId)
  local itemCfg = (ConfigData.item)[itemId]
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(itemCfg.describe)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).totalCount = (self._data):GetSeasonRewardLvLimit() + 1
  local targetIndex = (self._data):GetSeasonRewardCurLv()
  for i = 1, targetIndex do
    if (self._data):IsSeasonRewardLevelCanPick(i) then
      targetIndex = i
      break
    end
  end
  do
    ;
    ((self.ui).scroll):RefillCells(targetIndex - 1, 200)
    ;
    ((self.ui).scroll):SrollToCell(targetIndex - 1, 9999)
  end
end

UIActivitySeasonBonus.__Refresh = function(self)
  -- function num : 0_7 , upvalues : _ENV
  ((self.ui).tex_TokenNum):SetIndex(0, tostring((self._data):GetSeasonRewardAllExp()))
  ;
  ((self.ui).tex_Lvl):SetIndex(0, tostring((self._data):GetSeasonRewardCurLv()))
  local tempExp = (self._data):GetSeasonRewardCurExp() % (self._data):GetSeasonRewardCurExpLimit()
  local remainExp = (self._data):GetSeasonRewardCurExpLimit() - tempExp
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Exp).text = tostring(remainExp)
  for k,v in pairs(self._goItem) do
    v:RefreshBounsElement()
  end
  self:__RefreshAllGet()
end

UIActivitySeasonBonus.__RefreshAllGet = function(self)
  -- function num : 0_8
  local hasCanRecive = (self._data):HasSeasonRewardExpCanReceive()
  ;
  (((self.ui).img_Mask).gameObject):SetActive(not hasCanRecive)
end

UIActivitySeasonBonus.__OnInstantiateItem = function(self, go)
  -- function num : 0_9
  local item = ((self._emetyElement).New)()
  item:Init(go)
  item:BindHalloweenBounsItemClass(self._itemClass, self._cycleClass)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._goItem)[go] = item
end

UIActivitySeasonBonus.__OnChangeItem = function(self, go, index)
  -- function num : 0_10
  local item = (self._goItem)[go]
  local level = index + 1
  if (self._data):GetSeasonRewardLvLimit() < level then
    item:InitBounsCycleItem(self._data, self.__OnPickedSingleCycleCallback)
  else
    item:InitBounsItem(self._data, level, self.__OnPickedSingleCallback)
  end
end

UIActivitySeasonBonus.__OnPickedSingle = function(self, level, item)
  -- function num : 0_11
  (self._data):ReqSeasonRewardExpReceive(level)
end

UIActivitySeasonBonus.__OnPickedSingleCycle = function(self)
  -- function num : 0_12
  (self._data):ReqSeasonRewardExpCycle()
end

UIActivitySeasonBonus.OnClickPickedAll = function(self)
  -- function num : 0_13
  if not (self._data):HasSeasonRewardExpCanReceive() then
    return 
  end
  ;
  (self._data):ReqSeasonRewardAllExp()
end

UIActivitySeasonBonus.OnClickCloseBouns = function(self)
  -- function num : 0_14 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIActivitySeasonBonus.OnCloseBouns = function(self, tohome)
  -- function num : 0_15
  self:Delete()
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

UIActivitySeasonBonus.OnDelete = function(self)
  -- function num : 0_16 , upvalues : base
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  ;
  (self._conditionListener):Delete()
  ;
  (base.OnDelete)(self)
end

return UIActivitySeasonBonus

